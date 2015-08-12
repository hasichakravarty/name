@isTest
private class PS_GeneratePotentialTargetsTest
{
    static testMethod void myUnitTest()
    {
     
     //query to get the profile of sales user OneCRM
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
        
      Apttus_Config2__ClassificationName__c cat = new Apttus_Config2__ClassificationName__c(Name='TestClassification',Apttus_Config2__Active__c=true,Apttus_Config2__HierarchyLabel__c='TestClassification');
      insert cat;   
      Apttus_Config2__PriceList__c priceList = new Apttus_Config2__PriceList__c(Name='Humanities & Social Science',Apttus_Config2__Active__c=true);                  
      insert  priceList;     
      Apttus_Config2__PriceListCategory__c pcat = new Apttus_Config2__PriceListCategory__c(Apttus_Config2__PriceListId__c=priceList.Id,Apttus_Config2__HierarchyId__c=cat.Id,Apttus_Config2__Sequence__c=1);
      insert pcat;
         
      system.debug('Category is created'+cat.id+';'+priceList.id+';'+pcat.id);   
   
       List<Account> Acc = TestDataFactory.createAccount(1, 'Organisation');
       Acc[0].Territory_Code_s__c = '2ZZ'; 
       insert Acc;         

      System.runAs(u){
   
          //code for creating course
      List<UniversityCourse__c> courselist=new List<UniversityCourse__c>();
      for(integer i=0;i<3;i++){
          UniversityCourse__c course = new UniversityCourse__c();
          course.Name = 'TerritoryCourseNameandcode'+i;
          course.Account__c = Acc[0].id;
          course.Catalog_Code__c = 'Territorycoursecode'+i;
          course.Course_Name__c = 'Territorycoursename'+i;
          course.CurrencyIsoCode = 'USD';
          courselist.add(course);
      }

      insert courselist;
    //  Apttus_Config2__ClassificationName__c  Cn = [Select id,name from Apttus_Config2__ClassificationName__c where name=:u.Price_List__c];
      
      //code for inserting Category Hierarchy 
      Apttus_Config2__ClassificationHierarchy__c categoryhierarchy = new Apttus_Config2__ClassificationHierarchy__c();
      categoryhierarchy.Apttus_Config2__HierarchyId__c = cat.id;   //'a1cg00000003ePw';
      categoryhierarchy.Apttus_Config2__Label__c = 'TestCategoryHierarchy';
      categoryhierarchy.Name = 'TestCategoryHierarchy';
      insert categoryhierarchy; 
      
      List<Pearson_Course_Equivalent__c> pcelist=new List<Pearson_Course_Equivalent__c>();
      for(integer i=0;i<courselist.size();i++){
          Pearson_Course_Equivalent__c pce = new Pearson_Course_Equivalent__c();
          pce.Active__c = true;   
          pce.Course__c =courselist[i].id; 
          pce.Primary__c = true;
          pce.Pearson_Course_Code__c = categoryhierarchy.id;
          pcelist.add(pce);
      }
      insert pcelist; 
      
      Product2 pf = TestDataFactory.insertRelatedProducts();
      List<Product2> rp = [select id,name from Product2 where id in (select Apttus_Config2__RelatedProductId__c  from
        Apttus_Config2__RelatedProduct__c where Apttus_Config2__ProductId__c = :pf.id and Apttus_Config2__RelatedProductId__r.name like 'NA Territory%')];      
      
     List<Asset> asstlist=new List<Asset>();
      for(integer i=0;i<courselist.size();i++){
        Asset asset = new Asset();
       asset.name = 'TerritoryAsset'+i;
       asset.Product2Id = rp[i].id;
       asset.AccountId = Acc[0].id;
       asset.Course__c = courselist[i].id;
       asset.Primary__c = True;
       asset.Status__c = 'Active';
       asstlist.add(asset);
      } 
      insert asstlist;
      
      List<Apttus_Config2__ProductClassification__c> prdclasslist=new List<Apttus_Config2__ProductClassification__c>();
      for(integer i=0;i<courselist.size();i++){
      Apttus_Config2__ProductClassification__c pc = new Apttus_Config2__ProductClassification__c();
      pc.Apttus_Config2__ClassificationId__c = pcelist[i].Pearson_Course_Code__c;
      pc.CurrencyIsoCode = 'USD';
      pc.Apttus_Config2__ProductId__c = rp[i].id;
      prdclasslist.add(pc);
      }
      insert prdclasslist;
      Test.startTest();  
      
      Territory2 tt = TestDataFactory.createTerritory();
      tt.Territory_Code__c='TCA';
      insert tt;      
      //code written to assign a user to territory
      UserTerritory2Association ut2a = new UserTerritory2Association();
      ut2a.Territory2Id = tt.id;    //'0MIg00000000A4b';    //testTerritory.id;
      ut2a.UserId = u.id;
      insert ut2a;
      UserTerritory2Association ut2aquery=[select id,User.Name,Territory2.Name from UserTerritory2Association where id=:ut2a.id];
      system.debug( ut2aquery.User.Name + ';'+  ut2aquery.Territory2.Name);  
      
        Product2 prod2 = new Product2();
        prod2.name = 'TerritoryProduct2';
        prod2.Competitor_Product__c = false; 
        prod2.Next_Edition__c = rp[0].id;
        prod2.Relevance_Value__c = 10;
        prod2.Business_Unit__c = u.Business_Unit__c;
        prod2.Market__c = u.Market__c;
        prod2.Line_of_Business__c = u.Line_of_Business__c;
        insert prod2;  
       
          //code for mapping product to product classififcation
         Apttus_Config2__ProductClassification__c pc = new Apttus_Config2__ProductClassification__c();
         pc.Apttus_Config2__ClassificationId__c = pcelist[0].Pearson_Course_Code__c;
         pc.CurrencyIsoCode = 'USD';
         pc.Apttus_Config2__ProductId__c = prod2.id;
         insert pc; 
         
        //code for mapping the related products
        Apttus_Config2__RelatedProduct__c rps = new Apttus_Config2__RelatedProduct__c();
        rps.Apttus_Config2__ProductId__c = prod2.id; 
        rps.Apttus_Config2__RelatedProductId__c = prod2.id; 
        rps.CurrencyIsoCode = 'USD';
        rps.PSELL__c = true;
        insert rps; 
       
        //code for creating PriceListItem
        Apttus_Config2__PriceListItem__c pli = new Apttus_Config2__PriceListItem__c();
        pli.Apttus_Config2__PriceListId__c = priceList.id;
        pli.Apttus_Config2__ProductId__c =  prod2.id; 
        insert pli;
              
        PS_GeneratePotentialTargets gpt = new PS_GeneratePotentialTargets(Acc[0].id);
        PS_GeneratePotentialTargets.createPotentialTargets();
       
        }// run as close
   Test.stopTest(); 

    }
    
}