@isTest
public with sharing class TestProductTrigger {

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
		
		insert sOpportunity;
		
		Order__c sOrder					= (Order__c)TestClassAutomation.createSObject('Order__c');
		sOrder.Account__c				= sAccount.Id;
		sOrder.Opportunity__c			= sOpportunity.Id;
		
		insert sOrder;
		
		Product2 sProduct 				= (Product2)TestClassAutomation.createSObject('Product2');
		insert sProduct;
			
		Test.startTest();
		
			OrderLineItem__c sOLI		= (OrderLineItem__c)TestClassAutomation.createSObject('OrderLineItem__c');
			sOLI.Order__c				= sOrder.Id;
			sOLI.Product__c				= sProduct.Id;
			
			insert sOLI;
			
			update sOLI;
			
			delete sOLI;
			
			undelete sOLI;
			
			sProduct.isActive			= !sProduct.isActive;  
			
			update sProduct;
			
			delete sProduct;
			
			undelete sProduct;
			
			sOLI = [SELECT Id, Is_Active_Product__c FROM OrderLineItem__c where Id =: sOLI.Id];
			System.assert(sOLI.Is_Active_Product__c == sProduct.isActive);
		
		Test.stopTest();
	}
}