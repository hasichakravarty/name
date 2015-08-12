/*******************************************************************************************************************
* Apex Class Name  : CreateEditQuoteControllerTestClass
* Version          : 1.0 
* Created Date     : 30 March 2015
* Function         : Test Class of the CreateEditQuoteController Class
* Modification Log :
*
* Developer                                Date                    Description
* ------------------------------------------------------------------------------------------------------------------
*   Accenture IDC                          18/04/2015              Created Initial Version
*******************************************************************************************************************/

@isTest  (SeeAllData=True)                 
public class CreateEditQuoteControllerTestClass{
 static testMethod void myTest() {
 
  Account acc = new Account();
     acc.Name = 'Test';
     insert acc;
     

        List<Contact> con = new List<Contact>();          
        con = TestDataFactory.createContact(1);           
        insert con;          
                 
          
     Opportunity opp = new opportunity();
      opp.AccountId = acc.id;    
      opp.Name = 'OppTest';
      opp.StageName = 'Qualification';
      opp.Academic_Start_Date__c = system.today();
      opp.CloseDate = system.today();
      insert opp;
    ApexPages.currentPage().getParameters().put('id' , opp.id);
          
     OpportunityContactRole ocr = new OpportunityContactRole();
     ocr.ContactId=con[0].id;
     ocr.IsPrimary = True;
     ocr.Role='Evaluator';
     ocr.OpportunityId = opp.id;     
     insert ocr;
       
       test.starttest();
        Id Pricelistid ;
       CreateEditQuoteController ceq = new CreateEditQuoteController();
       ceq.opportunityId = opp.id;
       ceq.onLoad();
       ceq.calcuate_priceList();
       test.stoptest();
 
 }
}