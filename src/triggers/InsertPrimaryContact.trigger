/*Author: Steven M. Giangrasso
Date: April 2nd, 2012
Description: This trigger updates the Primary Contact (Custom field) on the Opportunity.  The Trigger is bulkified to handle more than 20 updates to 
the Opportunity object at the same time
*/

//Trigger is fired everytime Opportunity Record is updated
trigger InsertPrimaryContact on Opportunity(before update) {
/* AA (Deloitte) - Deactivated as UK Users not onboarded yet
 
 
//Hash set containing the ID's of the opportunities
set<id> oppids = new set<id>();

//Hash Map containing the contact id's needed in the contact role
Map<id,id> oppidcontactidmap = new map<id,id>();

//Enhanced For Loop that creates a Set of the Opportunities to be queried
    for(Opportunity o : Trigger.new){
 /*         
    if(o.CloseDate >= Date.today()){       */             
/* AA (Deloitte) - Deactivated as UK Users not onboarded yet
 
           oppids.add(o.id);
          
   /* }*/
/* AA (Deloitte) - Deactivated as UK Users not onboarded yet
 
     }*/
/* AA (Deloitte) - Deactivated as UK Users not onboarded yet
 
 
    //Create an object for the OpportunityContactRole to query all the contacts where the contact is set to Primary on the Contact Role
    //Use the List from the Java Collections library
  List<OpportunityContactRole> contactRoles = new List<OpportunityContactRole>();
            
    //SOQL query to return the contactID for the Primary Role of the OpportunityContactRole
    contactRoles = [Select ContactID, Contact.Name, OpportunityID from OpportunityContactRole where isPrimary = true and OpportunityID in :oppids];
            
    for(OpportunityContactrole ocr:contactRoles){
      oppidcontactidmap.put(ocr.OpportunityId,ocr.ContactId);
    }
         
    for(Opportunity o : Trigger.new){
      
    //If condition verifies that there is a contact Role assigned to this Opportunity
        if(oppidcontactidmap.get(o.id) != null)        
        {
            //Assign the custom Contact__c field to the contact ID related to the contactRole of the opportunity
            o.Primary_Contact__c = oppidcontactidmap.get(o.id);
        }    
    }*/           
 }