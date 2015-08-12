/* ----------------------------------------------------------------------------------------------------------------------------------------------------------
   Name:            PS_CaseTrigger.trigger
   Description:     On insert/update/delete of Case record 
   Date             Version         Author                             Summary of Changes 
   -----------      ----------      -----------------    ---------------------------------------------------------------------------------------------------
  27/03/2015         1.0            Manikandan                       Initial Release 
------------------------------------------------------------------------------------------------------------------------------------------------------------ */

trigger PS_CaseTrigger on Case(after insert, after update, before insert, before update, after delete, before delete) { 

   
        Bypass_Settings__c bypass = Bypass_Settings__c.getInstance();
        List<Case> newCases = new List<Case>();
        List<Case> oldCases = new List<Case>();
        Map<Id,Case> oldMap = new Map<Id,Case>();
         
        system.debug('################## bypass.Disable_Triggers__c :'+bypass.Disable_Triggers__c);
        //  Use Commonutils for getting the records which you want to get bypassed by ANZ record types 
        if (!bypass.Disable_Triggers__c){     
          if(Trigger.isAfter){
             
             if(trigger.IsUpdate && checkRecurssionAfter.runOnce('PS_CaseTrigger','Update')){
                  newCases = CommonUtils.getCaseBypassANZRecordType(System.Label.ANZ_Case_Record_Type, Trigger.new);
                  oldCases = CommonUtils.getCaseBypassANZRecordType(System.Label.ANZ_Case_Record_Type, Trigger.old);
                  for(Case oldCaseObj : oldCases){
                      
                      oldMap.put(oldCaseObj.id,oldCaseObj);
                  }
                  System.debug('new cases --- >' +newCases); 
                  system.debug('*************Trigger.IsInsert : '+Trigger.IsInsert +' Trigger.IsUpdate : '+Trigger.IsUpdate);
                 if(!newCases.isEmpty() && !oldMap.isEmpty())
                    PS_Case_TriggerSequenceCtrlr.afterUpdate(newCases,oldMap);
              } 
              
              if(trigger.IsInsert && checkRecurssionAfter.runOnce('PS_CaseTrigger','Insert')){
                 newCases = CommonUtils.getCaseBypassANZRecordType(System.Label.ANZ_Case_Record_Type, Trigger.new); 
                 oldCases = CommonUtils.getCaseBypassANZRecordType(System.Label.ANZ_Case_Record_Type, Trigger.old);
                 for(Case oldCaseObj : oldCases){
                      
                      oldMap.put(oldCaseObj.id,oldCaseObj);
                  }
                 System.debug('new cases insert after --- >' +newCases); 
                 system.debug('*************Trigger.IsInsert : '+Trigger.IsInsert +' Trigger.IsUpdate : '+Trigger.IsUpdate); 
                 if(!newCases.isEmpty() && !oldMap.isEmpty())
                    PS_Case_TriggerSequenceCtrlr.afterInsert(newCases,oldMap);
              
              }
              
          }
       
          
          if(Trigger.isBefore){
             
              if(trigger.Isupdate  && checkRecurssionBefore.runOnce('PS_CaseTrigger','Update')){
                   newCases = CommonUtils.getCaseBypassANZRecordType(System.Label.ANZ_Case_Record_Type, Trigger.new);
                   if(!newCases.isEmpty())
                        PS_Case_TriggerSequenceCtrlr.beforeInsertOrUpdate(newCases);
              }
              
              if(trigger.IsInsert  && checkRecurssionBefore.runOnce('PS_CaseTrigger','Insert')){
                  newCases = CommonUtils.getCaseBypassANZRecordType(System.Label.ANZ_Case_Record_Type, Trigger.new);
                  System.debug('new cases insert --- >' +newCases); 
                  if(!newCases.isEmpty())
                    PS_Case_TriggerSequenceCtrlr.beforeInsertOrUpdate(newCases);
              }
                     
                
            } 
         }
    //}    
}