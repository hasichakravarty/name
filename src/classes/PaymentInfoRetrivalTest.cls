@isTest
//Class created to cover the Test code coverage for the controller PaymentInfoRetrival
public  class PaymentInfoRetrivalTest {
 //Method created to do Test class code coverage 
    public static testmethod void insertOpportunity(){
    id pid=[select id from profile where name='ACN System Admin Read Only'].id;
       User u1 = new User(Alias = 'standt', Email='standarduser11@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = pid, 
            TimeZoneSidKey='America/Los_Angeles', UserName='test1234'+Math.random()+'@gmail.com', Geography__c = 'Growth',Market__c = 'ZA',Line_of_Business__c = 'Higher Ed');
            insert u1;
            System.assertEquals(u1.Email, 'standarduser11@testorg.com');
         system.runas(u1) {
            // List<Opportunity> opp = TestDataFactory.createOpportunity(1,'D2L');
             List<Account> acc = TestDataFactory.createAccount(1, 'Learner');
             Opportunity oppobj = new Opportunity();
             oppObj.Name = 'TestOpportunityName' ;        
             oppObj.CloseDate = date.today();          
             oppObj.StageName = 'TestOpportunityStageName' ;
             oppObj.AccountId = acc[0].id;        //'0011100000rXTzD';
             oppObj.Academic_Start_Date__c = date.today();
             oppObj.Type = 'New Business'; 
             oppObj.International_Sponsor__c = 'Yes'; 
             oppObj.Preferred_Campus__c = 'Durban';
             //oppObj.RecordTypeId = '012110000004rwd';  
             insert Oppobj;     
             
             PageReference testPage = new pagereference('apex/CustomerLedger');
             id customerid= Oppobj.id;
             testPage.getParameters().put('customerid',customerid);
             Test.setCurrentPage(testPage);
             ApexPages.StandardController sc = new ApexPages.standardController(Oppobj);
             Test.starttest();
             PaymentInfoProxyClass.getPaymentInfo(customerid,'CTI');
             PaymentInfoRetrival pir = new PaymentInfoRetrival();
             pir.institution = 'CTI';
             pir.getInstitutions();
             pir.search();
             Test.setMock(WebServiceMock.class, new TestMockRetrievePaymentInfo());
             pir.retreiveinfo();
             //RetrievePaymentInfoTest.coverTypes();
               
             PaymentInfo pi = new PaymentInfo();
             pi.trandate = null;
             pi.trantype = null;
             pi.tranamount = null;
             pi.tranbalance = null;
             pi.tranreference = null;
             pi.tranearlybird = null;
             pi.tranregpayment = null;  
             retreivePaymentInfo rpi = new retreivePaymentInfo();
             rpi.getInstitutions();
             rpi.search();  
             RetrievePaymentInfo.PaymentInfoItem pii = new RetrievePaymentInfo.PaymentInfoItem();
             RetrievePaymentInfo.RetrievePaymentInfoResponse rpir = new RetrievePaymentInfo.RetrievePaymentInfoResponse(); 
                           
             Test.stopTest();
         }
       }
}