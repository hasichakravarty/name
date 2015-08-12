// Test class for Sync_Quote_to_Opportunity  
@isTest(SeeAllData = True)
public Class TestSync_Quote_to_Opportunity {
    //Test method for Sync_Quote_to_Opportunity
    static testMethod void myUnitTest() {
        User u = [select Id, username from User where Id = :UserInfo.getUserId()];  
        Sync_Quote_to_Opportunity sqo = new Sync_Quote_to_Opportunity ();
        
        Account acc = new Account(Name = 'AccTest1',Line_of_Business__c='Schools',CurrencyIsoCode='GBP',Geography__c = 'Growth',Organisation_Type__c = 'Higher Education',Type = 'School',Market__c ='US');
        Opportunity op = new Opportunity(Name= 'OpTest1', AccountId = acc.id, StageName = 'Solutioning', Type = 'New Business', Academic_Vetting_Status__c = 'Un-Vetted', Academic_Start_Date__c = System.Today(),CloseDate = System.Today(),International_Student__c = true);
        Test.StartTest();
        system.RunAs(u){
        insert acc;
        insert op;
        
         Pricebook2 standardPB = [select id from Pricebook2 where isStandard=true limit 1];
        // Pricebook2 standardPB = new Pricebook2 (Name='Test Pricebook Entry',Description='Test Pricebook Entry', isActive=true, isStandard = true);
       // insert standardPB;
        Product2 pr = new Product2(Name = 'Bundle Product', IsActive = true, Apttus_Config2__ConfigurationType__c = 'Bundle',Qualification_Name__c = 'Test Bundle',Campus__c='Durbanville',Qualification_Level_Name__c= 2);
        insert pr;
        
        // Product2 pr2 = new Product2(Name = 'Option Product', IsActive = true, Apttus_Config2__ConfigurationType__c = 'Option');
        //insert pr2;
        
        Pricebook2 pbk1 = new Pricebook2 (Name='Test Pricebook Entry 1',Description='Test Pricebook Entry 1', isActive=true);
        Database.insert(pbk1);
        
        
        PricebookEntry pbe1 = new PricebookEntry (Product2ID= pr.id,Pricebook2ID=standardPB.id,UnitPrice=50,IsActive = true);
        PricebookEntry customprice = new pricebookentry( product2id = pr.id, pricebook2id = pbk1.id,UnitPrice=50, usestandardprice = false, IsActive = true);
        Database.insert(pbe1);
        Database.insert(customprice);
        
        Apttus_Proposal__Proposal__c prop = new Apttus_Proposal__Proposal__c(Apttus_Proposal__Proposal_Name__c = 'Test Proposal',Apttus_Proposal__Opportunity__c = op.id,Degree_Type__c = 'Full-Time', Deposit__c = 1234, Payment_Method__c = 'Credit Card', Payment_Type__c = 'Monthly Payment', Payment_Period_In_Month__c = '10', First_Payment_Date__c = System.Today());
        insert prop;
        Apttus_Proposal__Proposal__c prop1 = new Apttus_Proposal__Proposal__c(Apttus_Proposal__Proposal_Name__c = 'Test Proposal',Degree_Type__c = 'Full-Time', Deposit__c = 1234, Payment_Method__c = 'Credit Card', Payment_Type__c = 'Monthly Payment', Payment_Period_In_Month__c = '10', First_Payment_Date__c = System.Today());
        insert prop1;
        
        Apttus_Config2__ProductConfiguration__c qpConfig = new Apttus_Config2__ProductConfiguration__c(Name ='TestConfig', Apttus_Config2__Status__c = 'Finalized',Apttus_QPConfig__Proposald__c = prop.Id);
        insert qpConfig;
        Apttus_Proposal__Proposal_Line_Item__c pli = new Apttus_Proposal__Proposal_Line_Item__c();
        pli.Apttus_QPConfig__ItemSequence__c = 1;
        pli.Apttus_QPConfig__LineNumber__c =1;
        pli.Apttus_QPConfig__LineStatus__c = 'New';
        pli.Apttus_Proposal__Proposal__c= prop.id;
        pli.Apttus_QPConfig__ConfigurationId__c =qpConfig.id;
        pli.Apttus_Proposal__Product__c=pr.id;
        insert pli;
        
        sqo.proposalID = prop.id;
        //Calling the method Copy_Proposal_to_Oppty()
        sqo.Copy_Proposal_to_Oppty();
        sqo.proposalID = prop1.id;
        sqo.Copy_Proposal_to_Oppty();
        Test.stopTest();
        }
    }
        
}