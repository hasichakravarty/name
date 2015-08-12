@isTest
private class TestAccountTriggers
{
    static testMethod void myUnitTest()
    {
        Test.startTest();
        
        // TO DO: implement unit test
        
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
        sAccount.Territory_Code_s__c = '2PD';
        sAccount.High_Grade__c           = '1 Acc';
        insert sAccount;
       
     
        
        
        delete sAccount;
        
        undelete sAccount;
        
        Test.stopTest();
    }
    
  }