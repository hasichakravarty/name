@isTest (seeAllData=true)
private class TestCreateOrder
{
    static testMethod void myUnitTest()
    {
        TestClassAutomation.FillAllFields = true;
        
        // seeAllData required for standard pricebook
        // delete all settings that exist in the org
        MAP<String,OpportunityToOrderFieldMapping__c> sExistingMappings = OpportunityToOrderFieldMapping__c.getAll();
        if (sExistingMappings.size() > 0)
        {
            delete sExistingMappings.values();
        }
        
        OpportunityToOrderEntryCriteria__c sCriteria    = new OpportunityToOrderEntryCriteria__c();
        sCriteria.Name                                  = 'TestCriteria1';
        sCriteria.Error_Message__c                      = 'This is a testing error';
        sCriteria.Field_Name__c                         = 'IsClosed';
        sCriteria.Field_Type__c                         = 'Boolean';
        sCriteria.Required_Value__c                     = 'true';
        insert sCriteria;
        
        OpportunityToOrderFieldMapping__c sMapping1     = new OpportunityToOrderFieldMapping__c();
        sMapping1.Name                                  = 'TestData1';
        sMapping1.Source_Object__c                      = 'Opportunity';
        sMapping1.Source_Field__c                       = 'Type';
        sMapping1.Destination_Object__c                 = 'Order__c';
        sMapping1.Destination_Field__c                  = 'OrderType__c';
        insert sMapping1;
        
        OpportunityToOrderFieldMapping__c sMapping2     = new OpportunityToOrderFieldMapping__c();
        sMapping2.Name                                  = 'TestData2';
        sMapping2.Source_Object__c                      = 'OpportunityLineItem';
        sMapping2.Source_Field__c                       = 'Description';
        sMapping2.Destination_Object__c                 = 'OrderLineItem__c';
        sMapping2.Destination_Field__c                  = 'Ordered_Item__c';
        insert sMapping2;
        
        OpportunityToOrderFieldMapping__c sMapping3     = new OpportunityToOrderFieldMapping__c();
        sMapping3.Name                                  = 'TestData3';
        sMapping3.Source_Object__c                      = 'Opportunity';
        sMapping3.Source_Field__c                       = 'AccountId';
        sMapping3.Destination_Object__c                 = 'Order__c';
        sMapping3.Destination_Field__c                  = 'Account__c';
        insert sMapping3;

        OpportunityToOrderFieldMapping__c sMapping4     = new OpportunityToOrderFieldMapping__c();
        sMapping4.Name                                  = 'TestData4';
        sMapping4.Source_Object__c                      = 'OpportunityLineItem';
        sMapping4.Source_Field__c                       = 'Product2Id';
        sMapping4.Destination_Object__c                 = 'OrderLineItem__c';
        sMapping4.Destination_Field__c                  = 'Product__c';
        insert sMapping4;
        
        Account sAccount                = (Account)TestClassAutomation.createSObject('Account');
        sAccount.BillingCountry         = 'Australia';
        sAccount.BillingState           = 'Victoria';
        sAccount.BillingCountryCode     = 'AU';
        sAccount.BillingStateCode       = 'VIC';
        sAccount.ShippingCountry        = 'Australia';
        sAccount.ShippingState          = 'Victoria';
        sAccount.ShippingCountryCode    = 'AU';
        sAccount.ShippingStateCode      = 'VIC';
        
        insert sAccount;
        
        Opportunity sOpportunity                = (Opportunity)TestClassAutomation.createSObject('Opportunity');
        sOpportunity.AccountId                  = sAccount.Id;
        sOpportunity.StageName                  = 'Prospecting';
        sOpportunity.Re_engagement_Date__c      = system.today().addMonths(1);
        sOpportunity.Renewal_Date__c            = system.today().addMonths(12);
        insert sOpportunity;
        
        Product2 sProduct                       = (Product2)TestClassAutomation.createSObject('Product2');
        insert sProduct;

        Pricebook2 sPriceBook = [select id, name, isActive from Pricebook2 where IsStandard = true limit 1];
        sPriceBook.IsActive = true;
        update sPriceBook;
        
        PriceBookEntry sPriceBookEntry          = (PriceBookEntry)TestClassAutomation.createSObject('PriceBookEntry');
        sPriceBookEntry.IsActive                = true;
        sPriceBookEntry.Product2Id              = sProduct.Id;
        sPriceBookEntry.Pricebook2Id            = sPriceBook.Id;
        sPriceBookEntry.UnitPrice               = 34.95;
        insert sPriceBookEntry;

        OpportunityLineItem sOLI            = new OpportunityLineItem();
        sOLI.OpportunityId                  = sOpportunity.Id;
        sOLI.PricebookEntryId               = sPriceBookEntry.Id;
        sOLI.TotalPrice                     = 200;
        sOLI.Quantity                       = 1;

        insert sOLI;
        
        Test.startTest();
        
            ApexPages.standardController controller = new ApexPages.standardController(sOpportunity);
            
            CreateOrderController conExtension = new CreateOrderController(controller); 
            conExtension.init();
            conExtension.actionReturn();
            
            sOpportunity.StageName = 'In Production';
            update sOpportunity;
            
                // Retreive field listings from custom settings
            list<OpportunityToOrderEntryCriteria__c>    lstcsCriteria           = OpportunityToOrderEntryCriteria__c.getall().values();
            list<OpportunityToOrderFieldMapping__c>     lstcsMappings           = OpportunityToOrderFieldMapping__c.getall().values();
            list<String> stringstoQuery = new list<String>();
        
            for(OpportunityToOrderFieldMapping__c csMapping : lstcsMappings)
            {
                if(csMapping.Source_Object__c == 'Opportunity')
                {
                    stringstoQuery.add(csMapping.Source_Field__c);
                }
            }
            
            for(OpportunityToOrderEntryCriteria__c csCriteria : lstcsCriteria)
            {
                stringstoQuery.add(csCriteria.Field_Name__c);
            }
            
            string strQuery = 'SELECT ForecastCategoryName ';
            
            for(String strField : stringstoQuery)
            {
                strQuery += ', ' + strField;
            }
            
            strQuery += ' FROM Opportunity WHERE Id = \'' + sOpportunity.Id + '\' limit 1';
            
            system.debug('strQuery:::' + strQuery);
            
            sOpportunity = database.query(strQuery);
            
            ApexPages.standardController controller2 = new ApexPages.standardController(sOpportunity);
            
            CreateOrderController conExtension2 = new CreateOrderController(controller2); 
            conExtension2.init();
            
        Test.stopTest();
    }
}