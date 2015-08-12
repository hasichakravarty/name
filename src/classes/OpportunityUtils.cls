/*******************************************************************************************************************
* Apex Class Name	: OpportunityUtils.cls
* Version 			: 1.0 
* Created Date  	: 03 APRIL 2014
* Function 			: Utility Class for Opportunity Object
* Modification Log	:
* Developer                   Date                    Description
* ------------------------------------------------------------------------------------------------------------------
* Mitch Hunt                  03/04/2014              Created Initial Version of Utility Class
*******************************************************************************************************************/

public without sharing class OpportunityUtils
{
	// Creates clone opportunities
	//
	public void createReEngagementClones(Set<Id> setOpportunitiesToClone, set<String> setCloneOpptyIds, list<Opportunity> opptiesToClone)
	{
		// list of fields to ignore in soql
		set<String> setOpptyOmitFields				= new set<String>{'syncedquoteid'};
		set<String> setOLIOmitFields 				= new set<String>{'syncedquoteid'};
		// dynamic soql query
		String strOppQuery 							= 'SELECT ';
		
		// get a list of cloned oppties that still exist in the system
		map<Id, Opportunity> mapClonedOppties 		= new map<Id, Opportunity>([SELECT Id FROM Opportunity WHERE Id IN: setCloneOpptyIds]);
		
		// stores new records (oppties and lines) that we will insert
		map<integer, Opportunity> mapClonesToInsert = new map<integer, Opportunity>();
		list<OpportunityLineItem> lstClonedOLI		= new list<OpportunityLineItem>();
		
		// All the fields we need to pull into our query
		Set<String> setOpptyFields 	= Opportunity.sObjectType.getDescribe().fields.getMap().keySet();
		Set<String> setOLIFields 	= OpportunityLineItem.sObjectType.getDescribe().fields.getMap().keySet();
		
		// build our SOQL query
		// add oppty fields first
		for (String sOpptyField : setOpptyFields)
		{
			if (!setOpptyOmitFields.contains(sOpptyField))
			{
				strOppQuery += sOpptyField + ', ';
			}
		}
		
		// add a relationship query for the line items
		strOppQuery += '(SELECT';
		integer intFieldPosition = 1;
		integer intCountOpptyFields = setOLIFields.size();
		for (String sOLIField : setOLIFields)
		{
			if (!setOLIOmitFields.contains(sOLIField)) {
				strOppQuery += ' ' + sOLIField;
			}
			
			if (intFieldPosition++ < intCountOpptyFields) {
				strOppQuery += ',';
			} else {
				strOppQuery += ' FROM OpportunityLineItems where PriceBookEntry.isActive = true)';
			}
		}
		
		strOppQuery += ' FROM Opportunity WHERE Id IN: setOpportunitiesToClone AND Id NOT IN: setCloneOpptyIds';
		
		map<Id, Opportunity> mapSavedOpportunitiesToBeCloned = new map<Id, Opportunity>((list<Opportunity>)database.query(strOppQuery));
		map<Id, integer> mapOriginalIdToClonePosition = new map<Id, integer>();
		integer intTriggerListPosition = 0;
		for (Opportunity sOpportunity : opptiesToClone)
		{
			// skip this record if there is an existing clone in the database
			if (sOpportunity.Clone_Oppty__c <> null && mapClonedOppties.containsKey(sOpportunity.Clone_Oppty__c))
			{
				intTriggerListPosition++;
				continue;
			}
			// Create a clone of the oppty we have queried (if it has an Id) as the dynamic soql will exclude fields we need to omit
			else if (sOpportunity.Id <> null)
			{
				mapClonesToInsert.put(intTriggerListPosition, createOpportunityClone(mapSavedOpportunitiesToBeCloned.get(sOpportunity.Id)));
				lstClonedOLI.addAll(createOLIClone(mapSavedOpportunitiesToBeCloned.get(sOpportunity.Id).OpportunityLineItems));
				mapOriginalIdToClonePosition.put(sOpportunity.Id, intTriggerListPosition);
			}
			// Otherwise create a clone of the oppty passed to the trigger (has no id means just inserted, so there won't be line items or linked quotes)
			else
			{
				mapClonesToInsert.put(intTriggerListPosition, createOpportunityClone(sOpportunity));
			}
			// increment our position in trigger.new
			intTriggerListPosition++;
		}
		
		SavePoint sp = Database.setSavePoint();
		try
		{
			insert mapClonesToInsert.values();
			// Update the Ids of the cloned OLIs to the newly inserted oppties
			list<OpportunityLineItem> lstInsertOLIs = new list<OpportunityLineItem>();
			
			for (OpportunityLineItem sOLI : lstClonedOLI) 
			{
				OpportunityLineItem sClone = sOLI.clone(false, true);
				sClone.OpportunityId = mapClonesToInsert.get(mapOriginalIdToClonePosition.get(sOLI.OpportunityId)).Id;
				sCLone.Id = null;
				lstInsertOLIs.add(sClone);
			}
			// insert the line items
			insert lstInsertOLIs;
			
			// if successful, populate Id of the cloned opportunity on the original opportunity
			integer intUpdateListPosition = 0;
			for (Opportunity sOpportunity : opptiesToClone)
			{
				sOpportunity.Clone_Oppty__c = mapClonesToInsert.get(intUpdateListPosition++).Id;
			}
		}
		catch (Exception e)
		{
			System.debug(e.getMessage());
			database.rollback(sp);
		}
	}
	
	// Helper class to separate logic of cloning Opportunities
	//
	private static Opportunity createOpportunityClone(Opportunity sOpportunity)
	{
		// Create the clone
		Opportunity sCloneOpp 				= sOpportunity.clone(false, true);
		sCloneOpp.Re_engagement_Date__c		= null;
		sCloneOpp.Renewal_Date__c			= null;
		sCloneOpp.IsRenewal__c				= sOpportunity.isWon;
		sCloneOpp.Original_Oppty__c			= sOpportunity.Id;
		sCloneOpp.Stagename					= 'Prospecting';
		sCloneOpp.Probability				= 0;
		
		if(sOpportunity.Renewal_Date__c != null) {
			sCloneOpp.closeDate	= sOpportunity.Renewal_Date__c;
		} else {
			sCloneOpp.closeDate	= system.today().addmonths(6);
		}
		
		if(sOpportunity.Re_engagement_Date__c != null) {
			sCloneOpp.Legacy_Engagement_Date__c	= sOpportunity.Re_engagement_Date__c;
		} else {
			sCloneOpp.Legacy_Engagement_Date__c	= sCloneOpp.closeDate.addmonths(-1);
		}
		
		return sCloneOpp;
	}
	
	// Helper function separate logic for cloning OpportunityLineItems
	//
	private static list<OpportunityLineItem> createOLIClone(list<OpportunityLineItem> sOLIs)
	{
		list<OpportunityLineItem> sResult = new list<OpportunityLineItem>();
		for (OpportunityLineItem sOLI : sOLIs)
		{
			OpportunityLineItem sCloneOLI 	= sOLI.clone(false, true);
			sCloneOLI.ServiceDate			= null;
			sCloneOLI.TotalPrice			= null;
			sResult.add(sCloneOLI);
		}
		return sResult;
	}
	
	// Create Opportunity Follow up activities
	//
	public void createFollowUpActivities(Opportunity[] lstOpportunities)
	{
		
		list<ActivityTemplate__c>					lstActivityTemplates				= new list<ActivityTemplate__c>();
		map<String, String>							lstOpptyIdtoBillingCountry			= new map<String, String>();
		map<String, list<OpportunityLineItem>>		lstOpptyIdtoLineItems				= new map<String, list<OpportunityLineItem>>();
		list<Task>									lstTasksToInsert					= new list<Task>();
		
		// Retrieve the list of active activity templates
		lstActivityTemplates = [	SELECT Id, Active__c, Related_To__c, Stage__c, Status__c,
									Default_Owner__c, Subject__c, Days_Until_Due__c,
									Description__c, NPS_Rating_Required__c, Product_Type__c
									FROM ActivityTemplate__c WHERE Active__c = true AND Related_To__c = 'Opportunity'];
		
		for(Opportunity sOpportunity : lstOpportunities)
		{
			lstOpptyIdtoBillingCountry.put(sOpportunity.Id, null);
			lstOpptyIdtoLineItems.put(sOpportunity.Id, null);
		}
		
		for(OpportunityLineItem sOpptyLineItem : [	SELECT Id, OpportunityId, PriceBookEntry.Product2.ProductType__c
													FROM OpportunityLineItem 
													WHERE OpportunityId 
													IN : lstOpptyIdtoLineItems.keyset()])
													{
														if(lstOpptyIdtoLineItems.get(sOpptyLineItem.OpportunityId) == null)
														{
															lstOpptyIdtoLineItems.put(sOpptyLineItem.OpportunityId, new list<OpportunityLineItem>());
														}
														
														lstOpptyIdtoLineItems.get(sOpptyLineItem.OpportunityId).add(sOpptyLineItem);
													}
		
		for(Opportunity sOpportunity : [SELECT Id, Account.BillingCountry FROM Opportunity WHERE Id IN : lstOpptyIdtoBillingCountry.keyset()])
		{
			lstOpptyIdtoBillingCountry.put(sOpportunity.Id, sOpportunity.Account.BillingCountry);
		}
		
		for(Opportunity sOpportunity : lstOpportunities)
		{
			
			//Check the current activity templtes against this oppportunity.
			for(ActivityTemplate__c sActivityTemplate : lstActivityTemplates)
			{
				if(	sActivityTemplate.Stage__c				== sOpportunity.StageName &&
					sActivityTemplate.Status__c				== sOpportunity.Status__c //&&
					//sActivityTemplate.Account_Location__c	== lstOpptyIdtoBillingCountry.get(sOpportunity.Id)
					)
				{
					Task sTask							= new Task();
					sTask.Subject						= sActivityTemplate.Subject__c;
					sTask.ActivityDate					= system.today().addDays((Integer)sActivityTemplate.Days_Until_Due__c);
					sTask.Description					= sActivityTemplate.Description__c;
					sTask.NPS_Rating_Required__c		= sActivityTemplate.NPS_Rating_Required__c;
					sTask.WhatId						= sOpportunity.Id;
					
					if(sActivityTemplate.Default_Owner__c != null)
					{
						sTask.OwnerId					= sActivityTemplate.Default_Owner__c;
					}
					else
					{
						sTask.OwnerId					= sOpportunity.OwnerId;
					}
					
					if(sActivityTemplate.Product_Type__c != null)
					{
						// We need to check the line items to check if
						
						list<OpportunityLineItem> lstRelatedLineItems = lstOpptyIdtoLineItems.get(sOpportunity.Id);
						
						if(lstRelatedLineItems != null && lstRelatedLineItems.size() > 0)
						{
							for(OpportunityLineItem oli : lstRelatedLineItems)
							{
								// Check if the product type matches
								if(sActivityTemplate.Product_Type__c == oli.PriceBookEntry.Product2.ProductType__c)
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