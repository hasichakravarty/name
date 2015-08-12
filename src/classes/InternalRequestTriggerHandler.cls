/************************************************************************************************************
* Apex Class Name   : InternalRequestTriggerHandler.cls
* Version           : 1.0 
* Created Date      : 17 JULY 2015
* Function          : Handler class for Internal Request Object Trigger
* Modification Log  :
* Developer                   Date                    Description
* -----------------------------------------------------------------------------------------------------------
* Mitch Hunt                  17/07/2015              Created Internal Request Handler Class Template
************************************************************************************************************/

public with sharing class InternalRequestTriggerHandler 
{
   InternalRequestsUtils utils = new InternalRequestsUtils();

   private boolean m_bIsExecuting = false;
    private integer iBatchSize = 0;
    
    public InternalRequestTriggerHandler (boolean bIsExecuting, integer iSize)
    {
        m_bIsExecuting = bIsExecuting;
        iBatchSize = iSize;
    }
/*
    // EXECUTE BEFORE INSERT LOGIC
    //
    public void OnBeforeInsert(Internal_Request__c[] lstNewInternalRequests)
    {
        
    }*/
    
    // EXECUTE AFTER INSERT LOGIC
    //
    public void OnAfterUpdate(Internal_Request__c[] lstNewInternalRequests)
    {
        system.debug('Debug Inside AfterInsert on Internal Request');
        List<Internal_Request__Share> IR_share = new List<Internal_Request__Share>();
        set<id> IROwners = new set<id>();
        for(Internal_Request__c eachIR: lstNewInternalRequests){
          IROwners.add(eachIR.OwnerId);
          system.debug('eachIR.Related_Internal_Request__c :' +eachIR.Related_Internal_Request__c);
        }
        Map<Id,User> UserMap = new Map<Id,User>([select id, Name, UserRole.Name, ManagerId, Manager.ManagerId, Manager.Manager.ManagerId from User where id in:IROwners]);
        system.debug('User Details :'+UserMap);
        Id FinanceWorkflowRecordTypeid =  Schema.SObjectType.Internal_Request__c.getRecordTypeInfosByName().get('Finance Workflow').getRecordTypeId();
        system.debug('Record type: '+FinanceWorkflowRecordTypeid);
        for(Internal_Request__c eachIR: lstNewInternalRequests){
            if(eachIR.RecordTypeId == FinanceWorkflowRecordTypeid){
                if(UserMap.get(eachIR.OwnerId) != null && UserMap.get(eachIR.OwnerId).UserRole.Name.contains('NA Sales Representative')){
                    if(UserMap.get(eachIR.OwnerId).ManagerId != null){
                        Internal_Request__Share eachIRS = new Internal_Request__Share();
                        eachIRS.ParentId = eachIR.Id;
                        eachIRS.UserOrGroupId = UserMap.get(eachIR.OwnerId).ManagerId;
                        eachIRS.AccessLevel = 'Edit';
                        IR_share.add(eachIRS);
                    }
                    if(UserMap.get(eachIR.OwnerId).Manager.ManagerId != null){
                        Internal_Request__Share eachIRS = new Internal_Request__Share();
                        eachIRS.ParentId = eachIR.Id;
                        eachIRS.UserOrGroupId = UserMap.get(eachIR.OwnerId).Manager.ManagerId;
                        eachIRS.AccessLevel = 'Edit';
                        IR_share.add(eachIRS);
                    }
                    if(UserMap.get(eachIR.OwnerId).Manager.Manager.ManagerId != null){
                        Internal_Request__Share eachIRS = new Internal_Request__Share();
                        eachIRS.ParentId = eachIR.Id;
                        eachIRS.UserOrGroupId = UserMap.get(eachIR.OwnerId).Manager.Manager.ManagerId;
                        eachIRS.AccessLevel = 'Edit';
                        IR_share.add(eachIRS);
                    }
                }else if(UserMap.get(eachIR.OwnerId) != null && UserMap.get(eachIR.OwnerId).UserRole.Name.contains('NA Learning Technology Specialist')) {
                        if(UserMap.get(eachIR.OwnerId).ManagerId != null){
                            Internal_Request__Share eachIRS = new Internal_Request__Share();
                            eachIRS.ParentId = eachIR.Id;
                            eachIRS.UserOrGroupId = UserMap.get(eachIR.OwnerId).ManagerId;
                            eachIRS.AccessLevel = 'Edit';
                            IR_share.add(eachIRS);
                        }
                        if(UserMap.get(eachIR.OwnerId).Manager.ManagerId != null){
                            Internal_Request__Share eachIRS = new Internal_Request__Share();
                            eachIRS.ParentId = eachIR.Id;
                            eachIRS.UserOrGroupId = UserMap.get(eachIR.OwnerId).Manager.ManagerId;
                            eachIRS.AccessLevel = 'Edit';
                            IR_share.add(eachIRS);
                        }
                    
                }else if(UserMap.get(eachIR.OwnerId) != null && UserMap.get(eachIR.OwnerId).UserRole.Name.contains('NA District Sales Manager')){
                        if(UserMap.get(eachIR.OwnerId).ManagerId != null){
                            Internal_Request__Share eachIRS = new Internal_Request__Share();
                            eachIRS.ParentId = eachIR.Id;
                            eachIRS.UserOrGroupId = UserMap.get(eachIR.OwnerId).ManagerId;
                            eachIRS.AccessLevel = 'Edit';
                            IR_share.add(eachIRS);
                        }
                        if(UserMap.get(eachIR.OwnerId).Manager.ManagerId != null){
                            Internal_Request__Share eachIRS = new Internal_Request__Share();
                            eachIRS.ParentId = eachIR.Id;
                            eachIRS.UserOrGroupId = UserMap.get(eachIR.OwnerId).Manager.ManagerId;
                            eachIRS.AccessLevel = 'Edit';
                            IR_share.add(eachIRS);
                        }
                }else if(UserMap.get(eachIR.OwnerId) != null && UserMap.get(eachIR.OwnerId).UserRole.Name.contains('NA Regional Sales Manager')){
                        if(UserMap.get(eachIR.OwnerId).ManagerId != null){
                            Internal_Request__Share eachIRS = new Internal_Request__Share();
                            eachIRS.ParentId = eachIR.Id;
                            eachIRS.UserOrGroupId = UserMap.get(eachIR.OwnerId).ManagerId;
                            eachIRS.AccessLevel = 'Edit';
                            IR_share.add(eachIRS);
                        }
                }
            }
                
        }
        
    system.debug('Internal share  :'+IR_share);
    if(IR_share.size()>0){
        Database.SaveResult[] lsr = Database.insert(IR_share,true);
        system.debug(' insert result :'+lsr);
    }
    }
    
    // BEFORE UPDATE LOGIC
    // Return a list of update records from the utility to the trigger.new trigger class
    public list<Internal_Request__c> OnBeforeUpdate(Internal_Request__c[] lstOldInternalRequests, Internal_Request__c[] lstUpdatedInternalRequests, map<ID, Internal_Request__c> mapIDInternalRequest)
    {
                   list<Internal_Request__c>       lstInternalRequeststoUpdate        = new list<Internal_Request__c>();
                   lstInternalRequeststoUpdate        = utils.updateRecords(lstUpdatedInternalRequests, mapIDInternalRequest);
                   return lstInternalRequeststoUpdate;
    }
  /*  
    // AFTER UPDATE LOGIC
    //
    public void OnAfterUpdate(Internal_Request__c[] lstOldInternalRequests, Internal_Request__c[] lstUpdatedInternalRequests, map<ID, Internal_Request__c> mapIDInternalRequest)
    {
 
    }
    
    // BEFORE DELETE LOGIC
    //
    public void OnBeforeDelete(Internal_Request__c[] lstInternalRequestsToDelete, map<ID, Internal_Request__c> mapIDInternalRequest)
    {
        
    }
    
    // AFTER DELETE LOGIC
    //
    public void OnAfterDelete(Internal_Request__c[] lstDeletedInternalRequests,map<ID, Internal_Request__c> mapIDInternalRequest)
    {
        
    }
    
    // AFTER UNDELETE LOGIC
    //
    public void OnUndelete(Internal_Request__c[] lstRestoredInternalRequests)
    {
        
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
*/
    
}