/*******************************************************************************************************************
* Apex Class Name  : IntegrationFrameworkOuboundQueue
* Version          : 1.0 
* Created Date     : 31 March 2015
* Function         : Class to group the functionalities of the Integration Framework Outbound Queue
* Modification Log :
*
* Developer                   Date                    Description
* ------------------------------------------------------------------------------------------------------------------
*                             31/03/2015              Created Initial Version of IntegrationFrameworkOuboundQueue Class
*******************************************************************************************************************/
public without sharing class IntegrationFrameworkOuboundQueue
{
    /*************************************************************************************************************
    * Name        : SetNewIntReqStatus
    * Description : Set the initial status for the new Integration Request records
    * Input       : IntReqList - List of Integration Request records to include
    * Output      : 
    *************************************************************************************************************/
    public void SetNewIntReqStatus (List<Integration_Request__c> IntReqList)
    {
        // Get the Parent Object Ids of the outbound new Idntegration Request records
        List<String> ParentObjectIdsList = new List<String>();
        
        for(Integration_Request__c IntReq :IntReqList)
        {
            if(IntReq.Direction__c == 'Outbound')
            {
                ParentObjectIdsList.add(IntReq.Object_Id__c);
                
            }
        }
        
        if(ParentObjectIdsList.size()>0)
        {
            // Get the Integration Request records with the same Parent Object than the new Integration Request
            List<Integration_Request__c> ExistingIntReqList = [SELECT Id, Status__c, Object_Id__c FROM Integration_Request__c 
                                                                WHERE Object_Id__c IN :ParentObjectIdsList 
                                                                AND Direction__c = 'Outbound' 
                                                                AND Status__c IN ('Ready For Submission','Functional Error','Received','Technical Error','Queued')];     
                                                                                  
            
            Map<ID, List<Integration_Request__c>> ExistingIntReqMap = new Map<ID, List<Integration_Request__c>>();
       
            for(Integration_Request__c ExistingIntReq :ExistingIntReqList)
            {
                if(ExistingIntReqMap.containsKey(ExistingIntReq.Object_Id__c))
                {
                    List<Integration_Request__c> IntReqListPerParentObject = ExistingIntReqMap.get(ExistingIntReq.Object_Id__c);
                    IntReqListPerParentObject.add(ExistingIntReq);
                    ExistingIntReqMap.put(ExistingIntReq.Object_Id__c,IntReqListPerParentObject);
                }
                else
                {
                    List<Integration_Request__c> IntReqListPerParentObject = new List<Integration_Request__c>();
                    IntReqListPerParentObject.add(ExistingIntReq);
                    ExistingIntReqMap.put(ExistingIntReq.Object_Id__c,IntReqListPerParentObject);
                }
            }
            
            // Set to status to Queued if there is already another Integration Request for the same Parent Object 
            // or to Ready For Submission status if there isn't any other Integration Request for the same Parent Object
            for(Integration_Request__c IntReq :IntReqList)
            {
                if(ExistingIntReqMap.containsKey(IntReq.Object_Id__c))
                {
                  
                    IntReq.Status__c = 'Queued';
                }
                else
                {
                    IntReq.Status__c = 'Ready For Submission';
                }
            }   
        }
    }
    
    /*************************************************************************************************************
    * Name        : SubmitNextOutboundIngrationResquestFromQueue
    * Description : For the corresponding input Integration Request Objects, 
    *               sets to Ready for Submission the next Integration Request records in the Queue
    * Input       : CompletedIntReqList - List of Integration Request record completed
    * Output      : List of Integration Request records submitted
    *************************************************************************************************************/
    @InvocableMethod(label='Submit Next Outbound Integration Request From Queue' description='For the corresponding input Integration Request Object, sets to Ready for Submission the next Integration Request record in the Queue')
    public static List<Integration_Request__c> SubmitNextOutboundIngrationResquestFromQueue(List<Integration_Request__c> CompletedIntReqList){
        
        List<Integration_Request__c> SubmittedIntegrationRequests = new List<Integration_Request__c>();
            
            try
            {
                if(CompletedIntReqList.size()>0)
                {   
                    // Get the Ids of the Parent Objects
                    List<String> ParentObjectIdsList = new List<String>();
            
                    for(Integration_Request__c IntReq :CompletedIntReqList)
                    {
                        if(IntReq.Direction__c == 'Outbound')
                        {
                            ParentObjectIdsList.add(IntReq.Object_Id__c);
                            
                        }
                    }
                
                    // Get the outbound Integration_Request__c record with a Queued status, the oldest Created date/time and the same Parent Object
                    List<Integration_Request__c> FirstIntReqInQueue = [SELECT Id, Status__c, Object_Id__c ,CreatedDate FROM Integration_Request__c
                                                                            WHERE Object_Id__c = :ParentObjectIdsList
                                                                            AND Direction__c = 'Outbound'
                                                                            AND Status__c = 'Queued'
                                                                            ORDER BY Object_Id__c, CreatedDate ASC
                                                                            LIMIT 1];
                    // Submit next Integration Request record
                    if(FirstIntReqInQueue.size()>0)
                    {
                        Map<String,Integration_Request__c> NextIntReqPerParentObjectMap= new Map<String,Integration_Request__c>();
                        
                        // Loop through the Parent Object and find the next Integration Request to submit for each of them
                        for(String ParentObjectId :ParentObjectIdsList)
                        {
                            for(Integration_Request__c IntReq :FirstIntReqInQueue)
                            {
                                if(NextIntReqPerParentObjectMap.containsKey(IntReq.Object_Id__c))
                                {
                                    break;
                                }
                                else
                                {
                                    IntReq.Status__c = 'Ready For Submission';
                                    SubmittedIntegrationRequests.add(IntReq);
                                    NextIntReqPerParentObjectMap.put(IntReq.Object_Id__c,IntReq);
                                }
                            }
                        }       
                        update SubmittedIntegrationRequests;            
                    }   
                }
            }
            catch(Exception e)
            {
                SubmittedIntegrationRequests = null;
            }
            
            return SubmittedIntegrationRequests;
    }



}