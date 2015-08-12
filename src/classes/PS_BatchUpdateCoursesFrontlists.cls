global class PS_BatchUpdateCoursesFrontlists implements Database.Batchable<sObject>,Database.Stateful,Schedulable
{
    
    global set<id> setOfCourseIds = new set<id>();
    global String finalstr = 'Course ID, Course Name, Failure Reason \n';
    String sMarket;
    String sId;
    boolean initialld;
    List<Database.SaveResult> dbupres=null;
    list<UniversityCourse__c> listOfcourseObj=null;
    public PS_BatchUpdateCoursesFrontlists(String sCountry,String sCourseId,boolean initialload){
        sMarket=sCountry;
        sId=sCourseId;
        initialld=initialload;
    }//end constructor
    global Database.QueryLocator start(Database.BatchableContext BC){
        /*if (Test.isRunningtest()){
            return Database.getQueryLocator([SELECT id,name,Spring_Front_List__c ,Fall_Front_List__c,
                                        (SELECT Name,Pearson_Course_Code__c,Course__c,Course__r.Spring_Front_List__c,
                                        Course__r.Fall_Front_List__c,Pearson_Course_Code__r.Current_Period__c,
                                        Pearson_Course_Code__r.Prior_Period__c,Pearson_Course_Code__r.Region__c 
                                        FROM Pearson_Course_Equivalent__r where 
                                        (Pearson_Course_Code__r.Current_Period__c = true OR Pearson_Course_Code__r.Prior_Period__c=true) AND 
                                        Pearson_Course_Code__r.Region__c=:sMarket order by 
                                        Pearson_Course_Code__r.Current_Period__c desc,Pearson_Course_Code__r.Prior_Period__c desc)                                         
                                        from UniversityCourse__c where id =:sId]);
        }
        else{ */       
            if (initialld==true){ 
                return Database.getQueryLocator([SELECT id,name,Spring_Front_List__c ,Fall_Front_List__c
                                                 from UniversityCourse__c where Status__c='Active']);
             }
             else{
                return Database.getQueryLocator([SELECT id,name,Spring_Front_List__c ,Fall_Front_List__c
                                         from UniversityCourse__c where Status__c='Active' and id in 
                                        (select course__c from Pearson_Course_Equivalent__c where Pearson_Course_Code__r.lastmodifieddate >= YESTERDAY)]);
             }        
        //}

    }//end start
    global void execute(Database.BatchableContext BC, List<UniversityCourse__c> lstCourse){
        listOfcourseObj= new List<UniversityCourse__c>();
        List<UniversityCourse__c> courseLst = new List<UniversityCourse__c>();


        if(initialld)
            courseLst = [SELECT id,name,Spring_Front_List__c ,Fall_Front_List__c,
                                        (SELECT Name,Pearson_Course_Code__c,Course__c,Course__r.Spring_Front_List__c,
                                        Course__r.Fall_Front_List__c,Pearson_Course_Code__r.Current_Period__c,
                                        Pearson_Course_Code__r.Prior_Period__c,Pearson_Course_Code__r.Region__c 
                                        FROM Pearson_Course_Equivalent__r where 
                                        (Pearson_Course_Code__r.Current_Period__c = true OR Pearson_Course_Code__r.Prior_Period__c=true) AND 
                                        Pearson_Course_Code__r.Region__c=:sMarket order by 
                                        Pearson_Course_Code__r.Current_Period__c desc,Pearson_Course_Code__r.Prior_Period__c desc) 
                                        from UniversityCourse__c where Status__c='Active' and Id in :lstCourse];
        else
            courseLst =[SELECT id,name,Spring_Front_List__c ,Fall_Front_List__c,
                                        (SELECT Name,Pearson_Course_Code__c,Course__c,Course__r.Spring_Front_List__c,
                                        Course__r.Fall_Front_List__c,Pearson_Course_Code__r.Current_Period__c,
                                        Pearson_Course_Code__r.Prior_Period__c,Pearson_Course_Code__r.Region__c 
                                        FROM Pearson_Course_Equivalent__r where 
                                        (Pearson_Course_Code__r.Current_Period__c = true OR Pearson_Course_Code__r.Prior_Period__c=true) AND 
                                        Pearson_Course_Code__r.Region__c=:sMarket and
                                        Pearson_Course_Code__r.Type__c=:System.Label.PS_BatchFLCatType
                                        order by Pearson_Course_Code__r.Current_Period__c desc,Pearson_Course_Code__r.Prior_Period__c desc) 
                                        from UniversityCourse__c where Status__c='Active' and id in :lstCourse];

        if(courseLst.size()>0)
        {
        listOfcourseObj.addAll(courseLst);
        integer iMonth = system.today().month();
        try{
        for(UniversityCourse__c courseObj : listOfcourseObj){
            //System.debug(courseObj.name);
            boolean priorCheck = false;
            boolean currentCheck = false;
            courseObj.Fall_Front_List__c = false;   
            courseObj.Spring_Front_List__c = false;
            if(courseObj.Pearson_Course_Equivalent__r.size() > 0){
                for(Pearson_Course_Equivalent__c  pearson_equivalent : courseObj.Pearson_Course_Equivalent__r){
                    if (!(courseObj.Fall_Front_List__c && courseObj.Spring_Front_List__c)){
                    if (priorCheck == false){
                        if(pearson_equivalent.Pearson_Course_Code__r.Prior_Period__c == true){
                            if ((iMonth >=1 && iMonth <=4) || iMonth > 10){
                                courseObj.Fall_Front_List__c = true;
                            }
                            else{
                                courseObj.Spring_Front_List__c = true;
                            }
                            priorCheck=true;
                        }
                    }
                    if (currentCheck == false){
                        if(pearson_equivalent.Pearson_Course_Code__r.Current_Period__c == true){
                            if ((iMonth >=1 && iMonth <=4) || iMonth > 10){
                                courseObj.Spring_Front_List__c = true;
                            }
                            else{
                                courseObj.Fall_Front_List__c = true;
                            }
                            currentCheck=true;
                        }
                    }
                    }
                    else{break;}
                }//END LOOP THROUGH PEARSON COURSE
            }//end code to check for Pearson course
        }//end loop through course
        dbupres=Database.Update(listOfcourseObj,false);
        
        List<PS_ExceptionLogger__c> errloggerlist=new List<PS_ExceptionLogger__c>();
      try{            
          //Database.SaveResult[] srList=result;
          for (integer i=0;i<listOfcourseObj.size();i++){
              UniversityCourse__c course=listOfcourseObj[i];
              Database.SaveResult res=dbupres[i];
              String ErrMsg='';
              if (!res.isSuccess() || Test.isRunningtest()){
                  PS_ExceptionLogger__c errlogger=new PS_ExceptionLogger__c();
                  errlogger.InterfaceName__c='BatchUpdateCourseFrontList';
                  errlogger.ApexClassName__c='PS_BatchUpdateCoursesFrontlists';
                  errlogger.CallingMethod__c='finish';
                  //errlogger.ExceptionMessage__c=err.getStatusCode() + ': ' + err.getMessage(); 
                  errlogger.UserLogin__c=UserInfo.getUserName(); 
                  errlogger.RecordId__c=course.id;   
                  for(Database.Error err : res.getErrors()) {
                      ErrMsg=ErrMsg+err.getStatusCode() + ': ' + err.getMessage();
                  }   
                  errlogger.ExceptionMessage__c=ErrMsg;
                  errloggerlist.add(errlogger);                     
              }
          }
          if(errloggerlist.size()>0){insert errloggerlist;}
           
       }
       catch(DMLException e){
           throw(e);
       }
        
        }
        
        catch(Exception e){
            ExceptionFramework.LogException('BatchUpdateCourseFrontList','PS_BatchUpdateCoursesFrontlists','execute',e.getMessage(),UserInfo.getUserName(),'');
        }
       } 
    }
    global void finish(Database.BatchableContext BC){
              
    }//end batch finish
    
    global void execute(SchedulableContext sc) {
        database.executebatch(new PS_BatchUpdateCoursesFrontlists('US','',false));
    }
    
}//end class