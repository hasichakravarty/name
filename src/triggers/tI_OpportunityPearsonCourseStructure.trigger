trigger tI_OpportunityPearsonCourseStructure on OpportunityPearsonCourseStructure__c (before insert) {
 Set<Id> PearsonCourseStrIds = new Set<Id> ();
 List<OpportunityPearsonCourseStructure__c> OpportunityPearsonCourseStr = new List<OpportunityPearsonCourseStructure__c> ();
 Map <String, OpportunityPearsonCourseStructure__c> OpportunityPearsonCourseStrMap = new Map<String, OpportunityPearsonCourseStructure__c> ();
 
 if (Trigger.isInsert) {    
  for (OpportunityPearsonCourseStructure__c i :Trigger.new) {
      PearsonCourseStrIds.Add (i.Pearson_Course_Structure__c);
  }
 
  //Get the list of pearson course structure opportunity for the list of product ids
  List<OpportunityPearsonCourseStructure__c> OptyPearsonCourseStrInDB = [select Opportunity__c, Pearson_Course_Structure__c
             from OpportunityPearsonCourseStructure__c where Pearson_Course_Structure__c = :PearsonCourseStrIds];
        
   for (OpportunityPearsonCourseStructure__c i : OptyPearsonCourseStrInDB) {
       OpportunityPearsonCourseStrMap.put(i.Opportunity__c+'-'+i.Pearson_Course_Structure__c, 
               new OpportunityPearsonCourseStructure__c (
                  Opportunity__c = i.Opportunity__c,
                  Pearson_Course_Structure__c = i.Pearson_Course_Structure__c) );         
  }
     
  //check if the pearson course structure opportunity record is being duplicated.
   for (OpportunityPearsonCourseStructure__c OptyPearsonCourseStrChk : Trigger.new) {
     if (OpportunityPearsonCourseStrMap.containsKey(OptyPearsonCourseStrChk.Opportunity__c + '-' 
            + OptyPearsonCourseStrChk.Pearson_Course_Structure__c)) {
       OptyPearsonCourseStrChk.addError ('Pearson Course exists for Opportunity');
       //HEUK_GlobalMessages__c msg = HEUK_GlobalMessages__c.getOrgDefaults();
       //OptyPearsonCourseStrChk.addError ( (String)msg.Duplicate_Opty_Pearson_Course_Str_Msg__c );       
     }
   }      
 }

}