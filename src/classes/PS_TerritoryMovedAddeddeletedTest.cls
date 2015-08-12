/* Test Class to Cover PS_TerritoryMovedAddeddeleted Trigger & its Handler, PS_UserAdderorRemovedNotificationTrigger and its handler
 and cdsOpportunityClosingNotification() of Opportunity Trigger and Handler.
 Author : Accenture IDC */


@isTest
private class PS_TerritoryMovedAddeddeletedTest
{
    static testMethod void myUnitTest()
    {
        
         //query to get the profile of sales user OneCRM
     Profile pfile = [Select Id,name from profile where name = 'Pearson Sales User OneCRM'];
     //UserRole rol = [Select Id,name from UserRole where name = 'Customer Digital Success Agent'];
     User us = [select Market__c,Line_of_Business__c,Business_Unit__c from User where id =:UserInfo.getUserId() limit 1];
      //code for creating an User
      User u = new User();
      u.LastName = 'territoryuser';
      u.alias = 'terrusr'; 
      u.Email = 'territoryuser@gmail.com';  
      u.Username='territoryuser@gmail.com';
     // u.UserRole = rol;
      u.LanguageLocaleKey='en_US'; 
      u.TimeZoneSidKey='America/New_York';
      u.Price_List__c='Humanities & Social Science';
      u.LocaleSidKey='en_US';
      u.EmailEncodingKey='ISO-8859-1';
      u.ProfileId = pfile.id;       // '00eg0000000M99E';    currently hardcoded  for admin         
      u.Geography__c = 'Growth';
      u.Market__c = 'ZA';
      u.Business_Unit__c = 'US Field Sales';
      u.Line_of_Business__c = 'Higher Ed';
      insert u;
      test.StartTest();
      //Territory2Model tm = [select id from Territory2Model limit 1]; 
     // Territory2Model t2m = new Territory2Model (Name = 'TestModel', DeveloperName ='TestModel');
     // insert t2m;
      Territory2 tr0 = TestDataFactory.createTerritory();
      tr0.Territory_Code__c = 'AAA';
      insert tr0;
     // List<Territory2> childTerritoryList = new List<Territory2>();
      Territory2 tr = new Territory2();
      tr.DeveloperName = 'TestTerritory';
      tr.Name = 'TestTerritory';
     tr.Territory2ModelId = tr0.Territory2ModelId;
     tr.Territory2TypeId = tr0.Territory2TypeId;
      tr.ParentTerritory2Id = tr0.id;
      tr.Territory_Code__c = 'XXX';
      insert tr;
      
      Territory2 tr1 = new Territory2();
      tr1.DeveloperName = 'TestTerritory1';
      tr1.Name = 'TestTerritory1';
     tr1.Territory2ModelId = tr0.Territory2ModelId;
     tr1.Territory2TypeId = tr0.Territory2TypeId;
      tr1.ParentTerritory2Id = tr0.Id;
      tr1.Territory_Code__c = 'YYY';
      insert tr1;
     
      tr1.ParentTerritory2Id = tr.Id;
      update tr1;
      Territory2 tr2 = new Territory2();
      tr2.DeveloperName = 'TestTerritory2';
       tr2.Name = 'TestTerritory2';
      tr2.Territory2ModelId = tr0.Territory2ModelId;
     tr2.Territory2TypeId = tr0.Territory2TypeId;
      tr2.ParentTerritory2Id = tr.Id;
      tr2.Territory_Code__c = 'ZZZ';
      insert tr2;

     UserTerritory2Association ut2aP = new UserTerritory2Association();
      ut2aP.Territory2Id = tr.Id;   
      ut2aP.UserId = u.id;
      ut2aP.RoleInTerritory2 = 'District Manager';
      insert ut2aP;
      UserTerritory2Association ut2a = new UserTerritory2Association();
      ut2a.Territory2Id = tr1.Id;   
      ut2a.UserId = u.id;
      ut2a.RoleInTerritory2 = 'Customer Digital Success Agent';
      insert ut2a;
      UserTerritory2Association ut2a2 = new UserTerritory2Association();
      ut2a2.Territory2Id = tr2.Id;   
      ut2a2.UserId = u.id;
      ut2a2.RoleInTerritory2 = 'Sales Representative';
      insert ut2a2;
       //delete ut2a;
       
       // Code to Cover cdsOpportunityClosingNotification in Opportunity Trigger.
      system.RunAs(us){
        createAcc();
      
      delete ut2a;
      }
     test.StopTest();
     
     
      
    }
    @testSetup static void setup() {
        // Create common test accounts
        Account testAcct = new Account(Name = 'TestAcct', Geography__c = 'North America', Region__c = 'United States',Line_of_Business__c ='Schools', Market__c = 'US',BillingCountry = 'Australia',BillingState = 'Victoria',BillingCountryCode = 'AU',BillingStateCode = 'VIC',ShippingCountry = 'Australia',ShippingState = 'Victoria',ShippingCountryCode = 'AU',ShippingStateCode = 'VIC',Territory_Code_s__c = 'YYY');
       
        insert testAcct;       
    }
    public static void createAcc(){
    
    Account acct = [SELECT Id,Territory_Code_s__c FROM Account WHERE Name='TestAcct' LIMIT 1];
      
    
    Opportunity sOpportunity          = (Opportunity)TestClassAutomation.createSObject('Opportunity');
    sOpportunity.AccountId            = acct.Id;
    
    sOpportunity.RecordTypeId         = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('B2B').getRecordTypeId();
    sOpportunity.Digital_Indicator__c = true;
    insert sOpportunity;
   
    sOpportunity.StageName            = 'Closed';
    update sOpportunity;
      acct.Territory_Code_s__c = 'ZZZ';
    update acct;
    }
}