trigger tIU_Contact on Contact (after insert, after update, before update) {
  /* AA (Deloitte) - Deactivated as UK Users not onboarded yet
 
  List<AccountContact__c> AOC = new List<AccountContact__c>();
  Set<Id> AccountIds = new Set<Id> ();
  Set<Id> ContactIds = new Set<Id> ();
  List<AccountContact__c> AOCInDB;
  Boolean count = False;
  Integer AOC_Cnt = 0;
  List<AccountContact__c> AOC_Old ;
  List<AccountContact__c> AOC_Old_1 = new List<AccountContact__c> ();
  List<AccountContact__c> AOC_New = new List<AccountContact__c>();
  List<AccountContact__c> AOC_Del = new List<AccountContact__c>();
  
 if (Trigger.isBefore) {
   //Get a list of contact ids
   for (Contact c:Trigger.old) {
        ContactIds.add (c.Id);
   }
   
   //Get the existing account contact records
   AOC_Old = [select Id,Account__c,Contact__c from AccountContact__c where Contact__c = :ContactIds];

   for (Contact c:Trigger.old) {
     for (AccountContact__c k : AOC_Old) {
       //get the list of account contact records where contact's id and contact's account id
       // matches that on the account contact's contact and account id
       if (c.Id == k.Contact__c && c.AccountId == k.Account__c) {
         AOC_Old_1.add (k);
       }
     }
   }
   
   //Get the list of new contact account combinations   
   for (Contact c:Trigger.new) {
        AOC_New.add (new AccountContact__c(Account__c = c.AccountId, Contact__c = c.Id));
   }
   
   //Using the old and new account contact list, find where the account does not match for the same contact id
   //These are the account contact records that need to be deleted
   for ( AccountContact__c i : AOC_Old_1) {
     for (AccountContact__c j : AOC_new) {
       if (i.Contact__c == j.Contact__c && i.Account__c != j.Account__c) {
          AOC_del.add (i);
       }
     }
   }
   
   //Delete the account contact records only if there is data
   if (AOC_del.size() > 0) {
     delete AOC_del;
   }
 }
 
 if (Trigger.isAfter) 
 {
    if (Trigger.isUpdate) {
      //Get the list of all account ids
      for (Contact c:Trigger.new) {
        AccountIds.Add (c.AccountId);
      }
      AOCInDB = [select Account__c, Contact__c from AccountContact__c 
                  where Account__c = :AccountIds];
     
      for (Contact c:Trigger.new) {
        count = False;
        for (AccountContact__c a : AOCInDB) {
          if (a.Account__c == c.AccountId && a.Contact__c == c.Id) {
           count = True;
           break;
          }
        }
        if (!count) {
          AOC_Cnt += 1;
          AOC.add (new AccountContact__c(Account__c = c.AccountId, Contact__c = c.Id));
        }
      }
      if (AOC_Cnt > 0) {
        insert AOC;
      }
    }
    
    if (Trigger.isInsert ) {
      for (Contact c:Trigger.new) {
        AOC.add (new AccountContact__c(Account__c = c.AccountId, Contact__c = c.Id
        //AccountContactComboId__c = c.AccountId+'-'+c.Id
        ));
        //c.addError (c.AccountId + '-' + c.Id);
        //c.addError ('Here');
      }
      insert AOC;
   }
 }*/
}