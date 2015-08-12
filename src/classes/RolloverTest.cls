/*
     *@name myUnitTest() 
     *@return void 
     *@description This method for Insert Update and delete In Trigger OpportunityTeamMemberTrigger
     */

@isTest(SeeAllData=True)
private Class RolloverTest {
    static testMethod void myUnitTest() {
        //Test method for Rollover Class
        Account acc = new Account(Name = 'AccTest1',Line_of_Business__c='Schools',CurrencyIsoCode='GBP',Geography__c = 'Growth',Organisation_Type__c = 'Higher Education',Type = 'School',Market__c='US',Phone = '9989887687');
        acc.ShippingStreet = 'TestStreet';
        acc.ShippingCity = 'Vns';
        acc.ShippingState = 'Delhi';
        acc.ShippingPostalCode = '234543';
        acc.ShippingCountry = 'India';
        insert acc;
        User u = [select Id, firstname , isActive from user where id=:userinfo.getuserid() limit 1];
        
        Opportunity op = new Opportunity(Name= 'OpTest1', AccountId = acc.id, StageName = 'Solutioning', Type = 'New Business', Academic_Vetting_Status__c = 'Un-Vetted', Academic_Start_Date__c = System.Today(),CloseDate = System.Today(),International_Student__c = true, Qualification__c = 'Test Bundle', Campus__c ='Durbanville', Level__c=1,Conferer__c='CTI', Preferred_Campus__c = 'Bedfordview');
        insert op;
        
        OpportunityTeamMember  OTeam = new OpportunityTeamMember(UserId = U.Id, TeamMemberRole ='Sales', OpportunityId = op.Id  );
        insert OTeam;
        
        
        Contact con = new Contact(FirstName='Rollover',LastName ='Rollovertest',Phone='9999888898',Email='Rollover.Rollovertest@test.com', AccountId = acc.Id);
        insert con;
        
        OpportunityContactRole ocr  = new OpportunityContactRole(OpportunityId = op.Id, Role = 'Decision Maker', IsPrimary= true);
        ocr.ContactId = con.Id;
        insert ocr;
        Test.StartTest();
        Product2 p = new Product2();
        p.Name = 'Test Bundle Level 2';
        p.Apttus_Config2__ConfigurationType__c = 'Bundle' ;
        p.ISBN__c = '12345678901';
        p.IsActive = true;
        P.Qualification_Name__c = 'Test Bundle';
        p.Campus__c='Durbanville';
        p.Qualification_Level_Name__c= 2;
        p.Conferer__c = 'CTI';
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

        //ApexPages.StandardController std = new ApexPages.StandardController(op);
        Opportunity op1 = new Opportunity(Name= 'Test Bundle 1', AccountId = acc.id, StageName = 'Solutioning', Type = 'New Business', Academic_Vetting_Status__c = 'Un-Vetted', Academic_Start_Date__c = System.Today(),CloseDate = System.Today(),International_Student__c = true, Qualification__c = 'Test Bundle', Campus__c ='Durbanville', Level__c=1, Preferred_Campus__c = 'Bedfordview');
        insert op1;
        
        ApexPages.currentPage().getParameters().put('id',op1.id);
        Rollover roll2 = new Rollover();
        roll2.createOppty();
        //roll2.proposal_new = null;
        //roll2.routeToQuote();
        System.runAs(u){
        ApexPages.currentPage().getParameters().put('id',null);
        Rollover roll1 = new Rollover();
        
        //roll1.routeToQuote();
        ApexPages.currentPage().getParameters().put('id',op.id);
        Rollover roll = new Rollover();
        //roll.Create_ContactRoles();
        //roll.opportunityId = op.id;
        //roll.onLoad_dorollover();
        roll.createOppty();
        roll.Create_Quote();
        roll.routeToQuote();
        //roll.Create_ContactRoles();
        roll.Create_OpportunityTeam();
        roll.Create_Quote();
        roll.cretaeApttusobjects();
        roll.routeToQuote();
        }
        Update OTeam;
        
        Delete OTeam;
        
        //UnDelete OTeam; 
               
        /*WrapperProductController wrap= new WrapperProductController();
        wrap.ProductId = p.id;
        WrapperProductController.WrapperProductOption wrapOption = new WrapperProductController.WrapperProductOption();
        wrapOption.RecordId = poc.id;
        wrapOption.ProductId = p1.id;
        wrapOption.ProductOptionId = poc.Name;
        wrap.productoptions.add(wrapOption);
        roll.cpq.CreateBundle(wrap,roll.cartID);*/
        Test.stopTest();
    }
}