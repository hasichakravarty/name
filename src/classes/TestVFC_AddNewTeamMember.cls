@isTest
public  class TestVFC_AddNewTeamMember {

public static testmethod void insertteammember(){

         id pid=[select id from profile where name='ACN System Admin Read Only'].id;
          User u1 = new User(Alias = 'standt', Email='standarduser11@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = pid, 
            TimeZoneSidKey='America/Los_Angeles', UserName='test1234'+Math.random()+'@gmail.com', Geography__c = 'Growth',Market__c = 'ZA',Line_of_Business__c = 'Higher Ed');
            insert u1;
         system.runas(u1) {
         AccountTeamMember atm = TestDataFactory.createAccount();
         PageReference testPage = new pagereference('/apex/VFP_AddNewTeamMember');
         id atmid= atm.accountid;
         testPage.getParameters().put('AccountID',atmid);
         Test.setCurrentPage(testPage);
         ApexPages.StandardController sc = new ApexPages.standardController(atm);
         VFC_AddNewTeamMember atm1 = new VFC_AddNewTeamMember(sc);
         Test.starttest();
         atm1.doSaveTeamMember();
         atm1.SaveAndExitmessage();
         atm1.getItems();
         atm1.getpermissions();
        // user u = [select name from user where id =: UserInfo.getUserId()];
         atm1.selectedteammember = UserInfo.getUserId();
         atm1.accountaccess='Read';
         atm1.contactaccess='Read';
         atm1.opportunityaccess='Read';
         atm1.caseaccess='Read';
         atm1.getAccountTeamMembers();
         atm1.DeleteAndExitmessage();
         atm1.updatepermission();
         Test.stopTest();
         }
         

       }

}