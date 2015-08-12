@isTest
private class TestLeadTriggers
{
	static testMethod void myUnitTest()
	{
		Test.startTest();
		
		// TO DO: implement unit test
		
		TestClassAutomation.FillAllFields = true;
		
		Lead sLead				= (Lead)TestClassAutomation.createSObject('Lead');
		sLead.Country			= 'Australia';
		sLead.CountryCode		= 'AU';
		sLead.State				= 'Victoria';
		sLead.StateCode			= 'VIC';
		
		insert sLead;
		
		update sLead;
		
		delete sLead;
		
		undelete sLead;
		
		Test.stopTest();
	}
}