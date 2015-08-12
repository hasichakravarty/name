/*******************************************************************************************************************
* Apex Class Name  : IntegrationFrameworkOpportunity
* Version          : 1.0 
* Created Date     : 31 March 2015
* Function         : Class to group the functionalities of the Integration Framework related with the Opportunity object
* Modification Log :
*
* Developer                   Date                    Description
* ------------------------------------------------------------------------------------------------------------------
*                             31/03/2015              Created Initial Version of IntegrationFrameworkOpportunity Class
*******************************************************************************************************************/
public without sharing class IntegrationFrameworkOpportunity
{
    /*************************************************************************************************************
    * Name        : GetOpportunitiesFromJSONRepresentation
    * Description : Get the Integration Request parent Opportunity object from the JSON Representation
    * Input       : IntReqList - List of Integration Request record
    * Output      : List of Opportunity object instances
    *************************************************************************************************************/
    @InvocableMethod(label='Get Opportunities From JSON Representation' description='For the corresponding input Integration Request Object, retrieves the corresponding Opportunity Object from the JSON Representation')
    public static List<Opportunity> GetOpportunitiesFromJSONRepresentation(List<Integration_Request__c> IntReqList)
    {
        List<Opportunity> ParentOpportunityList = new List<Opportunity>();
        
        // Loop the input Integration Request records to get the Parent sObject from the JSON representation
        for(Integration_Request__c IntReq :IntReqList)
        {
            Opportunity ParentOpportunity = new Opportunity();
            
            try
            {
                if((IntReq.Object_Original__c != null)&&(IntReq.Object_Original__c != ''))
                {
                    ParentOpportunity = (Opportunity)JSON.deserialize(IntReq.Object_Original__c, Opportunity.class);
                    ParentOpportunityList.add(ParentOpportunity);
                }
            }
            catch(Exception e){
                
            }
        }
        
        return ParentOpportunityList;
    
    }
}