/* ----------------------------------------------------------------------------------------------------------------------------------------------------------
   Name:            PS_Lead_RecordTaggingCtrlr.cls 
   Description:     On insert/update/ of Lead record 
   Date             Version         Author                             Summary of Changes 
   -----------      ----------      -----------------    ---------------------------------------------------------------------------------------------------
  03/2015         1.0                Srinadh Reddy                       Initial Release 
------------------------------------------------------------------------------------------------------------------------------------------------------------ */
public class PS_Lead_RecordTagging_Ctrlr
{  
  public void leadRecordTagging(List<Lead> leadUpdateList)
  {

   List<User> leadLst = new List<User>();

         String user_id = UserInfo.getUserId();

         List <User> userdetails = [select Market__c , Line_of_Business__c , Geography__c from User where id =:user_id limit 1];

         System.debug(userdetails);
       if(userdetails[0].Market__c != null && userdetails[0].Line_of_Business__c != null && userdetails[0].Geography__c != null && !userdetails.isEmpty())
        { 
        for(Lead newlead: leadUpdateList)
        {
            system.debug('newlead.Market__c----->'+newlead.Market__c);
           
        //lead l = new lead();
        newlead.Market__c = userdetails[0].Market__c;
        newlead.Line_of_Business__c = userdetails[0].Line_of_Business__c;
        newlead.Geography__c = userdetails[0].Geography__c;
        }
            //leadLst.add(newlead);
            
             //system.debug(newlead);

         }
         else if(leadUpdateList[0].Market__c != null && leadUpdateList[0].Line_of_Business__c != null && leadUpdateList[0].Geography__c != null )
         {
         }
         else
         {
          leadUpdateList[0].addError('Record can’t be created without the Market, Line of Business and Geography information in Current User') ;
         }

         //if(!leadLst.isEmpty())
         //{
             //update leadLst;
             
              //system.debug(leadLst);
        // }           
    }
    
   public void updateDateforQualifiedLead(List<Lead> lstNewLead , Map<Id,Lead> oldMap){
   
        
       Map<ID, Schema.RecordTypeInfo> rtMap = Schema.SObjectType.Lead.getRecordTypeInfosById();
       Id leadRecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('D2L').getRecordTypeId();

        for(Lead leadObj : lstNewLead){
            if(leadObj.RecordTypeId == leadRecordTypeId){
                if(leadObj.status=='Qualified' && leadObj.status!=oldMap.get(leadObj.id).status)
                        leadObj.Lead_changed_Qualified__c = System.Today();
                System.debug('after leadObj --- >'+leadObj);        
             }
        }
    }
}