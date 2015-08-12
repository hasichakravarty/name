@isTest
private class TestContactTrigger {
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
                    Vista_Account_Number__c = 'xyz',RecordTypeId= AcctRecordTypeId );
        insert acct;

        Account acct_2 = new Account (name = 'Test2',BillingStreet = 'Street1',
                   BillingCity = 'London', BillingPostalCode = 'ABC DEF', BillingCountry = 'UK',
                    Vista_Account_Number__c = 'xyz',RecordTypeId= AcctRecordTypeId );
        insert acct_2;
                
        Contact ct  = new Contact (FirstName = 'testfnm', LastName = 'testln', 
           AccountId = acct.Id,RecordTypeId = ContactRecordTypeId,Role_Type__c = 'Bookshop Manager' );
        insert ct;
        
        Contact ct1 = [select Id,FirstName from Contact where Id = :ct.Id];
        System.assertEquals('testfnm', ct1.FirstName);
        
        ct1.AccountId = acct_2.Id;
        update ct1;
        
        AccountContact__c aoc_1 = [select Account__c, Contact__c from AccountContact__c where Contact__c = :ct.id];
        //Contact ct2 = [select Id,FirstName from Contact where Id = :ct.Id];
        System.assertEquals(acct_2.Id, aoc_1.Account__c);
        
        //insert ct;
        
    }
    */
}