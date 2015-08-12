/* ----------------------------------------------------------------------------------------------------------------------------------------------------------
   Name:            PS_CreateAssetbasedStudentRegistration.cls 
   Description:     On insert/update/delete of Opportunity record 
   Date             Version         Author                             Summary of Changes 
   -----------      ----------      -----------------    ---------------------------------------------------------------------------------------------------
  03/2015         1.0                Accenture IDC                          Initial Release 
                        
------------------------------------------------------------------------------------------------------------------------------------------------------------ */


/********** Created as per RD-00176 **************/

public with sharing class PS_createAssetbasedStudentRegistration{
 
     /***********creation of tasks**************/
   
    public static void createTask(List<Opportunity> OpptyList){
        system.debug('I am in create task method');
        Set<String> taskNamesList = new Set<String>{'Obtain Matric Indemnity = Complete',
                                                       'Obtain Student SA Medical Aid Subscription = Complete',
                                                       'Obtain Study Permit = Complete',
                                                       'Obtain Visa = Complete',
                                                       'Paid International Deposit = Complete',
                                                       'Paid 1st Month Instalment = Complete',
                                                       'Received Signed Enrolment Contract = Complete'
                                                   };                                                       
       
        List<Task> tskList = new List<Task>();
        ID recId = Schema.Sobjecttype.Task.getRecordTypeInfosByName().get('CTIMGI Task').getRecordTypeId();
        for(Opportunity o : opptyList){
            if(o.Type=='New Business' && o.International_Student_Status__c=='Yes'){
                Task tsk1 = new Task();
                tsk1.Status = 'Not Started';
                tsk1.WhatId = o.Id;
                tsk1.RecordTypeId = recId;
                tsk1.subject = 'Obtain Matric Certificate';
                tsk1.Auto_Generated__c = true;
                
                Task tsk2 = new Task();
                tsk2.Status = 'Not Started';                
                tsk2.WhatId = o.Id;
                tsk2.RecordTypeId = recId;
                tsk2.subject = 'Obtain Matric Indemnity';
                tsk2.Auto_Generated__c = true;
                
                Task tsk3 = new Task();
                tsk3.Status = 'Not Started';
                tsk3.WhatId = o.Id;
                tsk3.RecordTypeId = recId;
                tsk3.subject = 'Obtain Student SA Medical Aid Subscription';
                tsk3.Auto_Generated__c = true;
                
                Task tsk4 = new Task();
                tsk4.Status = 'Not Started';
                tsk4.WhatId = o.Id;
                tsk4.RecordTypeId = recId;
                tsk4.subject = 'Obtain Study Permit';
                tsk4.Auto_Generated__c = true;
                
                Task tsk5 = new Task();
                tsk5.Status = 'Not Started';
                tsk5.WhatId = o.Id;
                tsk5.RecordTypeId = recId;
                tsk5.subject = 'Obtain Visa';
                tsk5.Auto_Generated__c = true;
                
                Task tsk6 = new Task();
                tsk6.Status = 'Not Started';
                tsk6.WhatId = o.Id;
                tsk6.RecordTypeId = recId;
                tsk6.subject = ' Paid International Deposit';
                tsk6.Auto_Generated__c = true;
                
                Task tsk7 = new Task();
                tsk7.Status = 'Not Started';
                tsk7.WhatId = o.Id;
                tsk7.RecordTypeId = recId;
                tsk7.subject = 'Paid 1st Month Instalment';
                tsk7.Auto_Generated__c = true;
                
                Task tsk8 = new Task();
                tsk8.Status = 'Not Started';
                tsk8.WhatId = o.Id;
                tsk8.RecordTypeId = recId;
                tsk8.subject = 'Received Signed Enrolment Contract';
                tsk8.Auto_Generated__c = true;
                
                Task tsk9 = new Task();
                tsk9.Status = 'Not Started';
                tsk9.WhatId = o.Id;
                tsk9.RecordTypeId = recId;
                tsk9.subject = 'Obatin Copy of Student Passport';
                tsk9.Auto_Generated__c = true;
                
                tskList.add(tsk1);
                tskList.add(tsk2);
                tskList.add(tsk3);
                tskList.add(tsk4);
                tskList.add(tsk5);
                tskList.add(tsk6);
                tskList.add(tsk7);
                tskList.add(tsk8);
                tskList.add(tsk9);               
            }
            if(o.Type=='New Business' && o.International_Student_Status__c=='No'){
                Task tsk10 = new Task();
                tsk10.Status = 'Not Started';
                tsk10.WhatId = o.Id;
                tsk10.RecordTypeId = recId;
                tsk10.subject = 'Obtain Copy Matric Certificate';
                tsk10.Auto_Generated__c = true;
                
                Task tsk11 = new Task();
                tsk11.Status = 'Not Started';                
                tsk11.WhatId = o.Id;
                tsk11.RecordTypeId = recId;
                tsk11.subject = 'Obtain Copy of Sponsor SA ID';
                tsk11.Auto_Generated__c = true;
                
                Task tsk12 = new Task();
                tsk12.Status = 'Not Started';
                tsk12.WhatId = o.Id;
                tsk12.RecordTypeId = recId;
                tsk12.subject = 'Paid 1st Month Instalment';
                tsk12.Auto_Generated__c = true;
                
                Task tsk13 = new Task();
                tsk13.Status = 'Not Started';
                tsk13.WhatId = o.Id;
                tsk13.RecordTypeId = recId;
                tsk13.subject = 'Received Signed Enrolment Contract';
                tsk13.Auto_Generated__c = true;
                
                Task tsk14 = new Task();
                tsk14.Status = 'Not Started';
                tsk14.WhatId = o.Id;
                tsk14.RecordTypeId = recId;
                tsk14.subject = 'Obtain Copy of Student SA ID';
                tsk14.Auto_Generated__c = true;
                
                tskList.add(tsk10);
                tskList.add(tsk11);
                tskList.add(tsk12);
                tskList.add(tsk13);
                tskList.add(tsk14);           
            }               
        }
        if(!tskList.isEmpty()){
            insert tskList;
        }
    }
    
    /************creation of tasks and throughing validation as per RD-00176*******************/
    
    public static void OpportunityStage(Map<Id,Opportunity> optyMap,List<Opportunity> OpptyList,Map<Id,Opportunity> oldMapOpty){
       
        Set<String> taskNamesList = new Set<String>{'Obtain Matric Indemnity = Complete',
                                                       'Obtain Student SA Medical Aid Subscription = Complete',
                                                       'Obtain Study Permit = Complete',
                                                       'Obtain Visa = Complete',
                                                       'Paid International Deposit = Complete',
                                                       'Paid 1st Month Instalment = Complete',
                                                       'Received Signed Enrolment Contract = Complete'
                                                   };                                                       
       
        
        List<Opportunity> tempList = [select Id, StageName, AccountId , (select Id,Subject,Status, Auto_Generated__c from Tasks) from Opportunity where Id IN :OpptyList];
        
        set<id>accountset = new set<id>();
        for(Opportunity opp : tempList){
            accountset.add(opp.AccountId );            
        
        }
        
        List<Contract>contrlist = [select id,AccountId from Contract where AccountId in: accountset];
        Map<Id,List<Task>> tskMap = new Map<Id,List<Task>>();
        Map<Id,List<Contract>> ContractMap = new Map<Id,List<Contract>>();        
        
        for(Contract contr : contrlist){ 
            if(ContractMap.containsKey(contr.AccountId)){ 
                system.debug('In If-->'+ contr); 
                List<Contract> ctList = ContractMap.get(contr.AccountId); 
                ctList.add(contr); 
                ContractMap.put(contr.AccountId,ctList); 
            }ELSE{ 
                system.debug('In else-->'+ contr); 
                List<Contract> ctList = new List<Contract>(); 
                ctList.add(contr); 
                ContractMap.put(contr.AccountId,ctList); 
                 } 
        }

        
        for(Opportunity opp : tempList){
             tskMap.put(opp.Id,opp.Tasks);
            // ContractMap.put(opp.Id,opp.Contracts__r); 
        }
        
        
        for(Opportunity o : OpptyList){
            
            if(o.StageName == 'Closed'){
                 
                    for(Task tsk : tskMap.get(o.Id)){
                    
                    
                       if((tsk.Status!= 'Completed' || o.Academic_Vetting_Status__c!= 'Vetted - Approved') || ContractMap.get(o.AccountId) == null ){
                         
                           optyMap.get(o.Id).addError('In order to Win this Opportunity it is required for you to ensure you or the interested student and/ or sponsor has completed one or more of the following tasks: Obtain Copy Matric Certificate, Obtain Copy of Sponsor SA ID, Paid 1st Month Instalment, Received Signed Enrolment Contract, Obtain Copy of Student SA ID, Obtain Matric Indemnity, Obtain Student SA Medical Aid Subscription, Obtain Study Permit, Obtain Visa, Paid International Deposit, Received Signed Enrolment Contract, Obtain Copy of Student Passport. Please note tasks vary for different types of student applicants (local vs international).Also note a registration contract record may not exists or the students academic vetting may not have been approved.');   
                       }
                       
                    }
               
           } 
                 
        }
    }
    public static void createTask_Method(List<Opportunity> opty){       
        List<Task> tasks ;
        for (Opportunity Opp :opty) { 
        if(opp.Type=='Returning Business'&& opp.International_Student_Status__c == 'Yes'){        
            tasks = new List<Task>{
                new Task(whatID= Opp.ID,Ownerid= Opp.OwnerId,Subject='Obtain Study Permit',Status='Not Started',ActivityDate=null,Auto_Generated__c = true),
                new Task(whatID= Opp.ID,Ownerid= Opp.OwnerId,Subject='Obtain Visa',Status='Not Started',ActivityDate=null,Auto_Generated__c = true)
            }; 
           }
        }
        if(tasks<>null&&!tasks.isEmpty()){
             Database.insert(tasks,false); 
        }
    } 
    
    public static void createTask_Method1(List<Opportunity> oppty){
             List<Opportunity> op =[select id,name,type,International_Student_Status__c,academic_Vetting_Status__c,
              (select id,status,subject from tasks) from Opportunity where id IN : oppty];              
        List<Opportunity> oppList = new List<Opportunity>();        
          for(Opportunity opp : op){
              for(Task t : opp.tasks){
                  if(opp.type=='Returning Business'&&opp.International_Student_Status__c == 'No' && 
                  opp.Academic_Vetting_Status__c=='Vetted - Approved'&&(t.subject=='Obtain Study Permit' || t.subject=='Obtain Visa')&& t.status=='completed'){                      
                      opp.Enrolment_Status__c='Pre-enrolled';
                      oppList.add(opp);
                 } 
              }
          } 
        
    } 
    
    //If Type=ReturningBuisiness,the below 3 tasks should be created as per RD-00176
    public static void ReturningBuisinesscreateTask(List<Opportunity>opty){       
        List<Task> tasks  = new List<Task> ();
        set<id>set1 = new set<id>();
        
        for(Opportunity op: opty){
            if(op.Type=='Returning Business' ){
          
                set1.add(op.id);
            }
          }

          if(set1.size()==0) return;

          List<Opportunity> taskOpp = [SELECT Id, Type,OwnerId, (SELECT Id, Subject FROM Tasks) FROM Opportunity WHERE Id IN :set1];

          //integer counter = [Select count() from task where whatID IN :set1 ];
        
        for (Opportunity Opp :taskOpp) 
        { 
            if(opp.Type=='Returning Business' && (opp.tasks ==null || opp.tasks.size() <=2)){        
                
                Map<String,Task> listOfTasks = new Map<String,Task> ();

                Task newTask = new Task(whatID= Opp.ID,Ownerid= Opp.OwnerId,Subject='Received Signed Enrolment Contract',Status='Not Started',ActivityDate=null,Auto_Generated__c = true);
                listOfTasks.put(newTask.Subject,newTask);
                newTask = new Task (whatID= Opp.ID,Ownerid= Opp.OwnerId,Subject='Paid 1st Month Instalment',Status='Not Started',ActivityDate=null,Auto_Generated__c = true);
                listOfTasks.put(newTask.Subject,newTask);
                newTask =  new Task(whatID= Opp.ID,Ownerid= Opp.OwnerId,Subject='Verified Contact/Account Details',Status='Not Started',ActivityDate=null,Auto_Generated__c = true);
                listOfTasks.put(newTask.Subject,newTask);

                for(Task existingTask: opp.tasks)
                {
                    if(listOfTasks.containsKey(existingTask.Subject))
                    {
                        listOfTasks.remove(existingTask.Subject);
                    }
                } 

                if(!listOfTasks.isEmpty())
                {
                   
                    tasks.addAll(listOfTasks.values());         
                }                   
            }
        }

        if(tasks <> null && !tasks.isEmpty()){
             Database.insert(tasks,false); 
        }
    } 
    
    
    // After update and insert logic |RD 145 | 
      
    public Static void createTaskOnPsychology(List<Opportunity> oppList) {
              
             
        List<Task> tskList = new List<Task>();
        List<Event> evnList = new List<Event>();
        set<id>set1 = new set<id>();
        set<id>set2 = new set<id>();
        try{
        for(Opportunity op: oppList){
         if(op.Qualification__c.contains('Graphic Design')){
        set1.add(op.id);
          }
          if(op.Qualification__c.contains('Psychology')){
            set2.add(op.id);
          }
        }
        integer counter = [select count() from task where WhatId IN:set1 AND subject=:'Inform Student of Graphic Design Portfolio Requisite'];
        integer counter1 = [select count() from task where WhatId IN:set2 AND subject=: 'Student Attended Panel Interview'];
        system.Debug('counting' +counter1 );
        if(oppList.size()>0){
            for(Opportunity op: oppList){
              
               if(op.Qualification__c != null)
                {
                if(op.Qualification__c.contains('Psychology') && counter1<=0) {                
                
                    system.Debug('inside If psychology-----');
                    Task tsk = new task();
                    Event evn = new Event();
                    
                    tsk.subject = 'Student Attended Panel Interview';
                    tsk.status = 'Not Started';
                    tsk.whoId = op.Primary_Contact__c;
                    tsk.WhatId = op.id;
                    tsk.ActivityDate = null;
                    tsk.Auto_Generated__c = true;
                    tskList.add(tsk);
                    
                    
                     ID recId = Schema.Sobjecttype.Event.getRecordTypeInfosByName().get('Interview').getRecordTypeId();
                     evn.RecordTypeid = recId;                    
                    evn.subject = 'Bachelor of Psychology Interview';
                    evn.Status__c = 'To Be Scheduled';
                    evn.whoId = op.Primary_Contact__c;
                    evn.WhatId = op.id;
                    evn.ActivityDate = date.today();
                    evn.Type = 'Qualification Interview';
                    
                    datetime dtstart = Datetime.newInstance(2015, 15 , 4, 00, 00, 00);
                    datetime dtend = Datetime.newInstance(2015, 15 , 4, 01, 00, 00);
                    evn.EndDateTime = dtend;
                    evn.StartDateTime = dtstart; 
                    evn.ActivityDateTime = dtstart; 
                    evn.DurationInMinutes = 60;                  
                    
                    evnList.add(evn);                   
                    
                }
                system.Debug('outside 2nd If Graphic');
                if(op.Qualification__c.contains('Graphic Design')  && counter<1) {
                    system.Debug('inside 2nd If Graphic');
                    Task tsk1 = new task();
                    Task tsk2 = new task();
                    
                    tsk1.subject = 'Inform Student of Graphic Design Portfolio Requisite';
                    tsk1.status = 'Not Started';
                    tsk1.whoId = op.Primary_Contact__c;
                    tsk1.WhatId = op.id;
                    tsk1.ActivityDate = null;
                    tsk1.Auto_Generated__c = true;
                    tskList.add(tsk1);
                    
                    tsk2.subject = 'Confirm Student Submitted Portfolio';
                    tsk2.status = 'Not Started';
                    tsk2.whoId = op.Primary_Contact__c;
                    tsk2.WhatId = op.id;
                    tsk2.ActivityDate = null;
                    tsk2.Auto_Generated__c = true;
                    tskList.add(tsk2);
                }
               }
               
             }
                             
              if(!Utility.stopRecursion){
                 Utility.stopRecursion = true;  
                 
                if(tskList!= null && !tskList.isEmpty()){            
                 
                  insert tskList;
                }
                
                if(evnList!= null && !evnList.isEmpty()){                   
                  insert evnList;
                  
                }
                 
               }            
          } 
       }
        catch(Exception ex){
            system.debug('Exception'+ex);
        }
    }
    
    
    
     //Written as per RD-00145
    public static void ValidationOnTask(Map<Id,Opportunity> optyMap,List<Opportunity> oppty){     
      Map<Id,List<Task>> tskMap = new Map<Id,List<Task>>();
        List<Opportunity> op =[select id,name,Enrolment_Status__c,StageName,Qualification__c,
              (select id,status,subject,Auto_Generated__c from tasks) from Opportunity where id IN : oppty];
                      
        List<Opportunity> oppList = new List<Opportunity>();   
           
          for(Opportunity opp : op){
            
            tskMap.put(opp.Id,opp.Tasks);            
          }
          
           for(Opportunity o : oppty){            
                  
              If(o.StageName =='Closed'){   
                            
                for(Task tsk : tskMap.get(o.Id)){                
                  
                  if(tsk.status!='Completed' && o.qualification__c!=null && o.qualification__c.contains('Graphic Design')&& (tsk.subject.contains('Inform Student of Graphic Design Portfolio Requisite') || tsk.subject.contains('Confirm Student Submitted Portfolio'))){
                     
                     o.addError('The following student cannot yet be enrolled for Graphic Design until they have been informed of and have submitted the requisite Graphic Design Portfolio');
                 }
               
              
              }
           }
           
        }
    }
    
    public static void ValidationOnTaskAndEvent(Map<Id,Opportunity> optyMap,List<Opportunity> oppty){
     
      Map<Id,List<Task>> tskMap = new Map<Id,List<Task>>();
      Map<Id,List<Event>> evnMap = new Map<Id,List<Event>>();
        List<Opportunity> op =[select id,name,Enrolment_Status__c,StageName,Qualification__c,
              (select id,status,subject,Auto_Generated__c from tasks),(select id,subject,Status__c from Events) from Opportunity where id IN : oppty];
                      
        List<Opportunity> oppList = new List<Opportunity>();   
           
          for(Opportunity opp : op){            
            tskMap.put(opp.Id,opp.Tasks);  
            evnMap.put(opp.Id,opp.Events);           
          }
          
           for(Opportunity o : oppty){
                  
              If(o.StageName =='Closed'){               
              
                for(Task tsk : tskMap.get(o.Id)){
                 for(Event evn : evnMap.get(o.Id)){
                
                  
                  if(((tsk.status!='Completed'  || evn.Status__c!='Completed' ) && o.qualification__c!=null  && o.qualification__c.contains('Psychology')) && tsk.subject=='Student Attended Panel Interview' && evn.subject=='Bachelor of Psychology Interview'){
                                       
                     o.addError('The following student cannot yet be enrolled for BPsych until they have attended a panel interview & have completed a BPsych Interview');
                  }
                 
                 }               
              
              }
           }
           
        }
    }    
  
}