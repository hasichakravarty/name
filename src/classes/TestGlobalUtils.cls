@isTest
private class TestGlobalUtils
{
	static testMethod void myUnitTest()
	{
		Test.startTest();
		
			// Call Record Type Map
			map<string, string> mapRecordTypes	= GlobalUtils.getMapRecordTypes(new list<string>{'Account', 'Contact'});
			
			// Call Profiles Map
			map<string, string> mapProfiles		= GlobalUtils.getprofiles();
		
			// Call Custom Debug
			GlobalUtils.Debug('String');
			
			// Call Error String
			GlobalUtils.AddError('Error');
			
			// Call Warning String
			GlobalUtils.AddWarning('Warning');
			
			// Call Info String
			GlobalUtils.AddInfo('Info');
						
		Test.stopTest();
	}
}