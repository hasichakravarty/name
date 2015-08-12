/*******************************************************************************************************************
* Apex Class Name  : PS_Apttus_Proposal_Proposal 
* Version          : 1.0 
* Created Date     : 28 Feb 2015
* Function         : Trigger for Apttus_Proposal__Proposal__c Object
* Modification Log :
*
* Developer                                Date                    Description
* ------------------------------------------------------------------------------------------------------------------
*   Sachin, Pooja                          28/02/2015              Created Initial Version
*******************************************************************************************************************/
trigger PS_Apttus_Qualification_Details on Apttus_Proposal__Proposal__c (before update, after update, before insert ) {
    system.debug('in Trigger Qualification_Details');
   Qualification_Details_Handler handler = new Qualification_Details_Handler();
        
     if(trigger.isBefore){
         if(trigger.isInsert){
             handler.proposalMethod(trigger.new,trigger.oldMap);
         }
         if(trigger.isUpdate){
             handler.proposalMethod(trigger.new,trigger.oldMap);
             handler.proposalMethod1(trigger.new,trigger.oldMap);
         }
     }
     if(trigger.isAfter){
         if(trigger.isUpdate){
             handler.proposalMethod2(trigger.new,trigger.oldMap);
         }
     }    
}