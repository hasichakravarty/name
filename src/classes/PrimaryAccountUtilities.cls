public with sharing class PrimaryAccountUtilities 
{
  public static void updateRoleInformationOnAccountContact(Contact[] lstOldContacts, Contact[] lstNewContacts, map<ID, Contact> NewMapIDContact, map<ID, Contact> oldMapIDContact)
  { 
    List <AccountContact__c> accountContactsToUpdate = new List<AccountContact__c>();
     Map<Id , List<AccountContact__c>> accContMap = new  Map<Id , List<AccountContact__c>>();
    
    for(AccountContact__c accContactObj : [select Id, Account_Name__c, Primary_Account__c, AccountRole__c, Role_Detail__c,Contact__c from AccountContact__c where Contact__c in :NewMapIDContact.keySet()]){
            if(accContMap.containsKey(accContactObj.Contact__c)){
                accContMap.get(accContactObj.Contact__c).add(accContactObj);
            }
            
            else{
                List<AccountContact__c> tempLst = new List<AccountContact__c>();
                tempLst.add(accContactObj);
                accContMap.put(accContactObj.Contact__c,tempLst);
            }
          
            
    }
    
    for(Contact con : lstNewContacts)
    {
      Contact oldContact = oldMapIDContact.get(con.Id);
      
      if((con.role__c != null && !con.Role__c.equals(oldContact.Role__c)) || (con.Role_Detail__c != null && !con.Role_Detail__c.equals(oldContact.Role_Detail__c)) || (con.AccountId != oldContact.AccountId))
      {
        //Contact c = [select Id, (select Id, Account_Name__c, Primary_Account__c, AccountRole__c, Role_Detail__c from Accounts__r) from Contact where Id = :con.Id];
        if(accContMap.containsKey(con.id)){
            for(AccountContact__c ac : accContMap.get(con.id))
            {
              if(ac.Primary_Account__c)
              {  
                Boolean changed = false;
                if(!con.Role__c.equals(ac.AccountRole__c))
                {
                  ac.AccountRole__c = con.Role__c;
                  changed = true;
                }
                if(con.Role_Detail__c != ac.Role_Detail__c)
                {
                  ac.Role_Detail__c = con.Role_Detail__c;
                  changed = true;
                }
            
                if(changed)
                {
                  accountContactsToUpdate.add(ac);
                  changed = false;
                }
              }
            }
        }
      }
    }
    if(!accountContactsToUpdate.isEmpty())
    {
      update accountContactsToUpdate;
    }
  }
  
  public static void updateRoleInformationOnContact(AccountContact__c[] lstOldAccountContacts, AccountContact__c[] lstNewAccountContacts, map<ID, AccountContact__c> mapNewIDAccountContact, map<ID, AccountContact__c> mapOldIDAccountContact)
  { 
    List <Contact> contactsToUpdate = new List<Contact>();
    Set<Id> contIdSet = new Set<Id>();
    
    for(AccountContact__c accConObj :lstNewAccountContacts){
        contIdSet.add(accConObj.Contact__c);
        
    }

    Map<Id,Contact> mapContact = new Map<Id,Contact>([SELECT id, Role__c, Role_Detail__c FROM Contact WHERE Id in:contIdSet]);
            
  
    for(AccountContact__c ac : lstNewAccountContacts)
    {
      if(ac.Primary_Account__c)
      {
        AccountContact__c oldAccountContact = mapOldIDAccountContact.get(ac.Id);
        if((ac.AccountRole__c != null && !ac.AccountRole__c.equals(oldAccountContact.AccountRole__c)) || (ac.Role_Detail__c != null && !ac.Role_Detail__c.equals(oldAccountContact.Role_Detail__c)))
        {
          boolean changed = false; 
          //Contact c = [SELECT id, Role__c, Role_Detail__c FROM Contact WHERE Id = : ac.Contact__c];
          if(mapContact.containsKey(ac.Contact__c)){
              if(!ac.AccountRole__c.equals(mapContact.get(ac.Contact__c).Role__c)) 
              {
                mapContact.get(ac.Contact__c).Role__c = ac.AccountRole__c;
                changed = true;
              }
              if(ac.Role_Detail__c != mapContact.get(ac.Contact__c).Role_Detail__c) 
              {
                mapContact.get(ac.Contact__c).Role_Detail__c = ac.Role_Detail__c;
                changed = true;
              }
              if(changed)
              {
                contactsToUpdate.add(mapContact.get(ac.Contact__c));
                changed = false;
              }
          }
        }
      }
    }
    if(!contactsToUpdate.isEmpty())
    {
      update contactsToUpdate;
    }
  }  

  public static void checkAccountContactExists(Contact[] lstNewContacts)
  {
    List <AccountContact__c> accountContactsToInsert = new List<AccountContact__c>();
    
    Map<Id , List<AccountContact__c>> accContMap = new  Map<Id , List<AccountContact__c>>();
    
    for(AccountContact__c accContactObj : [select Id, Account_Name__c, Account__c ,Primary_Account__c, AccountRole__c, Role_Detail__c,Contact__c from AccountContact__c where Contact__c in :lstNewContacts]){
            if(accContMap.containsKey(accContactObj.Contact__c)){
                accContMap.get(accContactObj.Contact__c).add(accContactObj);
            }
            
            else{
                List<AccountContact__c> tempLst = new List<AccountContact__c>();
                tempLst.add(accContactObj);
                accContMap.put(accContactObj.Contact__c,tempLst);
            }
          
            
    }
    
    
    
    for(Contact con : lstNewContacts)
    {
      //Contact c = [select Id, (select Id, Account_Name__c,Account__c , Primary_Account__c, AccountRole__c, Role_Detail__c, Account__c from Accounts__r) from Contact where Id = :con.Id];
      boolean foundAccount = false;
      if(accContMap.containsKey(con.Id)){
          for(AccountContact__c ac : accContMap.get(con.Id))
          {
            if(ac.Account__c == con.AccountId)
            {
              foundAccount = true;
              break;
            }
          }
      }
      if(!foundAccount  && con.Mobile_Last_Updated__c == null)
      {
        AccountContact__c newac = new AccountContact__c();
        newac.Account__c = con.AccountId;
        newac.Contact__c = con.Id;
        newac.AccountRole__c = con.Role__c;
        newac.Role_Detail__c = con.Role_Detail__c;
        accountContactsToInsert.add(newac);
      }
      foundAccount=false;
    }
    
    if(!accountContactsToInsert.isEmpty())
    {
      insert accountContactsToInsert;
    }
  }

}