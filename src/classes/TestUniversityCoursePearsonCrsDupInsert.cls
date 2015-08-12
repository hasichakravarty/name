@isTest
private class TestUniversityCoursePearsonCrsDupInsert {

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
          if (i.Name == 'Bookshop Contact') {
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
        
        PearsonCourseStructure__c PCSTR1 = new PearsonCourseStructure__c (Name = 'Accounting', Type__c = 'Discipline', Active_Indicator__c = true);
          //RecordTypeId = DiscRecordTypeId );
        insert PCSTR1;
        
        UniversityCourse__c UC1 = new UniversityCourse__c (name = 'TestUC1', Account__c = bkshop1.Id);
        insert UC1;
        
        //check inserted value        
        UniversityCoursePearsonCourseStructure__c UCPCSTR1 = new UniversityCoursePearsonCourseStructure__c (
            UniversityCourse__c = UC1.Id, PearsonCourseStructure__c = PCSTR1.Id);
        insert UCPCSTR1 ;

        //UniversityCoursePearsonCourseStructure__c UCPCSTR2 = new UniversityCoursePearsonCourseStructure__c (
        //    UniversityCourse__c = UC1.Id, PearsonCourseStructure__c = PCSTR1.Id);
        //insert UCPCSTR2;      
        //System.assertEquals(prod.Bookshop_Quantity__c, 25);

                        
        Test.stopTest();        
    }
}