trigger TestingPrimary  on Pearson_Course_Equivalent__c (after delete, after insert, after undelete, after update, before delete, before insert, before update)
{
    Bypass_Settings__c bypass = Bypass_Settings__c.getInstance();
    if (bypass.Disable_Triggers__c) return;

    
    TestingPrimary  handler = new TestingPrimary();
    
    // Before Insert Logic
    //
    if(Trigger.isInsert && Trigger.isBefore)
    {
        //Handler.OnBeforeInsert(Trigger.new);
    }
    // After Insert Logic
    //
    else if(Trigger.isInsert && Trigger.isAfter)
    {
        //Handler.OnAfterInsert(Trigger.new);
    }
    // Before Update Logic
    //
    else if(Trigger.isUpdate && Trigger.isBefore)
    {
        //Handler.OnBeforeUpdate(Trigger.old, Trigger.new, Trigger.newMap);
    }
    // After Update Logic
    //
    if(Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate))
    {        
      if(Trigger.isInsert){
           for(Pearson_Course_Equivalent__c ce: Trigger.new){
                if(ce.Primary__c){
                    handler.updatePrimary(trigger.new); 
                }               
            }        
      }
      else
      {
          for(Pearson_Course_Equivalent__c ce: Trigger.new){
              if(ce.Primary__c &&(ce.Primary__c != Trigger.oldmap.get(ce.id).Primary__c)){
                  handler.updatePrimary(trigger.new); 
                }                
            }
        }
        //TestingPrimary.updatePrimary(trigger.new);
        //Handler.OnAfterUpdate(Trigger.old, Trigger.new, Trigger.newMap);
    }
    // Before Delete Logic
    //
    else if(Trigger.isDelete && Trigger.isBefore)
    {
        //Handler.OnBeforeDelete(Trigger.old, Trigger.oldMap);
    }
    // After Delete Logic
    //
    else if(Trigger.isDelete && Trigger.isAfter)
    {
        //Handler.OnAfterDelete(Trigger.old, Trigger.oldMap);
    }
    // After Undelete Logic
    //
    else if(Trigger.isUnDelete)
    {
        //Handler.OnUndelete(Trigger.new);
    }
}