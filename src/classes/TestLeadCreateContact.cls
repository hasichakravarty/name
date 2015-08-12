@isTest
    private class TestLeadCreateContact{  
     
     static testMethod void convertLeadWithSponsorEmailTest() {
         
         List<Lead> testLeads = TestDataFactory.createLead(1,'D2L'); 
         
         Lead testLead = testLeads[0];
         
         // Set sponsor email
         testLead.Sponsor_Type__c = 'Other';
         testLead.Sponsor_Email__c = 'test@example.com';
         
         Test.StartTest();   
         Database.insert(testLead);
         
         Database.LeadConvert lc = new database.LeadConvert();  
         lc.setLeadId(testLead.Id);    
         lc.setDoNotCreateOpportunity(false);
         lc.setConvertedStatus('Qualified');
         PS_lead_createContact.processedLead.clear();
         Database.ConvertLead(lc);
         
         Test.StopTest();
         
     }
    
     static testMethod void myCreateContactTest() {
       list<Lead> leadList = TestDataFactory.createLead(1,'D2L');                  
       System.debug('leadList-->5'+leadList);
      // Map<Id,Lead> mapWithLeadVal = new Map<Id,Lead>();   
       //PS_lead_createContact createCon = new PS_lead_createContact();
        

                 

       Test.Starttest();   
         Insert leadList;  
       for(Lead newLead : leadList)
       {
       
        if(newLead.Sponsor_Type__c !='Self'){
        Database.LeadConvert lc = new database.LeadConvert();  
     
       //System.assert(lcr.isSuccess());
        lc.setLeadId(newLead.id);    
        lc.setDoNotCreateOpportunity(false);
        lc.setConvertedStatus('Qualified');
        PS_lead_createContact.processedLead.clear();
        Database.LeadConvertResult lcr = Database.convertLead(lc);
       }
       }
          
     Test.Stoptest();    
    }
    
    static testMethod void myCreateContactTest_1() {
       list<Lead> leadList = TestDataFactory.createLead(1,'D2L');                   
       System.debug('leadList-->'+leadList);
      // Map<Id,Lead> mapWithLeadVal = new Map<Id,Lead>();   
       //PS_lead_createContact createCon = new PS_lead_createContact();
         Insert leadList;  

       Test.Starttest();   
        
       for(Lead newLead : leadList)
       {
        if(newLead.Sponsor_Type__c !='Parent'){
        Database.LeadConvert lc1 = new database.LeadConvert();  
     
       //System.assert(lcr.isSuccess());
        lc1.setLeadId(newLead.id);    
        lc1.setDoNotCreateOpportunity(false);
        lc1.setConvertedStatus('Qualified');
        PS_lead_createContact.processedLead.clear();
        Database.convertLead(lc1);
       }
       }
          
          
          
     Test.Stoptest();    
    }
    }