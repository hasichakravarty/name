/*creating 2 contacts under accountcontact__c object as per  RD - 00319*/


 trigger lead_createContact on Lead (after Update) {
    List<ID> leadID = new List<ID>();
    //public static boolean stopRecursion = false;    
    List<Contact> contactList = new List<Contact>();
    List<AccountContact__c> acc_cont = new List<AccountContact__c>();
    //List<Task>task1 = new List<Task>();
    //List<AccountContactRole> AcctConrole = new List<AccountContactRole>(); 
    List<AccountContact__c> AcctConrole = new List<AccountContact__c>();
    List<Id> conId =new List<Id>();
    //public static boolean var=false;   
    List<Contact> conlist = new List<Contact>();
    List<Account> Acclist= new List<Account>();
    String SponsorType ;
    if(Trigger.isAfter){
     for(Lead l:Trigger.New){
    //acc_cont = [Select id, Account__c, Financially_Responsible__c,Contact__c from AccountContact__c where Account__c =:l.ConvertedAccountId and Contact__c =:l.ConvertedContactId ];
      if(l.isConverted && (trigger.oldMap.get(l.id).isConverted!=true)){ 
        if(trigger.oldMap.get(l.id).Sponsor_Type__c != 'Self'){
          System.Debug('@@@ when sponser!= self'+l+'-----'+l.Sponsor_Salutation__c);
          Contact contact2 = new Contact();  
          contact2.Salutation = l.Sponsor_Salutation__c;  
          contact2.FirstName = l.Sponsor_Sponsor__c;
          contact2.LastName = l.Sponsor_Name__c;
          contact2.AccountId = l.ConvertedAccountId;    
          contact2.MobilePhone = String.valueOf(l.Sponsor_Mobile__c);          
          contact2.HomePhone = String.valueOf(l.Sponsor_Phone__c); 
          
          contact2.Email = l.Sponsor_Email__c;            
         contact2.MailingCity = l.Sponsor_Address_City__c;          
         contact2.MailingStreet = l.Sponsor_Address_Street__c;          
          contact2.MailingState = l.Sponsor_Address_State_Province__c;          
          contact2.MailingCountry = l.Sponsor_Address_Country__c ;         
          contact2.MailingPostalcode = l.Sponsor_Address_ZIP_Postal_Code__c;
           contact2.isleadConvertedContact__c = true;
          
          contact2.Preferred_Method_of_Communication__c = l.Sponsor_Preferred_Method_of_Contact__c ;
          contactList.add(contact2);
           }
           
        else {
              createTask ct = new CreateTask();
                ct.createTaskOnLead(l.ConvertedAccountId);         
            }
             
                                 
        
          //To copy studentId from Lead to converted Account
          if(l.ConvertedAccountId!=null){
            SponsorType=l.Sponsor_Type__c;
            Account acc = new Account();
            acc.Id = l.ConvertedAccountId;
            acc.Pearson_Account_Number__c = trigger.oldMap.get(l.id).Pearson_ID_Number__c;
            AccList.add(Acc);
          }
           if(l.ConvertedContactId!=null){
               // AcctConrole.clear();
              
            AccountContact__c acc = new AccountContact__c();
            /*  if(acc_cont.size()>0){
                    acc_cont[0].Financially_Responsible__c = true;
                    AcctConrole.add(acc_cont[0]);
                }
                 else{ */
                    acc.Contact__c = l.ConvertedContactId;
                    acc.Account__c = l.ConvertedAccountId; 
                    acc.AccountRole__c = 'Student';
                     //acc.AccountRole__c = l.Sponsor_Type__c;
                    acc.Primary__c = true;
                    //acc_cont[0].Financially_Responsible__c = true;                    
                   AcctConrole.add(Acc);
                  //}
             }       
          
          if(l.ConvertedContactId!=null && trigger.oldMap.get(l.id).Sponsor_Type__c == 'Self'){
           AcctConrole.clear();
          AccountContact__c acc = new AccountContact__c();
            System.debug(acc_cont.size());           
            /* if(acc_cont.size()>0){
                acc_cont[0].Financially_Responsible__c = false;
                AcctConrole.add(acc_cont[0]);
            } 
            else{  */          
                acc.Contact__c = l.ConvertedContactId;
                acc.Account__c = l.ConvertedAccountId; 
                //acc.AccountRole__c = 'Sponsor';
                acc.AccountRole__c = l.Sponsor_Type__c;
                acc.Financially_Responsible__c = false;
                AcctConrole.add(Acc);  
            // }           
          } 
          
        }
         } 
                }
    
    System.debug('---UUU---'+Utility.stopRecursion+'---UUU--');
    if(contactList != null){                    //&& Utility.stopRecursion != True
        System.debug(contactList+'---RRRR----');
        Database.SaveResult[] lsr= Database.Insert(contactList,false);
        //Utility.stopRecursion = true;
         System.debug('---WWW---'+Utility.stopRecursion+'---WWW--');
         for(Integer i=0;i<lsr.size();i++){ 
          if(lsr.get(i).isSuccess()){
            ConId.add(lsr.get(i).getid());
          }
          }
        System.debug(lsr);                  
      }  
    
    if(ConId.size()>0){
      conlist = [Select id,AccountId from contact where ID IN:ConId];
     if(conlist.size()>0){
       for(contact c:conlist){
        AccountContact__c acc = new AccountContact__c();
        acc.Contact__c = c.Id;
        acc.Account__c = c.AccountId;
       // acc.AccountRole__c = 'Sponsor';
        system.debug('@@@SponsorType'+SponsorType);
        acc.AccountRole__c =SponsorType;
       //acc.AccountRole__c = l.Sponsor_Type__c;
        acc.Financially_Responsible__c = True;
        AcctConrole.add(Acc);
       }
     }
    } 
       
    if(AcctConrole!=null && AcctConrole.size()>0){
      List<AccountContact__c> accConRole = new List<AccountContact__c>();
      Map<Id,String> mapWithContactId = new Map<Id,String>();  
      for(AccountContact__c accCon : AcctConrole)
      {
        mapWithContactId.put(accCon.Contact__c,accCon.AccountRole__c); 
      }  
      //accConRole = [select Id from AccountContactRole where ContactId =: AcctConrole[0].ContactId And Role =: AcctConrole[0].Role limit 1];
      accConRole = [select Id,Contact__c from AccountContact__c where Contact__c =: mapWithContactId.Keyset() And AccountRole__c =: mapWithContactId.values() limit 1];
      if(accConRole.size()== 0 && acc_cont.size()== 0){     
        Insert AcctConrole;
       // update AcctConrole;
              
       }         
           
      if(acc_cont.size()>0 ){      //&& acc_cont[0].Id!=null
       System.debug(acc_cont[0].Id+'kkkkk'+AcctConrole);
      
       update AcctConrole;
       }
      }
      
        //if(!task1.isEmpty() && !stopRecursion ){
        //stopRecursion = true;
        //insert task1;
      //}
    if(AccList.size()>0){
      Update AccList;
      }
  
        
} 











/*trigger createContact on Lead (after Update) {
    List<ID> leadID = new List<ID>();
    public static boolean stopRecursion = false;    
    List<Contact> contactList = new List<Contact>();
    List<AccountContactRole> AcctConrole = new List<AccountContactRole>(); 
    List<Id> conId =new List<Id>();
    List<Contact> conlist = new List<Contact>();
    List<Account> Acclist= new List<Account>();
    if(Trigger.isAfter){
     for(Lead l:Trigger.New){
    
      if(l.isConverted && (trigger.oldMap.get(l.id).isConverted!=true)){ 
        if(trigger.oldMap.get(l.id).Sponsor_Type__c != 'Self'){
          Contact contact2 = new Contact();    
          contact2.FirstName = l.Sponsor_Sponsor__c;
          contact2.LastName = l.Sponsor_Name__c;
          contact2.AccountId = l.ConvertedAccountId;    
          contact2.Phone = String.valueOf(l.Sponsor_Mobile__c);
          contact2.Email = l.Sponsor_Email__c;
          contactList.add(contact2);
           }
         
          //To copy studentId from Lead to converted Account
          if(l.ConvertedAccountId!=null){
            Account acc = new Account();
            acc.Id = l.ConvertedAccountId;
            acc.Pearson_Account_Number__c = trigger.oldMap.get(l.id).Pearson_ID_Number__c;
            AccList.add(Acc);
          }
          
          if(l.ConvertedContactId!=null){
            AccountContactRole acc = new AccountContactRole();
            acc.ContactId = l.ConvertedContactId;
            acc.AccountId = l.ConvertedAccountId; 
            acc.Role = 'Student';
           AcctConrole.add(Acc);
          } 
          
          if(l.ConvertedContactId!=null && trigger.oldMap.get(l.id).Sponsor_Type__c == 'Self'){
            AccountContactRole acc = new AccountContactRole();
            acc.ContactId = l.ConvertedContactId;
            acc.AccountId = l.ConvertedAccountId; 
            acc.Role = 'Sponsor';
            acc.IsPrimary = True;
           AcctConrole.add(Acc);
          } 
         }
         }
       }
    
    if(contactList != null){
        Database.SaveResult[] lsr= Database.Insert(contactList,false);
         for(Integer i=0;i<lsr.size();i++){ 
          if(lsr.get(i).isSuccess()){
            ConId.add(lsr.get(i).getid());
          }}
      }  
    
    if(ConId.size()>0){
      conlist = [Select id,AccountId from contact where ID IN:ConId];
     if(conlist.size()>0){
       for(contact c:conlist){
        AccountContactRole acc = new AccountContactRole();
        acc.ContactId = c.Id;
        acc.AccountId = c.AccountId;
        acc.Role = 'Sponsor';
        acc.IsPrimary = True;
        AcctConrole.add(Acc);
       }
     }
    } 
       
    if(AcctConrole!=null && AcctConrole.size()>1){
      List<AccountContactRole> accConRole = new List<AccountContactRole>();
      Map<Id,String> mapWithContactId = new Map<Id,String>();  
      for(AccountContactRole accCon : AcctConrole)
      {
        mapWithContactId.put(accCon.ContactId,accCon.Role); 
      }  
      //accConRole = [select Id from AccountContactRole where ContactId =: AcctConrole[0].ContactId And Role =: AcctConrole[0].Role limit 1];
      accConRole = [select Id,ContactId from AccountContactRole where ContactId =: mapWithContactId.Keyset() And Role =: mapWithContactId.values() limit 1];
      
      if(accConRole.size()==0 ){   
      if(!stopRecursion )  {
      insert AcctConrole;
      stopRecursion = true;
      
      }
      
      //insert AcctConrole;
       }         
             
      }
      
    if(AccList.size()>0){
     if(!stopRecursion )  {
      Update AccList;
      stopRecursion = true;
      
      }
    
    
      //Update AccList;
      }
  
        
}*/