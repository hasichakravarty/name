/*
Author: Steven M. Giangrasso
Date: 4/4/2012
Description: Test Class for Inserting Primary Contact Trigger
*/

//Annotation used in every Test class on Opportunities
@isTest
private class InsertPrimaryContactTester{
	/* AA (Deloitte) - Deactivated as UK Users not onboarded yet
	static testMethod void testInsertPrimaryContactonOpp(){
	 
	 
			//Start the test
			test.startTest();
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
	 
	/*Create an Account
	SMG 5/21/2012- Had to add Billing State to Contact instantiation to account for Billing State Validation Rule
	*/
	/* AA (Deloitte) - Deactivated as UK Users not onboarded yet
	 
	 Account a = new Account(Name='TestAccount',BillingStreet = 'Street1',
	                   BillingCity = 'ABD', BillingPostalCode = 'ABC DEF', BillingCountry = 'UK',
	                    Vista_Account_Number__c = 'xyz',RecordTypeId= AcctRecordTypeId );
	//insert a;
	 
	Database.Saveresult acctsr = database.insert(a,false);
	//http://www.salesforce.com/us/developer/docs/apexcode/Content/apex_dml_insert.htm
	id acctid = acctsr.getId();
	*/
	/*Create a Contact
	SMG 5/21/2012- Had to add Mailing State to Contact instantiation to account for Mailing State Validation Rule
	*/
	/* AA (Deloitte) - Deactivated as UK Users not onboarded yet
	 
	 Contact c = new Contact(firstname='Barack',lastname='Obama',accountid = a.id,email='test@cnn.com',MailingState='NY');
	insert c;
	 
	//Setup the Opportunity record
	String opportunityName = 'DSAImplementation';
	Opportunity o = new Opportunity();
	*/
	/*
	(contact__c = c.id, AccountID = a.Id, name = 'Opportunity Name',
	stagename='stagename',closedate=System.today());*/
	 /* AA (Deloitte) - Deactivated as UK Users not onboarded yet
	 
	 
	o.CloseDate = Date.today();
	o.Name = 'DSA';
	o.StageName='Prospecting';
	o.Primary_Contact__c = c.Id;
	o.AccountId = a.Id;
	//insert o;
	Database.SaveResult sr = database.insert(o,false);
	*/
	/*returns the id of the Opportunity that was saved in the Database.SaveResult
	http://www.salesforce.com/us/developer/docs/apexcode/Content/apex_dml_insert.htm
	*/
	/* AA (Deloitte) - Deactivated as UK Users not onboarded yet
	 
	 id newoppid = sr.getId();
	 
	o = [Select Name, Primary_Contact__c from Opportunity where id = :newoppid];
	 
	//Instantiate OpportunityContactRole object and insert all the required fields of the OpportunityContactRole object 
	OpportunityContactRole cnr = new OpportunityContactRole();
	cnr.Role = 'Engagement Sponsor';
	cnr.ContactId=c.Id;
	cnr.OpportunityId=newoppid;
	cnr.IsPrimary=true;
	 
	 Database.SaveResult srcnr = database.insert(cnr,false);
	 */
	/*returns the id of the Contact Role that was saved in the Database.SaveResult
	http://www.salesforce.com/us/developer/docs/apexcode/Content/apex_dml_insert.htm
	*/
	/* AA (Deloitte) - Deactivated as UK Users not onboarded yet
	 
	 id cnrid = srcnr.getId();
	//insert cnr; 
	 
	 
	 
	update o;
	 
	//Stop the Test
	test.stopTest();
	 
	}*/
}