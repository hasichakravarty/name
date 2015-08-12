Public without sharing Class UpdateTeamMember
{
    public static Map<Id,Boolean> needUpdateAccountShare = new Map<Id,Boolean>();
    
    public static void updateAccountOwner(list<account> triggeredAccountList){
        
        User u;
        Boolean isException = false;
        System.debug('#################updateAccountOwner.... ');     
        List<ID> accountIds = new List<ID>();
        List<Account> accountList = new List<Account>();
        Profile currentProfile;
        try{
             u = [SELECT id,name FROM User WHERE name =: System.Label.OwnerForAccount];
        }catch(Exception ex){
             isException = true;
        }
        
        system.debug('############## Current User : '+u);
        
        for(Account acc : triggeredAccountList){
           accountIds.add(acc.id);
            if(isException){
                acc.addError(System.Label.ErrorMsgForAccountReAssign);
            } 
        } 
        
        accountList = [SELECT RecordType.name,ownerId FROM Account 
                       WHERE id IN : accountIds];
        
        currentProfile = [SELECT name FROM Profile 
                   WHERE id =: UserInfo.getProfileId()];    
                       
        for(Account acc : accountList){
            if( UserInfo.getName() != System.Label.OwnerForAccount 
               &&  (acc.RecordType.name=='Organisation' || (acc.RecordType.name).equalsIgnorecase('Learner'))){
                    // system.debug('############ updated accountOwner ############');
                    acc.ownerId = u.id;
                }
        
        }
        system.debug('############BeforeUpdatingOwner <-> accountList : \n\n'+ accountList+'\n\n');
        Database.update(accountList);
        system.debug('############AfterUpdatingOwner <-> accountList : \n\n'+ accountList+'\n\n');
        
       /* AccountShare accShareOfChangedOwner = [SELECT Id,CaseAccessLevel,accountId,
                                                      AccountAccessLevel,OpportunityAccessLevel,
                                                      ContactAccessLevel,UserOrGroupId,RowCause  
                                               FROM AccountShare 
                                               WHERE accountId IN : accountList 
                                               AND UserOrGroupId =: u.id ];
        system.debug('####################accShareOfChangedOwner : \n\n'+accShareOfChangedOwner+'\n\n');*/
    }
    
    public static void addAccountTeamMember(list<Account> triggeredNewAccountList){
        
        System.debug('#################addAccountTeamMember.... ');

        System.debug('addAccountTeamMember (1) --> ' + triggeredNewAccountList); 

        List<id> AcountIdLst = new List<id>();
        String Recordtype; 
        User accountOwner = new User();
        List<ID> accountIds = new List<ID>();
        List<Account> accountList = new List<Account>(); 
        Map<ID,Account> account_ID_Map = new Map<ID,Account>();
        Map<ID,String> accountID_RecordType_Map = new Map<ID,String>(); 
        List<ObjectPermissions> objPerm = new List<ObjectPermissions>();
        Profile currentProfile;
                                                
        Map<ID, Schema.RecordTypeInfo> rtMap = Schema.SObjectType.Account.getRecordTypeInfosById();                                        
                                                
        for(Account newAcc : triggeredNewAccountList)
        {
           accountIds.add(newAcc.id);


        }

        System.debug('addAccountTeamMember (2) -->' + accountIds);
           
        accountList = [SELECT RecordTypeId,RecordType.name,ownerId FROM Account 
                       WHERE id IN : accountIds];
         
         for(Account acc : accountList) {
             accountID_RecordType_Map.put(acc.id , rtMap.get(acc.RecordTypeId).getName());
         }
         
         accountOwner = [Select ProfileId,id FROM User WHERE Id =: UserInfo.getUserId()];
         
         currentProfile = [SELECT Name FROM profile WHERE Id =: UserInfo.getProfileId()];
        
         system.debug('########accountOwner : '+accountOwner + '########currentProfile :'+currentProfile);
        
        //Object Permissions 
        objPerm = [SELECT Id, SObjectType, PermissionsRead, PermissionsCreate,PermissionsEdit
                   FROM ObjectPermissions 
                   WHERE parentid in (SELECT id 
                                      FROM permissionset 
                                      WHERE PermissionSet.Profile.Name =: currentProfile.Name )] ;
            
         System.debug('###### object Permissions ID : \n\n' +ObjPerm +'\n\n');
                                                
        List<AccountTeamMember> accountTeamMembers = new List<AccountTeamMember>();

        System.debug('-->AccountList Size is ' + accountList.size());

                                                
        for(Account acc : accountList){
            if(currentProfile.Name != 'Pearson Local Administrator OneCRM'
              &&   currentProfile.Name != 'System Administrator'){
                   System.debug( '######RecordType : '+accountID_RecordType_Map.get(acc.id));
                   System.debug('###Recordtype-->' +accountID_RecordType_Map.get(acc.id) ); 
                   if(accountID_RecordType_Map.get(acc.id) == 'Learner' || 
                      accountID_RecordType_Map.get(acc.id) == 'Organisation' ){
                       System.debug('###Recordtype-->' +accountID_RecordType_Map.get(acc.id) ); 
                        AccountTeamMember accTeamMember = new AccountTeamMember();
                         accTeamMember.AccountId = acc.Id;
                         accTeamMember.TeamMemberRole = 'Team Member';
                         accTeamMember.userid = accountOwner.id;
                         accountTeamMembers.add(accTeamMember);
                         system.debug('################accTeamMember :\n\n'+accTeamMember+'\n\n'); 
                         needUpdateAccountShare.put(acc.id,true) ;
                    }
              }
         }       
         
         if(accountTeamMembers != null)
            insert(accountTeamMembers);
         System.debug('####################### accountTeamMembers : \n\n'+accountTeamMembers+'\n\n'); 
    }
    
    Public Static Void UpdateAccountShare(List<Account> triggeredAccountList , Map<Id,Account> newAccount_Id_Map){
        
        system.debug('################### UpdateAccountShare....');
        List<AccountShare> newShare = new List<AccountShare>();
        List<Accountshare> updatedAccountShares = new List<Accountshare>();
        
        List<AccountShare> shares = [SELECT Id,CaseAccessLevel,accountId,AccountAccessLevel,OpportunityAccessLevel,ContactAccessLevel,UserOrGroupId,RowCause  
                                      FROM AccountShare 
                                      WHERE accountId IN : newAccount_Id_Map.keySet()
                                      AND UserOrGroupId =: UserInfo.getUserId()];
         
         System.debug('#############Accountshares -\n\n'+shares+'\n\n' );
         List<ObjectPermissions> AccEditPermission=[SELECT Id, SObjectType, PermissionsEdit, 
                                                          Parent.label, Parent.IsOwnedByProfile 
                                                   FROM ObjectPermissions 
                                                   WHERE (ParentId IN (SELECT PermissionSetId 
                                                                       FROM PermissionSetAssignment 
                                                                       WHERE Assignee.Id =: UserInfo.getUserId() )) 
                                                                       AND (PermissionsEdit = true) 
                                                                       AND (SobjectType = 'Account')];
         for (AccountShare sha : shares) { 
             if(AccEditPermission.size()>0 && !needUpdateAccountShare.isEmpty() && needUpdateAccountShare.get(sha.AccountId)){
                  
                   system.debug('***************accountshareBeforeUpdate --->\n\n'+sha+'\n\n');
                 
                   AccountShare tempAccShare = new AccountShare();  
                   tempAccShare.Id = sha.id; 
                   
                   if(sha.OpportunityAccessLevel =='read' || sha.CaseAccessLevel == 'None'){
                       System.debug('### sha.OpportunityAccessLevel -->' +sha.OpportunityAccessLevel);
                       sha.OpportunityAccessLevel = 'Edit';
                       tempAccShare.OpportunityAccessLevel = 'Edit';
                   }
                   if(sha.CaseAccessLevel =='read' || sha.CaseAccessLevel == 'None'){
                       System.debug('### sha.CaseAccessLevel -->' +sha.CaseAccessLevel);
                       sha.CaseAccessLevel = 'Edit';
                       tempAccShare.CaseAccessLevel = 'Edit';
                   }
                   if(sha.ContactAccessLevel =='read' || sha.ContactAccessLevel == 'None'){
                       System.debug('### sha.ContactAccessLevel -->' +sha.ContactAccessLevel);
                       sha.ContactAccessLevel = 'Edit';
                       tempAccShare.ContactAccessLevel = 'Edit';
                   }
                     if(sha.AccountAccessLevel =='read' || sha.AccountAccessLevel == 'None'){
                       System.debug('### sha.AccountAccessLevel-->' +sha.AccountAccessLevel);
                       sha.AccountAccessLevel = 'Edit';
                       tempAccShare.AccountAccessLevel = 'Edit';
                    }
                   
                   updatedAccountShares.add(tempAccShare);
                   system.debug('***************accountshareAfterUpdate --->\n\n'+tempAccShare+'\n\n'); 
             }
         }
         
         if(updatedAccountShares.size()>0){
          // update shares;
             update updatedAccountShares;
         }
         
         system.debug('#########  updatedAccountShares : \n\n'+ updatedAccountShares+'\n\n');
       
     }
    
    
 /*  public static Boolean canAddTeamMember(Id accountId, Id creatorId){
        
        Boolean accessLevel = False;
        
        //Get the running user:
        System.debug('creatorId'+creatorId);      
        
        //Check for the object permission and permission set for the login user 
        List<AccountShare> accAccessLevel = new List<AccountShare>();
        List<ObjectPermissions> AccEditPermission=[SELECT Id, SObjectType, PermissionsEdit, 
                                                          Parent.label, Parent.IsOwnedByProfile 
                                                   FROM ObjectPermissions 
                                                   WHERE (ParentId IN (SELECT PermissionSetId 
                                                                       FROM PermissionSetAssignment 
                                                                       WHERE Assignee.Id =: creatorId )) 
                                                                       AND (PermissionsEdit = true) 
                                                                       AND (SobjectType = 'Account')];
        
        accAccessLevel = [SELECT AccountAccessLevel 
                          FROM AccountShare 
                          WHERE (UserOrGroupId =: creatorId 
                          AND AccountId =: accountId)];
        
        /*ID perid = [select id from PermissionSet where label='Pearson Manage Account Team'];
        list<PermissionSetAssignment>  perser =[ SELECT Assignee.Id 
                                                 FROM PermissionSetAssignment 
                                                 WHERE PermissionSetId =:perid 
                                                 AND Assignee.Id = :creatorId];
        
        for(AccountShare accShare: accAccessLevel){
            System.debug('######accAccessLevel \n\n'+accShare+'\n\n');
           // if((AccEditPermission.size()>0) || (perser.size()>0)){
            if(AccEditPermission.size()>0){
                accessLevel = True;
                break;
            }
        }     
            
        // returns true if the user has necessary permission or the necessary permission set
        system.debug('########################AccessLevel'+accessLevel);
                return accessLevel;
    }  */
 }