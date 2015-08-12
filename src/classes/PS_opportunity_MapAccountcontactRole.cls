/*--------------------------------------------------------------------------------------------------------------------------------------------------------
   Name:            PS_opportunity_MapAccountcontactRole.cls 
   Description:    MapAccountcontactRole 
   
   Date             Version         Author                             Summary of Changes 
   -----------      ----------      -----------------    ---------------------------------------------------------------------------------------------------                 
  04/2015            1.0             karthik.A.S                         Initial Release 
----------------- ------------------------------------------------------------------------------------------------------------------------------------------- */

public without sharing class PS_opportunity_MapAccountcontactRole{

public static void MapAccountcontactRole(list<Opportunity> oppty)
{
  List<opportunity> opp=[select Id ,AccountId from opportunity where id in:oppty and Mass_Opportunity_Generation_Indicator__c=false]; 
    
  List<AccountContact__c> acc = new List<AccountContact__c>();
  
  List<OpportunityContactRole> ContactRoles = new List<OpportunityContactRole>();
  
  Map<Id,Id> accountopptyIds = new Map<Id,Id>();
  
  
  for(Opportunity o:opp){

    accountopptyIds.put(o.AccountId,o.Id);
  }
  
  acc = [SELECT Contact__c,Account__c,Primary__c,Financially_Responsible__c from AccountContact__c where Account__c IN: accountopptyIds.keySet()];
 
  for(AccountContact__c a:acc){
   
   OpportunityContactRole oc = new OpportunityContactRole();
   oc.ContactId = a.Contact__c;
   oc.opportunityId = accountopptyIds.get(a.Account__c);
   oc.IsPrimary = a.Primary__c;
   
   system.debug('oc.IsPrimary..'+oc.IsPrimary);
   system.debug('a.IsPrimary..'+a.Primary__c);

   if(a.Financially_Responsible__c) oc.Role = 'Primary Sales Contact';

   if(a.Primary__c) oc.Role = 'Business User';

   ContactRoles.add(oc);

   system.debug('ContactRoles..' + ContactRoles);
  }
 
  for(OpportunityContactRole ocr :ContactRoles ){
     system.debug('ocr.isprimary : '+ocr.IsPrimary);
  
  }
 
  if(ContactRoles.size()>0){

    List<OpportunityContactRole> oldContactRoles = [SELECT Id FROM OpportunityContactRole WHERE opportunityId IN: accountopptyIds.values()];

    if(oldContactRoles !=null && oldContactRoles.size() >0 ) delete oldContactRoles;

    Insert ContactRoles;
     
    system.debug('ContactRoles1...'+ContactRoles);
  }
  

}

}