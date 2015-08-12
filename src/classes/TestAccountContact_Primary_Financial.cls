/*******************************************************************************************************************
* Apex Class Name   :TestAccountContact_Primary_Financial
* Created Date      : 8 MAY 2014
* Description       : Test class for AccountContact_Primary_Financial class
*******************************************************************************************************************/
@isTest
private class TestAccountContact_Primary_Financial
{
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
        Contact sContact                = (Contact)TestClassAutomation.createSObject('Contact');
        sContact.AccountId              = sAccount.Id;
        sContact.OtherCountry           = 'Australia';
        sContact.OtherState             = 'Victoria';
        sContact.OtherCountryCode       = 'AU';
        sContact.OtherStateCode         = 'VIC';
        sContact.MailingCountry         = 'Australia';
        sContact.MailingState           = 'Victoria';
        sContact.MailingCountryCode     = 'AU';
        sContact.MailingStateCode       = 'VIC';
            
        Test.startTest();
            
            insert sContact;
            
        checkRecurssion.run = true;    
        AccountContact__c accContObj = new AccountContact__c();
        accContObj.Contact__c = sContact.id;
        accContObj.Account__c = sAccount.id;
        accContObj.AccountRole__c='Learner';
        accContObj.primary__c=false;
        accContObj.Sync_In_Progress__c=false;
        insert accContObj;
       //  AccountContact__c sAccountContact  = new AccountContact__c(account__c=sAccount.Id,contact__c=sContact.Id,Primary__c=true,AccountRole__c='Learner');        
         // insert sAccountContact; 
         AccountContact__c sAccountContact = [Select Id FROM AccountContact__c WHERE Contact__c = : sContact.Id limit 1];
         AccountContactRole sAccountConRole = [Select Id FROM AccountContactRole WHERE Contactid = : sContact.Id limit 1];

            checkRecurssion.run = true;       
            update sAccountContact;
            checkRecurssion.run = true; 
                        
            delete sAccountContact;
            delete sAccountConRole;
           checkRecurssion.run = true;    

           undelete sAccountContact;
        
        Test.stopTest();
    }
  /* Static testmethod void myUnitTest_1(){
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
        
        Contact sContact                = (Contact)TestClassAutomation.createSObject('Contact');
        sContact.AccountId              = sAccount.Id;
        sContact.OtherCountry           = 'Australia';
        sContact.OtherState             = 'Victoria';
        sContact.OtherCountryCode       = 'AU';
        sContact.OtherStateCode         = 'VIC';
        sContact.MailingCountry         = 'Australia';
        sContact.MailingState           = 'Victoria';
        sContact.MailingCountryCode     = 'AU';
        sContact.MailingStateCode       = 'VIC';
            
        Test.startTest();
            
           insert sContact;
         AccountContact__c sAccountContact  = new AccountContact__c(account__c=sAccount.Id,contact__c=sContact.Id,Primary__c=true,AccountRole__c='Learner');        
          insert sAccountContact; 
        // AccountContact__c sAccountContact = [Select Id FROM AccountContact__c WHERE Contact__c = : sContact.Id limit 1];
                    
         Test.stopTest();
            
     }  */
}