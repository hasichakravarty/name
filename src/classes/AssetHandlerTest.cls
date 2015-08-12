@isTest(SeeAllData=true)
private Class AssetHandlerTest { // Test Class to cover AssetHandler Class
    static testMethod void myUnitTest() { // Test Method to cover AssetHandler Class
        User u = [select Id, firstname from user where id=:userinfo.getuserid() limit 1];
         List<User> listWithUser = new List<User>();
         listWithUser  = TestDataFactory.createUser([select Id from Profile where Name =: 'System Administrator'].Id,1);
        System.runAs(listWithUser[0]){
        Test.StartTest();
        Account acc = new Account(Name = 'AccTest1',Line_of_Business__c='Schools',CurrencyIsoCode='GBP',Geography__c = 'Growth',Organisation_Type__c = 'Higher Education',Type = 'School',Market__c='US',Phone = '9989887687');
        acc.ShippingStreet = 'TestStreet';
        acc.ShippingCity = 'Vns';
        acc.ShippingState = 'Delhi';
        acc.ShippingPostalCode = '234543';
        acc.ShippingCountry = 'India';
        insert acc;
        
        Contact con = new Contact(FirstName='AssetHandler',LastName ='Test',Phone='9999888898',Email='AssetHandler.Test@testclass.com', AccountId = acc.Id);
        insert con;
        
        Pricebook2 standardPB = [select id from Pricebook2 where isStandard=true limit 1];
        Product2 pr1 = new Product2(Name = 'Bundle Product', IsActive = true, Apttus_Config2__ConfigurationType__c = 'Bundle',Qualification_Name__c = 'Test Bundle',Campus__c='Durbanville',Qualification_Level_Name__c= 2,Business_Unit__c = 'CTIMGI',Market__c = 'US',Line_of_Business__c='Higher Ed');
        insert pr1;
        
        
        Product2 pr2 = new Product2(Name = 'Option Product', IsActive = true, Apttus_Config2__ConfigurationType__c = 'Option',Business_Unit__c = 'CTIMGI',Market__c = 'US',Line_of_Business__c='Higher Ed');
        insert pr2;
        
        Pricebook2 pbk1 = new Pricebook2 (Name='Test Pricebook Entry 1',Description='Test Pricebook Entry 1', isActive=true);
        Database.insert(pbk1);
        
        //Pricebook2 oppprice = [select pricebook from Opportunity where id =: op.id].pricebook;
        
        PricebookEntry pbe1 = new PricebookEntry (Product2ID= pr1.id,Pricebook2ID=standardPB.id,UnitPrice=50,IsActive = true);
        PricebookEntry customprice = new pricebookentry( product2id = pr1.id, pricebook2id = pbk1.id,UnitPrice=50, usestandardprice = false, IsActive = true);
        Database.insert(pbe1);
        Database.insert(customprice);
        Opportunity ro = new Opportunity(Name= 'OpTest', AccountId = acc.id, StageName = 'Solutioning', Type = 'New Business', Academic_Vetting_Status__c = 'Un-Vetted', Academic_Start_Date__c = System.Today(),CloseDate = System.Today(),International_Student__c = true);
        insert ro;
        Opportunity op = new Opportunity(Name= 'OpTest1', AccountId = acc.id, StageName = 'Solutioning', Type = 'New Business', Academic_Vetting_Status__c = 'Un-Vetted', Academic_Start_Date__c = System.Today(),CloseDate = System.Today(),International_Student__c = true,Related_Opportunity__c=ro.Id);
        insert op;
        OpportunityLineItem oli = new OpportunityLineItem(PricebookEntryId = pbe1.id, OptionId__c = pr2.id, TotalPrice= 1000,Discount_Reference__c = 'Financial Credit',Amendment_Action__c = 'Deferred', Quantity = 1, Opportunityid = op.id);
        insert oli;
        
        Asset ast = new Asset(Name='#structstuf SA CBVS',Status = 'Active',AccountId = acc.id, Publisher__c='Pearson', Opportunity__c=op.Id, Product2Id= pr1.id);
        insert ast;
        
        Apttus_Config2__AssetLineItem__c ali = new Apttus_Config2__AssetLineItem__c(Name='TestAssetLI',Opportunity__c = op.Id,Apttus_Config2__ProductId__c = pr1.id);
        insert ali;
        Asset astRelated = new Asset(Name='#structstuf SA CBVSTest',Status = 'Active',AccountId = acc.id,Publisher__c='Pearson',Opportunity__c=ro.Id,Product2Id= pr1.id);
        insert astRelated;
        Apttus_Config2__AssetLineItem__c aliRelated = new Apttus_Config2__AssetLineItem__c(Name='TestAssetLI1',Opportunity__c = ro.Id,Apttus_Config2__ProductId__c = pr1.id);
        insert aliRelated;
        AssetHandler handler = new AssetHandler ();
        handler.Enrol_Student(op.id);
        handler.Modify_Contract(op.id);
        handler.ChangeofCampus_Asset(astRelated.id,'Durbanville');
        //ast.Status = 'Active';
        //update ast;
        handler.AssetCancelled(astRelated.id);
         Test.StopTest();      
       }                                   
    }
}