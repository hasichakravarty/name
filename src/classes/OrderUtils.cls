/*******************************************************************************************************************
* Apex Class Name	: OrderUtils.cls
* Version 			: 1.0 
* Created Date  	: 06 MAY 2014
* Function 			: Utility Class for Order Object
* Modification Log	:
* Developer                   Date                    Description
* ------------------------------------------------------------------------------------------------------------------
* Mitch Hunt                  06/05/2014              Created Initial Version of Utility Class
*******************************************************************************************************************/

public without sharing class OrderUtils
{
	// When an OrderLineItem is inserted or updated populate the value of Is_Active_Product__c
	//
	public void updateProductStatusByLine (OrderLineItem__c[] lstNewOrderLines)
	{
		
		Set<Id> lstOrderedProducts 			= new Set<Id>();
		Map<Id, Product2> mapActiveProducts = null;
		
		for (OrderLineItem__c sOrderLineItem : lstNewOrderLines)
		{
			lstOrderedProducts.add(sOrderLineItem.Product__c);
		}
		
		mapActiveProducts = new Map<Id, Product2>([SELECT isActive from Product2 where Id in: lstOrderedProducts]);
		
		for (OrderLineItem__c sOrderLineItem : lstNewOrderLines)
		{
			sOrderLineItem.Is_Active_Product__c = mapActiveProducts.get(sOrderLineItem.Product__c).isActive;
		}

	}
	
	// Create Order__c Follow up activities
	//
	public void createFollowUpActivities(Order__c[] lstOpportunities)
	{
		
		list<ActivityTemplate__c>					lstActivityTemplates				= new list<ActivityTemplate__c>();
		map<String, String>							lstOrderIdtoBillingCountry			= new map<String, String>();
		map<String, list<OrderLineItem__c>>			lstOrderIdtoLineItems				= new map<String, list<OrderLineItem__c>>();
		list<Task>									lstTasksToInsert					= new list<Task>();
		
		// Retrieve the list of active activity templates
		lstActivityTemplates = [	SELECT Id, Active__c, Related_To__c, Stage__c, Status__c,
									Account_Location__c, Default_Owner__c, Subject__c, Days_Until_Due__c,
									Description__c, NPS_Rating_Required__c, Product_Type__c
									FROM ActivityTemplate__c WHERE Active__c = true AND Related_To__c = 'Order'];
		
		for(Order__c sOrder : lstOpportunities)
		{
			lstOrderIdtoBillingCountry.put(sOrder.Id, null);
			lstOrderIdtoLineItems.put(sOrder.Id, null);
		}
		
		for(OrderLineItem__c sOrderLineItem : [	SELECT Id, Order__c, Product__r.ProductType__c
													FROM OrderLineItem__c 
													WHERE Order__c 
													IN : lstOrderIdtoLineItems.keyset()])
													{
														if(lstOrderIdtoLineItems.get(sOrderLineItem.Order__c)  == null)
														{
															lstOrderIdtoLineItems.put(sOrderLineItem.Order__c, new list<OrderLineItem__c>());
														}
														
														lstOrderIdtoLineItems.get(sOrderLineItem.Order__c).add(sOrderLineItem);
													}
		
		for(Order__c sOrder : [SELECT Id, Account__r.BillingCountry FROM Order__c WHERE Id IN : lstOrderIdtoBillingCountry.keyset()])
		{
			lstOrderIdtoBillingCountry.put(sOrder.Id, sOrder.Account__r.BillingCountry);
		}
		
		for(Order__c sOrder : lstOpportunities)
		{
			
			//Check the current activity templtes against this oppportunity.
			for(ActivityTemplate__c sActivityTemplate : lstActivityTemplates)
			{
				if(	sActivityTemplate.Status__c				== sOrder.Status__c &&
					sActivityTemplate.Account_Location__c	== lstOrderIdtoBillingCountry.get(sOrder.Id))
				{
					Task sTask							= new Task();
					sTask.Subject						= sActivityTemplate.Subject__c;
					sTask.ActivityDate					= system.today().addDays((Integer)sActivityTemplate.Days_Until_Due__c);
					sTask.Description					= sActivityTemplate.Description__c;
					sTask.NPS_Rating_Required__c		= sActivityTemplate.NPS_Rating_Required__c;
					sTask.WhatId						= sOrder.Id;
					
					if(sActivityTemplate.Default_Owner__c != null)
					{
						sTask.OwnerId					= sActivityTemplate.Default_Owner__c;
					}
					else
					{
						if(sOrder.Salesperson__c != null)
						{
							sTask.OwnerId					= sOrder.Salesperson__c; // No Owner, Master Detail
						}
						else
						{
							sTask.OwnerId					= sOrder.LastModifiedById;
						}
					}
					
					if(sActivityTemplate.Product_Type__c != null && sActivityTemplate.Product_Type__c != '')
					{
						// We need to check the line items to check if
						
						list<OrderLineItem__c> lstRelatedLineItems = lstOrderIdtoLineItems.get(sOrder.Id);
						
						if(lstRelatedLineItems != null && lstRelatedLineItems.size() > 0)
						{
							for(OrderLineItem__c oli : lstRelatedLineItems)
							{
								// Check if the product type matches
								if(sActivityTemplate.Product_Type__c == oli.Product__r.ProductType__c)
								{
									// May have multiple of the same line potentially, break loop
									lstTasksToInsert.add(sTask);
									break;
								}
							}
						}
					}
					else
					{
						// Product type is null so do not worry about line items
						lstTasksToInsert.add(sTask);
					}
				}
			}
			
		}
		
		insert lstTasksToInsert;
	
	}
	
}