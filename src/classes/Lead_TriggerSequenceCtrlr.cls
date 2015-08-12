/* ----------------------------------------------------------------------------------------------------------------------------------------------------------
   Name:            Lead_TriggerSequenceCtrlr.cls 
   Description:     On insert/update/delete of Lead record 
   Date             Version         Author                             Summary of Changes 
   -----------      ----------      -----------------    ---------------------------------------------------------------------------------------------------
  03/2015         1.0            Kalidass                       Initial Release 
------------------------------------------------------------------------------------------------------------------------------------------------------------ */
public with sharing class Lead_TriggerSequenceCtrlr {
    
    
     /**
    * Description : Performing all  Before Update Operations
    * @param NA
    * @return NA
    * @throws NA
    **/
    public static void beforeUpdate(){
    
      PS_Lead_RecordTagging_Ctrlr ldup = new PS_Lead_RecordTagging_Ctrlr();
      ldup.updateDateforQualifiedLead((list<lead>)Trigger.new, (map<id,lead>)Trigger.oldMap);
      PS_PreventChangingOwner.PreventChangingLeadOwner((list<lead>)Trigger.new, (map<id,lead>)Trigger.oldMap);
  
    }
    
    /**
    * Description : Performing all  before Insert operation
    * @param NA
    * @return NA
    * @throws NA
    **/
    public static void beforeInsert(){
    
    PS_Lead_UpdateStudentId.beforelead((list<lead>)Trigger.new);
    
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
     system.debug(' i am in Lead_TriggerSequenceCtrlr ');
        PS_lead_createContact.createAccountContact((list<lead>)Trigger.new, (map<id,lead>)Trigger.oldMap);
       //PS_mappingleadAccount ma = new PS_mappingleadAccount();
         //ma.B2BconvertLead((list<Lead>)Trigger.new, (map<id,lead>)Trigger.oldMap);   
         }
    
    /**
    * Description : Performing all  After Insert operation
    * @param NA
    * @return NA
    * @throws NA
    **/
          
    public static void afterInsert(){
        System.debug('@inna');    
       PS_Lead_UpdateStudentId.beforelead((list<lead>)Trigger.new);
             
      /* PS_Lead_RecordTagging_Ctrlr ldup = new PS_Lead_RecordTagging_Ctrlr();
     ldup.leadRecordTagging(Trigger.new);*/
    
     
 
    }
    
    
}