/*
         *@name TestAccountContactTriggers() 
         *@return void 
         *@description This method for myUnitTest In CLASS AccountcontactTriggerhandler .cls
         *@description This method for myUnitTest In trigger AccountContact.Triggers
         */



    @isTest
    private class TestAccountContactTriggers
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
            
            Contact sContact                = (Contact)TestClassAutomation.createSObject('Contact');
            sContact.AccountId              = sAccount.Id;
            sContact.OtherCountry           = 'Australia';
            sContact.Role__c                   = 'Educator';
            sContact.Role_Detail__c         = 'Director';
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
            accContObj.AccountRole__c= 'Educator';
            accContObj.Role_Detail__c= 'Director';
            insert accContObj;

             checkRecurssion.run = true; 
            accContObj.Role_Detail__c= 'Dean';
            update accContObj;

                checkRecurssion.run = true; 
            delete accContObj;

            


            
             
                
    AccountContactTriggerHandler testa= new AccountContactTriggerHandler(true,5);
     

     AccountContact__c[] accnt;
     
    //accnt = [Select Id,AccountContact__c.Primary__c,account__c,contact__c,AccountRole__c,Financially_Responsible__c  FROM AccountContact__c WHERE Contact__c = : sContact.Id limit 1];
                // testa.OnBeforeInsert(accnt);
                
    //if(accnt!=null){         testa.OnAfterInsert(accnt);}
                 
            Test.stopTest();
        }
       Static testmethod void myUnitTest_1(){
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
            sContact.Role__c                = 'Educator';
            sContact.Role_Detail__c         = 'Director';
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
             accContObj.AccountRole__c= 'Educator';
            accContObj.Role_Detail__c= 'Director';
            insert accContObj;

             checkRecurssion.run = true; 
            accContObj.Role_Detail__c= 'Dean';
            update accContObj;
            
            checkRecurssion.run = true; 
            delete accContObj;


            
           
             //AccountContact__c sAccountContact = [Select Id,AccountContact__c.Primary__c,account__c,contact__c,AccountRole__c,Financially_Responsible__c FROM AccountContact__c WHERE Contact__c = : sContact.Id limit 1];
             
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