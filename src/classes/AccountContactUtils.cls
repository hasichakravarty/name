/*******************************************************************************************************************
* Apex Class Name   : AccountContactUtils.cls
* Version           : 1.0 
* Created Date      : 12 MARCH 2014
* Function          : Utility Class for Contact Object
* Modification Log  :
* Developer                   Date                    Description
* ------------------------------------------------------------------------------------------------------------------
* Mitch Hunt                  12/03/2014              Created Initial Version of Utility Class
*******************************************************************************************************************/

public with sharing class AccountContactUtils
{
    // preventDuplicates
    // BeforeInsert Only
    //
    public void preventDuplicates(AccountContact__c[] lstAccountContacts)
    {
        set<ID>                             setContactIds               = new set<ID>();
        map <String, AccountContact__c>     mapKeytoAccountContact      = new map<String, AccountContact__c> ();
        
        for(AccountContact__c sAccountContact : lstAccountContacts)
        {
            setContactIds.add(sAccountContact.Contact__c);
        }
        
        // Retrieve a list of all AccountContact records for this Contact
        list<AccountContact__c> lstExistingAccountContact = [SELECT Account__c, Contact__c FROM AccountContact__c WHERE Contact__c = : setContactIds];
        
        // Create a unique key to check for duplicates
        for (AccountContact__c sAccountContact : lstExistingAccountContact)
        {
            mapKeytoAccountContact.put(sAccountContact.Account__c + '' + sAccountContact.Contact__c, 
            new AccountContact__c(Account__c = sAccountContact.Account__c, Contact__c = sAccountContact.Contact__c));
        }
        
        // Check if this Account Contact Record is a duplicate
        for (AccountContact__c sAccountContact : lstAccountContacts)
        {
            if(mapKeytoAccountContact.containsKey(sAccountContact.Account__c + '' + sAccountContact.Contact__c))
            {
                sAccountContact.Account__c.addError(system.Label.ErrorMsg_Prevent_Duplicate);
            }
        }
        
    }
}