/*******************************************************************************************************************
* Apex Class Name   :NewAccountRequesttest
* Created Date      : 5 MAY 2014
* Description       : Test class for NewAccountRequests class
*******************************************************************************************************************/


@isTest(SeeAllData = true)
Private class NewAccountRequesttest
{
public Static testMethod void testsave()//Testmethod to test NewAccountRequesttest Class
{
User u = [select Id, username from User where Id = :UserInfo.getUserId() limit 1];  
try{
System.runas(u){
Lead testLead = [Select id from Lead LIMIT 1];
ApexPages.StandardController stdLead = new ApexPages.StandardController(testLead);
NewAccountRequest cont = new NewAccountRequest(stdLead);
PageReference testPage = page.NewAccountRequestPage;
Test.setCurrentPage(testPage);
Test.StartTest();
cont.Save();
}
Test.StopTest(); 
}
catch(exception e)
{
System.debug(+e);
}
}

public Static testMethod void testsave_Positive()//Testmethod to test NewAccountRequesttest Class
{
User u = [select Id, username from User where Id = :UserInfo.getUserId() limit 1];  
try {
System.runas(u){
Lead testLead = new Lead(Company = 'TestC',Phone = '+123456780',Home_Phone__c = '0987654321',Other_Phone__c ='231456721',Primary_Email__c = 'test@tt.com',Secondary_Email__c = 'testSec@tt.com',LastName = 'testName',Status ='open');
//insert testLead;
ApexPages.StandardController stdLead = new ApexPages.StandardController(testLead);
NewAccountRequest cont = new NewAccountRequest(stdLead);
PageReference testPage = page.NewAccountRequestPage;
Test.setCurrentPage(testPage);
cont.Leadvalues = testLead;
//cont.Leadvalues.Phone =
Test.StartTest();
cont.Save();
}
Test.StopTest();
}
catch(exception e)
{
System.debug(+e);
}
}
}