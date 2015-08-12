/*******************************************************************************************************************
* Apex Class Name   :TestAccountContactUtils
* Created Date      : 8 MAY 2014
* Description       : Test class for AccountContactUtils class
*******************************************************************************************************************/
@isTest
private class TestAccountContactUtils
{
  Static testmethod void myUnitTest_1(){
  AccountContact__c sAccountContact = new AccountContact__c();

         system.debug('entered unittest1');
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
        system.debug('cccc created account-->'+sAccount);
        Contact sContact                = (Contact)TestClassAutomation.createSObject('Contact');
        system.debug('cccc contact reference is created');
        sContact.AccountId              = sAccount.Id;
        sContact.OtherCountry           = 'Australia';
        sContact.OtherState             = 'Victoria';
        sContact.OtherCountryCode       = 'AU';
        sContact.OtherStateCode         = 'VIC';
        sContact.MailingCountry         = 'Australia';
        sContact.MailingState           = 'Victoria';
        sContact.MailingCountryCode     = 'AU';
        sContact.MailingStateCode       = 'VIC';
        System.debug('cccc before contact insert-->');
     //   List<Contact> sContact = testdatafactory.createContact(2);
            
        
            
           insert sContact;
         System.debug('contact inserted-->'+sContact);
         Test.startTest();
         //sAccountContact = [Select Id,AccountContact__c.Primary__c,account__c,contact__c,AccountRole__c,
         //Financially_Responsible__c FROM AccountContact__c WHERE Contact__c = : sContact.Id limit 1];
         
         sAccountContact = new AccountContact__c(account__c=sAccount.Id,contact__c=sContact.Id,Primary__c=true,AccountRole__c='Learner');
         insert sAccountContact;
         System.debug('Accountcontact inserted-->'+sAccountContact);
         system.assert(sAccountContact != null);
        
        AccountContactTriggerHandler testa= new AccountContactTriggerHandler(true,5);
        System.assertEquals(true,  testa.bIsTriggerContext);  
           System.assertEquals(false,  testa.bIsVisualforcePageContext,false);   
           System.assertEquals(false, testa.bIsWebServiceContext,false);  
           System.assertEquals(false,  testa.bIsExecuteAnonymousContext,false); 
 AccountContact__c[] accnt;
 accnt = [Select Id,AccountContact__c.Primary__c,account__c,contact__c,AccountRole__c,Financially_Responsible__c  FROM AccountContact__c WHERE Contact__c = : sContact.Id limit 1];

AccountContact__c[] accntol;
     map<id,AccountContact__c> acc =new map<id,AccountContact__c>();
     //acc = [Select Id,AccountContact__c.Primary__c,account__c,contact__c,AccountRole__c,Financially_Responsible__c  FROM AccountContact__c WHERE Contact__c = : sContact.Id limit 1];

     map<id,AccountContact__c> acccon =new map<id,AccountContact__c>();
    
     testa.OnBeforeinsert(accnt);

         
         
         Test.stopTest();
            
     }  
}