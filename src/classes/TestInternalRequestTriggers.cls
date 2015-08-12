/*******************************************************************************************************************
* Apex Class Name  : TestInternalRequestTriggers
* Version          : 1.0 
* Created Date     : 17 July 2015
* Function         : Test Class for TestInternalRequestTrigger 
* Modification Log :
*
* Developer                   Date                    Description
* ------------------------------------------------------------------------------------------------------------------
*                      17/07/2015              Created Initial Version of TestInternalRequestTriggers Class
*******************************************************************************************************************/

@isTest
private class TestInternalRequestTriggers
{
    static testMethod void myUnitTest()
    {
        // Create Test Record      
        Internal_Request__c  sIRequest   = new Internal_Request__c();
        User uTest1 = new User();
        String AcctRecordTypeId;
         List<RecordType> RecordTypeList = new List<RecordType>([select Id,Name from RecordType]);
        
        for (RecordType i : RecordTypeList) {
          if (i.Name == 'Bookstore') {
            AcctRecordTypeId = i.Id;
          }
        }     
        Account bkshop1  = new Account (name = 'Test Bookshop1', BillingStreet = 'Street1',
                   BillingCity = 'Sydney', BillingPostalCode = 'ABC DEF', BillingCountry = 'Australia',
                    //Vista_Account_Number__c = 'xyz',
                    RecordTypeId= AcctRecordTypeId );
        insert bkshop1;          
        utest1 = [Select Id,UserRole.Name, ManagerId, Manager.ManagerId, Manager.Manager.ManagerId, IsActive FROM User where IsActive = true AND UserRole.Name LIKE 'NA Sales Representative%' AND ManagerId!= null AND Manager.ManagerId!= null AND Manager.Manager.ManagerId!= null limit 1];
        //a = [Select Id, Name FROM Account limit 1    ];
        sIRequest.Adjustment_Type__c     = 'Registration';
        sIRequest.Sales_Person_Name__c   = utest1.Id; //'005g0000002CEEP'; 
        sIRequest.Account_Name__c        = bkshop1.id; // a.Id;
        sIRequest.Subject__c             = 'Australia';
        sIRequest.Description__c         = 'Victoria';
        sIRequest.ISBN__c                = '12345';
        sIRequest.Requested_Unit_Count__c= 1;
           
        // Insert Test Record
        insert sIRequest;
       
        // Start Test
        Test.startTest();
        // Recall inserted Record
            siRequest = [SELECT OwnerId, Sales_Person_Name__c FROM Internal_Request__c WHERE Id =:sIRequest.Id];
        // Simulate Blank Update (No value is changed)
            sIRequest.Sales_Person_Name__c = sIRequest.Sales_Person_Name__c;
        // Update Record
            update sIRequest;
        // Validate BeforeUpdate Trigger fired
            system.assertEquals(sIRequest.OwnerId, sIRequest.Sales_Person_Name__c, 'Owner Updated');
        // Negative test - Sales Person Name is Inactive, Owner Update Fails
        User uTest= new User();
            utest = [Select Id, IsActive FROM User where IsActive = false limit 1    ];
            siRequest.Sales_Person_Name__c  = uTest.Id;
            update sIRequest;
            system.assertNotEquals(sIRequest.OwnerId, sIRequest.Sales_Person_Name__c, 'Owner Not Updated');
            system.assertEquals(uTest.Id, sIRequest.Sales_Person_Name__c, 'Sales Person Updated');
        	sIRequest.Requested_Unit_Count__c = null;
        try{
        	update sIRequest;
        }catch (Exception e){
           // Assert DML Exception to cover catch block System.Assert(e.getTypeName() == 'DmlException');
        }
       /* Internal_Request__Share intShareReq= new Internal_Request__Share();
        
        intShareReq.ParentId= siRequest.Id;
        intShareReq.UserOrGroupId= utest1.ManagerId;
        intShareReq.AccessLevel = 'Edit';
        
          
        
        */
        
        
        Test.stopTest();
    }
    
    
    static testMethod void myUnitTest1()
    {
        // Create Test Record      
        Internal_Request__c  sIRequest   = new Internal_Request__c();
        User uTest1 = new User();
        String AcctRecordTypeId;
         List<RecordType> RecordTypeList = new List<RecordType>([select Id,Name from RecordType]);
        
        for (RecordType i : RecordTypeList) {
          if (i.Name == 'Bookstore') {
            AcctRecordTypeId = i.Id;
          }
        }     
        Account bkshop1  = new Account (name = 'Test Bookshop1', BillingStreet = 'Street1',
                   BillingCity = 'Sydney', BillingPostalCode = 'ABC DEF', BillingCountry = 'Australia',
                    //Vista_Account_Number__c = 'xyz',
                    RecordTypeId= AcctRecordTypeId );
        insert bkshop1;          
        utest1 = [Select Id,UserRole.Name, ManagerId, Manager.ManagerId, IsActive FROM User where IsActive = true AND UserRole.Name LIKE 'NA District Sales Manager%' AND ManagerId!= null AND Manager.ManagerId!= null limit 1];
        //a = [Select Id, Name FROM Account limit 1    ];
        sIRequest.Adjustment_Type__c     = 'Registration';
        sIRequest.Sales_Person_Name__c   = utest1.Id; //'005g0000002CEEP'; 
        sIRequest.Account_Name__c        = bkshop1.id; // a.Id;
        sIRequest.Subject__c             = 'Australia';
        sIRequest.Description__c         = 'Victoria';
        sIRequest.ISBN__c                = '12345';
        sIRequest.Requested_Unit_Count__c= 1;
           
        // Insert Test Record
        insert sIRequest;
       
        // Start Test
        Test.startTest();
        // Recall inserted Record
            siRequest = [SELECT OwnerId, Sales_Person_Name__c FROM Internal_Request__c WHERE Id =:sIRequest.Id];
        // Simulate Blank Update (No value is changed)
            sIRequest.Sales_Person_Name__c = sIRequest.Sales_Person_Name__c;
        // Update Record
       /*     update sIRequest;
        // Validate BeforeUpdate Trigger fired
            system.assertEquals(sIRequest.OwnerId, sIRequest.Sales_Person_Name__c, 'Owner Updated');
        // Negative test - Sales Person Name is Inactive, Owner Update Fails
        User uTest= new User();
            utest = [Select Id, IsActive FROM User where IsActive = false limit 1    ];
            siRequest.Sales_Person_Name__c  = uTest.Id;
            update sIRequest;
            system.assertNotEquals(sIRequest.OwnerId, sIRequest.Sales_Person_Name__c, 'Owner Not Updated');
            system.assertEquals(uTest.Id, sIRequest.Sales_Person_Name__c, 'Sales Person Updated');
        	sIRequest.Requested_Unit_Count__c = null;*/
        try{
        	update sIRequest;
        }catch (Exception e){
           // Assert DML Exception to cover catch block System.Assert(e.getTypeName() == 'DmlException');
        }
        
        Test.stopTest();
    }
    
    static testMethod void myUnitTest2()
    {
        // Create Test Record      
        Internal_Request__c  sIRequest   = new Internal_Request__c();
        User uTest1 = new User();
        String AcctRecordTypeId;
         List<RecordType> RecordTypeList = new List<RecordType>([select Id,Name from RecordType]);
        
        for (RecordType i : RecordTypeList) {
          if (i.Name == 'Bookstore') {
            AcctRecordTypeId = i.Id;
          }
        }     
        Account bkshop1  = new Account (name = 'Test Bookshop1', BillingStreet = 'Street1',
                   BillingCity = 'Sydney', BillingPostalCode = 'ABC DEF', BillingCountry = 'Australia',
                    //Vista_Account_Number__c = 'xyz',
                    RecordTypeId= AcctRecordTypeId );
        insert bkshop1;          
        utest1 = [Select Id,UserRole.Name, ManagerId, IsActive FROM User where IsActive = true AND UserRole.Name LIKE 'NA Regional Sales Manager%' AND ManagerId!= null limit 1];
        //a = [Select Id, Name FROM Account limit 1    ];
        sIRequest.Adjustment_Type__c     = 'Registration';
        sIRequest.Sales_Person_Name__c   = utest1.Id; //'005g0000002CEEP'; 
        sIRequest.Account_Name__c        = bkshop1.id; // a.Id;
        sIRequest.Subject__c             = 'Australia';
        sIRequest.Description__c         = 'Victoria';
        sIRequest.ISBN__c                = '12345';
        sIRequest.Requested_Unit_Count__c= 1;
           
        // Insert Test Record
        insert sIRequest;
       
        // Start Test
        Test.startTest();
        // Recall inserted Record
            siRequest = [SELECT OwnerId, Sales_Person_Name__c FROM Internal_Request__c WHERE Id =:sIRequest.Id];
        // Simulate Blank Update (No value is changed)
            sIRequest.Sales_Person_Name__c = sIRequest.Sales_Person_Name__c;
        // Update Record
       /*     update sIRequest;
        // Validate BeforeUpdate Trigger fired
            system.assertEquals(sIRequest.OwnerId, sIRequest.Sales_Person_Name__c, 'Owner Updated');
        // Negative test - Sales Person Name is Inactive, Owner Update Fails
        User uTest= new User();
            utest = [Select Id, IsActive FROM User where IsActive = false limit 1    ];
            siRequest.Sales_Person_Name__c  = uTest.Id;
            update sIRequest;
            system.assertNotEquals(sIRequest.OwnerId, sIRequest.Sales_Person_Name__c, 'Owner Not Updated');
            system.assertEquals(uTest.Id, sIRequest.Sales_Person_Name__c, 'Sales Person Updated');
        	sIRequest.Requested_Unit_Count__c = null;*/
        try{
        	update sIRequest;
        }catch (Exception e){
           // Assert DML Exception to cover catch block System.Assert(e.getTypeName() == 'DmlException');
        }
        
        Test.stopTest();
    }
}