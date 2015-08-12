@isTest 
private class TestAutoCreateJunction
{
	static testMethod void OpportunityCallTests()
	{
		 id pid=[select id from profile where name='System Administrator'].id;
         User u = new User(Alias = 'standt', Email='standarduser11@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = pid, Sample_Approval__c= true,
            TimeZoneSidKey='America/Los_Angeles', UserName='test12345'+Math.random()+'@gmail.com', Geography__c = 'Growth',Market__c = 'ZA',Line_of_Business__c = 'Higher Ed');
          insert u; 
         
    system.runas(u) {
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
        sContact.FirstName				='Test';
        sContact.LastName				='Test';
		sContact.MailingCountry			= 'Australia';
		sContact.MailingState			= 'Victoria';
		sContact.MailingCountryCode		= 'AU';
		sContact.MailingStateCode		= 'VIC';
		sContact.OtherCountry			= 'Australia';
		sContact.OtherState				= 'Victoria';
		sContact.OtherCountryCode		= 'AU';
		sContact.OtherStateCode			= 'VIC';
        sContact.Email					= 'Test@Test.com';
		
		insert sContact;
		
		Call__c sCall					= (Call__c)TestClassAutomation.createSObject('Call__c');
		sCall.Account__c				= sAccount.Id;
		sCall.Call_Start_Time__c		= system.now();
		sCall.Call_End_Time__c			= system.now().addHours(1);
		insert sCall;
		
		Opportunity sOpportunity				= (Opportunity)TestClassAutomation.createSObject('Opportunity');
		sOpportunity.AccountId					= sAccount.Id;
		sOpportunity.StageName					= 'Prospecting';
		sOpportunity.Re_engagement_Date__c		= system.today().addMonths(1);
		sOpportunity.Renewal_Date__c			= system.today().addMonths(12);
		insert sOpportunity;
		
		
		Test.startTest();
			
			PageReference page1 = Page.AutoCreateJunction;
			Test.setCurrentPage(page1);
			ApexPages.currentPage().getParameters().put('newid', sCall.Id);
			ApexPages.currentPage().getParameters().put('originalid', sOpportunity.Id);
		
			AutoCreateJunctionController controller = new AutoCreateJunctionController();
			controller.createJunctionandredirect();
			
			PageReference page2 = Page.AutoCreateJunction;
			Test.setCurrentPage(page2);
			ApexPages.currentPage().getParameters().put('originalid', sCall.Id);
			ApexPages.currentPage().getParameters().put('newid', sOpportunity.Id);
			
			AutoCreateJunctionController controller2 = new AutoCreateJunctionController();
			controller2.createJunctionandredirect();
			
		Test.stopTest();
    		}   
	}

}