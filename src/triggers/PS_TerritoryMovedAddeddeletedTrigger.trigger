trigger PS_TerritoryMovedAddeddeletedTrigger on Territory2 (after delete, before Insert, before update) {
    PS_TerritoryMovedAddeddeletedHandler handler = new PS_TerritoryMovedAddeddeletedHandler();
    if(trigger.isInsert){
        PS_TerritoryMovedAddeddeletedHandler.TerritoryAction = 1;
        handler.territoryAddedNotification(trigger.new,null);
    }
    if(trigger.isDelete){
        PS_TerritoryMovedAddeddeletedHandler.TerritoryAction = 2;
        handler.territoryAddedNotification(trigger.old,null);
    }
    if(trigger.isupdate){
        PS_TerritoryMovedAddeddeletedHandler.TerritoryAction = 3;
        List<Territory2> newTrList = new List<Territory2>();
        for(Territory2 tr: trigger.new){
            // when Parent Territory field is updating add those records in newTrList list so that territoryAddedNotification method will be called only when Territory will move to other territory.
            if(tr.ParentTerritory2Id != trigger.oldMap.get(tr.Id).ParentTerritory2Id)
                newTrList.add(tr);
        }
        if(newTrList != null){
            handler.territoryAddedNotification(newTrList,trigger.oldMap);
        }
    }
}