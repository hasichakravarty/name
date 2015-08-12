trigger IntegrationRequest on Integration_Request__c (after delete, after insert, after undelete, after update, before delete, before insert, before update) 
{

    // Trigger handler class
     IntegrationRequestTriggerHandler Handler = new IntegrationRequestTriggerHandler();

    // Before Insert 
    if(Trigger.isBefore && Trigger.isInsert)
    {
        Handler.OnBeforeInsert(Trigger.new);
    }
    // After Insert
    else if(Trigger.isAfter && Trigger.isInsert)
    {
        Handler.OnAfterInsert(Trigger.new, Trigger.newMap);
    }
    // Before Update
    else if(Trigger.isBefore && Trigger.isUpdate)
    {
        Handler.OnBeforeUpdate(Trigger.old, Trigger.new, Trigger.oldMap, Trigger.newMap);
    }
    // After Update
    else if(Trigger.isAfter && Trigger.isUpdate)
    {
        Handler.OnAfterUpdate(Trigger.old, Trigger.new, Trigger.oldMap, Trigger.newMap);
    }
    // Before Delete
    else if(Trigger.isBefore && Trigger.isDelete)
    {
        Handler.OnBeforeDelete(Trigger.old, Trigger.oldMap);
    }
    // After Delete
    else if(Trigger.isAfter && Trigger.isDelete)
    {
        Handler.OnAfterDelete(Trigger.old, Trigger.oldMap);
    }
    // After Undelete
    else if(Trigger.isUnDelete)
    {
        Handler.OnUndelete(Trigger.new, Trigger.newMap);
    }
}