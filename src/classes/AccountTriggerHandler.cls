/************************************************************************************************************
* Apex Class Name	: AccountTriggerHandler.cls
* Version 			: 1.0 
* Created Date  	: 06 MARCH 2014
* Function 			: Handler class for Account Object Trigger
* Modification Log	:
* Developer                   Date                    Description
* -----------------------------------------------------------------------------------------------------------
* Mitch Hunt                  06/03/2014              Created Default Handler Class Template
************************************************************************************************************/

public with sharing class AccountTriggerHandler
{
	private boolean m_bIsExecuting = false;
	private integer iBatchSize = 0;
	
	public AccountTriggerHandler(boolean bIsExecuting, integer iSize)
	{
		m_bIsExecuting = bIsExecuting;
		iBatchSize = iSize;
	}
	
	// EXECUTE BEFORE INSERT LOGIC
	//
	public void OnBeforeInsert(Account[] lstNewAccounts)
	{
		
	}
	
	// EXECUTE AFTER INSERT LOGIC
	//
	public void OnAfterInsert(Account[] lstNewAccounts)
	{
		
	}
	
	// BEFORE UPDATE LOGIC
	//
	public void OnBeforeUpdate(Account[] lstOldAccounts, Account[] lstUpdatedAccounts, map<ID, Account> mapIDAccount)
	{
		
	}
	
	// AFTER UPDATE LOGIC
	//
	public void OnAfterUpdate(Account[] lstOldAccounts, Account[] lstUpdatedAccounts, map<ID, Account> mapIDAccount)
	{
		
	}
	
	// BEFORE DELETE LOGIC
	//
	public void OnBeforeDelete(Account[] lstAccountsToDelete, map<ID, Account> mapIDAccount)
	{
		
	}
	
	// AFTER DELETE LOGIC
	//
	public void OnAfterDelete(Account[] lstDeletedAccounts, map<ID, Account> mapIDAccount)
	{
		
	}
	
	// AFTER UNDELETE LOGIC
	//
	public void OnUndelete(Account[] lstRestoredAccounts)
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