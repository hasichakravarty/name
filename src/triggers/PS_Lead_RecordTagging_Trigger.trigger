trigger PS_Lead_RecordTagging_Trigger  on Lead (after insert, after update, before insert, before update)
{
    //LeadTriggerHandler  handler = new LeadTriggerHandler();
    
    // Before Insert Logic
    //
    if(Trigger.isInsert && Trigger.isBefore)
    {
      //Handler.OnBeforeInsert(Trigger.new);
     PS_Lead_RecordTagging_Ctrlr ldup = new PS_Lead_RecordTagging_Ctrlr();
     ldup.leadRecordTagging(Trigger.new);
    }
    // After Insert Logic
    //
    else if(Trigger.isInsert && Trigger.isAfter)
    {
        //Handler.OnAfterInsert(Trigger.new);
    }
          
}