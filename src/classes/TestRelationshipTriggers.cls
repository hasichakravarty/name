@isTest
private class TestRelationshipTriggers
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
        
        Account sAccount2               = (Account)TestClassAutomation.createSObject('Account');
        sAccount2.BillingCountry        = 'Australia';
        sAccount2.BillingState          = 'Victoria';
        sAccount2.BillingCountryCode    = 'AU';
        sAccount2.BillingStateCode      = 'VIC';
        sAccount2.ShippingCountry       = 'Australia';
        sAccount2.ShippingState         = 'Victoria';
        sAccount2.ShippingCountryCode   = 'AU';
        sAccount2.ShippingStateCode     = 'VIC';
        
        insert sAccount2;
        
        Test.startTest();
        
            Relationship__c  sRelationship      = (Relationship__c)TestClassAutomation.createSObject('Relationship__c');
            sRelationship.Account__c            = sAccount.Id;
            sRelationship.Related_To__c         = sAccount2.Id;
            sRelationship.RelationshipClone__c  = null;
            
            insert sRelationship;
            
            sRelationship.Type__c               = 'Campus';
            
            //update sRelationship;
            
            delete sRelationship;
            
            undelete sRelationship;
        
        Test.stopTest();
    }
}