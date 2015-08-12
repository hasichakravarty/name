/* ----------------------------------------------------------------------------------------------------------------------------------------------------------
  Name: Event.trigger 
  Description:    On insert/update/delete of Event record 
  Date             Version         Author    Summary of Changes 
  -----------      ----------      -----------------    ---------------------------------------------------------------------------------------------------
  03/2015         1.0            Madhusudhan                Initial Release
  ------------------------------------------------------------------------------------------------------------------------------------------------------------ */

trigger Event on Event (after delete, after insert, after undelete, after update, before delete, before insert, before update)
{
    createNewEventOnOpportunity newEvent = new createNewEventOnOpportunity();
    EventTriggerHandler Handler = new EventTriggerHandler(Trigger.isExecuting, Trigger.size);
    List<Id> LeadIds = New List<Id>();
    Id RecordTypeIdVal = [Select id from RecordType where sObjectType = 'Event' AND RecordType.Name='Interview'].Id;
//To bypass the trigger.
  	Bypass_Settings__c bypass = Bypass_Settings__c.getInstance();
    	if (!bypass.Disable_Triggers__c ) 
		{ 
    		if(Trigger.isInsert && Trigger.isBefore)
    		{
        		Handler.OnBeforeInsert(Trigger.new);
    		}

    // After Insert Logic
    
    		else if(Trigger.isInsert && Trigger.isAfter)
    		{
        		Handler.OnAfterInsert(Trigger.new);
        		newEvent.createNewEvent(Trigger.New); 
        			for(Event E: Trigger.New){
            			if(E.whoId != null && E.RecordTypeId != null && E.Status__c != null)
            			{      
          					if(E.RecordTypeId==RecordTypeIdval && (E.Reason_for_Cancellation__c=='No Show' || E.Reason_for_Cancellation__c=='Student Cancels') && String.valueOf(E.whoId).startsWith('00Q'))
                            {
             					Leadids.add(E.WhoId);
            					LeadUpdateonEventBased.LeadfieldUpdate(LeadIds); 
          					}
           				}
        			}
    		}
    // Before Update Logic
    		else if(Trigger.isUpdate && Trigger.isBefore)
    		{
        		newEvent.createNewEvent(Trigger.New); 
        		Handler.OnBeforeUpdate(Trigger.old, Trigger.new, Trigger.newMap);
    		}
    // After Update Logic
    		else if(Trigger.isUpdate && Trigger.isAfter)
    		{
        		Handler.OnAfterUpdate(Trigger.old, Trigger.new, Trigger.newMap);
             		for(Event E: Trigger.New)
                    {
          				if(E.whoId != null && E.RecordTypeId != null && E.Status__c != null)
            			{  
          					if(E.RecordTypeId==RecordTypeIdVal && (E.Reason_for_Cancellation__c=='No Show' || E.Reason_for_Cancellation__c=='Student Cancels') && Trigger.oldmap.get(E.Id).Status__c!='No Show' && Trigger.oldmap.get(E.Id).Status__c!='Student Cancellation' && String.valueOf(E.whoId).startsWith('00Q')){
               					LeadIds.add(E.WhoId);
           						LeadUpdateonEventBased.LeadfieldUpdate(LeadIds);  
          					}
           					if( E.RecordTypeId==RecordTypeIdval && (E.Status__c=='Completed' || E.Status__c=='Scheduled' || E.Status__c=='To be Scheduled' || E.Status__c== 'Deferred' || E.Reason_for_Cancellation__c=='Interviewer Cancels') && Trigger.oldmap.get(E.Id).Status__c=='Cancelled' && String.valueOf(E.whoId).startsWith('00Q'))
          					{
             					LeadIds.add(E.WhoId);
        						LeadUpdateonEventBased.LeadfieldUpdateDecrement(LeadIds);
          					}
          				}  
             		}
        
    		}
    // Before Delete Logic
    		else if(Trigger.isDelete && Trigger.isBefore)
    		{
        		Handler.OnBeforeDelete(Trigger.old, Trigger.oldMap);
        
        	}
    // After Delete Logic
    		else if(Trigger.isDelete && Trigger.isAfter)
    		{
        		Handler.OnAfterDelete(Trigger.old, Trigger.oldMap);
         		for(Event E: Trigger.old)
                {
               		if(E.whoId != null && E.RecordTypeId != null && E.Status__c == 'Cancelled' && (E.Reason_for_Cancellation__c=='No Show' || E.Reason_for_Cancellation__c=='Student Cancels') )
           			{
             			Leadids.add(E.WhoId);
            			LeadUpdateonEventBased.LeadfieldUpdateDecrement(LeadIds);
           			}  
             	}

             }
    
    // After Undelete Logic
    		else if(Trigger.isUnDelete)
    		{
        		Handler.OnUndelete(Trigger.new);
    		}
    }
}