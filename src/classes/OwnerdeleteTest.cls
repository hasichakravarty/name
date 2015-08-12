/*******************************************************************************************************************
* Trigger Name  : Ownerdelete
* Version          : 1.0 
* Created Date     : 30 March 2015
* Function         : Test Class of the Ownerdelete
* Modification Log :
*
* Developer                                Date                    Description
* ------------------------------------------------------------------------------------------------------------------
*   Accenture IDC                          31/03/2015              Created Initial Version
*******************************************************************************************************************/

@isTest             
public class OwnerdeleteTest{
 static testMethod void myTest() { 
 
  Account acc = new Account();
     acc.Name = 'Test';
     acc.Line_of_Business__c= 'Higher Ed';
     acc.Geography__c = 'North America';
     acc.Market__c = 'US';
     acc.ShippingCity = 'Bangalore';
     acc.ShippingCountry = 'India';
     acc.ShippingPostalCode = '560068';
     acc.ShippingStreet = 'Bellandur';
     acc.ShippingState = 'Karnataka';
     insert acc; 
/*list<Account> accountdatalist = TestDataFactory.createAccount(3,'Learner');   
Insert accountdatalist;
Update accountdatalist;*/
     
    contact con = new contact();
     con.Lastname= 'testcon';
     con.Firstname= 'testcon1';
     con.MobilePhone = '9999';     
     insert con;
 Test.startTest();
  // for(Account newAcc : accountdatalist){
    AccountContact__c ac = new AccountContact__c();
     ac.Account__c = acc.id;
     ac.Contact__c = con.id;
     ac.Role_Detail__c = 'Director';
    insert ac;
    
   
 Office_Hours__c oh = new Office_Hours__c();
 oh.Account_Contact__c = ac.id;
 insert oh;
 
 Office_Hours__c oh1 = new Office_Hours__c();
 oh1.Account_Contact__c = ac.id;
 
 insert oh1;
 delete oh1;
 //}
 Test.stoptest();
 }
}