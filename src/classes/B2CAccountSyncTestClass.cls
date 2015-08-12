/*******************************************************************************************************************
        * Apex Class Name  : B2CAccountSyncTestClass
        * Version          : 1.0 
        * Created Date     : 24 March 2015
        * Function         : Test Class of the B2CAccountSync Class
        * Modification Log :
        *
        * Developer                   Date                    Description
        * ------------------------------------------------------------------------------------------------------------------
        *                      24/03/2015              Created Initial Version of B2CAccountSyncTestClass
        *******************************************************************************************************************/
        @isTest(seealldata=true)
        private class B2CAccountSyncTestClass
        {
            // ----------- IN PROGRESS --------------
            
            
            /*************************************************************************************************************
            * Name        : VerifyB2CAccountSyncWhenContactsChanged
            * Description : Verify the B2C Accounts are successfully sync with the Primary and Financially Responsible 
            *                contact information when the contact is updated        
            * Input       : 
            * Output      : 
            *************************************************************************************************************/
            static testMethod void VerifyB2CAccountSyncWhenContactsChanged()
            {
                     List<User> usrLst = TestDataFactory.createUser(Userinfo.getProfileId());
                    insert usrLst;
                    System.runas(usrLst[0]){

                
                    try{
                    List<Id> contactIds = new List<Id>();
                   // list<case> clist = TestDataFactory.createCase(1,'General');
                    //insert clist;
                    List<AccountContact__c> accConList = new List<AccountContact__c>();
                    List<Account> accountList = new List<Account>();
                    Database.SaveResult[] accSr,conSr;
                
                    //TestData for Condition_1 and Condition_2
                    accountList = TestDataFactory.createAccount(1, 'Learner');
                    accSr = Database.insert(accountList);
                    List<Contact> contactList = TestDataFactory.createContact(1);
                    conSr = Database.insert(contactList);
                    system.debug('\n\n Database.SaveResult[] : accSr - '+accSr+'\n\n');
                    system.debug('\n\n Database.SaveResult[] : conSr - '+conSr+'\n\n');
                    for(Database.SaveResult sr : conSr)
                        contactIds.add(sr.id);
                    for(Database.SaveResult sr : accSr){
                        accConList.addAll(TestDataFactory.createAccountContact(sr.getId(), contactIds, true, true));   
                    } 
                    insert(accConList);
                    checkRecurssion.run = true;
                    
                     //Condition 1 ; accountContacts primary = true,financially responsible = true,
                    //              ContactsMainInfoChanged(FirstName,LastName,Phone,Mobile,Phone,Email)
                    for(Contact c : contactList)
                        C.LastName = 'XYZ';
                        
                    update contactList;
                    checkRecurssion.run = true;
                    //Condition 2 ; accountContacts primary = true,financially responsible = true,
                    //              ContactsMailingInfoChanged(MailingStreetMailingCityMailingStateMailingCountryMailingPostalCode
                    //                                          MailingStateCode,MailingCountryCode)
                    for(Contact c : contactList)
                        C.MailingCity = 'PLACE';
                    
                    Database.DMLOptions dml1 = new Database.DMLOptions();

dml1.DuplicateRuleHeader.allowSave = true;

//dml1.DuplicateRuleHeader.includeRecordDetails = true;

dml1.DuplicateRuleHeader.runAsCurrentUser = true;


List<Database.SaveResult> sr1 = Database.update(contactList, dml1);




                checkRecurssion.run = true;
                    //TestData for Condition_3 
                    delete contactList;
                    checkRecurssion.run = true;
                    contactList = TestDataFactory.createContact(1);
                    conSr = Database.insert(contactList);
                    accConList = new List<AccountContact__c>();
                    contactIds = new List<Id>();
                    system.debug('\n\n Database.SaveResult[] : accSr - '+accSr+'\n\n');
                    system.debug('\n\n Database.SaveResult[] : conSr - '+conSr+'\n\n');
                    checkRecurssion.run = true;
                    for(Database.SaveResult sr : conSr)
                        contactIds.add(sr.id);
                    for(Database.SaveResult sr : accSr){
                        accConList.addAll(TestDataFactory.createAccountContact(sr.getId(), contactIds, true, false));   
                    } 
                    checkRecurssion.run = true;
                    
                    /*Boolean NoSponsor = false;
                    for(AccountContact__c ac : accConList){
                        if(ac.Financially_Responsible__c == true)
                            NoSponsor = true;
                    }
                    if(!NoSponsor){
                        for(Database.SaveResult sr : accSr)
                            accConList.addAll(TestDataFactory.createAccountContact(sr.getId(), contactIds, true, true)); 
                    }*/
                
                    insert(accConList);
                        
                    //Condition 3 : accountContacts primary = true,financially responsible = false,
                    //              ContactsMainInfoChanged(FirstName,LastName,Phone,Mobile,Phone,Email)
                    for(Contact c : contactList)
                        C.LastName = 'XYZ';
                    checkRecurssion.run = true;    
                    update contactList;
                checkRecurssion.run = true;
                    //TestData for Condition_4 
                    delete contactList;
                    checkRecurssion.run = true;
                    contactList = TestDataFactory.createContact(1);
                    conSr = Database.insert(contactList);
                    accConList = new List<AccountContact__c>();
                    contactIds = new List<Id>();
                    system.debug('\n\n Database.SaveResult[] : accSr - '+accSr+'\n\n');
                    system.debug('\n\n Database.SaveResult[] : conSr - '+conSr+'\n\n');
                    checkRecurssion.run = true;
                    for(Database.SaveResult sr : conSr)
                        contactIds.add(sr.id);
                    for(Database.SaveResult sr : accSr){
                        accConList.addAll(TestDataFactory.createAccountContact(sr.getId(), contactIds, true, false));   
                    } 
                    checkRecurssion.run = true;
                    insert(accConList);
                checkRecurssion.run = true;
                    for(Contact c : contactList)
                        C.LastName = 'XYZ';
                        
                    Database.DMLOptions dml2 = new Database.DMLOptions();

dml2.DuplicateRuleHeader.allowSave = true;

//dml2.DuplicateRuleHeader.includeRecordDetails = true;

dml2.DuplicateRuleHeader.runAsCurrentUser = true;


List<Database.SaveResult> sr2 = Database.update(contactList, dml2);

            
                    
                    //Condition 3 : accountContacts primary = false,financially responsible = true,
                    //              ContactsMailingInfoChanged(MailingStreetMailingCityMailingStateMailingCountryMailingPostalCode
                    //                                          MailingStateCode,MailingCountryCode)
                    
                    delete contactList;
                    contactList = TestDataFactory.createContact(1);
                    conSr = Database.insert(contactList);
                    accConList = new List<AccountContact__c>();
                    contactIds = new List<Id>();
                    system.debug('\n\n Database.SaveResult[] : accSr - '+accSr+'\n\n');
                    system.debug('\n\n Database.SaveResult[] : conSr - '+conSr+'\n\n');
                    for(Database.SaveResult sr : conSr)
                        contactIds.add(sr.id);
                    for(Database.SaveResult sr : accSr){
                        accConList.addAll(TestDataFactory.createAccountContact(sr.getId(), contactIds, false, true));   
                    } 
                   // insert(accConList);
                checkRecurssion.run = true;
                    for(Contact c : contactList)
                        C.MailingCity = 'PLACE';
                    
                    Database.DMLOptions dml3 = new Database.DMLOptions();

dml3.DuplicateRuleHeader.allowSave = true;

//dml3.DuplicateRuleHeader.includeRecordDetails = true;

dml3.DuplicateRuleHeader.runAsCurrentUser = true;


List<Database.SaveResult> sr3 = Database.update(contactList, dml3);

                  checkRecurssion.run = true;  
                   Delete contactList;

                    } catch(Exception ex){
                        System.debug('Inside Exception');
                   }
                   
                    }
            }
            
            /*************************************************************************************************************
            * Name        : VerifyB2CAccountSyncWhenAccConRelationshipChanged
            * Description : Verify the B2C Accounts are successfully sync with the Primary and Financially Responsible 
            *                contact information when the AccountContact relationship is updated
            * Input       : 
            * Output      : 
            *************************************************************************************************************/
            static testMethod void VerifyB2CAccountSyncWhenAccConRelationshipChanged()
            {
               List<User> usrLst = TestDataFactory.createUser(Userinfo.getProfileid());  
                    insert usrLst;  
                      System.runas(usrLst[0]){
                    List<Id> contactIds = new List<Id>();
                    List<AccountContact__c> newAccConList = new List<AccountContact__c>();
                    List<AccountContact__c> oldAccConList = new List<AccountContact__c>();
                    Map<Id,AccountContact__c> oldIdAccConmap = new Map<Id,AccountContact__c>();
                    Map<Id,AccountContact__c> newIdAccConmap = new Map<Id,AccountContact__c>();
                    List<Account> accountList = new List<Account>();
                    Database.SaveResult[] conSr,oldAccConsr,newAccConsr;
                    Database.SaveResult accSr;
                
                    accountList = TestDataFactory.createAccount(1, 'Learner');
                    accountList[0].Account_Name_is_Read_only__c  = false;
                    accSr = Database.insert(accountList[0]);
                    Update accountList ;
                    List<Contact> contactList = TestDataFactory.createContact(1);
                    conSr = Database.insert(contactList);
                    Update ContactList;
                    for(Database.SaveResult sr : conSr)
                        contactIds.add(sr.id);
                    
                    newAccConList.addAll(TestDataFactory.createAccountContact(accSr.getId(), contactIds, true, true));   
                    oldAccConList.addAll(TestDataFactory.createAccountContact(accSr.getId(), contactIds, false, true));    
                    
                    newAccConsr = Database.insert(newAccConList);
                    
                    
                    Integer i = 0;
                    for(AccountContact__c acc : newAccConList){
                        oldAccConList.get(i).id = acc.id;
                        acc.id = newAccConsr.get(i++).getId();
                        
                    }
                    
                    for(Contact c : contactList){
                       c.FirstName = 'firstname';
                        c.LastName = 'lastName';
                       c.MailingStreet = 'testing123'; 
                    }
                    
                    update contactList;
                    system.debug('\n\n$$$$$$$$$ : newAccConList '+newAccConList+'\n\n');
                    system.debug('\n\n$$$$$$$$$ : oldAccConList '+oldAccConList+'\n\n');
                
                    Boolean contain = false;
                    for(Database.SaveResult sr : newAccConsr)
                        for(AccountContact__c newaccCon : newAccConList)
                            if(!newIdAccConmap.containsKey(sr.getId())){
                                for(AccountContact__c accCon : newIdAccConmap.values())
                                    if(newaccCon == accCon){
                                        contain = true;
                                        continue;
                                    }    
                                if(!contain)
                                    newIdAccConmap.put(sr.getId(),newaccCon);
                                contain = false;
                            }   
                    system.debug('\n\n$$$$$$$$$ newIdAccConmap : '+newIdAccConmap+'\n\n');
                
                    contain = false;
                    //for(Database.SaveResult sr : oldAccConsr)
                        for(AccountContact__c oldAccCon : oldAccConList)
                            if(!oldIdAccConmap.containsKey(oldAccCon.id)){
                                for(AccountContact__c accCon : oldIdAccConmap.values())
                                    if(oldaccCon == accCon){
                                        contain = true;
                                        continue;
                                    }    
                                if(!contain)
                                    oldIdAccConmap.put(oldAccCon.id,oldAccCon);
                                contain = false;
                            }   
                    system.debug('\n\n$$$$$$$$$ : oldIdAccConmap '+oldIdAccConmap+'\n\n');
                    
                   /* for(AccountContact__c accCon :newAccConList)
                        if(((newIdAccConmap.get(accCon.Id).Primary__c)&&
                                (!oldIdAccConmap.get(accCon.Id).Primary__c))||
                               ((newIdAccConmap.get(accCon.Id).Financially_Responsible__c)&&
                                (!oldIdAccConmap.get(accCon.Id).Financially_Responsible__c)))
                                    system.debug('\n\nenetered\n\n');*/
                                    
                    Bypass_Settings__c setting = Bypass_Settings__c.getOrgDefaults();
                    if(setting!=null)
                        setting.Disable_Validation_Rules__c = true;
                    update setting;

                    B2CAccountSync testClass = new B2CAccountSync();
                    checkRecurssion.run = true;
                  testClass.B2CAccountSyncWhenAccountContactRelationshipChange(newAccConList, newIdAccConmap, oldIdAccConmap);
                    }
            }
            
            /*************************************************************************************************************
            * Name        : VerifyB2CAccountSyncWhenAccConRelationshipChanged
            * Description : Verify the B2C Accounts are successfully sync with the Primary and Financially Responsible 
            *                contact information when the AccountContact relationship is created       
            * Input       : 
            * Output      : 
            *************************************************************************************************************/
            static testMethod void VerifyB2CAccountSyncWhenNewAccConRelationship()
            {
                     List<User> usrLst = TestDataFactory.createUser(Userinfo.getProfileId());
                    insert usrLst;
                    System.runas(usrLst[0]){
                    List<Id> contactIds = new List<Id>();
                    List<AccountContact__c> newAccConList = new List<AccountContact__c>();
                    List<AccountContact__c> oldAccConList = new List<AccountContact__c>();
                    List<Account> accountList = new List<Account>();
                    Database.SaveResult[] conSr,oldAccConsr,newAccConsr;
                    Database.SaveResult accSr;
                    ContactTriggerHandler ct = new ContactTriggerHandler(true,1);
                    accountList = TestDataFactory.createAccount(1, 'Learner');
                    accSr = Database.insert(accountList[0]);
                    List<Contact> contactList = TestDataFactory.createContact(1);
                    conSr = Database.insert(contactList);
                    
                    for(Database.SaveResult sr : conSr)
                        contactIds.add(sr.id);
                    
                    newAccConList.addAll(TestDataFactory.createAccountContact(accSr.getId(), contactIds, true, true));   
                    oldAccConList.addAll(TestDataFactory.createAccountContact(accSr.getId(), contactIds, false, true));    
                    
                    newAccConsr = Database.insert(newAccConList);
                    
                    
                    Integer i = 0;
                    for(AccountContact__c acc : newAccConList){
                        oldAccConList.get(i).id = acc.id;
                        acc.id = newAccConsr.get(i++).getId();
                        
                    }
                
                    for(Contact c : contactList){
                        c.FirstName = 'firstname';
                        c.LastName = 'lastName';
                    }
                    
                    update contactList;
                    system.debug('\n\n$$$$$$$$$ : newAccConList '+newAccConList+'\n\n');
                    system.debug('\n\n$$$$$$$$$ : oldAccConList '+oldAccConList+'\n\n');
                
                    B2CAccountSync testClass = new B2CAccountSync();
                    checkRecurssion.run = true;
                    testClass.B2CAccountSyncWhenAccountContactRelationshipIsSet(newAccConList);
                    
                    delete contactList;
                   
                  //  ct.OnUndelete(contactList);
                  // ct.bIsTriggerContext();
                    }
            }
        }