/************************************************************************************************************
* Apex Class Name   : IntegrationRequestTriggerHandler
* Version           : 1.0 
* Created Date      : 20 March 2015
* Function          : Handler class for Integration_Request__c custom object trigger
* Modification Log  :
* Developer                   Date                    Description
* -----------------------------------------------------------------------------------------------------------
*                             20/03/2015              Created Default Handler Class Template
************************************************************************************************************/
public with sharing class IntegrationRequestTriggerHandler
{
    IntegrationFrameworkUtilities IntFramUtil = new IntegrationFrameworkUtilities();
    IntegrationFrameworkOuboundQueue IntFramOutboundQueue = new IntegrationFrameworkOuboundQueue();
    
    public void OnBeforeInsert(List<Integration_Request__c> listNewIntegrationRequest)
    {
        //Set the JSON Representation of the Integration Request object
        IntFramUtil.SetObjectsJSONRepresentation(listNewIntegrationRequest);

        //Set the initial status of the new outbound Integration Request Records
        IntFramOutboundQueue.SetNewIntReqStatus(listNewIntegrationRequest);
              
    }
    
    public void OnAfterInsert(List<Integration_Request__c> listNewIntegrationRequest, Map<ID,Integration_Request__c> mapNewIntegrationRequest)
    {
        
    }
    
    public void OnBeforeUpdate(List<Integration_Request__c> listOldIntegrationRequest, List<Integration_Request__c> listNewIntegrationRequest, Map<ID,Integration_Request__c> mapOldIntegrationRequest, Map<ID,Integration_Request__c> mapNewIntegrationRequest)
    {
        //Set status based on change to SystemResponse
        IntegrationFrameworkUtilities.SetStatusBasedSystemResponse(listNewIntegrationRequest);
    }
    
    public void OnAfterUpdate(List<Integration_Request__c> listOldIntegrationRequest, List<Integration_Request__c> listNewIntegrationRequest, Map<ID,Integration_Request__c> mapOldIntegrationRequest, Map<ID,Integration_Request__c> mapNewIntegrationRequest)
    {
        // Queueable class that checks if the status has been changed to Complete, Functional Error or Technical error and if so launch the corresponding handler flows 
        System.enqueueJob(new IntegrationFrameworkLaunchHandlerFlow(listNewIntegrationRequest));
    }
    
    public void OnBeforeDelete(List<Integration_Request__c> listOldIntegrationRequest, Map<ID,Integration_Request__c> mapOldIntegrationRequest)
    {
        
    }
    
    public void OnAfterDelete(List<Integration_Request__c> listOldIntegrationRequest, Map<ID,Integration_Request__c> mapOldIntegrationRequest)
    {
        
    }
    
    public void OnUndelete(List<Integration_Request__c> listNewIntegrationRequest, Map<ID,Integration_Request__c> mapNewIntegrationRequest)
    {
        
    }
}