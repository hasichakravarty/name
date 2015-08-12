trigger Account on Account (after delete, after insert, after undelete, after update, before delete, before insert, before update)
{
    if(checkRecurssion.runOnce()){
        
        AccountTriggerHandler Handler = new AccountTriggerHandler(Trigger.isExecuting, Trigger.size);
        
        Profile ProfileName = [select Name from profile where id = :userinfo.getProfileId()];
        
       Id D2Lid  = [SELECT Id FROM RecordType WHERE SobjectType='Account' and Name= 'Learner'].Id;
       Id  OrganisationId = [SELECT Id FROM RecordType WHERE SobjectType='Account' and Name= 'Organisation'].Id;
        
        // Before Insert Logic
        //
        if(Trigger.isInsert && Trigger.isBefore)
        {
            Handler.OnBeforeInsert(Trigger.new);
        }
        // After Insert Logic
        //
        else if(Trigger.isInsert && Trigger.isAfter)
        {
          Handler.OnAfterInsert(Trigger.new);
           if(ProfileName.Name!='System Administrator' && ProfileName.Name!='Pearson Data Administrator'){
              AccountTeamMember[] newmembers = new AccountTeamMember[]{};
              for(Account a:Trigger.new){
               if(a.RecordtypeId == D2Lid || a.RecordtypeId==OrganisationId){
                AccountTeamMember Teammemberad=new AccountTeamMember(); 
                Teammemberad.AccountId=a.id;
                Teammemberad.UserId=a.OwnerId;
                Teammemberad.TeamMemberRole= 'Account Manager';
                newmembers.add(Teammemberad); }
              }
              if(newmembers.size()>0){
                 Insert newmembers;}
           }
        }
        // Before Update Logic
        //
        else if(Trigger.isUpdate && Trigger.isBefore)
        {
            Handler.OnBeforeUpdate(Trigger.old, Trigger.new, Trigger.newMap);
        }
        // After Update Logic
        //
        else if(Trigger.isUpdate && Trigger.isAfter)
        {
            Handler.OnAfterUpdate(Trigger.old, Trigger.new, Trigger.newMap);
        }
        // Before Delete Logic
        //
        else if(Trigger.isDelete && Trigger.isBefore)
        {
            Handler.OnBeforeDelete(Trigger.old, Trigger.oldMap);
        }
        // After Delete Logic
        //
        else if(Trigger.isDelete && Trigger.isAfter)
        {
            Handler.OnAfterDelete(Trigger.old, Trigger.oldMap);
        }
        
        // After Undelete Logic
        //
        else if(Trigger.isUnDelete)
        {
            Handler.OnUndelete(Trigger.new);
        }
    }
}