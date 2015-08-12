trigger contactDuplicatePreventer on Contact
                               (before insert, before update) {
/* AA (Deloitte) - Deactivated as UK Users not onboarded yet
 
 
    Map<String, Contact> contactMap = new Map<String, Contact>();
    for (Contact contact : System.Trigger.new) {
        
        // Make sure we don't treat an email address that  
        // isn't changing during an update as a duplicate.  
    
        if ((contact.Email != null) && (contact.Allow_Duplicate_Email__c != true) &&
                (System.Trigger.isInsert ||
                (contact.Email != 
                    System.Trigger.oldMap.get(contact.Id).Email))) {
        
            // Make sure another new contact isn't also a duplicate  
    
            if (contactMap.containsKey(contact.Email)) {
                contact.Email.addError('Another new contact has the '
                                    + 'same email address.');
                contact.Allow_Duplicate_Email__c.addError('Check this '
                                    + 'box to allow a duplicate email address.');
            } else {
                contactMap.put(contact.Email, contact);
            }
       }
    }
    
    // Using a single database query, find all the contacts in  
    
    // the database that have the same email address as any  
    
    // of the contacts being inserted or updated.  
    
    for (Contact contact : [SELECT Email FROM Contact
                      WHERE Email IN :contactMap.KeySet()]) {
        Contact newContact = contactMap.get(contact.Email);
        newContact.Email.addError('A contact with this email '
                               + 'address already exists.');
        newContact.Allow_Duplicate_Email__c.addError('Check this '
                               + 'box to allow a duplicate email address.');                       
    }*/
}