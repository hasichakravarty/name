trigger InternalRequest on Internal_Request__c(after delete, after insert, after undelete, after update, before delete, before insert, before update)
{
    InternalRequestTriggerHandler Handler = new InternalRequestTriggerHandler(Trigger.isExecuting, Trigger.size);
    
    /* Before Insert Logic
    //
    if(Trigger.isInsert && Trigger.isBefore)
    {
        Handler.OnBeforeInsert(Trigger.new);
    }
    // After Insert Logic
    //
    else*/ 
    if(Trigger.isInsert && Trigger.isAfter)
    {
       // Handler.OnAfterInsert(Trigger.new);
    }
    
    //Before Update Logic
    //
    if(Trigger.isUpdate && Trigger.isBefore)
    {
       try{

        Handler.OnBeforeUpdate(Trigger.old, Trigger.new, Trigger.newMap);
        
        }catch(Exception e){
        system.debug('**************** before update exception**********'+e);
        }
    }
    //After Update Logic
    else if(Trigger.isUpdate && Trigger.isAfter)
    {system.debug('****************after update update *********');
       // Handler.OnAfterUpdate(Trigger.old, Trigger.new, Trigger.newMap);
       Handler.OnAfterUpdate(Trigger.new);
    }
   /* // Before Delete Logic
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