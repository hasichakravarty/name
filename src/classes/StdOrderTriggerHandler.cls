/************************************************************************************************************
* Apex Class Name   : StandardOrderTriggerHandler.cls
* Version           : 1.0 
* Created Date      : 12 May 2015
* Function          : Handler class for StandarOrder Object Trigger
* Modification Log  :
* Developer                   Date                    Description
* -----------------------------------------------------------------------------------------------------------
* Davi Borges              01/Jul/2015            Removal of delete related operation, removal of Address 
                                                  replication to address override that is no longer necessary, 
                                                  since it is performed by web service RetrieveOneCRMHandler
-------------------------------------------------------------------------------------------------------------
  Davi Borges              10/Jul/2015            1) Introduction to validation to prevent changes from inconrect
                                                     people
                                                  2) Replication of shippingToContactID to Contact_c to allow 
                                                  use of related list in contact.   
************************************************************************************************************/

public without sharing class StdOrderTriggerHandler
{
   
    // EXECUTE BEFORE INSERT LOGIC
    //
    public void OnBeforeInsert(List<Order> newOrders)
    {
            
        // automactic definition of the CompanyAuthorizedById that identifies the pearson to which te order
        // is related. 
        for(Order ordr: newOrders)
        {
            ordr.CompanyAuthorizedById = UserInfo.getUserId();
            ordr.Contact__c = ordr.ShipToContactId;
        }
        
    }
    
    // EXECUTE AFTER INSERT LOGIC
    //
    public void OnAfterInsert(Map<Id,Order> newOrders)
    {
       PS_INT_IntegrationRequestController.createIntegrationRequestOrder(newOrders.values(),null);
    }
    
    // BEFORE UPDATE LOGIC
    //
    public void OnBeforeUpdate( Map<Id,Order> newOrders, Map<Id,Order> oldOrders)
    {
       //R3 - Todo --> It might be necessary to introduce logic related to Order To Cash order vs Sampling Orders 

        Map<String, Order> mapNewOrder = createListMap(newOrders);
        
        List<PS_OrderValidationInterface> validations = PS_OrderValidationFactory.CreateValidations(mapNewOrder, oldOrders, new User(Id=UserInfo.getUserId()));


        Map<String,List<String>> exceptions = new Map<String,List<String>>();

        for(PS_OrderValidationInterface validation: validations)
        {
            validation.validateUpdate(exceptions);
        }

        if( ! exceptions.isEmpty())
        {
            PS_Util.addErrors(mapNewOrder, exceptions);

            return;
        }



       for(Order ordr: newOrders.values())
       {
            ordr.Contact__c = ordr.ShipToContactId;
       }

       OrderApproval approvalprocess = new OrderApproval(newOrders,oldOrders);
       approvalprocess.submitOrder(); 
    }
    
    // AFTER UPDATE LOGIC
    //
    public void OnAfterUpdate(Map<Id,Order> newOrders, Map<Id,Order> oldOrders)
    {    
        PS_INT_IntegrationRequestController.createIntegrationRequestOrder(newOrders.values(),oldOrders);
         
        OrderApproval approvalprocess = new OrderApproval(newOrders,oldOrders);
        approvalprocess.submitApprovalChatterPost();
        approvalprocess.updatelorderlineitemstatus();
        approvalprocess.saveOrderItems();
    }


    public static Map<String,Order> createListMap(List<Order> objs)
    {
        Map<String,Order> output = new  Map<String,Order>();

        for(Integer i =0 ; i< objs.size(); i++)
        {
            output.put(String.valueOf(i), objs[i]);
        }

        return output;
    }

    public static Map<String,Order> createListMap(Map<Id,Order> objs)
    {
        Map<String,Order> output = new  Map<String,Order>();

        for(Id id: objs.keySet())
        {
            output.put(id,objs.get(id));
        }

        return output;
    }
    
    
}