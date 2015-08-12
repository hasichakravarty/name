public class AddAccountTeamMember {
    
	public static void intialize(Profile ProfileName,Id D2Lid,Id OrganisationId)
	{
		ProfileName = [select Name from profile where id = :userinfo.getProfileId()];
        D2Lid  = [SELECT Id FROM RecordType WHERE SobjectType='Account' and Name= 'Learner'].Id;
        OrganisationId = [SELECT Id FROM RecordType WHERE SobjectType='Account' and Name= 'Organisation'].Id;
	}
	
    public static void onInsert(List<Account> newAccounts){
        Profile ProfileName = new Profile();
        Id D2Lid,OrganisationId;
        intialize(ProfileName,D2Lid,OrganisationId);
        if(ProfileName.Name!='System Administrator' && ProfileName.Name!='Pearson Data Administrator'){
              AccountTeamMember[] newmembers = new AccountTeamMember[]{};
              for(Account a:newAccounts){
                   if(a.RecordtypeId == D2Lid || a.RecordtypeId==OrganisationId){
                        AccountTeamMember Teammemberad=new AccountTeamMember(); 
                        Teammemberad.AccountId=a.id;
                        Teammemberad.UserId=a.OwnerId;
                        Teammemberad.TeamMemberRole= 'Account Manager';
                        newmembers.add(Teammemberad); 
                   }
              }
              if(newmembers.size()>0){
                 Insert newmembers;
              }
          }
        }

}