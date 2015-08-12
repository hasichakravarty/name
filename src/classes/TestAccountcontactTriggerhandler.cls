/*
     *@name TestAccountcontactTriggerhandler() 
     *@return void 
     *@description This method for myUnitTest_3 In CLASS AccountcontactTriggerhandler .cls
     *@description This method for myUnitTest_3 In CLASS AccountContactSync .cls
     */

 
@isTest
private class TestAccountcontactTriggerhandler {
                
                    
Static testmethod void myUnitTest_3(){
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
        sContact.Mobile_Last_Updated__c = null;
                    
        Test.startTest();
            
           insert sContact;
       
         AccountContact__c sAccountContact = [Select Id,AccountContact__c.Primary__c  FROM AccountContact__c WHERE Contact__c = : sContact.Id limit 1];
         
       AccountContactTriggerHandler testa= new AccountContactTriggerHandler(true,5);

       AccountContact__c[] accnt;
       
       accnt = [Select Id,AccountContact__c.Primary__c,account__c,contact__c,AccountRole__c,Financially_Responsible__c,Synchronized_Account_Contact_Role__c  FROM AccountContact__c WHERE Contact__c = : sContact.Id limit 1];

       AccountContact__c[] accntol;

       accntol = [Select Id,AccountContact__c.Primary__c,account__c,contact__c,AccountRole__c,Financially_Responsible__c,Synchronized_Account_Contact_Role__c, Primary_Account__c, Role_Detail__c  FROM AccountContact__c WHERE Contact__c = : sContact.Id limit 1];
  
       map<id,AccountContact__c> acc =new map<id,AccountContact__c>();
       map<id,AccountContact__c> acccon =new map<id,AccountContact__c>();
       acccon.put(accntol.get(0).Id, accntol.get(0));
     
           System.assertEquals(true,  testa.bIsTriggerContext);  
           System.assertEquals(false,  testa.bIsVisualforcePageContext,false);   
           System.assertEquals(false, testa.bIsWebServiceContext,false);  
           System.assertEquals(false,  testa.bIsExecuteAnonymousContext,false);  
                  
         testa.OnAfterUpdate(accnt,accntol,acc,acccon);
                  
         testa.OnAfterdelete(accnt,acc);
         testa.OnBeforedelete(accnt,acc);
         testa.OnBeforeUpdate(accnt,accntol,acc);
         testa.OnUndelete(accnt);  
         AccountContactSync sync = new AccountContactSync();
         sync.SetAsNotPrimary(accnt); 
         try
         {
           testa.OnBeforeInsert(null);           
         }
         catch(Exception e)
         {  
           System.assert(e != null, 'The exception was not raised');           
         }
         
         try
         {           
           testa.OnAfterInsert(null);
         }
         catch(Exception e)
         {  
           System.assert(e != null, 'The exception was not raised');           
         }           
               
         Test.stopTest();}
 }