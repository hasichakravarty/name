/* ----------------------------------------------------------------------------------------------------------------------------------------------------------
   Name:            PS_opportunity_UpdateAccountTeamAdmin.cls 
   Description:     TO Update Account Team Adminstator Based On Opportunity Values
   Date             Version         Author                             Summary of Changes 
   -----------      ----------      -----------------    ---------------------------------------------------------------------------------------------------
     04/2015         1.0           Karthik.A.S                       Initial Release 
  03/04/2015         1.1           Davi Borges          Change in the process of selecting the campus account
------------------------------------------------------------------------------------------------------------------------------------------------------------ */

public without sharing class PS_opportunity_UpdateAccountTeamAdmin
{
  public static void updateadmin(List<Opportunity>oppty) 
  { 
    
    List<Opportunity> toProcessOpportunties =  new List<Opportunity>();

    for(Opportunity o:oppty)  
    {
      System.debug('@@@@@ at 3 '+ o.Type + ' ' + ' ' + o.StageName);
      
      if((o.Type=='New Business') &&(o.StageName == 'Closed' || o.StageName == 'Negotiation')){
        
        toProcessOpportunties.add(o);
        
      }
    }

    if(toProcessOpportunties.size() == 0){

      system.debug('updateadmin: No opportunties to be processed!');
      return;
    }

    Map<Id, Opportunity> opportunities = new Map<Id, Opportunity> (toProcessOpportunties);

    system.debug('@@@@@ at 1 id'+ opportunities);
         
    // maps opportunities id to account ids
    Map<Id,Id> opportunityIdToAccountId = new Map<Id, Id>();
    
    // for each opportunity add the account id to the map
    for(Opportunity o:opportunities.values())  
    {      
        opportunityIdToAccountId.put(o.Id,  o.AccountId );
    }

    system.debug('@@@@@ at 4id'+opportunityIdToAccountId);
        
    // account id to list of current team members
    List<AccountTeamMember> currentAccountTeamMembers  = [SELECT a.Id, a.UserId,a.User.Name,a.TeamMemberRole, a.AccountId
                                                FROM AccountTeamMember a
                                                WHERE  a.TeamMemberRole IN ('Account Administrator') AND 
                                                a.AccountId in :opportunityIdToAccountId.values()];
    

    // fetching child  account team members
    // maps preferred campus to opportunity id
    Map<Id , List<Id>> CampusAccountToListOpportunityId = new Map<Id ,List<Id>>();
    
    for(Opportunity o:opportunities.values()){  
     
           if( ! CampusAccountToListOpportunityId.containsKey(o.Qualification_Campus__c))
           {
             CampusAccountToListOpportunityId.put(o.Qualification_Campus__c, new List<Id>());
           }

           CampusAccountToListOpportunityId.get(o.Qualification_Campus__c).add(o.id);        
    }
    
    AccountTeamMember newAccountTeamMember;
    // the account team members to insert
    List<AccountTeamMember> listWithAccountTeamMember = new List<AccountTeamMember >();
    AccountShare[] newShare = new AccountShare[]{};    
    
    for(AccountTeamMember accountTeamMember1 : [SELECT a.UserId, a.User.Name, a.TeamMemberRole, a.Id, a.AccountId
                                                FROM AccountTeamMember a
                                                WHERE  a.TeamMemberRole IN ('Account Administrator') AND a.AccountId in :CampusAccountToListOpportunityId.keySet()])  
    { 
      
      List<Id> idOpp = CampusAccountToListOpportunityId.get(accountTeamMember1.AccountId);
      
      // Updating  parent account team members with child account team member
      for(Id oppId : idOpp)
      {
        newAccountTeamMember = new AccountTeamMember();
        newAccountTeamMember.AccountID = opportunities.get(oppId).AccountId;
        newAccountTeamMember.TeamMemberRole = accountTeamMember1.TeamMemberRole;
        newAccountTeamMember.UserId = accountTeamMember1.UserId;

        listWithAccountTeamMember.add(newAccountTeamMember);
        
            newShare.add(new AccountShare(UserOrGroupId=accountTeamMember1.UserId,
                                          AccountId=opportunities.get(oppId).AccountId, 
                                          AccountAccessLevel='Edit',
                                          OpportunityAccessLevel='Edit')); 
        }       
    }
    
    if(currentAccountTeamMembers.size() >0){
      delete currentAccountTeamMembers;
    }
    
    
    if(listWithAccountTeamMember.size() >0){
      
      insert listWithAccountTeamMember;
      insert(newShare); 
      system.debug('updateadmin: New team members added!');

      return;
    }

     system.debug('updateadmin: No new team members added!');
  }
   
}