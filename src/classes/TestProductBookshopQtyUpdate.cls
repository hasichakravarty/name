@isTest
private class TestProductBookshopQtyUpdate {
/* AA (Deloitte) - Deactivated as UK Users not onboarded yet
 
 
    public static testMethod void myUnitTest() {
    
        Test.startTest();
        String AcctRecordTypeId;
        String ContactRecordTypeId;
        String DiscRecordTypeId;
        String ClusterRecordTypeId;
        String OptyRecordTypeId;                        
        
        List<RecordType> RecordTypeList = new List<RecordType>([select Id,Name from RecordType]);
        
        for (RecordType i : RecordTypeList) {
          if (i.Name == 'Bookshop') {
            AcctRecordTypeId = i.Id;
          }
          if (i.Name == 'Bookshop Contact') {
             ContactRecordTypeId = i.Id;
          }
          
          if (i.Name == '3) Discipline') {
            DiscRecordTypeId = i.Id;
          }
          if (i.Name == '2) Cluster') {
            ClusterRecordTypeId = i.Id;
          }
          if (i.Name == 'New Multi-Component') {
            OptyRecordTypeId = i.Id;
          }                    
        }        
        // TO DO: implement unit test
        Product2 prod1 = new Product2 (name = 'Test Prod1');
        insert prod1;

        Product2 prod2 = new Product2 (name = 'Test Prod2');
        insert prod2;
        
        Account bkshop1  = new Account (name = 'Test Bookshop1', BillingStreet = 'Street1',
                   BillingCity = 'London', BillingPostalCode = 'ABC DEF', BillingCountry = 'UK',
                    Vista_Account_Number__c = 'xyz',RecordTypeId= AcctRecordTypeId );
        insert bkshop1;
        
        Account bkshop2  = new Account (name = 'Test Bookshop2', BillingStreet = 'Street2',
                   BillingCity = 'London', BillingPostalCode = 'ABC DEF', BillingCountry = 'UK',
                    Vista_Account_Number__c = 'xyz1',RecordTypeId = AcctRecordTypeId );
        insert bkshop2;
        
        Account bkshop3  = new Account (name = 'Test Bookshop3', BillingStreet = 'Street3',
                   BillingCity = 'London', BillingPostalCode = 'ABC DEF', BillingCountry = 'UK',
                    Vista_Account_Number__c = 'xyz3',RecordTypeId = AcctRecordTypeId );
        insert bkshop3;


        Account_Product__c ap1 = new Account_Product__c (Account__c = bkshop1.Id, Product__c = prod1.Id,
                   Stocked_Quantity__c = 10,Actual_Sold_Quantity__c = 10);
        insert ap1;
        
        Account_Product__c ap2 = new Account_Product__c (Account__c = bkshop2.Id, Product__c = prod1.Id,
                   Stocked_Quantity__c = 15,Actual_Sold_Quantity__c = 20);
        insert ap2;

        //check inserted value        
        Product2 prod = [select Bookshop_Quantity__c,Actual_Sold_Quantity__c from Product2 where Id = :prod1.Id];                 
        System.assertEquals(prod.Bookshop_Quantity__c, 25);
        System.assertEquals (prod.Actual_Sold_Quantity__c,30);

        //check updates
        Account_Product__c ap3 = [select Id,Stocked_Quantity__c from Account_Product__c where Id = :ap2.Id];
        ap3.Stocked_Quantity__c = 12;
        ap3.Actual_Sold_Quantity__c  = 15;
        update ap3;
        Product2 prod_1 = [select Bookshop_Quantity__c,Actual_Sold_Quantity__c from Product2 where Id = :prod1.Id];                 
        System.assertEquals(prod_1.Bookshop_Quantity__c, 22);
        System.assertEquals (prod_1.Actual_Sold_Quantity__c,25);

        //check deletes
        delete ap3;
        Product2 prod_2 = [select Bookshop_Quantity__c,Actual_Sold_Quantity__c from Product2 where Id = :prod1.Id];                 
        System.assertEquals(prod_2.Bookshop_Quantity__c, 10);
        System.assertEquals (prod_2.Actual_Sold_Quantity__c,10);

        //Account_Product__c ap4 = new Account_Product__c (Account__c = bkshop1.Id, Product__c = prod1.Id,
        //           Stocked_Quantity__c = 15);
        //insert ap4;
                        
        Test.stopTest();        
    }
    */
}