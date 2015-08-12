/*******************************************************************************************************************
* Apex Class Name  : UpdateOneCRM
* Version          : 1.0 
* Created Date     : 07 June 2015
* Function         : Web service class used for input operations
* Modification Log :
*
* Developer                   Date                    Description
* ------------------------------------------------------------------------------------------------------------------
* Davi Borges               07/06/2015              Created Initial Version of AccountContactSyncTestClass
*******************************************************************************************************************/

global class UpdateOneCRM 
{
  
/*************************************************************************************************************
  * @Name        : reportTransaction
  * @Description : Used to receive update about integration request sent to ESB 
  * 
  * @Todo        : This method need to merge with is R1 counterpart
  * @Input       : request information about the integration request to be updated
  * @Output      : true if the operation was successfully  executed
  *************************************************************************************************************/
  
  webservice static Boolean reportTransaction(IntegrationTransaction request)
  {    
    
    //Retreive Integration Request

    Integration_Request__c integrationRequest =
          IntegrationFrameworkUtilities.retreiveIntegrationRequest(request.integrationRequestId);

    //Validate if the integration request was found, otherwise returns a SOAP Fault (via Exception)

    if(integrationRequest == null)
    {
      String errorMessage= 'Cloud not find Integration Request:[' + request.integrationRequestId + ']';
      System.debug(errorMessage);   
      throw new UpdateOneCRMException('2|' + errorMessage);
    }

    Boolean isValidExternalSystem = false;

    try
    {
      isValidExternalSystem = IntegrationFrameworkUtilities.validExternalSystem(integrationRequest, request.externalSystem);
    
    }catch(Exception ex)
    {
      throw new UpdateOneCRMException('-1|' + ex.getMessage());
    }

      
    if(request.status != 'Received' && ! isValidExternalSystem)
    {
      String errorMessage= 'Invalid external system name:[' + request.externalSystem + ']';
      System.debug(errorMessage);
      throw new UpdateOneCRMException('1|' + errorMessage);
    }

    Set<String> status = IntegrationFrameworkUtilities.retreiveListOfStatus();
    
    if( ! IntegrationFrameworkUtilities.retreiveListOfStatus().contains(request.status))
    {

       throw new UpdateOneCRMException('3 | Invalid Status' );

    }

    if(request.externalSystem == null || request.externalSystem =='')
    {
            integrationRequest.Status__c = request.status;
            
            update integrationRequest;

            return true;

    }

    Boolean found = false;

    for(System_Response__c response : integrationRequest.System_Responses__r)
    {
        if(response.External_System__c == request.externalSystem)
        {
            found = true;
            
            response.Error_Code__c = request.errorCode;
            response.Error_Message__c = request.errorMessage;
            response.Status__c = request.status;

            update response;

        }

    }

    if(!found)
    {
        System_Response__c response = new System_Response__c
            (External_System__c = request.externalSystem,
                Error_Code__c = request.errorCode, 
                Error_Message__c = request.errorMessage, 
                Status__c = request.status,
                Integration_Request__c = integrationRequest.Id
            );

        insert response;
     
    }

    integrationRequest.check_responses__c = true;

    update integrationRequest;

    return true;
      
  }


  webservice static Boolean updateExternalReference(UpdateRequest request)
  {
    // validate the parameters
    UpdateOneCRMResult result = new UpdateOneCRMResult();
    result.errorCode = 0;
    result.errorMessage ='';
    
    if(request.externalSystem != System.Label.EVision)
    {
      String errorMessage= 'Invalid external system name:[' + request.externalSystem + ']';
      System.debug(errorMessage);
      result.errorCode = 1;
      result.errorMessage = errorMessage;
      throw new UpdateOneCRMException(result.errorCode + '|' + errorMessage);
    }
        
    if(request.externalKeyName != System.Label.Learner_ID &&
       request.externalKeyName != System.Label.Application_ID)
    {
      String errorMessage= 'Invalid external external key name:[' + request.externalKeyName + ']';
      System.debug(errorMessage);
      result.errorCode = 1;
      result.errorMessage = errorMessage;
      throw new UpdateOneCRMException(result.errorCode + '|' + errorMessage);
    }
    
    // get the integration request object        
    List<Integration_Request__c> integrationRequests = [SELECT Object_Id__c FROM Integration_Request__c WHERE Id = :request.integrationRequestId];
    Integration_Request__c integrationRequest = null;
    if(!integrationRequests.isEmpty())
    {
      integrationRequest = integrationRequests.get(0);
    }
        
    // if we have an integration request get the opportunity object
    if(integrationRequest != null)
    {
      List<Opportunity> opportunities = [SELECT External_Opportunity_Number__c, AccountId, Account.Id  FROM Opportunity WHERE Id = :integrationRequest.Object_Id__c];
      Opportunity opp = null;
      if(!opportunities.isEmpty())
      {
        opp = opportunities.get(0);
      }
      if(opp != null)
      {
        // if we are processing the Application ID key name update the 
        // External_Opportunity_Number__c and update the object
        if(request.externalKeyName == System.Label.Application_ID)
        {        
          opp.External_Id__c = request.externalKeyValue;
          update opp;
        }
        else if(request.externalKeyName == System.Label.Learner_ID)
        {
          // if we are processing the Learner ID key name update the account correlation
          // if it exists or create a new one if it doesnt exist
          List<Account_Correlation__c> accountCorrelations = [SELECT External_ID_Name__c,External_ID__c,External_System__c 
                                                             FROM Account_Correlation__c WHERE Account__c =: opp.Account.Id AND External_ID_Name__c = 'eVision Learner Number' LIMIT 1];

          if(accountCorrelations != null && !accountCorrelations.isEmpty())
          {
            accountCorrelations.get(0).External_ID__c = request.externalKeyValue;
            update accountCorrelations.get(0);            
          }
          else
          {
            // create a new account correlation
            Account_Correlation__c ac = new Account_Correlation__c(Account__c = opp.Account.Id, 
                                                                  External_ID__c = request.externalKeyValue, 
                                                                  External_ID_Name__c='eVision Learner Number',
                                                                  External_System__c = System.Label.EVision, 
                                                                  Market__c = 'ZA');
           insert ac;      
          }
        }
      }
      else
      {
        return false;
      } 
    }
    else
    {
      return false;
    }
        
    // updates or inserts performed - return true
    return true;
  }

  webservice static Boolean updateOrderLineItem(List<OrderLineItem> item)
  {
    UpdateOneCRMResult result = new UpdateOneCRMResult();
    result.errorCode = 0;
    result.errorMessage ='';
    
    List<OrderItem> updatedOrderLineItems = new List<OrderItem>();
    
    Map<String, Map<String,OrderLineItem>> orderMapItem = new  Map<String, Map<String,OrderLineItem>>();
    
    Map<Id,OrderLineItem> orderIdMapItem = new  Map<Id, OrderLineItem>();
    
    for(OrderLineItem oli : item){
     	analyseInputOrderLineItem(oli,orderIdMapItem,orderMapItem);       
    }
    
    List<Order> orders = new List<Order>();
    List<OrderItem> orderItems = new List<OrderItem>();
    
    if(orderMapItem.size() >0){
    	orders = [SELECT OrderNumber,(SELECT OrderItemNumber,Item_Number__c , Status__c FROM OrderItems) 
                  FROM Order WHERE OrderNumber IN : orderMapItem.keySet()];
    }
    
    System.debug('key set is ' + orderIdMapItem.keySet());
    
    if(orderIdMapItem.size() >0){
    	orderItems = [SELECT OrderItemNumber, Item_Number__c  , Status__c 
                      FROM OrderItem WHERE Id IN : orderIdMapItem.keySet()];    
    }
    
    
    for(Order ord: orders){
    	
      Map<String,OrderLineItem> mapItems = orderMapItem.get(ord.OrderNumber);
    	
    	for(OrderItem ordItem: ord.OrderItems){
    		
        if(mapItems.containsKey(String.ValueOf(ordItem.Item_Number__c))){

    			OrderLineItem oli = mapItems.get(String.ValueOf(ordItem.Item_Number__c));
    		
    			Boolean changed = checkForOrderLineItemChanges(oli,ordItem) ;
			      
		      	if(changed){
		      		updatedOrderLineItems.add(ordItem);
		     	  }
    			
    		}
    	}
    }	
	
	for(OrderItem ordItem: orderItems){
		
    OrderLineItem oli = orderIdMapItem.get(ordItem.Id);
		
		Boolean changed = checkForOrderLineItemChanges(oli,ordItem) ;
	      
    if(changed){
      		updatedOrderLineItems.add(ordItem);
    }	
	}   	
        
    if(!updatedOrderLineItems.isEmpty())
    {
      update updatedOrderLineItems;
      return true;
    }
    return false;
  }
  
  private static Boolean checkForOrderLineItemChanges(OrderLineItem oli, OrderItem ordItem)
  {
  	  // used to work out if we need to update the object
      boolean changed = false;  
    
      // do we need to update the status                      
	  if(!String.isBlank(oli.status))
	  {
	  	ordItem.Status__c = oli.status;
	  	
	  	//clean the status reason every time the status is changed 
	  	ordItem.StatusReason__c = '';     	
	    changed = true;
	  }
      
      // do we need to update the status reason
      if(!String.isBlank(oli.statusReason))
      {
      	ordItem.StatusReason__c = oli.statusReason;
      	changed = true;      	
      }
      
      // do we need to update the queantity
      if(oli.quantity > 0 )
      {
      	ordItem.Quantity = oli.quantity;
        changed = true;
      } 

	    // do we need to update the queantity
	    if(!String.isBlank(oli.externalOrderNumber))
	    {
	      ordItem.ERP_Order_Number__c = oli.externalOrderNumber;
	      changed = true;
	    }       
     
      // if we have a shipped object get the product and update the order line item
      if(oli.shipped != null && oli.shipped.isbn13 != null)
      {
      	List<Product2> prod = [SELECT Id FROM product2 where ISBN__c = :oli.shipped.isbn13 LIMIT 1];
      	if(prod.isEmpty())
      	{
      	  String errorMessage= 'Product doesnt exist for :[' + oli.shipped.isbn13 + ']';
          System.debug(errorMessage);
          throw new UpdateOneCRMException('1|' + errorMessage);  	
      	}
      	ordItem.Shipped_Product__c = prod.get(0).id;    	
        changed = true;      
      }
      
      return changed;
  }
  
  private static void analyseInputOrderLineItem(OrderLineItem oli,Map<Id,OrderLineItem> olisById ,Map<String, Map<String,OrderLineItem>> olisByNumber)
  {  	 
  	 // perform some validation on the input parameters;
      if(oli.id == null && (String.isBlank(oli.itemNumber) || String.isBlank(oli.orderNumber)))
      {
        String errorMessage= 'Invalid Ids were provided';
        System.debug(errorMessage);
        throw new UpdateOneCRMException('2|' + errorMessage);
      }
      
      if(oli.id != null)
      {
      	olisById.put(oli.id, oli);
      	return;
      }
      
      Map<String,OrderLineItem> mapItems = null;
      
      if(!olisByNumber.containsKey(oli.orderNumber))
      {
       	mapItems =  new Map<String,OrderLineItem>();
      	olisByNumber.put(oli.orderNumber, mapItems);
      	
      }else
      {
      	mapItems = olisByNumber.get(oli.orderNumber);
      }
      
      if(!mapItems.containsKey(oli.itemNumber))
      {
       	mapItems.put(oli.itemNumber,oli);
      }
  }

  global class IntegrationTransaction
  {
    webservice Id integrationRequestId;
    webservice String status;
    webservice String externalSystem;
    webservice String errorCode;
    webservice String errorMessage;
  }

  global class UpdateRequest
  {
    webservice Id integrationRequestId;
    webservice String externalSystem;
    webservice String externalKeyValue;
    webservice String externalKeyName;
  }

  global class OrderLineItem
  {
    webservice Id id;
    webservice Id orderId;
    webservice String itemNumber;
    webservice String orderNumber;
    webservice String status; //
    webservice String statusReason;
    webservice Integer quantity;
    webservice String externalOrderNumber;
    webservice INT_BookProduct shipped;
  }

  global class UpdateOneCRMResult
  {
    webService Integer errorCode;
    webService String errorMessage;
  }
    
  public class UpdateOneCRMException extends Exception 
  {
  }
}