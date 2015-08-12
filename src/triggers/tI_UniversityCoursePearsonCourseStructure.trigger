trigger tI_UniversityCoursePearsonCourseStructure on UniversityCoursePearsonCourseStructure__c (before insert) {
 Set<Id> PearsonCourseStructureIds = new Set<Id> ();
 List<UniversityCoursePearsonCourseStructure__c> UniversityCoursePearsonCourseStructure = 
    new List<UniversityCoursePearsonCourseStructure__c> ();
 Map <String, UniversityCoursePearsonCourseStructure__c> UniversityCoursePearsonCourseStructureMap = 
   new Map<String, UniversityCoursePearsonCourseStructure__c> ();
 
 if (Trigger.isInsert) {    
  for (UniversityCoursePearsonCourseStructure__c i :Trigger.new) {
      PearsonCourseStructureIds.Add (i.PearsonCourseStructure__c);
  }
 
  //Get the list of univeristy course for the list of pearson course str ids
  List<UniversityCoursePearsonCourseStructure__c> UniversityCoursePearsonCourseStructureInDB = 
     [select UniversityCourse__c, PearsonCourseStructure__c
             from UniversityCoursePearsonCourseStructure__c where PearsonCourseStructure__c = :PearsonCourseStructureIds];
        
   for (UniversityCoursePearsonCourseStructure__c i : UniversityCoursePearsonCourseStructureInDB) {
       UniversityCoursePearsonCourseStructureMap.put(i.UniversityCourse__c+'-'+i.PearsonCourseStructure__c, 
         new UniversityCoursePearsonCourseStructure__c (
                  UniversityCourse__c = i.UniversityCourse__c,
                  PearsonCourseStructure__c = i.PearsonCourseStructure__c) );         
  }
     
  //check if the univeristy course contact record is being duplicated.
   for (UniversityCoursePearsonCourseStructure__c UniversityCoursePearsonCourseStructureChk : Trigger.new) {
     if (UniversityCoursePearsonCourseStructureMap.containsKey(UniversityCoursePearsonCourseStructureChk.UniversityCourse__c + '-' + 
            UniversityCoursePearsonCourseStructureChk.PearsonCourseStructure__c)) {
         UniversityCoursePearsonCourseStructureChk.addError ('Pearson Course exists for this University Course');
         //HEUK_GlobalMessages__c msg = HEUK_GlobalMessages__c.getOrgDefaults();
         //UniversityCoursePearsonCourseStructureChk.addError ( (String)msg.Duplicate_Univ_Course_Pearson_Course_Str__c == null?
         //  (String)msg.Duplicate_Univ_Course_Pearson_Course_Str__c:'Pearson Course exists for University Course' );
     }
   }      
 }
}