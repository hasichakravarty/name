/************************************************************************************************************
* Apex Class Name   : OrderItemTrigger.trigger
* Version           : 1.0 
* Created Date      : 
* Function          : OrderItemTrigger for Order Item
* Modification Log  :
* Developer                   Date                    Description
* -----------------------------------------------------------------------------------------------------------
* Leonard Victor             13/Jul/2015               Added Logic for OrderProduct Valdiation in Before update event
************************************************************************************************************/

trigger OrderItemTrigger on OrderItem (after delete, after insert, after undelete, 
after update, before delete, before insert, before update)
{
  OrderItemTriggerHandler Handler = new OrderItemTriggerHandler();
  
  Bypass_Settings__c bypass = Bypass_Settings__c.getInstance();
  if (bypass.Disable_Triggers__c) return;
  else{
  // Before Insert Logic
  //
  if(Trigger.isInsert && Trigger.isBefore)
  {
        Handler.OnBeforeInsert(Trigger.new);
  }
  // After Insert Logic
  //
  else if(Trigger.isInsert && Trigger.isAfter)
  {
  
  }
  // Before Update Logic
  //
  else if(Trigger.isUpdate && Trigger.isBefore)
  {
          Handler.OnBeforeUpdate(trigger.newMap,Trigger.oldMap);
   
  }
  // After Update Logic
  //
  else if(Trigger.isUpdate && Trigger.isAfter)
  {
    Handler.OnAfterUpdate(Trigger.new);
  }
  // Before Delete Logic
  //
  else if(Trigger.isDelete && Trigger.isBefore)
  {
    Handler.OnBeforeDelete(Trigger.newMap , Trigger.oldMap);
  }
  // After Delete Logic
  //
  else if(Trigger.isDelete && Trigger.isAfter)
  {
   
  }
  
  // After Undelete Logic
  //
  else if(Trigger.isUnDelete)
  {
  
  }
 } 
}