/************************************************************************************************************
* Apex Class Name   : AccountContactTriggerHandler.cls
* Version           : 1.0 
* Created Date      : 12 MARCH 2014
* Function          : Handler class for AccountContact__c Object Trigger
* Modification Log  :
* Developer                   Date                    Description
* -----------------------------------------------------------------------------------------------------------
* Mitch Hunt                  12/03/2014              Created Default Handler Class Template
*                             19/03/2015              Updated to include references to the AccountContactSync apex class
*                             23/03/2015              Updated to include references to the B2CAccountSync apex class
************************************************************************************************************/

public without sharing class AccountContactTriggerHandler
{
    private boolean m_bIsExecuting = false;
    private integer iBatchSize = 0;
    
    public AccountContactTriggerHandler(boolean bIsExecuting, integer iSize)
    {
        m_bIsExecuting = bIsExecuting;
        iBatchSize = iSize;
    }
    
    // Init Contact Utils
    AccountContactUtils utils = new AccountContactUtils();
    
    //Sync Account Contact Class
    AccountContactSync sync = new AccountContactSync();
    
    //Sync B2C Accounts Class
    B2CAccountSync B2CSync = new B2CAccountSync();
    
    // EXECUTE BEFORE INSERT LOGIC
    //
    public void OnBeforeInsert(AccountContact__c[] lstNewAccountContacts)
    {
        utils.preventDuplicates(lstNewAccountContacts);
       // sync.CheckMultipleAccountContactPrimaries(lstNewAccountContacts);
    }
    
    // EXECUTE AFTER INSERT LOGIC
    //
    public void OnAfterInsert(AccountContact__c[] lstNewAccountContacts)
    {
        sync.InsertAccountContactRoleRecords(lstNewAccountContacts);
        B2CSync.B2CAccountSyncWhenAccountContactRelationshipIsSet(lstNewAccountContacts);
    }
    
    // BEFORE UPDATE LOGIC
    //
    public void OnBeforeUpdate(AccountContact__c[] lstOldAccountContacts, AccountContact__c[] lstUpdatedAccountContacts, map<ID, AccountContact__c> mapIDAccountContact)
    {
         sync.CheckMultipleAccountContactPrimaries(lstUpdatedAccountContacts);
    }
    
    // AFTER UPDATE LOGIC
    //
    public void OnAfterUpdate(AccountContact__c[] lstOldAccountContacts, AccountContact__c[] lstUpdatedAccountContacts, map<ID, AccountContact__c> mapNewIDAccountContact, map<ID, AccountContact__c> mapOldIDAccountContact)
    {
        sync.UpdateAccountContactRoleRecords(lstUpdatedAccountContacts); 
        B2CSync.B2CAccountSyncWhenAccountContactRelationshipChange(lstUpdatedAccountContacts, mapNewIDAccountContact, mapOldIDAccountContact);
        PrimaryAccountUtilities.updateRoleInformationOnContact(lstOldAccountContacts, lstUpdatedAccountContacts, mapNewIDAccountContact,mapOldIDAccountContact);
    }
    
    // BEFORE DELETE LOGIC
    //
    public void OnBeforeDelete(AccountContact__c[] lstAccountContactsToDelete, map<ID, AccountContact__c> mapIDAccountContact)
    {
        
    }
    
    // AFTER DELETE LOGIC
    //
    public void OnAfterDelete(AccountContact__c[] lstDeletedAccountContacts, map<ID, AccountContact__c> mapIDAccountContact)
    {
        sync.DeleteAccountContactRoleRecords(lstDeletedAccountContacts);
    }
    
    // AFTER UNDELETE LOGIC
    //
    public void OnUndelete(AccountContact__c[] lstRestoredAccountContacts)
    {
        Sync.UndeleteAccountContactRoleRecords(lstRestoredAccountContacts);
    }
    
    public boolean bIsTriggerContext
    {
        get{ return m_bIsExecuting; }
    }
    
    public boolean bIsVisualforcePageContext
    {
        get{ return !bIsTriggerContext; }
    }
    
    public boolean bIsWebServiceContext
    {
        get{ return !bIsTriggerContext; }
    }
    
    public boolean bIsExecuteAnonymousContext
    {
        get{ return !bIsTriggerContext; }
    }

}