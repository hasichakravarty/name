/**
  * VF Page    : Account Team Management
  * Controller : VFC_AddNewTeamMember
  * Description: Controller class to Add, Modify Permissions and Remove Account Team Members 
  **/  

/*==================================================================================================================+
 |  HISTORY  |                                                                           
 |  DATE          DEVELOPER         WR        DESCRIPTION                               
 |  ====          =========          ==        =========== 
 |  07/06/2015    Leonard Victor               Updated canAddTeamMember() method , removed AccountShare SOQL and added 
                                               SOQL for UserRcordAccess.                               
 +==================================================================================================================**/
public without sharing class VFC_AddNewTeamMember {

    //Declaration of Common Variables
    public Id acctid;
    private AccountTeamMember accTeamMember;
    public List<AccountTeamMemberSelected> AccountTeamMemberList {get; set;}     
    public integer accountteammembersadded {get;set;}
    public integer accountteammembersremoved{get;set;}
    public string selectedteammember{get;set;}
    public string accountaccess{get;set;}    
    public string contactaccess{get;set;}
    public string opportunityaccess{get;set;} 
    public string caseaccess{get;set;}
    
  //Constructor    
    public VFC_AddNewTeamMember(ApexPages.Standardcontroller controller) {
        this.accTeamMember = (AccountTeamMember)controller.getRecord();      
        acctid = ApexPages.currentPage().getParameters().get('AccountID');
        accountteammembersadded=0;
        accountteammembersremoved=0;
    }
    
    //Used to insert Account Team Members
    public void addTeamMemberAndAccountShare(){
        try{ 
         system.debug('&&&&&&&'+accTeamMember.UserId+accTeamMember.TeamMemberRole);          
         //Adding AccountTeamMember
       
        if(accTeamMember.UserId == null || accTeamMember.TeamMemberRole== null )//to ensure that both user and role is selected
        {
           ApexPages.Message msg = new ApexPages.message(ApexPages.severity.info,'Please select both User and Team Role');
           ApexPages.addMessage(msg);
        }
        else{
        //inserting Account Team
        AccountTeamMember addTeamMember= new AccountTeamMember();
        addTeamMember.AccountId = acctid;
        addTeamMember.UserId = accTeamMember.UserId;
        addTeamMember.TeamMemberRole = accTeamMember.TeamMemberRole;
        insert addTeamMember;
        system.debug('$$$$$$$$$'+addTeamMember);
        accountteammembersadded++;
        
        //Retrieving and updating Access Level Permissions
        system.debug('$$$$$$$'+acctid+addTeamMember.UserId);
        AccountShare addAccountShare = [select Accountid,AccountAccessLevel,OpportunityAccessLevel,CaseAccessLevel,ContactAccessLevel from AccountShare where Accountid =: acctid and UserOrGroupId =: addTeamMember.UserId];
        system.debug('Access Levels'+addAccountShare);
        addAccountShare.AccountAccessLevel = 'Edit';
        addAccountShare.OpportunityAccessLevel = 'Edit';
        addAccountShare.CaseAccessLevel = 'Edit';
        addAccountShare.ContactAccessLevel = 'Edit';               
        system.debug('$$$$$Access Levels'+addAccountShare);
        update addAccountShare;
        system.debug('$$$$$Added'+accountteammembersadded);
        String username=[select name from user where id=:accTeamMember.UserId].name;
        String summary = username + ' has been added to the team';
        ApexPages.Message msg = new ApexPages.message(ApexPages.severity.info,summary);
        ApexPages.addMessage(msg);


        AccountTeamMemberSelected atm = new AccountTeamMemberSelected(addTeamMember,addAccountShare);
        atm.userid = accTeamMember.UserId;
        atm.username =username;

        AccountTeamMemberList.add(atm);
        system.debug('@@@@@@@@@2'+AccountTeamMemberList);
        
       } }catch(Exception e){
              ApexPages.Message msg = new Apexpages.Message(ApexPages.Severity.Warning,'Sorry! The selected User does not have the necessary permissions to be added as Account Team Member.Please select another user or please contact your Administrator');
              ApexPages.addMessage(msg);
              system.debug('$$$$$$$$$$$$$Error'+e);}      
         

    }
        
   //query the account team members related to account
   public List<AccountTeamMemberSelected> getAccountTeamMembers() {
      
      if(AccountTeamMemberList == null ) {
          system.debug('$$$$$$Entered Function');
          AccountTeamMemberList = new List<AccountTeamMemberSelected>();

          Map<Id, AccountShare> accountshares= new Map<Id, AccountShare>();

          for(AccountShare s : [select UserOrGroupId,Accountid,AccountAccessLevel,OpportunityAccessLevel,CaseAccessLevel,ContactAccessLevel from AccountShare where accountid =: acctid] )
          {
            accountshares.put(s.UserOrGroupId  ,s);
          }   
          
          for(AccountTeamMember temp: [select Id, User.Id, User.Name , TeamMemberRole,Accountid from AccountTeamMember where accountid=:acctid]) {
                      AccountTeamMemberList.add(new AccountTeamMemberSelected(temp,accountshares.get(temp.User.Id)));
          }
      } 
       
      system.debug('@@@@@@@@@2'+AccountTeamMemberList);
      return AccountTeamMemberList;
  }    
        
  //delete the selected AccountTeamMembers
  public PageReference DeleteSelected() {
        
        Boolean permissionCheck = False;
        permissionCheck = canAddTeamMember();
        system.debug('^^^^Check'+permissionCheck) ;
               
        if(permissionCheck)
        {
        system.debug('$$$$$$Entered Function1');
        List<AccountTeamMember> selectedAccountTeamMembers = new List<AccountTeamMember>();
              for(AccountTeamMemberSelected temp: getAccountTeamMembers()) {
                   system.debug('$$$$$Selectedvalue'+temp.selected);
                   if(temp.selected == true) {
                        system.debug('$$$$$Selected'+temp);
                        selectedAccountTeamMembers.add(temp.atm);
                         String summary = temp.username + ' has been removed from the team';
                         ApexPages.Message msg = new ApexPages.message(ApexPages.severity.info,summary);
                         ApexPages.addMessage(msg);}

                       }
                   
               
            System.debug('These are the selected AccountTeamMembers...'+selectedAccountTeamMembers);
            accountteammembersremoved=accountteammembersremoved+selectedAccountTeamMembers.size();
             if(selectedAccountTeamMembers == null)  
             {
               ApexPages.Message msg = new ApexPages.message(ApexPages.severity.info,'No Member selected for Deletion');
               ApexPages.addMessage(msg);
             }
              else
             { delete selectedAccountTeamMembers;}         
          
                 AccountTeamMemberList=null;
         
             return null;
         } 
     else{
            //User does not have permission to remove account team members.
            System.debug('ApexPages.Message');          
            ApexPages.Message msg = new Apexpages.Message(ApexPages.Severity.Warning,'Sorry! You do not have the necessary permissions to remove Account Team Members. For further assistance, Please contact your Administrator');
            ApexPages.addMessage(msg);
            System.debug('inside else');       
            return null;        
        }
          
    } 

       
    //used to direct the flow of insertion based on user permission
    public PageReference save() {        
        Boolean permissionCheck = False;
        permissionCheck = canAddTeamMember();
        system.debug('^^^^Check'+permissionCheck) ;
               
        if(permissionCheck)
        {
            addTeamMemberAndAccountShare();
            System.debug('inside if');          
        }
        else{
            //User does not have permission to add an account team member.
            System.debug('ApexPages.Message');          
            ApexPages.Message msg = new Apexpages.Message(ApexPages.Severity.Warning,'Sorry! You do not have the necessary permissions to add an Account Team Member. For further assistance, Please contact your Administrator');
            ApexPages.addMessage(msg);
            System.debug('inside else');       
            return null;        
        }
        
        return null;        
    }

   //user to check if the user has permission to add Account Team Member
   private Boolean canAddTeamMember()
    {
        Boolean accessLevel = False;
        
        //Get the running user:
        Id creatorId = UserInfo.getUserId();
        System.debug('creatorId'+creatorId);      
        
        //Check for the object permission and permission set for the login user 
          //Commented for fixing account team member addition issue
        //List<AccountShare> accAccessLevel = new List<AccountShare>();
        List<ContactShare> ContactAccessLevel = new List<ContactShare>();
        List<OpportunityShare> OpportunityAccessLevel = new List<OpportunityShare>();
        List<caseShare> caseAccessLevel = new List<caseShare>();
        List<ObjectPermissions> AccEditPermission=[SELECT Id, SObjectType, PermissionsEdit, Parent.label, Parent.IsOwnedByProfile FROM ObjectPermissions WHERE (ParentId IN (SELECT PermissionSetId FROM PermissionSetAssignment WHERE Assignee.Id =: creatorId )) AND (PermissionsEdit = true) AND (SobjectType = 'Account')];
       //Commented for fixing account team member addition issue
       // accAccessLevel = [SELECT AccountAccessLevel FROM AccountShare WHERE (AccountId =: acctid and UserOrGroupId =:creatorId )];
        List<UserRecordAccess> userRecordLst = [Select HasEditAccess,recordid from UserRecordAccess where RecordId =:acctid and UserId = :creatorId];
        ID perid = [select id from PermissionSet where label='Pearson Manage Account Team'].id;
        list<PermissionSetAssignment>  perser =[ select Assignee.Id from PermissionSetAssignment where PermissionSetId =:perid and Assignee.Id = :creatorId];
         //Removed Account share list and added UseRecordAccess
           // if(((AccEditPermission.size()>0) || (perser.size()>0))&&(accAccessLevel.size()>0)){
        if(((AccEditPermission.size()>0) || (perser.size()>0))&&(userRecordLst.size()>0 && userRecordLst[0].HasEditAccess)){
            accessLevel = True;
         }
        // returns true if the user has necessary permission or the necessary permission set
                return accessLevel;
    }  
    
   //user to initiate the insertion process
   public PageReference doSaveTeamMember(){
        save();
        return null;
    }
    
  //used to insert the account TeamMember,display summary of insertion and exit 
  public void SaveAndExitmessage()
    {
     save();
     String summary = accountteammembersadded + ' member(s) have been added to the team';
     ApexPages.Message msg = new ApexPages.message(ApexPages.severity.info,summary);
     ApexPages.addMessage(msg);
    }
    
   //used to delete the account TeamMember,display summary of deletion and exit  
   public void DeleteAndExitmessage()
    {
     DeleteSelected() ;
     String summary = accountteammembersremoved + ' member(s) have been removed from the team';
     ApexPages.Message msg = new ApexPages.message(ApexPages.severity.info,summary);
     ApexPages.addMessage(msg);
    }
    
  //used to populate the team members in a picklist 
  public List<SelectOption> getItems() {
        
        List<SelectOption> options = new List<SelectOption>();

        if(AccountTeamMemberList == null){

          getAccountTeamMembers();

        }

        for(AccountTeamMemberSelected temp: AccountTeamMemberList)    
        {
          options.add(new selectoption(temp.userid,temp.username));
        }
        
        return options;
  }
         
  //used to populate Permissions in a picklist 
  public List<SelectOption> getpermissions() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new selectoption('Read', 'Read'));
        options.add(new selectoption('Edit', 'Read/Write'));
        return options;
            }

 //used for the updation of object permissions 
  public void updatepermission()
  {
                   
      Boolean permissionCheck = False;
      
      permissionCheck = canAddTeamMember();
      
      system.debug('^^^^Check'+permissionCheck) ;
               
      if(permissionCheck)
      {
          system.debug('&&&&&&&&&&&permissions'+selectedteammember+accountaccess+contactaccess+opportunityaccess+caseaccess);
              
          AccountShare addAccountShare = [select Accountid,AccountAccessLevel,OpportunityAccessLevel,CaseAccessLevel,ContactAccessLevel from AccountShare where accountid =: acctid and UserOrGroupId =:selectedteammember];
              
         
            if(addAccountShare.AccountAccessLevel !=accountaccess  )
            {
                 addAccountShare.AccountAccessLevel = string.valueof(accountaccess);
            }

            if(addAccountShare.ContactAccessLevel !=contactaccess  )
            {
                 addAccountShare.ContactAccessLevel = string.valueof(contactaccess);
            }
            if(addAccountShare.OpportunityAccessLevel != opportunityaccess )                                            
            {
                 addAccountShare.OpportunityAccessLevel = string.valueof(opportunityaccess);
            }
            if(addAccountShare.CaseAccessLevel != caseaccess )                                             
            {
                 addAccountShare.CaseAccessLevel = string.valueof(caseaccess);
            }
            
            update addAccountShare;
                            
             for(AccountTeamMemberSelected tempactm: getAccountTeamMembers()) {
                   if(tempactm.userid == selectedteammember) 
                    {
                       tempactm.accpermission=addAccountShare;
                    } 
              }                                                                   
                        
            system.debug('#########Newpermissions'+addAccountShare);
                
            
            ApexPages.Message msg = new Apexpages.Message(ApexPages.Severity.info,'The permissions have been updated');
            ApexPages.addMessage(msg);    
             
        }
        else{
            //User does not have permission modify permissions.
            System.debug('ApexPages.Message');          
            ApexPages.Message msg = new Apexpages.Message(ApexPages.Severity.Warning,'Sorry! Your Profile dont have permission to modify record permissionns. For further assistance, Please contact your Administrator');
            ApexPages.addMessage(msg);
            System.debug('inside else');       
               
        }
              
  }                         
                    
   //wrapper class used.It contains account teammember,boolean for selection,string for username and accountshare to store permission levels 
   public class AccountTeamMemberSelected {

     public AccountTeamMember atm {get; set;}
     public Boolean selected {get;set;}
     public string username{get; set;} 
     public Id userid {get; set;}
     public AccountShare accpermission{get;set;}   
     //This is the contructor method. 
     public AccountTeamMemberSelected(AccountTeamMember c) {
     atm=c;
     selected = false;     
     username=[select name from user where id=:c.userid].name;
     //accpermission=accper;     
     }

     public AccountTeamMemberSelected(AccountTeamMember c, AccountShare s ) {
         atm=c;
         selected = false;     
         username= c.User.Name;
         userId =c.User.Id;
         accpermission = s;
      }
  }
  
}