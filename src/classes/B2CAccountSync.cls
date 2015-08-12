/*******************************************************************************************************************
* Apex Class Name  : B2CAccountSync
* Version          : 1.0 
* Created Date     : 23 March 2015
* Function         : Class for sync B2C Accounts with Contact Information
* Modification Log :
*
* Developer                   Date                    Description
* ------------------------------------------------------------------------------------------------------------------
*                      23/03/2015              Created Initial Version of AccountContactSync Class
*******************************************************************************************************************/
public without sharing class B2CAccountSync
{
    /*************************************************************************************************************
    * Name        : B2CAccountSyncWhenContactChange
    * Description : Update B2C Accounts with the primary and/or financial responsible contact information 
    *               when the contacts change
    * Input       : newContacts - List of Contacts
    *               newContactsMap - Map with the after update version of the contacts
    *               oldContactsMap - Map with the before update version of the contacts
    * Output      : 
    *************************************************************************************************************/
    public void B2CAccountSyncWhenContactChange(List<Contact> newContacts, Map<Id,Contact> newContactsMap, Map<Id,Contact> oldContactsMap)
    {
    
        //Get the B2C Account Record Type 
        List<RecordType> AccountRecordTypes = [SELECT Id FROM RecordType WHERE DeveloperName = 'Learner'];
        
        //Get a map of the Accounts
        List<Account> B2CAccountList = [SELECT Id, Name,Account_Surname__c, FirstName__c, LastName__c, Phone, Mobile__c, Email__c,
                                            BillingCity, BillingCountry, BillingCountryCode, BillingPostalCode, BillingState,
                                            BillingStateCode, BillingStreet
                                            FROM Account WHERE RecordTypeId IN:AccountRecordTypes];
                                            
        Map<ID, Account> B2CAccountMap = new Map<ID, Account>(B2CAccountList);
        
        List<Account> AccountsToUpdateList = new List<Account>();

        Map<ID,Contact> ContactsMainInfoChangedMap = new Map<ID,Contact>();
        Map<ID,Contact> ContactsMailingInfoChangedMap = new Map<ID,Contact>();
        
        // Group the contact based on the information that changed
        for(Contact con :newContacts)
        {
            if((oldContactsMap.get(con.Id).FirstName != newContactsMap.get(con.Id).FirstName)
            ||(oldContactsMap.get(con.Id).LastName != newContactsMap.get(con.Id).LastName)
            ||(oldContactsMap.get(con.Id).Phone != newContactsMap.get(con.Id).Phone)
            ||(oldContactsMap.get(con.Id).MobilePhone != newContactsMap.get(con.Id).MobilePhone)
            ||(oldContactsMap.get(con.Id).Email != newContactsMap.get(con.Id).Email))
            {
                ContactsMainInfoChangedMap.put(con.Id,con);
            }
            
            if((oldContactsMap.get(con.Id).MailingStreet != newContactsMap.get(con.Id).MailingStreet)
            ||(oldContactsMap.get(con.Id).MailingCity != newContactsMap.get(con.Id).MailingCity)
            ||(oldContactsMap.get(con.Id).MailingState != newContactsMap.get(con.Id).MailingState)
            ||(oldContactsMap.get(con.Id).MailingCountry != newContactsMap.get(con.Id).MailingCountry)
            ||(oldContactsMap.get(con.Id).MailingPostalCode != newContactsMap.get(con.Id).MailingPostalCode)
            ||(oldContactsMap.get(con.Id).MailingStateCode != newContactsMap.get(con.Id).MailingStateCode)
            ||(oldContactsMap.get(con.Id).MailingCountryCode != newContactsMap.get(con.Id).MailingCountryCode))
            {
                ContactsMailingInfoChangedMap.put(con.Id,con);
            }
        }
        
        system.debug('\n\n$$$$$$$$$$ newContacts : '+newContacts+'\n\n');        
        system.debug('\n\n$$$$$$$$$$ AccountRecordTypes : '+AccountRecordTypes+'\n\n');
        system.debug('\n\n$$$$$$$$$$ ContactsMainInfoChangedMap : '+ContactsMainInfoChangedMap+'\n\n');
        system.debug('\n\n$$$$$$$$$$ ContactsMailingInfoChangedMap : '+ContactsMailingInfoChangedMap+'\n\n');
        
        //Get the AccountContact__c records for the contacts in which the Account is a B2C account
        List<AccountContact__c> AccountContactRelList = [SELECT Id, Account__c, Contact__c, Primary__c, Financially_Responsible__c,AccountRole__c,Role_Detail__c FROM AccountContact__c WHERE Contact__c IN:newContacts AND Account__r.RecordTypeId IN:AccountRecordTypes];
        
         system.debug('\n\n $$$$$$$$$$ AccountContactRelList : '+AccountContactRelList+'\n\n') ;          
        // Determine the accounts to update
        for(AccountContact__c accCon :AccountContactRelList)
        {
            if(B2CAccountMap.containsKey(accCon.Account__c))
            {   
                //Check if the contact is primary and financial responsible
                if((accCon.Primary__c)&&(accCon.Financially_Responsible__c))
                {
                    Account accToUpdate = B2CAccountMap.get(accCon.Account__c);
                    system.debug('\n\n $$$$$$$$$$ accToUpdate : '+accToUpdate+'\n\n') ;
                    if(ContactsMainInfoChangedMap.containsKey(accCon.Contact__c))
                    {
                        
                        accToUpdate.Name = ContactsMainInfoChangedMap.get(accCon.Contact__c).FirstName + ' ' + ContactsMainInfoChangedMap.get(accCon.Contact__c).LastName;
                        accToUpdate.FirstName__c = ContactsMainInfoChangedMap.get(accCon.Contact__c).FirstName;
                        accToUpdate.LastName__c = ContactsMainInfoChangedMap.get(accCon.Contact__c).LastName;
                        accToUpdate.Account_Surname__c = ContactsMainInfoChangedMap.get(accCon.Contact__c).LastName;
                        accToUpdate.Phone = ContactsMainInfoChangedMap.get(accCon.Contact__c).Phone;
                        accToUpdate.Mobile__c = ContactsMainInfoChangedMap.get(accCon.Contact__c).MobilePhone;
                        accToUpdate.Email__c = ContactsMainInfoChangedMap.get(accCon.Contact__c).Email; 
                        accToUpdate.Account_Name_is_Read_only__c = false;
                    }
                    if(ContactsMailingInfoChangedMap.containsKey(accCon.Contact__c))
                    {
               
                        accToUpdate.BillingCity = ContactsMailingInfoChangedMap.get(accCon.Contact__c).MailingCity;
                        accToUpdate.BillingCountry = ContactsMailingInfoChangedMap.get(accCon.Contact__c).MailingCountry;
                        accToUpdate.BillingCountryCode = ContactsMailingInfoChangedMap.get(accCon.Contact__c).MailingCountryCode;
                        accToUpdate.BillingPostalCode = ContactsMailingInfoChangedMap.get(accCon.Contact__c).MailingPostalCode;
                        accToUpdate.BillingState = ContactsMailingInfoChangedMap.get(accCon.Contact__c).MailingState;
                        accToUpdate.BillingStateCode = ContactsMailingInfoChangedMap.get(accCon.Contact__c).MailingStateCode;
                        accToUpdate.BillingStreet = ContactsMailingInfoChangedMap.get(accCon.Contact__c).MailingStreet;
                    }
                    
                    AccountsToUpdateList.add(accToUpdate);
                }
                //Check if the contact is primary
                else if(accCon.Primary__c && ContactsMainInfoChangedMap.containsKey(accCon.Contact__c))
                {
                    Account accToUpdate = B2CAccountMap.get(accCon.Account__c);
                    
                    accToUpdate.Name = ContactsMainInfoChangedMap.get(accCon.Contact__c).FirstName + ' ' + ContactsMainInfoChangedMap.get(accCon.Contact__c).LastName;
                    accToUpdate.FirstName__c = ContactsMainInfoChangedMap.get(accCon.Contact__c).FirstName;
                    accToUpdate.LastName__c = ContactsMainInfoChangedMap.get(accCon.Contact__c).LastName;
                     accToUpdate.Account_Surname__c = ContactsMainInfoChangedMap.get(accCon.Contact__c).LastName;
                    accToUpdate.Phone = ContactsMainInfoChangedMap.get(accCon.Contact__c).Phone;
                    accToUpdate.Mobile__c = ContactsMainInfoChangedMap.get(accCon.Contact__c).MobilePhone;
                    accToUpdate.Email__c = ContactsMainInfoChangedMap.get(accCon.Contact__c).Email;
                    accToUpdate.Account_Name_is_Read_only__c = false;
                    AccountsToUpdateList.add(accToUpdate);
                }
                //Check if the contact is financial responsible
                else if(accCon.Financially_Responsible__c && ContactsMailingInfoChangedMap.containsKey(accCon.Contact__c))
                {
                    Account accToUpdate = B2CAccountMap.get(accCon.Account__c);
                    
                    accToUpdate.BillingCity = ContactsMailingInfoChangedMap.get(accCon.Contact__c).MailingCity;
                    accToUpdate.BillingCountry = ContactsMailingInfoChangedMap.get(accCon.Contact__c).MailingCountry;
                    accToUpdate.BillingCountryCode = ContactsMailingInfoChangedMap.get(accCon.Contact__c).MailingCountryCode;
                    accToUpdate.BillingPostalCode = ContactsMailingInfoChangedMap.get(accCon.Contact__c).MailingPostalCode;
                    accToUpdate.BillingState = ContactsMailingInfoChangedMap.get(accCon.Contact__c).MailingState;
                    accToUpdate.BillingStateCode = ContactsMailingInfoChangedMap.get(accCon.Contact__c).MailingStateCode;
                    accToUpdate.BillingStreet = ContactsMailingInfoChangedMap.get(accCon.Contact__c).MailingStreet;
                    accToUpdate.Account_Name_is_Read_only__c = false;
                    AccountsToUpdateList.add(accToUpdate);
                }
            }
        }
        
        system.debug('\n\n$$$$$$$$$$$$$$ AccountsToUpdateList : '+AccountsToUpdateList+'\n\n');
        //Update the Accounts
        if(AccountsToUpdateList.size()>0)
        {
            update AccountsToUpdateList;
        }
        
     //updating AccountContactRole and RoleDetials based on changes in contact
        
            
    }
    
    /*************************************************************************************************************
    * Name        : B2CAccountSyncWhenAccountContactRelationshipChange
    * Description : Update B2C Accounts with the primary and/or financial responsible contact information 
    *               when the account contact relationships change
    * Input       : newAccConRel - List of AccountContacts
    *               newAccConRelMap - Map with the after update version of the AccountContacts
    *               oldAccConRelMap - Map with the before update version of the AccountContacts
    * Output      : 
    *************************************************************************************************************/
    public void B2CAccountSyncWhenAccountContactRelationshipChange(List<AccountContact__c> newAccConRel, Map<Id,AccountContact__c> newAccConRelMap, Map<Id,AccountContact__c> oldAccConRelMap){
        
        if(checkRecurssion.runOnce()){
            //Get the B2C Account Record Type 
            List<RecordType> AccountRecordTypes = [SELECT Id FROM RecordType WHERE DeveloperName = 'Learner'];
            
            //Get a map of the B2C Accounts
            List<Account> B2CAccountList = [SELECT Id, Name,Account_Surname__c, FirstName__c, LastName__c, Phone, Mobile__c, Email__c,
                                                BillingCity, BillingCountry, BillingCountryCode, BillingPostalCode, BillingState,
                                                BillingStateCode, BillingStreet
                                                FROM Account WHERE RecordTypeId IN:AccountRecordTypes];
            Map<ID, Account> B2CAccountMap = new Map<ID, Account>(B2CAccountList);
            
            List<Account> AccountsToUpdateList = new List<Account>();
            
            //Get Contacts map
            List<ID> ContactsIdsList = new List<ID>();
            
            for(AccountContact__c accCon :newAccConRel){
                ContactsIdsList.add(accCon.Contact__c);
            }
            
            List<Contact> ContactsList = [SELECT Id, FirstName, LastName, Email, Phone, MobilePhone,Role__c,Role_Detail__c,
                                            MailingCity, MailingCountry, MailingCountryCode, MailingPostalCode,
                                            MailingState, MailingStateCode, MailingStreet
                                            FROM Contact
                                            WHERE Id IN:ContactsIdsList];
                                                                                  
            Map<ID, Contact> ContactsMap = new Map<ID, Contact>(ContactsList);
            
            for(AccountContact__c accCon :newAccConRel)
            {
                if(B2CAccountMap.containsKey(accCon.Account__c))
                {
                    if(((newAccConRelMap.get(accCon.Id).Primary__c)&&(!oldAccConRelMap.get(accCon.Id).Primary__c))||((newAccConRelMap.get(accCon.Id).Financially_Responsible__c)&&(!oldAccConRelMap.get(accCon.Id).Financially_Responsible__c)))
                    {
                        Account accToUpdate = B2CAccountMap.get(accCon.Account__c);
                                     
                        if((newAccConRelMap.get(accCon.Id).Primary__c)&&(ContactsMap.containsKey(accCon.Contact__c)))
                        {
                            accToUpdate.Name = ContactsMap.get(accCon.Contact__c).FirstName + ' ' + ContactsMap.get(accCon.Contact__c).LastName;
                            accToUpdate.FirstName__c = ContactsMap.get(accCon.Contact__c).FirstName;
                            accToUpdate.LastName__c = ContactsMap.get(accCon.Contact__c).LastName;
                            accToUpdate.Account_Surname__c = ContactsMap.get(accCon.Contact__c).LastName;
                            accToUpdate.Phone = ContactsMap.get(accCon.Contact__c).Phone;
                            accToUpdate.Mobile__c = ContactsMap.get(accCon.Contact__c).MobilePhone;
                            accToUpdate.Email__c = ContactsMap.get(accCon.Contact__c).Email;
                        }
                        if((newAccConRelMap.get(accCon.Id).Financially_Responsible__c)&&(ContactsMap.containsKey(accCon.Contact__c)))
                        {
                            accToUpdate.BillingCity = ContactsMap.get(accCon.Contact__c).MailingCity;
                            accToUpdate.BillingCountry = ContactsMap.get(accCon.Contact__c).MailingCountry;
                            accToUpdate.BillingCountryCode = ContactsMap.get(accCon.Contact__c).MailingCountryCode;
                            accToUpdate.BillingPostalCode = ContactsMap.get(accCon.Contact__c).MailingPostalCode;
                            accToUpdate.BillingState = ContactsMap.get(accCon.Contact__c).MailingState;
                            accToUpdate.BillingStateCode = ContactsMap.get(accCon.Contact__c).MailingStateCode;
                            accToUpdate.BillingStreet = ContactsMap.get(accCon.Contact__c).MailingStreet;
                        }
                        AccountsToUpdateList.add(accToUpdate);
                    }
                }
            }
            
            //Update the Accounts
            if(AccountsToUpdateList.size()>0)
            {
                update AccountsToUpdateList;
            }
    
        

        }
    }
    
    /*************************************************************************************************************
    * Name        : B2CAccountSyncWhenAccountContactRelationshipIsSet
    * Description : Update B2C Accounts with the primary and/or financial responsible contact information 
    *               when the account contact relationships change
    * Input       : newAccConRel - List of AccountContacts
    * Output      : 
    *************************************************************************************************************/
    public void B2CAccountSyncWhenAccountContactRelationshipIsSet(List<AccountContact__c> newAccConRel)
    {
        //Get the B2C Account Record Type 
        List<RecordType> AccountRecordTypes = [SELECT Id FROM RecordType WHERE DeveloperName = 'Learner'];
        
        //Get a map of the B2C Accounts
        List<Account> B2CAccountList = [SELECT Id, Name, FirstName__c, LastName__c, Phone, Mobile__c, Email__c,
                                            BillingCity, BillingCountry, BillingCountryCode, BillingPostalCode, BillingState,
                                            BillingStateCode, BillingStreet
                                            FROM Account WHERE RecordTypeId IN:AccountRecordTypes];
        Map<ID, Account> B2CAccountMap = new Map<ID, Account>(B2CAccountList);
        
        List<Account> AccountsToUpdateList = new List<Account>();
        
        //Get Contacts map
        List<ID> ContactsIdsList = new List<ID>();
        
        for(AccountContact__c accCon :newAccConRel){
            ContactsIdsList.add(accCon.Contact__c);
        }
        
        List<Contact> ContactsList = [SELECT Id, FirstName, LastName, Email, Phone, MobilePhone,
                                        MailingCity, MailingCountry, MailingCountryCode, MailingPostalCode,
                                        MailingState, MailingStateCode, MailingStreet
                                        FROM Contact
                                        WHERE Id IN:ContactsIdsList];
                                        
        Map<ID, Contact> ContactsMap = new Map<ID, Contact>(ContactsList);
        
        for(AccountContact__c accCon :newAccConRel)
        {
            if(B2CAccountMap.containsKey(accCon.Account__c))
            {
                if((accCon.Primary__c)||(accCon.Financially_Responsible__c ))
                {
                    Account accToUpdate = B2CAccountMap.get(accCon.Account__c);
                    
                    if((accCon.Primary__c)&&(ContactsMap.containsKey(accCon.Contact__c)))
                    {
                        accToUpdate.Name = ContactsMap.get(accCon.Contact__c).FirstName + ' ' + ContactsMap.get(accCon.Contact__c).LastName;
                        accToUpdate.FirstName__c = ContactsMap.get(accCon.Contact__c).FirstName;
                        accToUpdate.LastName__c = ContactsMap.get(accCon.Contact__c).LastName;
                        accToUpdate.Account_Surname__c = ContactsMap.get(accCon.Contact__c).LastName;
                        accToUpdate.Phone = ContactsMap.get(accCon.Contact__c).Phone;
                        accToUpdate.Mobile__c = ContactsMap.get(accCon.Contact__c).MobilePhone;
                        accToUpdate.Email__c = ContactsMap.get(accCon.Contact__c).Email;
                        accToUpdate.Account_Name_is_Read_only__c = false;
                       
                    }
                    if((accCon.Financially_Responsible__c)&&(ContactsMap.containsKey(accCon.Contact__c)))
                    {
                        accToUpdate.BillingCity = ContactsMap.get(accCon.Contact__c).MailingCity;
                        accToUpdate.BillingCountry = ContactsMap.get(accCon.Contact__c).MailingCountry;
                        accToUpdate.BillingCountryCode = ContactsMap.get(accCon.Contact__c).MailingCountryCode;
                        accToUpdate.BillingPostalCode = ContactsMap.get(accCon.Contact__c).MailingPostalCode;
                        accToUpdate.BillingState = ContactsMap.get(accCon.Contact__c).MailingState;
                        accToUpdate.BillingStateCode = ContactsMap.get(accCon.Contact__c).MailingStateCode;
                        accToUpdate.BillingStreet = ContactsMap.get(accCon.Contact__c).MailingStreet;
                    }
                    AccountsToUpdateList.add(accToUpdate);
                     System.debug('@@@@ accounttoupdate'+accToUpdate);
                }
            }
        }
        
        //Update the Accounts
        if(AccountsToUpdateList.size()>0)
        {
            update AccountsToUpdateList;
        }

    }

}