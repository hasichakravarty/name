Public without sharing Class PS_PreventChangingOwner
{
  Public static void PreventChangingAccountOwner(List<account>newAccounts,Map<id,account>oldMap)
  {
    System.debug('newAccounts'+newAccounts+'oldMap--->'+oldMap);  
    user u= [select id from user where name=: system.label.OwnerForAccount];
        for(account newacc :newAccounts)
    { 
        Account oldacc = oldMap.get(newacc.Id);
        if(oldacc.OwnerId ==u.id)
        {
            if(newacc.ownerid !=u.id)
            newacc.addError('Cannot change the owner if the current owner is Pearson');
        }
        System.debug('@@oldacc.OwnerId -->'+oldacc.OwnerId+ 'newacc.ownerid--> '+newacc.ownerid  );
     }
   }

   Public static void PreventChangingContactOwner(List<contact>newContacts,Map<id,contact>oldMap)
  {
    user u= [select id from user where name=: system.label.OwnerForAccount];
    for(contact newcon :newContacts)
    { 
        Contact oldcon = oldMap.get(newcon.Id);
        if(oldcon.OwnerId ==u.id)
        {
            if(newcon.ownerid !=u.id)
            newcon.addError('Cannot change the owner if the current owner is Pearson');
        }
     }
   }

   Public static void PreventChangingLeadOwner(List<Lead>newLeads,Map<id,Lead>oldMap)
  {

    String userid;
    userid = UserInfo.getUserId();
    userid = userid.substring(0,userid.length()-3);
    system.debug('##userid' + userid);

    String leadid;
    
      
    List<UserRecordAccess> leadaccess = new List<UserRecordAccess>();
    Boolean editaccess;
    system.debug('##editaccess' + editaccess);
    Lead oldlead;

    List<Id> leads = new List<Id> ();

    for(Lead newlead :newLeads)
    {
      oldlead = oldMap.get(newlead.Id);
      leadid = newLead.Id;
      leadid = leadid.substring(0,leadid.length()-3);
      leads.add(newLead.Id);
      system.debug('##LeadId' + leadid);
      system.debug('##Leads' + leads);
    }

    //check if user has edit access to record
    leadaccess = [SELECT RecordId, HasEditAccess FROM UserRecordAccess WHERE UserId =:userid AND RecordId=:leads];
    system.debug('##leadaccess' + leadaccess);

    for(UserRecordAccess ura :leadaccess)
    {
      editaccess = ura.HasEditAccess;
      system.debug('##editaccess' + editaccess);
    }

    list<Lead> leadlist =new list<Lead>();
    leadlist = [SELECT Id, OwnerId FROM Lead where Id IN :leads];
    system.debug('##leadlist' + leadlist);

    for(Lead newlead :newLeads)
    {
      if(oldlead.OwnerId != newlead.OwnerId)
      {
        system.debug('##oldlead Owner ID' + oldlead.OwnerId);
        system.debug('##newlead Owner ID' + newlead.OwnerId);
        
        if(editaccess==false)
        {
          system.debug('##editaccess' + editaccess);
          newlead.addError('You do not have the necessary permissions to transfer this lead.');
        }
      }
    }
  }
}