@isTest
private class TestUniversityCourseContactDupInsert {

    public static testMethod void myUnitTest() {
    
        Test.startTest();
        String AcctRecordTypeId;
        String ContactRecordTypeId;
        String DiscRecordTypeId;
        String ClusterRecordTypeId;
        String OptyRecordTypeId;                        
        
        List<RecordType> RecordTypeList = new List<RecordType>([select Id,Name from RecordType]);
        
        for (RecordType i : RecordTypeList) {
          if (i.Name == 'Bookstore') {
            AcctRecordTypeId = i.Id;
          }
          if (i.Name == 'Contact') {
             ContactRecordTypeId = i.Id;
          }
          
          if (i.Name == '3) Discipline') {
            DiscRecordTypeId = i.Id;
          }
          if (i.Name == '2) Cluster') {
            ClusterRecordTypeId = i.Id;
          }
          if (i.Name == 'Opportunity') {
            OptyRecordTypeId = i.Id;
          }                    
        }        
        Account bkshop1  = new Account (name = 'Test Bookshop1', BillingStreet = 'Street1',
                   BillingCity = 'Sydney', BillingPostalCode = 'ABC DEF', BillingCountry = 'Australia',
                    //Vista_Account_Number__c = 'xyz',
                    RecordTypeId= AcctRecordTypeId );
        insert bkshop1;
        
        Account bkshop2  = new Account (name = 'Test Bookshop2', BillingStreet = 'Street2',
                   BillingCity = 'London', BillingPostalCode = 'ABC DEF', BillingCountry = 'Australia',
                   //Vista_Account_Number__c = 'xyz1',
                   RecordTypeId = AcctRecordTypeId );
        insert bkshop2;
        
        Contact ct1 = new Contact (Firstname = 'TestF1', LastName = 'TestL1', AccountId = bkshop1.Id,email='test@test.com',
                        RecordTypeId=ContactRecordTypeId );
        insert ct1;
        
        UniversityCourse__c UC1 = new UniversityCourse__c (name = 'TestUC1', Account__c = bkshop1.Id);
        insert UC1;
        
        //check inserted value        
        UniversityCourseContact__c UCT1 = new UniversityCourseContact__c (UniversityCourse__c = UC1.Id, Contact__c = ct1.Id);
        insert UCT1;

        //UniversityCourseContact__c UCT2 = new UniversityCourseContact__c (UniversityCourse__c = UC1.Id, Contact__c = ct1.Id);
        //insert UCT2;        
        //System.assertEquals(prod.Bookshop_Quantity__c, 25);

                        
        Test.stopTest();        
    }
}