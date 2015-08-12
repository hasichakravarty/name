/*******************************************************************************************************************
* Apex Class Name	: CallAttendeeUtils.cls
* Version 			: 1.0 
* Created Date  	: 30 APRIL 2014
* Function 			: Utility Class for CallAttendee Object
* Modification Log	:
* Developer                   Date                    Description
* ------------------------------------------------------------------------------------------------------------------
* Mitch Hunt                  30/04/2014              Created Initial Version of Utility Class
*******************************************************************************************************************/

global class CallAttendeeUtils
{
	global static void SyncEventAttendees(list<CallAttendee__c> lstCallAttendees)
	{
		map<string, Event> 					mapExistingEventForCallRecord 	= new map<string, Event>();
		map<String, String>					mapExistingEventtoCallId		= new map<String, String>();
		map<CallAttendee__c, String>		mapCallAttendeetoEventId		= new map<CallAttendee__c, String>();
		map<String, list<EventRelation>>	mapExistingEventtoRelations		= new map<String, list<EventRelation>>();
		list<EventRelation>					lstAttendeestoInsert			= new list<EventRelation>();
		map<String, Call__c>				mapCallIdtoCall					= new map<String, Call__c>();

		//Generate Map from CallId to assist in the sync process
		for(CallAttendee__c sCallAttendee : lstCallAttendees)
		{
			mapExistingEventForCallRecord.put(sCallAttendee.Call__c, null);
			mapCallIdtoCall.put(sCallAttendee.Call__c, null);
		}
		
		for(Call__c sCall : [select Id, Account__c FROM Call__c WHERE Id IN : mapCallIdtoCall.keyset()])
		{
			mapCallIdtoCall.put(sCall.Id, sCall);
		}
		
		// Find the Event where the WhatId is the Current Call
		for(Event e : [select Id, WhatId, IsChild from Event where WhatId in :mapExistingEventForCallRecord.keySet() and IsChild = false])
		{
			mapExistingEventForCallRecord.put(e.WhatId, e);
			mapExistingEventtoCallId.put(e.Id, e.WhatId);
			mapExistingEventtoRelations.put(e.Id,new list<EventRelation>());
			
			system.debug('event:::' + e);
		}
		
		//get the appropriate event id for each attendee
		for(CallAttendee__c sCallAttendee : lstCallAttendees)
		{
			mapCallAttendeetoEventId.put(sCallAttendee, mapExistingEventForCallRecord.get(sCallAttendee.Call__c).Id);
		}
		
		// Get a list of the current event relations
		for(EventRelation sEventRelation : [SELECT AccountId, EventId, RelationId 
											FROM EventRelation 
											WHERE EventId IN : mapExistingEventtoCallId.keyset()])
		{
			mapExistingEventtoRelations.get(sEventRelation.EventId).add(sEventRelation);
		}
		
		// for each call attendee get the list of existing EventRelations
		for(CallAttendee__c sCallAttendee : lstCallAttendees)
		{
			String strEventId 		= mapCallAttendeetoEventId.get(sCallAttendee);
			boolean bAttendeeExists = false;
			
			list<EventRelation> lstEventRelations = mapExistingEventtoRelations.get(strEventId);
			
			// Loop through the current list of relations to see if it already exists
			for(EventRelation sEventRelation : lstEventRelations)
			{
				if((sCallAttendee.Client__c != null && sEventRelation.RelationId == sCallAttendee.Client__c) ||
					(sCallAttendee.Pearson_Employee__c != null && sEventRelation.RelationId == sCallAttendee.Pearson_Employee__c))
				{
					// We have found the same attendee already no need to insert break loop
					bAttendeeExists = true;
					break;
				}
			}
			
			if(bAttendeeExists == false)
			{
				EventRelation sEventRelation	= new EventRelation();
				system.debug('strEventId:::' + strEventId);
				sEventRelation.EventId			= strEventId;
				
				if(sCallAttendee.Client__c != null)
				{
					sEventRelation.RelationId	= sCallAttendee.Client__c;
				}
				else
				{
					sEventRelation.RelationId	= sCallAttendee.Pearson_Employee__c;
				}
				
				lstAttendeestoInsert.add(sEventRelation);
			}
		}
		// Insert the appropriate attendee records
		insert lstAttendeestoInsert;
		
	}
	
	global static void deleteAttendees(list<CallAttendee__c> lstCallAttendees)
	{
		list<EventRelation>						lstEventRelationstoDel				= new list<EventRelation>();
		map<String, list<CallAttendee__c>>		mapEventIdtoCallAttendees			= new map<String, list<CallAttendee__c>>();
		map<String, String>						mapCallIdtoEventId					= new map<String, String>();
		
		//Generate Map from CallId to assist in the sync process
		for(CallAttendee__c sCallAttendee : lstCallAttendees)
		{
			mapCallIdtoEventId.put(sCallAttendee.Call__c, null);
		}
		
		for(Event sEvent : [SELECT Id, WhatId FROM Event WHERE WhatId IN : mapCallIdtoEventId.keyset()])
		{
			mapCallIdtoEventId.put(sEvent.WhatId, sEvent.Id);
		}
		
		for(CallAttendee__c sCallAttendee : lstCallAttendees)
		{
			if(mapEventIdtoCallAttendees.get(mapCallIdtoEventId.get(sCallAttendee.Call__c)) == null)
			{
				mapEventIdtoCallAttendees.put(mapCallIdtoEventId.get(sCallAttendee.Call__c), new list<CallAttendee__c>());
			}
		
			mapEventIdtoCallAttendees.get(mapCallIdtoEventId.get(sCallAttendee.Call__c)).add(sCallAttendee);	
		}
		
		// Select all the event relations related to this event
		for(EventRelation sEventRelation : [SELECT Id, EventId, RelationId FROM EventRelation WHERE EventId IN : mapEventIdtoCallAttendees.keyset()])
		{
			list<CallAttendee__c>	lstRelatedCallAttendees	= mapEventIdtoCallAttendees.get(sEventRelation.EventId);
			
			// For each attendee record check against this relation
			for(CallAttendee__c sCallAttendee : lstRelatedCallAttendees)
			{
				if(sCallAttendee.Client__c != null && sEventRelation.RelationId == sCallAttendee.Client__c ||
					sCallAttendee.Pearson_Employee__c != null && sEventRelation.RelationId == sCallAttendee.Pearson_Employee__c)
				{
					lstEventRelationstoDel.add(sEventRelation);
					break; // Can only add to list once
				}
			}
		}
		
		system.debug('lstEventRelationstoDel:::' + lstEventRelationstoDel);
		
		delete lstEventRelationstoDel;
	}
}