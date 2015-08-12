@isTest
private class TestTestClassAutomation
{
	static
	{
		TestClassAutomation.FillAllFields = true; // increase test coverage without creating custom objects
	}

	static testMethod void createsSingleObjectWithSingleRequiredStringField()
	{
		Account account = (Account)TestClassAutomation.createSObject('Account');
	}

	static testMethod void createsObjectWithoutCascadeDoesNotSetLookupField()
	{
		Contact contact = (Contact)TestClassAutomation.createSObject('Contact', false);
		System.assert(contact.AccountId == null);
	}

	static testMethod void createObjectWithUnsupportedTypeThrowsException()
	{
		try
		{
			TestClassAutomation.createSObject('Unsupported');
			System.assert(false);
		}
		catch (TestClassAutomation.UnsupportedObjectTypeException ex)
		{
			System.assert(true);
		}
	}

	static testMethod void creating401UniqueRecords()
	{
		List<SObject> contactsAsSObjects = TestClassAutomation.createSObjectList('Contact', false, 50);
	}
}