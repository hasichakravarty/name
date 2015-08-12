global class BatchUpdateCourses_Frontlists implements Database.Batchable<sObject>,Database.Stateful,Schedulable
{
    
    global set<id> setOfCourseIds = new set<id>();
    global String finalstr = 'Course ID, Course Name, Failure Reason \n';
        
    //setOfCourseIds.add('a0F11000003F1Rr');
    //setOfCourseIds.add('a0F11000004uMlU');
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([SELECT id,Spring_Front_List__c ,Fall_Front_List__c,
                                        (SELECT Name,Pearson_Course_Code__c,Course__c,Course__r.Spring_Front_List__c,Course__r.Fall_Front_List__c,Pearson_Course_Code__r.Current_Period__c,Pearson_Course_Code__r.Prior_Period__c,Pearson_Course_Code__r.Region__c FROM Pearson_Course_Equivalent__r
                                                                where (Pearson_Course_Code__r.Current_Period__c = true OR Pearson_Course_Code__r.Prior_Period__c=true) AND Pearson_Course_Code__r.Region__c='US')
                                        from UniversityCourse__c]);
    }
    global void execute(Database.BatchableContext BC, List<UniversityCourse__c> lstCourse)
    {
    try
    { 
    //UniversityCourse__c courseObj = lstCourse[0];
    list<UniversityCourse__c> listOfcourseObj = new list<UniversityCourse__c>();
    listOfcourseObj = lstCourse;
    for(UniversityCourse__c courseObj : listOfcourseObj){
        boolean priorCheck = false;
        boolean currentCheck = false;
        if(courseObj.Pearson_Course_Equivalent__r.size() > 0){
           //integer iMonth = 4;
           integer iMonth = system.today().month(); 
           for(Pearson_Course_Equivalent__c  pearson_equivalent : courseObj.Pearson_Course_Equivalent__r){
                if((pearson_equivalent.Pearson_Course_Code__r.Current_Period__c == true || pearson_equivalent.Pearson_Course_Code__r.Prior_Period__c == true)
                   && (iMonth == 11 || iMonth == 12 ||   iMonth == 1 ||   iMonth == 2 ||   iMonth == 3 ||   iMonth == 4) 
                   && pearson_equivalent.Pearson_Course_Code__r.Region__c != null && pearson_equivalent.Pearson_Course_Code__r.Region__c == 'US'){
                    
                    if(pearson_equivalent.Pearson_Course_Code__r.Prior_Period__c == true){
                       courseObj.Fall_Front_List__c = true;  
                       courseObj.Spring_Front_List__c = false;
                       priorCheck = true;
                    }else{
                       currentCheck = true;
                       courseObj.Spring_Front_List__c = true;
                       courseObj.Fall_Front_List__c = false;  
                    }    

                    if(pearson_equivalent.Pearson_Course_Code__r.Prior_Period__c == true && pearson_equivalent.Pearson_Course_Code__r.Current_Period__c == true){
                        currentCheck = true;
                        priorCheck = true;
                    }           
                }else if((pearson_equivalent.Pearson_Course_Code__r.Current_Period__c == true || pearson_equivalent.Pearson_Course_Code__r.Prior_Period__c == true)
                       && (iMonth == 5 ||iMonth == 6 || iMonth == 7 ||   iMonth == 8 ||   iMonth == 9 || iMonth == 10 ) 
                       && pearson_equivalent.Pearson_Course_Code__r.Region__c != null && pearson_equivalent.Pearson_Course_Code__r.Region__c == 'US'){
                           
                           if(pearson_equivalent.Pearson_Course_Code__r.Prior_Period__c == true){
                                courseObj.Fall_Front_List__c = false;   
                                courseObj.Spring_Front_List__c = true;
                                priorCheck = true;
                           }else{
                              courseObj.Fall_Front_List__c = true;   
                              courseObj.Spring_Front_List__c = true;
                              currentCheck = true;
                           }
                           
                   if(pearson_equivalent.Pearson_Course_Code__r.Prior_Period__c == true && pearson_equivalent.Pearson_Course_Code__r.Current_Period__c == true){
                        currentCheck = true;
                        priorCheck = true;
                    }
                }
            }
        }else{
            courseObj.Spring_Front_List__c = false;
            courseObj.Fall_Front_List__c = false;
        }
        
        // if both check for same course 
        if(priorCheck && currentCheck){
            courseObj.Spring_Front_List__c = true;
            courseObj.Fall_Front_List__c = true;
        }
        system.debug('courseObjexception1===>>'+courseObj.id);
    }
    
    update listOfcourseObj;
  } catch(Exception e)
    {
    System.debug('Type: ' + e.getTypeName() + '\n' + 'Cause: ' + e.getCause() + '\n' + 'Message: ' 
    + e.getMessage() + '\n' + 'Line #: ' + e.getLineNumber() + '\n' + e.getStackTraceString()); 
    
     for(UniversityCourse__c courseObj : lstCourse){
        string recordString = '"'+courseObj.id+'","'+courseObj.Name+'","'+ e.getTypeName() +'-'+ e.getCause() + '-'+ e.getMessage()+'"\n';
        finalstr = finalstr + recordString;   
        sendEmailCheck = false;
        system.debug('courseObjexception===>>'+courseObj.id);
     }
     system.debug('sendEmailCheck  exception===>>'+sendEmailCheck );
    }
   }
   
   global boolean sendEmailCheck = true;
   global void execute(SchedulableContext sc) {
     database.executebatch(new BatchUpdateCourses_Frontlists());
     }
    
    global void finish(Database.BatchableContext BC){
           system.debug('finalstr===>>'+finalstr);
           system.debug('sendEmailCheck ===>>'+sendEmailCheck );
           if(!sendEmailCheck){
            system.debug('inside email===>>');
            AsyncApexJob a = [SELECT id, ApexClassId,
                       JobItemsProcessed, TotalJobItems,
                       NumberOfErrors, CreatedBy.Email
                       FROM AsyncApexJob
                       WHERE id = :BC.getJobId()];
            
            String subject = 'Course - Apex Batch Error List';
            String attName = 'Course Errors.csv';
             
            // Define the email
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage(); 
            
            // Create the email attachment    
            Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
            efa.setFileName(attName);
            efa.setBody(Blob.valueOf(finalstr));
            
            // Sets the paramaters of the email
            email.setSubject( subject );
            email.setToAddresses( new String[] {a.CreatedBy.Email} );
            email.setPlainTextBody('Please find the attachment of failure course records ');
            email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
 
            // Sends the email
            Messaging.SendEmailResult [] r = 
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});  
          }

    }
}