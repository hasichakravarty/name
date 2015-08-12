@isTest (seeAllData=true)
private class TestOpportunityLineItemTriggers
{
	static testMethod void myUnitTest()
	{
		
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
		
		Opportunity sOpportunity				= (Opportunity)TestClassAutomation.createSObject('Opportunity');
		sOpportunity.AccountId					= sAccount.Id;
		sOpportunity.RecordTypeId               = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Opportunity').getRecordTypeId();
		
		insert sOpportunity;
		
		Product2 sProduct						= (Product2)TestClassAutomation.createSObject('Product2');
		insert sProduct;

		Pricebook2 sPriceBook = [select id, name, isActive from Pricebook2 where IsStandard = true limit 1];
		sPriceBook.IsActive = true;
		update sPriceBook;
		
		PriceBookEntry sPriceBookEntry			= (PriceBookEntry)TestClassAutomation.createSObject('PriceBookEntry');
		sPriceBookEntry.IsActive				= true;
		sPriceBookEntry.Product2Id				= sProduct.Id;
		sPriceBookEntry.Pricebook2Id			= sPriceBook.Id;
		sPriceBookEntry.UnitPrice				= 34.95;
		insert sPriceBookEntry;
		
		Pricebook2 sPriceBookANZ = [select id from Pricebook2 where Name like 'ANZ%' limit 1];
		sPriceBookANZ.IsActive = true;
		update sPriceBookANZ;
		
		PriceBookEntry sPriceBookEntry1			= (PriceBookEntry)TestClassAutomation.createSObject('PriceBookEntry');
		sPriceBookEntry1.IsActive				= true;
		sPriceBookEntry1.Product2Id				= sProduct.Id;
		sPriceBookEntry1.Pricebook2Id			= sPriceBookANZ.Id;
		sPriceBookEntry1.UnitPrice				= 34.95;
		sPriceBookEntry1.UseStandardPrice       = false;
		insert sPriceBookEntry1;
		
		Test.startTest();
		
			OpportunityLineItem sOLI			= new OpportunityLineItem();
			sOLI.OpportunityId					= sOpportunity.Id;
			sOLI.PricebookEntryId				= sPriceBookEntry1.Id;
			sOLI.TotalPrice						= 200;
			sOLI.Quantity						= 1;
			
			system.debug('sOLI:::' + sOLI);
			insert sOLI;
			
			update sOLI;
			
			delete sOLI;
		
		Test.stopTest();
	}
	
	static testMethod void myUnitTest_Delete()
	{
		
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
		
		Opportunity sOpportunity				= (Opportunity)TestClassAutomation.createSObject('Opportunity');
		sOpportunity.AccountId					= sAccount.Id;
		sOpportunity.RecordTypeId               = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('B2B').getRecordTypeId();
		
		insert sOpportunity;
		
		Product2 sProduct						= (Product2)TestClassAutomation.createSObject('Product2');
		insert sProduct;

		Pricebook2 sPriceBook = [select id, name, isActive from Pricebook2 where IsStandard = true limit 1];
		sPriceBook.IsActive = true;
		update sPriceBook;
		
		PriceBookEntry sPriceBookEntry			= (PriceBookEntry)TestClassAutomation.createSObject('PriceBookEntry');
		sPriceBookEntry.IsActive				= true;
		sPriceBookEntry.Product2Id				= sProduct.Id;
		sPriceBookEntry.Pricebook2Id			= sPriceBook.Id;
		sPriceBookEntry.UnitPrice				= 34.95;
		insert sPriceBookEntry;
		
		Test.startTest();
		
			OpportunityLineItem sOLI			= new OpportunityLineItem();
			sOLI.OpportunityId					= sOpportunity.Id;
			sOLI.PricebookEntryId				= sPriceBookEntry.Id;
			sOLI.TotalPrice						= 200;
			sOLI.Quantity						= 1;
			
			system.debug('sOLI:::' + sOLI);
			
			insert sOLI;
			
			update sOLI;

            Special_Price_Request__c objspecial = new Special_Price_Request__c(Opportunity__c = sOpportunity.id, Request_Type__c = 'Valuepack with MyLab / Mastering Access Code',Status__c = 'New',
                          included_the_Account_Numbers_for_every_S__c = 'No',Is_this_a_Renewal__c = 'No');
            insert objspecial;

			
			Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
            User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
                              EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                              LocaleSidKey='en_US', ProfileId = p.Id,
                              UserName='standarduserfortestingOLIDelete@testorg.com',
                              TimeZoneSidKey='America/Los_Angeles',
                              Line_of_Business__c = 'Higher Ed',
                              Market__c = 'US');
     
      System.runAs(u) {
          try{
             delete sOLI;
          }catch(Exception e){
              system.debug(' pending special price list request error');
          }
      }

		Test.stopTest();
	}
	
}