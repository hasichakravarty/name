@isTest(SeeAllData = true)
private class TestSendEmailInstructor
{
    static testMethod void myUnitTest()
    {
         
      //code for creating an User
      User u = new User();
      u.LastName = 'secenario2user';
      u.alias = 'sen2usr'; 
      u.Email = 'secenario2user@gmail.com';  
      u.Username='secenario2user@gmail.com';
      u.LanguageLocaleKey='en_US'; 
      u.TimeZoneSidKey='America/New_York';
      u.LocaleSidKey='en_US';
      u.EmailEncodingKey='ISO-8859-1';
      u.ProfileId = '00eb0000000zBJ3';        
      u.Geography__c = 'Growth';
      u.Market__c = 'ZA';
      u.Line_of_Business__c = 'Higher Ed';
      u.Price_List__c = 'US HE All';
      insert u;
      
    System.runAs(u){
    
      //code written for creating an opportunity.

     
    
     
      // Create a test account
     Account testAcct = new Account (Name = 'My Test Account');
     insert testAcct;
     system.debug('testAcct--->'+testAcct);
     //query to get the Recordtype of the Opportunity
     RecordType opprdtype = [Select Id,name,SobjectType FROM RecordType where SobjectType = 'Opportunity' and name = 'D2L'];
      Opportunity Opp = new Opportunity();
          Opp.Name = '*NEW EDU 200 - Intro to Education';
          Opp.AccountId = testAcct.Id;
          Opp.StageName = 'Negotiations';
          Opp.CloseDate = System.today();
          Opp.Type = 'New Business';
          Opp.Amount = 555888555;
          Opp.RecordTypeId = opprdtype.id;     //'012g00000004tzM';  //currently hardcoded 
          insert Opp; 
          system.debug('Opp--->'+Opp);     
      //code for creating the contact 
      Contact con = new Contact();
       con.AccountId= testAcct.Id;
       con.FirstName = 'Testing';
       con.LastName = 'Contact';
       con.Email ='contact@gmail.com';
       con.MailingCity ='BNG';
       con.MailingCountry ='India';
       con.MailingState ='Karnataka';
       con.MailingStreet = 'MGR';
       con.MailingPostalCode = '560037';
       insert con;
       system.debug('con--->'+con);
       
       //code for creating the Product
       Product2 prod = new Product2();
           prod.Name = 'PearsonChoice Book';
           prod.Author__c = '2015';
           prod.Full_Title__c = 'Pearson';
           prod.Edition__c = '15';
           prod.ISBN__c = '9780321858306';
           prod.IRC_Link__c = 'http://pearson.com';
           insert prod;
           system.debug('prod--->'+prod);
          
           //code for creating the Product
       Product2 prod1 = new Product2();
           prod1.Name = 'GalaxyStory Book';
           prod1.Author__c = '2014';
           prod1.Full_Title__c = 'Galaxy';
           prod1.Edition__c = '14';
           prod1.ISBN__c = '9780321858305';
           prod1.IRC_Link__c = 'http://galaxy.com';
           insert prod1;
           system.debug('prod1--->'+prod1);
           
           //code for creating the Product
       Product2 prod2 = new Product2();
           prod2.Name = 'Globalmind Book';
           prod2.Author__c = '2013';
           prod2.Full_Title__c = 'Global';
           prod2.Edition__c = '13';
           prod2.ISBN__c = '9780321858304';
           prod2.IRC_Link__c = 'http://global.com';
           insert prod2;
           system.debug('prod2--->'+prod2);
         
         //code for creating the pricelist  
        Pricebook2 pb = new Pricebook2();
            pb.Name = 'Standard Price Book 2015';
            pb.Description = 'Price Book 2015 Products';
            pb.IsActive = true;
            insert pb;
            system.debug('pb--->'+pb);
            
            //code for creating the preason choice
            List<Pearson_Choice__c> pclist = new List<Pearson_Choice__c>();
          Pearson_Choice__c pc = new Pearson_Choice__c();
            pc.Bookstore__c = prod.id;  //'01tg0000002R6iB';
            pc.Bookstore_Price__c = 45.00;
            pc.eText_Offer_Price__c = 10.00;
            pc.Print_Offer_Price__c = 11.00;
            pc.Includes_Pearon_eText__c = 'with eText';
            pc.Access_Length__c = '12 months';
            pc.Bookstore_ISBN_s__c = '9780321858306';
            pc.Brand__c = 'Pearson';
            pclist.add(pc);
            Pearson_Choice__c pc1 = new Pearson_Choice__c();
            pc1.Instant_Access__c = prod.id;  //'01tg0000002RVNW';
            pc1.Instant_Access_Price__c = 20.99;
            pc1.eText_Offer_Price__c = 10.00;
            pc1.Print_Offer_Price__c = 11.00;
            pc1.Includes_Pearon_eText__c = 'with eText';
            pc1.Access_Length__c = '12 months';
            pc1.Bookstore_ISBN_s__c = '9780321858306';
            pc1.Brand__c = 'Pearson';
            pclist.add(pc1);
            insert pclist;
            //system.debug('pc--->'+pc);
            
            //code for creating the Opportunity Contact Role
         OpportunityContactRole opcr = new OpportunityContactRole();
             opcr.ContactId = con.Id;
             opcr.Role = 'Business User1';
             opcr.OpportunityId = Opp.id;
             opcr.IsPrimary=TRUE;
             insert opcr;
             system.debug('opcr--->'+opcr);
     
        Apttus_Config2__PriceList__c priceListObjec = new Apttus_Config2__PriceList__c();
         priceListObjec.Name = 'US HE All';
          insert priceListObjec;
        
        
        //code for creating the Apttus_Config2__PriceListItem__c
        Apttus_Config2__PriceListItem__c acp = new Apttus_Config2__PriceListItem__c();
         acp.Apttus_Config2__ProductId__c = prod.Id;//'01tg0000002P31r';
         acp.Apttus_Config2__ListPrice__c = 11.0;
         acp.Apttus_Config2__Active__c = true;
         acp.Apttus_Config2__PriceListId__c = priceListObjec.Id; //'a2Ig0000000JOQC';
         acp.Net_Price__c = 212.00;
         insert acp;
         system.debug('acp--->'+acp);
         String pcids =pc.id+','+pc1.id;
          
          Test.startTest(); 
          Test.setCurrentPage(Page.PS_SendEmail_Contacts);
           ApexPages.currentPage().getParameters().put('productId', prod2.id); 
           ApexPages.currentPage().getParameters().put('pc',pcids);
           ApexPages.currentPage().getParameters().put('opportunityId',Opp.id);
           ApexPages.currentPage().getParameters().put('col','Bookstore_Price__c,Suggested Retail Price,Instant_Access_Price__c,eText_Offer_Price__c,Print_Offer_Price__c');
  
     SendEmailInstructor smi = new SendEmailInstructor();
      List<Apttus_Config2__PriceListItem__c>  suggestedPrice = new List<Apttus_Config2__PriceListItem__c>();
       Map<Id,Apttus_Config2__PriceListItem__c> suggestedPricemap = new Map<Id,Apttus_Config2__PriceListItem__c>();
       List<Contact> listWithPrimaryContact = new List<Contact>();
       List<Contact> listWithContact = new List<Contact>();
      Set<Id> prodIdset=new Set<Id>();
      smi.ConstructingEmailBody();
      smi.getContactValues();
      smi.addContactToList0();     
      smi.addContactToList1();
      smi.retrieveProductDetails();
      smi.retrieveContactDetails();  
      smi.getselectedContacts();
      smi.addContactToList();
      smi.addContactToListRM();
      
      
      //smi.additionalEmailAddress();   
      smi.cancel(); 
      smi.ConstructingEmailBody();  
      String myString = 'StringToBlob';
      Blob myBlob = Blob.valueof(myString);   
      smi.documentbody= myBlob;
      smi.documentname ='Test document Name';
      smi.suggestedRetailprice = 0.00;
      
      smi.sendEmail();
      smi.emailBody1 = 'emailBody1';
      smi.mailsent = true; 
      System.assert(true);
      Test.stopTest();   
     
        }// run as close
    }
    
}