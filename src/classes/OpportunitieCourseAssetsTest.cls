@istest(seealldata =true)
public class OpportunitieCourseAssetsTest{

static testmethod void constructorTest() {

Test.startTest();

        opportunity ld = new opportunity(Name='Test', StageName='Needs Analysis', CloseDate=system.today());
        insert ld;
        Test.setCurrentPage(Page.OpportunitieCourseAssets);
        
         Account acc = new Account(Name = 'AccTest1',Line_of_Business__c='Schools',CurrencyIsoCode='GBP',Geography__c = 'Growth',Organisation_Type__c = 'Higher Education',Type = 'School');
        insert acc;
        
        Contact con = new Contact(FirstName='karthik',LastName ='A.S',Phone='9999888898',Email='test@gmail.com', AccountId = acc.Id);
        insert con;
        UniversityCourse__c UnivCourse =new UniversityCourse__c(Name='testcourse',Account__c= acc.id,Catalog_Code__c='testcode',Course_Name__c='testcoursename',CurrencyIsoCode='GBP',Active__c=true);
        insert UnivCourse;
       OpportunityUniversityCourse__c s = new OpportunityUniversityCourse__c();
       s.Close_Date__c =System.today();
       s.Account__c= acc.id;
      s.Opportunity_Name__c =ld.Name;
      s.Opportunity_University_Course_Amount__c=100.00;
       s.UniversityCourse__c = UnivCourse.id;
       s.Opportunity__c =  ld.id;
       insert s; 
        system.debug('@@date'+date.today());
       UniversityCourseContact__c uni = new UniversityCourseContact__c(UniversityCourse__c=UnivCourse.id,Contact__c = con.Id);
         insert uni;
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
product2 produ= new product2(name ='testproduct',Next_Edition__c=null,Publisher__c='tPearson');//,Relevance__c=Date.today());
insert produ;
    asset ass = new asset(name ='test asset',AccountId = acc.Id,Contactid = con.id ,Course__c=UnivCourse.id,Product2=produ,IsCompetitorProduct=true);
 insert ass;  
         
  PageReference createOppty = new pagereference('apex/OpportunitieCourseAssets');

                        id courseid=  UnivCourse.id;
                        id ldid= ld.id;
                       system.debug('$$$$courseid'+UnivCourse.id);
                        Test.setCurrentPage(createOppty);
                        //createOppty.getParameters().put('id', ldid);
                        OpportunitieCourseAssets controller = new OpportunitieCourseAssets(new ApexPages.StandardController(ld));

        controller.gethasAssets();
        controller.getCourseAssets();
        controller.beginning();
        controller.previous();
        controller.next();
        controller.end();
        controller.getprev();
        controller.getnxt();

                 // ApexPages.StandardController sc = new ApexPages.standardController(UnivCourse);
     
                 
   Test.stopTest();
system.debug('@@@course'+ass);
 
}

}