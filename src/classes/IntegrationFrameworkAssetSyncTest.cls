/*******************************************************************************************************************
* Apex Class Name  : IntegrationFrameworkAssetSyncTest
* Version          : 1.0 
* Created Date     : 24 April 2015
* Function         : Test Class of the Integration Framework Asset Sync 
* Modification Log :
*
* Developer                   Date                    Description
* ------------------------------------------------------------------------------------------------------------------
*                         24/04/2015              Created Initial Version of AccountContactSyncTestClass
*******************************************************************************************************************/
@isTest  
public with sharing class IntegrationFrameworkAssetSyncTest 
{
  /*************************************************************************************************************
  * Name        : verifySetNewIntReqStatus
  * Description : Verify the SetNewIntReqStatus method   
  * Input       : 
  * Output      : 
  *************************************************************************************************************/
  static testMethod void verifySynchroniseAssets()
  {
    test.startTest();
    List<Case> generatedCases = generateTestCases(1);   
    List<Integration_Request__c> generatedIntegrationRequests = generateIntegrationRequests(10, generatedCases.get(0).Id );
    generatedIntegrationRequests.get(1).Sub_Event__c = 'Change Module Choice';
    generatedIntegrationRequests.get(1).Status__c = 'Queued';
    update generatedIntegrationRequests.get(1);
    
    generatedIntegrationRequests.get(2).Lob__c = null;
    generatedIntegrationRequests.get(2).Geo__c = null;
    generatedIntegrationRequests.get(2).Market__c = null;
    generatedIntegrationRequests.get(2).Event__c = 'Change Of Campus';
    
    generatedIntegrationRequests.get(3).Lob__c = null;
    generatedIntegrationRequests.get(3).Geo__c = null;
    generatedIntegrationRequests.get(3).Event__c = 'Modify Contract';
    
    generatedIntegrationRequests.get(4).Lob__c = null;
    generatedIntegrationRequests.get(4).Event__c = 'Contract Cancelled'; 
    
    generatedIntegrationRequests.get(5).Lob__c = null;
    generatedIntegrationRequests.get(5).Market__c = null;
    
    generatedIntegrationRequests.get(6).Geo__c = null;
    generatedIntegrationRequests.get(6).Market__c = null;
    
    generatedIntegrationRequests.get(7).Geo__c = null;
    
    generatedIntegrationRequests.get(8).Market__c = null;
    
    IntegrationFrameworkAssetSync.SynchroniseAssets(generatedIntegrationRequests);
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
      Account accountToInsert = new Account(Name = 'Account' + (i+1));
      accountsToInsert.add(accountToInsert);
    }
        
    if(accountsToInsert.size()>0)
    {
      insert accountsToInsert;
    }
     
    return accountsToInsert;
  }
  
  /*************************************************************************************************************
  * Name        : generateTestCases
  * Description : Generate Cases records
  * Input       : NumOfCases - Number of case records to generate
  * Output      : List of the Case records generated
  *************************************************************************************************************/
  private static List<Case> generateTestCases(Integer numOfCases)
  {
    List<Case> casesToInsert = new List<Case>();
    
    //Generate an account
    Account acc = new Account(Name = 'Account 1', Market__c = 'ZA', Line_of_Business__c = 'Schools', Geography__c='Growth'); 
    insert acc;
        
    //Generate contact
    Contact con = new Contact(LastName = 'Contact 1', FirstName = 'fn', Email = 'test@test.com.demo', AccountId = acc.Id);
    insert con;
    RecordType rt = [SELECT Id,Name FROM RecordType WHERE SobjectType='Case' and DeveloperName = 'Loan_Bursary_Request'];
    for(Integer i=0; i<numOfCases; i++)
    {    
      Case caseToInsert = new Case( AccountId = acc.Id, RecordTypeid = rt.id, Type ='General', ContactId = con.Id, Sponsor_name__c = con.Id);          
      casesToInsert.add(caseToInsert);
    }
        
    if(casesToInsert.size()>0)
    {
      insert casesToInsert;
    }
     
    return casesToInsert;
  }
}