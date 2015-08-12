@isTest
private class OppProductToAssetTest {

    static testMethod void testSearchTermCleansing() {
    test.StartTest();
        User us = [select Market__c,Line_of_Business__c,Business_Unit__c from User where id =:UserInfo.getUserId() limit 1];
        system.RunAs(us){
        
        
        TestClassAutomation.FillAllFields = true;
    
    Account sAccount        = (Account)TestClassAutomation.createSObject('Account');
    sAccount.BillingCountry      = 'Australia';
    sAccount.BillingState      = 'Victoria';
    sAccount.BillingCountryCode    = 'AU';
    sAccount.BillingStateCode    = 'VIC';
    sAccount.ShippingCountry    = 'Australia';
    sAccount.ShippingState      = 'Victoria';
    sAccount.ShippingCountryCode  = 'AU';
    sAccount.ShippingStateCode    = 'VIC';
    
    insert sAccount;
    
    Product2 sProduct            = (Product2)TestClassAutomation.createSObject('Product2');
    sProduct.Market__c = us.Market__c;
    sProduct.Line_of_Business__c= us.Line_of_Business__c;
    sProduct.Business_Unit__c = us.Business_Unit__c ;
    insert sProduct;
     system.debug('product details---'+sProduct);
     
    PriceBookEntry newPriceBookEntry = new PriceBookEntry();
    newPriceBookEntry.Pricebook2Id = Test.getStandardPricebookId();//listWithPriceBook[0].Id;
    newPriceBookEntry.UnitPrice = 10.0;
    newPriceBookEntry.Product2Id = sProduct.Id;
    newPriceBookEntry.CurrencyIsoCode= 'GBP';
    newPriceBookEntry.IsActive = true;
    insert newPriceBookEntry;

    
    Opportunity sOpportunity        = (Opportunity)TestClassAutomation.createSObject('Opportunity');
    sOpportunity.AccountId          = sAccount.Id;
    sOpportunity.StageName          = 'Closed';
    sOpportunity.RecordTypeId       = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Opportunity').getRecordTypeId();
   // sOpportunity.Pricebook2Id       = Test.getStandardPricebookId();
    sOpportunity.CurrencyIsoCode= 'GBP';
    insert sOpportunity;
    
    UniversityCourse__c course = new UniversityCourse__c(Name= 'TestCourse',Account__c = sAccount.Id, Catalog_Code__c = 'C01',Course_Name__c = 'TestCourse');
    insert course;
    
    OpportunityUniversityCourse__c ouc = new OpportunityUniversityCourse__c(Opportunity__c = sOpportunity.Id, UniversityCourse__c = course.Id,Account__c = sAccount.Id,Opportunity_Name__c = sOpportunity.Id, Close_Date__c = system.Today(),Opportunity_University_Course_Amount__c = 100);
    insert ouc;
    
     List<Contact> contactList=TestDataFactory.createContact(1);
    contactList[0].AccountId = sAccount.id;
    insert contactList;
    
    system.debug('---------MArket------------'+us.Market__c+'---Business Unit---'+us.Business_Unit__c +'---Lie of business---'+us.Line_of_Business__c);
        
         
    //Test.startTest();
    
      OpportunityLineItem sOLI      = new OpportunityLineItem();
      sOLI.OpportunityId          = sOpportunity.Id;
      sOLI.PricebookEntryId        = newPriceBookEntry.Id;
      //sOLI.TotalPrice            = 200;
      sOLI.UnitPrice = 10.0;      
      sOLI.Quantity            = 1;
      
      system.debug('sOLI:::' + sOLI);
      insert sOLI;
        
        try{
            OppProductToAsset.setOLIS();          
        }catch(Exception e){}  
        
        try{
            OppProductToAsset.setAssetList();
        }catch(Exception e){} 
        try{
            OppProductToAsset.convert();
        }catch(Exception e){} 
        try{
            OppProductToAsset.setOUCS();       
        }catch(Exception e){} 
        OppProductToAsset.convertToAsset(sOpportunity.Id,sAccount.Id);
        OppProductToAsset obj = new OppProductToAsset();
        
        
        OpportunityContactRole ocr = new OpportunityContactRole(ContactId = contactList[0].Id, OpportunityId = sOpportunity.Id, IsPrimary = true, Role= 'Desicion Maker');
        insert ocr;
        OppProductToAsset.setAssetList();
        delete sOLI;
        List<OpportunityLineItem> li = obj.getOlis();
        OppProductToAsset.setOLIS();
        }test.StopTest();
    }
}