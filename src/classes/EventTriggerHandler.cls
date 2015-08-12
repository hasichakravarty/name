/************************************************************************************************************
* Apex Class Name   : EventTriggerHandler.cls
* Version		   	: 1.0 
* Created Date	  	: 06 MARCH 2014
* Function		  	: Handler class for Event Object Trigger
* Modification Log  :
* Developer				   Date					Description
* -----------------------------------------------------------------------------------------------------------
* Mitch Hunt				  06/03/2014			  Created Default Handler Class Template
************************************************************************************************************/

public with sharing class EventTriggerHandler
{
	private boolean m_bIsExecuting = false;
	private integer iBatchSize = 0;
	
	public EventTriggerHandler(boolean bIsExecuting, integer iSize)
	{
		m_bIsExecuting = bIsExecuting;
		iBatchSize = iSize;
	}
	
	// EXECUTE BEFORE INSERT LOGIC
	//
	public void OnBeforeInsert(Event[] lstNewEvents)
	{
		
	}
	
	// EXECUTE AFTER INSERT LOGIC
	//
	public void OnAfterInsert(Event[] lstNewEvents)
	{
		
	}
	
	// BEFORE UPDATE LOGIC
	//
	public void OnBeforeUpdate(Event[] lstOldEvents, Event[] lstUpdatedEvents, map<ID, Event> mapIDEvent)
	{
		
	}
	
	// AFTER UPDATE LOGIC
	//
	public void OnAfterUpdate(Event[] lstOldEvents, Event[] lstUpdatedEvents, map<ID, Event> mapIDEvent)
	{
		map<Id, DateTime>   CallIdtoStartDateTime   = new map<Id, DateTime>();
		map<Id, DateTime>   CallIdtoEndDateTime	 = new map<Id, DateTime>();
		map<Id, String>	 CallIdtoObjective	   = new map<Id, String>();
		map<Id, String>	 CallIdtoOtherObjective  = new map<Id, String>();
		list<Call__c>	   lstCallstoUpate		 = new list<Call__c>();
		
		map<String, String> s2o = new Map<String, String>();
		map<String, Schema.SObjectType> schemas = Schema.getGlobalDescribe();
		Set<String> keys = schemas.keySet();
		
		// creating map that able to look up object name by key prefix.
		for (String key : keys)
		{
			Schema.SObjectType schema = schemas.get(key);
			Schema.DescribeSObjectResult d = schema.getDescribe();
			s2o.put(d.getKeyPrefix(), d.getName());
		}

		
		for(Event sOldEvent : lstOldEvents)
		{
			Event sNewEvent = mapIDEvent.get(sOldEvent.Id);
			String prefix = '';
			if (sNewEvent.WhatId != null) { 
				prefix = ((String)(sNewEvent.WhatId)).substring(0,3);
				String objName = s2o.get(prefix);
			
				// If the related object is a call
			 	if(objName.equals('Call__c'))
			 	{
					//and the event time has changed
					if((sNewEvent.StartDateTime != sOldEvent.StartDateTime) ||
						sNewEvent.EndDateTime != sOldEvent.EndDateTime)
					{
						CallIdtoStartDateTime.put(sNewEvent.WhatId, sNewEvent.StartDateTime);
						CallIdtoEndDateTime.put(sNewEvent.WhatId, sNewEvent.EndDateTime);
					}
				
					// Update the Objectives from the Event to Call
					if(sNewEvent.Meeting_Objective__c != sOldEvent.Meeting_Objective__c)
					{
						CallIdtoObjective.put(sNewEvent.WhatId, sNewEvent.Meeting_Objective__c);
					} 
					if(sNewEvent.Other_Meeting_Objective__c != sOldEvent.Other_Meeting_Objective__c)
					{
						CallIdtoOtherObjective.put(sNewEvent.WhatId, sNewEvent.Other_Meeting_Objective__c);
					}
				}
			}
		}
		
		for(Call__c sCall : [   SELECT  Id, Call_Start_Time__c, Call_End_Time__c, Call_Objective__c,  Other_Call_Objective__c
								FROM	Call__c 
								WHERE   (Id IN : CallIdtoStartDateTime.keyset() OR
										 Id IN : CallIdtoObjective.keyset() OR
										 Id IN : CallIdtoOtherObjective.keyset()
										 )
							 ]
			)
		{
			boolean sUpdateRequired = false;
			if (CallIdtoStartDateTime.containsKey(sCall.Id) && 
				(
					(sCall.Call_Start_Time__c	!= CallIdtoStartDateTime.get(sCall.Id)) ||
					 sCall.Call_End_Time__c	  !=  CallIdtoEndDateTime.get(sCall.Id)
				)
			   )
			{
				sCall.Call_Start_Time__c		= CallIdtoStartDateTime.get(sCall.Id);
				sCall.Call_End_Time__c		  = CallIdtoEndDateTime.get(sCall.Id);
				sUpdateRequired = true;
			}
			// Update call objective if it has been changed
			if (CallIdtoObjective.containsKey(sCall.Id) && 
				(sCall.Call_Objective__c != CallIdtoObjective.get(sCall.Id))) 
			{
				sCall.Call_Objective__c = CallIdtoObjective.get(sCall.Id);
				sUpdateRequired = true;
			}
			// Update Other call objective if it has been changed
			if (CallIdtoOtherObjective.containsKey(sCall.Id) && 
				(sCall.Other_Call_Objective__c != CallIdtoOtherObjective.get(sCall.Id))) 
			{
				sCall.Other_Call_Objective__c = CallIdtoOtherObjective.get(sCall.Id);
				sUpdateRequired = true;
			}
			
			if (sUpdateRequired)
			{
				lstCallstoUpate.add(sCall);
			}
		}
		
		update lstCallstoUpate;
	}
	
	// BEFORE DELETE LOGIC
	//
	public void OnBeforeDelete(Event[] lstEventsToDelete, map<ID, Event> mapIDEvent)
	{
		map<String, String> s2o = new Map<String, String>();
	  	map<String, Schema.SObjectType> schemas = Schema.getGlobalDescribe();
	  	Set<String> keys = schemas.keySet();
		
	  	// creating map that able to look up object name by key prefix.
	  	for (String key : keys)
	  	{
			Schema.SObjectType schema = schemas.get(key);
			Schema.DescribeSObjectResult d = schema.getDescribe();
			s2o.put(d.getKeyPrefix(), d.getName());
	  	}

		
		for(Event sDeleteEvent : lstEventsToDelete)
		{
			String prefix = '';
			if (sDeleteEvent.WhatId != null) { 
                prefix = ((String)(sDeleteEvent.WhatId)).substring(0,3);
                String objName = s2o.get(prefix);
			
                // If the related object is a call
                if(objName.equals('Call__c'))
                {
                    sDeleteEvent.addError(System.Label.CannotDeleteCallEvent);
                }
            }
		}
	}
	
	// AFTER DELETE LOGIC
	//
	public void OnAfterDelete(Event[] lstDeletedEvents, map<ID, Event> mapIDEvent)
	{
		
	}
	
	// AFTER UNDELETE LOGIC
	//
	public void OnUndelete(Event[] lstRestoredEvents)
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