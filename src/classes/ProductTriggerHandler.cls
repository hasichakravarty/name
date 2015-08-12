/************************************************************************************************************
* Apex Class Name	: ProductTriggerHandler.cls
* Version 			: 1.0 
* Created Date  	: 06 MARCH 2014
* Function 			: Handler class for Product Object Trigger
* Modification Log	:
* Developer                   Date                    Description
* -----------------------------------------------------------------------------------------------------------
* Mitch Hunt                  06/03/2014              Created Default Handler Class Template
************************************************************************************************************/

public with sharing class ProductTriggerHandler
{
	private boolean m_bIsExecuting = false;
	private integer iBatchSize = 0;
	
	public ProductTriggerHandler(boolean bIsExecuting, integer iSize)
	{
		m_bIsExecuting = bIsExecuting;
		iBatchSize = iSize;
	}
	
	// EXECUTE BEFORE INSERT LOGIC
	//
	public void OnBeforeInsert(Product2[] lstNewProducts)
	{
		
	}
	
	// EXECUTE AFTER INSERT LOGIC
	//
	public void OnAfterInsert(Product2[] lstNewProducts)
	{
		
	}
	
	// BEFORE UPDATE LOGIC
	//
	public void OnBeforeUpdate(Product2[] lstOldProducts, Product2[] lstUpdatedProducts, map<ID, Product2> mapIDProduct)
	{
		
	}
	
	// AFTER UPDATE LOGIC
	//
	public void OnAfterUpdate(Product2[] lstOldProducts, Product2[] lstUpdatedProducts, map<ID, Product2> mapIDProduct)
	{
		// If a product is made inactive flow the status through to the order line item level
		map<Id,boolean> mapProductIDtoStatus = new map<Id,boolean>();
		list<OrderLineItem__c> lstOrderLineItemtoUpdate = new list<OrderLineItem__c>();
		
		for(Product2 oldProduct : lstOldProducts)
		{
			Product2 newProduct = mapIDProduct.get(OldProduct.Id);
			
			if(oldProduct.isActive != newProduct.isActive)
			{
				mapProductIDtoStatus.put(newProduct.Id, newProduct.isActive);
			}
		}
		
		for(OrderLineItem__c oli : [SELECT Id, Product__c FROM OrderLineItem__c WHERE Order__r.Status__c = 'New' AND Product__c IN : mapProductIDtoStatus.keyset()])
		{
			oli.Is_Active_Product__c = mapProductIDtoStatus.get(oli.Product__c);
			lstOrderLineItemtoUpdate.add(oli);
		}
		
		update lstOrderLineItemtoUpdate;
	}
	
	// BEFORE DELETE LOGIC
	//
	public void OnBeforeDelete(Product2[] lstProductsToDelete, map<ID, Product2> mapIDProduct)
	{
		
	}
	
	// AFTER DELETE LOGIC
	//
	public void OnAfterDelete(Product2[] lstDeletedProducts, map<ID, Product2> mapIDProduct)
	{
		
	}
	
	// AFTER UNDELETE LOGIC
	//
	public void OnUndelete(Product2[] lstRestoredProducts)
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