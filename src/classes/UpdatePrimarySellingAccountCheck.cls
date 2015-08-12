public class UpdatePrimarySellingAccountCheck {

    public static void initialize( List<Account> newtriggeredAccounts,List<Id> rootIds,
                                   List<Id> rootIdsOfChildAccHierarchy,List<Id> accountIds,
                                   List<Id> UncheckedParentsWithChild){
            for(Account acc : newtriggeredAccounts){
                    accountIds.add(acc.Id);
                    if(acc.Primary_Selling_Account_check__c)
                        rootIds.add(acc.id);
                        //Commented for R3 since this logic is not used any more
                   /* if(Trigger.isUpdate && acc.Primary_Selling_Account_check__c == false && acc.Parent.Primary_Selling_Account_check__c != null)
                        rootIdsOfChildAccHierarchy.add(acc.id);*/
                    if(Trigger.isUpdate && !acc.Primary_Selling_Account_check__c)
                        UncheckedParentsWithChild.add(acc.Id);
                }
    }
    
    public static void processOnInsert_Update( List<Account> newtriggeredAccounts,Boolean isInsert,Boolean isUpdate ){
       
    Map<Id,Integer> accounts_noOfParentsMap = new Map<Id,Integer>();
    List<Id> accountIds = new List<Id>();
    List<Account> newAccounts,oldParentAccounts,oldChildAccounts,newChildAccounts,
                  firstLevelChildAccounts,secondLevelChildAccounts,thirdLevelChildAccounts;
    List<Id> newAccountIds = new List<Id>();
    List<Id> parentOfcheckedAccountIds = new List<Id>();
    Map<Id,Id> UnCheckedAccountId_ParentIdMap = new Map<Id,Id>();
    boolean noPSA = false;
    List<Account> accountsNotHavingPSA = new List<Account>();
    List<Id> rootIds = new List<Id>();
    List<Id> firstLevelAccountIds = new List<Id>();
    List<Id> secondLevelAccountIds = new List<Id>();
    List<Id> thirdLevelAccountIds = new List<Id>();
    List<Id> rootIdsOfChildAccHierarchy = new List<Id>();
    List<Id> rootIdsOnly1stLevel = new List<Id>();
    List<Id> rootIdsOnly2ndLevel = new List<Id>();  
    List<Id> UncheckedParentsWithChild = new List<Id>();  
    List<Account> accountsToUpdate = new List<Account>(); 
        
        try{
        system.debug('*****************************Entered Trigger');    
        initialize(newtriggeredAccounts,rootIds,rootIdsOfChildAccHierarchy,accountIds,UncheckedParentsWithChild);
        System.debug('**************AccountIds : '+accountIds);     
        
            If(isInsert || isUpdate){
                
                 // Update all the childs of unchecked Account with null values in PSA
            if(UncheckedParentsWithChild != null){
                firstLevelChildAccounts = [SELECT id,ParentId,Primary_Selling_Account__c
                                           FROM Account
                                           WHERE ParentId IN : UncheckedParentsWithChild];
                if(firstLevelChildAccounts != null){
                    for(Account acc : firstLevelChildAccounts){
                        firstLevelAccountIds.add(acc.id);
                        acc.Primary_Selling_Account__c = null;
                    }
                    //update firstLevelChildAccounts;//Commented for R3 to restrict mutiple updates on Account
                    accountsToUpdate.addall(firstLevelChildAccounts);
                }    
                if(!firstLevelChildAccounts.isEmpty()){
                secondLevelChildAccounts = [SELECT id,Primary_Selling_Account__c,Parent.ParentId
                                           FROM Account
                                           WHERE ParentId IN : firstLevelAccountIds];
                if(secondLevelChildAccounts != null){
                    for(Account acc : secondLevelChildAccounts){
                        secondLevelAccountIds.add(acc.id);
                        acc.Primary_Selling_Account__c = null;
                    }
                    //update secondLevelChildAccounts;//Commented for R3 to restrict mutiple updates on Account
                    accountsToUpdate.addall(secondLevelChildAccounts);
                    
                }
                }
                if(!secondLevelChildAccounts.isEmpty()){
                thirdLevelChildAccounts = [SELECT id,Primary_Selling_Account__c,Parent.Parent.ParentId
                                           FROM Account
                                           WHERE ParentId IN : secondLevelAccountIds];
                if(thirdLevelChildAccounts != null){
                    for(Account acc : thirdLevelChildAccounts){
                            thirdLevelAccountIds.add(acc.id);
                            acc.Primary_Selling_Account__c = null;
                        }
                    //update thirdLevelChildAccounts;//Commented for R3 to restrict mutiple updates on Account
                    accountsToUpdate.addall(thirdLevelChildAccounts);

                }
                }
                if(!accountsToUpdate.isEmpty()){
                    update accountsToUpdate;
                }
                
            }
            
            firstLevelAccountIds = new List<Id>();
            secondLevelAccountIds = new List<Id>();
            thirdLevelAccountIds = new List<Id>();
            accountsToUpdate = new List<Account>();
            
            system.debug('*****************************UncheckedParentsWithChild : '+UncheckedParentsWithChild);
            system.debug('*****************************firstLevelChildAccounts : '+firstLevelChildAccounts);
            system.debug('*****************************secondLevelChildAccounts : '+secondLevelChildAccounts);
            system.debug('*****************************thirdLevelChildAccounts : '+thirdLevelChildAccounts);
                
                // Update all the childs Primary_Selling_Account till the 4 levels down 
                system.debug('rootIds: '+rootIds);
                if(rootIds != null){
                    firstLevelChildAccounts = [SELECT id,ParentId,Primary_Selling_Account__c
                                               FROM Account
                                               WHERE ParentId IN : rootIds];
                    if(firstLevelChildAccounts != null){
                        for(Account acc : firstLevelChildAccounts){
                            firstLevelAccountIds.add(acc.id);
                            acc.Primary_Selling_Account__c = acc.ParentId;
                        }
                        //update firstLevelChildAccounts;//Commented for R3 to restrict mutiple updates on Account
                        if(!firstLevelChildAccounts.isEmpty())
                             accountsToUpdate.addall(firstLevelChildAccounts);
                    }    
                    if(!firstLevelChildAccounts.isEmpty()){
                        secondLevelChildAccounts = [SELECT id,Primary_Selling_Account__c,Parent.ParentId
                                                   FROM Account
                                                   WHERE ParentId IN : firstLevelAccountIds];
                        if(secondLevelChildAccounts != null){
                            for(Account acc : secondLevelChildAccounts){
                                secondLevelAccountIds.add(acc.id);
                                acc.Primary_Selling_Account__c = acc.Parent.ParentId;
                            }
                            //update secondLevelChildAccounts;//Commented for R3 to restrict mutiple updates on Account
                            if(!secondLevelChildAccounts.isEmpty())
                                accountsToUpdate.addall(secondLevelChildAccounts);
                        }
                    }
                    if(!secondLevelChildAccounts.isEmpty()){
                        thirdLevelChildAccounts = [SELECT id,Primary_Selling_Account__c,Parent.Parent.ParentId
                                                   FROM Account
                                                   WHERE ParentId IN : secondLevelAccountIds];
                        if(thirdLevelChildAccounts != null){
                            for(Account acc : thirdLevelChildAccounts){
                                    thirdLevelAccountIds.add(acc.id);
                                    acc.Primary_Selling_Account__c = acc.Parent.Parent.ParentId;
                                }
                            //update thirdLevelChildAccounts;//Commented for R3 to restrict mutiple updates on Account
                            if(!thirdLevelChildAccounts.isEmpty())
                                accountsToUpdate.addall(thirdLevelChildAccounts);
                        }
                    }
                    
                    if(!accountsToUpdate.isEmpty())
                        update accountsToUpdate;
                }
                
                //When a hierarchy itself is joined to another hierarchy
               /* if(rootIdsOfChildAccHierarchy != null){
                    List<Account> newaccountHierarchyRoot = [SELECT id,Parent.Primary_Selling_Account__c
                                               FROM Account
                                               WHERE id IN : rootIdsOfChildAccHierarchy];
                    for(Account acc:newaccountHierarchyRoot ){
                        if(acc.Parent.Primary_Selling_Account__c != null &&
                           acc.Parent.Parent.Primary_Selling_Account__c != null)
                             accounts_noOfParentsMap.put(acc.id,2);
                        else if(acc.Parent.Primary_Selling_Account__c != null)  
                            accounts_noOfParentsMap.put(acc.id,1);
                    }
                    
                    for(Id accid : accounts_noOfParentsMap.keySet()){
                        if(accounts_noOfParentsMap.get(accid) == 1)
                            rootIdsOnly1stLevel.add(accid);
                        else 
                            rootIdsOnly2ndLevel.add(accid);
                    }
                    
                    if(rootIdsOnly1stLevel != null){
                        firstLevelChildAccounts = [SELECT id,ParentId,Primary_Selling_Account__c
                                                   FROM Account
                                                   WHERE ParentId IN : rootIdsOnly1stLevel];
                        
                        if(firstLevelChildAccounts != null){
                            for(Account acc : firstLevelChildAccounts){
                                firstLevelAccountIds.add(acc.id);
                                acc.Primary_Selling_Account__c = acc.ParentId;
                            }
                            update firstLevelChildAccounts;
                        }    
                    }
                    
                    if(rootIdsOnly2ndLevel != null){
                         firstLevelChildAccounts = [SELECT id,ParentId,Primary_Selling_Account__c
                                                   FROM Account
                                                   WHERE ParentId IN : rootIdsOnly2ndLevel];
                        
                        if(firstLevelChildAccounts != null){
                            for(Account acc : firstLevelChildAccounts){
                                firstLevelAccountIds.add(acc.id);
                                acc.Primary_Selling_Account__c = acc.ParentId;
                            }
                            update firstLevelChildAccounts;
                        }    
                        secondLevelChildAccounts = [SELECT id,Primary_Selling_Account__c,Parent.ParentId
                                                   FROM Account
                                                   WHERE ParentId IN : firstLevelAccountIds];
                        if(secondLevelChildAccounts != null){
                            for(Account acc : secondLevelChildAccounts){
                                secondLevelAccountIds.add(acc.id);
                                acc.Primary_Selling_Account__c = acc.Parent.ParentId;
                            }
                            update secondLevelChildAccounts;
                        }
                        }
                    
                }*/
                
                system.debug('*****************************accountIds : '+accountIds);
                system.debug('*****************************firstLevelChildAccounts : '+firstLevelChildAccounts);
                system.debug('*****************************secondLevelChildAccounts : '+secondLevelChildAccounts);
                system.debug('*****************************thirdLevelChildAccounts : '+thirdLevelChildAccounts);
                
                newAccounts = [SELECT Primary_Selling_Account_check__c,
                                            Parent.id,Parent.Primary_Selling_Account_check__c,
                                            Parent.Parent.id,Parent.Parent.Primary_Selling_Account_check__c,
                                            Parent.Parent.Parent.id,Parent.Parent.Parent.Primary_Selling_Account_check__c,
                                            Parent.Parent.Parent.Parent.id,Parent.Parent.Parent.Parent.Primary_Selling_Account_check__c
                                     FROM Account 
                                     WHERE Id IN :accountIds];
               
                system.debug('********************** accounts = '+ newAccounts);
                
                for(Account acc : newAccounts){
                   
                     if(acc.ParentId!=null ) {
                            if(acc.Parent.Primary_Selling_Account_check__c == true)
                                if(acc.Primary_Selling_Account_check__c == true)
                                    parentOfcheckedAccountIds.add(acc.ParentId);
                                else
                                    UnCheckedAccountId_ParentIdMap.put(acc.id,acc.ParentId);
                            else if(acc.Parent.ParentId!=null){
                                if(acc.Parent.Parent.Primary_Selling_Account_check__c == true)
                                    if(acc.Primary_Selling_Account_check__c == true)
                                        parentOfcheckedAccountIds.add(acc.Parent.ParentId);
                                    else
                                        UnCheckedAccountId_ParentIdMap.put(acc.id,acc.Parent.ParentId);
                                else if(acc.Parent.Parent.ParentId!=null){
                                    if(acc.Parent.Parent.Parent.Primary_Selling_Account_check__c == true)
                                       if(acc.Primary_Selling_Account_check__c == true)
                                            parentOfcheckedAccountIds.add(acc.Parent.Parent.ParentId);
                                       else
                                            UnCheckedAccountId_ParentIdMap.put(acc.id,acc.Parent.Parent.ParentId); 
                                    else if(acc.Parent.Parent.Parent.ParentId!=null){
                                        if(acc.Parent.Parent.Parent.Primary_Selling_Account_check__c == true)
                                            if(acc.Primary_Selling_Account_check__c == true)
                                                parentOfcheckedAccountIds.add(acc.Parent.Parent.Parent.ParentId);
                                            else
                                                UnCheckedAccountId_ParentIdMap.put(acc.id,acc.Parent.Parent.Parent.ParentId);
                                            
                                    }    
                                }        
                            }
                        }   
                        
                    if( parentOfcheckedAccountIds.size() == 0  && UnCheckedAccountId_ParentIdMap.size() == 0 ){
                        if(acc.Parent.Primary_Selling_Account_check__c == false){
                            accountsNotHavingPSA.add(acc);
                        }
                    }
                }
                
                        
                system.debug('********************** parentOfcheckedAccountIds : '+parentOfcheckedAccountIds);
                system.debug('********************** UnCheckedAccountId_ParentIdMap : '+UnCheckedAccountId_ParentIdMap);
                system.debug('********************** accountsNotHavingPSA : '+accountsNotHavingPSA);
                
               //Added for R3 to restrict Mutilple update
               List<Account> accFinalUpdateLst = new List<Account>();
                
                    
                //Update the OldChildAccounts 'Primary Selling Account' and OldParent Accounts 'Primary Selling Account check' fields
                    if(parentOfcheckedAccountIds != null)
                        oldChildAccounts = [SELECT Primary_Selling_Account__c 
                                            FROM Account 
                                            WHERE Primary_Selling_Account__c IN :parentOfcheckedAccountIds];
                    
                    system.debug('********************** oldChildAccounts : '+oldChildAccounts);
                    
                    if(oldChildAccounts !=null ){
                        for(Account acc : oldChildAccounts){
                            acc.Primary_Selling_Account__c = null;
                        }
                        //update oldChildAccounts;//Commented for R3 to restric mutiple updates on Account
                        accFinalUpdateLst.addAll(oldChildAccounts);
                    }
                    
                    if(parentOfcheckedAccountIds !=null) 
                        oldParentAccounts = [SELECT Primary_Selling_Account_check__c FROM Account 
                                             WHERE id IN :parentOfcheckedAccountIds ];
                    
                    system.debug('********************** oldParentAccounts : '+oldParentAccounts);
                    
                    if(oldParentAccounts != null){
                        for(Account acc : oldParentAccounts){
                            acc.Primary_Selling_Account_check__c = false;
                        } 
                       //update oldParentAccounts;//Commented for R3 to Restrict mutiple updates on Account
                       accFinalUpdateLst.addAll(oldParentAccounts);
                    }
                
                
                
                // Update the NewChildAccounts 'Primary Selling Account' field with Parent Account information
                
                if(UnCheckedAccountId_ParentIdMap != null)
                    newChildAccounts = [SELECT Primary_Selling_Account__c,Parent.id
                                        FROM Account 
                                        WHERE id IN :UnCheckedAccountId_ParentIdMap.keySet()];
                
                system.debug('********************** newChildAccounts : '+newChildAccounts);
                
                //Commented for R3 since this SOQL is used only for Debug
                
              /*  List<Account> parentofUncheckedAccount = [SELECT id,Primary_Selling_Account_check__c,Parent.id
                                                          FROM Account 
                                                          WHERE id IN :UnCheckedAccountId_ParentIdMap.values()];
                
                system.debug('***********************parentofUncheckedAccount : '+parentofUncheckedAccount);*/
               
           
                
                if(newChildAccounts!=null){
                    for(Account acc : newChildAccounts){
                        acc.Primary_Selling_Account__c = UnCheckedAccountId_ParentIdMap.get(acc.id);
                    }
                   // update newChildAccounts;//Commented for R3 to restrict mutiple updates on Account
                   accFinalUpdateLst.addAll(newChildAccounts);
                }
                
                // If both checked and unchecked accounts are not there and there is no primary selling account for the current account
                if(accountsNotHavingPSA != null){
                    for(Account acc : accountsNotHavingPSA){
                        if(acc.Primary_Selling_Account_check__c != true)
                            acc.Primary_Selling_Account__c = null;
                    }
                    //update accountsNotHavingPSA;//Commented for R3 to restrict mutiple updates on Account
                    accFinalUpdateLst.addAll(accountsNotHavingPSA);
                 }   
                 system.debug('accFinalUpdateLst---------->'+accFinalUpdateLst);
            if(!accFinalUpdateLst.isEmpty())
                    update accFinalUpdateLst;   
            }
             
        
       }catch(Exception ex){
            system.debug('$$$$$$$$$$$Exception :'+ex);     
       }     
    }

    // Update all the childs Primary_Selling_Account to null till the 4 levels down if Primary Selling Account got deleted                             
     public static void processOnDelete( List<Account> newtriggeredAccounts,
                                          List<Account> oldtriggeredAccounts,
                                          Boolean isDelete ){
        Map<Id,Integer> accounts_noOfParentsMap = new Map<Id,Integer>();
        List<Id> accountIds = new List<Id>();
        List<Account> newAccounts,oldParentAccounts,oldChildAccounts,newChildAccounts,
                      firstLevelChildAccounts,secondLevelChildAccounts,thirdLevelChildAccounts;
        List<Id> newAccountIds = new List<Id>();
        List<Id> parentOfcheckedAccountIds = new List<Id>();
        Map<Id,Id> UnCheckedAccountId_ParentIdMap = new Map<Id,Id>();
        boolean noPSA = false;
        List<Account> accountsNotHavingPSA = new List<Account>();
        List<Id> rootIds = new List<Id>();
        List<Id> firstLevelAccountIds = new List<Id>();
        List<Id> secondLevelAccountIds = new List<Id>();
        List<Id> thirdLevelAccountIds = new List<Id>();
        List<Id> rootIdsOfChildAccHierarchy = new List<Id>();
        List<Id> UncheckedParentsWithChild = new List<Id>(); 
                                              
        try{                                     
           initialize(newtriggeredAccounts,rootIds,rootIdsOfChildAccHierarchy,accountIds,UncheckedParentsWithChild);
           if(isDelete){
                
                for(Account acc : oldtriggeredAccounts){
                    accountIds.add(acc.Id);
                    if(acc.Primary_Selling_Account_check__c == true)
                        rootIds.add(acc.id);
                }
                
                firstLevelChildAccounts = [SELECT id,ParentId,Primary_Selling_Account__c
                                           FROM Account
                                           WHERE ParentId IN : rootIds];
                if(firstLevelChildAccounts != null){
                    for(Account acc : firstLevelChildAccounts){
                        firstLevelAccountIds.add(acc.id);
                        acc.Primary_Selling_Account__c = null;
                    }
                    update firstLevelChildAccounts;
                }    
                secondLevelChildAccounts = [SELECT id,Primary_Selling_Account__c
                                           FROM Account
                                           WHERE ParentId IN : firstLevelAccountIds];
                if(secondLevelChildAccounts != null){
                    for(Account acc : secondLevelChildAccounts){
                        secondLevelAccountIds.add(acc.id);
                        acc.Primary_Selling_Account__c = null;
                    }
                    update secondLevelChildAccounts;
                }
                thirdLevelChildAccounts = [SELECT id,Primary_Selling_Account__c
                                           FROM Account
                                           WHERE ParentId IN : secondLevelAccountIds];
                if(thirdLevelChildAccounts != null){
                    for(Account acc : thirdLevelChildAccounts){
                            thirdLevelAccountIds.add(acc.id);
                            acc.Primary_Selling_Account__c = null;
                        }
                    update thirdLevelChildAccounts;
                }
                system.debug('*****************************accountIds : '+accountIds);
                system.debug('*****************************firstLevelChildAccounts : '+firstLevelChildAccounts);
                system.debug('*****************************secondLevelChildAccounts : '+secondLevelChildAccounts);
                system.debug('*****************************thirdLevelChildAccounts : '+thirdLevelChildAccounts);
            }
         }catch(Exception ex){
             system.debug('$$$$$$$$$$ Exception : '+ex );
         }   
       }  
    
}