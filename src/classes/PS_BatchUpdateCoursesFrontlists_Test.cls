/**
 * Name : PS_BatchUpdateCoursesFrontlists_Test 
 * Author : Accenture
 * Description : Test class used for testing the PS_BatchUpdateCoursesFrontlists
 * Date : 7/01/15 
 * Version : <intial Draft> 
 */
@isTest
public class PS_BatchUpdateCoursesFrontlists_Test {

    static testmethod void testBatchUpdateCourses()
    { 
        List<Account> accList = TestDataFactory.createAccount(2,'Direct Corporate');
        insert accList;
        
        UniversityCourse__c unvobject = new UniversityCourse__c(); 
        unvobject.Account__c = accList[0].Id;
        unvobject.Active__c = true;
        unvobject.Name = 'Test Univ course Name';
        unvobject.Adoption_Type__c = 'committee';
        unvobject.Course_Name__c = 'Test course Name';
        unvobject.Fall_Enrollment__c = 121;
        unvobject.Spring_Enrollment__c = 110;
        unvobject.Winter_Enrollment__c = 415;
        unvobject.Fall_Front_List__c= true;
        unvobject.Spring_Front_List__c= true;
        integer iMonth = system.today().month();
               // unvobject.  = Course
      // unvobject.
          insert unvobject;
        List<UniversityCourse__c> lstUnivcourse = new List<UniversityCourse__c>();
       // lstUnivcourse.add(unvobject);
       // lstUnivcourse.clear();
        Apttus_Config2__ClassificationName__c category = new Apttus_Config2__ClassificationName__c(Name='testcategoryy',Apttus_Config2__HierarchyLabel__c='testlabele');
        insert category; 
        Apttus_Config2__ClassificationHierarchy__c csa =new Apttus_Config2__ClassificationHierarchy__c(name ='estt',Apttus_Config2__HierarchyId__c=category.id,Apttus_Config2__Label__c='testlabel');
        csa.Region__c = 'US';
        csa.Type__c ='Course';
        csa.Current_Period__c = true;
        csa.Prior_Period__c = true;
        insert csa;                 
        Pearson_Course_Equivalent__c  pcourseObject = new Pearson_Course_Equivalent__c();
        pcourseObject.Course__c  =unvobject.Id;
        pcourseObject.Active__c = true;  
        pcourseObject.Primary__c =true;
        pcourseObject.Pearson_Course_Code__c = csa.Id;
       
        insert pcourseObject;
        
     PS_BatchUpdateCoursesFrontlists batchObject = new PS_BatchUpdateCoursesFrontlists('US',unvobject.Id, true);   
      Test.startTest();  
      database.executeBatch(batchObject) ; 
   //  system.schedule();
     SchedulableContext sc = null;
     // tsc.execute(sc);
     batchObject.execute(sc);
        Test.stopTest();
     
    }
    
}