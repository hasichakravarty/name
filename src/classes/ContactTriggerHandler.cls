/************************************************************************************************************
* Apex Class Name   : ContactTriggerHandler.cls
* Version           : 1.0 
* Created Date      : 10 MARCH 2014
* Function          : Handler class for Contact Object Trigger
* Modification Log  :
* Developer                   Date                    Description
* -----------------------------------------------------------------------------------------------------------
* Mitch Hunt                  10/03/2014              Created Default Handler Class Template
*                             23/03/2015              Update to include reference to the B2CAccountSync apex class
************************************************************************************************************/

public with sharing class ContactTriggerHandler
{
    private boolean m_bIsExecuting = false;
    private integer iBatchSize = 0;
    
    public ContactTriggerHandler(boolean bIsExecuting, integer iSize)
    {
        m_bIsExecuting = bIsExecuting;
        iBatchSize = iSize;
    }
    
    // Init Contact Utils
    ContactUtils utils = new ContactUtils();
    B2CAccountSync B2CSync = new B2CAccountSync();
    
    // EXECUTE BEFORE INSERT LOGIC
    //
    public void OnBeforeInsert(Contact[] lstNewContacts)
    {
     
       
    }
    
    // EXECUTE AFTER INSERT LOGIC
    //
    public void OnAfterInsert(Contact[] lstNewContacts)
    {
        /* logic to avoid creation of Account contact if the contact is created from mobile */
        List<Contact> ContactsNotbyMobile = new List<Contact>();
        for(Contact eachcontact : lstNewContacts){
            if(eachcontact.Mobile_Last_Updated__c == null){
                ContactsNotbyMobile.add(eachcontact);
            }
        }
        if(ContactsNotbyMobile !=null && !ContactsNotbyMobile.isEmpty())
            utils.createAccountContact(ContactsNotbyMobile);
    }
    
    // BEFORE UPDATE LOGIC
    //
    public void OnBeforeUpdate(Contact[] newContacts, map<ID, Contact> oldMap)
    {
     system.debug('i am in ContactTriggerHandler');
    // AccountReadOnly.BeforeInsert(lstUpdatedContacts);
    Ps_PreventChangingOwner.PreventChangingContactOwner(newContacts,oldMap);  

    }
    
    // AFTER UPDATE LOGIC
    //
    public void OnAfterUpdate(Contact[] lstOldContacts, Contact[] lstUpdatedContacts, map<ID, Contact> NewMapIDContact, map<ID, Contact> oldMapIDContact)
    {   
        if(checkRecurssion.runOnce())
        {
          B2CSync.B2CAccountSyncWhenContactChange(lstUpdatedContacts, NewMapIDContact, oldMapIDContact);
          PrimaryAccountUtilities.updateRoleInformationOnAccountContact(lstOldContacts, lstUpdatedContacts, NewMapIDContact, oldMapIDContact); 
          PrimaryAccountUtilities.checkAccountContactExists(lstUpdatedContacts);
        }
    }
    
    // BEFORE DELETE LOGIC
    //
    public void OnBeforeDelete(Contact[] lstContactsToDelete, map<ID, Contact> mapIDContact)
    {
        utils.preventDelete(lstContactsToDelete);
    }
    
    // AFTER DELETE LOGIC
    //
    public void OnAfterDelete(Contact[] lstDeletedContacts, map<ID, Contact> mapIDContact)
    {
        
    }
    
    // AFTER UNDELETE LOGIC
    //
    public void OnUndelete(Contact[] lstRestoredContacts) { }
    
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