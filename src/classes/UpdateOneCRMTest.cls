/*******************************************************************************************************************
* Apex Class Name  : UpdateOneCRMTestTest
* Version          : 1.0 
* Created Date     : 5 May 2015
* Function         : Test Class of the UpdateOneCRMTest class 
* Modification Log :
*
* Developer                   Date                    Description
* ------------------------------------------------------------------------------------------------------------------
*                             05/05/2015              Created Initial Version of AccountContactSyncTestClass
*******************************************************************************************************************/
@isTest (seeAllData=true)
public with sharing class UpdateOneCRMTest 
{
  /*************************************************************************************************************
  * Name        : verifyReportTransaction1 
  * Description : Verify the reportTransaction method   
  * Input       : 
  * Output      : 
  *************************************************************************************************************/
  static testMethod void verifyReportTransaction1()
  {
    Boolean result = false;
    List<Account> generatedAccounts = generateTestAccounts(1);
    List<Integration_Request__c> generatedIntegrationRequests = generateIntegrationRequests(1, generatedAccounts.get(0).Id );
    UpdateOneCRM.IntegrationTransaction request = new UpdateOneCRM.IntegrationTransaction(); 
    request.integrationRequestId = generatedIntegrationRequests.get(0).id;   
    request.status = System.Label.INT_Status_Received;
    request.externalSystem = 'Sys 1';
    Integration_Framework_Configuration__c ifc = new Integration_Framework_Configuration__c(Name = 'Name', 
                                                                                            Event__c = 'Enrol Student', 
                                                                                            Geo__c = 'Growth', 
                                                                                            Lob__c = 'HE', 
                                                                                            Market__c = 'ZA', 
                                                                                            Sub_Event__c = 'Sub Event', 
                                                                                            System_1__c = 'Sys 1', System_2__c = 'Sys 2');
    insert ifc;
    
    test.startTest();
    
    result = UpdateOneCRM.reportTransaction(request);
    System.assertEquals(true, result, 'Returned result is not true');
    request.status = 'New';
    result = UpdateOneCRM.reportTransaction(request);
    System.assertEquals(true, result, 'Returned result is not true');
   
    try
    {
      request.integrationRequestId = generatedAccounts.get(0).Id;
      result = false;
      result = UpdateOneCRM.reportTransaction(request);
    }
    catch(UpdateOneCRM.UpdateOneCRMException e)
    {
      System.assertEquals(false, result, 'Returned result is not false');
    }
   
    try
    {
      request.externalSystem = 'XXXXX';
      request.status = 'XXXXX';
      result = false;
      result = UpdateOneCRM.reportTransaction(request);      
    }
    catch(UpdateOneCRM.UpdateOneCRMException e)
    {
      System.assertEquals(false, result, 'Returned result is not false');
    }
    
    test.stopTest();
  }
  
  
  /*************************************************************************************************************
  * Name        : verifyReportTransaction
  * Description : Verify the reportTransaction method   
  * Input       : 
  * Output      : 
  *************************************************************************************************************/
  static testMethod void verifyReportTransaction2()
  {
    Boolean result = false;
    List<Account> generatedAccounts = generateTestAccounts(1);
    List<Integration_Request__c> generatedIntegrationRequests = generateIntegrationRequests(1, generatedAccounts.get(0).Id );
    UpdateOneCRM.IntegrationTransaction request = new UpdateOneCRM.IntegrationTransaction(); 
    request.integrationRequestId = generatedIntegrationRequests.get(0).id;   
    request.status = System.Label.INT_Status_Received;
    request.externalSystem = 'Sys 1';
    Integration_Framework_Configuration__c ifc = new Integration_Framework_Configuration__c(Name = 'Name', 
                                                                                            Event__c = 'Enrol Student', 
                                                                                            Geo__c = 'Growth', 
                                                                                            Lob__c = 'HE', 
                                                                                            Market__c = 'ZA', 
                                                                                            Sub_Event__c = 'Sub Event', 
                                                                                            System_1__c = 'Sys 1', System_2__c = 'Sys 2');
    insert ifc;
    System_Response__c sr = new System_Response__c(Integration_Request__c = generatedIntegrationRequests.get(0).id,
                                                   External_System__c = request.externalSystem);
    insert sr;
    
    Integration_Request__c ir = [SELECT id, (SELECT Id from System_Responses__r) from Integration_Request__c WHERE Id = :generatedIntegrationRequests.get(0).Id];
    update generatedIntegrationRequests.get(0);
    request.integrationRequestId = ir.Id;
    test.startTest();
    
    result = UpdateOneCRM.reportTransaction(request);
    System.assertEquals(true, result, 'Returned result is not true');
    
    test.stopTest();
  } 
  
  
  /*************************************************************************************************************
  * Name        : verifyupdateExternalReference
  * Description : Verify the updateExternalReference method   
  * Input       : 
  * Output      : 
  *************************************************************************************************************/
  static testMethod void verifyUpdateExternalReference()
  {
  	Boolean result = false;
    List<Account> generatedAccounts = generateTestAccounts(1);
    Opportunity opp = (Opportunity)TestClassAutomation.createSObject('Opportunity');
    opp.AccountId = generatedAccounts.get(0).Id;
    opp.CurrencyIsoCode = 'GBP';
    opp.Lost_Reason_Other__c = 'XXX';
    insert opp;
    List<Integration_Request__c> generatedIntegrationRequests = generateIntegrationRequests(1, opp.Id );
   
    UpdateOneCRM.UpdateRequest request = new UpdateOneCRM.UpdateRequest(); 
    request.integrationRequestId = generatedIntegrationRequests.get(0).id;   
    request.externalKeyValue = '999999999';
    request.externalKeyName = System.Label.Learner_ID;
    request.externalSystem = System.Label.EVision;
    
    test.startTest();
    
    result = UpdateOneCRM.updateExternalReference(request);
    System.assertEquals(true, result, 'Returned result is not true');

    Account_Correlation__C ac = new Account_Correlation__C(Account__C = generatedAccounts.get(0).Id, External_ID_Name__c = 'eVision Learner Number', External_ID__c = 'External ID');
    insert ac; 
    result = UpdateOneCRM.updateExternalReference(request);
    System.assertEquals(true, result, 'Returned result is not true');  
    try
    {
      request.externalSystem = 'XXXXX';
      result = false;
      result = UpdateOneCRM.updateExternalReference(request);
    }
    catch(UpdateOneCRM.UpdateOneCRMException e)
    {
      System.assertEquals(false, result, 'Returned result is not false');
    }
    try
    {
      request.externalKeyName = 'XXXXX';
      request.externalSystem = System.Label.EVision;
      result = false;
      result = UpdateOneCRM.updateExternalReference(request);
    }
    catch(UpdateOneCRM.UpdateOneCRMException e)
    {
      System.assertEquals(false, result, 'Returned result is not false');
    }
    
    request.externalKeyName = System.Label.Application_ID;
    result = UpdateOneCRM.updateExternalReference(request); 
    System.assertEquals(true, result, 'Returned result is not true');
    
    
    request.integrationRequestId = 'a3bg00000008UPHAA4';
    result = UpdateOneCRM.updateExternalReference(request); 
    System.assertEquals(false, result, 'Returned result is not false');
    
    generatedIntegrationRequests.get(0).Object_Id__c = '006b0000007YFwEAAW';
    update generatedIntegrationRequests.get(0);
    request.integrationRequestId = generatedIntegrationRequests.get(0).id; 
    result = UpdateOneCRM.updateExternalReference(request); 
    System.assertEquals(false, result, 'Returned result is not false');
    
    test.stopTest();
  }
  
  /*************************************************************************************************************
  * Name        : verifyUpdateOrderLineItem1
  * Description : Verify the updateOrderLineItem method   
  * Input       : 
  * Output      : 
  *************************************************************************************************************/
  static testMethod void verifyUpdateOrderLineItem1()
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
    UpdateOneCRM.OrderLineItem oli = new UpdateOneCRM.OrderLineItem();
    oli.id = '0011100000hXHFgAAO';
    oli.orderId = '0011100000hXHFgAAO';
    oli.itemNumber = '12345';
    oli.orderNumber = '12345';
    oli.status = 'New Status';
    oli.statusReason = 'New Status Reason';
    oli.externalOrderNumber = '123456';
    oli.quantity = 7;
    
    UpdateOneCRM.OrderLineItem oli2 = new UpdateOneCRM.OrderLineItem();
    oli2.orderId = '0011100000hXHFgAAO';
    oli2.itemNumber = '12345';
    oli2.orderNumber = '12345';
    oli2.status = 'New Status';
    oli2.statusReason = 'New Status Reason';
    oli2.quantity = 7;
    
    UpdateOneCRM.OrderLineItem oli3 = new UpdateOneCRM.OrderLineItem();
    oli3.orderId = '0011100000hXHFgAAO';
    oli3.itemNumber = '12345';
    oli3.orderNumber = '12345';
    oli3.status = 'New Status';
    oli3.statusReason = 'New Status Reason';
    oli3.quantity = 7;
    
    
    Account acc = (Account)TestClassAutomation.createSObject('Account');
    acc.Name = 'Test';
    acc.billingStateCode = '';
    acc.ShippingStateCode = '';
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
    prod.ISBN__c = '67890';
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
    Order o2 = [select id, ordernumber from Order where id = :ord.id];
    
    OrderItem oi = new OrderItem();
    oi.orderid=ord.id;
    oi.Shipped_Product__c = prod.id;
    oi.Quantity = 6;
    oi.pricebookentryid= sPriceBookEntry.id;
    oi.unitprice =1.00;
    insert oi;    
	  OrderItem oi2 = [select id, orderitemnumber from OrderItem where id = :oi.id];	
		
    oli.orderNumber = o2.orderNumber;
    oli.id = o2.id;    
    //oli.id = oi2.id;
    oli2.orderNumber = o2.orderNumber;
    oli3.orderNumber = o2.orderNumber;
    oli.itemNumber = oi2.OrderItemNumber;
    oli2.itemNumber = oi2.OrderItemNumber;
    oli3.itemNumber = oi2.OrderItemNumber;
    oli.externalOrderNumber = '999';
    oli2.externalOrderNumber = '999';
    oli3.externalOrderNumber = '999';
    INT_BookProduct shippedBook = new INT_BookProduct();
    shippedBook.isbn10  = '123456';
    shippedBook.isbn13 = '67890';
    oli.shipped = shippedBook;
    oli2.shipped = shippedBook;
    oli3.shipped = shippedBook;
    
    List<UpdateOneCRM.OrderLineItem> orderLineItemList = new List<UpdateOneCRM.OrderLineItem>();
    orderLineItemList.add(oli);
    orderLineItemList.add(oli2);
    orderLineItemList.add(oli3);
    
    test.startTest();
    
    Boolean result = UpdateOneCRM.updateOrderLineItem(orderLineItemList);
    System.assertEquals(false, result, 'The result is not false');
    
    test.stopTest();
    }
  }
  
  /*************************************************************************************************************
  * Name        : verifyUpdateOrderLineItem2
  * Description : Verify the updateOrderLineItem method   
  * Input       : 
  * Output      : 
  *************************************************************************************************************/
  static testMethod void verifyUpdateOrderLineItem2()
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
    INT_BookProduct bp = new INT_BookProduct();
    bp.isbn13 = '12345';
    
    UpdateOneCRM.OrderLineItem oli = new UpdateOneCRM.OrderLineItem();
    oli.id = '0011100000hXHFgAAO';
    oli.orderId = '0011100000hXHFgAAO';
    oli.itemNumber = '12345';
    oli.orderNumber = '12345';
    oli.status = 'New Status';
    oli.statusReason = 'New Status Reason';
    oli.quantity = 7;
    oli.externalOrderNumber = '123456';
    oli.shipped = bp;
    
    UpdateOneCRM.OrderLineItem oli2 = new UpdateOneCRM.OrderLineItem();
    oli2.orderId = '0011100000hXHFgAAO';
    oli2.itemNumber = '12345';
    oli2.orderNumber = '12345';
    oli2.status = 'New Status';
    oli2.statusReason = 'New Status Reason';
    oli2.quantity = 7;
    oli2.externalOrderNumber = '123456';
    oli2.shipped = bp;
    
    UpdateOneCRM.OrderLineItem oli3 = new UpdateOneCRM.OrderLineItem();
    oli3.orderId = '0011100000hXHFgAAO';
    oli3.itemNumber = '12345';
    oli3.orderNumber = '12345';
    oli3.status = 'New Status';
    oli3.statusReason = 'New Status Reason';
    oli3.quantity = 7;
    oli3.externalOrderNumber = '123456';
    oli3.shipped = bp;
    
    Account acc = (Account)TestClassAutomation.createSObject('Account');
    acc.Name = 'Test';
    acc.billingStateCode = '';
    acc.ShippingStateCode = '';
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
    prod.ISBN__c = '12345';
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
    //ord.OpportunityId=opp.Id;
    ord.Accountid = acc.Id;
    ord.EffectiveDate = system.today();
    ord.status = 'Open';
    ord.Pricebook2Id = priceBook.id;
    ord.CurrencyIsoCode = 'GBP';
    ord.Packing_Instructions__c = 'Packing Instructions';
    ord.Shipping_Instructions__c = 'Shipping instructions';
    insert ord;

    Order o2 = [select id, ordernumber from Order where id = :ord.id];
    
    OrderItem oi = new OrderItem();
    oi.orderid=ord.id;
    oi.Shipped_Product__c = prod.id;
    oi.Quantity = 6;
    oi.pricebookentryid= sPriceBookEntry.id;
    oi.unitprice =1.00;
    insert oi;    
	  OrderItem oi2 = [select id, orderitemnumber from OrderItem where id = :oi.id];	
		
    oli.orderNumber = o2.orderNumber;
    //oli.id = o2.id;    
    oli.id = oi2.id;
    oli2.orderNumber = o2.orderNumber;
    oli3.orderNumber = o2.orderNumber;
    oli.itemNumber = oi2.OrderItemNumber;
    oli2.itemNumber = oi2.OrderItemNumber;
    oli3.itemNumber = oi2.OrderItemNumber;
    
    List<UpdateOneCRM.OrderLineItem> orderLineItemList = new List<UpdateOneCRM.OrderLineItem>();
    orderLineItemList.add(oli);
    
    test.startTest();
        
    Boolean result = UpdateOneCRM.updateOrderLineItem(orderLineItemList);
    System.assertEquals(true, result, 'The result is not true');
    
    try
    {
      result = false;
      bp.isbn13 = 'ABC123456';
      result = UpdateOneCRM.updateOrderLineItem(orderLineItemList); 
      bp.isbn13 = '12345';     
    }
    catch(Exception e)
    {
      System.assertEquals(false, result, 'The result is not false');
    }    
    
    oli.id = null;
    oli.itemNumber = '';
    oli.orderNumber = '';
    try
    {
      result = false;
      result = UpdateOneCRM.updateOrderLineItem(orderLineItemList);      
    }
    catch(Exception e)
    {
      System.assertEquals(false, result, 'The result is not false');
    }
    
    
    test.stopTest();
    }
  }  
     
  /*************************************************************************************************************
  * Name        : verifyUpdateOrderLineItem3
  * Description : Verify the updateOrderLineItem method   
  * Input       : 
  * Output      : 
  *************************************************************************************************************/
  static testMethod void verifyUpdateOrderLineItem3()
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
    UpdateOneCRM.OrderLineItem oli = new UpdateOneCRM.OrderLineItem();
    oli.id = '0011100000hXHFgAAO';
    oli.orderId = '0011100000hXHFgAAO';
    oli.itemNumber = '12345';
    oli.orderNumber = '12345';
    oli.status = 'New Status';
    oli.statusReason = 'New Status Reason';
    oli.quantity = 7;
    oli.externalOrderNumber = '123456';
    
    UpdateOneCRM.OrderLineItem oli2 = new UpdateOneCRM.OrderLineItem();
    oli2.orderId = '0011100000hXHFgAAO';
    oli2.status = 'New Status';
    oli2.statusReason = 'New Status Reason';
    oli2.quantity = 7;
    oli2.externalOrderNumber = '123456';
    
    UpdateOneCRM.OrderLineItem oli3 = new UpdateOneCRM.OrderLineItem();
    oli3.orderId = '0011100000hXHFgAAO';
    oli3.itemNumber = '12345';
    oli3.orderNumber = '12345';
    oli3.status = 'New Status';
    oli3.statusReason = 'New Status Reason';
    oli3.quantity = 7;
    oli3.externalOrderNumber = '123456';
        
    Account acc = (Account)TestClassAutomation.createSObject('Account');
    acc.Name = 'Test';
    acc.billingStateCode = '';
    acc.ShippingStateCode = '';
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
    //ord.OpportunityId=opp.Id;
    ord.Accountid = acc.Id;
    ord.EffectiveDate = system.today();
    ord.status = 'Open';
    ord.Pricebook2Id = priceBook.id;
    ord.CurrencyIsoCode = 'GBP';
    ord.Packing_Instructions__c = 'Packing Instructions';
    ord.Shipping_Instructions__c = 'Shipping instructions';
    insert ord;

    Order o2 = [select id, ordernumber from Order where id = :ord.id];
    
    OrderItem oi = new OrderItem();
    oi.orderid=ord.id;
    oi.Shipped_Product__c = prod.id;
    oi.Quantity = 6;
    oi.pricebookentryid= sPriceBookEntry.id;
    oi.unitprice =1.00;
    insert oi;    
	  OrderItem oi2 = [select id, orderitemnumber from OrderItem where id = :oi.id];	
		
    oli.orderNumber = o2.orderNumber;
    //oli.id = o2.id;    
    oli.id = oi2.id;
    oli2.orderNumber = o2.orderNumber;
    oli3.orderNumber = o2.orderNumber;
    oli.itemNumber = oi2.OrderItemNumber;
    oli2.itemNumber = oi2.OrderItemNumber;
    oli3.itemNumber = oi2.OrderItemNumber;
    
    List<UpdateOneCRM.OrderLineItem> orderLineItemList = new List<UpdateOneCRM.OrderLineItem>();
    orderLineItemList.add(oli2);
    
    test.startTest();
    
    Boolean result = UpdateOneCRM.updateOrderLineItem(orderLineItemList);
    System.assertEquals(false, result, 'The result is not false');
    
    test.stopTest();
    }
  }  
    
  /*************************************************************************************************************
  * Name        : verifyExceptions1
  * Description : Verify the exceptions   
  * Input       : 
  * Output      : 
  *************************************************************************************************************/
  static testMethod void verifyExceptions1()
  {
    Boolean result = false;
    List<Account> generatedAccounts = generateTestAccounts(1);
    List<Integration_Request__c> generatedIntegrationRequests = generateIntegrationRequests(1, generatedAccounts.get(0).Id );
    UpdateOneCRM.IntegrationTransaction request = new UpdateOneCRM.IntegrationTransaction(); 
    request.integrationRequestId = generatedIntegrationRequests.get(0).id;   
    request.status = System.Label.INT_Status_Received;
    request.externalSystem = 'XXXX';
    Integration_Framework_Configuration__c ifc = new Integration_Framework_Configuration__c(Name = 'Name', 
                                                                                            Event__c = 'Enrol Student', 
                                                                                            Geo__c = 'Growth', 
                                                                                            Lob__c = 'HE', 
                                                                                            Market__c = 'ZA', 
                                                                                            Sub_Event__c = 'Sub Event', 
                                                                                            System_1__c = 'Sys 1', System_2__c = 'Sys 2');
    insert ifc;
    test.startTest();
    try
    {
      result = UpdateOneCRM.reportTransaction(request);
    }
    
    catch(UpdateOneCRM.UpdateOneCRMException e)
    {
      System.assertEquals(false, result, 'Returned result is not false');
    }
    
    test.stopTest();
  }    
  
  /*************************************************************************************************************
  * Name        : verifyExceptions2
  * Description : Verify the exceptions   
  * Input       : 
  * Output      : 
  *************************************************************************************************************/
  static testMethod void verifyExceptions2()
  {
    Boolean result = false;
    List<Account> generatedAccounts = generateTestAccounts(1);
    List<Integration_Request__c> generatedIntegrationRequests = generateIntegrationRequests(1, generatedAccounts.get(0).Id );
    UpdateOneCRM.IntegrationTransaction request = new UpdateOneCRM.IntegrationTransaction(); 
    request.integrationRequestId = generatedIntegrationRequests.get(0).id;   
    request.status = 'XXXX';
    request.externalSystem = 'Sys 1';
    Integration_Framework_Configuration__c ifc = new Integration_Framework_Configuration__c(Name = 'Name', 
                                                                                            Event__c = 'Enrol Student', 
                                                                                            Geo__c = 'Growth', 
                                                                                            Lob__c = 'HE', 
                                                                                            Market__c = 'ZA', 
                                                                                            Sub_Event__c = 'Sub Event', 
                                                                                            System_1__c = 'Sys 1', System_2__c = 'Sys 2');
    insert ifc;
    test.startTest();
    try
    {
      result = UpdateOneCRM.reportTransaction(request);
    }
    
    catch(UpdateOneCRM.UpdateOneCRMException e)
    {
      System.assertEquals(false, result, 'Returned result is not false');
    }
    
    test.stopTest();
  }    
  
  /*************************************************************************************************************
  * Name        : verifyExceptions3
  * Description : Verify the exceptions   
  * Input       : 
  * Output      : 
  *************************************************************************************************************/
  static testMethod void verifyExceptions3()
  {
    Boolean result = false;
    List<Account> generatedAccounts = generateTestAccounts(1);
    List<Integration_Request__c> generatedIntegrationRequests = generateIntegrationRequests(1, generatedAccounts.get(0).Id );
    UpdateOneCRM.IntegrationTransaction request = new UpdateOneCRM.IntegrationTransaction(); 
    request.integrationRequestId = generatedIntegrationRequests.get(0).id;   
    request.status = System.Label.INT_Status_Received;
    request.externalSystem = null;
    Integration_Framework_Configuration__c ifc = new Integration_Framework_Configuration__c(Name = 'Name', 
                                                                                            Event__c = 'Enrol Student', 
                                                                                            Geo__c = 'Growth', 
                                                                                            Lob__c = 'HE', 
                                                                                            Market__c = 'ZA', 
                                                                                            Sub_Event__c = 'Sub Event', 
                                                                                            System_1__c = '', System_2__c = '');
    insert ifc;
    test.startTest();
    try
    {
      result = UpdateOneCRM.reportTransaction(request);
    }
    
    catch(UpdateOneCRM.UpdateOneCRMException e)
    {
      System.assertEquals(false, result, 'Returned result is not false');
    }
    
    test.stopTest();
  }    
  
  /*************************************************************************************************************
  * Name        : generateIntegrationRequests
  * Description : Generate Integration Request records
  * Input       : NumOfIntegrationRequest - Number of Integration Request records to generate
  * INPUT       : The objectId to associate with the Integration Request
  * Output      : List of the Integration Request records generated
  *************************************************************************************************************/
  private static List<Integration_Request__c> generateIntegrationRequests(Integer numOfIntegrationRequests, Id objectId)
  {
   List<Integration_Request__c> integrationRequestsToInsert = new List<Integration_Request__c>();
       
    for(Integer i=0; i<numOfIntegrationRequests; i++)
    {
      Integration_Request__c integrationRequestToInsert = new Integration_Request__c(Object_Id__c = objectId);
      integrationRequestToInsert.Object_Name__c = 'Opportunity';
      integrationRequestToInsert.Direction__c = 'Outbound';
      integrationRequestToInsert.Event__c = 'Enrol Student';
      integrationRequestToInsert.Geo__c ='Growth';
      integrationRequestToInsert.Lob__c = 'HE';
      integrationRequestToInsert.Market__c = 'ZA'; 
      integrationRequestToInsert.Sub_Event__c = 'Sub Event';
      integrationRequestsToInsert.add(integrationRequestToInsert);
    }
       
    if(integrationRequestsToInsert.size()>0)
    {
      insert integrationRequestsToInsert;
    }
       
    return integrationRequestsToInsert;
  } 
  
  /*************************************************************************************************************
  * Name        : generateTestAccounts
  * Description : Generate Account records
  * Input       : NumOfAccounts - Number of account records to generate
  * Output      : List of the Account records generated
  *************************************************************************************************************/
  private static List<Account> generateTestAccounts(Integer numOfAccounts)
  {
    List<Account> accountsToInsert = new List<Account>();
        
    for(Integer i=0; i<numOfAccounts; i++)
    {
      Account accountToInsert = new Account(Name = 'Account' + (i+1));
      accountsToInsert.add(accountToInsert);
    }
        
    if(accountsToInsert.size()>0)
    {
      insert accountsToInsert;
    }
     
    return accountsToInsert;
  }
}