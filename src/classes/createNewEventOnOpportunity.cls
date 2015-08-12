/*************************************************************
@Author     : Accenture IDC
@Description: Controller being called from createNewEventOnOpportunity trigger to create a new event on opportunity
@Date       : 23/03/2015
**************************************************************/
public class createNewEventOnOpportunity
{
public Integer recordCounter = 1;
public Map<ID,ID> MapContactIdWithOpptyId;
public Map<ID,Opportunity> MapOpptyIdWithOppty;
public Event newEvent;
public List<Event> listWithNewEvent;
public Set<ID> setWithOpptyId;
public Map<String,Integer> mapOpportunityIdWithEventCount;
public Map<Id,Event> mapEventIdWithEvent;
public Set<ID> setOppIdForNewEvent;

// Method checks for event on opportunity and if the condition is satisfied,then a new event is created.

public void createNewEvent(List<Event> eventList)
{
    MapContactIdWithOpptyId = new Map<ID,ID>();
    MapOpptyIdWithOppty = new Map<ID,Opportunity>();
    setOppIdForNewEvent = new Set<ID>();
    listWithNewEvent = new List<Event>();
    setWithOpptyId = new Set<ID>();
    mapEventIdWithEvent = new Map<Id,Event>();  
    mapOpportunityIdWithEventCount = new Map<String,Integer>();   
    try
    {    
    if(Utility.stopRecursion != true )
    { 
    System.debug(Utility.stopRecursion); 
    for(Event eventVal : eventList)
    {
        if(String.ValueOf((eventVal.WhatId)).left(3) == '006' )
        {        
            setWithOpptyId.add(eventVal.WhatId);       
        }
    }
    if(!setWithOpptyId.isEmpty())    
    {
        for(AggregateResult eventRec: [select WhatID,Count(Id) idCount from Event where WhatId IN : setWithOpptyId AND IsArchived = false Group By WhatId])
        { 
            Integer recCou = Integer.ValueOf(eventRec.get('idCount'));
            String OppId = String.ValueOf(eventRec.get('WhatId'));            
            mapOpportunityIdWithEventCount.put(OppId,recCou); 
        } 
        for(Opportunity oppValues : [select Id,Academic_Start_Date__c,Academic_End_Date__c,OwnerId from opportunity where Id IN : setWithOpptyId])
        {
            MapOpptyIdWithOppty.put(oppValues.Id,oppValues);
        }        
        for(opportunityContactRole opptyConRole : [select contactId,opportunityId from opportunityContactRole where (Role =: 'Primary Sales Contact' OR Role =: 'Business User') AND Id IN : setWithOpptyId])
        {
            MapContactIdWithOpptyId.put(opptyConRole.opportunityId,opptyConRole.contactId);
        }        
    }    
    if(!mapOpportunityIdWithEventCount.isEmpty())
    {    
        for(Event  eventIteration : [select Id,WhatID,subject__c,Status__c,Subject from Event where whatId IN : mapOpportunityIdWithEventCount.keyset() AND IsArchived = false])
        {
            mapEventIdWithEvent.put(eventIteration.Id,eventIteration);
        }    
    }
    if(!mapOpportunityIdWithEventCount.isEmpty())
    { 
    for(String recordCount : mapOpportunityIdWithEventCount.keyset())
    {
       newEvent = new Event();
       if(!mapOpportunityIdWithEventCount.isEmpty())
       { 
           if(mapOpportunityIdWithEventCount.get(recordCount) > 2)
           {  
              if(!mapEventIdWithEvent.isEmpty())
              {                
              for(Event eventMap : mapEventIdWithEvent.Values())
              {
                 System.debug(eventMap.WhatID +recordCount);  
                 System.debug(eventMap.WhatID); 
                 System.debug(eventMap.subject__c);   
                 System.debug(eventMap.Status__c);  
               if(eventMap.Subject == 'Enrollment Date - Returning Interview')
                break;   
               if(eventMap.WhatID == recordCount && eventMap.subject__c == 'Returning Student Interview' && eventMap.Status__c == 'Cancelled' || eventMap.Status__c == 'Deferred')
               {
                   recordCounter++;
                   System.debug(recordCounter);                    
                   if(recordCounter == 3)
                   {
                       System.debug(MapOpptyIdWithOppty.get(recordCount).Academic_Start_Date__c);
                       System.debug(MapOpptyIdWithOppty.get(recordCount).Academic_End_Date__c);                       
                       newEvent.OwnerId = MapOpptyIdWithOppty.get(recordCount).OwnerID;
                       newEvent.Type__c = 'Face To Face Meeting';
                       newEvent.IsRecurrence  = false;
                       //newEvent.DurationInMinutes = DateTime.ValueOf((MapOpptyIdWithOppty.get(recordCount).Academic_End_Date__c)).minute();                      
                       newEvent.subject__c = 'Returning Student Interview';                        
                       newEvent.Subject = 'Enrollment Date - Returning Interview';  
                       newEvent.EndDateTime = MapOpptyIdWithOppty.get(recordCount).Academic_End_Date__c;
                       newEvent.StartDateTime = MapOpptyIdWithOppty.get(recordCount).Academic_Start_Date__c;
                       newEvent.Location = 'To Be Determined';
                       newEvent.WhatID = recordCount;
                       newEvent.IsAllDayEvent = true; 
                       newEvent.Status__c = 'To be Scheduled';                      
                       newEvent.ActivityDate = MapOpptyIdWithOppty.get(recordCount).Academic_Start_Date__c;                      
                       newEvent.ActivityDateTime =  MapOpptyIdWithOppty.get(recordCount).Academic_Start_Date__c;
                       newEvent.WhoId = MapContactIdWithOpptyId.get(recordCount);                      
                       listWithNewEvent.add(newEvent);                        
                       break;
                   }    
               }
             }
            }
          }
       }     
    }
   }    
       if(listWithNewEvent != null)
       {        
           Utility.stopRecursion = true;
           insert listWithNewEvent;
       }        
   }
  }catch(Exception e)
   {
       System.debug(e);
   }
   
 }
}