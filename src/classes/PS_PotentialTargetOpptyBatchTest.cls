@isTest(SeeAllData=True)
//class for covering the test class
private class PS_PotentialTargetOpptyBatchTest
{
    static testMethod void myBatchTest(){
    
         Profile pfile = [Select Id,name from profile where name = 'System Administrator'];
     
      //code for creating an User
      User u = new User();
      u.LastName = 'territoryuser';
      u.alias = 'terrusr'; 
      u.Email = 'territoryuser@gmail.com';  
      u.Username='territoryuser@gmail.com';
      u.LanguageLocaleKey='en_US'; 
      u.TimeZoneSidKey='America/New_York';
      u.Price_List__c='US HE All';
      u.LocaleSidKey='en_US';
      u.EmailEncodingKey='ISO-8859-1';
      u.ProfileId = pfile.id;       // '00eg0000000M99E';    currently hardcoded  for admin         
      u.Geography__c = 'Growth';
      u.CurrencyIsoCode='USD';
      u.Line_of_Business__c = 'Higher Ed';
      u.Market__c = 'US';
      u.Business_Unit__c = 'US Field Sales';
      insert u; 
      system.runas(u){
    //Product set up
        Product2 pf = TestDataFactory.insertRelatedProducts();
        List<PricebookEntry> pbe = new List<PricebookEntry>();
        PricebookEntry pbe1 = new PricebookEntry(Pricebook2Id = Test.getStandardPricebookId(),Product2Id = pf.id,
                IsActive=true,UnitPrice = 100,currencyisocode='USD');
        pbe.add(pbe1);
        
        List<Product2> rp = [select id,name from Product2 where id in (select Apttus_Config2__RelatedProductId__c  from
        Apttus_Config2__RelatedProduct__c where Apttus_Config2__ProductId__c = :pf.id and 
                                                                       Apttus_Config2__RelatedProductId__r.name like 'NA Territory%')];
        for(Product2 prod:rp){
            PricebookEntry pbe2 = new PricebookEntry(Pricebook2Id = Test.getStandardPricebookId(),Product2Id = prod.id,
                IsActive=true,UnitPrice = 100,currencyisocode='USD');
            pbe.add(pbe2);
        }
        insert pbe;
        
//category set up
   Apttus_Config2__ClassificationName__c cat = new Apttus_Config2__ClassificationName__c(Name='TestClassification',Apttus_Config2__Active__c=true,Apttus_Config2__HierarchyLabel__c='TestClassification');
    insert cat;     
    Apttus_Config2__ClassificationHierarchy__c cathier = new Apttus_Config2__ClassificationHierarchy__c(Name='TestClassificationHier',
    Apttus_Config2__Label__c='TestClassificationHier',Apttus_Config2__HierarchyId__c=cat.id);
    insert cathier;
    
    Apttus_Config2__ProductClassification__c procat = new Apttus_Config2__ProductClassification__c(Apttus_Config2__ClassificationId__c=cathier.id,
    Apttus_Config2__ProductId__c=pf.id);
    insert procat;
        
    //Account and contact set up        
      List<Account> Acc = TestDataFactory.createAccount(1, 'Organisation');
      Acc[0].Territory_Code_s__c = '2ZZ'; 
      insert Acc; 
     
      List<Contact> con = TestDataFactory.createContact(1); 
      con[0].AccountId = Acc[0].id; 
      insert con;  
        
      UniversityCourse__c course = new UniversityCourse__c();
          course.Name = 'TerritoryCourseNameandcode';
          course.Account__c = Acc[0].id;
          course.Catalog_Code__c = 'Territorycoursecode';
          course.Course_Name__c = 'Territorycoursename';
          course.CurrencyIsoCode = 'USD';
          course.Fall_Enrollment__c = 90;
          course.Spring_Enrollment__c = 80;
          course.Status__c = 'Active';
          course.mass_sampling__c=true;
          insert course; 

        
        UniversityCourseContact__c ucc = new UniversityCourseContact__c();
        ucc.Contact__c = con[0].id;
        ucc.UniversityCourse__c = course.id;
        ucc.Contact_Role__c = 'Business User';
        ucc.Active__c = true;
        insert ucc;
        
        
           Asset asset = new Asset();
           asset.name = 'TerritoryAsset';
           asset.Product2Id = rp[0].id;                //'01tg0000002j1jK';
           //asset.ContactId = con.id;
           asset.AccountId = Acc[0].id;
           asset.Course__c = course.id;
           asset.Primary__c = True;
           asset.Status__c = 'Active';
           insert asset;
           
           //code written for creating Generating Potential Targets
            List<Generate_Potential_Target__c> gptlist = new List<Generate_Potential_Target__c>();
            Generate_Potential_Target__c gpt = new Generate_Potential_Target__c();
            gpt.Account__c = Acc[0].id;
            gpt.Action__c ='Create';
            gpt.Course__c = course.id;
            gpt.Opportunity_Type__c= 'Existing Business';
            gpt.Processed__c = false;
            gpt.Product_In_Use_Publisher__c= 'Pearson';
            gpt.Product_In_Use__c = asset.id;
            gpt.Product__c = rp[0].id;
            gpt.Status__c = 'In Progress';
            gpt.TakeAway_Multiple_Frontlist__c = false;
            gpt.CurrencyIsoCode='USD';
             gptlist.add(gpt);
          
            Generate_Potential_Target__c gpt1= new Generate_Potential_Target__c();
            gpt1.Account__c = Acc[0].id;
            gpt1.Action__c ='Create';
            gpt1.Course__c = course.id;
            gpt1.opportunity_Type__c= 'Takeaway';
            gpt1.processed__c = false;
            gpt1.product_In_Use_Publisher__c= 'Pearson';
            gpt1.product_In_Use__c = asset.id;
            gpt1.Product__c = rp[0].id;
            gpt1.Status__c = 'In Progress';
            gpt1.TakeAway_Multiple_Frontlist__c = true;
            gpt1.CurrencyIsoCode='USD';
             gptlist.add(gpt1);          
            insert gptlist;
            
            Test.startTest();
            //code for covering the batch class 
            PS_PotentialTargetOpptyCreationBatch ptoc = new PS_PotentialTargetOpptyCreationBatch();
            Database.executeBatch(ptoc);
            Test.stopTest();
        }
    }
}