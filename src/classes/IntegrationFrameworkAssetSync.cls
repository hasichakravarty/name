/*******************************************************************************************************************
* Apex Class Name  : IntegrationFrameworkAssetSync
* Version          : 1.0 
* Created Date     : 21 April 2015
* Function         : Class to conrol the synchronise of an asset
* Modification Log :
*
* Developer                   Date                    Description
* ------------------------------------------------------------------------------------------------------------------
*                             21/04/2015              Created Initial Version of IntegrationFrameworkAssetSync Class
*******************************************************************************************************************/
public without sharing class IntegrationFrameworkAssetSync 
{
  /*************************************************************************************************************
   * Name        : SynchroniseAssets
   * Description : Depending on the integration request event calls the corresponding  
   *               method in the AssetHandler class to perform the operation to synchronise the asset
   * Input       : CompletedIntReqList - List of Integration Request record completed
   * Output      : none
   *************************************************************************************************************/
  @InvocableMethod(label='Asset synchronisation' description='Synchronises an asset')
  public static void SynchroniseAssets(List<Integration_Request__c> CompletedIntReqList)
  {
  	// create an instance of the AssetHandler to delegate the sync request to
  	AssetHandler assetHandler = new AssetHandler();
  	
  	// process each Integration Request and call the corresponding AssetHandler method
  	for(Integration_Request__c intReq : CompletedIntReqList)
    { 
      System.debug('Processing Integration Request ' + intReq.Name + ' ' + intReq.Event__c + ' ' + intReq.Geo__c + ' ' + intReq.LoB__c + ' ' + intReq.Market__c);
      if(IntReq.Event__c == System.Label.Enrol_Student)
      {
        System.debug('Responding to event Enrol Student');
        assetHandler.Enrol_Student(intReq.object_id__c);
      }
      else if(IntReq.Event__c == System.Label.Change_Of_Campus)
      {
        System.debug('Responding to event Change of Campus');
        // get the case object from the integration object
        Case caseRec = [select Products_in_Use__c, Proposed_Campus__c from Case where id = :intReq.Object_Id__c ];
        if(caseRec != null)
        {
          assetHandler.ChangeofCampus_Asset(caserec.Products_in_Use__c, caserec.Proposed_Campus__c);
        }
      }
      else if(IntReq.Event__c == System.Label.Modify_Contract)
      {
        System.debug('Responding to event Modify Contract');
        assetHandler.Modify_Contract(intReq.object_id__c);
      }
      else if(IntReq.Event__c == System.Label.Contract_Cancelled)
      {
        System.debug('Responding to event Contract Cancelled');
        // get the case object from the integration object
        Case caseRec = [select Products_in_Use__c from Case where id = :intReq.Object_Id__c ];
        if(caseRec != null)
        {
          assetHandler.AssetCancelled(caserec.Products_in_Use__c);
        }
      }
    }
  }
}