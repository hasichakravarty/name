@isTest
public class PS_assetTriggerTest
{
     

    @isTest static void myTest1(){
    
    
         Profile pfile = [Select Id,name from profile where name = 'System Administrator'];
     
      //code for creating an User
      User u = new User();
      u.LastName = 'territoryuser';
      u.alias = 'terrusr'; 
      u.Email = 'territoryuser@gmail.com';  
      u.Username='territoryuser@gmail.com';
      u.LanguageLocaleKey='en_US'; 
      u.TimeZoneSidKey='America/New_York';
      u.Price_List__c='Humanities & Social Science';
      u.LocaleSidKey='en_US';
      u.EmailEncodingKey='ISO-8859-1';
      u.ProfileId = pfile.id;       // '00eg0000000M99E';    currently hardcoded  for admin         
      u.Geography__c = 'Growth';
      u.Market__c = 'US';
      u.Business_Unit__c = 'US Field Sales';
      u.Line_of_Business__c = 'Higher Ed';
      u.isactive=true;
      u.CurrencyIsoCode='USD';
      insert u;       
             
        
      System.runAs(u){
      
       List<Account> Acc = TestDataFactory.createAccount(1, 'Organisation');
       Acc[0].Territory_Code_s__c = '2ZZ'; 
       Acc[0].Market__c = 'US'; 
       Acc[0].Line_of_Business__c = 'Higher Ed'; 
       Acc[0].Geography__c = 'Growth'; 
       insert Acc; 
          //code for creating course
      List<UniversityCourse__c> courselist=new List<UniversityCourse__c>();
      for(integer i=0;i<1;i++){
          UniversityCourse__c course = new UniversityCourse__c();
          course.Name = 'TerritoryCourseNameandcode'+i;
          course.Account__c = Acc[0].id;
          course.Catalog_Code__c = 'Territorycoursecode'+i;
          course.Course_Name__c = 'Territorycoursename'+i;
          course.CurrencyIsoCode = 'USD';
          courselist.add(course);
      }
      insert courselist;
      List<Contact> contactList=TestDataFactory.createContact(1);
      insert contactList;
      Product2 pf = TestDataFactory.insertRelatedProducts();
      List<Product2> rp = [select id,name from Product2 where id in (select Apttus_Config2__RelatedProductId__c  from
        Apttus_Config2__RelatedProduct__c where Apttus_Config2__ProductId__c = :pf.id and Apttus_Config2__RelatedProductId__r.name like 'NA Territory%')];      
      test.StartTest();
     List<Asset> asstlist=new List<Asset>();
      for(integer i=0;i<2;i++){
        Asset asset = new Asset();
       asset.name = 'TerritoryAsset'+i;
       asset.Product2Id = rp[0].id;
       asset.AccountId = Acc[0].id;
       asset.Course__c = courselist[0].id;
       asset.Primary__c = True;
       asset.Status__c = 'Active';
       asset.ContactId = contactList[0].Id;
       asstlist.add(asset);
      } 
      insert asstlist;
     
     asstlist[0].Quantity = 1;
     update asstlist[0];
       test.stopTest();
       }
      
      
     
    }
    
}