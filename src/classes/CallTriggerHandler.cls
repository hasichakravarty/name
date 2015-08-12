/************************************************************************************************************
* Apex Class Name	: CallTriggerHandler.cls
* Version 			: 1.0 
* Created Date  	: 30 APRIL 2014
* Function 			: Handler class for Call Object Trigger
* Modification Log	:
* Developer                   Date                    Description
* -----------------------------------------------------------------------------------------------------------
* Mitch Hunt                  30/04/2014              Created Default Handler Class Template
************************************************************************************************************/

public without sharing class CallTriggerHandler
{
	private boolean m_bIsExecuting = false;
	private integer iBatchSize = 0;
	
	public CallTriggerHandler(boolean bIsExecuting, integer iSize)
	{
		m_bIsExecuting = bIsExecuting;
		iBatchSize = iSize;
	}
	
	// EXECUTE BEFORE INSERT LOGIC
	//
	public void OnBeforeInsert(Call__c[] lstNewCalls)
	{
		// If the user has not selected an owner for the call default the call record owner to current user
		for(Call__c sCall : lstNewCalls)
		{
			if(sCall.OwnerId__c == null)
			{
				sCall.OwnerId__c = system.Userinfo.getUserId();
			}
		}
	}
	
	// EXECUTE AFTER INSERT LOGIC
	//
	public void OnAfterInsert(Call__c[] lstNewCalls)
	{
		CallUtils.SyncEvent(lstNewCalls);
	}
	
	// BEFORE UPDATE LOGIC
	//
	public void OnBeforeUpdate(Call__c[] lstOldCalls, Call__c[] lstUpdatedCalls, map<ID, Call__c> mapIDCall)
	{
		
	}
	
	// AFTER UPDATE LOGIC
	//
	public void OnAfterUpdate(Call__c[] lstOldCalls, Call__c[] lstUpdatedCalls, map<ID, Call__c> mapIDCall)
	{
		CallUtils.SyncEvent(lstUpdatedCalls);
	}
	
	// BEFORE DELETE LOGIC
	//
	public void OnBeforeDelete(Call__c[] lstCallsToDelete, map<ID, Call__c> mapIDCall)
	{
		
	}
	
	// AFTER DELETE LOGIC
	//
	public void OnAfterDelete(Call__c[] lstDeletedCalls, map<ID, Call__c> mapIDCall)
	{
		CallUtils.DeleteEvent(lstDeletedCalls);
	}
	
	// AFTER UNDELETE LOGIC
	//
	public void OnUndelete(Call__c[] lstRestoredCalls)
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