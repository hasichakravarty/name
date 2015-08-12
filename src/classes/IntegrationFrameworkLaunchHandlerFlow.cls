/*******************************************************************************************************************
* Apex Class Name  : IntegrationFrameworkLaunchHandlerFlow 
* Version          : 1.0 
* Created Date     : 25 March 2015
* Function         : Class to launch the Integration Framework handler flows in a queueable mode
* Modification Log :
*
* Developer                   Date                    Description
* ------------------------------------------------------------------------------------------------------------------
*                             25/03/2015              Created Initial Version of IntegrationFrameworkLaunchHandlerFlow  Class
*******************************************************************************************************************/
public class IntegrationFrameworkLaunchHandlerFlow implements Queueable
{
    List<Integration_Request__c> IntReqListToQueue = new List<Integration_Request__c>();
    
    
    /*************************************************************************************************************
    * Name        : IntegrationFrameworkLaunchHandlerFlow
    * Description : Launch the Integration Framework handler flows in a queueable mode base on the Integration Request
    *               records 
    * Input       : IntegrationRequestList - List of Integration Request records to queue
    * Output      : 
    *************************************************************************************************************/
    public IntegrationFrameworkLaunchHandlerFlow(List<Integration_Request__c> IntegrationRequestList)
    {
        this.IntReqListToQueue.addAll(IntegrationRequestList);
    }
    public void execute(QueueableContext context) {

        if(IntReqListToQueue.size()>0)
        { 
            System.debug('INT REQ CHECKING: ' + IntReqListToQueue.get(0).Id);
            
            // Set the input parameters for the handler flows
            Map<String, Object> FlowInputParameters = new Map<String, Object>();
            FlowInputParameters.put('IntegrationRequestObject',IntReqListToQueue.get(0));
            
            //Check if it's an outbound integration request
            if(IntReqListToQueue.get(0).Direction__c == 'Outbound')
            {
                
                // Base on the status of the integration request record launch the corresponding handler flow
                if(IntReqListToQueue.get(0).Status__c == 'Functional Error')
                {
                    //Launch Functional Error Handler Flow
                    Flow.Interview.OIF_FunctionalErrorHandler FunctionalErrorHandlerFlow = new Flow.Interview.OIF_FunctionalErrorHandler(FlowInputParameters);
                    FunctionalErrorHandlerFlow.start();
                }
                else if(IntReqListToQueue.get(0).Status__c == 'Technical Error')
                {
                    //Launch Technical Error Handler Flow
                    Flow.Interview.OIF_TechnicalErrorHandler TechnicalErrorHandlerFlow = new Flow.Interview.OIF_TechnicalErrorHandler(FlowInputParameters);
                    TechnicalErrorHandlerFlow.start();
                }
                else if(IntReqListToQueue.get(0).Status__c == 'Completed')
                {
                    
                    //Launch Completion Handler Flow
                    Flow.Interview.OIF_CompletionHandler CompletionHandlerFlow = new Flow.Interview.OIF_CompletionHandler(FlowInputParameters);
                    CompletionHandlerFlow.start();
                }
            }
            // Remove the current Integration Request record from the list to queue
            IntReqListToQueue.remove(0);
            
            // If there are still Integration Request records in the list of records to queue, execute the method for the first one in the list
            if(IntReqListToQueue.size()>0)
            {
                System.enqueueJob(new IntegrationFrameworkLaunchHandlerFlow(IntReqListToQueue));
            }
        }
    }
}