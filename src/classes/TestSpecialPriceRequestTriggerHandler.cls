/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest(SeeAllData=true)
private class TestSpecialPriceRequestTriggerHandler {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        User user = new User();
        user.ProfileID = [Select Id From Profile Where Name='System Administrator'].id;
        user.EmailEncodingKey = 'ISO-8859-1';
        user.LanguageLocaleKey = 'en_US';
        user.TimeZoneSidKey = 'America/New_York';
        user.LocaleSidKey = 'en_US';
        user.FirstName = 'first';
        user.LastName = 'last';
        user.Username = 'test@test54.com';   
        user.CommunityNickname = 'testUser123';
        user.Alias = 't1';
        user.Email = 'no@email.com1';
        user.IsActive = true;
        user.Job_Function__c = 'Learning Technology Specialist';
        insert user;
        
        
        list<Account> lstAccount = new list<Account>();
        Pricebook2  standardPb = [select id, name, isActive from Pricebook2 where IsStandard = true limit 1];
        Account objacc = new Account(Name = 'Account');
        lstAccount.add(objacc);
        Account objacc1 = new Account(Name = 'Account 2');
        lstAccount.add(objacc1);
        insert lstAccount;
        
       list<Relationship__c> lstRelation = new list<Relationship__c>();
        
      Relationship__c objr= new Relationship__c(Influence_Type__c='Influences',Account__c = objacc.id,Related_To__c = objacc1.id);
      lstRelation.add(objr);
      insert lstRelation;
        
        
        Pricebook2 pbk1 = new Pricebook2 ();
		pbk1.Name='Test Pricebook Entry 1';
		pbk1.Description='Test Pricebook Entry 1';
		pbk1.isActive=true;
		insert pbk1;
		Product2 prd1 = new Product2 ();
		prd1.Name='Test Product Entry 1';
		prd1.Description='Test Product Entry 1';
		prd1.productCode = 'ABC';
		prd1.isActive = true;
		insert prd1;
		  
		PricebookEntry pbe1 = new PricebookEntry ();
	    pbe1.Product2ID=prd1.id;
	    pbe1.Pricebook2ID=standardPb.id;
	    pbe1.UnitPrice=50;
	    pbe1.isActive=true;
	    insert pbe1;
        
        list<Opportunity> lstOpp = new list<Opportunity>();
        Opportunity  objopp = new Opportunity(Name = 'Opp Name',AccountId = objacc.id,StageName='Prospecting',Type='Rollover',
        							CloseDate = system.today(),Selling_Period__c = 'Fall 2017',ForecastCategoryName='Commit');
        lstOpp.add(objOpp);
        
        insert lstOpp;
        
        OpportunityLineItem objoli = new OpportunityLineItem(OpportunityId= objOpp.id,PricebookEntryId=pbe1.Id,Quantity = 1,UnitPrice=200);
        insert objoli;
        
        list<OpportunityTeamMember> lstTeam = new list<OpportunityTeamMember>();

        OpportunityTeamMember objteam = new OpportunityTeamMember(Userid = user.id,TeamMemberRole = 'Support',OpportunityId = objOpp.id);
        lstTeam.add(objteam);
        insert lstTeam;
        
        
        list<Special_Price_Request__c> lstspecial = new list<Special_Price_Request__c>();
        Special_Price_Request__c objspecial = new Special_Price_Request__c(Opportunity__c = objOpp.id,Request_Type__c = 'Valuepack with MyLab / Mastering Access Code',Status__c = 'New',
        							included_the_Account_Numbers_for_every_S__c = 'No',Is_this_a_Renewal__c = 'No');
        lstspecial.add(objspecial);
        insert lstspecial;
        
        Test.startTest();
        System.RunAs(user){
        lstspecial.clear();
        objspecial.Status__c = 'Completed';
        lstspecial.add(objspecial);
        try{
         update lstspecial;
        } catch(exception e){
            system.debug('special price error :'+e);
        }
        Test.stopTest();
        }
        
 }
    
    static testMethod void myUnitTest1(){
        
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        System.runAs ( thisUser ){

        User user = new User();
        user.ProfileID = [Select Id From Profile Where Name='System Administrator'].id;
        user.EmailEncodingKey = 'ISO-8859-1';
        user.LanguageLocaleKey = 'en_US';
        user.TimeZoneSidKey = 'America/New_York';
        user.LocaleSidKey = 'en_US';
        user.FirstName = 'first';
        user.LastName = 'last';
        user.Username = 'test@test54.com';   
        user.CommunityNickname = 'testUser123';
        user.Alias = 't1';
        user.Email = 'no@email.com1';
        user.IsActive = true;
        user.Job_Function__c = 'Learning Technology Specialist';
        insert user;
       
        
        list<Account> lstAccount = new list<Account>();
        Pricebook2  standardPb = [select id, name, isActive from Pricebook2 where IsStandard = true limit 1];
        Account objacc = new Account(Name = 'Account');
        lstAccount.add(objacc);
        Account objacc1 = new Account(Name = 'Account 2');
        lstAccount.add(objacc1);
        insert lstAccount;
        
       //list<Relationship__c> lstRelation = new list<Relationship__c>();
        
      //Relationship__c objr= new Relationship__c(Influence_Type__c='Influences',Account__c = objacc.id,Related_To__c = objacc1.id);
      //lstRelation.add(objr);
      //insert lstRelation;
        
        
        Pricebook2 pbk1 = new Pricebook2 ();
		pbk1.Name='Test Pricebook Entry 1';
		pbk1.Description='Test Pricebook Entry 1';
		pbk1.isActive=true;
		insert pbk1;
		Product2 prd1 = new Product2 ();
		prd1.Name='Test Product Entry 1';
		prd1.Description='Test Product Entry 1';
		prd1.productCode = 'ABC';
		prd1.isActive = true;
		insert prd1;
		  
		PricebookEntry pbe1 = new PricebookEntry ();
	    pbe1.Product2ID=prd1.id;
	    pbe1.Pricebook2ID=standardPb.id;
	    pbe1.UnitPrice=50;
	    pbe1.isActive=true;
	    insert pbe1;
        
        list<Opportunity> lstOpp = new list<Opportunity>();
        Opportunity  objopp = new Opportunity(Name = 'Opp Name',AccountId = objacc.id,StageName='Prospecting',Type='Rollover',
        							CloseDate = system.today(),Selling_Period__c = 'Fall 2017',ForecastCategoryName='Commit');
        lstOpp.add(objOpp);
        
        insert lstOpp;
        
        OpportunityLineItem objoli = new OpportunityLineItem(OpportunityId= objOpp.id,PricebookEntryId=pbe1.Id,Quantity = 1,UnitPrice=200);
        insert objoli;
        
        list<OpportunityTeamMember> lstTeam = new list<OpportunityTeamMember>();

        OpportunityTeamMember objteam = new OpportunityTeamMember(Userid = user.id,TeamMemberRole = 'Support',OpportunityId = objOpp.id);
        lstTeam.add(objteam);
        insert lstTeam;
        
        
        list<Special_Price_Request__c> lstspecial = new list<Special_Price_Request__c>();
        Special_Price_Request__c objspecial = new Special_Price_Request__c(Opportunity__c = objOpp.id,Request_Type__c = 'Valuepack with MyLab / Mastering Access Code',Status__c = 'New',
        							included_the_Account_Numbers_for_every_S__c = 'No',Is_this_a_Renewal__c = 'No');
        lstspecial.add(objspecial);
        insert lstspecial;
        
        System.RunAs(user){
         
        Group Queue = [Select Id from Group where type ='Queue' and DeveloperName = 'Special_Pricing_Monitoring_Group' Limit 1];
        GroupMember member = new GroupMember(GroupId = Queue.Id, UserOrGroupId = user.ID);
        
        insert member;
        
        Test.startTest();
        
        lstspecial.clear();
        objspecial.Status__c = 'Completed';
        lstspecial.add(objspecial);
        try{
         update lstspecial;
        } catch(exception e){
            system.debug('special price error :'+e);
        }
        Test.stopTest();
        }
        }
    } 
}