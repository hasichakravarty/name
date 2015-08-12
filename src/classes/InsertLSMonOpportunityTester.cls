/*
Description: Test Class for InsertLSMonOpportunity Trigger
*/

//Annotation used in every Test class on Opportunities
@isTest
private class InsertLSMonOpportunityTester{
    /* AA (Deloitte) - Deactivated as UK Users not onboarded yet
 
 	static testMethod void testInsertLSMonOpportunity(){
 
        //Start the test
        test.startTest();
        
        //Retrieve the Profile ID for the User Instantiation with the following code
        Profile p = [SELECT Id FROM profile WHERE name='Standard User'];
        
        //Populate the lsmUser object with the necessary details of those fields
        user lsmUser= new user(Alias='testln',Email='robert.power@pearson.com',EmailEncodingKey='UTF-8',LanguageLocaleKey='en_US',LastName='TestLN',
        LocaleSidKey='en_US',ProfileId=p.id,TimeZoneSidKey='America/New_York',Username='robert.power@pearson.com.testclass');
        
        //Create an Object for the user record
        Database.SaveResult srUser = Database.insert(lsmUser, false);
        //retrieve the ID of the user to populate the OpportunityTeamMember constructor below
        id lsmUserId = srUser.getId();
        
        String AcctRecordTypeId;
        String DiscRecordTypeId;
        String ClusterRecordTypeId;
        String OptyRecordTypeId; 
        
        List<RecordType> RecordTypeList = new List<RecordType>([select Id,Name from RecordType]);
        for (RecordType i : RecordTypeList) {
          if (i.Name == 'Bookshop') {
            AcctRecordTypeId = i.Id;
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
        
        //Instantiate the Account and populate the required fields        
        Account acct = new Account (name = 'Test1', BillingStreet = 'Street1', BillingCity = 'London', BillingPostalCode = 'ABC DEF', BillingCountry = 'UK', Vista_Account_Number__c = 'xyz',RecordTypeId= AcctRecordTypeId); //'012E0000000Ll83');
        insert acct;
        
        //Instantiate the Opportunity and populate the required fields
        Opportunity o = new Opportunity(Name='Test Opportunity',Account = acct, StageName = 'Identification', CloseDate = System.Today(),RecordTypeId = OptyRecordTypeId);
        Database.SaveResult srOpp = Database.insert(o, false);
        id oppId = srOpp.getId();
        
        //Instantiate the OpportunityTeamMember and populate the required fields
        OpportunityTeamMember otm = new OpportunityTeamMember(UserId=lsmUserId, OpportunityId=oppId, teammemberrole = 'Learning Solutions');
        insert otm;
        
        
        Opportunity oppToUpdate = [select Id, Name from Opportunity where id=:oppId limit 1];
        oppToUpdate.Name='Test Opportunity Update';
        update oppToUpdate;
 
        //Stop the Test
        test.stopTest();
 
    }
    */
}