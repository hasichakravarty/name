/*
Handler Class for PS_USerAdderorRemovedNotificationTrigger.
Date: 2 June'15 | Accenture IDC
*/

public class PS_UserAdderorRemovedNotificationHandler {
    public Static boolean isAdded = false;
    // When User Added to aTerritory then chatter post is added to already assigned users.
    public void userNotification(List<UserTerritory2Association> newUTAList){
        Set<Id> uid = new Set<Id>(); // Set of UserId's of users which are getting assigned to Territory
        // List of Territories Id's, to which user's are getting assigned.
        List<string> tid = new List<string>();
        List<Id> ptid = new List<Id>();
        Map<Id, Territory2> cpptid = new Map<Id,Territory2>();
        if(newUTAList != null){
            for(UserTerritory2Association ut : newUTAList){
                system.Debug('triggernew---->'+newUTAList+'---'+ut.Id);
                uid.add(ut.UserId);
                system.debug('uid--->'+uid);
                
                
                tid.add(ut.Territory2Id);
                system.Debug('tid---'+ tid);
            }
        }
        List<Territory2> TList = [select id, name, ParentTerritory2Id,ParentTerritory2.Name,Territory2ModelId,Territory2Model.Name from Territory2 where Id IN: tid];
        system.debug('TList???'+TList);
        for(Territory2 tr: TList){
            ptid.add(tr.ParentTerritory2Id);
        }
        system.debug('ptid>>>>'+ptid);
        List<Territory2> pTList = [select id, name, ParentTerritory2Id,ParentTerritory2.Name,ParentTerritory2.ParentTerritory2Id,ParentTerritory2.ParentTerritory2.Name,Territory2ModelId,Territory2Model.Name from Territory2 where ParentTerritory2Id IN: ptid];
        for(Territory2 t : pTList){
            system.debug('t.id----'+t.id);
            system.debug('t.ParentTerritory2.ParentTerritory2Id-----'+t.ParentTerritory2.ParentTerritory2Id);
            cpptid.put(t.id,t);
            cpptid.put(t.ParentTerritory2Id,t);
            cpptid.put(t.ParentTerritory2.ParentTerritory2Id,t);
        }
        system.debug('cpptid---------->'+cpptid);
       List<User> ulist = [select name from User where Id IN: uid];
        Map<Id, String> userMap = new Map<Id,String>(); // Map of All user 's name with their Id's.
        if(ulist != null){
            for(User u : ulist){
                userMap.put(u.Id,u.Name);
            }
        }
        // List of already Assigned users records in UserTerritory2Association for Territory Id.
        List<UserTerritory2Association> AssignedUsersToTerritory = [select id,Territory2Id,Territory2.Name, UserId ,User.Name,User.IsActive, RoleInTerritory2 
        from UserTerritory2Association where User.IsActive=true and Territory2Id IN: cpptid.keySet() And (RoleInTerritory2 =: System.Label.PS_AccountParTerUserRole  OR RoleInTerritory2 =: System.Label.PS_AccountGPTerUserRole)];
        system.debug('AssignedUsersToTerritory-->'+ AssignedUsersToTerritory);
        // Map of aready assigned user's record with there territory Id.
        Map<Id,List<UserTerritory2Association>> AssignedUsersToTerritoryMap = new Map<Id,List<UserTerritory2Association>>();
        if(AssignedUsersToTerritory != null){
            for(UserTerritory2Association aut : AssignedUsersToTerritory){
                if(AssignedUsersToTerritoryMap.containsKey(aut.Territory2Id)){
                    system.debug('In If-->'+ aut);
                    List<UserTerritory2Association> utList = AssignedUsersToTerritoryMap.get(aut.Territory2Id);
                    utList.add(aut);
                    AssignedUsersToTerritoryMap.put(aut.Territory2Id,utList);
                }ELSE{
                    system.debug('In else-->'+ aut);
                    List<UserTerritory2Association> utList = new List<UserTerritory2Association>();
                    utList.add(aut);
                    AssignedUsersToTerritoryMap.put(aut.Territory2Id,utList);
                }
            }
        }
        User useradmin=[select Id, Name,Email,UserRoleId,UserRole.Name from User where UserRole.Name =: System.Label.PS_TerritoryUserAdminRole and isactive=true limit 1];
        system.debug('AssignedUsersToTerritoryMap-----'+AssignedUsersToTerritoryMap);
        String msg = '';
         String adminmsg = '';
          Boolean flag = false;
        List<FeedItem> fiList = new List<FeedItem>();
        // for Each Territory for which users are getting assigned
        if(AssignedUsersToTerritoryMap.keyset() != null){
            for(Id i : AssignedUsersToTerritoryMap.keyset()){
                system.Debug('value of i----'+i);
                if(AssignedUsersToTerritoryMap.get(i) != null){
                    // for each already assigned user related to perticular Territory
                    for(UserTerritory2Association uat : AssignedUsersToTerritoryMap.get(i)){
                        system.Debug('UserAssociation record in last for---'+uat);
                        if(uat.User.IsActive == true){
                        // for each newly added user
                              for(UserTerritory2Association u : newUTAList){
                                
                            system.debug('u --->>'+ u);
                          //  if(u.Territory2Id == uat.Territory2Id){
                                FeedItem post = new FeedItem();
                                FeedItem adminpost = new FeedItem();
                                post.ParentId = uat.UserId;
                                 adminpost.ParentId = useradmin.Id;
                                msg = 'Attention '+ uat.User.Name+', \n You are receiving this notification because you are assigned as the '+uat.RoleInTerritory2 + ' associated to '+uat.Territory2.Name+'.';
                                adminmsg = 'Attention '+ useradmin.Name+', \n You are receiving this notification because you are assigned as the '+useradmin.UserRole.Name +'.';
                               if(isAdded == true){
                                    adminmsg += '\n \n Please be aware that '+ userMap.get(u.UserId) +' has been added';
                                    msg += '\n \n Please be aware that '+ userMap.get(u.UserId) +' has been added';
                                    if(u.RoleInTerritory2 != null){
                                        msg += ' as the ' + u.RoleInTerritory2;
                                        adminmsg += ' as the ' + u.RoleInTerritory2;
                                    }
                                    msg += ' to '+cpptid.get(u.Territory2ID).Name;
                                    adminmsg += ' to '+cpptid.get(u.Territory2ID).Name;
                                }
                                if(isAdded == false){
                                    adminmsg += '\n \n Please be aware that '+ userMap.get(u.UserId) +' has been removed';
                                    msg += '\n \n Please be aware that '+ userMap.get(u.UserId) +' has been removed';
                                    if(u.RoleInTerritory2 != null){
                                        adminmsg += ' as the ' + u.RoleInTerritory2;
                                        msg += ' as the ' + u.RoleInTerritory2;
                                    }
                                    adminmsg += ' from '+cpptid.get(u.Territory2ID).Name;
                                    msg += ' from '+cpptid.get(u.Territory2ID).Name;
                                }
                                msg += '\n \n If you believe this territory assignment or role alignment is incorrect or that you are receiving this message in error, please contact your manager.';
                                //msg += '\n \n Thank you for your support and remember we are Always Learning! ';
                                post.Body = msg;
                                adminpost.Body = adminmsg;
                                adminpost.CreatedDate = System.now();
                                system.Debug('adminpost feed---'+adminpost);
                                
                                post.CreatedDate = System.now();
                                system.Debug('Post feed---'+post);
                                fiList.add(post);
                                if(flag == false){
                                    fiList.add(adminpost);
                                }
                            }
                        } flag = true;
                        
                    }
                }
            }
        }
        system.debug('fiList---->'+fiList);
        if(fiList.size() > 0 && fiList.size() < 150){
          try{
            insert fiList;}
            catch(DMLException e){throw(e);}
        }
    }
}