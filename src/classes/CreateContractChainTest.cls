@isTest(SeeAllData=true)
 // TestClass to test CreateContractChain Class
private Class CreateContractChainTest {
    static testMethod void myUnitTest() {  // TestMethod to test CreateContractChain Class
       
        User u = [select Id, firstname from user where id=:userinfo.getuserid() limit 1];
         Test.StartTest();
        System.runAs(u){
        Account acc = new Account(Name = 'AccTest1',Line_of_Business__c='Schools',CurrencyIsoCode='GBP',Geography__c = 'Growth',Organisation_Type__c = 'Higher Education',Type = 'School',Market__c='other',Phone = '9989887687');
        acc.ShippingStreet = 'TestStreet';
        acc.ShippingCity = 'Vns';
        acc.ShippingState = 'Delhi';
        acc.ShippingPostalCode = '234543';
        acc.ShippingCountry = 'India';
        insert acc;
        
        Contact con = new Contact(FirstName='Contract',LastName ='ChainTest',Phone='9999888898',Email='Contract.ChainTest@Test.com', AccountId = acc.Id, isleadConvertedContact__c=false);
        insert con;
        
        Opportunity op = new Opportunity( Registration_Payment_Reference1__c = true, Received_Signed_Registration_Contract__c = true, Name= 'OpTest1', AccountId = acc.id, StageName = 'Solutioning', Type = 'New Business', Academic_Vetting_Status__c = 'Un-Vetted', Academic_Start_Date__c = System.Today(),CloseDate = System.Today(),International_Student__c = true);
        insert op;
        
        OpportunityTeamMember  OTeam = new OpportunityTeamMember(UserId = U.Id, TeamMemberRole ='Sales', OpportunityId = op.Id );
        insert OTeam;
        
        OpportunityContactRole ocr  = new OpportunityContactRole(OpportunityId = op.Id, Role = 'Business User', IsPrimary= true);
        ocr.ContactId = con.Id;
        insert ocr;
        
        Apttus_Proposal__Proposal__c prop = new Apttus_Proposal__Proposal__c(Apttus_Proposal__Proposal_Name__c = 'Test Proposal',Apttus_Proposal__Opportunity__c = op.id,Degree_Type__c = 'Full-Time', Deposit__c = 1234, Payment_Method__c = 'Credit Card', Payment_Type__c = 'Monthly Payment', Payment_Period_In_Month__c = '10', First_Payment_Date__c = System.Today());
        prop.RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Quote').getRecordTypeId();
        insert prop;
        // create 2 products of product2 
        // product 1 cnfigration type = bundle
        Product2 pr1 = new Product2(Name = 'Bundle Product', IsActive = true, Apttus_Config2__ConfigurationType__c = 'Bundle');
        pr1.ISBN__c = '12345678901';
        pr1.Conferer__c = 'CTI';
        pr1.Qualification_Name__c = 'Bachelor of Arts in Graphic Design';
        pr1.Campus__c='Durbanville';
        pr1.Qualification_Level_Name__c= 2;
        
        insert pr1;
        
        // product 2 configration type = option 
        Product2 pr2 = new Product2(Name = 'Option Product', IsActive = true, Apttus_Config2__ConfigurationType__c = 'Option');
        insert pr2;
        
        Apttus_Config2__ClassificationName__c CN = new Apttus_Config2__ClassificationName__c(Name ='Test CN',Apttus_Config2__HierarchyLabel__c = 'Test CN', Apttus_Config2__Active__c = true);
        insert CN;
        
        Apttus_Config2__ClassificationHierarchy__c CH = new Apttus_Config2__ClassificationHierarchy__c(Name ='Test CH', Apttus_Config2__Label__c = 'Test CH', Apttus_Config2__HierarchyId__c = CN.Id);
        insert CH;
        
        Apttus_Config2__ProductOptionGroup__c POG = new Apttus_Config2__ProductOptionGroup__c(Apttus_Config2__RootOptionGroupId__c = CH.Id, Apttus_Config2__OptionGroupId__c = CH.Id, Apttus_Config2__ProductId__c = Pr1.Id,Apttus_Config2__MaxOptions__c = 999, Apttus_Config2__Sequence__c = 1);
        insert POG;
        
        Apttus_Config2__ProductOptionComponent__c POC = new Apttus_Config2__ProductOptionComponent__c( Apttus_Config2__ComponentProductId__c = pr2.Id, Apttus_Config2__ProductOptionGroupId__c = POG.Id, Apttus_Config2__ParentProductId__c = pr1.Id, Apttus_Config2__Sequence__c = 1);
        insert POC;
        
        Apttus_Proposal__Proposal__c prop1 = new Apttus_Proposal__Proposal__c(Apttus_Proposal__Proposal_Name__c = 'Test Proposal',Degree_Type__c = 'Full-Time', Deposit__c = 1234, Payment_Method__c = 'Credit Card', Payment_Type__c = 'Monthly Payment', Payment_Period_In_Month__c = '10', First_Payment_Date__c = System.Today());
         prop1.RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Quote').getRecordTypeId();
        insert prop1;
        
        Apttus_Config2__LineItem__c line = new Apttus_Config2__LineItem__c();
        
        
        asset ass = new asset(name='ass1',AccountId = acc.id); 
        insert ass;
        
        Apttus_Config2__ProductConfiguration__c prod = new Apttus_Config2__ProductConfiguration__c();
        prod.Name = 'testp';
        prod.Apttus_QPConfig__Proposald__c = prop.Id;
        prod.Apttus_Config2__Status__c = 'Finalized';
        
        insert prod;

        Apttus_Config2__LineItem__c al = new Apttus_Config2__LineItem__c();
        //al.Apttus_Config2__AssetId__c = ass.id;
        // add option type product
        al.Apttus_Config2__ProductId__c = pr1.Id;
        al.Apttus_Config2__OptionId__c =  pr2.Id;
        al.Apttus_Config2__ProductOptionId__c = POC.Id;
        al.Discount_Reference__c = null;
        al.Apttus_Config2__LineNumber__c = 30;
        al.Apttus_Config2__ItemSequence__c = 1;
        al.Apttus_Config2__ConfigurationId__c= prod.id;
        al.Apttus_Config2__AdjustmentType__c = '% Discount';
        al.Apttus_Config2__AdjustmentAmount__c = 88;
        al.Apttus_Config2__LineType__c = 'Option';
        al.Discount_Reference__c = 'Academic Credit';
        al.Apttus_Config2__Quantity__c  = 2;
        
        insert al;
        
        Apttus_Config2__LineItem__c al1 = new Apttus_Config2__LineItem__c();
        // add bundle product 
        al1.Apttus_Config2__ProductId__c = pr1.Id;
        al1.Apttus_Config2__OptionId__c = null;
        al1.Apttus_Config2__AssetId__c = ass.id;
        al1.Discount_Reference__c = 'Academic Credit' ;
        al1.Apttus_Config2__LineNumber__c = 30;
        al1.Apttus_Config2__ItemSequence__c = 1;
        al1.Apttus_Config2__ConfigurationId__c= prod.id;
        al1.Apttus_Config2__AdjustmentType__c = '% Discount';
        al1.Apttus_Config2__AdjustmentAmount__c = 88;
        al1.Apttus_Config2__Quantity__c = 1;
        al1.Apttus_Config2__LineType__c = 'Product/Service';
        //al.Apttus_Config2__OptionId__c =  pr1.id;
        insert al1;
        
         Contract conn = new Contract();
            conn.Opportunity__c = op.Id;
            conn.AccountId= op.AccountId;
            conn.StartDate =system.today();
            conn.ContractTerm = 4;       
        //insert conn;
        
        //chain.proposalID = prop.Id;
        Apttus_Config2__ProductConfiguration__c prods = new Apttus_Config2__ProductConfiguration__c();
        prods.Name = 'testp';
        prods.Apttus_QPConfig__Proposald__c = prop1.Id;
        prods.Apttus_Config2__Status__c = 'Finalized';
        
        insert prods;
        Apttus_Config2__LineItem__c ali = new Apttus_Config2__LineItem__c();
        ali.Apttus_Config2__ProductId__c = pr1.Id;
        ali.Apttus_Config2__OptionId__c =  pr2.Id;
        ali.Apttus_Config2__ProductOptionId__c = POC.Id;
        ali.Discount_Reference__c = null;
        ali.Apttus_Config2__LineNumber__c = 30;
        ali.Apttus_Config2__ItemSequence__c = 1;
        ali.Apttus_Config2__ConfigurationId__c= prods.id;
        ali.Apttus_Config2__AdjustmentType__c = '% Discount';
        ali.Apttus_Config2__AdjustmentAmount__c = 88;
        ali.Apttus_Config2__LineType__c = 'Option';
        ali.Discount_Reference__c = 'Academic Credit';
        ali.Apttus_Config2__Quantity__c  = 2; 
        insert ali;
        
        CreateContractChain chain1 = new CreateContractChain();
        chain1.addLinesToCart();
        ApexPages.currentPage().getParameters().put('id',prop1.Id);
        CreateContractChain chain2 = new CreateContractChain();
        chain2.Clone_proposal();
        chain2.addLinesToCart();
        
        WrapperProductController obj = new WrapperProductController();
        chain2.CreateBundle(obj,null);
        ApexPages.currentPage().getParameters().put('id',prop.Id);
        CreateContractChain chain = new CreateContractChain();
        chain.Clone_proposal();
        chain.createCart();
        chain.addLinesToCart();
        chain.validateConstraints();
        chain.priceCart();
        chain.finalizeCart();
        chain.routeToQuote();
        chain.updatepricelist(true);
        
         OpportunityTriggerHandler testa=new OpportunityTriggerHandler(True,5);
         
         Opportunity[] oppty;
         Oppty = [SELECT AccountId,Registration_Payment_Reference1__c,Received_Signed_Registration_Contract__c,Courses_Applied_for_Other_Institutions__c, CreatedById, StageName, Status__c FROM Opportunity WHERE AccountId = : acc.Id limit 1];
         
         Opportunity[] oppty1;
          Oppty1 = [SELECT AccountId,Registration_Payment_Reference1__c,Received_Signed_Registration_Contract__c,Courses_Applied_for_Other_Institutions__c, CreatedById, StageName, Status__c FROM Opportunity WHERE AccountId = : acc.Id limit 1];
          
         map<id,Opportunity> oppma =new map<id,Opportunity>();
         
         List<Contract> conList = [select Id from Contract where AccountId =: acc.Id limit 1];
         if(!conList.isEmpty())
                 delete conList;

         //testa.OnAfterUpdate(oppty,oppty1,oppma);
         testa.OnBeforedelete(Oppty,oppma);
         testa.OnAfterdelete(Oppty,oppma);
         testa.OnUndelete(Oppty1);
       
       Test.Stoptest();
           System.assertEquals(True,  testa.bIsTriggerContext);  
           System.assertEquals(false,  testa.bIsVisualforcePageContext);   
           System.assertEquals(false, testa.bIsWebServiceContext);  
           System.assertEquals(false,  testa.bIsExecuteAnonymousContext); 
       }
    }
    
    static TestMethod void myUnitTest1(){  // TestMethod to test CreateContractChain Class
        Test.startTest();
        User u = [select Id, firstname from user where id=:userinfo.getuserid() limit 1];
        System.runAs(u){
        CreateContractChain c=new CreateContractChain();
        ApexPages.currentPage().getParameters().put('id','null');
        c.proposalID=null;
        c.cartID=null;
        c.Proposal_NewID=null;
        c.createCart(); 
        }
        Test.stopTest();
    }
}