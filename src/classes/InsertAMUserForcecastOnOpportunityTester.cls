/*
Name: Shashi Kantharaj & Steven M. Giangrasso
Description: This is the test class for the InsertAMUserForecastOnOpportunity.trigger that assigns the user
to the AM_User_Forecast__c custom object
Date: Tuesday, October 9th, 2012
*/

//annotation used at the start of all test classes
@isTest
private class InsertAMUserForcecastOnOpportunityTester{
    
    /* AA (Deloitte) - Deactivated as UK Users not onboarded yet
 
 	//testMethod for the Trigger
    static testMethod void testInsertAMOnOpportunity(){
 
        //Start the test
        test.startTest();
        
		        //Retrieve the Profile ID for the User Instantiation with the following code
		        Profile p = [SELECT Id FROM profile WHERE name='Standard User'];
		        
		        //Populate the AMUser object with the necessary details of the fields from the User
		        user AMUser= new user(Alias='testln',Email='x.y@pearson.com',EmailEncodingKey='UTF-8',LanguageLocaleKey='en_US',LastName='TestLN',
		        LocaleSidKey='en_US',ProfileId=p.id,TimeZoneSidKey='Europe/Lisbon',Username='x.y@pearson.com.testclass');
		        
		        //Create an Object for the user record
		        Database.SaveResult srUser = Database.insert(AMUser, false);
		        
		        //retrieve the ID of the user to populate the constructor of the UserForecast object below
		        id AMUserId = srUser.getId();
		        
		        
		        //Instantiate the UserForecast__c object and add the necessary fields to the Constructor
		        UserForecast__c uforecast = new UserForecast__c (User__c = AMUserId, YTDSales__c = 20000,YTDTarget__c = 500000);
		        //Insert a UserForecast__c record
		        insert uforecast;
		        
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
		        //Insert the Account record
		        insert acct;
		        
		        //Instantiate the Opportunity and populate the required fields
		        Opportunity o = new Opportunity(Name='Test Opportunity',Account = acct, StageName = 'Identification', CloseDate = System.Today(),RecordTypeId = OptyRecordTypeId, OwnerId = AMUserId );
		        Database.SaveResult srOpp = Database.insert(o, false);
		        id oppId = srOpp.getId();
		        //System.assertEquals (oppId, '006L0000002FMJD');
		 
		        Opportunity opty_1 =  [ select Id,AM_User_Forecast__c from Opportunity where id=:oppId limit 1];
		        //UserForecast__c ufc = [select Id from UserForecast__c where User__c = :AMUserId limit 1];
		        System.assertEquals(uforecast.Id,opty_1.AM_User_Forecast__c);
		         
		         
		        Opportunity oppToUpdate = [select Id, Name from Opportunity where id=:oppId limit 1];
		        oppToUpdate.Name='Test Opportunity Update';
		        //oppToUpdate.OwnerId = '005L0000000Ni1V';
        		//Assign the OwnerId of the Opportunity to update to the UserId of the UserForecast__c object
                oppToUpdate.OwnerId = uforecast.User__c;
        
        		//Send a DML update to update the Opportunity
        		update oppToUpdate;
        
        
        */
        /*
        Setting the Close Date to Less than 10 days from today 
		to cover the possibility where the Opportunity ID/Contact Role/Contact ID are not in the map
		*/		
		/* AA (Deloitte) - Deactivated as UK Users not onboarded yet
 
 		Opportunity o2 = new Opportunity(Name='OppCntNull', StageName='Prospecting', CloseDate=Date.Today().addDays(-10));

						//Setting the Primary Contact Lookup to Null to cover the scenario where their is no Contact
						o2.Primary_Contact__c = null;
						o2.AccountId = acct.Id;

							//Insert the Opportunity
							Database.SaveResult sr2 = database.insert(o2,false);
							*/
							/*returns the id of the Opportunity that was saved in the Database.SaveResult
							http://www.salesforce.com/us/developer/docs/apexcode/Content/apex_dml_insert.htm
							*/
							/* AA (Deloitte) - Deactivated as UK Users not onboarded yet
 
 							id newoppid2 = sr2.getId();

					
					o2 = [Select Name, Primary_Contact__c from Opportunity where id = :newoppid2];
					*/
					/*
					Used the System.assertNotEquals method to cover the null insert for the Primary Contact Lookup
					
					http://apex-lang.googlecode.com/svn-history/r116/trunk/eclipse-project/src/classes/DatabaseUtilsTest.cls
									
					*/
					/* AA (Deloitte) - Deactivated as UK Users not onboarded yet
 
 					System.assertNotEquals(o2.Primary_Contact__c, 'Banana');

		//Update the 2nd Opportunity 
		update o2;
		
		//Stop the Test
        test.stopTest();
 
    }*/
}