trigger PS_PrimaryPearsonCourse  on Pearson_Course_Equivalent__c (after insert, after update, before insert, before update)
{
    Bypass_Settings__c bypass = Bypass_Settings__c.getInstance();
    if (bypass.Disable_Triggers__c) return;
    
    PS_PrimaryPearsonCourse  handler = new PS_PrimaryPearsonCourse();
    
    if (Trigger.isBefore){
        if((Trigger.isInsert && checkRecurssionBefore.runOnce('TestingPrimary','Insert'))|| 
        (Trigger.isUpdate && checkRecurssionBefore.runOnce('TestingPrimary','Update'))){
            handler.updatePrimaryFlag(trigger.new,trigger.oldmap,Trigger.isInsert,Trigger.isUpdate); 
        }
    }
   
}