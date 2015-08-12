/*************************************************************
@Author     : Accenture IDC
@Description: trigger for OpportunityTeamMember
@Date       : 26/03/2015
**************************************************************/

trigger OpportunityTeamMemberTrigger on OpportunityTeamMember (after delete, after insert, after undelete, after update, before delete, before insert, before update) {
    
    oneCRMSetOpptyTeamMemberValues SetOpptyTeamMemberValues = new oneCRMSetOpptyTeamMemberValues();
    // Before Insert Logic
    //
    
    if(Trigger.isInsert && Trigger.isBefore)
    {
        SetOpptyTeamMemberValues.setJobFunAndManager(Trigger.New);    
    }
    
    // After Insert Logic
    //
    
    else if(Trigger.isInsert && Trigger.isAfter)
    {
        
    }
    
    // Before Update Logic
    //
    
    else if(Trigger.isUpdate && Trigger.isBefore)
    {
    
    }
    
    // After Update Logic
    //
    
    else if(Trigger.isUpdate && Trigger.isAfter)
    {
                
    }
    
    // Before Delete Logic
    //
    
    else if(Trigger.isDelete && Trigger.isBefore)
    {
    
    }
    
    // After Delete Logic
    //
    
    else if(Trigger.isDelete && Trigger.isAfter)
    {
    
    }
    
    // After Undelete Logic
    //
    
    else if(Trigger.isUnDelete)
    {
        
    }

}