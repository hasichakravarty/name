/*************************************************************
@Author     : Accenture IDC
@Description: Controller to set 'Job Function' and 'Team Member Manager' field in OpportunityTeamMember
@Date       : 26/03/2015
**************************************************************/
public class oneCRMSetOpptyTeamMemberValues 
{

/*************************************************************
@Param      : List of OpportunityTeamMember   
@Description: Method to pull 'Job Function' and 'Team Member Manager' field from user object and set it in OpportunityTeamMember
@Return Type: Void
**************************************************************/

 public void setJobFunAndManager(List<OpportunityTeamMember> listOpportunityTeamMember)
 {
     Map<ID,OpportunityTeamMember>  mapWithOpportunityTeamMember = new  Map<ID,OpportunityTeamMember>();  
     Map<Id,User> mapWithUserValues = new Map<Id,User>();
     if(!listOpportunityTeamMember.isEmpty())
     {
         for(OpportunityTeamMember teamMember : listOpportunityTeamMember)
         {         
             mapWithOpportunityTeamMember.put(teamMember.UserId,teamMember); 
         }       
     }     
     if(mapWithOpportunityTeamMember.size()>0 && !mapWithOpportunityTeamMember.isEmpty())
     {     
         for(User userList : [select Id,Job_Function__c,ManagerId from User where Id IN : mapWithOpportunityTeamMember.keyset()])
         {
             mapWithUserValues.put(userList.Id,userList);
         }    
     }
     if(!mapWithUserValues.isEmpty())
     {
         for(ID userVal : mapWithUserValues.keyset())
         {
             //mapWithOpportunityTeamMember.get(userVal).Job_Function__c = mapWithUserValues.get(userVal).Job_Function__c;       
             mapWithOpportunityTeamMember.get(userVal).Team_Member_s_Manager__c = mapWithUserValues.get(userVal).ManagerId;
         }  
     }    
 } 

}