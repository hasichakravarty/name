/*******************************************************************************************************************
* Apex Class Name   :TestprimarycheckonAccountContact 
* Created Date      : 6 MAY 2014
* Description       : Test class for primarycheckonAccountContact class
*******************************************************************************************************************/

@isTest  
private class TestprimarycheckonAccountContact{ 
    static testMethod void MyTest() {
    
    List<Account> accountList=TestDataFactory.createAccount(1,'Learner');
    insert accountList;
    
    List<Contact> contactList=TestDataFactory.createContact(2);
    //Madhu Added 
    contactList[0].accountid=accountList[0].id;
    contactList[1].accountid=accountList[0].id;
    insert contactList;

    system.debug('******contactList*******'+contactList.size());
     //List<AccountContact__c> AccountContactList = TestDataFactory.createAccountContact(1,accountList[0].Id,contactList[0].Id); 
    //Madhu added
    List<AccountContact__c> AccountContactList = [select id,Account_Name__c,primary__c,Financially_Responsible__c from AccountContact__c where account__c=:accountList[0].id];
    List<AccountContact__c> lstAccconList=new List<AccountContact__c>();
   /* for(AccountContact__c acc:AccountContactList){
        acc.Account_Name__c=true;
        acc.Financially_Responsible__c = true;
        acc.primary__c=true;
        lstAccconList.add(acc);
    }*/
        if (AccountContactList.size()>0)   {
            system.debug('AccountContactList[0].Financially_Responsible__c'+AccountContactList[0].Financially_Responsible__c);
            system.debug('AccountContactList[0].primary__c'+AccountContactList[0].primary__c);            
            system.debug('AccountContactList[1].Financially_Responsible__c'+AccountContactList[1].Financially_Responsible__c);
            system.debug('AccountContactList[1].primary__c'+AccountContactList[1].primary__c);
            AccountContactList[1].Account_Name__c=true;
            AccountContactList[1].Financially_Responsible__c=false;
            AccountContactList[1].primary__c=false;
        }
        update AccountContactList[1];
      AccountContactList = [select id,Account_Name__c,primary__c,Financially_Responsible__c from AccountContact__c where account__c=:accountList[0].id];
                if (AccountContactList.size()>0)   {
            system.debug('AccountContactList[0].Financially_Responsible__c'+AccountContactList[0].Financially_Responsible__c);
            system.debug('AccountContactList[0].primary__c'+AccountContactList[0].primary__c);            
            system.debug('AccountContactList[1].Financially_Responsible__c'+AccountContactList[1].Financially_Responsible__c);
            system.debug('AccountContactList[1].primary__c'+AccountContactList[1].primary__c);
            AccountContactList[1].Account_Name__c=true;
            AccountContactList[1].Financially_Responsible__c=true;
            AccountContactList[1].primary__c=true;
        }
        update AccountContactList[1];
        system.debug('Calling contact insert again');
     List<Contact> contactListin=TestDataFactory.createContact(3);
      // contactListin[2].accountid= accountList[0].id;
        insert contactListin[2];
     AccountContact__c nacccon=new AccountContact__c(Account__c=accountList[0].id,Contact__c=contactListin[2].id,primary__c=true,
                                                    Financially_Responsible__c=true,AccountRole__c='Learner');   
     insert nacccon;
    //Insert AccountContactList; 
   // checkRecurssionAfter.run =true;
   //update lstAccconList;
    
  // Map<Id, AccountContact__c> previousValuesMap = new Map<Id, AccountContact__c>(lstAccconList); 
             
  /*  List<AccountContact__c> accountcontact = [SELECT Account__c, Contact__c,Role_Detail__c FROM AccountContact__c WHERE Id =:AccountContactList[0].Id]; 
    List <account>Acc1 = TestDataFactory.createAccount(3,'Organisation');
    insert Acc1 ; 
    List<AccountContact__c> Aoc1 =[select Id from accountcontact__c where account__c = : Acc1[0].id];
    insert Aoc1;
    List<AccountContact__c> updateaccountcontact = new List<AccountContact__c>();    
    for(AccountContact__c acc : accountcontact) {
         acc.Primary__c = true;
         acc.Financially_Responsible__c = true;
         acc.Account_Name__c =true;
         if(acc.Account__c == AccountContactList[0].Account__c)
          updateaccountcontact.add(acc);
    }
    Update accountList;
     Update updateaccountcontact;
    primarycheckonAccountContact.updateContact(AccountContactList,accountcontact);*/
     //primarycheckonAccountContact.togglePrimaryAndFinancialFlags(lstAccconList, previousValuesMap);
   
    }
 /*   static testMethod void myUnitTest2()
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
         accContObj.Primary__c = true;
        accContObj.Academic_Role__c = 'Learner';
        accContObj.Role_Detail__c ='this is a role desc..';
        insert accContObj;
         AccountContact__c sAccountContact  = new AccountContact__c();
         sAccountContact = [Select Id FROM AccountContact__c WHERE Contact__c = : sContact.Id limit 1];
            //checkRecurssion.run = true;       
            sAccountContact.Primary__c = true;
             sAccountContact.Financially_Responsible__c =true;
             sAccountContact.primary__c=true;
             update sAccountContact;
            //checkRecurssion.run = true; 
                        
            delete sAccountContact;
           //checkRecurssion.run = true;    

            undelete sAccountContact;
        
        Test.stopTest();
    }
   Static testmethod void myUnitTest_1(){
         TestClassAutomation.FillAllFields = true;
          Boolean blnInsert =true ; 
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
           system.debug('id of contact'+scontact.id); 
          
         
         System.assert(true,blnInsert);
      List<AccountContact__c> sAccountContact  = new List<AccountContact__c>();
          sAccountContact = [Select Id FROM AccountContact__c WHERE Contact__c=:sContact.Id limit 1];
        system.debug('sAccountContact/contact'+sAccountContact+'con'+sContact);
         Update  sAccountContact;          
         Test.stopTest();
            
     }  */
    }