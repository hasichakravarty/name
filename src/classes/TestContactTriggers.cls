@isTest
private class TestContactTriggers
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
		
		Test.startTest();
			
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
			
			update sContact;
			
			delete sContact;
			
			undelete sContact;
		
		Test.stopTest();
	}
}