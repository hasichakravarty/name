/* ----------------------------------------------------------------------------------------------------------------------------------------------------------
   Name:            PS_PSAccount_TriggerSequenceCtrlr.cls 
   Description:     On insert/update/delete of Account record 
   Date             Version         Author                             Summary of Changes 
   -----------      ----------      -----------------    ---------------------------------------------------------------------------------------------------
  03/2015         1.0            Manikandan                       Initial Release 
------------------------------------------------------------------------------------------------------------------------------------------------------------ */
public without sharing class Account_TriggerSequenceCtrlr {
    
    
     /**
    * Description : Performing all  Before Update Operations
    * @param NA
    * @return NA
    * @throws NA
    **/
    public static void beforeUpdate(List<Account> newAccounts,Map <Id,account>OldMap){
        System.debug('\n\n###########Before Update is called#####################\n\n');
        Ps_PreventChangingOwner.PreventChangingAccountOwner(newAccounts,oldMap);        
    }
    
    
    
    public static void AccountTerritoryAssociationNotification(List<Account> acList, Map<Id,Account> oldTriggerMap){
        
        system.debug('####!@#$---'+acList);
        if(acList != null){
            Set<String> newtrStr = new Set<String>();
            Set<String> oldtrStr = new Set<String>();
            Map<String,List<Account>> AddCodeAccountmap = new Map<String,List<Account>>();
            Map<String,List<Account>> RemovedCodeAccountmap = new Map<String,List<Account>>();
            Map<String,Id> territoryIDCOdeMap = new Map<String,Id>();
            for(Account ac: acList){
                if(ac.Territory_Code_s__c != null){
                    system.debug('ac.Territory_Code_s__c------'+ac.Territory_Code_s__c);
                    for(String s: ac.Territory_Code_s__c.split(',')){
                        newtrStr.add(s);
                    }
                    if(oldTriggerMap.get(ac.Id).Territory_Code_s__c != null){
                        for(String s : oldTriggerMap.get(ac.Id).Territory_Code_s__c.split(',')){
                            oldtrStr.add(s);
                        }
                    }
                }
                else{
                    if(oldTriggerMap.get(ac.Id).Territory_Code_s__c != null){
                        for(String s : oldTriggerMap.get(ac.Id).Territory_Code_s__c.split(',')){
                            oldtrStr.add(s);
                        }
                    }
                }
                system.debug('oldtrStr---'+oldtrStr);
                system.debug('newtrStr---'+newtrStr);
                if(newtrStr != null){
                    for(String ns : newtrStr){
                        if(!oldtrStr.Contains(ns)){
                            if(AddCodeAccountmap.containsKey(ns)){
                                system.debug('In If-->'+ ns);
                                List<Account> associatedAccList = AddCodeAccountmap.get(ns);
                                associatedAccList.add(ac);
                                AddCodeAccountmap.put(ns,associatedAccList);
                            }ELSE{
                                system.debug('In else-->'+ ns);
                                List<Account> associatedAccList = new List<Account>();
                                associatedAccList.add(ac);
                                AddCodeAccountmap.put(ns,associatedAccList);
                            }
                                        
                        }
                    }
                }
                if(oldtrStr != null){
                for(String aut : oldtrStr){
                    if(!newtrStr.Contains(aut)){
                        if(RemovedCodeAccountmap.containsKey(aut)){
                            system.debug('In If-->'+ aut);
                            List<Account> associatedAccList = RemovedCodeAccountmap.get(aut);
                            associatedAccList.add(ac);
                            RemovedCodeAccountmap.put(aut,associatedAccList);
                        }ELSE{
                            system.debug('In else-->'+ aut);
                            List<Account> associatedAccList = new List<Account>();
                            associatedAccList.add(ac);
                            RemovedCodeAccountmap.put(aut,associatedAccList);
                        }
                    }
                }
                }
            }               //}
        //}
            List<Territory2> trList = new List<Territory2>();
            If(RemovedCodeAccountmap != null && AddCodeAccountmap != null){
                trList = [select name,Territory_Code__c, ParentTerritory2Id,ParentTerritory2.Name,Territory2ModelId,Territory2Model.Name from Territory2 where Territory_Code__c IN: AddCodeAccountmap.keyset() OR Territory_Code__c IN: RemovedCodeAccountmap.keyset()];
            }
            List<Id> ptidList = new List<Id>();
            for(Territory2 t : trList){
                ptidList.add(t.ParentTerritory2Id);
            }
            //system.debug('ptid>>>>'+ptid);
            List<Territory2> pTList = [select id, name,Territory_Code__c, ParentTerritory2Id,ParentTerritory2.Territory_Code__c,ParentTerritory2.Name,ParentTerritory2.ParentTerritory2Id,ParentTerritory2.ParentTerritory2.Territory_Code__c,ParentTerritory2.ParentTerritory2.Name,Territory2ModelId,Territory2Model.Name from Territory2 where ParentTerritory2Id IN: ptidList];
            Map<Id,Territory2> ctidMap = new Map<Id,Territory2>();
            Map<Id,String> ptidMap = new Map<Id,String>();
            Map<Id,String> pptidMap = new Map<Id,String>();
            for(Territory2 t : pTList){
                system.debug('t.id----'+t.id);
                system.debug('t.ParentTerritory2.ParentTerritory2Id-----'+t.ParentTerritory2.ParentTerritory2Id);
                ctidMap.put(t.id,t);
                ptidMap.put(t.ParentTerritory2Id,t.ParentTerritory2.Territory_Code__c);
                pptidMap.put(t.ParentTerritory2.ParentTerritory2Id,t.ParentTerritory2.ParentTerritory2.Territory_Code__c);
            }
            
            
            List<UserTerritory2Association> AssignedUsersToTerritory = new List<UserTerritory2Association>();
            //Map of aready assigned user's record with there territory Id.
            Map<String,List<UserTerritory2Association>> AssignedUsersToTerritoryMap = new Map<String,List<UserTerritory2Association>>();
            If(ctidMap.KeySet() != null && ptidMap.KeySet() != null && pptidMap.KeySet() != null){
                //AssignedUsersToTerritory = [select id,Territory2.Territory_Code__c,Territory2.ParentTerritory2Id,Territory2Id,Territory2.ParentTerritory2.ParentTerritory2Id,Territory2.Name,Territory2.Territory2ModelId,Territory2.Territory2Model.Name, UserId ,User.Name,User.IsActive, RoleInTerritory2 from UserTerritory2Association where ((RoleInTerritory2 = 'Learning Technology Specialist' OR RoleInTerritory2 = 'Customer Digital Success Agent' OR RoleInTerritory2  = 'Temporary Sales Representative' OR RoleInTerritory2 = 'Sales Representative') AND (Territory2Id IN: ctidMap.KeySet())) OR (RoleInTerritory2 = 'District Manager' AND Territory2Id IN: ptidMap.keyset()) OR (RoleInTerritory2 = 'Regional Manager' AND Territory2Id IN: pptidMap.keyset())];
                String[] usrrole=System.Label.PS_AccountTerritoryUserRole.split(',');
                AssignedUsersToTerritory = [select id,Territory2.Territory_Code__c,Territory2.ParentTerritory2Id,Territory2Id,Territory2.ParentTerritory2.ParentTerritory2Id,
                Territory2.Name,Territory2.Territory2ModelId,Territory2.Territory2Model.Name, UserId ,User.Name,User.IsActive, RoleInTerritory2 from 
                UserTerritory2Association where User.IsActive=true and
                ((RoleInTerritory2 in :usrrole AND Territory2Id IN: ctidMap.KeySet()) OR 
                (RoleInTerritory2 = :System.Label.PS_AccountParTerUserRole AND Territory2Id IN: ptidMap.keyset()) OR 
                (RoleInTerritory2 = : System.Label.PS_AccountGPTerUserRole AND Territory2Id IN: pptidMap.keyset()))];
            }
                      
            system.debug('AssignedUsersToTerritory-----'+AssignedUsersToTerritory);
            if(AssignedUsersToTerritory != null){
                for(UserTerritory2Association aut : AssignedUsersToTerritory){
                    if(AssignedUsersToTerritoryMap.containsKey(aut.Territory2.Territory_Code__c)){
                        system.debug('In If-->'+ aut);
                        List<UserTerritory2Association> utList = AssignedUsersToTerritoryMap.get(aut.Territory2.Territory_Code__c);
                        utList.add(aut);
                        AssignedUsersToTerritoryMap.put(aut.Territory2.Territory_Code__c,utList);
                    }ELSE{
                        system.debug('In else-->'+ aut);
                        List<UserTerritory2Association> utList = new List<UserTerritory2Association>();
                        utList.add(aut);
                        AssignedUsersToTerritoryMap.put(aut.Territory2.Territory_Code__c,utList);
                    }
                }
            }
        User useradmin;
        try{
            useradmin = [select Id, Name,Email,UserRoleId,UserRole.Name from User where UserRole.Name = :System.Label.PS_TerritoryUserAdminRole 
            AND Market__c =: System.Label.PS_TerritoryMarket and isactive=true limit 1];
        }catch(Exception e){
            system.debug('No Admin Exist');
        }
            system.debug('AssignedUsersToTerritoryMap-----'+AssignedUsersToTerritoryMap);
            String msg = '';
            String adminmsg = '';
            Boolean flag = false;
            List<FeedItem> fiList = new List<FeedItem>();
            if(AssignedUsersToTerritoryMap != null){
            System.debug('AddCodeAccountmap---->'+AddCodeAccountmap);
            System.debug('RemovedCodeAccountmap---->'+RemovedCodeAccountmap);
            for(String st : AssignedUsersToTerritoryMap.KeySet()){//loop -1
                system.debug('AddCodeAccountmap.containsKey(st)---->>'+AddCodeAccountmap.containsKey(st));
                if(AddCodeAccountmap != null && AddCodeAccountmap.containsKey(st)){
                  flag = false;
                  List<UserTerritory2Association>  lst =  AssignedUsersToTerritoryMap.get(st);
                  System.debug('lst---->'+lst);
                  
                  List<UserTerritory2Association> alluser = new List<UserTerritory2Association>();
                  System.debug('00---->'+ptidMap.containsKey(lst[0].Territory2.ParentTerritory2Id) + 'user assigned--:>'+AssignedUsersToTerritoryMap.get(ptidMap.get(lst[0].Territory2.ParentTerritory2Id)));
                  system.debug('prid-->><>'+lst[0].Territory2.ParentTerritory2Id);
                  system.debug('parent tr map---'+ptidMap);
                  system.debug('parentTerritory-----'+ptidMap.get(lst[0].Territory2.ParentTerritory2Id));
                  if(ptidMap.containsKey(lst[0].Territory2.ParentTerritory2Id) && AssignedUsersToTerritoryMap.get(ptidMap.get(lst[0].Territory2.ParentTerritory2Id)) != null){
                      System.debug('in side If----');
                      alluser.addAll(AssignedUsersToTerritoryMap.get(ptidMap.get(lst[0].Territory2.ParentTerritory2Id)));
                      System.debug('alluser--'+alluser);
                      for(Territory2 cti : ctidMap.values()){ //loop -2
                          System.debug('cti--'+cti.ParentTerritory2Id+ 'AssignedUsers=='+AssignedUsersToTerritoryMap.get(cti.territory_Code__c));
                        if(cti.ParentTerritory2Id==lst[0].Territory2.ParentTerritory2Id && AssignedUsersToTerritoryMap.get(cti.territory_Code__c) != null){
                            alluser.addAll(AssignedUsersToTerritoryMap.get(cti.territory_Code__c));
                            system.debug('Parent assigned user------->'+AssignedUsersToTerritoryMap.get(cti.territory_Code__c));
                        }
                      }
                  }
                  system.debug('truefalse---'+pptidMap.containsKey(lst[0].Territory2.ParentTerritory2.ParentTerritory2Id));
                  system.debug('truefalse user'+AssignedUsersToTerritoryMap.get(pptidMap.get(lst[0].Territory2.ParentTerritory2.ParentTerritory2Id)));
                  if(pptidMap.containsKey(lst[0].Territory2.ParentTerritory2.ParentTerritory2Id) && AssignedUsersToTerritoryMap.get(pptidMap.get(lst[0].Territory2.ParentTerritory2.ParentTerritory2Id))!= null){
                      system.debug(AssignedUsersToTerritoryMap.get(pptidMap.get(lst[0].Territory2.ParentTerritory2.ParentTerritory2Id)));
                      alluser.addAll(AssignedUsersToTerritoryMap.get(pptidMap.get(lst[0].Territory2.ParentTerritory2.ParentTerritory2Id)));
                  }
                  system.debug('allusers-----'+alluser);
                  for(UserTerritory2Association uat : alluser){
                    if(uat.User.IsActive == true){
                    FeedItem post = new FeedItem();
                    FeedItem adminpost = new FeedItem();
                    post.ParentId = uat.UserId; 
                    adminpost.ParentId = useradmin.Id;
                    msg = 'Attention '+ uat.User.Name+', \n You are receiving this notification because you are assigned as the '+uat.RoleInTerritory2 + ' associated to '+uat.Territory2.Name+'.';
                    adminmsg = 'Attention '+ useradmin.Name+', \n You are receiving this notification because you are assigned as the '+useradmin.UserRole.Name+'.';
                    system.debug('AddCodeAccountmap -----'+AddCodeAccountmap);
                    adminmsg += '\n \n Please be aware that , ';
                    msg += '\n \n Please be aware that , ';
                    for(Account ac : AddCodeAccountmap.get(st)){
                        msg += ac.name + ' ';
                        adminmsg += ac.name + ' ';
                    }   
                    adminmsg += ' was recently assigned to '+ lst[0].Territory2.Name;
                    msg += ' was recently assigned to '+ lst[0].Territory2.Name;
                    if(lst[0].UserId == uat.UserId){
                        msg += ' where you are the assigned '+uat.RoleInTerritory2;
                    }
                    adminmsg += ' and can be seen in the '+ uat.Territory2.Territory2Model.Name+' territory hierarchy.';
                    msg += ' and can be seen in the '+ uat.Territory2.Territory2Model.Name+' territory hierarchy.';
                    msg += '\n \n If you believe this account territory reassignment was made incorrectly or that you are receiving this message in error, please contact your Territory Administrator, '+useradmin.Name+' at '+ useradmin.Email;
                    post.Body = msg;
                    adminpost.body = adminmsg;
                    post.CreatedDate = System.now();
                    adminpost.CreatedDate = System.now();
                    system.Debug('Post feed---'+post);
                    fiList.add(post);
                    if(flag == false){
                        fiList.add(adminpost);
                    }
                    flag = true;
                  }
                }
                }   
                //}
                //for(String st : AssignedUsersToTerritoryMap.KeySet()){
                if(RemovedCodeAccountmap != null && RemovedCodeAccountmap.containsKey(st)){
                  List<UserTerritory2Association>  lst =  AssignedUsersToTerritoryMap.get(st);
                  List<UserTerritory2Association> alluser = new List<UserTerritory2Association>();
                  if(ptidMap.containsKey(lst[0].Territory2.ParentTerritory2Id) && AssignedUsersToTerritoryMap.get(ptidMap.get(lst[0].Territory2.ParentTerritory2Id)) != null){
                      alluser.addAll(AssignedUsersToTerritoryMap.get(ptidMap.get(lst[0].Territory2.ParentTerritory2Id)));
                      for(Territory2 cti : ctidMap.values()){
                        if(cti.ParentTerritory2Id==lst[0].Territory2.ParentTerritory2Id && AssignedUsersToTerritoryMap.get(cti.territory_Code__c) != null){
                            alluser.addAll(AssignedUsersToTerritoryMap.get(cti.territory_Code__c));
                        }
                      }
                  }
                  if(pptidMap.containsKey(lst[0].Territory2.ParentTerritory2.ParentTerritory2Id) && AssignedUsersToTerritoryMap.get(pptidMap.get(lst[0].Territory2.ParentTerritory2.ParentTerritory2Id)) != null){
                      alluser.addAll(AssignedUsersToTerritoryMap.get(pptidMap.get(lst[0].Territory2.ParentTerritory2.ParentTerritory2Id)));
                  }
                  for(UserTerritory2Association uat : alluser){
                    if(uat.User.IsActive == true){  
                        FeedItem post = new FeedItem();
                        FeedItem adminpost = new FeedItem();
                        post.ParentId = uat.UserId;
                        adminpost.ParentId = useradmin.Id;                      
                        msg = 'Attention '+ uat.User.Name+', \n You are receiving this notification because you are assigned as the '+uat.RoleInTerritory2 + ' associated to '+uat.Territory2.Name+'.';
                        adminmsg = 'Attention '+ useradmin.Name+', \n You are receiving this notification because you are assigned as the '+useradmin.UserRole.Name+'.';
                        msg += '\n \n Please be aware that , ';
                        adminmsg += '\n \n Please be aware that , ';
                        for(Account ac : RemovedCodeAccountmap.get(st)){
                            msg += ac.name + ' ';
                            adminmsg += ac.name + ' ';
                        }   
                        msg += ' was recently unassigned from '+ lst[0].Territory2.Name;
                        if(lst[0].UserId == uat.UserId){
                            msg += ' where you are the assigned '+uat.RoleInTerritory2;
                        }
                        adminmsg += ' and can be seen in the '+ uat.Territory2.Territory2Model.Name+' territory hierarchy.';
                        msg += ' and can be seen in the '+ uat.Territory2.Territory2Model.Name+' territory hierarchy.';
                        msg += '\n \n If you believe this account territory reassignment was made incorrectly or that you are receiving this message in error, please contact your Territory Administrator, '+useradmin.Name+' at '+ useradmin.Email;
                        post.Body = msg;
                        adminpost.body = adminmsg;
                        post.CreatedDate = System.now();
                        adminpost.CreatedDate = System.now();
                        system.Debug('Post feed---'+post);
                        fiList.add(post);
                        if(flag == false){
                            fiList.add(adminpost);
                        }
                        flag = true;
                    }
                  }
                }   
                //}
            }
            }
                
            system.debug('fiList---->'+fiList);
            if(fiList.size() > 0 && fiList.size() < 150){
                insert fiList;
            }
        }
    }// Pooja
            
    //}
    
    
    
    
    
    /**
    * Description : Performing all  before Insert operation
    * @param NA
    * @return NA
    * @throws NA
    **/
    public static void beforeInsert(List<Account> newAccounts){
        if(newAccounts.size()>0){
        PS_Account_RecordTagging_Ctrlr.accountRecordTagging(newAccounts);
        }
    }
    
    /**
    * Description : Performing all  before Insert operation
    * @param NA
    * @return NA
    * @throws NA
    **/
    public static void beforeInsertOrUpdate(List<Account> newAccounts , Boolean isInsert){
         system.debug('newAccounts--------->'+newAccounts);
         
     /*     Map<String, Schema.SObjectType> sObjectMap = Schema.getGlobalDescribe() ;
         Schema.SObjectType Accnt = sObjectMap.get('Account') ; // getting Sobject Type
        Schema.DescribeSObjectResult accntresSchema = Accnt.getDescribe() ;
        Map<String,Schema.RecordTypeInfo> accntrecordTypeInfo = accntresSchema.getRecordTypeInfosByName(); //getting all Recordtype for the Sobject
          
            if(isInsert){
                for(Account accObj : newAccounts){
                    if(accObj.IsCreatedFromLead__c)
                            accObj.recordtypeid = accntrecordTypeInfo.get('Learner').getRecordTypeId();
                }
            } */
           //  system.debug('newAccounts[0].recordtypeid--------->'+newAccounts[0].recordtypeid);
           //Commented as part of R3 since its not used any more
         //CalculateAccountFee.CalculateFee(newAccounts);
    }
    
    
    /**
    * Description : Performing all  After Insert Operations
    * @param List<Account> newAccounts
    * @return NA
    * @throws NA
    **/
    public static void afterInsert( List<Account> newAccounts , Map<Id,Account> newAccount_Id_Map){
        
        /*//Map<String, Schema.SObjectType> sObjectMap = Schema.getGlobalDescribe() ;
         Map<String, Schema.SObjectType> sObjectMap = Schema.getGlobalDescribe() ;
         Schema.SObjectType Accnt = sObjectMap.get('Account') ; // getting Sobject Type
        Schema.DescribeSObjectResult accntresSchema = Accnt.getDescribe() ;
        Map<String,Schema.RecordTypeInfo> accntrecordTypeInfo = accntresSchema.getRecordTypeInfosByName(); //getting all Recordtype for the Sobject
        Id actrtId = accntrecordTypeInfo.get('Learner').getRecordTypeId();//particular RecordId by  Name 
        List<account>AccList = new list<Account> ();
        //AddAccountTeamMember.onInsert(newAccounts);
        For(account a : newAccounts)
        {
         a.recordTypeId = actrtId;
         AccList.add(a);
         
         }
         update AccList ;
         System.debug('aac update'+AccList);*/
        System.debug('triger.new list-->'+newAccounts);  
        UpdateTeamMember.updateAccountOwner(newAccounts);
        System.debug('triger.new list111-->'+newAccounts); 
        UpdateTeamMember.addAccountTeamMember(newAccounts);
        UpdateTeamMember.UpdateAccountShare(newAccounts , newAccount_Id_Map);
        GeneratePearsonId.GenerateRandomPearsonID(newAccounts);
        
    }
    
     /**
    * Description : Performing all  After Update Operations
    * @param NA
    * @return NA
    * @throws NA
    **/
    public static void afterUpdate(List<Account> oldAccounts){
        System.debug('###########After Update is called*********************');
    }
    
    /**
    * Description : Performing all  AfterInsert or AfterUpdate operation
    * @param NA List<Account> newtriggeredAccounts,Boolean isInsert,Boolean isUpdate 
    * @return NA
    * @throws NA
    **/
    public static void afterInsertOrUpdate( List<Account> neworgAccounts,Boolean isInsert,Boolean isUpdate ){
        system.debug('*************** neworgAccounts : '+neworgAccounts);
        //Added for R3 to fetch All record types and create a list of Organization  TYpe account
        Map<String, Map<String,ID>> mapObjRecord= PS_Util.fetchAllRecordType();
        List<Account> accLst = new List<Account>();
        System.debug('test123456----->'+mapObjRecord.get('Account').get(Label.PS_Account_Organisation));
        for(Account accObj : neworgAccounts){
            if(accObj.recordtypeid==mapObjRecord.get('Account').get(Label.PS_Account_Organisation))
                accLst.add(accObj);         
        }
        UpdatePrimarySellingAccountCheck.processOnInsert_Update(accLst,isInsert,isUpdate ); 
        
    }
    
    /**
    * Description : Performing all  After Delete operation
    * @param NA
    * @return NA
    * @throws NA
    **/
   /* public static void afterDelete()
    {
     }*/

}