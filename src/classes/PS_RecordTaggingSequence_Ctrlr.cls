/* ----------------------------------------------------------------------------------------------------------------------------------------------------------
   Name:            PS_RecordTaggingSequence_Ctrlr.cls 
   Description:     On insert/update of Lead record 
   Date             Version         Author                             Summary of Changes 
   -----------      ----------      -----------------    ---------------------------------------------------------------------------------------------------
  03/2015         1.0            Kalidass                       Initial Release 
------------------------------------------------------------------------------------------------------------------------------------------------------------ */
public with sharing class PS_RecordTaggingSequence_Ctrlr {
    
    
     /**
    * Description : Performing all  Before Update Operations
    * @param NA
    * @return NA
    * @throws NA
    **/
    public static void beforeUpdate(){
    }
    
    /**
    * Description : Performing all  before Insert operation
    * @param NA
    * @return NA
    * @throws NA
    **/
    public static void beforeInsert(){
      PS_Lead_RecordTagging_Ctrlr ldup = new PS_Lead_RecordTagging_Ctrlr();
     ldup.leadRecordTagging(Trigger.new);
    }
    
    /**
    * Description : Performing all  After Update Operations
    * @param NA
    * @return NA
    * @throws NA
    **/
    public static void afterUpdate(){
     
     
    }
    
    /**
    * Description : Performing all  After Insert operation
    * @param NA
    * @return NA
    * @throws NA
    **/
    public static void afterInsert(){
     PS_Lead_RecordTagging_Ctrlr ldup = new PS_Lead_RecordTagging_Ctrlr();
     ldup.leadRecordTagging(Trigger.new);
 
    }
    

}