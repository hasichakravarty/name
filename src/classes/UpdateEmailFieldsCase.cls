public without sharing class UpdateEmailFieldsCase {

    public static void populateEmailFieldsCase(List<Case> caseList){
        
        List<ID> accountIDs = new List<ID>();
        List<ID> contactIDs = new List<ID>();
        
        // Build the account ID list to pull all sponsorship contacts if there are any
        for (Case c : caseList) {
            if (c.AccountId != NULL) accountIDs.add(c.AccountId);
            if (c.ContactId != NULL) contactIDs.add(c.ContactId);
            if (c.Sponsor_name__c != NULL) contactIDs.add(c.Sponsor_name__c);
        } // End for
        
        // Retrieve all the related sponsor and student contacts and add them on a map
        Map<ID, String> sponsorContactEmailMap = new Map<ID, String>();
        Map<ID, String> studentContactEmailMap = new Map<ID, String>();
        
        List<AccountContact__c> sponsorContacts = [SELECT Account__c, Contact__r.Email 
                                                        FROM AccountContact__c 
                                                        WHERE Account__c IN :accountIDs AND Financially_Responsible__c = TRUE];
        // Build the sponsor email map
        for (AccountContact__c ac : sponsorContacts) {
            sponsorContactEmailMap.put(ac.Account__c, ac.Contact__r.Email);
        } // End for
        
        // Retrieve the contact emails
        List<Contact> studentContacts = [SELECT Id, Email FROM Contact WHERE Id IN :contactIDs];
        
        // Build the student email map
        for (Contact sc : studentContacts) {
            studentContactEmailMap.put(sc.Id, sc.Email);
        } // End for
        
        // Then update the sponsor and student email fields
        for (Case c : caseList) {
            // If there is a sponsor then use that value to retrieve the email
            if (studentContactEmailMap.containsKey(c.Sponsor_name__c))
                c.Account_Financially_Responsible_Email__c = studentContactEmailMap.get(c.Sponsor_name__c);
            // If the sponsor has not been selected, then pull the sponsor from the account/contact relatioship
            if (c.Sponsor_name__c == NULL && c.AccountId != NULL) {
                if (sponsorContactEmailMap.containsKey(c.AccountId))
                    c.Account_Financially_Responsible_Email__c = sponsorContactEmailMap.get(c.AccountId);
            } // End account ID check
            if (c.ContactId!= NULL) {
                if (studentContactEmailMap.containsKey(c.ContactId))
                    c.Account_Primary_Contact_Email__c = studentContactEmailMap.get(c.ContactId);
            } // End contact ID check
            // If the sponsor email and the student email are the same, then clear the sponsor email
            if (c.Account_Primary_Contact_Email__c == c.Account_Financially_Responsible_Email__c)
                c.Account_Financially_Responsible_Email__c = NULL;
        } // End for
        
    }
}