/* ----------------------------------------------------------------------------------------------------------------------------------------------------------
   Name:            PS_Opportunity_TriggerSequenceCtrlr .cls 
   Description:     On insert/update/delete of Lead record 
   Date             Version         Author                             Summary of Changes 
   -----------      ----------      -----------------    ---------------------------------------------------------------------------------------------------
  04/2015         1.0           Karthik.A.S                       Initial Release
  06/2015         1.1           Stacey Walter                     Adjustment to Bypass functions
  06/07/2015      1.1           Davi Borges                       Change to submissionvalidation method signature to pass old opportunities
------------------------------------------------------------------------------------------------------------------------------------------------------------ */
public with sharing class PS_Opportunity_TriggerSequenceCtrlr {
    
     /**
    * Description : Performing all  Before Update Operations
    * @param NA
    * @return NA
    * @throws NA
    **/
    public static void beforeUpdate(List<Opportunity> newOpportunitys){
       
        //D2L Operations
        List<Opportunity> D2Llist = OpptyUtils.getOpportunityByRecordType('D2L',newOpportunitys);
        
        if(D2Llist.size()>0)
        {
             PS_INT_IntegrationRequestController.submissionValidation(newOpportunitys,(Map<Id,Opportunity>)trigger.oldMap); 
            PS_CreateAssetbasedStudentRegistration.OpportunityStage((Map<Id,Opportunity>)trigger.newMap,newOpportunitys,(Map<Id,Opportunity>)trigger.oldMap);
            PS_CreateAssetbasedStudentRegistration.ValidationOnTask((Map<Id,Opportunity>)trigger.newMap,newOpportunitys);
            PS_CreateAssetbasedStudentRegistration.ValidationOnTaskAndEvent((Map<Id,Opportunity>)trigger.newMap,newOpportunitys);       
        }
    }
    /**
    * Description : Performing all  before Insert operation
    * @param NA
    * @return NA
    * @throws NA
    **/
    public static void beforeInsert(List<Opportunity> newOpportunitys){
    
    }
    
    /**
    * Description : Performing all  After Update Operations
    * @param NA
    * @return NA
    * @throws NA
    **/
    public static void afterUpdate(List<Opportunity> newOpportunitys, Map<Id,Opportunity> oppOldMap)
    {
       // RD: 652 | Territory Management | Pooja | 3rd June
       // Add chatter feed on User who is assigned to Territory( as a Customer Digital Success Agent) shud be associated to Opportunity 
       List<Opportunity> opList = new List<Opportunity>();
       for(Opportunity op : newOpportunitys){
           if(op.RecordTypeId == Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('B2B').getRecordTypeId() && op.Digital_Indicator__c == true && op.StageName == 'Closed' && op.StageName != oppOldMap.get(op.Id).StageName){   
              opList.add(op);
           }
       }            
       if(opList != null){
           PS_OpportunityB2BNAActions.cdsOpportunityClosingNotification(opList); // RD: 652 | Pooja |3rd June
       }
        //D2L Operations
        
        List<Opportunity> D2Llist = OpptyUtils.getOpportunityByRecordType('D2L',newOpportunitys);
        
        if(D2Llist.size()>0)
        {
            List<Opportunity> convertedList = OpptyUtils.getLeadConvertedOpp(D2Llist);
            List<Opportunity> nonConvertedList = OpptyUtils.getLeadNonConvertedOpp(D2Llist);
            
            PS_opportunity_UpdateAccountTeamAdmin.updateadmin(D2Llist);
            PS_INT_IntegrationRequestController.createIntegrationRequestOpp(D2Llist, Trigger.oldMap);
            PS_CreateAssetbasedStudentRegistration.createTaskOnPsychology(D2Llist);
            sendEmailToOpptyContact.OppOutboundNotification(D2Llist,Trigger.oldMap,true);

            
            if(nonConvertedList.size()>0)
            {
                PS_CreateAssetbasedStudentRegistration.createTask_Method1(D2Llist); 
                PS_CreateAssetbasedStudentRegistration.ReturningBuisinesscreateTask(nonConvertedList);
            }
        }
        
    }
    
    /**
    * Description : Performing all  After Insert operation
    * @param NA
    * @return NA
    * @throws NA
    **/
    public static void afterInsert(List<Opportunity> newOpportunitys){
        
        List<Opportunity> D2Llist = OpptyUtils.getOpportunityByRecordType('D2L',newOpportunitys);
        
        if(D2Llist.size()>0)
        {
            List<Opportunity> convertedList = OpptyUtils.getLeadConvertedOpp(D2Llist);
            List<Opportunity> nonConvertedList = OpptyUtils.getLeadNonConvertedOpp(D2Llist);    
            
            PS_opportunity_UpdateAccountTeamAdmin.updateadmin(D2Llist); 
            PS_CreateAssetbasedStudentRegistration.createTask(D2Llist);
            
            if(nonConvertedList.size()>0)
            {
                PS_opportunity_MapAccountcontactRole.MapAccountcontactRole(nonConvertedList);
                PS_CreateAssetbasedStudentRegistration.ReturningBuisinesscreateTask(nonConvertedList);
                PS_CreateAssetbasedStudentRegistration.createTask_Method(nonConvertedList);  
            }
            
         }
    }
}