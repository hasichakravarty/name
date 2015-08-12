@isTest
private class TestOpportunityCourseTrigger {

    public static testMethod void myUnitTest() {
        Test.startTest();
        // TO DO: implement unit test
        //create the account
        String AcctRecordTypeId;
        String DiscRecordTypeId;
        String ClusterRecordTypeId;
        String OptyRecordTypeId;                        
        
        List<RecordType> RecordTypeList = new List<RecordType>([select Id,Name from RecordType]);
        
        for (RecordType i : RecordTypeList) {
          if (i.Name == 'Bookstore') {
            AcctRecordTypeId = i.Id;
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
        
        Account acct = new Account (name = 'Test1', BillingStreet = 'Street1',
                   BillingCity = 'London', BillingPostalCode = 'ABC DEF', BillingCountry = 'Australia',
                  //Vista_Account_Number__c = 'xyz',
                  RecordTypeId= AcctRecordTypeId); //'012E0000000Ll83');
        insert acct;
        
        //link account to universtiy course
        UniversityCourse__c univcrs = new UniversityCourse__c (Account__c = acct.Id, name = 'acct mgmt1');
        insert univcrs;
        
        //create pearson course structures
        PearsonCourseStructure__c disc = new PearsonCourseStructure__c (Name = 'Accounting & Taxation',
          Active_Indicator__c = True,Type__c = 'Discipline'); //,RecordTypeId = DiscRecordTypeId);
        insert disc;
        
        
        PearsonCourseStructure__c cluster = new PearsonCourseStructure__c (Name = 'Financial Accounting',
          Active_Indicator__c = True,Type__c = 'Cluster',Parent_Pearson_Course_Structure__c = disc.Id);
            //RecordTypeId = ClusterRecordTypeId );
        insert cluster;

        PearsonCourseStructure__c cluster2 = new PearsonCourseStructure__c (Name = 'Business Accounting',
          Active_Indicator__c = True,Type__c = 'Cluster',Parent_Pearson_Course_Structure__c = disc.Id);
          //RecordTypeId = ClusterRecordTypeId );
        insert cluster2;

        //associate university course to pearson course structures
        UniversityCoursePearsonCourseStructure__c univcrspearsoncrs = 
          new UniversityCoursePearsonCourseStructure__c (PearsonCourseStructure__c = cluster.Id,
            UniversityCourse__c = univcrs.Id);
        insert univcrspearsoncrs;

        UniversityCoursePearsonCourseStructure__c univcrspearsoncrs2 = 
          new UniversityCoursePearsonCourseStructure__c (PearsonCourseStructure__c = cluster2.Id,
            UniversityCourse__c = univcrs.Id);
           insert univcrspearsoncrs2;
              
        //create opportunity for account
        Opportunity opty_1 = new Opportunity (name = 'Test Opty1',Account = acct, StageName = 'Identification',
          CloseDate = System.Today(),RecordTypeId = OptyRecordTypeId );
        insert opty_1;
        
        //associate opportunity to university course
        OpportunityUniversityCourse__c optyunivcrs = new OpportunityUniversityCourse__c (Account__c=acct.id,Close_Date__c = system.today()+7,
          Opportunity_Name__c='Test',Opportunity_University_Course_Amount__c=100.00,Opportunity__c = opty_1.Id,UniversityCourse__c = univcrs.Id);
        insert optyunivcrs;
        
        //Validate that opportunity is linked to the pearson course structure associated to the university course
        OpportunityPearsonCourseStructure__c optypearsoncrs = [select Opportunity__c,Pearson_Course_Structure__c
          from OpportunityPearsonCourseStructure__c where Opportunity__c = :opty_1.Id
          and Pearson_Course_Structure__c = :cluster.Id];
        
        System.assertEquals (optypearsoncrs.Pearson_Course_Structure__c, cluster.Id);
        
        OpportunityPearsonCourseStructure__c optypearsoncrs2 = [select Opportunity__c,Pearson_Course_Structure__c
          from OpportunityPearsonCourseStructure__c where Opportunity__c = :opty_1.Id
          and Pearson_Course_Structure__c = :cluster2.Id];
        
        System.assertEquals (optypearsoncrs2.Pearson_Course_Structure__c, cluster2.Id);

        //associate opportunity to university course again
        //OpportunityUniversityCourse__c optyunivcrs_1 = new OpportunityUniversityCourse__c (
       //  Opportunity__c = opty_1.Id,UniversityCourse__c = univcrs.Id);
        //insert optyunivcrs_1;
        
        //Validate that opportunity is linked to the pearson course structure associated to the university course
        OpportunityPearsonCourseStructure__c optypearsoncrs3 = [select Opportunity__c,Pearson_Course_Structure__c
          from OpportunityPearsonCourseStructure__c where Opportunity__c = :opty_1.Id
          and Pearson_Course_Structure__c = :cluster.Id];
        
        System.assertEquals (optypearsoncrs3.Pearson_Course_Structure__c, cluster.Id);
        
        OpportunityPearsonCourseStructure__c optypearsoncrs4 = [select Opportunity__c,Pearson_Course_Structure__c
          from OpportunityPearsonCourseStructure__c where Opportunity__c = :opty_1.Id
          and Pearson_Course_Structure__c = :cluster2.Id];
        
        System.assertEquals (optypearsoncrs4.Pearson_Course_Structure__c, cluster2.Id);        
                
        Test.stopTest();
    }
}