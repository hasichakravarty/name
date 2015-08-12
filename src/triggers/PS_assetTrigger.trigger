trigger PS_assetTrigger on Asset (before insert, before update) {

    Bypass_Settings__c bypass = Bypass_Settings__c.getInstance();
    AssetTriggerHandler handler = new AssetTriggerHandler();
    List<Asset> asList = new List<Asset>();
    
    if(trigger.isUpdate)
    {
        if (trigger.New.size() == 1 && checkRecurssionBefore.runOnce('PS_assetTrigger','Update'))
            handler.primaryContactv2(trigger.New[0]);
       /* for(Asset ast : trigger.New){
            if(ast.Primary__c == true && ast.Primary__c != trigger.oldMap.get(ast.id).Primary__c)
            asList.add(ast);
        }*/
        
    }
    if(trigger.isInsert)
    {
        if (trigger.New.size() == 1 && checkRecurssionBefore.runOnce('PS_assetTrigger','Insert'))
            handler.primaryContactv2(trigger.New[0]);
       /* for(Asset ast : trigger.New){
            if(ast.Primary__c == true && ast.Primary__c != trigger.oldMap.get(ast.id).Primary__c)
            asList.add(ast);
        }*/
        
    }    
    
}