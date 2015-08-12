trigger Contact on Contact (after delete, after insert, after undelete, after update, before delete, before insert, before update)
{
    
    Bypass_Settings__c bypass = Bypass_Settings__c.getInstance();
    if (bypass.Disable_Triggers__c) return;
    
    List<Contact> newContacts = new List<Contact>();
    List<Contact> oldContacts = new List<Contact>();
    ContactTriggerHandler Handler = new ContactTriggerHandler(Trigger.isExecuting, Trigger.size);
    
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
       // contactCreateTriggerHandler.createAccountContact(trigger.new);
        Handler.OnAfterInsert(Trigger.new);
    }
    // Before Update Logic
    //
    else if(Trigger.isUpdate && Trigger.isBefore)
    {
        newContacts = CommonUtils.getContactbypassRecordType(System.Label.ContactANZRecordType, Trigger.new);
        oldContacts = CommonUtils.getContactbypassRecordType(System.Label.ContactANZRecordType, Trigger.old);
        if(!newContacts.isEmpty()){
            Handler.OnBeforeUpdate(newContacts, Trigger.oldMap);
        }
    }
    // After Update Logic
    //
    else if(Trigger.isUpdate && Trigger.isAfter)
    {
        Handler.OnAfterUpdate(Trigger.old, Trigger.new, Trigger.newMap, Trigger.oldMap);
    }
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
    }
}