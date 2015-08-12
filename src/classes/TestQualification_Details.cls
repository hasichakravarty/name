/*******************************************************************************************************************
* Apex Class Name  : TestQualification_Details
* Version          : 1.0 
* Created Date     : 27 March 2015
* Function         : Test Class of the Qualification_Details Trigger
* Modification Log :
*
* Developer                                Date                    Description
* ------------------------------------------------------------------------------------------------------------------
*   Accenture IDC                          31/03/2015              Created Initial Version
*******************************************************************************************************************/


@isTest(SeeAllData=true)
public Class TestQualification_Details {
    static testMethod void myUnitTest() {
        Test.StartTest();
        Account acc = new Account(Name = 'AccTest1',Line_of_Business__c='Schools',CurrencyIsoCode='GBP',Geography__c = 'Growth',Organisation_Type__c = 'Higher Education',Type = 'School');
        Opportunity op = new Opportunity(Name= 'OpTest1', AccountId = acc.id, StageName = 'Solutioning', Type = 'New Business', Academic_Vetting_Status__c = 'Un-Vetted', Academic_Start_Date__c = System.Today(),CloseDate = System.Today(),International_Student__c = true);
        Apttus_Config2__PriceList__c price = new Apttus_Config2__PriceList__c(Name = 'CTI - MGI  Costs 2014',CurrencyIsoCode='GBP');
        Apttus_Config2__PriceList__c price1 = new Apttus_Config2__PriceList__c(Name = 'CTI - MGI  Costs 2015',CurrencyIsoCode='GBP');
        Apttus_Proposal__Proposal__c prop = new Apttus_Proposal__Proposal__c ();
        prop.Apttus_Proposal__Proposal_Name__c = 'Proposal1';
        prop.Apttus_Proposal__Opportunity__c = op.id;
        prop.Degree_Type__c = 'Full-Time';
        prop.Payment_Method__c = 'Cash';
        prop.Payment_Type__c = '30% Deposit';
        prop.Deposit__c = 3452;
        prop.Payment_Period_In_Month__c = '10';
        prop.First_Payment_Date__c = system.today();
        prop.Total_Early_Bird_Securing_Fee_Payments__c = 234456;
        prop.Apttus_QPConfig__PriceListId__c = price.id;
        insert acc;
        insert op;
        insert price;
        insert prop;
        insert price1;
        Apttus_Proposal__Proposal_Line_Item__c lineItem = new Apttus_Proposal__Proposal_Line_Item__c();
        lineItem.Apttus_QPConfig__ClassificationHierarchy__c = 'CTI - MGI | MGI | Bachelor of Arts in Graphic Design | Durbanville';
        lineItem.Apttus_QPConfig__LineNumber__c = 1;
        lineItem.Apttus_QPConfig__LineType__c = 'Product/Service';
        lineItem.Outside_Module__c = true;
        lineItem.Apttus_QPConfig__ItemSequence__c =0;
        lineItem.Apttus_Proposal__Proposal__c = prop.id;
        
        insert lineItem;
        prop.Total_Early_Bird_Securing_Fee_Payments__c  = 453679;
        prop.Apttus_QPConfig__ConfigurationFinalizedDate__c = system.now();
        prop.Apttus_QPConfig__PriceListId__c = price1.id;
       // prop.Payment_Type__c = '30% Deposit';
        update prop;
        
        
        Test.StopTest();
    }
}