// RD: 652 | Territory Management | Pooja | 3rd June
public class PS_OpportunityB2BNAActions {
    
    // Add chatter feed on User who is assigned to Territory( as a Customer Digital Success Agent) shud be associated to Opportunity
    public static void cdsOpportunityClosingNotification(List<Opportunity> opList){    
        
        //Set<Id> accountIdSet = new Set<Id>();
        Map<Id,Opportunity> accOppMap = new Map<Id,Opportunity>();
        for(Opportunity op: opList){
                //accountIdSet.add(op.AccountId);
                accOppMap.put(op.AccountId,op);
        }
        List<Account> acList = [select Id,name,Territory_Code_s__c from Account where Id in: accOppMap.KeySet()];
        
        system.debug('####!@#$---'+acList);
        if(acList != null){
            Set<String> newtrStr = new Set<String>();
            Map<String,List<Account>> AddCodeAccountmap = new Map<String,List<Account>>();
            Map<String,Id> territoryIDCOdeMap = new Map<String,Id>();
            for(Account ac: acList){
                if(ac.Territory_Code_s__c != null){
                    system.debug('ac.Territory_Code_s__c------'+ac.Territory_Code_s__c);
                    for(String s: ac.Territory_Code_s__c.split(',')){
                        newtrStr.add(s);
                    }
                }
            
            system.debug('newtrStr---'+newtrStr);
            if(newtrStr != null && newtrStr.size() >0){
                for(String ns : newtrStr){
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
        List<UserTerritory2Association> AssignedUsersToTerritory = new List<UserTerritory2Association>();
        //Map of aready assigned user's record with there territory Id.
        Map<String,List<UserTerritory2Association>> AssignedUsersToTerritoryMap = new Map<String,List<UserTerritory2Association>>();
        If(AddCodeAccountmap != null){
            AssignedUsersToTerritory = [select id,Territory2.Territory_Code__c,Territory2Id,Territory2.Name,Territory2.Territory2ModelId,Territory2.Territory2Model.Name, UserId ,User.Name,User.isActive, RoleInTerritory2 from UserTerritory2Association where RoleInTerritory2 = 'Customer Digital Success Agent' AND Territory2.Territory_Code__c IN: AddCodeAccountmap.keyset()];
        }
        system.debug('AssignedUsersToTerritory-----'+AssignedUsersToTerritory);
        if(AssignedUsersToTerritory != null && AssignedUsersToTerritory.size()>0){
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
            useradmin = [select Id, Name,Email,UserRoleId,UserRole.Name from User where UserRole.Name = 'NA Sales and Territory Admins' AND Market__c ='US' limit 1];
        }catch(Exception e){
            system.debug('No Admin Exist');
        }
        system.debug('AssignedUsersToTerritoryMap-----'+AssignedUsersToTerritoryMap);
        String msg = '';
        List<FeedItem> fiList = new List<FeedItem>();
        if(AssignedUsersToTerritoryMap.KeySet() != null){
            for(String st : AssignedUsersToTerritoryMap.KeySet()){
                system.debug('st----'+st);
                if(AssignedUsersToTerritoryMap.get(st) != null && AssignedUsersToTerritoryMap.get(st).size()>0){
                    for(UserTerritory2Association uat : AssignedUsersToTerritoryMap.get(st)){
                        if(uat.User.isActive == true){
                            system.debug('uat----'+uat);
                            FeedItem post = new FeedItem();
                            post.ParentId = uat.UserId; 
                            msg = 'Attention '+ uat.User.Name+', \n You are receiving this notification because you are assigned as the '+uat.RoleInTerritory2 + ' associated to '+uat.Territory2.Name+'.';
                            system.debug('AddCodeAccountmap -----'+AddCodeAccountmap);
                            if(AddCodeAccountmap != null && AddCodeAccountmap.containsKey(st)){
                                for(Account ac : AddCodeAccountmap.get(st)){
                                    String fullRecordURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + accOppMap.get(ac.id).Id + ' ';
                                    msg += '\n \n Please note that the following Opportunity, '+fullRecordURL+' has recently been set to “Closed” and has associated digital products.  Ensure the following measures are taken: ';
                                    msg += '\n \n 1.Click the link provided above \n 2.Navigate to the Products Related List on the Opportunity \n 3.Review the products associated to our customer associated order \n 4.Gather any related collateral in preparation for discussing support with the associated contact \n 5. Follow-up with the appropriate contact(s) in a timely manner in regard to the many support services Pearson can provide to ensure there continued success with our technology products.';
                                    if(useradmin != null){
                                        msg += '\n \n If you believe this digital opportunity closure notification is incorrect or that you are receiving this message in error, please contact your Territory Administrator, '+useradmin.Name+' at '+ useradmin.Email;
                                    }
                                    post.Body = msg;
                                    post.CreatedDate = System.now();
                                    system.Debug('Post feed---'+post);
                                    fiList.add(post);
                                }   
                            }
                        }
                    }
                }
            }
        }
        system.debug('fiList---->'+fiList);
        if(fiList.size() > 0 && fiList.size() < 150){
            insert fiList;
        }
    } }
    
}