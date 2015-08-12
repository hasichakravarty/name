@isTest
private class TestOrderTriggers
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
		
		Opportunity sOpportunity		= (Opportunity)TestClassAutomation.createSObject('Opportunity');
		sOpportunity.AccountId			= sAccount.Id;
		sOpportunity.StageName			= 'Prospecting';
		insert sOpportunity;
		
		
		
		Product2 sProduct 				= (Product2)TestClassAutomation.createSObject('Product2');
		sProduct.isActive				= true;
		insert sProduct;
		
		ActivityTemplate__c	sAT1 		= new ActivityTemplate__c();
		sAT1.Related_To__c				= 'Order';
		sAT1.Status__c					= 'New';
		sAT1.Subject__c					= 'Test activity 1';
		sAT1.Description__c				= 'Test description 1';
		sAT1.Active__c					= true;
		sAT1.NPS_Rating_Required__c		= true;
		sAT1.Days_Until_Due__c			= 10;
		sAT1.Account_Location__c		= 'Australia';
		sAT1.Product_Type__c 			= sProduct.ProductType__c;
		insert sAT1;
		
		ActivityTemplate__c	sAT2 		= new ActivityTemplate__c();
		sAT2.Related_To__c				= 'Order';
		sAT2.Status__c					= 'Approved';
		sAT2.Subject__c					= 'Test activity 2';
		sAT2.Description__c				= 'Test description 2';
		sAT2.Active__c					= true;
		sAT2.NPS_Rating_Required__c		= true;
		sAT2.Days_Until_Due__c			= 10;
		sAT2.Account_Location__c		= 'Australia';
		sAT2.Product_Type__c 			= sProduct.ProductType__c;
		insert sAT2;
		
		Test.startTest();
		
			Order__c	sOrder				= (Order__c)TestClassAutomation.createSObject('Order__c');
			sOrder.Account__c				= sAccount.Id;
			sOrder.Opportunity__c			= sOpportunity.Id;
			sOrder.Status__c				= 'New';
			
			insert sOrder;
			
			OrderLineItem__c sOLI			= new OrderLineItem__c();
			sOLI.Order__c 					= sOrder.Id;
			sOLI.Product__c					= sProduct.Id;
			sOLI.ItemQuantity__c			= 10;
			insert sOLI;
			
			sAccount.External_Account_Number__c = '1234567';
			sAccount.Account_Status__c			= 'A';
			update sAccount;
			
			sOrder.Status__c					= 'Approved';
			update sOrder;
			
			delete sOrder;
			
			undelete sOrder;
		
		Test.stopTest();
	}
}