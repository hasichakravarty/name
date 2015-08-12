//Trigger is fired everytime Opportunity Record is inserted or updated
trigger InsertAMUserForecastOnOpportunity on Opportunity(before insert, before update) {
/* AA (Deloitte) - Deactivated as UK Users not onboarded yet
 
 
//Hash set containing the ID's of the opportunities
set<id> OppOwnerUserIds = new set<id>();
Map <Id,Id> oppsWithAMsUserIdUserForecastIdMap = new Map <Id,Id>();

//Enhanced For Loop that creates a Set of the Opportunities Owner user ids to query the user forecast object
    for(Opportunity o : Trigger.new){
          OppOwnerUserIds.add(o.ownerid);
    }

    //Instantiate the UserForecast custom object to put the Username and Id in the ufList
    List<UserForecast__c> ufList = new List<UserForecast__c>();
    //SOQL query to return the Id from the UserForecast where the User is the Account Manager/Opportunity Owner
    ufList = [Select Id, User__c from UserForecast__c where User__c in :OppOwnerUserIds];
    for(UserForecast__c uf:ufList){
        //Put the UserID and UserForecast Id in the Map
      oppsWithAMsUserIdUserForecastIdMap.put(uf.User__c,uf.Id);
    }
    
    //Loop through the opportunity records and assign the AM user forecast id corresponding to the opty owner
    for(Opportunity opp: Trigger.new){
            if(oppsWithAMsUserIdUserForecastIdMap.get(opp.ownerid) != null) {
                opp.AM_User_Forecast__c = oppsWithAMsUserIdUserForecastIdMap.get(opp.ownerid);
            }
            else {
                opp.AM_User_Forecast__c = null;            
            }        
    }
    */
 }