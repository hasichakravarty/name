/* ----------------------------------------------------------------------------------------------------------------------------------------------------------
   Name:            PS_LeadTrigger.trigger
   Description:     On insert/update/delete of Lead record 
   Date             Version         Author                             Summary of Changes 
   -----------      ----------      -----------------    ---------------------------------------------------------------------------------------------------
  03/2015         1.0            Kalidass                       Initial Release 
------------------------------------------------------------------------------------------------------------------------------------------------------------ */

trigger PS_LeadTrigger on Lead(after insert, after update, before insert, before update) { 
    //To bypass the trigger.
    Bypass_Settings__c bypass = Bypass_Settings__c.getInstance();
    
    //String LeadRecType;
    String leadRecType = Null;
    Map<ID,RecordType> rt_Map = New Map<ID,RecordType>([Select ID, Name From RecordType Where sObjectType = 'Lead']);
    for(Lead lead : trigger.new){
        leadRecType = rt_map.get(lead.recordTypeID).name;
    } // End for
        
    if(!bypass.Disable_Triggers__c && leadRecType != System.Label.ANZ_Record_Type){
        if(Trigger.isBefore){
            if(trigger.Isupdate){
                 Lead_TriggerSequenceCtrlr.beforeUpdate();       
            }
            
            if(trigger.IsInsert){
                //beforeInsert();
                Lead_TriggerSequenceCtrlr.beforeInsert();                          
            }    
        } // End before check
        
        if(Trigger.isAfter){
            if(trigger.IsUpdate){
                //afterUpdate();
                Lead_TriggerSequenceCtrlr.afterUpdate();
            } 
            
            if(trigger.IsInsert){
                //afterInsert(); 
                Lead_TriggerSequenceCtrlr.afterInsert();
            }
        } // End after insert check
    }
}