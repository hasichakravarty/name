@isTest
private class TestEventTriggers
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
		
			Event sEvent					= (Event)TestClassAutomation.createSObject('Event');
			sEvent.WhatId					= sAccount.Id;
			sEvent.WhoId					= null;
			sEvent.ActivityDateTime			= system.now();
			sEvent.StartDateTime			= sEvent.ActivityDateTime;
			sEvent.EndDateTime				= system.now().addHours(1);
			sEvent.DurationInMinutes		= null;
			sEvent.IsRecurrence				= false;
			sEvent.RecurrenceStartDateTime	= null;
			sEvent.RecurrenceEndDateOnly	= null;
			sEvent.RecurrenceInterval		= null;
			sEvent.RecurrenceDayOfWeekMask	= null;
			sEvent.RecurrenceDayOfMonth		= null;
			sEvent.RecurrenceMonthOfYear	= null;
			sEvent.RecurrenceInstance		= null;
			sEvent.RecurrenceEndDateOnly	= null;
			sEvent.RecurrenceType			= null;
			sEvent.RecurrenceTimeZoneSidKey	= null;
			insert sEvent;
			
			update sEvent;
			
			delete sEvent;
			
			undelete sEvent;
		
		Test.stopTest();
	}
}