public class AccountContact_Primary_Financial {
    
    public static void checkPrimaryAndFinancialFlags(List<AccountContact__c> triggeredAccountcontacts) {
        List<ID> accountRecordIDs = new List<ID>();
        List<AccountContact__c> relatedAccountContactRecords = new List<AccountContact__c>();
                
        // Build the related account list
        for(AccountContact__c ac : triggeredAccountcontacts) { 
            accountRecordIDs.add(ac.Account__c);
        } // End for
        
        // Retrieve the related accounts contact records
        if (!accountRecordIDs.isEmpty())
            relatedAccountContactRecords = [SELECT Id, Account__c, Account__r.RecordTypeId, Financially_Responsible__c, Primary__c 
                                            FROM AccountContact__c WHERE Account__c IN :accountRecordIDs];
            //Get RecordType Id for Learner Account Type                                
            Id learnerRTId = [SELECT Id from RecordType WHERE sObjectType='Account' AND Name='Learner'].Id;                                 
        
        // RD-00287
        // - An account contact must have at least 1 financially responsible contact, if not raise error
        // - An account contact must have at least 1 primary contact, if not raise error
        
        // Iterate through the triggered account contact records and check the field values based on the following business logic
        for(AccountContact__c ac : triggeredAccountcontacts) { 
            // Check for primary account contacts
            if (!ac.Primary__c && !ac.Sync_In_Progress__c ) {
              if (numberOfOtherPrimaryAccountContacts(relatedAccountContactRecords, ac.Account__c, ac.Id) == 0 && ac.Account__r.RecordTypeId==learnerRTId ) {
                     // Ignore validation if there are no other records to allow the user to create an account contact for the first time
                     if (relatedAccountContactRecords.size() > 1)
                         ac.Primary__c.addError(Label.AC001_Primary_Contact_Error);
                }
            }
            // Check for FS account contacts
            if (!ac.Financially_Responsible__c && !ac.Sync_In_Progress__c ) {
                if (numberOfOtherFSAccountContacts(relatedAccountContactRecords, ac.Account__c, ac.Id) == 0 && ac.Account__r.RecordTypeId==learnerRTId) {
                    // Ignore validation if there are no other records to allow the user to create an account contact for the first time
                    if (relatedAccountContactRecords.size() > 1)
                        ac.Financially_Responsible__c.addError(Label.AC001_Financial_Responsible_Person_Error);
                }
            }
            // Reset the account sync flag
            ac.Sync_In_Progress__c = FALSE;
        } // End for
        
    }
    
    private static Integer numberOfOtherFSAccountContacts(List<AccountContact__c> relatedAccountContactRecords,
                                                                    String strAccountID,
                                                                                     String strTriggeredAccountContactID) {
        Integer intCount = 0;
        
        for (AccountContact__c rac : relatedAccountContactRecords) {
            if (rac.Account__c == strAccountID) {
                if (rac.Id != strTriggeredAccountContactID && rac.Financially_Responsible__c)
                    intCount++;
            }
        } // End for
            
        return intCount;
    }
    
    
    private static Integer numberOfOtherPrimaryAccountContacts(List<AccountContact__c> relatedAccountContactRecords,
                                                                    String strAccountID,
                                                                                     String strTriggeredAccountContactID) {
        Integer intCount = 0;
        
        for (AccountContact__c rac : relatedAccountContactRecords) {
            if (rac.Account__c == strAccountID) {
                if (rac.Id != strTriggeredAccountContactID && rac.Primary__c)
                    intCount++;
            }
        } // End for
            
        return intCount;
    }
    
}