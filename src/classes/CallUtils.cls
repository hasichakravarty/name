/*******************************************************************************************************************
* Apex Class Name   : CallUtils.cls
* Version           : 1.0 
* Created Date      : 30 APRIL 2014
* Function          : Utility Class for Call Object
* Modification Log  :
* Developer                   Date                    Description
* ------------------------------------------------------------------------------------------------------------------
* Mitch Hunt                  30/04/2014              Created Initial Version of Utility Class
*******************************************************************************************************************/

global class CallUtils
{
    global static void DeleteEvent(list<Call__c> lstCalls)
    {
        map<string, Event>          mapExistingCallstoEvent         = new map<string, Event>();
        list<Event>                 lstEventsToDelete               = new list<Event>();
        
        for(Call__c sCall : lstCalls)
        {
            mapExistingCallstoEvent.put(sCall.Id, null);
        }
        
        for(Event sEvent : [SELECT Id, WhatId FROM Event WHERE WhatId IN : mapExistingCallstoEvent.keyset()])
        {
            lstEventsToDelete.add(sEvent);
        }
        
        try
        {
            delete lstEventsToDelete;
        }
        catch(exception ex)
        {
            system.debug('An Error has occoured in deletion of either calls or events :::' + lstEventsToDelete + ' ::///::' + lstCalls);
        }
        
    }
    
    global static void SyncEvent(list<Call__c> lstCalls)
    {
        map<string, Event>          mapExistingEventForCallRecord   = new map<string, Event>();
        map<string, string>         mapAccountIdToName              = new map<string, string>();

        //Generate Maps from Call record to assist in the sync process
        for(Call__c c : lstCalls)
        {
            mapAccountIdToName.put(c.Account__c, ' - ');
            mapExistingEventForCallRecord.put(c.Id, null);
        }
        
        // Find the Event where the WhatId is the Current Call
        for(Event e : [select Id, WhatId from Event where isChild = false and WhatId in :mapExistingEventForCallRecord.keySet()])
        {
            mapExistingEventForCallRecord.put(e.WhatId, e);
        }
        
        // Generate a map of the Account ID to Account Names
        for(Account sAcct : [select Id, Name from Account where Id in : mapAccountIdToName.keySet()])
        {
            mapAccountIdToName.put(sAcct.Id, sAcct.Name);
        }

        // Insert and update the events
        list<Event> liEventForCallRecord = new list<Event>();
        Event sEvent = null;

        for(Call__c c : lstCalls)
        {
            // If the event does not already exist create a new event record otherwise retrieve the current event.
            if(mapExistingEventForCallRecord.get(c.Id) == null)
            {
                sEvent                = new Event();
                sEvent.WhatId         = c.Id;
            }
            else
            {
                sEvent = mapExistingEventForCallRecord.get(c.Id);
            }
            if(c.Call_Objective__c == '' || c.Call_Objective__c == null)
            {
                sEvent.Subject          = mapAccountIdToName.get(c.Account__c) + ' : Ad Hoc Call';
            }
            else
            {
                sEvent.Subject          = mapAccountIdToName.get(c.Account__c) + ' : ' + c.Call_Objective__c;
            }
            sEvent.Description      			= c.Pre_Call_Notes__c;
            sEvent.StartDateTime    			= c.Call_Start_Time__c;
            sEvent.EndDateTime      			= c.Call_End_Time__c;
            sEvent.OwnerId          			= c.OwnerId__c;
            sEvent.Type             			= 'Call';
            sEvent.Meeting_Objective__c			= c.Call_Objective__c;
            sEvent.Other_Meeting_Objective__c	= c.Other_Call_Objective__c;
            
            // If the end time is null default call date to an hour after the start date
            if(c.Call_End_Time__c == null)
            {
                sEvent.EndDateTime  = sEvent.StartDateTime.addHours(1);
            }
            else
            {
                sEvent.EndDateTime = c.Call_End_Time__c;
            }

            liEventForCallRecord.add(sEvent);
        }

        upsert liEventForCallRecord;
    }
    
}