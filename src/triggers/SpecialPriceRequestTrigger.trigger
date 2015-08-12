trigger SpecialPriceRequestTrigger on Special_Price_Request__c (after delete, after insert, after undelete, after update, before delete, before insert, before update) {
    
SpecialPriceRequestTriggerHandler Handler = new SpecialPriceRequestTriggerHandler(Trigger.isExecuting, Trigger.size);

 
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
        Handler.OnAfterInsert(Trigger.new);
    }
    else if(Trigger.isUpdate && Trigger.isAfter)
    {
        Handler.OnAfterUpdate(Trigger.old, Trigger.new, Trigger.oldMap);
    }
    
    //Before Update Logic
    
    else if(Trigger.isUpdate && Trigger.isBefore)
    {
        Handler.OnBeforeUpdate(Trigger.old, Trigger.new, Trigger.oldmap); 
    }
    // After Update Logic
    //
    /*
    // Before Delete Logic
    //
    else if(Trigger.isDelete && Trigger.isBefore)
    {
        Handler.OnBeforeDelete(Trigger.old, Trigger.oldMap);
    }
    // After Delete Logic
    //
    else if(Trigger.isDelete && Trigger.isAfter)
    {
        Handler.OnAfterDelete(Trigger.old, Trigger.oldMap);
    }
    
    // After Undelete Logic
    //
    else if(Trigger.isUnDelete)
    {
        Handler.OnUndelete(Trigger.new);
    }*/

}