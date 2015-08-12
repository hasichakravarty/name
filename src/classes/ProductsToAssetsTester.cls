// Project: Convert Assets from Product Info.
// Created by: Comity Designs [Developer: Rashi Girdhar]
// Class: ProductsToAssetsTester.cls      
// Description: Custom controller Tester
// Other Package Classes: ProductsToAssets.cls, AssetWrapper.cls
// VisualForce Page: ProductsToAssets.page
// Date: 8/3/2009
//
// Change Log:
// Data | Description
// 2/21/2011 | Updated Test Class - Better Code Coverage

/**
 ** Class: ProductsToAssetsTester
**/

@isTest(seeAllData=true) // Using isTest annotation
private class ProductsToAssetsTester {

    
    // Test Methods [Each test method is self-sufficient]
    public static testMethod void testOIDQueryParamsMissing() {
        PageReference PTAPage;
        ProductsToAssets PTAController;
        
        try {
        
            Test.startTest();
            
            PTAPage = Page.ProductsToAssets;
            Test.setCurrentPage(PTAPage);
            
            PTAController = new ProductsToAssets(true);
            
            Test.stopTest();
        } catch (Exception e) {
            System.debug(e.getMessage());
            System.AssertEquals(e.getMessage(), 'Manual Exception: OID or AID is Null!');
            //System.Assert(e.getMessage().contains('Manual Exception'));
            System.debug('Info: AssertEquals just occured!');
        }
    }
    
    // Test Methods [Each test method is self-sufficient]
    public static testMethod void testOIDQueryParamsMissing2() {
        PageReference PTAPage;
        ProductsToAssets PTAController;
        
        try {
            Test.startTest();
        
            PTAPage = Page.ProductsToAssets;
            Test.setCurrentPage(PTAPage);
            
            PTAController = new ProductsToAssets();
            
            Test.stopTest();
        } catch (Exception e) {
            System.debug(e.getMessage());
            System.AssertEquals(e.getMessage(), 'Manual Exception: OID or AID is Null!');
            //System.Assert(e.getMessage().contains('Manual Exception'));
            System.debug('Info: AssertEquals just occured!');
        }
    }
    
    public static testMethod void testAIDQueryParamsMissing() {
        PageReference PTAPage;
        ProductsToAssets PTAController;
        Account a1;
        Opportunity o1;      
        String AcctRecordTypeId;
        String ContactRecordTypeId;
        String OptyRecordTypeId;              
        
        try {
            List<RecordType> RecordTypeList = new List<RecordType>([select Id,Name from RecordType]);
            
            for (RecordType i : RecordTypeList) {
              if (i.Name == 'Bookstore') {
                AcctRecordTypeId = i.Id;
              }
              if (i.Name == 'Contact') {
                 ContactRecordTypeId = i.Id;
              }
              if (i.Name == 'Opportunity') {
                OptyRecordTypeId = i.Id;
              }                    
            }                
    
            // Create and Insert Account
            a1 = new Account(Name='CTest',BillingStreet = 'Street1',
                   BillingCity = 'London', BillingPostalCode = 'ABC DEF', BillingCountry = 'Australia',
                    Vista_Account_Number__c = 'xyz',RecordTypeId= AcctRecordTypeId);
            insert a1;
            // Create and Insert Opportunity
            o1 = new Opportunity(Name='CTestOpp', AccountId=a1.Id, StageName='Closed Won', CloseDate=Date.today(),
               Re_engagement_Date__c = system.today().addmonths(1), Renewal_Date__c = system.today().addmonths(8), RecordTypeId=OptyRecordTypeId ); 
            insert o1;     

            // Test with a valid OID and no AID
            PTAPage = new PageReference('/apex/ProductsToAssets?oid='+ o1.ID);
            Test.setCurrentPage(PTAPage);
            
            Test.startTest();
            
            PTAController = new ProductsToAssets(true);         
            
            Test.stopTest();
        } catch (Exception e) {
            System.debug(e.getMessage());
            System.AssertEquals(e.getMessage(), 'Manual Exception: OID or AID is Null!');
            System.debug('Info: AssertEquals just occured!');
        }
    }   
    
    public static testMethod void testInvalidOIDQueryParam() {
        PageReference PTAPage;
        ProductsToAssets PTAController;
        Account a1;
        Opportunity o1;
        
        String invalidOID;
        String invalidAID;
        
        Boolean flag;
        
        try {
            invalidOID = '006123456789123';
            invalidAID = '001A123456789123';
            
            // Run with Invalid OID
            PTAPage = new PageReference('/apex/ProductsToAssets?oid='+ invalidOID + '&aid=' + invalidAid);
            Test.setCurrentPage(PTAPage);
            
            Test.startTest();
            
            PTAController = new ProductsToAssets(true);
            
            Test.stopTest();
        } catch (Exception e) {
            System.debug('Wanted Excpetion Caught: ' + e.getMessage());
            System.AssertEquals(e.getMessage(), 'Invalid id: 006123456789123');
            System.debug('Test Info: AssertEquals just occured!');
        }
    }
    
        
    public static testMethod void testInvalidAIDQueryParam() {
        PageReference PTAPage;
        ProductsToAssets PTAController;
        Account a1;
        Opportunity o1;
        String AcctRecordTypeId;
        String ContactRecordTypeId;
        String OptyRecordTypeId; 

        String invalidOID;
        String invalidAID;
        
        Boolean flag;
        
        try {
            invalidOID = '006123456789123';
            invalidAID = '001A123456789123';
            flag = false; // false for invalidAID
            List<RecordType> RecordTypeList = new List<RecordType>([select Id,Name from RecordType]);
            
            for (RecordType i : RecordTypeList) {
              if (i.Name == 'Bookstore') {
                AcctRecordTypeId = i.Id;
              }
              if (i.Name == 'Contact') {
                 ContactRecordTypeId = i.Id;
              }
              if (i.Name == 'Opportunity') {
                OptyRecordTypeId = i.Id;
              }                    
            }                
    
            // Create and Insert Account
            a1 = new Account(Name='CTest',BillingStreet = 'Street1',
                   BillingCity = 'London', BillingPostalCode = 'ABC DEF', BillingCountry = 'Australia',
                    Vista_Account_Number__c = 'xyz',RecordTypeId= AcctRecordTypeId);
            insert a1;
            // Create and Insert Opportunity
            o1 = new Opportunity(Name='CTestOpp', AccountId=a1.Id, StageName='Closed Won', CloseDate=Date.today(),
            Re_engagement_Date__c = system.today().addmonths(1), Renewal_Date__c = system.today().addmonths(8), RecordTypeId=OptyRecordTypeId); 
            insert o1;

            // Run with Valid OID and Invalid AID
            flag = true;
           	PTAPage = new PageReference('/apex/ProductsToAssets?oid='+ o1.ID +'&aid='+ invalidAID);
           	//PTAPage = new PageReference('/apex/ProductsToAssets?oid='+ o1.ID);
            Test.setCurrentPage(PTAPage);
            
            Test.startTest();
            
            PTAController = new ProductsToAssets(true);
    
            Test.stopTest();
        } catch (Exception e) {
            System.debug('Wanted Excpetion Caught: ' + e.getMessage());
            System.AssertEquals(e.getMessage(), 'Invalid id: 001A123456789123');
            System.debug('Test Info: AssertEquals just occured!');
        }
    }
    
    public static testMethod void testButtons() {
        // Testing Cancel, gotoAccount, convert, Toggle View
        PageReference PTAPage;
        ProductsToAssets PTAController;
        Account a1;
        Opportunity o1;
        OpportunityLineItem oli1;
        PageReference opportunityPage;
        PageReference accountPage;
        
        Double quantity = 2.00;
        
        UniversityCourse__c uc1;
        OpportunityUniversityCourse__c ouc1;
        String AcctRecordTypeId;
        String ContactRecordTypeId;
        String OptyRecordTypeId;              
        
        try {       
            List<RecordType> RecordTypeList = new List<RecordType>([select Id,Name from RecordType]);
            
            for (RecordType i : RecordTypeList) {
              if (i.Name == 'Bookstore') {
                AcctRecordTypeId = i.Id;
              }
              if (i.Name == 'Contact') {
                 ContactRecordTypeId = i.Id;
              }
              if (i.Name == 'Opportunity') {
                OptyRecordTypeId = i.Id;
              }                    
            }                
    
            // Create and Insert Account
            a1 = new Account(Name='CTest',BillingStreet = 'Street1',
                   BillingCity = 'London', BillingPostalCode = 'ABC DEF', BillingCountry = 'Australia',
                    Vista_Account_Number__c = 'xyz',RecordTypeId= AcctRecordTypeId);
            insert a1;
            // Create and Insert Opportunity
            o1 = new Opportunity(Name='CTestOpp', AccountId=a1.Id, StageName='Closed Won', CloseDate=Date.today(),
               Re_engagement_Date__c = system.today().addmonths(1), Renewal_Date__c = system.today().addmonths(8), RecordTypeId=OptyRecordTypeId ); 
            insert o1;
            System.debug('Test Info: Inserted Opportunity!');
            
            // Run with Valid OID and Valid AID
            PTAPage = new PageReference('/apex/ProductsToAssets?oid='+ o1.Id +'&aid='+a1.Id);
            Test.setCurrentPage(PTAPage);
            
            Test.startTest();
            
            accountPage = new ApexPages.StandardController(a1).view();
            opportunityPage = new ApexPages.StandardController(o1).view();
            
            PTAController = new ProductsToAssets(true);
            
            // Testing Cancel Button
            PageReference cancelPage = PTAController.cancel();
            
            System.AssertEquals(cancelPage.getUrl(), opportunityPage.getUrl());
            System.debug('Test Info: Cancel Button - AssertEquals just occured!');
            
            /*
            // Testing gotoAccount Button
            PTAController = new ProductsToAssets(true);
            PageReference gotoAccountPage = PTAController.gotoAccount();
            
            System.AssertEquals(gotoAccountPage.getUrl(), accountPage.getUrl());
            System.debug('Test Info: gotoAccount Button - AssertEquals just occured!');
            */
            
            // Testing convert Button without any Opportunity Line Items [including case for none selected]
            PTAController = new ProductsToAssets(true);
            PageReference convertPage = PTAController.convert();
            
            System.AssertEquals(convertPage, null);
            System.debug('Test Info: convert Button - AssertEquals just occured!');
            
            // Testing convert Button with Opportunity Line Items on Opportunity
            // Get an entry from the Pricebook Table to create and insert the Opportunity Line Item
            String PBE_Id = [select ID from PriceBookEntry where PriceBook2.Name = 'Standard Price Book' limit 1].ID;
            
            // Create and Insert an Opportunity Line Item
            oli1 = new OpportunityLineItem(OpportunityId=o1.id, Quantity=quantity, TotalPrice=200, PriceBookEntryID=PBE_Id);
            insert oli1;
            System.debug('Test Info: Inserted Opportunity Line Item!');
            
            //Add University Course to Opportunity
            uc1 = new UniversityCourse__c(Name='CTestUC',Account__c=a1.Id);
            insert uc1;
            ouc1 = new OpportunityUniversityCourse__c(Opportunity__c=o1.Id,UniversityCourse__c=uc1.id);
            insert ouc1;       
            
            PTAController = new ProductsToAssets(true);
            // Select Items so we can have a successful convert [Lets Deselect all first and then Select All]
            PageReference deselectAllPage = PTAController.deselectAll();
            PageReference selectAllPage = PTAController.selectAll();
            // Run convert method
            PageReference convertPage2 = PTAController.convert();
            
            System.AssertEquals(convertPage2.getUrl(), accountPage.getUrl());
            System.debug('Test Info: convert Button - AssertEquals just occured!');
            
            // Testing ToggleView
            PTAController = new ProductsToAssets(true);
                    
            // Test 1 - ToggleView not called [Initial view should be multiple quantity asset view]
            System.assertEquals(PTAController.assetW.size(), 1.00);
            System.debug('Test Info: Toggle Button [Test1: ToggleView not Called] - AssertEquals just occured!');
            
            // Test 2 - ToggleView called [Now multiple quantity assets will be broken into single quantities]
            PageReference toggleViewPage = PTAController.toggleView();
            
            System.assertEquals(PTAController.getAssetW().size(), quantity);
            System.debug('Test Info: Toggle Button [Test2: ToggleView Called once] - AssertEquals just occured!');
            
            // Test 3 - ToggleView called [Now multiple quantity assets view is shown again - Quantity of 1]
            toggleViewPage = PTAController.toggleView();
            
            System.assertEquals(PTAController.assetW.size(), 1.00);
            System.debug('Test Info: Toggle Button [Test3: ToggleView Called twice] - AssertEquals just occured!');
            

            Test.stopTest();
        } catch (Exception e){
            System.debug('Unwanted Excpetion Caught: ' + e.getMessage());
            
        }
    }
    
    public static testMethod void testGetters() {
        PageReference PTAPage;
        ProductsToAssets PTAController;
        Account a1;
        Opportunity o1;
        OpportunityLineItem oli1;
        PageReference opportunityPage;
        PageReference accountPage;
        
        Double quantity = 2.00;
        String AcctRecordTypeId;
        String ContactRecordTypeId;
        String OptyRecordTypeId;
        
        try {       
           List<RecordType> RecordTypeList = new List<RecordType>([select Id,Name from RecordType]);
            
            for (RecordType i : RecordTypeList) {
              if (i.Name == 'Bookstore') {
                AcctRecordTypeId = i.Id;
              }
              if (i.Name == 'Contact') {
                 ContactRecordTypeId = i.Id;
              }
              if (i.Name == 'Opportunity') {
                OptyRecordTypeId = i.Id;
              }                    
            }                
    
            // Create and Insert Account
            a1 = new Account(Name='CTest',BillingStreet = 'Street1',
                   BillingCity = 'London', BillingPostalCode = 'ABC DEF', BillingCountry = 'Australia',
                    Vista_Account_Number__c = 'xyz',RecordTypeId= AcctRecordTypeId);
            insert a1;
            System.debug('Test Info: testGetters - Inserted Account!');
                        
           
            // Create and Insert Opportunity
            o1 = new Opportunity(Name='CTestOpp', AccountId=a1.Id, StageName='Closed Won', CloseDate=Date.today(),
               Re_engagement_Date__c = system.today().addmonths(1), Renewal_Date__c = system.today().addmonths(8), RecordTypeId=OptyRecordTypeId ); 
            insert o1;
            System.debug('Test Info: testGetters - Inserted Opportunity!');
            
            // Testing convert Button with Opportunity Line Items on Opportunity
            // Get an entry from the Pricebook Table to create and insert the Opportunity Line Item
            String PBE_Id = [select ID from PriceBookEntry where PriceBook2.Name = 'Standard Price Book' limit 1].ID;
            System.debug('PriceBookEntry ID: ' + PBE_Id);
            
            // Create and Insert an Opportunity Line Item
            oli1 = new OpportunityLineItem(OpportunityId=o1.id, Quantity=quantity, TotalPrice=200, PriceBookEntryID=PBE_Id);
            insert oli1;
            System.debug('Test Info: testGetters - Inserted Opportunity Line Item!');
            
            // Run with Valid OID and Valid AID
            PTAPage = new PageReference('/apex/ProductsToAssets?oid='+ o1.Id +'&aid='+a1.Id);
            Test.setCurrentPage(PTAPage);
            
            Test.startTest();
            
            accountPage = new ApexPages.StandardController(a1).view();
            opportunityPage = new ApexPages.StandardController(o1).view();
            
            PTAController = new ProductsToAssets(true);
            
            // Test getOpportunityID
            System.assertEquals(PTAController.getOpportunityID(), o1.ID);
            System.debug('Test Info: getOpportunityID - AssertEquals just occured!');
            
            // Test getAccountID
            System.assertEquals(PTAController.getAccountID(), a1.ID);
            System.debug('Test Info: getAccountID - AssertEquals just occured!');
            
            // Test getAccount
            System.assertEquals(PTAController.getAccount().ID, a1.ID);
            System.debug('Test Info: getAccount - AssertEquals just occured!');
            
            // Test getToggleFlag, Section Header, and Button Header
            System.assertEquals(PTAController.getToggleFlag(), false);
            System.debug('Test Info: getToggleFlag - AssertEquals just occured!');
            
            System.assertEquals(PTAController.getSectionHeader(), 'Multiple Quantity Asset View');
            System.debug('Test Info: getSectionHeader - Multiple Quantity Asset View : AssertEquals just occured!');
            
            System.assertEquals(PTAController.getToggleButtonHeader(), 'View Single Quantity Assets');
            System.debug('Test Info: getToggleButtongHeader - View Single Quantity Asses : AssertEquals just occured!');
                        
            /// Call ToggleView and Assert
            PageReference togglePage = PTAController.toggleView();
            
            System.assertEquals(PTAController.getToggleFlag(), true);
            System.debug('Test Info: getToggleFlag - AssertEquals just occured!');
            
            System.assertEquals(PTAController.getSectionHeader(), 'Single Quantity Asset View');
            System.debug('Test Info: getSectionHeader - Single Quantity Asset View : AssertEquals just occured!');
            
            System.assertEquals(PTAController.getToggleButtonHeader(), 'View Multiple Quantity Assets');
            System.debug('Test Info: getToggleButtonHeader - View Multiple Quantity Assets : AssertEquals just occured!');

            // Test getOLIS - Should be set to null before the constructor concludes
            System.assertEquals(PTAController.getOLIS(), null);
            System.debug('Test Info: getOLIS - AssertEquals just occured!');
            
            // Test convertedAssets - Should be 0, since no assets were previously converted
            System.assertEquals(PTAController.getConvertedAssets().size(), 0);
            System.debug('Test Info: getConvertedAssets - AssertEquals just occured!');
            
            System.assertEquals(PTAController.getConvertedAssetsCount(), 0);
            System.debug('Test Info: getConvertedAssetsCount : AssertEquals just occured!');

            Test.stopTest();
        } catch (Exception e){
            System.debug('Unwanted Excpetion Caught: ' + e.getMessage());
            
        }
    }
    
    public static testMethod void testExceptionBlocks() {
        PageReference PTAPage;
        ProductsToAssets PTAController;
        Account a1;
        Opportunity o1;
        OpportunityLineItem oli1;
        PageReference opportunityPage;
        PageReference accountPage;
        
        Double quantity = 2.00;
        String AcctRecordTypeId;
        String ContactRecordTypeId;
        String OptyRecordTypeId;
        
        Test.startTest();
        
        try {       
           List<RecordType> RecordTypeList = new List<RecordType>([select Id,Name from RecordType]);
            
            for (RecordType i : RecordTypeList) {
              if (i.Name == 'Bookstore') {
                AcctRecordTypeId = i.Id;
              }
              if (i.Name == 'Contact') {
                 ContactRecordTypeId = i.Id;
              }
              if (i.Name == 'Opportunity') {
                OptyRecordTypeId = i.Id;
              }                    
            }                
    
            // Create and Insert Account
            a1 = new Account(Name='CTest',BillingStreet = 'Street1',
                   BillingCity = 'London', BillingPostalCode = 'ABC DEF', BillingCountry = 'Australia',
                    Vista_Account_Number__c = 'xyz',RecordTypeId= AcctRecordTypeId);
            insert a1;
            System.debug('Test Info: Inserted Account!');
            
            // Create and Insert Opportunity
            o1 = new Opportunity(Name='CTestOpp', AccountId=a1.Id, StageName='Closed Won', CloseDate=Date.today(),
               Re_engagement_Date__c = system.today().addmonths(1), Renewal_Date__c = system.today().addmonths(8), RecordTypeId=OptyRecordTypeId );  
            insert o1;
            System.debug('Test Info: Inserted Opportunity!');
            
            // Testing convert Button with Opportunity Line Items on Opportunity
            // Get an entry from the Pricebook Table to create and insert the Opportunity Line Item
            String PBE_Id = [select ID from PriceBookEntry where PriceBook2.Name = 'Standard Price Book' limit 1].ID;
            
            // Create and Insert an Opportunity Line Item
            oli1 = new OpportunityLineItem(OpportunityId=o1.id, Quantity=quantity, TotalPrice=200, PriceBookEntryID=PBE_Id);
            insert oli1;
            System.debug('Test Info: Inserted Opportunity Line Item!');
            
            // Run with Valid OID and Valid AID
            PTAPage = new PageReference('/apex/ProductsToAssets?oid='+ o1.Id +'&aid='+a1.Id);
            Test.setCurrentPage(PTAPage);
            
            accountPage = new ApexPages.StandardController(a1).view();
            opportunityPage = new ApexPages.StandardController(o1).view();
            
            
        } catch (Exception e) {
            System.debug(e.getMessage());
        }
        
        // setAccountName will throw an exception
        try {
        
            PTAController = new ProductsToAssets(true);
            PTAController.setThrowException(true);
            PTAController.setAccountOpportunityName();
            
        } catch (Exception e){
            //System.assertEquals(e.getMessage(), 'Manual Exception!');
            System.Assert(e.getMessage().contains('Manual Exception'));
        }
        
        // setOLIS will throw an exception
        try {
            PTAController = new ProductsToAssets(true);
            PTAController.setThrowException(true);
            PTAController.setOLIS();
        } catch (Exception e){
            //System.assertEquals(e.getMessage(), 'Manual Exception!');
            System.Assert(e.getMessage().contains('Manual Exception'));
        } 
        
        // setConvertedAssets will throw an exception
        try {
            PTAController = new ProductsToAssets(true);
            PTAController.setThrowException(true);
            PTAController.setConvertedAssets(); 
        } catch (Exception e){
            //System.assertEquals(e.getMessage(), 'Manual Exception!');
            System.Assert(e.getMessage().contains('Manual Exception'));
        } 
        // setAssetWrapperList will throw an exception
        try {
            PTAController = new ProductsToAssets(true);
            PTAController.setOLIS();
            PTAController.setThrowException(true);
            PTAController.setAssetWrapperList(); 
        } catch (Exception e){
            //System.assertEquals(e.getMessage(), 'Manual Exception!');
            System.Assert(e.getMessage().contains('Manual Exception'));
        } 
        
        // Cancel will throw an exception
        try {
            PTAController = new ProductsToAssets(true);
            PTAController.setThrowException(true);
            PTAController.cancel(); 
        } catch (Exception e){
            //System.assertEquals(e.getMessage(), 'Manual Exception!');
            System.Assert(e.getMessage().contains('Manual Exception'));
        } 
        
        // convert will throw an exception
        try {
            PTAController = new ProductsToAssets(true);
            PTAController.setThrowException(true);
            PTAController.convert(); 
        } catch (Exception e){
            //System.assertEquals(e.getMessage(), 'Manual Exception!');
            System.Assert(e.getMessage().contains('Manual Exception'));
        } 
        
        // toggleView will throw an exception
        try {
            PTAController = new ProductsToAssets(true);
            PTAController.setThrowException(true);
            PTAController.toggleView(); 
        } catch (Exception e){
            //System.assertEquals(e.getMessage(), 'Manual Exception!');
            System.Assert(e.getMessage().contains('Manual Exception'));
        } 
        
        Test.stopTest();
        
    }
}