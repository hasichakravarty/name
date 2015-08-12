@isTest 

public class PS_oneCRMProductSelectorPermissionTest{
static testMethod void checkPermission()
{
  List<Opportunity> listWithOpportunity = new List<Opportunity>();
  List<User> listWithUser = new List<User>();
  listWithUser  = TestDataFactory.createUser([select Id from Profile where Name =: 'System Administrator'].Id,1);
  test.StartTest();
  listWithOpportunity = TestDataFactory.createnewopportnity(1);
  
  listWithOpportunity[0].OwnerId = UserInfo.getUserId(); 
  update listWithOpportunity;
  
  if(listWithUser != null && !listWithUser.isEmpty())
    {
        //listWithUser[0].Price_List__c = 'Math & Science';
        insert listWithUser;
    }
  System.debug(listWithUser[0].Price_List__c);
  test.StopTest();
  System.runAs(listWithUser[0])
  {
      System.debug(listWithUser[0].Price_List__c);
      PS_oneCRMProductSelectorPermission callPermissionMethods = new PS_oneCRMProductSelectorPermission();
      PS_oneCRMProductSelectorPermission.checkPermission(listWithOpportunity[0].Id);
  }
}
static testMethod void checkPermissionPrice()
{
  List<Opportunity> listWithOpportunity = new List<Opportunity>();  
  List<User> listWithUser = new List<User>();
  List<User> listWithUserReadOnly = new List<User>();
  List<Special_Price_Request__c> listWithSpecialPriceRequest = new List<Special_Price_Request__c>();
  Special_Price_Request__c newSpecialPriceRequest = new Special_Price_Request__c();
  listWithUser  = TestDataFactory.createUser([select Id from Profile where Name =: 'System Administrator'].Id,1);
  listWithUserReadOnly = TestDataFactory.createUser([select Id from Profile where Name =: 'Read Only'].Id,1);
  String errorString = '';
  ID opptyId;
  ID opptyProdId;
  test.StartTest();
  if(listWithUser != null && !listWithUser.isEmpty())
    {
       listWithUser[0].Price_List__c = '';
       insert listWithUser;
    }
  listWithOpportunity = TestDataFactory.createnewopportnity(1);
  if(listWithUserReadOnly != null && !listWithUserReadOnly .isEmpty())
    {
       insert listWithUserReadOnly;
       //listWithOpportunity[0].OwnerId = listWithUserReadOnly[0].Id;
    }
  opptyId = listWithOpportunity[0].Id;
  opptyProdId = listWithOpportunity[0].Id;
  newSpecialPriceRequest.Status__c = 'New';
  newSpecialPriceRequest.Opportunity__c = listWithOpportunity[0].Id;
  listWithSpecialPriceRequest.add(newSpecialPriceRequest);
  insert listWithSpecialPriceRequest;
  test.StopTest();
  System.runAs(listWithUserReadOnly[0])
  {
      PS_oneCRMProductSelectorPermission callPermissionMethods = new PS_oneCRMProductSelectorPermission();
      PS_oneCRMProductSelectorPermission.checkPermission(listWithOpportunity[0].Id);
  }
}
}