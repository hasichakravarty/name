/*******************************************************************************************************************
* Apex Class Name  : UpdateOneCRM
* Version          : 1.1 
* Created Date     : 26 July 2015
* Function         : Web service class used for input operations
* Modification Log :
*
* Developer                   Date                    Description
* ------------------------------------------------------------------------------------------------------------------
* Davi Borges               26/06/2015              Initial documentation of the class. Introduction of mapping for Lob
*******************************************************************************************************************/

public without sharing class PS_INT_IntegrationRequestController 
{
  public static void submissionValidation(List<Opportunity> opps, Map<Id,Opportunity> oldOpportunities)
  {
    String errorMessage = 'Error Messages: ';
    Bypass_Settings__c bypass = Bypass_Settings__c.getInstance();
    // get all the OpportunityContactRoles we need
    Map<Id,List<OpportunityContactRole>> oppToRole = new Map<Id,List<OpportunityContactRole>>();
    List<OpportunityContactRole> allOppConRoles = [SELECT Id, OpportunityId, Role, ContactId, Contact.National_Identity_Number__c, Contact.Name, 
                                                   Contact.Passport_Number__c, Contact.MobilePhone, Contact.Phone, Contact.Home_Phone__c
                                                   FROM OpportunityContactRole WHERE OpportunityId IN :opps]; 
    for(OpportunityContactRole role : allOppConRoles)
    {
      System.debug('In loop for all roles' + role.OpportunityId + ' ' + role.Role);
      // it the list for the opportunity is present get it and add the role
      if(oppToRole.containsKey(role.OpportunityId))
      {
        System.debug('In map' + role.OpportunityId);
        List<OpportunityContactRole> ocr = oppToRole.get(role.OpportunityId);
        ocr.add(role);  
      } 
      else
      {
        // otherwise create it
        System.debug('Not in map' + role.OpportunityId);
        List<OpportunityContactRole> ocr = new List<OpportunityContactRole>();
        ocr.add(role);
        oppToRole.put(role.OpportunityId, ocr);
      }
    }
    
    Map<ID, Opportunity> opportunityMap = new Map<ID, Opportunity>([SELECT Qualification_Campus__r.Id, 
                                                                           (SELECT OwnerId FROM Apttus_Proposal__R00N70000001yUfDEAU__r) 
                                                                    FROM Opportunity  
                                                                    WHERE Id IN :opps]);
    
    if(!bypass.Disable_Integration_Requests__c)
    {     
      
      Map<Id,Boolean> oppsRegistered = verifyOpportunityWasRegistered(opps);
              
      for(Opportunity opp : opps)
      {
        
        // retrives the previous state of the opportunity
        Opportunity oldOpportunity = oldOpportunities.get(opp.Id);
        
          // Enroll Student
        if((opp.Type == 'New Business' || opp.Type == 'Returning Business') && opp.StageName =='Closed')
        {            
          // check fields present for enroll student 
          
          // validates with the Enronlment was performed 
          if(opp.Academic_Vetting_Status__c !='Vetted - Approved')
          {
            errorMessage += 'An Opportunity can only be enrolled if it has been academically vetted';
          }

          if(opp.Academic_Vetting_Status__c =='Vetted - Approved' &&  oldOpportunity.Academic_Vetting_Status__c !='Vetted - Approved')
          {
            errorMessage += 'An Opportunity cannot be enrolled and academically vetted at the same time';
          }
          
          
        } 
        // Modify Contract
        else if (opp.Type == 'Amendment'  && opp.StageName =='Closed')
        {
          // validates with the Enronlment was performed 
          if(opp.Academic_Vetting_Status__c !='Vetted - Approved')
          {
            errorMessage += 'An Opportunity can only be enrolled if it has been academically vetted';
          }

          if(opp.Academic_Vetting_Status__c =='Vetted - Approved' &&  oldOpportunity.Academic_Vetting_Status__c !='Vetted - Approved')
          {
            errorMessage += 'An Opportunity cannot be enrolled and academically vetted at the same time';
          }
        }
        // Application Cancelled
        else if(opp.Academic_Vetting_Status__c =='Vetted - Approved' && opp.StageName =='Lost')
        {
          // check fields present for application cancelled
        }
        // Student Vetted
        else if(opp.Academic_Vetting_Status__c =='Vetted - Approved' )
        {
           if(oppsRegistered.containsKey(opp.Id) && ! oppsRegistered.get(opp.Id))
          {
            errorMessage += 'A new business Opportunity cannot be academically vetted if it has not been registered';
          }
            /*for(OpportunityContactRole ocr : opp.OpportunityContactRoles)
            {
                if(ocr.Contact.National_Identity_Number__c == null && ocr.Contact.Passport_Number__c == null)
            {
              errorMessage += 'Either National Identity Number or Passport Number is required';
            }
            if(ocr.Contact.FirstName == null)
            {
              errorMessage += 'First name is required';
            }
            if(ocr.Contact.LastName == null)
            {
              errorMessage += 'Last name is required';
            }
            if(ocr.Contact.Gender__c == null)
            {
              errorMessage += 'Gender is required';
            }
            
            if(ocr.role == 'Student')
            {
              if(ocr.Contact.Marital_Status__c == null)
              {
                errorMessage += 'Marital status is required';
              }
              if(ocr.Contact.Birthdate__c == null)
              {
                errorMessage += 'Birth date is required';
              }
              if(ocr.Contact.First_Language__c == null)
              {
                errorMessage += 'First language is required';
              }
              if(ocr.Contact.Ethnic_Origin__c == null)
              {
                errorMessage += 'Ethnic origin is required';
              }
              
                }
                else if(ocr.role == 'Sponsor')
                {
                  
                }               
            }
            if(opp.Campus__c == null)
            {
                errorMessage += 'Campus is required;';              
            }*/
        }
        // Register Student
        else if((opp.Type == 'New Business' || opp.Type == 'Returning Business') && opp.StageName =='Negotiation')
        {
          // check fields present for register student
          // based on the details in the drop task
          System.debug('Register Student validation');
          // must have a passport number of national id
          
          //for(OpportunityContactRole ocr : opp.OpportunityContactRoles)
          List<OpportunityContactRole> ocrs = oppToRole.get(opp.Id);
          //Added to fix contact role issue
          if(ocrs == null || ocrs.size()==0){
             errorMessage += 'Opportunity should have a valid contact mapped to it , kindly complete all the nessacary steps and proceed further';

          }
         //End of Contact Role Issue fix
         
         if(ocrs != null) 
         {
          for(OpportunityContactRole ocr : ocrs)
          {
            if(ocr.Contact==null){
                     errorMessage += 'Contact Role Should have a valid Contact mapped to it';

              }
              else{
            System.debug('in loop for roles ' + ocr.role);
            if(ocr.role == 'Business User' || ocr.role == 'Primary Sales Contact')
            {
            if(String.isBlank(ocr.Contact.National_Identity_Number__c) && String.isBlank(ocr.Contact.Passport_Number__c))
            {
              errorMessage += ' Either National Identity Number or Passport Number is required for contact ' + ocr.Contact.Name + ': ';
            }
            else if(!String.isBlank(ocr.Contact.National_Identity_Number__c))
              {
                // if the national id is present it must be 13 chanracters
                if(ocr.Contact.National_Identity_Number__c.length() != 13)
                {
                  errorMessage += 'National Identity Number must be 13 characters for contact ' + ocr.Contact.Name + ': ';    
                }
              }
              if(String.isBlank(ocr.Contact.MobilePhone) && String.isBlank(ocr.Contact.Home_Phone__c))
              {
                errorMessage += 'A home telephone or mobile telephone number must be supplied for contact ' + ocr.Contact.Name + ': ';
              }
              
              /*if(String.isBlank(ocr.Contact.MobilePhone) && 
                 String.isBlank(ocr.Contact.Phone)       &&
                 String.isBlank(ocr.Contact.Home_Phone__c))
              {
                 errorMessage += 'A home telephone number must be supplied for contact ' + ocr.Contact.Name + ': ';  
              } */  
            }
            }
           }
          }
          // must have a proposal  
          Opportunity op = opportunityMap.get(opp.Id);
          if(op != null)
          {
            System.debug('Proposal size is ' + op.Apttus_Proposal__R00N70000001yUfDEAU__r.size());
            if(op.Apttus_Proposal__R00N70000001yUfDEAU__r.size() <= 0)
            {
                errorMessage += 'A proposal is required: '; 
            } 
            
            if(op.Qualification_Campus__r.Id == null)
            {
                errorMessage += 'A primary proposal synchronised with the opportunity is required: '; 
            }
          }               
        }
        if(!errorMessage.equals('Error Messages: '))
        {
          opp.addError(errorMessage);
        }
      }       
    }       
  }
    
  public static void submissionValidation(List<Case> cases)
  {
    String errorMessage = 'Error Messages: ';
    Bypass_Settings__c bypass = Bypass_Settings__c.getInstance();
    if(!bypass.Disable_Integration_Requests__c)
    {
      
      Map<Id,Schema.RecordTypeInfo> caseRecTypesById = Case.SObjectType.getDescribe().getRecordTypeInfosById();

    
      for(Case c : cases)
      {
        String recType = caseRecTypesById.get(c.RecordTypeId).getName(); 
        // Application Cancelled
        if(recType == 'Cancellation Request' && c.Status == 'Closed')
        {
          // check fields present for application cancelled
        }
        // Change to Financially Responsible Contact
        else if(recType == 'Change Request' && c.Type == 'Change Sponsor' && c.Status == 'Closed')
        {
          // check fields present for change to financially responsible contact
        }
        // Change Of Campus
        else if(recType == 'Change Request' && c.Type == 'Change Campus' && c.Status == 'Closed')
        {
        // check fields present for change of campus
        }
      }
    }
  }


    public static void createIntegrationRequestOpp(List<Opportunity> opps, Map<Id, SObject> oldopps)
    {

        List<Integration_Request__c> notification = new List<Integration_Request__c>();

         //validation that don't pass the validation to check for duplicates
        List<Integration_Request__c> notificationBypass = new List<Integration_Request__c>();

        //Retreive Opportunity Line Item

        Map<Id, Opportunity> items =  new Map<Id, Opportunity>([SELECT Id, Name,
        		(SELECT Id FROM OpportunityLineItems WHERE (Amendment_Action__c = 'Deferred' OR Amendment_Action__c ='Retake')) 
        		 FROM Opportunity WHERE Id IN : oldopps.KeySet()]);

        for(Opportunity opp : opps)
        {
        
            if((opp.Type == 'New Business' || opp.Type == 'Returning Business') && opp.StageName =='Closed' && ((Opportunity)oldopps.get(opp.Id)).StageName !='Closed' )
            {

                notification.add(createOutboundIntetgrationRequest(opp.Id, 'Opportunity', 'Enrol Student', null, opp.Market__c, opp.Geography__c,opp.Line_of_Business__c));

            } else if (opp.Type == 'Amendment'  && opp.StageName =='Closed' && ((Opportunity)oldopps.get(opp.Id)).StageName !='Closed' )
            {
				if(items.get(opp.Id).OpportunityLineItems != null && items.get(opp.Id).OpportunityLineItems.size() >0 )
				{
					notification.add(createOutboundIntetgrationRequest(opp.Id, 'Opportunity', 'Modify Contract', 'Retake Module', opp.Market__c, opp.Geography__c,opp.Line_of_Business__c));
				}else
				{

					notification.add(createOutboundIntetgrationRequest(opp.Id, 'Opportunity', 'Modify Contract', 'Change Module Choice', opp.Market__c, opp.Geography__c,opp.Line_of_Business__c));
                
           	    }

            }else if(opp.Academic_Vetting_Status__c =='Vetted - Approved' && opp.StageName =='Lost' && opp.Type == 'New Business')
            {
                notification.add(createOutboundIntetgrationRequest(opp.Id, 'Opportunity', 'Application Cancelled', null, opp.Market__c, opp.Geography__c,opp.Line_of_Business__c));
            }else if(opp.Academic_Vetting_Status__c =='Vetted - Approved' && (opp.Type == 'New Business' || opp.Type == 'Returning Business') && ((Opportunity)oldopps.get(opp.Id)).Academic_Vetting_Status__c !='Vetted - Approved' )
            {
                System.debug('Vetting Event Triggered!');
                notificationBypass.add(createOutboundIntetgrationRequest(opp.Id, 'Opportunity', 'Student Vetted', null, opp.Market__c, opp.Geography__c,opp.Line_of_Business__c));
            }
            else if(opp.Type == 'New Business'  && opp.StageName =='Negotiation')
            {
                notification.add(createOutboundIntetgrationRequest(opp.Id, 'Opportunity', 'Register Student', null,  opp.Market__c, opp.Geography__c,opp.Line_of_Business__c));
            }else
            {
                System.debug('--> No Integration Request for Opportunity:' + opp.Id);
            }
            

        }
        

        if(notification.size() >0)
        {
            notification = fielterExistingEvent (notification);
            
            System.debug('Before ByPass-->' + notification.size());
        
            System.debug(notification);
        }
        
        if(notificationBypass.size() >0)
        {
            	System.debug('Adding ByPass');
            	notification.addAll(notificationBypass);
        }

        if(notification.size() >0)
        {
            insert notification;
        }
        
    }

    public static void createIntegrationRequestCase(List<Case> cases)
    {
        List<Integration_Request__c> notification = new List<Integration_Request__c>();

        //validation that don't pass the validation to check for duplicates
        List<Integration_Request__c> notificationBypass = new List<Integration_Request__c>();

        List<RecordType> recs = [SELECT Id, Name FROM RecordType WHERE SobjectType = 'Case'];

        Map<Id,String> recsType = new Map<Id,String>();

        for(RecordType rec: recs )
        {
            recsType.put(rec.Id, rec.Name);
        }


        for(Case c : cases)
        {
            String recType = recsType.get(c.RecordTypeId);

            if(recType == 'Cancellation Request' && c.Status == 'Closed')
            {
                notification.add(createOutboundIntetgrationRequest(c.Id, 'Case', 'Contract Cancelled', null, c.Market__c, c.Geography__c,c.Line_of_Business__c));
            }else if(recType == 'Change Request' && c.Type == 'Change Sponsor' && c.Status == 'Closed')
            {
                notification.add(createOutboundIntetgrationRequest(c.Id, 'Case', 'Change to Financially Responsible Contact', null,c.Market__c, c.Geography__c,c.Line_of_Business__c));
            }else if(recType == 'Change Request' && c.Type == 'Change Campus' && c.Status == 'Closed')
            {
                notification.add(createOutboundIntetgrationRequest(c.Id, 'Case', 'Change of Campus', null,c.Market__c, c.Geography__c,c.Line_of_Business__c));
            }

        }

        if(notification.size() >0)
        {
            notification = fielterExistingEvent (notification);

            System.debug(notification);

            if(notification.size() >0)
            {
                insert notification;
            }
        }

    }
    
    /*************************************************************************************************************
  * @Name        : createIntegrationRequestOrder
  * @Description : Method use to create Order Related Integration Request
  * 
  * @Todo        : Implment functionality to retreive Market, Lob and Geo from the Order
  * @Input       : New and the old list of Orders, this method is to be used in the context of a trigger
  * @Output      : N/A
  ***************************************************************************************************************/
    public static void createIntegrationRequestOrder(List<Order> orders, Map<Id, SObject> oldObjects)
    {
        List<Integration_Request__c> notification = new List<Integration_Request__c>();

        //validation that don't pass the validation to check for duplicates
        List<Integration_Request__c> notificationBypass = new List<Integration_Request__c>();

        for(Order inOrder : orders)
        {      
            if(inOrder.Status == 'Open')
            {
                notification.add(createOutboundIntetgrationRequest(inOrder.Id, 'Order', 'New Order', null, 'US','North America','HE'));
            }
        }

        if(notification.size() >0)
        {
            notification = fielterExistingEvent (notification);

            System.debug(notification);

            if(notification.size() >0)
            {
                insert notification;
            }
        }

    }
    
  /*************************************************************************************************************
  * @Name        : createIntegrationRequestOrderLine
  * @Description : Method use to create OrderItem Related Integration Requests
  * 
  * @Todo        : Implment functionality to retreive Market, Lob and Geo from the Order
  * @Input       : New and the old list of Orders, this method is to be used in the context of a trigger
  * @Output      : N/A
  ***************************************************************************************************************/
     public static void createIntegrationRequestOrderLine(List<OrderItem> orderItems, Map<Id, SObject> oldObjects)
    {
        List<Integration_Request__c> notification = new List<Integration_Request__c>();

		///Map<Id, OrderItem> oldOli = (Map<Id, OrderItem>) oldObjects;

        //validation that don't pass the validation to check for duplicates
        List<Integration_Request__c> notificationBypass = new List<Integration_Request__c>();

        for(OrderItem item : orderItems)
        {      
        	OrderItem oldoli = (OrderItem)oldObjects.get(item.id);
            if(item.Status__c == 'Cancelled' && oldoli.Status__c != 'Cancelled')
            {
                notification.add(createOutboundIntetgrationRequest(item.Id, 'Order Line Item', 'Modify Order Line Item', 'Cancellation','US','North America','HE'));
            }else if (item.Status__c == 'Approved' && oldoli.Status__c != 'Approved')
            {
            	 notification.add(createOutboundIntetgrationRequest(item.Id, 'Order Line Item', 'Modify Order Line Item', 'Approval','US','North America','HE'));
            }
        }

        if(notification.size() >0)
        {
            notification = fielterExistingEvent (notification);

            System.debug(notification);

            if(notification.size() >0)
            {
                insert notification;
            }
        }

    }
       
    static List<Integration_Request__c> fielterExistingEvent(List<Integration_Request__c> requests)
    {
        
        Set<Id> objIds = listofObject(requests);

        List<Integration_Request__c> duplicate = new List<Integration_Request__c>();

        List<Integration_Request__c> output = new List<Integration_Request__c>();

        List<Integration_Request__c> existingReqs = [SELECT Id, Object_Id__c, Event__c, Sub_Event__c FROM Integration_Request__c WHERE Object_Id__c in :objIds];

        if(existingReqs == null || existingReqs.size() == 0) return requests;
        

        for(Integration_Request__c reqIn : requests)
        {
            for( Integration_Request__c reqExt : existingReqs)
            {

                if(reqIn.Object_Id__c == reqExt.Object_Id__c &&  reqIn.Event__c == reqExt.Event__c  &&  reqIn.Sub_Event__c == reqExt.Sub_Event__c )
                {
                    duplicate.add(reqIn);
                }

            }       
        }

        if(duplicate.isEmpty())
        {
            return requests;
        }else
        {
            Map<Id, Integration_Request__c> reqsmap = ListToMap(duplicate);

            for(Integration_Request__c r: requests)
            {
                if(!reqsmap.containsKey(r.Id)) output.add(r);
            }
        }

        return output;

    }

    static Map<Id, Integration_Request__c> listToMap(List<Integration_Request__c> requests)
    {

        Map<Id, Integration_Request__c> output =  new Map<Id, Integration_Request__c>();

        for(Integration_Request__c req :requests)
        {
            output.put(req.Id, req);
        }

        return output;

    }

    static Set<Id> listofObject(List<Integration_Request__c> requests)
    {

        Set<Id> output =  new Set<Id>();

        for(Integration_Request__c req :requests)
        {
            if(!output.contains(req.Object_Id__c)) output.add (req.Object_Id__c) ;
        }

        return output;

    }

    static Integration_Request__c createOutboundIntetgrationRequest(Id objId, String objName, String event, String subEvent, String Market, String Geo, String Lob)
    {

        System.debug('--> new Integration Request' + 'objId:' + objId + ':objName:' + objName + ':event:' + event + ':subEvent:' + subEvent );

        return new Integration_Request__c(Object_Id__c = objId, Object_Name__c = objName, Event__c = event, Sub_Event__c = subEvent, 
            Direction__c ='Outbound', status__c = 'New', Market__c = Market, Geo__c = Geo, LoB__c = translateLineOfBusiness(Lob));
    }

  /*************************************************************************************************************
  * @Name        : translateLineOfBusiness
  * @Description : This method translate the Lob from the value used by One CRM to the value agreed with ESB 
  * 
  * @Input       : One CRM Line of Business
  * @Output      : ESB Line of Business 
  *************************************************************************************************************/
  
  static String translateLineOfBusiness(String lob)
  {
      //this method will only translate the necessary values, values that don't require translation will be
      //automatically returned

      if(lob == 'Higher Ed'){
        return 'HE';
      }

      if(lob == 'Schools'){
        return 'K-12';
      }

      return lob;
  }
   
    static Map<Id,Boolean> verifyOpportunityWasRegistered (List<Opportunity> opps)
    {
        Map<Id, Boolean> output = new Map<Id, Boolean> ();

        Map<Id, Opportunity> Opportunities = new  Map<Id, Opportunity>(opps);

        List<Integration_Request__c> registred = [SELECT Id, Object_Id__c FROM Integration_Request__c WHERE Object_Id__c in: Opportunities.KeySet() AND Event__c ='Register Student'];
        
        for(Integration_Request__c req : registred)
        {
          output.put(req.Object_Id__c,true);
        }

        for(Opportunity oppy: opps)
        {
          if(oppy.Type == 'New Business' && ! output.containsKey(oppy.Id))
          {
            output.put(oppy.Id,false);
          }
        }

        return output;

    }
}