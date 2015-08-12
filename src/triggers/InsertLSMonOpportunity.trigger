/*
    *Author: Steven M. Giangrasso
    *Date: August 22nd, 2012
    *Description: This trigger updates the Learning Solutions Manager (Custom field) on the Opportunity.  
    *The Trigger is bulkified to handle more than 20 updates to the Opportunity object at the same time
*/

//Trigger is fired everytime Opportunity Record is updated
trigger InsertLSMonOpportunity on Opportunity(before update) {
/* AA (Deloitte) - Deactivated as UK Users not onboarded yet
 
 
//Hash set containing the ID's of the opportunities
set<id> oppids = new set<id>();

//Hash Map containing the user id's needed in the Opportunity Team Member Role
Map<id,id> oppiduseridmap = new map<id,id>();

//Enhanced For Loop that creates a Set of the Opportunities to be queried
    for(Opportunity o : Trigger.new){         
/* Removed the CloseDate Condition as per Sharon Maidment Request on 10th July, 2013. Reference Ticket# INC0311503                      
    if(o.CloseDate >= Date.today()){ */
/* AA (Deloitte) - Deactivated as UK Users not onboarded yet
 
           oppids.add(o.id);
    }
    

    //Create an object for the OpportunityTeamMembers to query all the contacts where the TeamMemberRole is set to 
    //Use the List from the Java Collections library
  List<OpportunityTeamMember> lsmMember = new List<OpportunityTeamMember>();
            
    //SOQL query to return the UserID from the OpportunityTeamMember where the Role is the Learning Solutions Manager
    lsmMember = [Select UserID, OpportunityID from OpportunityTeamMember where teammemberrole = 'Learning Solutions' and OpportunityID in :oppids];
            
       //Enhanced For Loop to loop through the OpportunityTeamMember id's
    for(OpportunityTeamMember ocr:lsmMember){
        //Put the UserID on the OpportunityTeamMember role into the Mash Map
      oppiduseridmap.put(ocr.OpportunityId,ocr.UserId);
    }
         
      //Enhanced For Loop to loop through the Opportunities
    for(Opportunity o : Trigger.new){
      
        //If condition verifies that there is a OpportunityTeamMember Role assigned to this Opportunity
        if(oppiduseridmap.get(o.id) != null)        
        {
            //Assign the custom Learning Solutions Manager field to the UserID related to the OpportunityTeamMember 
            o.Learning_Solutions_Manager__c = oppiduseridmap.get(o.id);
        }    
    }    
    
    //Begin RNP changes
    //For all Opportunities with an LSM, populate User_Forecast__c
    //Hash set containing the ID's of the opportunities
    set<id> userids = new set<id>();
    map<id,id> oppsWithLSMsUserIdUserForecastIdMap = new map<id,id>();
    for(Opportunity opp: Trigger.new){
        if(opp.Learning_Solutions_Manager__c != null){                    
            userids.add(opp.Learning_Solutions_Manager__c);
        }
    }
    
    //Instantiate the UserForecast custom object to put the Username and Id in the ufList
    List<UserForecast__c> ufList = new List<UserForecast__c>();
    //SOQL query to return the Id from the UserForecast where the User is the Learning Solutions Manager
    ufList = [Select Id, User__c from UserForecast__c where User__c in :userids];
    for(UserForecast__c uf:ufList){
        //Put the UserID and UserForecast Id in the Map
      oppsWithLSMsUserIdUserForecastIdMap.put(uf.User__c,uf.Id);
    }

  
    for(Opportunity opp: Trigger.new){
        if(opp.Learning_Solutions_Manager__c != null){ 
            if(oppsWithLSMsUserIdUserForecastIdMap.get(opp.Learning_Solutions_Manager__c) != null) {
                opp.User_Forecast__c = oppsWithLSMsUserIdUserForecastIdMap.get(opp.Learning_Solutions_Manager__c);
            } else {
            //Instead of creating the missing User Forecast record here, rely on a separate trigger on User that ensures all Users have a User Forecast record.
            }                
        }
    }
    //End RNP Changes
    
    */
 }