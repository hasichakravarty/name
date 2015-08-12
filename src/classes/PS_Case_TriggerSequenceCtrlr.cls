/* ----------------------------------------------------------------------------------------------------------------------------------------------------------
   Name:            PS_Case_TriggerSequenceCtrlr.cls 
   Description:     On insert/update/delete of Case record 
   Date             Version         Author                             Summary of Changes 
   -----------      ----------      -----------------    ---------------------------------------------------------------------------------------------------
  03/2015         1.0            Manikandan                       Initial Release 
------------------------------------------------------------------------------------------------------------------------------------------------------------ */
public with sharing class PS_Case_TriggerSequenceCtrlr {
    
    
     /**
    * Description : Performing all  Before Update Operations
    * @param NA
    * @return NA
    * @throws NA
    **/
   // public static void beforeUpdate(){
   // }
    
    /**
    * Description : Performing all  before Insert operation
    * @param NA
    * @return NA
    * @throws NA
    **/
  //  public static void beforeInsert(){  }
    
    /**
    * Description : Performing all  before Insert operation
    * @param NA
    * @return NA
    * @throws NA
    **/
    public static void beforeInsertOrUpdate(List<Case> triggeredcases){
        

        CloseCase.cannotCloseCase(triggeredcases);
        // 01-05-2015 - Requirements 1177/ 1174
        // smark
        // Update the student and sponsor email fields in the case object
        UpdateEmailFieldsCase.populateEmailFieldsCase(triggeredcases);

        PS_Case_D2L_Management.assignAccountToNewSponsor(triggeredcases);
    }
    
    
    /**
    * Description : Performing all  After Insert Operations
    * @param List<Case> newCases
    * @return NA
    * @throws NA
    **/
    public static void afterInsert( List<Case> newCases,  Map<id,Case> oldmap){
        AssignmentRuleActivation.activateAssignmentRule(newCases, true, false, oldmap);
    }
    
     /**
    * Description : Performing all  After Update Operations
    * @param NA
    * @return NA
    * @throws NA
    **/
    public static void afterUpdate(List<Case> newCases, Map<id,Case> oldmap){
        AssignmentRuleActivation.activateAssignmentRule(newCases, false, true, oldmap);
        PS_INT_IntegrationRequestController.createIntegrationRequestCase(newCases);
    }
    
    /**
    * Description : Performing all  AfterInsert or AfterUpdate operation
    * @param NA List<Case> newtriggeredCases,Boolean isInsert,Boolean isUpdate 
    * @return NA
    * @throws NA
    **/
  //  public static void afterInsertOrUpdate( List<Case> newtriggeredCases,Boolean isInsert,Boolean isUpdate ){
      //  system.debug('*************** newtriggeredCases : '+newtriggeredCases);
        
        
  //  }
    
    /**
    * Description : Performing all  After Delete operation
    * @param NA
    * @return NA
    * @throws NA
    **/
  //  public static void afterDelete(){  }

}