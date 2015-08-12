@isTest (seeAllData=true)
public with sharing class PS_INT_IntegrationRequestControllerTest 
{    
  /*************************************************************************************************************
  * Name        : verifySubmisionValidation
  * Description : Verify the submissionValidation method   
  * Input       :  
  * Output      :  
  *************************************************************************************************************/
  static testMethod void verifySubmisionValidation()
  {  
   
    List<User> usrLst = TestDataFactory.createUser(Userinfo.getProfileId());
    insert usrLst;
    System.runas(usrLst[0]){
    Account acc = (Account)TestClassAutomation.createSObject('Account');
    acc.Name = 'Test';
    insert acc; 
    
    Account_Correlation__C ac = new Account_Correlation__C(Account__C = acc.Id, External_ID_Name__c = 'eVision Learner Number', External_ID__c = 'External ID');
    insert ac; 
     
    contact con = (Contact)TestClassAutomation.createSObject('Contact');
    con.Lastname= 'testcon';
    con.Firstname= 'testcon1';
    con.MobilePhone = '9999';     
    insert con;     
    
    Opportunity opp = (Opportunity)TestClassAutomation.createSObject('Opportunity');
    opp.AccountId = acc.Id;
    opp.CurrencyIsoCode = 'GBP';
    opp.Lost_Reason_Other__c = 'XXX';
    opp.Academic_Vetting_Status__c = 'XXXXX';
    opp.Type = 'New Business';
    opp.StageName = 'Negotiation';
    insert opp;
    
    Opportunity oldopp = (Opportunity)TestClassAutomation.createSObject('Opportunity');
    oldopp.AccountId = acc.Id;
    oldopp.CurrencyIsoCode = 'GBP';
    oldopp.Lost_Reason_Other__c = 'XXX';
    oldopp.Academic_Vetting_Status__c = 'XXXXX';
    oldopp.Type = 'New Business';
    oldopp.StageName = 'Negotiation';
    insert oldopp;
    
    list<OpportunityContactRole>ocrlist = new list<OpportunityContactRole>();
    OpportunityContactRole ocr = new OpportunityContactRole();
    ocr.ContactId = con.id;
    ocr.Role = 'Business User';
    ocr.IsPrimary = True;
    ocr.OpportunityId = opp.id;     
    ocrlist.add(ocr);
     
    OpportunityContactRole ocr1 = new OpportunityContactRole();
    ocr1.ContactId = con.id;
    ocr1.Role = 'Primary Sales Contact';
    ocr1.IsPrimary = True;
    ocr1.OpportunityId = opp.id;
    ocrlist.add(ocr1);
    insert ocrlist;    
    List <Opportunity> opps = new List<Opportunity>();
    Map<Id, Opportunity> oldOpps = new Map<Id, Opportunity>();
    opps.add(opp);
    oldopps.put(opp.id, oldopp);
    
    test.startTest();
    
    PS_INT_IntegrationRequestController.submissionValidation(opps, oldOpps);
    
    con.Passport_Number__c = '12345';
    con.National_Identity_Number__c = '123456';
    update con;
    ocr.ContactId = con.id;
    update ocr;
    PS_INT_IntegrationRequestController.submissionValidation(opps, oldOpps);
  
    opp.Type = 'New Business';
    opp.StageName = 'Closed';
    update opp;
  
    con.MobilePhone = null;
    con.Phone = '9999';
    update con;
    PS_INT_IntegrationRequestController.submissionValidation(opps, oldOpps);
    
    opp.Type = 'Amendment';
    opp.StageName = 'Closed';
    update opp;
    
    con.Phone = null;
    con.Home_Phone__c = '9999';
    update con;
    PS_INT_IntegrationRequestController.submissionValidation(opps, oldOpps);
    
    //con.Home_Phone__C = null;
    //update con;
    //PS_INT_IntegrationRequestController.submissionValidation(opps, oldOpps);
    
    //Map<id, SObject> oldopps = new Map<id, SObject>();
    
    opp.StageName = 'Closed';
    update opp;
    PS_INT_IntegrationRequestController.createIntegrationRequestOpp(opps, oldopps);
    
    opp.Type = 'Amendment';
    update opp;    
    PS_INT_IntegrationRequestController.createIntegrationRequestOpp(opps, oldopps);
    
    opp.Type = 'New Business';
    opp.Academic_Vetting_Status__c = 'Vetted - Approved';
    opp.StageName = 'Lost';
    opp.Lost_Reason__c = 'Other';
    update opp;
    PS_INT_IntegrationRequestController.createIntegrationRequestOpp(opps, oldopps);
    
    opp.StageName = 'Invoiced';
    update opp;
    PS_INT_IntegrationRequestController.createIntegrationRequestOpp(opps, oldopps);
    
    test.stopTest();
    }
  }
  
  /*************************************************************************************************************
  * Name        : verifySubmisionValidationForCases
  * Description : Verify the submissionValidationForCases method   
  * Input       : 
  * Output      : 
  *************************************************************************************************************/
  static testMethod void verifySubmisionValidationForCases()
  {  
    List<User> usrLst = TestDataFactory.createUser(Userinfo.getProfileId());
    insert usrLst;
     List <Case> cases = new List<Case>();
     List<Case> generatedCases  = new List<Case>();

    system.runas(usrLst[0]){
    generatedCases = generateTestCases(1, false);    
    cases.add(generatedCases.get(0));
    }
    
    test.startTest();
    
    PS_INT_IntegrationRequestController.submissionValidation(cases);
    
    /* This code cannot be executed as it causes a filter criteria exception on contactid 
    RecordType rt = [SELECT Id, Name FROM RecordType WHERE SobjectType='Case' and DeveloperName = 'Cancellation_Request']; 
    generatedCases.get(0).RecordTypeid = rt.id  = rt.Id;
    generatedCases.get(0).Status = 'Closed';
    update generatedCases.get(0);              
    PS_INT_IntegrationRequestController.createIntegrationRequestCase(cases);*/
    
    RecordType rt = [SELECT Id, Name FROM RecordType WHERE SobjectType='Case' and DeveloperName = 'Change_Request']; 
    generatedCases.get(0).RecordTypeid = rt.id  = rt.Id;
    generatedCases.get(0).Type = 'Change Sponsor';
    generatedCases.get(0).Status = 'Closed';
    update generatedCases.get(0);              
    PS_INT_IntegrationRequestController.createIntegrationRequestCase(cases);
    
    generatedCases.get(0).Type = 'Change Campus';
    generatedCases.get(0).Current_Campus__c = 'Bedfordview';
    generatedCases.get(0).Proposed_Campus__c = 'Durban';
    update generatedCases.get(0);              
    PS_INT_IntegrationRequestController.createIntegrationRequestCase(cases);
    
    test.stopTest();
  }
  
  /*************************************************************************************************************
  * Name        : verifyCreateIntegrationRequestOrder
  * Description : Verify the createIntegrationRequestOrder method   
  * Input       : 
  * Output      : 
  *************************************************************************************************************/
  static testMethod void verifyCreateIntegrationRequestOrder()
  {  
    List<User> usrLst = TestDataFactory.createUser(Userinfo.getProfileId());
    insert usrLst;
    
    List <PermissionSet> permList = [SELECT Id FROM PermissionSet WHERE name = 'Pearson_Backend_Order_Creation'];  
    PermissionSetAssignment psa = new PermissionSetAssignment();
    psa.AssigneeId = usrLst[1].Id;
    psa.PermissionSetId = permList[0].Id;
    insert psa;
    
    System.runas(usrLst[1])
    {
    Account acc = (Account)TestClassAutomation.createSObject('Account');
    acc.Name = 'Test';
    insert acc;
     
    contact con = (Contact)TestClassAutomation.createSObject('Contact');
    con.Lastname= 'testcon';
    con.Firstname= 'testcon1';
    con.MobilePhone = '9999';     
    insert con;     
    
    Opportunity opp = (Opportunity)TestClassAutomation.createSObject('Opportunity');
    opp.AccountId = acc.Id;
    opp.CurrencyIsoCode = 'GBP';
    opp.Lost_Reason_Other__c = 'XXX';
    insert opp;
    
    Product2 prod = (Product2)TestClassAutomation.createSObject('Product2');
    insert prod;

    Pricebook2 priceBook = [select id, name, isActive from Pricebook2 where IsStandard = true limit 1];
    priceBook.IsActive = true;
    update priceBook;
        
    PriceBookEntry sPriceBookEntry = (PriceBookEntry)TestClassAutomation.createSObject('PriceBookEntry');
    sPriceBookEntry.IsActive = true;
    sPriceBookEntry.Product2Id = prod.Id;
    sPriceBookEntry.Pricebook2Id = priceBook.Id;
    sPriceBookEntry.UnitPrice = 34.95;
    sPriceBookEntry.CurrencyIsoCode = 'GBP';
    insert sPriceBookEntry;
    
    OpportunityLineItem oli1 = new OpportunityLineItem();
    oli1.OpportunityId = opp.Id;
    oli1.PricebookEntryId = sPriceBookEntry.Id;
    oli1.TotalPrice = 200;
    oli1.Quantity = 1;
            
    insert oli1;
     
    order ord = new order();
    ord.OpportunityId=opp.Id;
    ord.Accountid = acc.Id;
    ord.EffectiveDate = system.today();
    ord.status = 'Open';
    ord.Pricebook2Id = priceBook.id;
    ord.CurrencyIsoCode = 'GBP';
    ord.Packing_Instructions__c = 'Packing Instructions';
    ord.Shipping_Instructions__c = 'Shipping instructions';
    insert ord;

    Orderitem oi = new OrderItem();
    oi.orderid=ord.id;
    oi.Shipped_Product__c = prod.id;
    oi.Quantity = 6;
    oi.pricebookentryid= sPriceBookEntry.id;
    oi.unitprice = 1.00;
    insert oi;  
    
    Orderitem oldoi = new OrderItem();
    oldoi.orderid=ord.id;
    oldoi.Shipped_Product__c = prod.id;
    oldoi.Quantity = 6;
    oldoi.pricebookentryid= sPriceBookEntry.id;
    oldoi.unitprice = 1.00;
    oldoi.Status__c = 'New';
    insert oldoi;    
    
    test.startTest();
    
    List<Order> orders = new List<Order>();
    orders.add(ord);
    Map<Id, SObject> oldorders = new Map<Id, SObject>();
    oldorders.put(ord.Id, ord); 
    PS_INT_IntegrationRequestController.createIntegrationRequestOrder(orders, oldorders);
    
    oi.Status__c = 'Cancelled';
    update oi;
    List<OrderItem> orditems = new List<OrderItem>();
    orditems.add(oi);
    Map<Id, SObject> oldorderitems = new Map<Id, SObject>();
    oldorderitems.put(oi.id, oldoi);
    PS_INT_IntegrationRequestController.createIntegrationRequestOrderLine(orditems, oldorderitems);
    
    oi.Status__c = 'Approved';
    update oi;   
    PS_INT_IntegrationRequestController.createIntegrationRequestOrderLine(orditems, oldorderitems);
    
    test.stopTest();
    }
  }

  /*************************************************************************************************************
  * Name        : generateTestCases
  * Description : Generate Cases records
  * Input       : NumOfCases - Number of case records to generate
  * Output      : List of the Case records generated
  *************************************************************************************************************/
  private static List<Case> generateTestCases(Integer numOfCases, Boolean setExternalId)
  {
    List<Case> casesToInsert = new List<Case>();
    
    //Generate an account
    Account acc = new Account(Name = 'Account 1');
    if(setExternalId)
    {
      acc.External_Account_Number__c = 'External';  
    }
    insert acc;
        
    //Generate contact
    Contact con = new Contact(LastName = 'Contact 1', FirstName = 'fn', Email = 'test@test.com.demo', AccountId = acc.Id);
    insert con;
    
    AccountContact__c accCon = new  AccountContact__c(Account__c = acc.Id, Contact__c = con.Id, AccountRole__c = 'Role', Primary__c = true, Financially_Responsible__c = True);
    insert accCon;
    
    Account_Correlation__C ac = new Account_Correlation__C(Account__C = acc.Id, External_ID_Name__c = 'eVision Learner Number', External_ID__c = 'External ID');
    insert ac;
     
    RecordType rt = [SELECT Id,Name FROM RecordType WHERE SobjectType='Case' and DeveloperName = 'Loan_Bursary_Request'];                        
    for(Integer i=0; i<numOfCases; i++)
    {    
      Case caseToInsert = new Case( AccountId = acc.Id, RecordTypeid = rt.id, Type ='General', ContactId = con.Id, Sponsor_name__c = con.Id, Reason_if_Other__c = 'Other');          
      casesToInsert.add(caseToInsert);
    }
        
    if(casesToInsert.size()>0)
    {
      insert casesToInsert;
    }
     
    return casesToInsert;
  }
  
   static testMethod void ChatterComponentTest()
  {  
        Test.startTest();
        List<User> usrLst = TestDataFactory.createUser(Userinfo.getProfileId());
        insert usrLst;
         System.runas(usrLst[0]){
         Account acc = (Account)TestClassAutomation.createSObject('Account');
         acc.Name = 'Test';
         insert acc; 
        
        Test.setCurrentPageReference(new PageReference('ChatterComponent'));
        System.currentPageReference().getParameters().put('id', acc.id);
        ChatterComponent chatCompObj = new ChatterComponent();
        chatCompObj.getRecordId();
         }
        Test.stopTest();
  }
}