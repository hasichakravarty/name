/* ----------------------------------------------------------------------------------------------------------------------------------------------------------
   Name:            PS_OpportunityTrigger.trigger
   Description:     On insert/update/delete of Lead record 
   Date             Version         Author                             Summary of Changes 
   -----------      ----------      -----------------    ---------------------------------------------------------------------------------------------------
  04/2015         1.0            Accenture IDC                     Initial Release
  06/2015         1.1            Stacey Walter                     Adjustment to Bypass functions
------------------------------------------------------------------------------------------------------------------------------------------------------------ */

trigger PS_OpportunityTrigger on Opportunity (after insert, after update, before insert, before update) { 

    Bypass_Settings__c bypass = Bypass_Settings__c.getInstance();
    List<Opportunity> newOpportunitys = new List<Opportunity>();
    List<Opportunity> oldOpportunitys = new List<Opportunity>();
    
    Map<Id,Opportunity> oldMap = new Map<Id,Opportunity>();
    Map<Id,Opportunity> newMap = new Map<Id,Opportunity>();

    Id recId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Opportunity').getRecordTypeId();
    
    system.debug('################## bypass.Disable_Triggers__c :'+bypass.Disable_Triggers__c);
    //  Use Commonutils for getting the records which you want to get bypassed by ANZ record types 
    if (!bypass.Disable_Triggers__c)
    {     
        if(Trigger.isAfter)
        {
            
            if(trigger.IsInsert && checkRecurssionAfter.runOnce('PS_OpportunityTrigger','Insert')){
                newOpportunitys = OpptyUtils.getOpportunitybypassRecordType(System.Label.ANZ_Opportunity_Record_Type, Trigger.new);
                oldOpportunitys = OpptyUtils.getOpportunitybypassRecordType(System.Label.ANZ_Opportunity_Record_Type, Trigger.old);
                
                System.debug('new opportunity insert after --- >' +newOpportunitys); 
                system.debug('*************Trigger.IsInsert : '+Trigger.IsInsert +' Trigger.IsUpdate : '+Trigger.IsUpdate);
                if(!newOpportunitys.isEmpty())
                    PS_Opportunity_TriggerSequenceCtrlr.afterInsert(newOpportunitys);
            } 
            
            if(trigger.IsUpdate && checkRecurssionAfter.runOnce('PS_OpportunityTrigger','Update')){
                newOpportunitys = OpptyUtils.getOpportunitybypassRecordType(System.Label.ANZ_Opportunity_Record_Type, Trigger.new);
                oldOpportunitys = OpptyUtils.getOpportunitybypassRecordType(System.Label.ANZ_Opportunity_Record_Type, Trigger.old);
                
                
                System.debug('new opportunities --- >' +newOpportunitys); 
                system.debug('*************Trigger.IsInsert : '+Trigger.IsInsert +' Trigger.IsUpdate : '+Trigger.IsUpdate);
                if(!newOpportunitys.isEmpty())
                    PS_Opportunity_TriggerSequenceCtrlr.afterUpdate(newOpportunitys, trigger.oldMap);
            } 
        }
        
        
        if(Trigger.isBefore )
        {
            
            if(trigger.IsInsert && checkRecurssionBefore.runOnce('PS_OpportunityTrigger','Insert')){
                newOpportunitys = OpptyUtils.getOpportunitybypassRecordType(System.Label.ANZ_Opportunity_Record_Type, Trigger.new);
                if(!newOpportunitys.isEmpty())
                    PS_Opportunity_TriggerSequenceCtrlr.beforeInsert(newOpportunitys);
                
            }
            
            if(trigger.Isupdate && checkRecurssionBefore.runOnce('PS_OpportunityTrigger','Update'))
            {
                newOpportunitys = OpptyUtils.getOpportunitybypassRecordType(System.Label.ANZ_Opportunity_Record_Type, Trigger.new);
                
                if(!newOpportunitys.isEmpty()) 
                {
                    PS_Opportunity_TriggerSequenceCtrlr.beforeUpdate(newOpportunitys);
                }
            }      
        }  
    }
}