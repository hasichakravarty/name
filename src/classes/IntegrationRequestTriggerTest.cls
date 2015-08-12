/*******************************************************************************************************************
* Apex Class Name  : IntegrationRequestTriggerTest
* Version          : 1.0 
* Created Date     : 24 April 2015
* Function         : Test Class of the Integration Request Trigger 
* Modification Log :
*
* Developer                   Date                    Description
* ------------------------------------------------------------------------------------------------------------------
*                         24/04/2015              Created Initial Version of AccountContactSyncTestClass
*******************************************************************************************************************/
@isTest  
public with sharing class IntegrationRequestTriggerTest 
{
  /*************************************************************************************************************
  * Name        : verifyInsert
  * Description : Verify the insert of Integration Request Objects         
  * Input       : 
  * Output      : 
  *************************************************************************************************************/
  static testMethod void verifyInsert()
  {
  	test.startTest();
    List<Account> generatedAccounts = generateTestAccounts(1);	
    List<Integration_Request__c> generatedIntegrationRequests = generateIntegrationRequests(1, generatedAccounts.get(0).Id );
    List<Integration_Request__c> recordsInserted = [SELECT id from Integration_Request__c];
    System.AssertEquals(recordsInserted.size(), generatedIntegrationRequests.size(), 'The IntegrationRequests were not inserted into the database');
    test.stopTest();
  }
  
  /*************************************************************************************************************
  * Name        : verifyUpdate
  * Description : Verify the updating of Integration Request Objects         
  * Input       : 
  * Output      : 
  *************************************************************************************************************/
  static testMethod void verifyUpdate()
  {
  	test.startTest();
    List<Account> generatedAccounts = generateTestAccounts(1);	
    List<Integration_Request__c> generatedIntegrationRequests = generateIntegrationRequests(2, generatedAccounts.get(0).Id );
    List<Integration_Request__c> recordsInserted = [SELECT id from Integration_Request__c];
    System.AssertEquals(recordsInserted.size(), generatedIntegrationRequests.size(), 'The IntegrationRequests were not inserted into the database');
    generatedIntegrationRequests.get(0).Status__c = 'Completed';
    update generatedIntegrationRequests.get(0);
    List<Integration_Request__c> recordsUpdated = [SELECT Status__c from Integration_Request__c];
    System.AssertEquals(recordsUpdated.get(0).Status__c, 'Completed', 'The IntegrationRequests were not updated');
    generatedIntegrationRequests.get(0).Status__c = 'Functional Error';
    update generatedIntegrationRequests.get(0);
    generatedIntegrationRequests.get(0).Status__c = 'Technical Error';
    update generatedIntegrationRequests.get(0);
    generatedIntegrationRequests.get(0).check_responses__c = true;
    System_Response__c sr = new System_Response__c(External_System__c = 'External', Error_Code__c = '-1', Error_Message__c = 'Message', Status__c = 'Status', Integration_Request__c = generatedIntegrationRequests.get(0).Id);
    insert sr;
    Integration_Framework_Configuration__c ifc = new Integration_Framework_Configuration__c(Name = 'Name', Event__c = 'Event', Geo__c = 'Geo', Lob__c = 'Lob', Market__c = 'Market', Sub_Event__c = 'Sub Event', System_1__c = 'Sys 1', System_2__c = 'Sys 2');
    insert ifc;
    update generatedIntegrationRequests.get(0);
    test.stopTest();
  }
  
  /*************************************************************************************************************
  * Name        : verifyDelete
  * Description : Verify the deleting of Integration Request Objects         
  * Input       : 
  * Output      : 
  *************************************************************************************************************/
  static testMethod void verifyDelete()
  {
  	test.startTest();
    List<Account> generatedAccounts = generateTestAccounts(1);	
    List<Integration_Request__c> generatedIntegrationRequests = generateIntegrationRequests(1, generatedAccounts.get(0).Id );
    List<Integration_Request__c> recordsInserted = [SELECT id from Integration_Request__c];
    System.AssertEquals(recordsInserted.size(), generatedIntegrationRequests.size(), 'The IntegrationRequests were not inserted into the database');
    delete generatedIntegrationRequests.get(0);
    List<Integration_Request__c> recordsDeleted = [SELECT Id from Integration_Request__c];
    System.AssertEquals(recordsDeleted.size(), 0, 'The IntegrationRequests were not deleted');
    undelete generatedIntegrationRequests.get(0);
    List<Integration_Request__c> recordsUndeleted = [SELECT Id from Integration_Request__c];
    System.AssertEquals(recordsUndeleted.size(), 1, 'The IntegrationRequests were not undeleted');
    test.stopTest();
  }
    
  /*************************************************************************************************************
  * Name        : generateIntegrationRequests
  * Description : Generate Integration Request records
  * Input       : NumOfIntegrationRequest - Number of Integration Request records to generate
  * INPUT       : The objectId to associate with the Integration Request
  * Output      : List of the Integration Request records generated
  *************************************************************************************************************/
  private static List<Integration_Request__c> generateIntegrationRequests(Integer numOfIntegrationRequests, Id objectId)
  {
   List<Integration_Request__c> integrationRequestsToInsert = new List<Integration_Request__c>();
       
    for(Integer i=0; i<numOfIntegrationRequests; i++)
    {
      Integration_Request__c integrationRequestToInsert = new Integration_Request__c(Object_Id__c = objectId);
      integrationRequestToInsert.Object_Name__c = 'Account';
      integrationRequestToInsert.Direction__c = 'Outbound';
      integrationRequestToInsert.Event__c = 'Enrol Student';
      integrationRequestToInsert.Geo__c ='Growth';
      integrationRequestToInsert.Lob__c = 'HE';
      integrationRequestToInsert.Market__c = 'ZA'; 
      integrationRequestsToInsert.add(integrationRequestToInsert);
    }
       
    if(integrationRequestsToInsert.size()>0)
    {
      insert integrationRequestsToInsert;
    }
       
    return integrationRequestsToInsert;
  }
    
  /*************************************************************************************************************
  * Name        : generateTestAccounts
  * Description : Generate Account records
  * Input       : NumOfAccounts - Number of account records to generate
  * Output      : List of the Account records generated
  *************************************************************************************************************/
  private static List<Account> generateTestAccounts(Integer numOfAccounts)
  {
    List<Account> accountsToInsert = new List<Account>();
        
    for(Integer i=0; i<numOfAccounts; i++)
    {
      Account accountToInsert = new Account(Name = 'Account' + (i+1), Market__c = 'ZA', Line_of_Business__c = 'Schools', Geography__c='Growth');
      accountsToInsert.add(accountToInsert);
    }
        
    if(accountsToInsert.size()>0)
    {
      insert accountsToInsert;
    }
     
    return accountsToInsert;
  }
}