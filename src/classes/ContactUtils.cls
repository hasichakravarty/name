/*******************************************************************************************************************
* Apex Class Name   : ContactUtils.cls
* Version           : 1.0 
* Created Date      : 10 MARCH 2014
* Function          : Utility Class for Contact Object
* Modification Log  :
* Developer                   Date                    Description
* ------------------------------------------------------------------------------------------------------------------
* Mitch Hunt                  10/03/2014              Created Initial Version of Utility Class
*******************************************************************************************************************/

public with sharing class ContactUtils
{
    // preventDelete
    // If the current user is not the owner or an admin throw an error message on the page.
    //
    public void preventDelete(Contact[] lstContactsToDelete)
    {
        map<string, string> mapProfiles = GlobalUtils.getprofiles();
        Id sProfileId                   = system.Userinfo.getProfileId();
        
     if  (   mapProfiles.get(sProfileId) != 'Pearson Administrator' &&
                mapProfiles.get(sProfileId) != 'System Administrator' &&
                mapProfiles.get(sProfileId) != 'Pearson Data Administrator'                 
            )
        {
            for(Contact sContact : lstContactsToDelete)
            {
                GlobalUtils.Debug('ProfileId:::' + mapProfiles.get(system.Userinfo.getProfileId()));
                
                if  (sContact.OwnerId != system.Userinfo.getUserId())
                {
                    sContact.addError(System.Label.NonAdminOwnerDelete);
                }
            }
        }
        
    }
    
    // createAccountContact
    // create an associated AccountContact__c for a list of contacts.
    // 
    public void createAccountContact(Contact[] lstContacts)
    {
        list<AccountContact__c> lstAccountContact = new list<AccountContact__c>();
        
        set<Id> accountSet = new set<Id>();        
        for(Contact lc : lstContacts)
        {
        	accountSet.add(lc.AccountId);
        }
        
        list<AccountContact__c> existingAccountContacts = [SELECT Contact__c, Account__c FROM AccountContact__c where Account__c = :accountSet];
        
        map<Id, AccountContact__c> accountContactLookup = new map<Id, AccountContact__c>();
        for(AccountContact__c ac : existingAccountContacts)
        {
          accountContactLookup.put(ac.Account__c, ac);
          System.debug('@@@ putting in lookup map ' + ac.Account__c);    
        }
         
        for (Contact sContact : lstContacts)
        {
           //to block accountcontact creation on lead conversion        
            if(sContact.isleadConvertedContact__c == false && sContact.AccountId != null)
            {
              System.debug('@@@isleadConvertedContact__c'+sContact.isleadConvertedContact__c);
              System.debug('@@@ account id is ' + scontact.AccountId);
              if(!accountContactLookup.containsKey(sContact.AccountId))
              {
                lstAccountContact.add(new AccountContact__c(Account__c = sContact.AccountId, Contact__c = sContact.Id, 
                                                            Account_Name__c = true, 
                                                            AccountRole__c = sContact.Role__c,
                                                            Role_Detail__c = sContact.Role_Detail__c,
                                                            Primary__c = true,
                                                            Financially_Responsible__c = true));
                                                          
              }
              else
              {
                lstAccountContact.add(new AccountContact__c(Account__c = sContact.AccountId, Contact__c = sContact.Id, 
                                                            Account_Name__c = true, 
                                                            AccountRole__c = sContact.Role__c,
                                                            Role_Detail__c = sContact.Role_Detail__c,
                                                            Primary__c = false,
                                                            Financially_Responsible__c = false));
              }
              System.debug('@@@ContactUtils'+lstAccountContact);              
            }
        }
                    insert lstAccountContact;
    }
    
    
    
}