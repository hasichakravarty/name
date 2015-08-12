public with sharing class MultipleAccountApprovalController 
{
    private ApexPages.StandardSetController standardController;

    public MultipleAccountApprovalController(ApexPages.StandardSetController standardController)
    {
        this.standardController = standardController;
    }

    public PageReference MultipleAccounts()
    {       
        List<Account> selectedAccounts = (List<Account>) standardController.getSelected();
         AccountTeamMember[] newmembers = new AccountTeamMember[]{};
         system.debug('selectedAccounts...'+selectedAccounts); 
           
        for(Account selectedAccount : selectedAccounts)
        {
         Approval.processsubmitrequest req1 = new Approval.processsubmitrequest();
         req1.setobjectId(selectedAccount.Id);
         Approval.processresult result = Approval.Process(req1);  
         if(result.getInstanceStatus() == 'Approved' && result.IsSuccess()){
          AccountTeamMember Teammemberad=new AccountTeamMember(); 
          Id SubmitterId = req1.getSubmitterId();
          Teammemberad.AccountId=selectedAccount.Id;
          Teammemberad.UserId=SubmitterId;
          Teammemberad.TeamMemberRole= 'Team Member';
          newmembers.add(Teammemberad); 
          system.debug('subid..'+SubmitterId);
         }
        }       
        Insert newmembers;
        return null;        
    }

  
}