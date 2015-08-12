/************************************************************************************************************
* Apex Class Name   : OrderTrigger.trigger
* Version           : 1.1 
* Created Date      : N/A
* Function          : Trigger for the Order (Standard Object)
* Modification Log  :
* Developer                   Date                    Description
* -----------------------------------------------------------------------------------------------------------
* Davi Borges               01/Jul/2015               removal of unecessary events
************************************************************************************************************/

trigger OrderTrigger on Order ( after insert, after update, before insert, before update)
{
  StdOrderTriggerHandler Handler = new StdOrderTriggerHandler();
  
  Bypass_Settings__c bypass = Bypass_Settings__c.getInstance();
  
  if (bypass.Disable_Triggers__c) return;

  if(Trigger.isInsert && Trigger.isBefore)
  {
       Handler.OnBeforeInsert(Trigger.new);
  }
  // After Insert Logic
  //
  else if(Trigger.isInsert && Trigger.isAfter)
  {
        Handler.OnAfterInsert(Trigger.newMap);
  }
  // Before Update Logic
  //
  else if(Trigger.isUpdate && Trigger.isBefore)
  {
        Handler.OnBeforeUpdate(Trigger.newMap,Trigger.oldMap);
  }
  // After Update Logic
  //
  else if(Trigger.isUpdate && Trigger.isAfter)
  {
    Handler.OnAfterUpdate(Trigger.newMap,Trigger.oldMap);
  }
  
}