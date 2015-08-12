/*******************************************************************************************************************
* Apex Class Name  : IntegrationFrameworkAsset
* Version          : 1.0 
* Created Date     : 31 March 2015
* Function         : Class to group the functionalities of the Integration Framework related with the Asset object
* Modification Log :
*
* Developer                   Date                    Description
* ------------------------------------------------------------------------------------------------------------------
*                             31/03/2015              Created Initial Version of IntegrationFrameworkAsset Class
*******************************************************************************************************************/
public without sharing class IntegrationFrameworkAsset
{
    /*************************************************************************************************************
    * Name        : GetAssetsFromJSONRepresentation
    * Description : Get the Integration Request parent Asset object from the JSON Representation
    * Input       : IntReqList - List of Integration Request record
    * Output      : List of Asset object instances
    *************************************************************************************************************/
    @InvocableMethod(label='Get Assets From JSON Representation' description='For the input Integration Request Object, retrieves the corresponding Asset Object from the JSON Representation')
    public static List<Asset> GetAssetsFromJSONRepresentation(List<Integration_Request__c> IntReqList)
    {
        List<Asset> ParentAssetList = new List<Asset>();
        
        Asset ParentAsset = new Asset();
        
        // Loop the input Integration Request records to get the Parent sObject from the JSON representation
        for(Integration_Request__c IntReq :IntReqList)
        {
            try
            {
                if((IntReq.Object_Original__c != null)&&(IntReq.Object_Original__c != ''))
                {
                    ParentAsset = (Asset)JSON.deserialize(IntReq.Object_Original__c, Asset.class);
                    ParentAssetList.add(ParentAsset);
                }
            }
            catch(Exception e)
            {
                
            }
        }
        
        return ParentAssetList;
    
    }
}