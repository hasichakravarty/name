/************************************************************************************************************************
* Apex Class Name	: RelationshipTriggerHandler.cls
* Version 			: 1.0 
* Created Date  	: 14 MARCH 2014
* Function 			: Handler class for Relationship Object Trigger
* Modification Log	:
* Developer                   Date                    Description
* -----------------------------------------------------------------------------------------------------------------------
* Mitch Hunt                  14/03/2014              Created Default Handler Class Template
************************************************************************************************************************/

public with sharing class RelationshipTriggerHandler
{
	private boolean m_bIsExecuting = false;
	private integer iBatchSize = 0;
	
	public RelationshipTriggerHandler(boolean bIsExecuting, integer iSize)
	{
		m_bIsExecuting = bIsExecuting;
		iBatchSize = iSize;
	}
	
	// Init Relationship Utils
	RelationshipUtils utils = new RelationshipUtils();
	
	// EXECUTE BEFORE INSERT LOGIC
	//
	public void OnBeforeInsert(Relationship__c[] lstNewRelationships)
	{
		
	}
	
	// EXECUTE AFTER INSERT LOGIC
	//
	public void OnAfterInsert(Relationship__c[] lstNewRelationships)
	{
		utils.cloneRecords(lstNewRelationships);
	}
	
	// BEFORE UPDATE LOGIC
	//
	public void OnBeforeUpdate(Relationship__c[] lstOldRelationships, Relationship__c[] lstUpdatedRelationships, map<ID, Relationship__c> mapIDRelationship)
	{
		
	}
	
	// AFTER UPDATE LOGIC
	//
	public void OnAfterUpdate(Relationship__c[] lstOldRelationships, Relationship__c[] lstUpdatedRelationships, map<ID, Relationship__c> mapIDRelationship)
	{
		utils.updateRecords(lstOldRelationships, mapIDRelationship);
	}
	
	// BEFORE DELETE LOGIC
	//
	public void OnBeforeDelete(Relationship__c[] lstRelationshipsToDelete, map<ID, Relationship__c> mapIDRelationship)
	{
		utils.deleteRecords(lstRelationshipsToDelete);
	}
	
	// AFTER DELETE LOGIC
	//
	public void OnAfterDelete(Relationship__c[] lstDeletedRelationships, map<ID, Relationship__c> mapIDRelationship)
	{
		
	}
	
	// AFTER UNDELETE LOGIC
	//
	public void OnUndelete(Relationship__c[] lstRestoredRelationships)
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

}