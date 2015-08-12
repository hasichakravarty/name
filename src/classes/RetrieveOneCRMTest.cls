/*******************************************************************************************************************
* Apex Class Name  : RetrieveOneCRMTestTest 
* Version          : 1.0 
* Created Date     : 30 April 2015
* Function         : Test Class of the RetrieveOneCRMTest
* Modification Log :
*
* Developer                   Date                    Description
* ------------------------------------------------------------------------------------------------------------------
*                         24/04/2015              Created Initial Version of AccountContactSyncTestClass
*******************************************************************************************************************/
@isTest (seeAllData=true)
public with sharing class RetrieveOneCRMTest 
{
  /*************************************************************************************************************
  * Name        : verifyRetrieveOrderById
  * Description : Verify the RetrieveOrderById method   
  * Input       : 
  * Output      : 
  *************************************************************************************************************/
  static testMethod void verifyRetrieveOrderById()
  {     
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
    insert opp;
    
    Product2 prod = (Product2)TestClassAutomation.createSObject('Product2');
    prod.Qualification_Level_Name__c = 6;
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

    OpportunityLineItem oli2 = new OpportunityLineItem();
    oli2.OpportunityId = opp.Id;
    oli2.PricebookEntryId = sPriceBookEntry.Id;
    oli2.TotalPrice = 200;
    oli2.Quantity = 1;
    oli2.OptionId__c = prod.Id;
            
    insert oli2;    

    Apttus_Proposal__Proposal__c prop = new  Apttus_Proposal__Proposal__c();
    prop.Apttus_Proposal__Proposal_Name__c = opp.name;
    prop.Degree_Type__c = 'Full-Time';
    prop.Payment_Method__c = 'Cash';
    prop.Payment_Type__c = 'Monthly Payment';
    prop.Deposit__c = 111;
    prop.Payment_Period_In_Month__c = '10';
    prop.First_Payment_Date__c = system.today();
    prop.Total_Early_Bird_Securing_Fee_Payments__c = 234456;
    prop.Campus__c = 'bredford';
    prop.Qualification_Campus__c = acc.id;      
    prop.Apttus_Proposal__Opportunity__c = opp.id;      
    prop.Apttus_Proposal__Account__c = acc.id;      
    prop.Apttus_Proposal__Approval_Stage__c = 'Draft';
    prop.Apttus_Proposal__Primary__c = true;
    prop.Early_Bird__c = true;
    prop.recordtypeid =Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Quote').getRecordTypeId();
    insert prop;
      
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
    
    test.startTest();
    RetrieveOneCRM.RetrieveOrderResult result = RetrieveOneCRM.RetrieveOrderById(opp.id);  
    System.assertNotEquals(result, null, 'Returned Result is null');    
    test.stopTest();
  } 
  
  /*************************************************************************************************************
  * Name        : verifyRetrieveOrderById2
  * Description : Verify the RetrieveOrderById method - needed to get around DML limits  
  * Input       : 
  * Output      : 
  *************************************************************************************************************/
  static testMethod void verifyRetrieveOrderById2()
  {     
    Account acc = (Account)TestClassAutomation.createSObject('Account');
    acc.Name = 'Test';
    acc.External_Account_Number__c = 'External';
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

    OpportunityLineItem oli2 = new OpportunityLineItem();
    oli2.OpportunityId = opp.Id;
    oli2.PricebookEntryId = sPriceBookEntry.Id;
    oli2.TotalPrice = 200;
    oli2.Quantity = 1;
    oli2.OptionId__c = prod.Id;
            
    insert oli2;    

    Apttus_Proposal__Proposal__c prop = new  Apttus_Proposal__Proposal__c();
    prop.Apttus_Proposal__Proposal_Name__c = opp.name;
    prop.Degree_Type__c = 'Full-Time';
    prop.Payment_Method__c = 'Cash';
    prop.Payment_Type__c = 'Monthly Payment';
    prop.Deposit__c = 111;
    prop.Payment_Period_In_Month__c = '10';
    prop.First_Payment_Date__c = system.today();
    prop.Total_Early_Bird_Securing_Fee_Payments__c = 234456;
    prop.Campus__c = 'bredford';
    prop.Qualification_Campus__c = acc.id;      
    prop.Apttus_Proposal__Opportunity__c = opp.id;      
    prop.Apttus_Proposal__Account__c = acc.id;      
    prop.Apttus_Proposal__Approval_Stage__c = 'Draft';
    prop.Apttus_Proposal__Primary__c = true;
    prop.Early_Bird__c = true;
    prop.recordtypeid =Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Quote').getRecordTypeId();
    insert prop;
      
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
    
    test.startTest();
    RetrieveOneCRM.RetrieveOrderResult result = RetrieveOneCRM.RetrieveOrderById(opp.id); 
    System.assertNotEquals(result, null, 'Returned Result is null');    
    test.stopTest();
  } 
  
  /*************************************************************************************************************
  * Name        : verifyRetrieveOrderById3
  * Description : Verify the RetrieveOrderById method - needed to get around DML limits  
  * Input       : 
  * Output      : 
  *************************************************************************************************************/
  static testMethod void verifyRetrieveOrderById3()
  {   
  	RetrieveOneCRM.RetrieveOrderResult result = null;
   
  	try
  	{
  	  result = RetrieveOneCRM.RetrieveOrderById('');	
  	}
  	catch(Exception e)
  	{
  	  System.assertEquals(result, null, 'Returned Result is not null');    	
  	}
  	
  	try
  	{
  	  result = RetrieveOneCRM.RetrieveOrderById('006b00000077Fw3AAG');	
  	}
  	catch(Exception e)
  	{
  	  System.assertEquals(result, null, 'Returned Result is not null');    	
  	}
  	
  	try
  	{
  	  RetrieveOneCRMHandler.RetrieveOrderInfoByIds(null, null);
  	}
  	catch(Exception e)
  	{
  	  System.assertEquals(result, null, 'Returned Result is not null');    	
  	}
  	
  	try
  	{
  	  RetrieveOneCRMHandler.RetrieveOrderInfoByIds('801110000077fHZAA0', null);
  	}
  	catch(Exception e)
  	{
  	  System.assertEquals(result, null, 'Returned Result is not null');    	
  	}
  }
  
  /*************************************************************************************************************
  * Name        : verifyRetrieveOrderByOrderLineItemId
  * Description : Verify the RetrieveOrderByOrderLineItemId method   
  * Input       : 
  * Output      : 
  *************************************************************************************************************/
  static testMethod void verifyRetrieveOrderByOrderLineItemId()
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
     
    order sampleorder = new order();
    sampleorder.OpportunityId=opp.Id;
    sampleorder.Accountid = acc.Id;
    sampleorder.EffectiveDate = system.today();
    sampleorder.status = 'Open';
    sampleorder.Pricebook2Id = priceBook.id;
    sampleorder.CurrencyIsoCode = 'GBP';
    sampleorder.Packing_Instructions__c = 'Packing Instructions';
    sampleorder.Shipping_Instructions__c = 'Shipping instructions';
    insert sampleorder;
    
    Orderitem oi = new OrderItem();
    oi.orderid=sampleorder.id;
    oi.Shipped_Product__c = prod.id;
    oi.Quantity = 6;
    oi.pricebookentryid= sPriceBookEntry.id;
    oi.unitprice =1.00;
    insert oi;    
   
    test.startTest();
    RetrieveOneCRM.RetrieveOrderResult result = RetrieveOneCRM.RetrieveOrderByOrderLineItemId(oi.Id);
    System.assertNotEquals(result, null, 'Returned Result is null');
    try
    {
      result = RetrieveOneCRM.RetrieveOrderByOrderLineItemId('');
    }
    catch(Exception e)
    {
      System.assertNotEquals(result, null, 'Returned Result is null');
    }
    RetrieveOneCRM.RetrieveOrderById(sampleOrder.id);
    
    test.stopTest();
    }
  } 
   
  /*************************************************************************************************************
  * Name        : verifyRetrieveOrderByOrderLineItemId
  * Description : Verify the RetrieveOrderByOrderLineItemId method   
  * Input       : 
  * Output      : 
  *************************************************************************************************************/
  static testMethod void verifyRetrieveOrderByOrderLineItemId2()
  { 
  	test.startTest();
  	RetrieveOneCRM.RetrieveOrderResult result = null;
    try
    {
      result = RetrieveOneCRM.RetrieveOrderByOrderLineItemId('80211000000r66gkAAA');
    }
    catch(Exception e)
    {
      System.assertEquals(result, null, 'Returned Result is not null');
    }
    test.stopTest();
  }
  
 /*************************************************************************************************************
  * Name        : verifyRetrieveAccountByCaseId
  * Description : Verify the RetrieveAccountByCaseId   
  * Input       : 
  * Output      : 
  *************************************************************************************************************/
  static testMethod void verifyRetrieveAccountByCaseId()
  {     
    List<Case> generatedCases = generateTestCases(1, false);    
    test.startTest();
    //RetrieveOneCRM.RetrieveAccountByCaseId('');
    RetrieveOneCRM.RetrieveAccountResult result = RetrieveOneCRM.RetrieveAccountByCaseId(generatedCases.get(0).Id);
    System.assertNotEquals(result, null, 'Returned Result is null');
    try
    {
      result = RetrieveOneCRM.RetrieveAccountByCaseId('');	
    }
    catch(Exception e)
    {
      System.assertNotEquals(result, null, 'Returned Result is null');	
    }
    test.stopTest();
  }  
  
  /*************************************************************************************************************
  * Name        : verifyRetrieveAccountByCaseId2 
  * Description : Verify the RetrieveAccountByCaseId - needed to get around DML limits 
  * Input       : 
  * Output      : 
  *************************************************************************************************************/
  static testMethod void verifyRetrieveAccountByCaseId2()
  {     
    List<Case> generatedCases = generateTestCases(1, true);    
    test.startTest();
    //RetrieveOneCRM.RetrieveAccountByCaseId('');
    RetrieveOneCRM.RetrieveAccountResult result = RetrieveOneCRM.RetrieveAccountByCaseId(generatedCases.get(0).Id);
    System.assertNotEquals(result, null, 'Returned Result is null');
    test.stopTest();
  }  
  
  /*************************************************************************************************************
  * Name        : verifyRetrieveCaseById
  * Description : Verify the RetrieveCaseById need methods verifyRetrieveCaseById1 and verifyRetrieveCaseById2
  *               to get around max DML statements govenor limits
  * Input       : 
  * Output      : 
  *************************************************************************************************************/
  static testMethod void verifyRetrieveCaseById1()
  {     
    List<Case> generatedCases = generateTestCases(1, false);   
    test.startTest();
    RetrieveOneCRM.RetrieveCaseResult result = RetrieveOneCRM.RetrieveCaseById(generatedCases.get(0).Id);
    System.assertNotEquals(result, null, 'Returned Result is null');
    test.stopTest();
  }  
  
  /*************************************************************************************************************
  * Name        : verifyRetrieveCaseById
  * Description : Verify the RetrieveCaseById
  * Input       : 
  * Output      : 
  *************************************************************************************************************/
  static testMethod void verifyRetrieveCaseById2()
  {     
    List<Case> generatedCases = generateTestCases(1, true);    
    test.startTest();
    Case c = generatedCases.get(0);
    c.Reason_if_Other__c = null;
    c.Reason = 'Reason';
    update c;
    RetrieveOneCRM.RetrieveCaseResult result = RetrieveOneCRM.RetrieveCaseById(c.Id);
    System.assertNotEquals(result, null, 'Returned Result is null');
    test.stopTest();
  } 
  
  /*************************************************************************************************************
  * Name        : verifyHandleRetrieveAccountByCaseId
  * Description : Verify the handleRetrieveAccountByCaseId   
  * Input       : 
  * Output      : 
  *************************************************************************************************************/
  static testMethod void verifyhandleRetrieveAccountByCaseId()
  {     
    test.startTest();
    RetrieveOneCRM.RetrieveAccountResult result = null;
    try
    {
      result = RetrieveOneCRMHandler.handleRetrieveAccountByCaseId('500110000077qdiAAC');	
    }
    catch(Exception e)
    {
      System.assertEquals(result, null, 'Returned Result is null');	
    }
    test.stopTest();
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
  
  /*************************************************************************************************************
  * Name        : verifyExceptions
  * Description : Verify the Exceptions that are thrown
  * Input       : 
  * Output      : 
  *************************************************************************************************************/
  static testMethod void verifyExceptions()
  { 
    test.startTest();   
    RetrieveOneCRM.RetrieveCaseResult result = null;
    try
    {
      result = RetrieveOneCRM.RetrieveCaseById('');
    }
    catch(RetrieveOneCRM.RetreiveOneCRMException exc)
    {
      System.assertEquals(result, null, 'Returned Result is not null');
    }
    
    try
    {
      result = RetrieveOneCRM.RetrieveCaseById('500110000077EWKAA2');
    }
    catch(RetrieveOneCRM.RetreiveOneCRMException exc)
    {
      System.assertEquals(result, null, 'Returned Result is not null');
    }
    
    test.stopTest();    
  }
}