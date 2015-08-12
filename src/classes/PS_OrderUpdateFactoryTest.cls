@isTest(seeAllData=true)
public with sharing class PS_OrderUpdateFactoryTest 
{
  static testMethod void testMethod1()
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
    oi.status__c = 'Cancelled';
    insert oi;  
    
    Orderitem oi1 = new OrderItem();
    oi1.orderid=sampleorder.id;
    oi1.Shipped_Product__c = prod.id;
    oi1.Quantity = 6;
    oi1.pricebookentryid= sPriceBookEntry.id;
    oi1.unitprice =1.00;
    oi1.status__c = 'Shipped';
    insert oi1;  
     
    List <OrderItem> orderItems = new List<OrderItem>();
    orderItems.add(oi); 
    orderItems.add(oi1);
    
  	Test.startTest();
  	
    List<PS_OrderUpdateInterface> updates = PS_OrderUpdateFactory.createOrderUpdates(orderItems);
    for(PS_OrderUpdateInterface updateInterface: updates)
    {
     updateInterface.updateOrders();
    }
    
    oi1.status__c = 'Cancelled';
    update oi1;
    updates = PS_OrderUpdateFactory.createOrderUpdates(orderItems);
    for(PS_OrderUpdateInterface updateInterface: updates)
    {
     updateInterface.updateOrders();
    }
    
    oi1.status__c = 'On Hold';
    update oi1;
    updates = PS_OrderUpdateFactory.createOrderUpdates(orderItems);
    for(PS_OrderUpdateInterface updateInterface: updates)
    {
     updateInterface.updateOrders();
    }
    
    List <OrderItem> emptyOrderItems = new List<OrderItem>();
    updates = PS_OrderUpdateFactory.createOrderUpdates(emptyOrderItems);
    for(PS_OrderUpdateInterface updateInterface: updates)
    {
      updateInterface.updateOrders();
    }
    
    Test.stopTest();
    }
  } 
}