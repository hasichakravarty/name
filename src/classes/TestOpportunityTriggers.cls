@isTest
private class TestOpportunityTriggers
{
    static testMethod void myUnitTest()
    {

        TestClassAutomation.FillAllFields = true;
        
        Account sAccount                = (Account)TestClassAutomation.createSObject('Account');
        sAccount.BillingCountry         = 'Australia';
        sAccount.BillingState           = 'Victoria';
        sAccount.BillingCountryCode     = 'AU';
        sAccount.BillingStateCode       = 'VIC';
        sAccount.ShippingCountry        = 'Australia';
        sAccount.ShippingState          = 'Victoria';
        sAccount.ShippingCountryCode    = 'AU';
        sAccount.ShippingStateCode      = 'VIC';
        
        insert sAccount;
        
        ActivityTemplate__c sAT1        = new ActivityTemplate__c();
        sAT1.Related_To__c              = 'Opportunity';
        sAT1.Status__c                  = 'On Schedule';
        sAT1.Stage__c                   = 'Prospecting';
        sAT1.Subject__c                 = 'Test opportunity activity';
        sAT1.Description__c             = 'Test opportunity activity';
        sAT1.Active__c                  = true;
        sAT1.NPS_Rating_Required__c     = true;
        sAT1.Days_Until_Due__c          = 10;
        sAT1.Account_Location__c        = 'Australia';
        insert sAT1;
        
        ActivityTemplate__c sAT2        = new ActivityTemplate__c();
        sAT2.Related_To__c              = 'Opportunity';
        sAT2.Status__c                  = 'On Schedule';
        sAT2.Stage__c                   = 'Invoiced';
        sAT2.Subject__c                 = 'Test opportunity activity 2';
        sAT2.Description__c             = 'Test opportunity activity 2';
        sAT2.Active__c                  = true;
        sAT2.NPS_Rating_Required__c     = true;
        sAT2.Days_Until_Due__c          = 10;
        sAT2.Account_Location__c        = 'Australia';
        insert sAT2;
        
        Test.startTest();
    
        Opportunity sOpportunity        = (Opportunity)TestClassAutomation.createSObject('Opportunity');
        sOpportunity.AccountId          = sAccount.Id;
        sOpportunity.StageName          = sAT1.Stage__c;
        sOpportunity.Status__c          = sAT1.Status__c;
        //sOpportunity.Registration_Payment_Reference1__c = true;
       //sOpportunity.Received_Signed_Registration_Contract__c = true;
        insert sOpportunity;
        
        sOpportunity.StageName                  = 'Invoiced';
        sOpportunity.Renewal_Date__c            = system.today().addmonths(8);
        sOpportunity.Re_engagement_Date__c      = system.today().addmonths(1);
        update sOpportunity;
        
        
        Opportunity sClosedInsert           = new opportunity(Name='Test', CloseDate=system.today());
        
        sClosedInsert.AccountId             = sAccount.Id;
        sClosedInsert.StageName             = 'In Production';
        sClosedInsert.Re_engagement_Date__c = system.today().addMonths(1);
        sClosedInsert.Renewal_Date__c       = system.today().addMonths(12);
        insert sClosedInsert;
        
        sClosedInsert.StageName = 'Prospecting';
        update sClosedInsert;
        sClosedInsert.StageName = 'In Production';
        sClosedInsert.Student_Registered__c = true;
        sClosedInsert.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('D2L').getRecordTypeId(); 
        update sClosedInsert;
        
        
        OpportunityTriggerHandler handler = new OpportunityTriggerHandler(true,1);
        
        Boolean bIsTriggerContext = handler.bIsTriggerContext;
        Boolean bIsVisualforcePageContext = handler.bIsVisualforcePageContext;
        Boolean bIsWebServiceContext = handler.bIsWebServiceContext;
        Boolean bIsExecuteAnonymousContext = handler.bIsExecuteAnonymousContext;
        
        delete sOpportunity;
        
        undelete sOpportunity;
    
        Test.stopTest();
    }   
    static testMethod void myUnitTest2()
    {
        TestClassAutomation.FillAllFields = true;
        
        Account sAccount                = (Account)TestClassAutomation.createSObject('Account');
        sAccount.BillingCountry         = 'Australia';
        sAccount.BillingState           = 'Victoria';
        sAccount.BillingCountryCode     = 'AU';
        sAccount.BillingStateCode       = 'VIC';
        sAccount.ShippingCountry        = 'Australia';
        sAccount.ShippingState          = 'Victoria';
        sAccount.ShippingCountryCode    = 'AU';
        sAccount.ShippingStateCode      = 'VIC';
        
        insert sAccount;
        Test.startTest();
    
        Opportunity sOpportunity        = (Opportunity)TestClassAutomation.createSObject('Opportunity');
        sOpportunity.AccountId          = sAccount.Id;
        sOpportunity.StageName          = 'In Production';
       // sOpportunity.Status__c          = sAT1.Status__c;
        sOpportunity.Registration_Payment_Reference1__c = true;
        sOpportunity.Received_Signed_Registration_Contract__c = true;
        insert sOpportunity;
        Test.stopTest();
    }
}