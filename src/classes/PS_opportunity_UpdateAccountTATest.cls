@isTest
public with sharing class PS_opportunity_UpdateAccountTATest 
{
  static testMethod void verifyupdateadmin()
  {  
    List<User> usrLst = TestDataFactory.createUser(Userinfo.getProfileId());
    insert usrLst;
    System.runas(usrLst[0])
    {
      Account acc = (Account)TestClassAutomation.createSObject('Account');
      acc.Name = 'Test';
      insert acc; 
    
      Account_Correlation__C ac = new Account_Correlation__C(Account__C = acc.Id, External_ID_Name__c = 'eVision Learner Number', External_ID__c = 'External ID');
      insert ac; 
     
      contact con = (Contact)TestClassAutomation.createSObject('Contact');
      con.Lastname= 'testcon';
      con.Firstname= 'testcon1';
      con.MobilePhone = '9999';     
      insert con;     
    
      Opportunity opp = (Opportunity)TestClassAutomation.createSObject('Opportunity');
      opp.AccountId = acc.Id;
      opp.CurrencyIsoCode = 'GBP';
      opp.Lost_Reason_Other__c = 'XXX';
      opp.Academic_Vetting_Status__c = 'XXXXX';
      opp.Type = 'New Business';
      opp.StageName = 'Negotiation';
      opp.Qualification_Campus__c = acc.id;
      insert opp;
      List<Opportunity> oppty = new List<Opportunity>();
      oppty.add(opp);
      
      AccountTeamMember accountTeamMember = new AccountTeamMember();
      accountTeamMember.TeamMemberRole='Account Administrator';
      accountTeamMember.AccountId= acc.Id;
      accountTeamMember.userId = usrLst[0].id;
      insert accountTeamMember;
             
      test.startTest();
      PS_opportunity_UpdateAccountTeamAdmin.updateadmin(oppty);
      opp.Type = 'Amendment';
      PS_opportunity_UpdateAccountTeamAdmin.updateadmin(oppty);
      
      test.stopTest();
    }
  }
}