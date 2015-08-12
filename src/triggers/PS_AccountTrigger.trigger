/* ----------------------------------------------------------------------------------------------------------------------------------------------------------
   Name:            PS_AccountTrigger.trigger
   Description:     On insert/update/delete of Account record 
   Date             Version         Author                             Summary of Changes 
   -----------      ----------      -----------------    ---------------------------------------------------------------------------------------------------
  27/03/2015         1.0            Manikandan                       Initial Release 
------------------------------------------------------------------------------------------------------------------------------------------------------------ */

trigger PS_AccountTrigger on Account(after insert, after update, before insert, before update, after delete, before delete) { 
        
        Bypass_Settings__c bypass = Bypass_Settings__c.getInstance();
        List<Account> newAccounts = new List<Account>();
        List<Account> oldAccounts = new List<Account>();
         
        system.debug('################## bypass.Disable_Triggers__c :'+bypass.Disable_Triggers__c);
        //  Use Commonutils for getting the records which you want to get bypassed by ANZ record types 
        if (bypass.Disable_Triggers__c == false)
        {     
          if(Trigger.isAfter){
              
             if(trigger.IsUpdate && checkRecurssionAfter.runOnce('PS_AccountTrigger','Update')){
                  newAccounts = CommonUtils.getAccountbypassRecordType(System.Label.ANZ_Account_Record_Type, Trigger.new);
                  oldAccounts = CommonUtils.getAccountbypassRecordType(System.Label.ANZ_Account_Record_Type, Trigger.old);
                  system.debug('\n\n##############AfterUpdate : Trigger.IsUpdate : '+Trigger.IsUpdate+'\n\n');
                  system.debug('##############newAccounts : '+newAccounts);
                  System.debug('### trigger.new'+trigger.new);                        
                  Account_TriggerSequenceCtrlr.afterInsertOrUpdate(newAccounts,Trigger.IsInsert,Trigger.IsUpdate);
                  Account_TriggerSequenceCtrlr.afterUpdate(oldAccounts);
                  //Account_TriggerSequenceCtrlr.afterUpdate(newAccounts,Trigger.oldMap);
              } 
              
              if(trigger.IsInsert && checkRecurssionAfter.runOnce('PS_AccountTrigger','Insert')){
                 system.debug('##############newAccounts : '+Trigger.new);   
                 newAccounts = CommonUtils.getAccountbypassRecordType(System.Label.ANZ_Account_Record_Type, Trigger.new); 
                 oldAccounts = CommonUtils.getAccountbypassRecordType(System.Label.ANZ_Account_Record_Type, Trigger.old); 
                 system.debug('\n\n##############AfterInsert Trigger.IsInsert : '+Trigger.IsInsert +'\n\n'); 
                 system.debug('##############newAccounts : '+newAccounts); 
                 Account_TriggerSequenceCtrlr.afterInsertOrUpdate(newAccounts,Trigger.IsInsert,Trigger.IsUpdate);
                 Account_TriggerSequenceCtrlr.afterInsert(newAccounts,Trigger.newMap);
              }
        
                      
          } 
       
      
      
          if(Trigger.isBefore){
        
              if(trigger.IsUpdate && checkRecurssionBefore.runOnce('PS_AccountTrigger','Update')){
                   system.debug('new trg--->'+ trigger.new +'===trigger old---'+trigger.old);
                   newAccounts = CommonUtils.getAccountbypassRecordType(System.Label.ANZ_Account_Record_Type, Trigger.new);
                   oldAccounts = CommonUtils.getAccountbypassRecordType(System.Label.ANZ_Account_Record_Type, Trigger.old);
                   system.debug('\n\n##############BeforeUpdate : Trigger.IsUpdate : '+Trigger.IsUpdate+'\n\n');
                   system.debug('##############newAccounts : '+newAccounts);
                   Account_TriggerSequenceCtrlr.beforeInsertOrUpdate(newAccounts,false);
                   Account_TriggerSequenceCtrlr.beforeUpdate(newAccounts,Trigger.oldmap);
                   
                   
                    List<Account> acList = new List<Account>();
                    for(Account ac : newAccounts){
                     
                    system.debug('Tr code--->'+ ac.Territory_Code_s__c +'oldmap---' +trigger.oldMap.get(ac.Id).Territory_Code_s__c + 'newmap----'+ trigger.newMap.get(ac.Id).Territory_Code_s__c);
                        if(ac.Territory_Code_s__c!= trigger.oldMap.get(ac.Id).Territory_Code_s__c){
                            
                            acList.add(ac);
                        }
                    }   
                     // RD: 652 | Pooja | 4th june | territory Chatter Notification when account added or removed
                    if(acList.size() >0){
                        Account_TriggerSequenceCtrlr.AccountTerritoryAssociationNotification(acList,trigger.oldMap);
                    }
              }
              
              if(trigger.IsInsert && checkRecurssionBefore.runOnce('PS_AccountTrigger','Insert'))
              {
                  Map<String, Schema.SObjectType> sObjectMap = Schema.getGlobalDescribe() ;
                  Schema.SObjectType Accnt = sObjectMap.get('Account') ; // getting Sobject Type
                  Schema.DescribeSObjectResult accntresSchema = Accnt.getDescribe() ;
                  Map<String,Schema.RecordTypeInfo> accntrecordTypeInfo = accntresSchema.getRecordTypeInfosByName(); //getting all Recordtype for the Sobject
    
                    //Davi Borges: Bad solution detect it has to be fixed for R2
                    /*for(Account accObj : Trigger.new){
                        if(accObj.IsCreatedFromLead__c)
                                accObj.recordtypeid = accntrecordTypeInfo.get('Learner').getRecordTypeId();
                               System.debug('@@@accrecordtype'+ accObj.recordtypeid); 
                    }*/ //Davi Borges --> Commented the record type should be defined by the Permission  of the user

                 
                  newAccounts = CommonUtils.getAccountbypassRecordType(System.Label.ANZ_Account_Record_Type, Trigger.new);
                  system.debug('\n\n##############BeforeInsert Trigger.IsInsert : '+Trigger.IsInsert +'\n\n'); 
                  system.debug('##############newAccounts : '+newAccounts);
                  Account_TriggerSequenceCtrlr.beforeInsertOrUpdate(newAccounts,trigger.IsInsert);
                  Account_TriggerSequenceCtrlr.beforeInsert(newAccounts);
              }
                   
          } 
        } 
}