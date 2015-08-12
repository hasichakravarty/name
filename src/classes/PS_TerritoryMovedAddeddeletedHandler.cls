/* Handler class for TerritoryMovedAddeddeleted Trigger
Date: 2 June'2015 | Author: Accenture IDC
*/
public class PS_TerritoryMovedAddeddeletedHandler {
    // Value of TerritoryAction set in Trigger, For insert : 1, For Delete:2 and For Moved: 3.
    public Static integer TerritoryAction = 0;
    
    // When User Added to aTerritory then chatter post is added to already assigned users.
    public void territoryAddedNotification(List<Territory2> territoryList1, Map<Id,Territory2> territoryoldMap){
        User useradmin= [select Id, Name,Email,UserRoleId,UserRole.Name from User where 
        isactive=true and UserRole.Name =:System.Label.PS_TerritoryUserAdminRole limit 1];
       
        List<FeedItem> fiList = new List<FeedItem>();
        String msg = '';
        // Map of ParentTerritoryId and its name
        Map<ID,String> territoryMap = new Map<ID,String>(); 
        // Set of Parent Territories Ids.
        Set<Id> parentTerritoryIdList = new Set<Id>();
        for(Territory2 tr : territoryList1){
            parentTerritoryIdList.add(tr.ParentTerritory2Id);
            //territoryMap.put(tr.ParentTerritory2Id,tr.);
        }
        // List of Parent Territories name
        List<territory2> parentTerrList = [select name from Territory2 where Id IN: parentTerritoryIdList];
        for(Territory2 tr : parentTerrList){
            territoryMap.put(tr.Id,tr.name);
        }
        
        //for Territories moved. 
        if(territoryoldMap != null){
            // Set of old Parent Territory Ids which will be used to find name of old parent territories
            Set<Id> parentOldTerritoryIdList = new Set<Id>();
            for(Territory2 tr : territoryoldMap.values()){
                parentOldTerritoryIdList.add(tr.ParentTerritory2Id);
            }
            List<territory2> parentOfOldTerrList = [select name from Territory2 where Id IN: [select name from Territory2 where Id IN: parentOldTerritoryIdList]];
            for(Territory2 tr : parentOfOldTerrList){
                territoryMap.put(tr.Id,tr.name);
            }
        }
        //Map of Territory Model ID and its name
        Map<ID,String> territoryModelMap = new Map<ID,String>();
        Set<Id> TerritoryModelIdList = new Set<Id>();
        for(Territory2 tr : territoryList1){
            TerritoryModelIdList.add(tr.Territory2ModelId);
        }
        List<Territory2Model> TerritoryModelList = [select name from Territory2Model where Id IN: TerritoryModelIdList];
        for(Territory2Model tm : TerritoryModelList){
            territoryModelMap.put(tm.Id,tm.name);
        }
        if(useradmin != null){
        for(Territory2 tr : territoryList1){
            system.debug('record of trigger.new-->'+tr);
            FeedItem post = new FeedItem();
            post.ParentId = useradmin.Id; 
            msg = 'Attention '+ useradmin.Name+', \n You are receiving this notification because you are assigned as the '+useradmin.UserRole.Name +'.';
            if(TerritoryAction == 1){
                msg += '\n \n Please be aware that '+ tr.Name +' was newly created';
                if(tr.ParentTerritory2Id != null){
                    msg += ' as a child territory of '+territoryMap.get(tr.ParentTerritory2Id);
                }
                msg += ' and can be seen in the ' + territoryModelMap.get(tr.Territory2ModelId) + ' territory hierarchy .';
            }
            else if(TerritoryAction == 2){
                msg += '\n \n Please be aware that '+ tr.Name;
                if(tr.ParentTerritory2Id != null){
                    msg += ' which was a child territory of  '+territoryMap.get(tr.ParentTerritory2Id);
                }
                msg += ' has been deleted from the ' + territoryModelMap.get(tr.Territory2ModelId) + ' territory hierarchy .';
            }
            else if(TerritoryAction == 3){
                msg += '\n \n Please be aware that '+ tr.Name;
                if(territoryoldMap.get(tr.Id).ParentTerritory2Id != null){
                    msg += ' which was recently a child territory of '+ territoryMap.get(territoryoldMap.get(tr.Id).ParentTerritory2Id);
                }
                if(tr.ParentTerritory2Id != null){
                    msg += ' has been moved and is now a child territory to  '+territoryMap.get(tr.ParentTerritory2Id);
                }
                msg += ' and can be seen in the ' + territoryModelMap.get(tr.Territory2ModelId) + ' territory hierarchy .';
            }
           // msg += '\n \n If you believe this territory addition is incorrect or that you are receiving this message in error, please contact your manager';
            //msg += '\n \n Thank you for your support and remember we are Always Learning! ';
            post.Body = msg;
            post.CreatedDate = System.now();
            system.Debug('Post feed---'+post);
            //insert post;
            fiList.add(post);
        }
        }
        if(fiList.size() > 0 && fiList.size() < 150){
            try{
            insert fiList;
            }
            catch(DMLException e){
                throw(e);
            }
        }
    }
}