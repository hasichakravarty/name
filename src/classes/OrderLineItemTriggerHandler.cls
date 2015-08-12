/************************************************************************************************************
* Apex Class Name	: OrderLineItemTriggerHandler.cls
* Version 			: 1.0 
* Created Date  	: 06 MAY 2014
* Function 			: Handler class for Order Object Trigger
* Modification Log	:
* Developer                   Date                    Description
* -----------------------------------------------------------------------------------------------------------
* Mitch Hunt                  06/05/2014              Created Default Handler Class Template
************************************************************************************************************/

public without sharing class OrderLineItemTriggerHandler
{
	private boolean m_bIsExecuting = false;
	private integer iBatchSize = 0;
	
	public OrderLineItemTriggerHandler(boolean bIsExecuting, integer iSize)
	{
		m_bIsExecuting = bIsExecuting;
		iBatchSize = iSize;
	}
	
	OrderUtils Utils = new OrderUtils();
	
	// EXECUTE BEFORE INSERT LOGIC
	//
	public void OnBeforeInsert(OrderLineItem__c[] lstNewOrders)
	{
		Utils.updateProductStatusByLine(lstNewOrders);
	}
	
	// EXECUTE AFTER INSERT LOGIC
	//
	public void OnAfterInsert(OrderLineItem__c[] lstNewOrderLines)
	{
		set<ID> setOrderIds = new set<ID>();
		
		for(OrderLineItem__c oli : lstNewOrderLines)
		{
			setOrderIds.add(oli.Order__c);
		}
		
		String strQuery = 'SELECT ';
		
		Map<String, Schema.SObjectField> schemaFieldMap = Schema.SObjectType.Order__c.fields.getMap();
		for (String fieldName: schemaFieldMap.keySet())
		{
			strQuery += fieldName + ', ';
		}
		
		strQuery = strQuery.substring(0, strQuery.length() - 2);
		strQuery += ' FROM Order__c WHERE ID IN : setOrderIds';
		
		system.debug('thequery:::' + strQuery);
		
		list<Order__c> lstOrders = database.query(strQuery);
		
		Utils.createFollowUpActivities(lstOrders);
	}
	
	// BEFORE UPDATE LOGIC
	//
	public void OnBeforeUpdate(OrderLineItem__c[] lstOldOrderLines, OrderLineItem__c[] lstUpdatedOrderLines, map<ID, OrderLineItem__c> mapIDOrderLines)
	{
		
	}
	
	// AFTER UPDATE LOGIC
	//
	public void OnAfterUpdate(OrderLineItem__c[] lstOldOrderLines, OrderLineItem__c[] lstUpdatedOrderLines, map<ID, OrderLineItem__c> mapIDOrderLines)
	{
		
	}
	
	// BEFORE DELETE LOGIC
	//
	public void OnBeforeDelete(OrderLineItem__c[] lstOrderLinesToDelete, map<ID, OrderLineItem__c> mapIDOrderLines)
	{
		
	}
	
	// AFTER DELETE LOGIC
	//
	public void OnAfterDelete(OrderLineItem__c[] lstDeletedOrderLines, map<ID, OrderLineItem__c> mapIDOrderLines)
	{
		
	}
	
	// AFTER UNDELETE LOGIC
	//
	public void OnUndelete(OrderLineItem__c[] lstRestoredOrderLines)
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