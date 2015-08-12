@isTest
private class TestAccountContactTrigger {
/* AA (Deloitte) - Deactivated as UK Users not onboarded yet
 
 
    public static testMethod void myUnitTest() {
        // TO DO: implement unit test
        Test.startTest();
         String AcctRecordTypeId;
        String ContactRecordTypeId;
        String DiscRecordTypeId;
        String ClusterRecordTypeId;
        String OptyRecordTypeId;                        
        
        List<RecordType> RecordTypeList = new List<RecordType>([select Id,Name from RecordType]);
        
        for (RecordType i : RecordTypeList) {
          if (i.Name == 'Bookshop') {
            AcctRecordTypeId = i.Id;
          }
          if (i.Name == 'Bookshop Contact') {
             ContactRecordTypeId = i.Id;
          }
          
          if (i.Name == '3) Discipline') {
            DiscRecordTypeId = i.Id;
          }
          if (i.Name == '2) Cluster') {
            ClusterRecordTypeId = i.Id;
          }
          if (i.Name == 'New Multi-Component') {
            OptyRecordTypeId = i.Id;
          }                    
        }        
        Account acct = new Account (name = 'Test1',BillingStreet = 'Street1',
                   BillingCity = 'London', BillingPostalCode = 'ABC DEF', BillingCountry = 'UK',
                    Vista_Account_Number__c = 'xyz',RecordTypeId= AcctRecordTypeId);
        insert acct;
        
        Contact ct  = new Contact (FirstName = 'testfnm', LastName = 'testln', AccountId = acct.Id,
          RecordTypeId=ContactRecordTypeId);
        insert ct;
		*/
        /*AccountContact__c aoc1 = new AccountContact__c (Account__c = acct.Id, Contact__c = ct.Id,
                   AccountContactComboId__c = acct.Id + '-' + ct.Id);
        insert aoc1;*/
		/* AA (Deloitte) - Deactivated as UK Users not onboarded yet
 
 
        AccountContact__c aoc2 = [select Account__c, Contact__c from AccountContact__c 
                    where Account__c = :acct.Id and Contact__c = :ct.Id];
        
        System.assertEquals(ct.Id, aoc2.Contact__c);
        Test.stopTest();
        //insert ct;
        
    }
    
    */
}