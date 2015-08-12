/************************************************************************************************************
* Apex Class Name   : OrderItemTriggerHandler.cls
* Version           : 1.1 
* Created Date      : 26 May 2015
* Function          : Handler class for StandarOrder Object Product(OrderItem)  Trigger
* Modification Log  :
* Developer                   Date                    Description
* -----------------------------------------------------------------------------------------------------------
* Davi Borges         13 Jul 2015                   Inclusion of validation framework
************************************************************************************************************/

public without sharing class OrderItemTriggerHandler
{
   
    
    // EXECUTE BEFORE INSERT LOGIC
    //
    public void OnBeforeInsert(list<orderitem> orderitems)
    {
       Map<String, OrderItem> mapNewOrderItem = createListMap(orderitems);
        
        List<PS_OrderItemValidationInterface> validations = PS_OrderItemValidationFactory.CreateValidations(mapNewOrderItem , null, new User(Id=UserInfo.getUserId()));

        Map<String,List<String>> exceptions = new Map<String,List<String>>();

        for(PS_OrderItemValidationInterface validation: validations)
        {
            validation.validateInsert(exceptions);
        }
       
    }
    
    // EXECUTE AFTER INSERT LOGIC
    //
    public void OnAfterInsert(list<orderitem> orderitems)
    {
       
    }
    
    // BEFORE UPDATE LOGIC
    //
    public void OnBeforeUpdate(Map<Id,OrderItem> mapNewOrderProduct, Map<Id,OrderItem> mapOldOrderProduct)
    {
        Map<String, OrderItem> mapNewOrderItem = createListMap(mapNewOrderProduct);
        
        List<PS_OrderItemValidationInterface> validations = PS_OrderItemValidationFactory.CreateValidations(mapNewOrderItem , mapOldOrderProduct, new User(Id=UserInfo.getUserId()));


        Map<String,List<String>> exceptions = new Map<String,List<String>>();

        for(PS_OrderItemValidationInterface validation: validations)
        {
            validation.validateUpdate(exceptions);
        }

        if( ! exceptions.isEmpty())
        {
            PS_Util.addErrors(mapNewOrderItem , exceptions);

            return;
        }

       
    }
    
    // AFTER UPDATE LOGIC
    //
    public void OnAfterUpdate(list<orderitem> orderitems)
    { if(checkRecurssion.runOnce()) 
      {
        PS_INT_IntegrationRequestController.createIntegrationRequestOrderLine(orderitems,Trigger.oldMap);
        List<PS_OrderUpdateInterface> updates = PS_OrderUpdateFactory.createOrderUpdates(orderitems);
        for(PS_OrderUpdateInterface updateInterface: updates)
        {
          updateInterface.updateOrders();
        }
      }
    }
    
    // BEFORE DELETE LOGIC
    //
    public void OnBeforeDelete(Map<Id,OrderItem> mapNewOrderProduct, Map<Id,OrderItem> mapOldOrderProduct)
    {
        Map<String, OrderItem> mapNewOrderItem = createListMap(mapOldOrderProduct);
        
        List<PS_OrderItemValidationInterface> validations = PS_OrderItemValidationFactory.CreateValidations(mapNewOrderItem , mapOldOrderProduct, new User(Id=UserInfo.getUserId()));


        Map<String,List<String>> exceptions = new Map<String,List<String>>();

        for(PS_OrderItemValidationInterface validation: validations)
        {
            validation.validateDelete(exceptions);
        }

        if( ! exceptions.isEmpty())
        {
            PS_Util.addErrors(mapNewOrderItem , exceptions);

            return;
        }
    }
    
    // AFTER DELETE LOGIC
    //
    public void OnAfterDelete(list<orderitem> orderitems)
    {
       
    }
    
    // AFTER UNDELETE LOGIC
    //
    public void OnUndelete(list<orderitem> orderitems)
    {
       
    }
    
    public static Map<String,OrderItem> createListMap(Map<Id,OrderItem> objs)
    {
        Map<String,OrderItem> output = new  Map<String,OrderItem>();

        for(Id id: objs.keySet())
        {
            output.put(id,objs.get(id));
        }

        return output;
    }
    
     public static Map<String,OrderItem> createListMap(List<OrderItem> objs)
    {
        Map<String,OrderItem> output = new  Map<String,OrderItem>();

        for(Integer i =0 ; i< objs.size(); i++)
        {
            output.put(String.valueOf(i), objs[i]);
        }

        return output;
    }
    
    
}