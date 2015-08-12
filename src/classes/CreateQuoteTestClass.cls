/*******************************************************************************************************************
* Apex Class Name  : CreateQuoteTestClass
* Version          : 1.0 
* Created Date     : 30 March 2015
* Function         : Test Class of the CreateQuote Class
* Modification Log :
*
* Developer                                Date                    Description
* ------------------------------------------------------------------------------------------------------------------
*   Accenture IDC                          31/03/2015              Created Initial Version
*******************************************************************************************************************/

@isTest(SeeAllData = True)                   
public class CreateQuoteTestClass{
 static testMethod void myTest() { 
 
     Account acc = new Account();
     acc.Name = 'Test';
     insert acc;
     
     contact con = new contact();
     con.Lastname= 'testcon';
     con.Firstname= 'testcon1';
     con.MobilePhone = '9999';     
     insert con;
     
     Opportunity opp = new opportunity();
      opp.AccountId = acc.id;    
      opp.Name = 'OppTest';
      opp.StageName = 'Qualification';
      opp.CloseDate = system.today();
      insert opp;
   
          
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
      prop.Apttus_Proposal__Primary__c = false;
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
      
      test.starttest();
      
      insert ocrlist;
      
      CreateQuote cq = new CreateQuote(new ApexPages.StandardController(opp));
       cq.opportunityId = opp.id;
      cq.Quote_create();
      cq.calcuate_priceList();
      
      test.stoptest();
 
 }
}