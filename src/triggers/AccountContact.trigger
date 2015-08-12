trigger AccountContact on AccountContact__c (after delete, after insert, after undelete, after update, 
                                                                before delete, before insert, before update) {

    Bypass_Settings__c bypass = Bypass_Settings__c.getInstance();
    System.debug('BEFORE REC CHECK');
    //if(checkRecurssion.runOnce()){
        AccountContactTriggerHandler Handler = new AccountContactTriggerHandler(Trigger.isExecuting, Trigger.size);
        
        // Before Insert Logic
        //
        if(Trigger.isInsert && Trigger.isBefore) {
            //Handler.OnBeforeInsert(Trigger.new);
            //AccountContact_Primary_Financial.onlyONEPrimary(Trigger.new);
            // Smark 08/05/2015
            // Fix RD-00287
            if(!bypass.Disable_Triggers__c){
            AccountContact_Primary_Financial.checkPrimaryAndFinancialFlags(Trigger.new);
            }
        }
        // After Insert Logic
        //
        else if(Trigger.isInsert && Trigger.isAfter) {
            if(checkRecurssion.runOnce())
                Handler.OnAfterInsert(Trigger.new);
            // Smark 08/05/2015
            // Fix RD-00287
            if(!bypass.Disable_Triggers__c){
            primarycheckonAccountContact.togglePrimaryAndFinancialFlags(Trigger.new, NULL);
            }
        }
        // Before Update Logic
        //
        else if(Trigger.isUpdate && Trigger.isBefore) {
            // Handler.OnBeforeUpdate(Trigger.old, Trigger.new, Trigger.newMap);
            // AccountContact_Primary_Financial.onlyONEPrimary(Trigger.new);
            // Smark 08/05/2015
            // Fix RD-00287
            if(!bypass.Disable_Triggers__c){
            AccountContact_Primary_Financial.checkPrimaryAndFinancialFlags(Trigger.new);
            }
        }
        // After Update Logic
        //
        else if(Trigger.isUpdate && Trigger.isAfter) {
            // Smark 08/05/2015
            // Fix RD-00287
            //primarycheckonAccountContact.updateContact(trigger.new,trigger.old);
            System.debug('IN AFTER UPDATE 1');
            if(!bypass.Disable_Triggers__c){
            primarycheckonAccountContact.togglePrimaryAndFinancialFlags(Trigger.new, Trigger.oldMap);
            }
            
            if(checkRecurssion.runOnce())
                Handler.OnAfterUpdate(Trigger.old, Trigger.new, Trigger.newMap, Trigger.oldMap);
        }
        // Before Delete Logic
        //
        else if(Trigger.isDelete && Trigger.isBefore) {
            if(checkRecurssion.runOnce())
                Handler.OnBeforeDelete(Trigger.old, Trigger.oldMap);
        }
        // After Delete Logic
        //
        else if(Trigger.isDelete && Trigger.isAfter) {
            if(checkRecurssion.runOnce())
                Handler.OnAfterDelete(Trigger.old, Trigger.oldMap);
        }
        // After Undelete Logic
        //
        else if(Trigger.isUnDelete) {
            if(checkRecurssion.runOnce())
                Handler.OnUndelete(Trigger.new);
        }
    //}
}