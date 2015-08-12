@isTest
private class TestCallAttendeeTriggers
{
	static testMethod void myUnitTest()
	{
		// TO DO: implement unit test
		
		TestClassAutomation.FillAllFields = true;
		
		Account sAccount				= (Account)TestClassAutomation.createSObject('Account');
		sAccount.BillingCountry			= 'Australia';
		sAccount.BillingState			= 'Victoria';
		sAccount.BillingCountryCode		= 'AU';
		sAccount.BillingStateCode		= 'VIC';
		sAccount.ShippingCountry		= 'Australia';
		sAccount.ShippingState			= 'Victoria';
		sAccount.ShippingCountryCode	= 'AU';
		sAccount.ShippingStateCode		= 'VIC';
		
		insert sAccount;
		
		Contact sContact				= (Contact)TestClassAutomation.createSObject('Contact');
		sContact.AccountId				= sAccount.ID;
		sContact.MailingCountry			= 'Australia';
		sContact.MailingState			= 'Victoria';
		sContact.MailingCountryCode		= 'AU';
		sContact.MailingStateCode		= 'VIC';
		sContact.OtherCountry			= 'Australia';
		sContact.OtherState				= 'Victoria';
		sContact.OtherCountryCode		= 'AU';
		sContact.OtherStateCode			= 'VIC';
		
		insert sContact;
	
		Call__c sCall					= (Call__c)TestClassAutomation.createSObject('Call__c');
		sCall.Account__c				= sAccount.Id;
		sCall.Call_Start_Time__c		= system.now();
		sCall.Call_End_Time__c			= system.now().addHours(1);
		
		insert sCall;
			
		Test.startTest();
			
			CallAttendee__c sCallAttendee			= (CallAttendee__c)TestClassAutomation.createSObject('CallAttendee__c');
			sCallAttendee.Call__c					= sCall.Id;
			sCallAttendee.Client__c					= sContact.Id;
			sCallAttendee.Pearson_Employee__c		= null; // You can only have one or the other
			
			insert sCallAttendee;
			
			update sCallAttendee;
			
			delete sCallAttendee;
			
			undelete sCallAttendee;
							
		Test.stopTest();
	}
}