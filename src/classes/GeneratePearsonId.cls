public class GeneratePearsonId
{
    public static void GenerateRandomPearsonID(List<Account> listAccount)
    {
        Set<Id> UserIds = new Set<Id>();
         List<Id> UserId = new List<Id>();
         List<Account> AccList = new List<Account>();
         List<Account> AccountList = new List<Account>();
         List<Account> AccountList1 = new List<Account>();
         Set<id> AccountId = new Set<id>();
         List<id> AccountIds = new List<id>();
         Map<id,List<Account>> UserAccountmap = new Map<Id,List<Account>>();
         List<User> Userlist = new List<User>();
         List<User> Userlist1 = new List<User>();
         //List<Account> accstudentIdlist = [Select Pearson_Account_Number__c from Account];
         //List<Lead> leadstudentIdlist = [Select Pearson_ID_Number__c from Lead];
         List<String> StudentIdlist = new List<String>();
          
         /* for(account a:accstudentIdlist){
            StudentIdlist.add(a.Pearson_Account_Number__c);
          }
          
          for(lead l:leadstudentIdlist){
            StudentIdlist.add(l.Pearson_ID_Number__c);
          }
         
                
               
          if(UserIds.size()>0){
            UserId.addall(UserIds);
            AccList = [Select Id,OwnerId from Account where OwnerId IN:UserId];
           
          }
          
          if(AccList.size()>0){
           for(Account a: Acclist){
            if(UserAccountmap.containskey(a.OwnerID)){
             UserAccountmap.get(a.OwnerID).add(a);
            }
            else{
             UserAccountmap.put(a.ownerId,new List<Account>{a}); 
             } 
           }
          }
          
          if(UserId.size()>0){
           Userlist = [Select Id,name from User where Id In:UserId];
          }
          
            List<Account> acc1 = new List<Account>();
        
          if(Userlist.size()>0){
               for(User U:Userlist){
                //Account acc1 = new Account();
                    User u1 = new User();
                    u1.Id = U.Id;
                    if(!UserAccountmap.isEmpty() && 
                       UserAccountmap.get(U.Id) != null && 
                       UserAccountmap.size()>0 && U.Id != null && 
                       UserAccountmap.keyset()!=null && 
                       UserAccountmap.values()!=null){
                            acc1.addall(UserAccountmap.get(U.Id));
                    }
                    if(Acc1.size()>0){
                        u1.Account_Count__c = acc1.size();
                    }
                    UserList1.add(u1);
               }
          }*/
        system.debug('############entered generatePearsonID');
            for(Account acc : listAccount) 
                AccountIds.add(acc.id);
        
          if(AccountIds.size()>0){
               Accountlist = [Select id,Pearson_Account_Number__c from Account where Id In:AccountIds];
          } 
            
          
          //For StudentId generation
          if(AccountList.size()>0){
             for(Account a:AccountList){
               Account a1 = new Account();
               a1.id = a.Id;
               
           final String chars = '123456789BCDFGHJKLMNPQRSTVWXYZ'; 
            String randStr = '';
             while (randStr.length() < 8) {
               Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), 30);
               randStr += chars.substring(idx, idx+1);
             }  
             
            final String chars2 = '123456789';
             String randStr2 = '';
             while (randStr2.length() < 1) {
               Integer idx2 = Math.mod(Math.abs(Crypto.getRandomInteger()), 9);
               randStr2 += chars2.substring(idx2, idx2+1);
             }
            string str = randstr+randStr2;
                   
              system.debug('$$$$$$$$$$$$$$$$$$$$$$$$str...'+str);
              
            Boolean flag= false;
             for(string s:StudentIdlist){
              if(s==str){
               system.debug('s...'+s);
               system.debug('str1...'+s);
                flag = true;
                break;
               }}
              if(flag!=true){
              system.debug('#####################str2..'+str);
                a1.Pearson_Account_Number__c = str;
                StudentIdlist.add(str);
                }
              
                
              AccountList1.add(a1); 
               
          }}
          
          if(UserList1.size()>0){  
            Update UserList1;  }
          
          if(AccountList1.size()>0){
              system.debug('###################updating');
             Update AccountList1;
             }
       }     
}