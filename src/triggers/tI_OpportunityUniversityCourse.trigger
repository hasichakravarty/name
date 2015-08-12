trigger tI_OpportunityUniversityCourse on OpportunityUniversityCourse__c (before insert) {
  Set <Id> univcourseids = new Set<Id>();
  Set <String> OpportunityPearsonCourseComboIDs = new Set<String>();
  Set<Id> OpportunityIds  = new Set<Id>();
  Integer count = 0;
  Map <String, OpportunityPearsonCourseStructure__c> m = new Map <String,OpportunityPearsonCourseStructure__c> ();
  Map <String, OpportunityUniversityCourse__c> OptyUnivCourseMap = new Map <String,OpportunityUniversityCourse__c> ();
  
  List <OpportunityPearsonCourseStructure__c> optypearsoncourses = new List<OpportunityPearsonCourseStructure__c>();
  List <OpportunityPearsonCourseStructure__c> optypearsoncourses_new = new List<OpportunityPearsonCourseStructure__c>();
  Boolean dup_found = False;
  
  if (Trigger.isInsert && Trigger.isBefore) {      
      /*Get the unique list of university courses linked to the opportunity*/
      for (OpportunityUniversityCourse__c optyunivcrs: Trigger.new) {
        univcourseids.Add (optyunivcrs.UniversityCourse__c);
        OpportunityIds.Add (optyunivcrs.Opportunity__c);
      }
      

      //Get the list of opportunity university course records
      List <OpportunityUniversityCourse__c> OptyUnivCourseInDB = [select UniversityCourse__c, Opportunity__c
             from OpportunityUniversityCourse__c where UniversityCourse__c in :univcourseids];
        
       for (OpportunityUniversityCourse__c i : OptyUnivCourseInDB) {
           OptyUnivCourseMap.put(i.UniversityCourse__c+'-'+i.Opportunity__c, new OpportunityUniversityCourse__c (
                      UniversityCourse__c = i.UniversityCourse__c,
                      Opportunity__c = i.Opportunity__c) );         
      }
         
      //check if the univeristy course opportunity record is being duplicated.
       for (OpportunityUniversityCourse__c OptyUnivCourseChk : Trigger.new) {
         if (OptyUnivCourseMap.containsKey(OptyUnivCourseChk.UniversityCourse__c + '-' + OptyUnivCourseChk.Opportunity__c)) {
           OptyUnivCourseChk.addError ('Opportunity exists for this University Course');
           //HEUK_GlobalMessages__c msg = HEUK_GlobalMessages__c.getOrgDefaults();           
           //OptyUnivCourseChk.addError ((String)msg.Duplicate_Opty_University_Course_Msg__c);
           dup_found = true;
         }
       }      
  
     if (dup_found == False) {
          /*Get all the pearson course structures linked to the university courses from above set*/
          List<UniversityCoursePearsonCourseStructure__c> univcoursepearsoncourses = new List <UniversityCoursePearsonCourseStructure__c> (
            [select UniversityCourse__c,PearsonCourseStructure__c from UniversityCoursePearsonCourseStructure__c 
              where UniversityCourse__c in :univcourseids]);
          
          /* For each opportunity course record, look up the university course to pearson course structure
            and link the opportunity to the pearson code structure*/   
          for (OpportunityUniversityCourse__c optyunivcrs: Trigger.new) {
            for (UniversityCoursePearsonCourseStructure__c univpearsoncrs :univcoursepearsoncourses) {
               if (optyunivcrs.UniversityCourse__c == univpearsoncrs.UniversityCourse__c) {
                 if (!m.containsKey(optyunivcrs.Opportunity__c+'-'+univpearsoncrs.PearsonCourseStructure__c)) {
                    m.put (optyunivcrs.Opportunity__c+'-'+univpearsoncrs.PearsonCourseStructure__c, 
                        new OpportunityPearsonCourseStructure__c (Opportunity__c = optyunivcrs.Opportunity__c,
                    Pearson_Course_Structure__c = univpearsoncrs.PearsonCourseStructure__c));
                 }
               }
            }
           }
           
            // get All the unique opty pearson course structure records
            optypearsoncourses = m.values();
            //Get the unique list of Opty ids
            OpportunityPearsonCourseComboIDs = m.keyset();
        
            // Get list of existing opty pearson course records in db
            List<OpportunityPearsonCourseStructure__c> exists_optypearsoncourses = new List<OpportunityPearsonCourseStructure__c> (
            [ select Opportunity__c,Pearson_Course_Structure__c from OpportunityPearsonCourseStructure__c 
              where Opportunity__c in :OpportunityIDs ]);
             
            //remove from the driver list, all opty pearson course records that are in db using above list
            for (OpportunityPearsonCourseStructure__c optypearsoncourses_2: optypearsoncourses ) {
               count = 0;
               for (OpportunityPearsonCourseStructure__c exists_optypearsoncourses_1 :exists_optypearsoncourses) {
                 if (optypearsoncourses_2.Opportunity__c == exists_optypearsoncourses_1.Opportunity__c &&
                     optypearsoncourses_2.Pearson_Course_Structure__c == exists_optypearsoncourses_1.Pearson_Course_Structure__c ) {                 
                    count = 1;
                    break;
                 }
               }
               //Opty pearson code record not in db so can be added
               if (count == 0) {
                    optypearsoncourses_new.Add (new OpportunityPearsonCourseStructure__c (Opportunity__c = optypearsoncourses_2.Opportunity__c,
                    Pearson_Course_Structure__c = optypearsoncourses_2.Pearson_Course_Structure__c
                    ));
               }         
            }        
          
           insert optypearsoncourses_new;
     } // end of dup_found check
  } /*end of test of before insert trigger*/           
}