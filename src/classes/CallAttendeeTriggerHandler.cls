/************************************************************************************************************
* Apex Class Name	: CallAttendeeTriggerHandler.cls
* Version 			: 1.0 
* Created Date  	: 30 APRIL 2014
* Function 			: Handler class for Call Attendee Object Trigger
* Modification Log	:
* Developer                   Date                    Description
* -----------------------------------------------------------------------------------------------------------
* Mitch Hunt                  30/04/2014              Created Default Handler Class Template
************************************************************************************************************/

public without sharing class CallAttendeeTriggerHandler
{
	private boolean m_bIsExecuting = false;
	private integer iBatchSize = 0;
	
	public CallAttendeeTriggerHandler(boolean bIsExecuting, integer iSize)
	{
		m_bIsExecuting = bIsExecuting;
		iBatchSize = iSize;
	}
	
	// EXECUTE BEFORE INSERT LOGIC
	//
	public void OnBeforeInsert(CallAttendee__c[] lstNewCallAttendees)
	{
		
	}
	
	// EXECUTE AFTER INSERT LOGIC
	//
	public void OnAfterInsert(CallAttendee__c[] lstNewCallAttendees)
	{
		CallAttendeeUtils.SyncEventAttendees(lstNewCallAttendees);
	}
	
	// BEFORE UPDATE LOGIC
	//
	public void OnBeforeUpdate(CallAttendee__c[] lstOldCallAttendees, CallAttendee__c[] lstUpdatedCallAttendees, map<ID, CallAttendee__c> mapIDCallAttendees)
	{
		
	}
	
	// AFTER UPDATE LOGIC
	//
	public void OnAfterUpdate(CallAttendee__c[] lstOldCallAttendees, CallAttendee__c[] lstUpdatedCallAttendees, map<ID, CallAttendee__c> mapIDCallAttendees)
	{
		
	}
	
	// BEFORE DELETE LOGIC
	//
	public void OnBeforeDelete(CallAttendee__c[] lstCallAttendeesToDelete, map<ID, CallAttendee__c> mapIDCallAttendees)
	{
		
	}
	
	// AFTER DELETE LOGIC
	//
	public void OnAfterDelete(CallAttendee__c[] lstDeletedCallAttendees, map<ID, CallAttendee__c> mapIDCallAttendees)
	{
		CallAttendeeUtils.deleteAttendees(lstDeletedCallAttendees);
	}
	
	// AFTER UNDELETE LOGIC
	//
	public void OnUndelete(CallAttendee__c[] lstRestoredCallAttendees)
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