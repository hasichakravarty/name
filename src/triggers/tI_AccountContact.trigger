trigger tI_AccountContact on AccountContact__c (before insert) {
 /* AA (Deloitte) - Deactivated as UK Users not onboarded yet
 
 Set<Id> ContactIds = new Set<Id> ();
 List<AccountContact__c> AccountContact = new List<AccountContact__c> ();
 Map <String, AccountContact__c> AccountContactMap = new Map<String, AccountContact__c> ();
 String msg1;
 
 if (Trigger.isInsert) {    
  for (AccountContact__c i :Trigger.new) {
      ContactIds.Add (i.Contact__c);
  }
 
  //Get the list of account contact for the list of product ids
  List<AccountContact__c> AccountContactInDB = [select Account__c, Contact__c
             from AccountContact__c where Contact__c = :ContactIds];
        
   for (AccountContact__c i : AccountContactInDB) {
       AccountContactMap.put(i.Account__c+'-'+i.Contact__c, new AccountContact__c (
                  Account__c = i.Account__c,
                  Contact__c = i.Contact__c) );         
  }
     
  //check if the account contact record is being duplicated.
   for (AccountContact__c AccountContactChk : Trigger.new) {
     if (AccountContactMap.containsKey(AccountContactChk.Account__c + '-' + AccountContactChk.Contact__c)) {
       AccountContactChk.addError ('Contact exists for this Account');
       //HEUK_GlobalMessages__c msg = HEUK_GlobalMessages__c.getOrgDefaults();
       //msg1 = msg.Duplicate_Account_Contact_Message__c;
      
     }
   }      
 }*/
}