@IsTest

Public class TestCaseCommissionSharing {
    static testmethod void insertCase() {
        RecordType FinanceWorkflowRecordType = [select id from RecordType where DeveloperName='Finance_Workflow' limit 1];
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User manMan = new User(Alias = 'manMan', Email='manman@testorg.com', 
         EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
         LocaleSidKey='en_US', ProfileId = p.Id, 
         TimeZoneSidKey='America/Los_Angeles', UserName='manman@testorg.com');
        insert manMan;
        User man = new User(Alias = 'man', Email='man@testorg.com', 
         EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
         LocaleSidKey='en_US', ProfileId = p.Id, 
         TimeZoneSidKey='America/Los_Angeles', UserName='man@testorg.com', ManagerId=manMan.id);
        insert man;
        User dm = new User(Alias = 'dm', Email='dm@testorg.com', 
         EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
         LocaleSidKey='en_US', ProfileId = p.Id, 
         TimeZoneSidKey='America/Los_Angeles', UserName='dm@testorg.com', ManagerId=man.id);
        insert dm;
        User rep = new User(Alias = 'rep', Email='rep@testorg.com', 
         EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
         LocaleSidKey='en_US', ProfileId = p.Id, 
         TimeZoneSidKey='America/Los_Angeles', UserName='rep@testorg.com', ManagerId=dm.id);
        insert rep;
         
        //User SalesRep = [select id from User Limit 1];
        Case c = new Case();
        c.RecordTypeId = FinanceWorkflowRecordType.id; 
        c.OwnerId = dm.id;      
        c.Sales_Rep_Name__c = rep.id;
       
        insert c;
    }
 }