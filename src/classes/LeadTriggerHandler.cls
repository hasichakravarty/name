/************************************************************************************************************
* Apex Class Name	: LeadTriggerHandler.cls
* Version 			: 1.0 
* Created Date  	: 06 MARCH 2014
* Function 			: Handler class for Lead Object Trigger
* Modification Log	:
* Developer                   Date                    Description
* -----------------------------------------------------------------------------------------------------------
* Mitch Hunt                  06/03/2014              Created Default Handler Class Template
************************************************************************************************************/

public with sharing class LeadTriggerHandler
{
	private boolean m_bIsExecuting = false;
	private integer iBatchSize = 0;
	
	public LeadTriggerHandler(boolean bIsExecuting, integer iSize)
	{
		m_bIsExecuting = bIsExecuting;
		iBatchSize = iSize;
	}
	
	// EXECUTE BEFORE INSERT LOGIC
	//
	public void OnBeforeInsert(Lead[] lstNewLeads)
	{
		
	}
	
	// EXECUTE AFTER INSERT LOGIC
	//
	public void OnAfterInsert(Lead[] lstNewLeads)
	{
		
	}
	
	// BEFORE UPDATE LOGIC
	//
	public void OnBeforeUpdate(Lead[] lstOldLeads, Lead[] lstUpdatedLeads, map<ID, Lead> mapIDLead)
	{
		
	}
	
	// AFTER UPDATE LOGIC
	//
	public void OnAfterUpdate(Lead[] lstOldLeads, Lead[] lstUpdatedLeads, map<ID, Lead> mapIDLead)
	{
		
	}
	
	// BEFORE DELETE LOGIC
	//
	public void OnBeforeDelete(Lead[] lstLeadsToDelete, map<ID, Lead> mapIDLead)
	{
		
	}
	
	// AFTER DELETE LOGIC
	//
	public void OnAfterDelete(Lead[] lstDeletedLeads, map<ID, Lead> mapIDLead)
	{
		
	}
	
	// AFTER UNDELETE LOGIC
	//
	public void OnUndelete(Lead[] lstRestoredLeads)
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