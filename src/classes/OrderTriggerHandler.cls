/************************************************************************************************************
* Apex Class Name	: OrderTriggerHandler.cls
* Version 			: 1.0 
* Created Date  	: 06 MAY 2014
* Function 			: Handler class for Order Object Trigger
* Modification Log	:
* Developer                   Date                    Description
* -----------------------------------------------------------------------------------------------------------
* Mitch Hunt                  06/05/2014              Created Default Handler Class Template
************************************************************************************************************/

public without sharing class OrderTriggerHandler
{
	private boolean m_bIsExecuting = false;
	private integer iBatchSize = 0;
	
	public OrderTriggerHandler(boolean bIsExecuting, integer iSize)
	{
		m_bIsExecuting = bIsExecuting;
		iBatchSize = iSize;
	}
	
	OrderUtils Utils = new OrderUtils();
	
	// EXECUTE BEFORE INSERT LOGIC
	//
	public void OnBeforeInsert(Order__c[] lstNewOrders)
	{
		
	}
	
	// EXECUTE AFTER INSERT LOGIC
	//
	public void OnAfterInsert(Order__c[] lstNewOrders)
	{
		Utils.createFollowUpActivities(lstNewOrders);
	}
	
	// BEFORE UPDATE LOGIC
	//
	public void OnBeforeUpdate(Order__c[] lstOldOrders, Order__c[] lstUpdatedOrders, map<ID, Order__c> mapIDOrder, map<ID, Order__c> mapIDOldOrder)
	{
		List<OrderLineItem__c> recordToUpdate = new List<OrderLineItem__c>();
		
		for (Order__c order: [
								select 	Id, Status__c, (
															SELECT 	ID, Status__c 
															FROM 	Order_Line_Items__r
														) 
								FROM 	Order__c 
								WHERE 	Id IN :mapIDOrder.keySet()
							])
		{
			System.Debug('***********************************************************************************');
			System.Debug('Order ID : ' + order.Id);
			System.Debug('Status : ' + mapIDOrder.get(order.Id).Status__c);
			System.Debug('Old Status : ' + mapIDOldOrder.get(order.Id).Status__c);
			System.Debug('Lines : ' + order.Order_Line_Items__r);
			
			if(		mapIDOrder.get(order.Id).Status__c == 'Approved'
				&&	mapIDOldOrder.get(order.Id).Status__c != 'Approved')
			{
				Integer lineNumber = 0;
				for(OrderLineItem__c item : order.Order_Line_Items__r)
				{
					item.LineNo__c = ++lineNumber;
					recordToUpdate.add(item);
				}
			}
		}
		update recordToUpdate;
	}
	
	// AFTER UPDATE LOGIC
	//
	public void OnAfterUpdate(Order__c[] lstOldOrders, Order__c[] lstUpdatedOrders, map<ID, Order__c> mapIDOrder)
	{
		
		list<Order__c> lstOrderstoEval		= new list<Order__c>();
		
		for(Order__c sOldOrder : lstOldOrders)
		{
			Order__c sNewOrder = mapIDOrder.get(sOldOrder.Id);
			
			// If an Order stage or status has changed evaluate if they need a task created.
			if(sOldOrder.Status__c != sNewOrder.Status__c)
			{
				lstOrderstoEval.add(sNewOrder);
			}
		}
		
		Utils.createFollowUpActivities(lstOrderstoEval);
	}
	
	// BEFORE DELETE LOGIC
	//
	public void OnBeforeDelete(Order__c[] lstOrdersToDelete, map<ID, Order__c> mapIDOrder)
	{
		
	}
	
	// AFTER DELETE LOGIC
	//
	public void OnAfterDelete(Order__c[] lstDeletedOrders, map<ID, Order__c> mapIDOrder)
	{
		
	}
	
	// AFTER UNDELETE LOGIC
	//
	public void OnUndelete(Order__c[] lstRestoredOrders)
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