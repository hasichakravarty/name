/*******************************************************************************************************************
* Class Name       : PS_CreateAssetbasedStudentRegistration
* Version          : 1.0 
* Created Date     : 30 March 2015
* Function         : Test Class of the PS_CreateAssetbasedStudentRegistration
* Modification Log :
*
* Developer                                Date                    Description
* ------------------------------------------------------------------------------------------------------------------
*   Accenture IDC                          9/05/2015              Created Initial Version
*******************************************************************************************************************/

@isTest 
/* a private class for creating student based on asset */            
private class PS_CreateAssetbasedStudentTest{
private static List<User> userlist;

/* a test method to ensure that students are created based on the criteria */
 static testMethod void myTest() { 

/*list<Account> accountdatalist = TestDataFactory.createAccount(3,'Learner');   
Insert accountdatalist;
Update accountdatalist;*/
    userlist = new List<User>();
    userlist = TestDataFactory.createUser(userinfo.getProfileId());
    insert userlist;
    system.runAs(userlist[0]){
    Account acc = new Account();
     acc.Name = 'Test';
     acc.Line_of_Business__c= 'Higher Ed';
     acc.Geography__c = 'North America';
     acc.Market__c = 'US';
     insert acc;
     
     
     contact con = new contact();
     con.Lastname= 'testcon';
     con.Firstname= 'testcon1';
     con.MobilePhone = '9999';     
     insert con;
     
     Test.startTest();
  //for(Account newAcc : accountdatalist){}
     List<Opportunity>opplist = new List<Opportunity>();
     Map<Id,Opportunity> optyMap = new Map<Id,Opportunity>();
     Map<Id,Opportunity> oldMapOpty = new Map<Id,Opportunity>();
     Opportunity opp = new opportunity();
      opp.AccountId = acc.id;    
      opp.Name = 'OppTest';
      opp.StageName = 'Qualification';
      opp.Type = 'New Business';
      opp.Enrolment_Status__c = 'Enrolled';
      opp.CloseDate = system.today();
      opp.International_Student_Status__c = 'Yes';
      opp.Qualification__c = 'Psychology';
      opp.Market2__c = 'US';
      
      Opportunity opp1 = new opportunity();
      opp1.AccountId = acc.id;    
      opp1.Name = 'OppTest';
      opp1.StageName = 'Qualification';
      opp1.Type = 'Returning Business';
      opp1.Enrolment_Status__c = 'Pre-enrolled';
      opp1.CloseDate = system.today();
      opp1.International_Student_Status__c = 'No';
      opp1.Qualification__c = 'Graphic Design';
      opp1.Market2__c = 'US';
      
     Opportunity opp2 = new opportunity();
      opp2.AccountId = acc.id;    
      opp2.Name = 'OppTest';
      opp2.StageName = 'Qualification';
      opp2.Type = 'New Business';
      opp2.Enrolment_Status__c = 'Enrolled';
      opp2.CloseDate = system.today();
      opp2.International_Student_Status__c = 'No';
      opp2.Qualification__c = 'Graphic Design';
      opp2.Market2__c = 'US';
      
      insert opp2;
         
      opplist.add(opp);
      opplist.add(opp1);
      //opplist.add(opp2);
      
      
      insert opplist;
      
    opp2.Qualification__c = 'Psychology';
    
    update  opp2;
    opplist.add(opp2); 
    
    Task tsk1 = new Task();
    tsk1.Status = 'Not Started';
     tsk1.WhatId = opp.Id;
     //tsk1.RecordTypeId = recId;
     tsk1.subject = 'Obtain Matric Certificate';
     tsk1.Auto_Generated__c = true;
      insert tsk1;
      
      Task tsk2 = new Task();
      tsk2.Status = 'Not Started';
      tsk2.WhatId = opp.Id;     
      tsk2.subject = 'Received Signed Enrolment Contract';
      tsk2.Auto_Generated__c = true;
      insert tsk2;
      
      Task tsk3 = new Task();
      tsk3.Status = 'Not Started';
      tsk3.WhatId = opp2.Id;
      tsk3.subject = 'Student Attended Panel Interview';
      tsk3.Auto_Generated__c = true;
      insert tsk3;     
      
             
       PS_createAssetbasedStudentRegistration.createTask(opplist);
       PS_createAssetbasedStudentRegistration.OpportunityStage(optyMap,opplist,oldMapOpty );
       PS_createAssetbasedStudentRegistration.createTask_Method(opplist);
       PS_createAssetbasedStudentRegistration.createTask_Method1(opplist);
       PS_createAssetbasedStudentRegistration.ReturningBuisinesscreateTask(opplist);
       PS_createAssetbasedStudentRegistration.createTaskOnPsychology(opplist);
       PS_createAssetbasedStudentRegistration.ValidationOnTask(optyMap,opplist);
       PS_createAssetbasedStudentRegistration.ValidationOnTaskAndEvent(optyMap,opplist);
       
       Test.stoptest();
   }    
  }
}