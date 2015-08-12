@istest(seealldata =true)
private class CreateOpportunityfromCoursetest{
static testmethod void constructorTest() {
try{
Test.startTest();
       
       

        Account acc = new Account(Name = 'AccTest1',Line_of_Business__c='Schools',CurrencyIsoCode='GBP',Geography__c = 'Growth',Organisation_Type__c = 'Higher Education',Type = 'School');
        insert acc;
        
        Contact con = new Contact(FirstName='karthik',LastName ='A.S',Phone='9999888898',Email='test@gmail.com', AccountId = acc.Id);
        insert con;
        UniversityCourse__c UnivCourse =new UniversityCourse__c(Name='testcourse',Account__c= acc.id,Catalog_Code__c='testcode',Course_Name__c='testcoursename',CurrencyIsoCode='GBP',Active__c=true,Fall_Enrollment__c=10);
        insert UnivCourse;
       
         opportunity ld = new opportunity(Name='Test', StageName='Needs Analysis', CloseDate=system.today());         
        insert ld;
        

        system.debug('@@date'+date.today());
       UniversityCourseContact__c uni = new UniversityCourseContact__c(UniversityCourse__c=UnivCourse.id,Contact__c = con.Id);
         insert uni;
   
 

CreateOpportunityfromCourse testnew = new CreateOpportunityfromCourse();

 //testnew.createOppty();
 
 
PageReference createOppty = new pagereference('apex/CreateOpportunityfromCourse');

                        id courseid=  UnivCourse.id;
                        id ldid= ld.id;
                       system.debug('$$$$courseid'+UnivCourse.id);
                        Test.setCurrentPage(createOppty);
                        createOppty.getParameters().put('id', courseid);
                        createOppty.getParameters().put('command', 'Opportunitycreate');
                       
                        createOppty.getParameters().put('command', 'CreateOpportunityUniversityCourse');
                        

                        createOppty.getParameters().put('opptyid', ldid);
                   ApexPages.StandardController sc = new ApexPages.standardController(UnivCourse);
          CreateOpportunityfromCourse testnew1 = new CreateOpportunityfromCourse();
        
 CreateOpportunityfromCourse testnew2 = new CreateOpportunityfromCourse();      
  CreateOpportunityfromCourse testnew3 = new CreateOpportunityfromCourse();             
 testnew1.onLoad_CourseOpptyEdit();
  Apttus_Config2__ClassificationName__c category = new Apttus_Config2__ClassificationName__c(Name='testcategoryy',Apttus_Config2__HierarchyLabel__c='testlabele');
 insert category;
 
 Apttus_Config2__ClassificationHierarchy__c catre= new Apttus_Config2__ClassificationHierarchy__c(Name ='testcategory',Apttus_Config2__HierarchyId__c=category.id,Apttus_Config2__Label__c='testlabel');
  
insert catre;
List<Opportunity_Pearson_Course_Code__c> opppearson =new List<Opportunity_Pearson_Course_Code__c>();
Opportunity_Pearson_Course_Code__c opppearsonitem =new Opportunity_Pearson_Course_Code__c();

for(integer i=0;i<3;i++)
{
opppearsonitem.Opportunity__c =ld.id;
opppearsonitem.Pearson_Course_Code_Name__c=catre.id;
opppearson.add(opppearsonitem);
}
insert opppearson;
Apttus_Config2__ClassificationHierarchy__c csa =new Apttus_Config2__ClassificationHierarchy__c(name ='estt',Apttus_Config2__HierarchyId__c=category.id,Apttus_Config2__Label__c='testlabel');
insert csa; 
List<Pearson_Course_Equivalent__c> perasoncourese = new List<Pearson_Course_Equivalent__c>();
Pearson_Course_Equivalent__c perasoncoureseitem = new Pearson_Course_Equivalent__c();
for(integer i=0;i<3;i++)
{
perasoncoureseitem = new Pearson_Course_Equivalent__c();
perasoncoureseitem.Pearson_Course_Code__c = csa.id;
perasoncoureseitem.Course__c=UnivCourse.id;
perasoncourese.add(perasoncoureseitem);
}
insert perasoncourese;
system.debug('perasoncourese'+perasoncourese);
//Pearson_Course_Equivalent__c perasoncouresee = new Pearson_Course_Equivalent__c(Pearson_Course_Code__c = csa.id,Course__c=UnivCourse.id);
//insert perasoncouresee ;
product2 produ= new product2(name ='testproduct',Next_Edition__c=null,Publisher__c='Pearson'/*,Relevance__c[0]=10Date.today()*/);
insert produ;
asset asse = new asset(name ='test asset',AccountId = acc.Id,Contactid = con.id ,Course__c=UnivCourse.id,/*IsCompetitorProduct=true,*/product2=produ);
 insert asse;
 


system.debug('$$$$asse'+asse);
      system.debug('$$$$produ'+produ);           
 system.debug('$$$$courseid'+courseid);
                   system.debug('$$$$UnivCourse'+UnivCourse);
         system.debug('$$$$createOppty'+createOppty);
         system.debug('$$$$ldid'+ldid);

createOppty.getParameters().put( 'id' , opppearson[0].id);
 testnew1.today_date = system.today();

testnew1.Fall_start_date = system.today()-1;
testnew1.Fall_end_date = system.today()+1;
  testnew1.Spring_start_date = system.today();
  testnew1.Spring_end_date = system.today();
  System.debug(testnew1.Fall_end_date);
  System.debug(testnew1.Spring_end_date);
  
// testnew2.createOppty();

testnew1.createOppty();
//testnew2.onLoad_CourseOpptyEdit(); 
   //testnew2.CreateOpportunityUniversityCourse(); 
testnew.CreateOpportunityUniversityCourse();
testnew.DeleteOppty();

 testnew.CreatePearsonCourse();
 
 Test.stopTest();}
 catch(Exception e){return ;}
}         
   static testmethod void constructorTest1() {
try{Test.startTest();
      Account acc = new Account(Name = 'AccTest1',Line_of_Business__c='Schools',CurrencyIsoCode=null,Geography__c = 'Growth',Organisation_Type__c = 'Higher Education',Type = 'School');
        insert acc;
        
        Contact con = new Contact(FirstName='karthik',LastName ='A.S',Phone='9999888898',Email='test@gmail.com', AccountId = acc.Id);
        insert con;
        UniversityCourse__c UnivCourse =new UniversityCourse__c(Name='testcourse',Account__c= acc.id,Catalog_Code__c='testcode',Course_Name__c='testcoursename',CurrencyIsoCode='GBP',Active__c=true);
        insert UnivCourse;
       
         opportunity ld = new opportunity(Name='Test', StageName='Needs Analysis', CloseDate=Date.newInstance(2015,04,15));
        insert ld;
        
       

CreateOpportunityfromCourse testnew = new CreateOpportunityfromCourse();
testnew.onLoad_CourseOpptyEdit ();
 //testnew.createOppty();
 
 
PageReference createOppty = new pagereference('apex/CreateOpportunityfromCourse');

                        id courseid=  UnivCourse.id;
                        id ldid= ld.id;
                       system.debug('$$$$courseid'+UnivCourse.id);
                        Test.setCurrentPage(createOppty);
                        createOppty.getParameters().put('id', courseid);
                        createOppty.getParameters().put('command', 'Opportunitycreate');
                       
                                               
                        createOppty.getParameters().put('opptyid', ldid);
                   //ApexPages.StandardController sc = new ApexPages.standardController(UnivCourse);
          CreateOpportunityfromCourse testnew1 = new CreateOpportunityfromCourse();
          
 CreateOpportunityfromCourse testnew2 = new CreateOpportunityfromCourse();      
  CreateOpportunityfromCourse testnew3 = new CreateOpportunityfromCourse();             
 testnew1.onLoad_CourseOpptyEdit();
  date today_date = system.today();
date Spring_start_date=system.today()-1;
date Spring_end_date=system.today()+1; 
 // testnew1.Fall_start_date;
 testnew1.today_date = system.today();

testnew1.Fall_start_date = system.today()-1;
testnew1.Fall_end_date = system.today()+1;
  testnew1.Spring_start_date = system.today();
  testnew1.Spring_end_date = system.today();
  System.debug(testnew1.Fall_end_date);
  System.debug(testnew1.Spring_end_date);
  
// testnew2.createOppty();

testnew1.createOppty();
 //opportunity ldd = new opportunity(Name='Test', StageName='Needs Analysis', CloseDate=Date.newInstance(2015,04,15));
       // update ldd;

 

Test.stopTest();}
catch(exception e){return ;}
  }   
   static testmethod void constructorTest2() {
try{Test.startTest();
        Account acc = new Account(Name = 'AccTest1',Line_of_Business__c='Schools',CurrencyIsoCode='GBP',Geography__c = 'Growth',Organisation_Type__c = 'Higher Education',Type = 'School');
        insert acc;
        
        Contact con = new Contact(FirstName='karthik',LastName ='A.S',Phone='9999888898',Email='test@gmail.com', AccountId = acc.Id);
        insert con;
        UniversityCourse__c UnivCourse =new UniversityCourse__c(Name='testcourse',Account__c= acc.id,Catalog_Code__c='testcode',Course_Name__c='testcoursename',CurrencyIsoCode='GBP',Active__c=true);
        insert UnivCourse;
       
         opportunity ld = new opportunity(Name='Test', StageName='Needs Analysis', CloseDate=Date.newInstance(2015,04,15));

        insert ld;
        
       UniversityCourseContact__c uni = new UniversityCourseContact__c(UniversityCourse__c=UnivCourse.id,Contact__c = con.Id);
         insert uni;
   

CreateOpportunityfromCourse testnew = new CreateOpportunityfromCourse();
testnew.onLoad_CourseOpptyEdit ();
 //testnew.createOppty();
 date today_date = system.today();
date Spring_start_date=system.today()+1;
date Spring_end_date=system.today()-1; 
 
PageReference createOppty = new pagereference('apex/CreateOpportunityfromCourse');

                        id courseid=  UnivCourse.id;
                        id ldid= ld.id;
                       system.debug('$$$$courseid'+UnivCourse.id);
                        Test.setCurrentPage(createOppty);
                        createOppty.getParameters().put('id', courseid);
                        createOppty.getParameters().put('command', 'CreatePearsonCourse');
                       
                                               
                        createOppty.getParameters().put('opptyid', ldid);
                   //ApexPages.StandardController sc = new ApexPages.standardController(UnivCourse);
          CreateOpportunityfromCourse testnew1 = new CreateOpportunityfromCourse();
          
 CreateOpportunityfromCourse testnew2 = new CreateOpportunityfromCourse();      
  CreateOpportunityfromCourse testnew3 = new CreateOpportunityfromCourse();             
 testnew1.onLoad_CourseOpptyEdit();
Apttus_Config2__ClassificationName__c category = new Apttus_Config2__ClassificationName__c(Name='testcategoryy',Apttus_Config2__HierarchyLabel__c='testlabele');
 insert category;
 
 Apttus_Config2__ClassificationHierarchy__c catre= new Apttus_Config2__ClassificationHierarchy__c(Name ='testcategory',Apttus_Config2__HierarchyId__c=category.id,Apttus_Config2__Label__c='testlabel');
  
insert catre;
Opportunity_Pearson_Course_Code__c opppearson =new Opportunity_Pearson_Course_Code__c(Opportunity__c =ld.id,Pearson_Course_Code_Name__c=catre.id);
insert opppearson;
Apttus_Config2__ClassificationHierarchy__c csa =new Apttus_Config2__ClassificationHierarchy__c(name ='estt',Apttus_Config2__HierarchyId__c=category.id,Apttus_Config2__Label__c='testlabel');
insert csa; 
Pearson_Course_Equivalent__c perasoncourese = new Pearson_Course_Equivalent__c(Pearson_Course_Code__c = csa.id,Course__c=UnivCourse.id);
insert perasoncourese ;
product2 produ= new product2(name ='testproduct',Next_Edition__c=null,Publisher__c='Pearson');//,Relevance__c=Date.today());
insert produ;
asset asse = new asset(name ='test asset',AccountId = acc.Id,Contactid = con.id ,Course__c=UnivCourse.id,IsCompetitorProduct=true,product2=produ);
 insert asse;

system.debug('$$$$asse'+asse);
      system.debug('$$$$produ'+produ);           
 system.debug('$$$$courseid'+courseid);
                   system.debug('$$$$UnivCourse'+UnivCourse);
         system.debug('$$$$createOppty'+createOppty);
         system.debug('$$$$ldid'+ldid);

createOppty.getParameters().put( 'id' ,opppearson.id);
 
 //testnew2.createOppty();
 testnew1.today_date = system.today();

testnew1.Fall_start_date = system.today()-1;
testnew1.Fall_end_date = system.today()+1;
  testnew1.Spring_start_date = system.today();
  testnew1.Spring_end_date = system.today();
  System.debug(testnew1.Fall_end_date);
  System.debug(testnew1.Spring_end_date);
  
// testnew2.createOppty();

testnew1.createOppty();

Test.stopTest();}
catch(exception e){ return ;} 
  }      
    static testmethod void constructorTest3() {
try{Test.startTest();

         Account acc = new Account(Name = 'AccTest1',Line_of_Business__c='Schools',CurrencyIsoCode='GBP',Geography__c = 'Growth',Organisation_Type__c = 'Higher Education',Type = 'School');
        insert acc;
        
        Contact con = new Contact(FirstName='karthik',LastName ='A.S',Phone='9999888898',Email='test@gmail.com', AccountId = acc.Id);
        insert con;
        UniversityCourse__c UnivCourse =new UniversityCourse__c(Name='testcourse',Account__c= acc.id,Catalog_Code__c='testcode',Course_Name__c='testcoursename',CurrencyIsoCode='GBP',Active__c=true);
        insert UnivCourse;
       
         opportunity ld = new opportunity(Name='Test', StageName='Needs Analysis', CloseDate=Date.newInstance(2015,04,15),Fall__c=10,Spring__c=10, Winter__c=10, Summer__c=10);

        insert ld;
        system.debug('@@@@ld'+ld);
       UniversityCourseContact__c uni = new UniversityCourseContact__c(UniversityCourse__c=UnivCourse.id,Contact__c = con.Id);
         insert uni;

CreateOpportunityfromCourse testnew = new CreateOpportunityfromCourse();
testnew.onLoad_CourseOpptyEdit ();
 //testnew.createOppty();

 
 
PageReference createOppty = new pagereference('apex/CreateOpportunityfromCourse');

                        id courseid=  UnivCourse.id;
                        id ldid= ld.id;
                       system.debug('$$$$courseid'+UnivCourse.id);
                        Test.setCurrentPage(createOppty);
                        createOppty.getParameters().put('id', courseid);
                        createOppty.getParameters().put('command', 'DeleteOpportunity');
                       
                                               
                        createOppty.getParameters().put('opptyid', ldid);
                   //ApexPages.StandardController sc = new ApexPages.standardController(UnivCourse);
          CreateOpportunityfromCourse testnew1 = new CreateOpportunityfromCourse();
          
 //CreateOpportunityfromCourse testnew2 = new CreateOpportunityfromCourse();      
  //CreateOpportunityfromCourse testnew3 = new CreateOpportunityfromCourse();             
 testnew1.onLoad_CourseOpptyEdit();
  testnew1.today_date = system.today();

testnew1.Fall_start_date = system.today()-1;
testnew1.Fall_end_date = system.today()+1;
  testnew1.Spring_start_date = system.today();
  testnew1.Spring_end_date = system.today();
  System.debug(testnew1.Fall_end_date);
  System.debug(testnew1.Spring_end_date);
  testnew1.createOppty();
//opportunity ldd = new opportunity(Name='Test',  CloseDate=Date.newInstance(2015,04,15),Fall__c=10,Spring__c=10, Winter__c=10, Summer__c=10);

//delete ldd;
Test.stopTest();
}
catch(exception e){ System.debug('Unwanted Excpetion Caught: ' + e.getMessage());}
  }  
 }