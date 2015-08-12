public class primarycheckonAccountContact{
    
    public static void togglePrimaryAndFinancialFlags(List<AccountContact__c> triggeredAccountcontacts, Map<Id, AccountContact__c> previousValuesMap) {
        List<ID> accountRecordIDs = new List<ID>();
        List<AccountContact__c> relatedAccountContactRecords = new List<AccountContact__c>();
        Map<Id, AccountContact__c> updatedAccountContactRecordsMap = new Map<Id, AccountContact__c>();
        Boolean blnInsert = (previousValuesMap == NULL);
        
        // Build the related account list
        for(AccountContact__c ac : triggeredAccountcontacts) { 
            accountRecordIDs.add(ac.Account__c);
        } // End for
        
        // Retrieve the related accounts contact records
        if (!accountRecordIDs.isEmpty())
            relatedAccountContactRecords = [SELECT Id, Account__c, Financially_Responsible__c, Primary__c 
                                            FROM AccountContact__c 
                                            WHERE Account__c IN :accountRecordIDs AND Id NOT IN :triggeredAccountcontacts];
        
        // RD-00287
        // - When an account contact is selected as primary, any previous primary records should be deselected
        // - When an account contact is selected as financially responsible, any previous FS records should be deselected
        
        // Iterate through the triggered account contact records and check the field values based on the following business logic
        for(AccountContact__c ac : triggeredAccountcontacts) { 
            
            // If either primary contact or FS checkboxes are checked, then retrieve the related account contact records
            // The record has to be updated once, otherwise the DML will fail
            if (ac.Primary__c || ac.Financially_Responsible__c) {
                for (AccountContact__c rac : relatedAccountContactRecords) {
                    if (rac.Account__c == ac.Account__c) {
                        
                        if (ac.Primary__c) {
                            if (blnInsert) {
                                system.debug(updatedAccountContactRecordsMap.size());
                                if (!updatedAccountContactRecordsMap.containsKey(rac.Id))
                                    updatedAccountContactRecordsMap.put(rac.Id, rac);
                                updatedAccountContactRecordsMap.get(rac.Id).Primary__c = FALSE;
                                updatedAccountContactRecordsMap.get(rac.Id).Sync_In_Progress__c = TRUE;
                            } else {
                                if (!previousValuesMap.get(ac.Id).Primary__c) {
                                    if (!updatedAccountContactRecordsMap.containsKey(rac.Id))
                                        updatedAccountContactRecordsMap.put(rac.Id, rac);
                                    updatedAccountContactRecordsMap.get(rac.Id).Primary__c = FALSE;
                                    updatedAccountContactRecordsMap.get(rac.Id).Sync_In_Progress__c = TRUE;
                                }
                            }
                        }
                        
                        if (ac.Financially_Responsible__c) {
                            if (blnInsert) {
                                if (!updatedAccountContactRecordsMap.containsKey(rac.Id))
                                    updatedAccountContactRecordsMap.put(rac.Id, rac);
                                updatedAccountContactRecordsMap.get(rac.Id).Financially_Responsible__c= FALSE;
                                updatedAccountContactRecordsMap.get(rac.Id).Sync_In_Progress__c = TRUE;
                            } else {
                                if (!previousValuesMap.get(ac.Id).Financially_Responsible__c) {
                                    if (!updatedAccountContactRecordsMap.containsKey(rac.Id))
                                        updatedAccountContactRecordsMap.put(rac.Id, rac);
                                    updatedAccountContactRecordsMap.get(rac.Id).Financially_Responsible__c= FALSE;
                                    updatedAccountContactRecordsMap.get(rac.Id).Sync_In_Progress__c = TRUE;
                                }
                            }
                        }
                    }
                }    
            } // End Primary/FS check
        } // End for
        
        // Update the related records
        if (!updatedAccountContactRecordsMap.isEmpty())
            Database.Update(updatedAccountContactRecordsMap.Values());
    }
    
  /*public static void updateContact(List<AccountContact__c> acList,List<AccountContact__c> oldList){
  
   List<AccountContact__c> tempacList = new List<AccountContact__c>();
   List<contact> conlist = new List<contact>();
   Map<Id,Id> tempMap = new Map<Id,Id>();
   Map<Id,AccountContact__c> tempActMap = new Map<Id,AccountContact__c>();
   Set<ID> acIds = new Set<ID>();
   List<AccountContact__c> accconlist = [select id,Account__c,Contact__c,Account_Name__c from AccountContact__c where ID IN :acList AND Contact__c <> null];
       
       for(AccountContact__c ac: accconlist ){
       
        if(ac.Account_Name__c ){
            
            tempMap.put(ac.Contact__c,ac.Account__c);
            acIds.add(ac.id);
            tempActMap.put(ac.Account__c,ac);
            
        }
       
       
       }
   
     for(Contact c : [select Id,AccountID,(select Id,Account_Name__c from Accounts__r) from Contact where Id IN :tempMap.keySet() ]){
     
        c.AccountId = tempMap.get(c.ID); 
        system.debug('############'+c.AccountId);       
        conList.add(c);
        for(AccountContact__c ac : c.Accounts__r){
            if(ac.Account_Name__c && !acIds.contains(ac.Id)){
                ac.Account_Name__c = false;
                tempacList.add(ac);
            }
        }
    }
    
    
    for(Account c : [select Id,(select Id,Account_Name__c from Contacts__r) from Account where Id IN :tempActMap.keySet() ]){
         
        for(AccountContact__c ac : c.Contacts__r){
            if(ac.Account_Name__c && !acIds.contains(ac.Id)){
                ac.Account_Name__c = false;
                tempacList.add(ac);
            }
        }
    }   
    
    
    
    
    if(!conList.isEmpty()){
        update conList;
    }
    if(!tempacList.isEmpty()){
        update tempacList;
    }
  }*/

}