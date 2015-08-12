/*******************************************************************************************************************
* Apex Class Name  : IntegrationFrameworkUtilitiesTest
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
public with sharing class IntegrationFrameworkUtilitiesTest 
{
  /*************************************************************************************************************
  * Name        : verifySetObjectsJSONRepresentation
  * Description : Verify the verifySetObjectsJSONRepresentation method   
  * Input       : 
  * Output      : 
  *************************************************************************************************************/
  static testMethod void verifySetObjectsJSONRepresentation()
  {
    test.startTest();
    generateIntegrationFrameworkJSONDefinitions();
    List<Account> generatedAccounts = generateTestAccounts(1);  
    List<Integration_Request__c> generatedIntegrationRequests = generateIntegrationRequests(10, generatedAccounts.get(0).Id );
    generatedIntegrationRequests.get(1).Sub_Event__c = 'Change Module Choice';
    
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
    
    IntegrationFrameworkUtilities ifu = new IntegrationFrameworkUtilities();
    ifu.SetObjectsJSONRepresentation(generatedIntegrationRequests);
    
    List<Integration_Request__c> recordsInserted = [SELECT id from Integration_Request__c];
    System.AssertEquals(recordsInserted.size(), generatedIntegrationRequests.size(), 'The IntegrationRequests were not inserted into the database');
    test.stopTest();
  }  
  
  /*************************************************************************************************************
  * Name        : verifyGetsObjectFromJSONRepresentation
  * Description : Verify the verifyGetsObjectFromJSONRepresentation method   
  * Input       : 
  * Output      : 
  *************************************************************************************************************/
  static testMethod void verifyGetsObjectFromJSONRepresentation()
  {
    test.startTest();
    List<Account> generatedAccounts = generateTestAccounts(1);  
    List<Integration_Request__c> generatedIntegrationRequests = generateIntegrationRequests(1, generatedAccounts.get(0).Id );
    generatedIntegrationRequests.get(0).Object_Original__c = '{"attributes":{"type":"Contact","url":"/services/data/v33.0/sobjects/Contact/0031100000h3ff7AAA"},"FirstName":"Scott","Id":"0031100000h3ff7AAA","LastName":"Berry"}';
    IntegrationFrameworkUtilities.GetsObjectFromJSONRepresentation(generatedIntegrationRequests);
    
    List<Integration_Request__c> recordsInserted = [SELECT id from Integration_Request__c];
    System.AssertEquals(recordsInserted.size(), generatedIntegrationRequests.size(), 'The IntegrationRequests were not inserted into the database');
    test.stopTest();
  }  
  
  /*************************************************************************************************************
  * Name        : generateIntegrationFrameworkJSONDefinitions
  * Description : Generate IntegrationFrameworkJSONDefinitions records
  *************************************************************************************************************/
  private static void generateIntegrationFrameworkJSONDefinitions()
  {
    IntegrationFrameworkJSONDefinition__c ifjd1 = new IntegrationFrameworkJSONDefinition__c(Name = 'ZA_Growth_HE_Opp_EnrolStudent',
                                                                                           Object_Fields__c = 'Id',
                                                                                           Event__c = 'Enrol Student', 
                                                                                           ObjectType__c = 'Account',
                                                                                           Geo__c = 'Growth', 
                                                                                           Market__c = 'ZA', 
                                                                                           LoB__c = 'HE');
    insert ifjd1;    
    IntegrationFrameworkJSONDefinition__c ifjd2 = new IntegrationFrameworkJSONDefinition__c(Name = 'ZA_Growth_HE_Opp_RegStudent',
                                                                                           Object_Fields__c = 'Id',
                                                                                           Event__c = 'Register Student', 
                                                                                           ObjectType__c = 'Account',
                                                                                           Geo__c = 'Growth', 
                                                                                           Market__c = 'ZA', 
                                                                                           LoB__c = 'HE',
                                                                                           Sub_Event__c = 'Change Module Choice');
    insert ifjd2;   
    
    IntegrationFrameworkJSONDefinition__c ifjd3 = new IntegrationFrameworkJSONDefinition__c(Name = 'ZA_Growth_HE_Opp_CancelStudent',
                                                                                           Object_Fields__c = 'Id',
                                                                                           Event__c = 'Register Student', 
                                                                                           ObjectType__c = 'Account',
                                                                                           Geo__c = '', 
                                                                                           Market__c = '', 
                                                                                           LoB__c = '',
                                                                                           Sub_Event__c = 'Change Module Choice');
    insert ifjd3;                                                                                            
    
    IntegrationFrameworkJSONDefinition__c ifjd4 = new IntegrationFrameworkJSONDefinition__c(Name = 'ZA_Growth_HE_Opp_ModifyStudent',
                                                                                           Object_Fields__c = 'Id',
                                                                                           Event__c = 'Register Student', 
                                                                                           ObjectType__c = 'Account',
                                                                                           Geo__c = '', 
                                                                                           Market__c = 'ZA', 
                                                                                           LoB__c = '',
                                                                                           Sub_Event__c = 'Change Module Choice');
    insert ifjd4;
    
    IntegrationFrameworkJSONDefinition__c ifjd5 = new IntegrationFrameworkJSONDefinition__c(Name = 'ZA_Growth_HE_Opp_ChangeStudent',
                                                                                           Object_Fields__c = 'Id',
                                                                                           Event__c = 'Register Student', 
                                                                                           ObjectType__c = 'Account',
                                                                                           Geo__c = 'Growth', 
                                                                                           Market__c = 'ZA', 
                                                                                           LoB__c = '',
                                                                                           Sub_Event__c = 'Change Module Choice');
    insert ifjd5;
   
    IntegrationFrameworkJSONDefinition__c ifjd6 = new IntegrationFrameworkJSONDefinition__c(Name = 'ZA_Growth_HE_Opp_AmendStudent',
                                                                                           Object_Fields__c = 'Id',
                                                                                           Event__c = 'Register Student', 
                                                                                           ObjectType__c = 'Account',
                                                                                           Geo__c = 'Growth', 
                                                                                           Market__c = '', 
                                                                                           LoB__c = '',
                                                                                           Sub_Event__c = 'Change Module Choice');
    insert ifjd6;
    
    IntegrationFrameworkJSONDefinition__c ifjd7 = new IntegrationFrameworkJSONDefinition__c(Name = 'ZA_Growth_HE_Opp_AmendStudent',
                                                                                           Object_Fields__c = 'Id',
                                                                                           Event__c = 'Register Student', 
                                                                                           ObjectType__c = 'Account',
                                                                                           Geo__c = '', 
                                                                                           Market__c = '', 
                                                                                           LoB__c = 'HE',
                                                                                           Sub_Event__c = 'Change Module Choice');
    insert ifjd7;
    
    IntegrationFrameworkJSONDefinition__c ifjd8 = new IntegrationFrameworkJSONDefinition__c(Name = 'ZA_Growth_HE_Opp_AmendStudent',
                                                                                           Object_Fields__c = 'Id',
                                                                                           Event__c = 'Register Student', 
                                                                                           ObjectType__c = 'Account',
                                                                                           Geo__c = 'Growth', 
                                                                                           Market__c = '', 
                                                                                           LoB__c = 'HE',
                                                                                           Sub_Event__c = 'Change Module Choice');
    insert ifjd8;
  
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