trigger tI_UniversityContact on UniversityCourseContact__c (before insert) {

 Set<Id> ContactIds = new Set<Id> ();
 List<UniversityCourseContact__c> UniversityContact = new List<UniversityCourseContact__c> ();
 Map <String, UniversityCourseContact__c> UnivContactMap = new Map<String, UniversityCourseContact__c> ();
 
 if (Trigger.isInsert) {    
  for (UniversityCourseContact__c i :Trigger.new) {
      ContactIds.Add (i.Contact__c);
  }
 
  //Get the list of univeristy course contact for the list of product ids
  List<UniversityCourseContact__c> UnivContactInDB = [select UniversityCourse__c, Contact__c
             from UniversityCourseContact__c where Contact__c = :ContactIds];
        
   for (UniversityCourseContact__c i : UnivContactInDB) {
       UnivContactMap.put(i.UniversityCourse__c+'-'+i.Contact__c, new UniversityCourseContact__c (
                  UniversityCourse__c = i.UniversityCourse__c,
                  Contact__c = i.Contact__c) );         
  }
     
  //check if the univeristy course contact record is being duplicated.
   for (UniversityCourseContact__c UnivContactChk : Trigger.new) {
     if (UnivContactMap.containsKey(UnivContactChk.UniversityCourse__c + '-' + UnivContactChk.Contact__c)) {
         UnivContactChk.addError ('Contact exists for this University Course');
        //HEUK_GlobalMessages__c msg = HEUK_GlobalMessages__c.getOrgDefaults();
         //UnivContactChk.addError ( (String)msg.Duplicate_University_Course_Contact_Msg__c );       
     }
   }      
 }
}