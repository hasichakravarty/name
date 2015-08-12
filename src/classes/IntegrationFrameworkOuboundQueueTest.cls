/*******************************************************************************************************************
* Apex Class Name  : IntegrationFrameworkOuboundQueueTest
* Version          : 1.0 
* Created Date     : 24 April 2015
* Function         : Test Class of the Integration Framework Oubound Queue
* Modification Log :
*
* Developer                   Date                    Description
* ------------------------------------------------------------------------------------------------------------------
*                         24/04/2015              Created Initial Version of AccountContactSyncTestClass
*******************************************************************************************************************/
@isTest  
public with sharing class IntegrationFrameworkOuboundQueueTest 
{
  /*************************************************************************************************************
  * Name        : verifySetNewIntReqStatus
  * Description : Verify the SetNewIntReqStatus method   
  * Input       : 
  * Output      : 
  *************************************************************************************************************/
  static testMethod void verifySetNewIntReqStatus()
  {
    test.startTest();
    List<Account> generatedAccounts = generateTestAccounts(1);  
    List<Integration_Request__c> generatedIntegrationRequests = generateIntegrationRequests(10, generatedAccounts.get(0).Id );
    generatedIntegrationRequests.get(1).Sub_Event__c = 'Change Module Choice';
    generatedIntegrationRequests.get(1).Status__c = 'Queued';
    update generatedIntegrationRequests.get(1);
    
    generatedIntegrationRequests.get(2).Lob__c = null;
    generatedIntegrationRequests.get(2).Geo__c = null;
    generatedIntegrationRequests.get(2).Market__c = null;
    
    generatedIntegrationRequests.get(3).Lob__c = null;
    generatedIntegrationRequests.get(3).Geo__c = null;
    
    generatedIntegrationRequests.get(4).Lob__c = null;
    
    generatedIntegrationRequests.get(5).Lob__c = null;
    generatedIntegrationRequests.get(5).Market__c = null;
    
    generatedIntegrationRequests.get(6).Geo__c = null;
    generatedIntegrationRequests.get(6).Market__c = null;
    
    generatedIntegrationRequests.get(7).Geo__c = null;
    
    generatedIntegrationRequests.get(8).Market__c = null;
    
    IntegrationFrameworkOuboundQueue ifoq = new IntegrationFrameworkOuboundQueue();
    ifoq.SetNewIntReqStatus(generatedIntegrationRequests);
    IntegrationFrameworkOuboundQueue.SubmitNextOutboundIngrationResquestFromQueue(generatedIntegrationRequests);        
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