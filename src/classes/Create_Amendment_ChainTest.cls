/*
     *@name myUnitTest() 
     *@return void 
     *@description This method for Insert Update and delete In Trigger OpportunityTeamMemberTrigger
     */

@isTest(SeeAllData=True)
private Class Create_Amendment_ChainTest {
    static testMethod void myUnitTest() { // TestMethod to test Create_Amendment_Chain Class
        
        Account acc = new Account(Name = 'AccTest1',Line_of_Business__c='Schools',CurrencyIsoCode='GBP',Geography__c = 'Growth',Organisation_Type__c = 'Higher Education',Type = 'School',Market__c='US',Phone = '9989887687');
        acc.ShippingStreet = 'TestStreet';
        acc.ShippingCity = 'Vns';
        acc.ShippingState = 'Delhi';
        acc.ShippingPostalCode = '234543';
        acc.ShippingCountry = 'India';
        insert acc;
        User u = [select Id, firstname from user where id=:userinfo.getuserid() limit 1];
        
        Opportunity op = new Opportunity(Name= 'OpTest1', AccountId = acc.id, StageName = 'Solutioning', Type = 'New Business', Academic_Vetting_Status__c = 'Un-Vetted', Academic_Start_Date__c = System.Today(),CloseDate = System.Today(),International_Student__c = true, Qualification__c = 'Test Bundle', Campus__c ='Durbanville', Level__c=1,Conferer__c='CTI',International_Sponsor__c = 'Yes');
        insert op;
        
        OpportunityTeamMember  OTeam = new OpportunityTeamMember(UserId = U.Id, TeamMemberRole ='Sales', OpportunityId = op.Id );
        insert OTeam;
        
        Contact con = new Contact(FirstName='CreateAmendment',LastName ='ChainTest',Phone='9999888898',Email='CreateAmendment.ChainTest@test.com', AccountId = acc.Id);
        insert con;
        
        OpportunityContactRole ocr  = new OpportunityContactRole(OpportunityId = op.Id, Role = 'Business User', IsPrimary= true);
        ocr.ContactId = con.Id;
        insert ocr;
        Quote_Settings__c qsvalue = Quote_Settings__c.getValues('System Properties');
        Apttus_Proposal__Proposal__c prop = new Apttus_Proposal__Proposal__c(Apttus_Proposal__Proposal_Name__c = 'Test Proposal',Apttus_Proposal__Opportunity__c = op.id,Degree_Type__c = 'Full-Time', Deposit__c = 1234, Payment_Method__c = 'Credit Card', Payment_Type__c = 'Monthly Payment', Payment_Period_In_Month__c = '10', First_Payment_Date__c = System.Today());
        prop.RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Contract').getRecordTypeId();
        prop.Apttus_Proposal__Primary__c = true;
        prop.Apttus_QPConfig__PriceListId__c = qsvalue.Early_Bird_Price_List_Id__c;
        insert prop;
        
        Product2 p = new Product2();
        p.Name = 'Test Bundle Level 2';
        p.Apttus_Config2__ConfigurationType__c = 'Bundle' ;
        p.ISBN__c = '12345678901';
        p.IsActive = true;
        P.Qualification_Name__c = 'Test Bundle';
        p.Campus__c='Durbanville';
        p.Qualification_Level_Name__c= 2;
        insert p;
        
        Product2 p1 = new Product2();
        p1.Name = 'Test Option';
        p1.Apttus_Config2__ConfigurationType__c = 'Option' ;
        p1.ISBN__c = '123456 IS';
        p1.IsActive = true;
        insert p1;
        
        Apttus_Config2__ClassificationName__c CN = new Apttus_Config2__ClassificationName__c(Name ='Test CN',Apttus_Config2__HierarchyLabel__c = 'Test CN', Apttus_Config2__Active__c = true);
        insert CN;
        
        Apttus_Config2__ClassificationHierarchy__c CH = new Apttus_Config2__ClassificationHierarchy__c(Name ='Test CH', Apttus_Config2__Label__c = 'Test CH', Apttus_Config2__HierarchyId__c = CN.Id);
        insert CH;
        
        Apttus_Config2__ProductOptionGroup__c POG = new Apttus_Config2__ProductOptionGroup__c(Apttus_Config2__RootOptionGroupId__c = CH.Id, Apttus_Config2__OptionGroupId__c = CH.Id, Apttus_Config2__ProductId__c = P.Id,Apttus_Config2__MaxOptions__c = 999, Apttus_Config2__Sequence__c = 1);
        insert POG;
        
        Apttus_Config2__ProductOptionComponent__c poc = new Apttus_Config2__ProductOptionComponent__c(Apttus_Config2__Sequence__c = 1,Apttus_Config2__ComponentProductId__c = p1.id, Apttus_Config2__RelationshipType__c = 'Option', Apttus_Config2__ParentProductId__c = p.id, Apttus_Config2__ProductOptionGroupId__c = POG.id, Apttus_Config2__Modifiable__c = true);
        insert poc;
        
        
        
        Pricebook2 standardPB = [select id from Pricebook2 where isStandard=true limit 1];
        Pricebook2 pbk1 = new Pricebook2 (Name='Test Pricebook Entry 1',Description='Test Pricebook Entry 1', isActive=true);
        Database.insert(pbk1);
        
        PricebookEntry pbe1 = new PricebookEntry (Product2ID= p.id,Pricebook2ID=standardPB.id,UnitPrice=50,IsActive = true);
        PricebookEntry customprice = new pricebookentry( product2id = p.id, pricebook2id = pbk1.id,UnitPrice=50, usestandardprice = false, IsActive = true);
        Database.insert(pbe1);
        Database.insert(customprice);
        
        OpportunityLineItem oli = new OpportunityLineItem (OpportunityId = op.Id,PricebookEntryId = pbe1.id,LineType__c='Product/Service',LineNumber__c =1,Quantity =1,TotalPrice=1000);
        insert oli;
        OpportunityLineItem oli1 = new OpportunityLineItem (OpportunityId = op.Id,ProductOptionId__c=poc.id,OptionId__c=p1.id,PricebookEntryId = pbe1.id,LineType__c='Option',LineNumber__c =1,Quantity =1,TotalPrice=1000);
        insert oli1;
        
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
        al.Apttus_Config2__ProductId__c = p.Id;
        al.Apttus_Config2__OptionId__c =  p1.Id;
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
        al1.Apttus_Config2__ProductId__c = p.Id;
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
        
         Opportunity op1 = new Opportunity(Name= 'OpTest2', AccountId = acc.id, StageName = 'Solutioning', Type = 'New Business', Academic_Vetting_Status__c = 'Un-Vetted', Academic_Start_Date__c = System.Today(),CloseDate = System.Today(),International_Student__c = true, Qualification__c = 'Test Bundle', Campus__c ='Durbanville', Level__c=1,Conferer__c='CTI',International_Sponsor__c = 'Yes');
        insert op1;
        Test.StartTest();
        Opportunity op2 = new Opportunity(Name= 'OpTest3', AccountId = acc.id, StageName = 'Solutioning', Type = 'Returning Business', Academic_Vetting_Status__c = 'Un-Vetted', Academic_Start_Date__c = System.Today(),CloseDate = System.Today(),International_Student__c = true, Qualification__c = 'Test Bundle', Campus__c ='Durbanville', Level__c=1,Conferer__c='CTI',International_Sponsor__c = 'Yes');
        insert op2;
         Apttus_Proposal__Proposal__c prop1 = new Apttus_Proposal__Proposal__c(Apttus_Proposal__Proposal_Name__c = 'Test Proposal',Apttus_Proposal__Opportunity__c = op2.id,Degree_Type__c = 'Full-Time', Deposit__c = 1234, Payment_Method__c = 'Credit Card', Payment_Type__c = 'Monthly Payment', Payment_Period_In_Month__c = '10', First_Payment_Date__c = System.Today());
        prop1.RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Contract').getRecordTypeId();
        prop1.Apttus_Proposal__Primary__c = true;
        prop1.Apttus_QPConfig__PriceListId__c = qsvalue.Early_Bird_Price_List_Id__c;
        insert prop1;
         System.runAs(u){
        ApexPages.currentPage().getParameters().put('oid',null);
        Create_Amendment_Chain amend1 = new Create_Amendment_Chain();
        ApexPages.currentPage().getParameters().put('oid',op1.Id);
        Create_Amendment_Chain amend2 = new Create_Amendment_Chain();
         amend2.cloneOppty();
         amend2.addLinesToCart();
        //amend2.Create_ContactRoles();
        amend2.Create_OpportunityTeam();
        amend2.createCart();
        amend2.Create_Quote();
        amend2.Clone_proposal();
        
        ApexPages.currentPage().getParameters().put('oid',op2.Id);
        Create_Amendment_Chain amend3 = new Create_Amendment_Chain();
        
        amend3.cloneOppty();
       // amend3.Create_ContactRoles();
        amend3.Create_OpportunityTeam();
        amend3.Clone_proposal();
        amend3.Create_Quote();
        amend3.Clone_proposal();
        amend3.addLinesToCart();
        
        ApexPages.currentPage().getParameters().put('oid',op.Id);
        Create_Amendment_Chain amend = new Create_Amendment_Chain();
        
        amend.cloneOppty();
        //amend.Create_ContactRoles();
        amend.Create_OpportunityTeam();
        amend.Create_Quote();
        amend.Clone_proposal();
        amend.createCart();
        amend.addLinesToCart();
        amend.validateConstraints();
        amend.priceCart();
        amend.finalizeCart();
        amend.routeToQuote();
        amend.updatepricelist(true);
        amend.updatepricelist(false);
       }
        Test.stopTest();
    }
}