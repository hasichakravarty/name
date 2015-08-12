/**
 * Class Name: TestDataFactory 
 * @author: Kalidass Gujar
 * Date: 4/27/2015
 * Requirement/Project Name: Pearson
 * @description Utility Class for test data creation
 *
 */
@isTest                   
public class TestDataFactory {
static Opportunity oppObj1;
static Contact conObj;
static Opportunity oppObj2;
static Contact conObj1;

    /**
     * @description 
     *      This method creates one or more account test data.   
     * 
     * @param numAccts - number of account to be created
     * @param recType - account record type name
     * @return accountList - list of created accounts
     * @throws exception - none
     */     
    public static List<Account> createAccount(Integer numAccts, String recType) {
        List<Account> accountList = new List<Account>(); 
        //Get the record type ID using the recType parameter. recType will be the Record type name.
        List<RecordType> rt = [SELECT Id, Name FROM RecordType WHERE SobjectType = 'Account' AND Name =: recType LIMIT 1];  
        
        //Create the account object and assign values to the required account fields.
        for(Integer i=0;i<numAccts;i++){
            Account accountRecord = new Account(Name='Test Account' + i, Phone='+9100000' + i, ShippingCountry = 'India', ShippingCity = 'Bangalore', ShippingStreet = 'BNG' + i, ShippingPostalCode = '560037' +i);
            system.debug('acount rectype-->' +accountRecord.REcordtypeId);
            if(rt.size() > 0){
                //Set the record type of the account 
                accountRecord.RecordTypeId = rt[0].Id;
            }

            if(recType == 'Direct Corporate'){
                accountRecord.AccountNumber='AN000' + i;
                
                
            }
            else if(recType == 'Direct SPH Inter-Division'){
              //  accountRecord.Contact_Person__c = 'Contact Person ' + i;              
                //START: D-1091 Modified by FrancisBenzon corrected assignment String to String
                accountRecord.Phone = '0' + i;
                //END: D-1091 Modified by FrancisBenzon corrected assignment String to String                                   
            }
            else if(recType == 'Mailing Agent'){
               // accountRecord.Mailing_Agent_Code__c = '00000' + i;
                accountRecord.Phone = '00000' + i;
            }
            //Add the account object to the account list 
            accountList.add(accountRecord);
        }
        
        return accountList;
    }
    
        public static List<Contact> createContact(Integer numContacts) {

        List<Contact> contactList = new List<Contact>();
        Account AccountRec = new account(Name='Test Account1', Phone='+9100000' , ShippingCountry = 'India', ShippingCity = 'Bangalore', ShippingStreet = 'BNG', ShippingPostalCode = '560037');
        insert AccountRec;
        for(Integer i=0;i<numContacts;i++){
            Contact contactRecord = new Contact(FirstName='TestContactFirstname'+ i, LastName='TestContactLastname' + i,
                                                AccountId=AccountRec.Id ,Salutation='MR.', Email='sampleemailaddress' + i + '@email.com', 
                                                Phone='111222333' + i);     
            contactList.add(contactRecord);
        }
        
        return contactList;
    }  
    
    public static List<Case> createCase(Integer numCase , String recordType) {

     List<Case> caseList = new List<Case>();
     
     //Generate an account
     Account acc = new Account(Name = 'Account 1');
     insert acc;
     
     RecordType rt = [SELECT Id, Name FROM RecordType WHERE SobjectType = 'Case' AND Name =: recordType ];
     
     Contact contactRecord = new Contact(FirstName='TestContactFirstname', LastName='TestContactLastname',
                                                Salutation='MR.', Email='sampleemailaddress.@email.com', 
                                                Phone='111222333'); 
     Insert contactRecord;                                   
    
    
     for(Integer i=0;i<numCase;i++){
             if(recordType == 'Cancellation request'){
                Case caseRecord = new Case(Type ='Cancellation request',ContactId = contactRecord.id,Status ='New',Priority='Low',Origin ='Post',Reason = 'financial',Returning_Tablet__c = 'No',
                                                         Sponsor_name__c = contactRecord.id,Tablet_Unique_Number__c = '123', RecordTypeId = rt.id, AccountId = acc.Id );     
                   caseList.add(caseRecord);
             }
            else if(recordType == 'General'){
                Case caseRecord = new Case(Status ='New',Priority='Low',Origin ='Phone',
                                           RecordTypeId = rt.id,AccountId = acc.Id );     
                caseList.add(caseRecord);
            }
        }
       // Insert caseList
        return caseList;
    }  
    
    public static List<Action__c> createAction(List<Id> caseIds,Integer numCase) {

        List<Action__c> actions = new List<Action__c>();
        Integer i = 0;
        for(Id identifier : caseIds){
            for(i=0;i<numCase;i++){
                Action__c act = new Action__c( Case__c = identifier , Template__c = 'test'+i++ , 
                                               Title__c = 'test'+i++ , Status__c ='Active');
                actions.add(act);
            }    
        }
       
        return actions;
    }  
    
    public static List<AccountContact__c> createAccountContact(Integer numAccountContacts,Id accountId,Id contactId) {        
        List<AccountContact__c> AccountcontactList = new List<AccountContact__c>();            
        for(Integer i=0;i<numAccountContacts;i++){            
            AccountContact__c AccountcontactRecord = new AccountContact__c(Account__c=accountId, 
                                                                           Contact__c=contactId,
                                                                           Role_Detail__c='Sponser'); 
            AccountcontactRecord.Primary__c=true;
            AccountcontactRecord.Financially_Responsible__c = true;
            AccountcontactRecord.Account_Name__c = false;                                                                              
            AccountcontactList.add(AccountcontactRecord);        
        }                
        return AccountcontactList;    
    }  

        public static List<Lead> createLead(Integer numLeads, String recType) {
         List<Lead> leadList = new List<Lead>(); 
         List<RecordType> rtye = [SELECT Id, Name FROM RecordType WHERE SobjectType = 'Lead' AND Name =: recType LIMIT 1]; 
         Lead leadRecord;        
         for(Integer i=0;i<numLeads;i++){
         leadRecord = new Lead();
         leadRecord.LastName='Abraham'+i;
         leadRecord.FirstName='John' +i;
         leadRecord.Company='Test' +i;
         leadRecord.Preferred_Contact_Method__c = 'Email';
         leadRecord.Email='rahulgarje55@gmail.com' +i;
         leadRecord.LeadSource= 'Walk-In';
         leadRecord.Interview_Attendance__c = true;
         leadRecord.Status='open';
          Account leadAccountRecord = createAccount(1, 'Organisation')[0];
          insert leadAccountRecord;  
          System.debug('LeadAccountRecord --> '+LeadAccountRecord);
          leadRecord.Institution_Organisation__c = leadAccountRecord.id;         //  '0011100000jh8Et';
          leadRecord.Country_of_Origin__c = 'India';
          leadRecord.First_Language__c = 'English';
          leadRecord.Preferred_Campus__c='Durban';
          leadRecord.international_student__c  ='Yes';
          
          
          leadRecord.Sponsor_Type__c = 'Self';
        
           
           //leadRecord.Sponsor_Type__c = 'Parent';
          leadRecord.Sponsor_Sponsor__c = 'TestclassSponsor';   
          leadRecord.Sponsor_Preferred_Method_of_Contact__c = 'Email';  
          leadRecord.Sponsor_Email__c ='testclass@sponsor.com'; 
           leadRecord.Sponsor_Name__c  ='Test';
           
          
            system.debug('i value is -->'+i); 
          leadRecord.country = 'India';
          leadRecord.City= 'Bangalore'+ i;     
          
               if(rtye.size() > 0){
                 //Set the record type of the account 
                 leadRecord.RecordTypeId = rtye[0].Id;
             }

            leadList.add(leadRecord);
        }
        
            return leadList;
            //Insert leadList;
        } 
        
        public static List<Opportunity> createOpportunity(Integer numOpportunity, String recType) {
         List<Opportunity> oppList = new List<Opportunity>(); 
         List<RecordType> opprtye = [SELECT Id, Name FROM RecordType WHERE SobjectType = 'Opportunity' AND Name =: recType LIMIT 1]; 
         Lead opportunityRecord;
         for(Integer i=0 ; i<=numOpportunity ; i++ ){
         Opportunity oppObj = new Opportunity();
         oppObj.Name = 'TestOpportunityName' + i;
         oppObj.CloseDate = date.today();
           oppObj.StageName = 'TestOpportunityStageName' + i;
         if(opprtye.size() > 0){
                 //Set the record type of the account 
                 oppObj.RecordTypeId = opprtye[0].Id;
             }
         oppList.add(oppObj);
         }
         return oppList;
        } 
         public static String getUserNamePrefix(){

        return UserInfo.getOrganizationId() + System.now().millisecond();
        
         }

            
            public static List<User> createUser(Id profileId){

                List<user> userlist = new List<User>();
                for(Integer i=0;i<200;i++)
                 {
                    User u = new User();
                  u.LastName = 'happy';
                  u.alias = 'happy'; 
                  u.Email = 'h@gmail.com';  
                  u.Username='test1234'+Math.random()+'@gmail.com';
                  u.CommunityNickname = 'happy' +Math.random();
                  u.LanguageLocaleKey='en_US'; 
                  u.TimeZoneSidKey='America/New_York';
                  u.LocaleSidKey='en_US';
                    u.EmailEncodingKey='ISO-8859-1';
                     u.ProfileId = profileId;              
                    u.Geography__c = 'Growth';
                     u.Market__c = 'ZA';
                       u.Line_of_Business__c = 'Higher Ed';
                         userlist.add(u);                
                 }               
                 return userlist;           
            }            

            public static List<Opportunity> createnewopportnity(Integer numOppor){
                  
                                                 
                Account acc =  new Account();
                acc.Name = 'Mani';
                 acc.Line_of_Business__c = 'Higher Ed';
                  acc.Geography__c = 'Core';              
                insert acc;
                
                conObj1 = new Contact();                  
              conObj1.FirstName = 'FName';
               conObj1.LastName = 'LName';
                conObj1.AccountId = acc.Id;            
                 conObj1.email = 'cont@gmail.com';
                                      
                insert conObj1;   
                                
                List<Id> oppIds = new List<Id>();        
                List<Opportunity> opplist = new List<Opportunity>();
               Opportunity opp;
                for(Integer i=0;i<numOppor;i++){

                     oppObj2 = new Opportunity();       
                     oppObj2 .Name = 'OpporName';
                     oppObj2 .AccountId = acc.Id;
                     oppObj2 .CloseDate = System.TODAY() + 30;
                     oppObj2 .StageName = 'OpporStageName';     
                     oppObj2 .Registration_Payment_Reference__c = 'A12B'; 
                     oppObj2 .Spring__c = 10;
                     oppObj2 .Fall__c = 10;
                     oppObj2 .Selling_Period__c = '2015 - Spring';                         
                          opplist.add(oppObj2);              
                       
                }  
                 insert oppObj2; 
                        
                return opplist;
            }


            public static List<OpportunityContactRole> createnewOpportunityContactRole(){
            
                       
          List<Id> oppconId = new List<Id>();
                      
            List<OpportunityContactRole> ocrlist1 = new  List<OpportunityContactRole>();
               OpportunityContactRole oc;             
             for(Integer j=0;j<2;j++){
             oc = new OpportunityContactRole();
             oc.opportunityId =  oppObj2.Id;            
              oc.contactId = conObj1.Id;
              oc.Role =  'Business User';
               oc.IsPrimary = True;             
                ocrlist1.add(oc); 
                           
             } 
               
                 System.debug('@@@@@' +ocrlist1);            
              return  ocrlist1;    
          }   
            
   
    
        
      public static List<Event> createEvent(Integer numEvent){
                oppObj1 = new Opportunity();        
              oppObj1.Name = 'TestOpportunityName';
            oppObj1.CloseDate = System.TODAY();
         
         oppObj1.StageName = 'TestOpportunityStageName';
         insert oppObj1;
                      
        List<Id> eventIds = new List<Id>();        
        List<Event> eventlist = new List<Event>();
         
        Event e;
        Account accObj =  new Account();
                accObj.Name = 'Abhi';
                 accObj.Line_of_Business__c = 'Higher Ed';
                  accObj.Geography__c = 'Core';              
                insert accObj;
    
                conObj = new Contact();                  
              conObj.FirstName = 'FirstName';
               conObj.LastName = 'LastName';
                conObj.AccountId = accObj.Id;            
                 conObj.email = 'abhijit@gmail.com';
                  conObj.Secondary_Email__c = 'abhis13191@gmail.com';
                               
                insert conObj;          
             for(Integer i=0;i<numEvent;i++){
         
          e = new Event();
            e.whatId = oppObj1.Id;          
            e.OwnerId = userinfo.getUserId();
          
            e.Type__c = 'Face To Face Meeting';                       
            e.IsRecurrence  = false;
            
             e.subject__c = 'Returning Student Interview';                                               
             e.Subject = 'Enrollment Date - Returning Interview';                         
             e.EndDateTime = System.Today();                       
             e.StartDateTime = System.Today();                       
             e.Location = 'To Be Determined';                                              
             e.IsAllDayEvent = true;                        
             e.Status__c = 'Completed';                                             
             e.ActivityDate = System.Today();                                             
             e.ActivityDateTime =  System.Today();                       
             e.WhoId = conObj.Id;
              e.Sponsor_Attended__c = True;
              
               
             eventlist.add(e);
                system.debug('####' +eventlist);             
         }
                //insert eventlist;         
            return eventlist;         
        }  
        


         
          public static List<OpportunityContactRole> createOpportunityContactRole(){
            
           /* oppObj1 = new Opportunity();           
        oppObj1.Name = 'TestOpportunityName';
            oppObj1.CloseDate = System.TODAY();     
         oppObj1.StageName = 'TestOpportunityStageName';
         insert oppObj1; 
         System.debug(oppObj1);
            
                Account accObj =  new Account();
                accObj.Name = 'Abhi';
                 accObj.Line_of_Business__c = 'Higher Ed';
                  accObj.Geography__c = 'Core';              
                insert accObj;
                System.debug(accObj);  
                              
             conObj = new Contact();                  
          conObj.FirstName = 'TestFirstName';
           conObj.LastName = 'LastName';
            conObj.AccountId = accObj.Id;          
             conObj.email = 'abhinav@gmail.com';
               
                                      
                insert conObj;  
                System.debug(conObj);  */ 
                       
          List<Id> oppconId = new List<Id>();
                      
            List<OpportunityContactRole> ocrlist = new  List<OpportunityContactRole>();
               OpportunityContactRole ocr;             
             for(Integer j=1;j<2;j++){
             ocr = new OpportunityContactRole();
             ocr.opportunityId =  oppObj1.Id;            
              ocr.contactId = conObj.Id;
              ocr.Role =  'Decision Maker';
              
                ocrlist.add(ocr); 
                           
             } 
                //insert ocrlist;
                 System.debug('@@@@@' +ocrlist);            
              return   ocrlist;    
          }    
          
    
    
  



    /**
     * @description 
     *      This method creates one or more AccountContact test data.   
     * 
     * @param accountId - accountId for which Account Contact to be created
     * @param contactIds - contacts associated to the particular account
     * @param primary - whether the Contact is primary or not
     * @param financiallyResponsible - whether the contact is financially responsible or not
     * @return accountContactList - list of created accountContacts
     * @throws exception - none
     */     
    public static List<AccountContact__c> createAccountContact(Id accountId, List<Id> contactIds, boolean primary, boolean financiallyResponsible ) {
        List<AccountContact__c> accountContactList = new List<AccountContact__c>();
        
        for(Id conId : contactIds){
            AccountContact__c accCon = new AccountContact__c();
            accCon.Account__c = accountId;
            accCon.Contact__c = conId;
            accCon.Financially_Responsible__c = financiallyResponsible;
            accCon.Primary__c = primary;
            accCon.Role_Detail__c = 'Learner';
            accountContactList.add(accCon);
         }
        
            Boolean NoSponsor = false;
            for(AccountContact__c ac : accountContactList){
                if(ac.Financially_Responsible__c == true)
                    NoSponsor = true;
            }
            
            //system.debug('\n\n############ TestDataFactory : NoSponsor - '+NoSponsor+'\n\n');
        
        /*  if(!NoSponsor){
                system.debug('\n\n############ Creating financially responsible---------------');
                AccountContact__c accCon = new AccountContact__c();
                accCon.Account__c = accountId;
                accCon.Contact__c = contactIds[0];
                accCon.Financially_Responsible__c = false;
                accCon.Primary__c = false;
                accCon.Role_Detail__c = 'Student';
                accountContactList.add(accCon);
            }*/
        
         
        system.debug('\n\n TestClass  accountContactList :'+accountContactList+'\n\n'); 
        return accountContactList;
    }
    
    //method to create test data
    public static AccountTeamMember createAccountTeamMember()
    {
      AccountTeamMember  acountTeamMember = new AccountTeamMember();
      acountTeamMember.userId ='00511000002OCOH'; 
      acountTeamMember.TeamMemberRole='Sales';
    //  acountTeamMember.Id ='1';
      // acountTeamMember.AccountId='1';
      return acountTeamMember ;
    }
    
    
public static List<Event> createOnlyEvent(Integer numEvent , Opportunity opptyObj , Contact cntObj){
        List<Event> lstEvnt = new List<Event>(); 
         for(Integer i=0;i<numEvent;i++){
         
          Event eveObj = new Event();
            eveObj .whatId = opptyObj.id;          
            //e.OwnerId = userinfo.getUserId();
          
             eveObj.Type__c = 'Face To Face Meeting';                       
             eveObj.IsRecurrence  = false;
             eveObj.subject__c = 'Returning Student Interview';                                               
             eveObj.Subject = 'Returning Student Interview';                         
             eveObj.EndDateTime = System.Today();                       
             eveObj.StartDateTime = System.Today();                       
             eveObj.Location = 'To Be Determined';                                              
            // e.IsAllDayEvent = true;                        
             eveObj.Status__c = 'Cancelled';                                             
             eveObj.ActivityDate = System.Today();                                             
             eveObj.ActivityDateTime =  System.Today();                       
             eveObj.WhoId = cntObj.id;
             eveObj.Sponsor_Attended__c = True;
            lstEvnt.add(eveObj);
         }
            return lstEvnt;         
        }  

//DataMethods for TestVFC_AddNewTeamMember
public static AccountTeamMember createAccount()
{
   List<RecordType> rt = [SELECT Id, Name FROM RecordType WHERE SobjectType = 'Account' AND Name ='School' LIMIT 1]; 
   Account acc = new Account(name='Test1',Line_of_Business__c='Higher Ed',Geography__c='Growth',Phone='+9100000',ShippingCountry = 'India', ShippingCity = 'Bangalore', ShippingStreet = 'BNG', ShippingPostalCode = '560037');
   insert acc;
   AccountTeamMember atm = new AccountTeamMember(accountid=acc.id,UserId=UserInfo.getUserId(),TeamMemberRole='Sales' );
   insert atm;
   AccountShare addAccountShare = [select Accountid,AccountAccessLevel,OpportunityAccessLevel,CaseAccessLevel,ContactAccessLevel from AccountShare where accountid =: acc.id and UserOrGroupId =:UserInfo.getUserId()]; 
         //insert addAccountShare;
   return atm; 
}

                public static List<User> createUser(Id profileId,Integer numOfRec){

                List<user> userlist = new List<User>();
                for(Integer i=0;i<numOfRec;i++)
                 {
                    User u = new User();
                  u.LastName = 'happy';
                  u.alias = 'happy'; 
                  u.Email = 'h@gmail.com';  
                  u.Username='test1234'+Math.random()+'@gmail.com';
                  u.CommunityNickname = 'happy' +Math.random();
                  u.LanguageLocaleKey='en_US'; 
                  u.TimeZoneSidKey='America/New_York';
                  u.LocaleSidKey='en_US';
                    u.EmailEncodingKey='ISO-8859-1';
                     u.ProfileId = profileId;              
                    u.Geography__c = 'Growth';
                     u.Market__c = 'US';
                       u.Line_of_Business__c = 'Higher Ed';
                       u.Business_Unit__c = 'CTIMGI';
                      U.Price_List__c= 'Math & Science';
                         userlist.add(u);                
                 }               
                 return userlist;           
            }  
    
   
    
  public static List<Product2> prdList   = null; 
   public static List<Pearson_Choice__c> pcList   = null;     
  /**
     * @description 
     *      This method creates one or more Product test data.   
     * 
     * @param numProducts - number of products to be created
     * @return ProductList - list of created products
     * @throws exception - none
     */     
    public static List<Product2> createProduct(Integer numProducts) {
      prdList = new List<Product2>(); 
       for(Integer i =0;i<=numProducts; i++) 
       {
         Product2 prodObjec = new Product2();
         prodObjec.Name = 'Test Product';
         prodObjec.Apttus_Config2__ConfigurationType__c='Bundle';   
         prodObjec.Market__c ='US';
         prodObjec.Business_Unit__c ='US Field Sales';  
         prodObjec.Author__c = 'Test Author';
         prodObjec.Status__c ='PUB';
         prodObjec.Line_of_Business__c='Higher Ed'; 
        //insert   prodObjec;
        prdList.add(prodObjec); 
       }
      return prdList;  
    }
   
    public static List<Pearson_Choice__c> insertPC()
    {
    pcList = new   List<Pearson_Choice__c>();  
    Pearson_Choice__c pc = new Pearson_Choice__c();
    pc.Product_Family__c = prdList[0].id;
    pc.Bookstore__c = prdList[0].id;
    pc.Access_Length__c ='access';
    pc.Bookstore_Price__c = 123.00;
    pc.eText_Offer_Price__c = 245.21;
    pc.Sequence__c =1;
    pc.Instant_Access_Price__c = 151.00;
    insert pc; 
    pcList.add(pc) ;  
    return pcList;  
    }
    
    public static void insertMarketInfo() {
         Marketing_Information__c marketingInfo = new Marketing_Information__c();
        marketingInfo.Family__c = prdList[0].id;
        marketingInfo.Order__c = 1;
        marketingInfo.Type__c = 'About this Product';
        marketingInfo.Sub_Type__c = 'Table of contents';
        marketingInfo.Content__c='This is the text area for testing purpose';
        insert marketingInfo;
        Marketing_Information__c marketingInfo1 = new Marketing_Information__c();
        marketingInfo1.Family__c = prdList[0].id;
        marketingInfo1.Order__c = 1;
        marketingInfo1.Type__c = 'About this Product';
        marketingInfo1.Sub_Type__c = 'Features';
        marketingInfo1.Content__c='This is the text area for testing purpose';
        insert marketingInfo1;
        Marketing_Information__c marketingInfo2 = new Marketing_Information__c();
        marketingInfo2.Family__c = prdList[0].id;
        marketingInfo2.Order__c = 1;
        marketingInfo2.Type__c = 'About this Product';
        marketingInfo2.Sub_Type__c = 'Description';
        marketingInfo2.Content__c='This is the text area for testing purpose';
        insert marketingInfo2;
        Marketing_Information__c marketingInfo3 = new Marketing_Information__c();
        marketingInfo3.Family__c = prdList[0].id;
        marketingInfo3.Order__c = 1;
        marketingInfo3.Type__c = 'About this Product';
        marketingInfo3.Sub_Type__c = 'New to this edition';
        marketingInfo3.Content__c='This is the text area for testing purpose';
        insert marketingInfo3;
        Marketing_Information__c marketingInfo4 = new Marketing_Information__c();
        marketingInfo4.Family__c = prdList[0].id;
        marketingInfo4.Order__c = 1;
        marketingInfo4.Type__c = 'About this Product';
        marketingInfo4.Sub_Type__c = 'About the Author(s)';
        marketingInfo4.Content__c='This is the text area for testing purpose';
        insert marketingInfo4;      
    }
    
    public static void insertpricelist()
    {
      Apttus_Config2__PriceList__c priceListObjec = new Apttus_Config2__PriceList__c();
        priceListObjec.Name = 'Math & Science';
        insert priceListObjec;    
        
       Apttus_Config2__PriceListItem__c apptusObj = new Apttus_Config2__PriceListItem__c();  
      apptusObj.Apttus_Config2__ProductId__c = prdList[0].id;
      apptusObj.Apttus_Config2__Active__c = true;
      apptusObj.Apttus_Config2__ListPrice__c = 11.0;
      apptusObj.Apttus_Config2__PriceListId__c =  priceListObjec.Id; 
      apptusObj.Net_Price__c = 212.00;
      insert apptusObj;

    Apttus_Config2__PriceListItem__c apptusObj1 = new Apttus_Config2__PriceListItem__c();  
    apptusObj1.Apttus_Config2__ProductId__c =pcList[0].Bookstore__c;
    apptusObj1.Apttus_Config2__Active__c = true;
    apptusObj1.Apttus_Config2__ListPrice__c = 11.0;
    apptusObj1.Apttus_Config2__PriceListId__c =  priceListObjec.Id; 
    apptusObj1.Net_Price__c = 212.00;
    insert apptusObj1;  
    
     Apttus_Config2__RelatedProduct__c relatedPrd = new Apttus_Config2__RelatedProduct__c();
        relatedPrd.Apttus_Config2__ProductId__c = prdList[0].id;
        relatedPrd.Apttus_Config2__RelatedProductId__c = prdList[0].id;
        relatedPrd.Student_Resource__c = true;
        relatedPrd.Instructor_Resource__c = true;
        insert relatedPrd;     
    }

    public static Product2 insertRelatedProducts()
    {
      List<Product2> prod_create=new List<Product2>();
        Product2 prod1 = new Product2();

        //Bundle
           prod1.Apttus_Config2__ConfigurationType__c='Bundle'; 
           prod1.Market__c ='US';
           prod1.Line_of_Business__c='Higher Ed';
           prod1.Business_Unit__c   ='US Field Sales';
           prod1.name = 'NA Test Product Family';
           prod1.Author__c = 'Test Author'; 
           prod1.Edition__c = '10';
           prod1.Status__c = 'PUB';
           prod1.Relevance_Value__c = 11;
           prod1.Brand__c = 'MyLab + Note Taking Guide';
           prod_create.add(prod1);
           
        //Student Supplement
           Product2 prod2 = new Product2();
           prod2.Apttus_Config2__ConfigurationType__c='Option'; 
           prod2.Duration__c = 'D10';
           prod2.name = 'NA Territory Product1';
           prod2.Line_of_Business__c = 'Higher Ed';
           prod2.Market__c ='US';
           prod2.Business_Unit__c='US Field Sales';
           prod2.Binding__c = 'Access Code Card'; 
           prod2.Edition__c = '10';
           prod2.Platform__c = 'Plat1';
           prod2.Relevance_Value__c = 10;
           prod2.Brand__c = 'Mastering';
           prod2.Medium2__c= 'Digital';
           prod2.Category2__c='CourseSmart';
           prod2.CurrencyIsoCode = 'USD';   
           prod_create.add(prod2);
         //'Premium Website',
           Product2 prod4 = new Product2();
           prod4.Apttus_Config2__ConfigurationType__c='Option'; 
           prod4.name = 'NA Territory Product2';
           prod4.Duration__c = 'D10';
           prod4.Line_of_Business__c = 'Higher Ed';
           prod4.Market__c ='US';
           prod4.Business_Unit__c='US Field Sales';
           //prod4.Next_Edition__c = prod2.id;
           prod4.Competitor_product__c = True;
           prod4.Binding__c = 'Website'; 
           prod4.Edition__c = '10';
           prod4.Platform__c  = 'Plat1';
           prod4.Relevance_Value__c = 10;
           prod4.Brand__c = 'Mastering';  
           prod4.Medium2__c= 'Digital';
           prod4.Category2__c='CourseSmart';  
           prod4.CurrencyIsoCode = 'USD';                     
           prod_create.add(prod4);     
      
         //'CourseCompass',
           Product2 prod41 = new Product2();
           prod41.Apttus_Config2__ConfigurationType__c='Option'; 
           prod41.name = 'NA Territory Product3';
           prod41.Duration__c = 'D10';
           prod41.Market__c ='US';
           prod41.Line_of_Business__c = 'Higher Ed';           
           prod41.Business_Unit__c='US Field Sales';
           prod41.Binding__c = 'Website'; 
           prod41.Edition__c = '10';
           prod41.Platform__c  = 'Plat1';
           prod41.Relevance_Value__c = 10;
           prod41.Brand__c = 'Mastering'; 
           prod41.Medium2__c= 'Digital';
           prod41.Category2__c='CourseSmart'; 
           prod41.CurrencyIsoCode = 'USD';                       
           prod_create.add(prod41);    
           
           //'Premium Website'
           Product2 prod411 = new Product2();
           prod411.Apttus_Config2__ConfigurationType__c='Option'; 
           prod411.name = 'NA Test Product4';
           prod411.Duration__c = 'D10';
           prod411.Market__c ='US';
           prod411.Business_Unit__c='US Field Sales';
           prod411.Line_of_Business__c = 'Higher Ed';           
           prod411.Binding__c = 'Website'; 
           prod411.Edition__c = '10';
           prod411.Platform__c  = 'Plat1';
           prod411.Relevance_Value__c = 10;
           prod411.Brand__c = 'Mastering';           
           prod_create.add(prod411);            
             
             //'CourseCompass'
           Product2 prod42 = new Product2();
           prod42.Apttus_Config2__ConfigurationType__c='Option'; 
           prod42.name = 'NA Test Product4';
           prod42.Duration__c = 'D100';
           prod42.Market__c ='US';
           prod42.Business_Unit__c='US Field Sales';
           prod42.Line_of_Business__c = 'Higher Ed';
           prod42.Binding__c = 'Website'; 
           prod42.Edition__c = '10';
           prod42.Platform__c  = 'Plat2';
           prod42.Relevance_Value__c = 10;
           prod42.Brand__c = 'MyLab';           
           prod_create.add(prod42);                
                                    
                   
            //Iaworules                   
           Product2 prod3 = new Product2();
           prod3.Apttus_Config2__ConfigurationType__c='Option'; 
           prod3.name = 'NA Test Product3';
           prod3.Market__c ='US';
           prod3.Business_Unit__c='US Field Sales';
           prod3.Line_of_Business__c = 'Higher Ed';           
           prod3.Author__c = 'Test Author'; 
           prod3.Edition__c = '10';
           prod3.Status__c = 'PUB';
           prod3.Relevance_Value__c = 10;
           prod3.Brand__c = 'CourseSmart';
           prod_create.add(prod3);    
  
           
           //eText          
           Product2 prod71 = new Product2();
           prod71.Apttus_Config2__ConfigurationType__c='Option'; 
           prod71.name = 'NA Test Product5';
           prod71.Duration__c = 'D20';
           prod71.Market__c ='US';
           prod71.Business_Unit__c='US Field Sales';
           prod71.Line_of_Business__c = 'Higher Ed';           
           prod71.Category2__c = 'eBook+ upgrade (component)'; 
           prod71.Edition__c = '10';
           prod71.Platform__c= 'eBook+ Upgrade';
           prod71.Relevance_Value__c = 10;
           prod71.Brand__c = 'MyKit';    
           prod71.Accounting_Code__c  = 'R-86';
           prod71.Binding__c = 'Electronic Book';
           prod_create.add(prod71);  

           //Printoffer
           Product2 prod7 = new Product2();
           prod7.Apttus_Config2__ConfigurationType__c='Option'; 
           prod7.name = 'NA Test Product Print offer';
           prod7.Duration__c = 'D20';
           prod7.Market__c ='US';
           prod7.Business_Unit__c='US Field Sales';
           prod7.Line_of_Business__c = 'Higher Ed';           
           prod7.Category2__c = 'Special Item'; 
           prod7.Edition__c = '10';
           prod7.Platform__c= 'Print Offer';
           prod7.Relevance_Value__c = 10;
           prod7.Brand__c = '';    
           prod7.Binding__c = 'Unbound (Saleable)';
           prod_create.add(prod7);   
           

           //PCL
           Product2 prod8 = new Product2();
           prod8.Apttus_Config2__ConfigurationType__c='Option'; 
           prod8.name = 'NA Test Product5';
           prod8.Duration__c = 'D20';
           prod8.Market__c ='US';
           prod8.Business_Unit__c='US Field Sales';
           prod8.Line_of_Business__c = 'Higher Ed';           
           prod8.Author__c = 'Test Author'; 
           prod8.Edition__c = '10';
           prod8.Status__c = 'PUB';
           prod8.Relevance_Value__c = 10;
           prod8.Brand__c = 'Pearson Custom Library (PCL)';           
           prod_create.add(prod8); 
           

           //Remaining           
           Product2 prod5 = new Product2();
           prod5.Apttus_Config2__ConfigurationType__c='Option'; 
           prod5.name = 'NA Test Product5';
           prod5.Duration__c = 'D20';
           prod5.Market__c ='US';
           prod5.Business_Unit__c='US Field Sales';
           prod5.Line_of_Business__c = 'Higher Ed';           
           prod5.Author__c = 'Test Author'; 
           prod5.Edition__c = '10';
           prod5.Relevance_Value__c = 10;
           prod5.Brand__c = 'Pearson eText';           
           prod_create.add(prod5);       
           //Alternate Binding
           Product2 prod6 = new Product2();
           prod6.Apttus_Config2__ConfigurationType__c='Option'; 
           prod6.name = 'NA Test Product5';
           prod6.Duration__c = 'D20';
           prod6.Market__c ='US';
           prod6.Business_Unit__c='US Field Sales';
           prod6.Line_of_Business__c = 'Higher Ed';           
           prod6.Author__c = 'Test Author'; 
           prod6.Edition__c = '10';
           prod6.Medium2__c = 'Print';
           prod6.Relevance_Value__c = 10;
           prod6.Brand__c = null;    
           prod6.Binding__c = 'Cloth';
           prod_create.add(prod6);  
     
                              
           List<String> sasscat = new List<String>{'Bundle','Student Supplement','Premium Website','CourseCompass','Premium Website',
           'CourseCompass','Iaworules','eText','Printoffer','PCL','Remaining','Alternate Binding'}; 
           
           insert prod_create;
           system.debug('Products created:'+prod_create.size());
           
           
        
           List<Apttus_Config2__RelatedProduct__c> aptusObjeclist =  new List<Apttus_Config2__RelatedProduct__c>();
           for(integer i =1; i<prod_create.size();i++){
               Apttus_Config2__RelatedProduct__c aptusObjec = new Apttus_Config2__RelatedProduct__c(); 
               aptusObjec.Apttus_Config2__ProductId__c  =prod_create[0].Id;
               //aptusObjec.Apttus_Config2__ProductId__c  =prod_create[i].Id;
               aptusObjec.Apttus_Config2__RelatedProductId__c = prod_create[i].Id;  
               aptusObjec.Association_Category__c=sasscat[i];
               aptusObjec.psell__c=true;
               aptusObjec.psam__c=true;
               if (aptusObjec.Association_Category__c == 'Previous Edition')
                   aptusObjec.Relation_Package__c=false;
               aptusObjeclist.add(aptusObjec); 
           }           
           insert aptusObjeclist;
           system.debug('Related Product size='+aptusObjeclist.size());
        
           Apttus_Config2__PriceList__c priceListObjec = new Apttus_Config2__PriceList__c();
           priceListObjec.Name = 'US HE All'; 
           insert priceListObjec;         
        
           List<Apttus_Config2__PriceListItem__c> apptusObjpilist = new List<Apttus_Config2__PriceListItem__c>();
           for(integer i =0; i<prod_create.size();i++){
               Apttus_Config2__PriceListItem__c apptusObj = new Apttus_Config2__PriceListItem__c();   
               apptusObj.Apttus_Config2__ProductId__c = prod_create[i].id;   
               if(i==3)
                   apptusObj.Net_Price__c= 200.00;
               else
                   apptusObj.Net_Price__c= 100.00;
               apptusObj.Apttus_Config2__Active__c = true;  
               apptusObj.Apttus_Config2__ListPrice__c = 11.0;
               apptusObj.Apttus_Config2__PriceListId__c =  priceListObjec.Id;    
               apptusObjpilist.add(apptusObj);
           }
           insert apptusObjpilist;
           system.debug('Pricelist item created:'+apptusObjpilist.size());
           //List<Product2> plist=[select id,(select id from Apttus_Config2__RelatedProducts__r) from product2 where Market__c='US' and Apttus_Config2__ConfigurationType__c ='Bundle' and
                            // Line_of_Business__c = 'Higher Ed' and Business_Unit__c='US Field Sales' and Relevance_value__c>=10 and relevance_value__c<=100 and id=:prod_create[0].Id];
           //system.assert(plist.size()>0);
        
           return prod_create[0];
    }
    
    public static List<Pearson_Choice__c> returnPearsonChoice()
    {
        List<Pearson_Choice__c> listWithPearsonChoice = new List<Pearson_Choice__c>();
        Pearson_Choice__c newPearsonChoice;
        for(Integer i=0;i<200;i++)
        {
            newPearsonChoice = new Pearson_Choice__c();
            newPearsonChoice.Name = 'PearsonChoice'+i;
            listWithPearsonChoice.add(newPearsonChoice);
        }
        return listWithPearsonChoice;    
    }
    
    public static order returnorder(){
            account acc = new Account(Name='Test Account', Phone='+9100000', ShippingCountry = 'India', ShippingCity = 'Bangalore', ShippingStreet = 'BNG', ShippingPostalCode = '560037');
            insert acc;
            Opportunity opp = new opportunity ( Name = 'OpporName',AccountId = acc.Id,CloseDate = System.TODAY() + 30,StageName = 'OpporStageName');
            insert opp;
            Contact con = new Contact(FirstName='TestContactFirstname', LastName='TestContactLastname',AccountId=opp.accountid ,Salutation='MR.', Email='sampleemailaddress' + '@email.com',Phone='111222333');  
            insert con;
            OpportunityContactRole oc = new OpportunityContactRole( opportunityId =  opp.Id,contactId = con.id ,Role =  'Business User');
            insert oc;
            product2  prod = new product2(name='test');
            insert prod;
            Id pricebookId = Test.getStandardPricebookId();
            PricebookEntry standardPrice = new PricebookEntry( Pricebook2Id = pricebookId, Product2Id = prod.Id,UnitPrice = 10000, IsActive = true);
            insert standardPrice;
            Pricebook2 customPB = new Pricebook2(Name='Standard Price Book', isActive=true); 
            insert customPB;
            PricebookEntry pbe = new PricebookEntry(Pricebook2Id = customPB.id, Product2Id = prod.Id, UnitPrice = 1);
            insert pbe;
            order sampleorder = new order(Accountid=opp.accountid,ShipToContactid=con.id,Opportunityid=opp.id,EffectiveDate=system.today(),Status='Cancelled',Pricebook2Id=customPB.id,CurrencyIsoCode = userinfo.getDefaultCurrency(),type=System.Label.Order_Type);
            insert sampleorder;
            orderitem item = new orderitem(orderid=sampleorder.id,Shipped_Product__c = prod.id,Quantity = 1,pricebookentryid= pbe.id, unitprice=pbe.unitprice,Shipping_Method__c= 'Ground' );
            insert item;
            order sampleorder1 = new order(Accountid=opp.accountid,ShipToContactid=con.id,Opportunityid=opp.id,EffectiveDate=system.today(),Status='New',Pricebook2Id=customPB.id,CurrencyIsoCode = userinfo.getDefaultCurrency(),type=System.Label.Order_Type);
            insert sampleorder1;
            orderitem item1 = new orderitem(orderid=sampleorder1.id,Shipped_Product__c = prod.id,Quantity = 1,pricebookentryid= pbe.id, unitprice=pbe.unitprice,Shipping_Method__c= 'Ground' );
            insert item1;
        
           return sampleorder1;
    }
    
    public static order returnmodifiedorder(){
        account acc = new Account(Name='Test Account', Phone='+9100000', ShippingCountry = 'India', ShippingCity = 'Bangalore', ShippingStreet = 'BNG', ShippingPostalCode = '560037');
            insert acc;
            RecordType rt = [SELECT Id, Name FROM RecordType WHERE SobjectType = 'Contact' AND Name ='Global Contact' limit 1 ]; 
            Contact con = new Contact(FirstName='TestContactFirstname', LastName='TestContactLastname',AccountId=acc.Id ,Salutation='MR.', Email='sampleemailaddress' + '@email.com',Phone='111222333',mailingcity='city',mailingstreet='street',mailingstate='Kerala',mailingcountry='India',Mailingpostalcode='12345',othercity='city',otherstreet='street',otherstate='Kerala',othercountry='India',otherpostalcode='12345',recordtypeid=rt.id);  
            insert con;
            Opportunity opp = new opportunity ( Name = 'OpporName',AccountId = acc.Id,CloseDate = System.TODAY() + 30,StageName = 'OpporStageName');
            insert opp;
            OpportunityContactRole oc = new OpportunityContactRole( opportunityId =  opp.Id,contactId = con.Id,Role =  'Business User');
            insert oc;
            product2  prod = new product2(name='test');
            insert prod;
            Id pricebookId = Test.getStandardPricebookId();
            PricebookEntry standardPrice = new PricebookEntry( Pricebook2Id = pricebookId, Product2Id = prod.Id,UnitPrice = 10000, IsActive = true);
            insert standardPrice;
            Pricebook2 customPB = new Pricebook2(Name='Standard Price Book', isActive=true); 
            insert customPB;
            PricebookEntry pbe = new PricebookEntry(Pricebook2Id = customPB.id, Product2Id = prod.Id, UnitPrice = 1);
            insert pbe;
            order sampleorder = new order(Accountid=acc.id,ShipToContactid=con.id,Opportunityid=opp.id,EffectiveDate=system.today(),Status='Cancelled',Pricebook2Id=customPB.id,CurrencyIsoCode = userinfo.getDefaultCurrency(),type=System.Label.Order_Type);
            insert sampleorder;
            orderitem item = new orderitem(orderid=sampleorder.id,Shipped_Product__c = prod.id,Quantity = 1,pricebookentryid= pbe.id, unitprice=pbe.unitprice,Shipping_Method__c= 'Ground', Status__c = 'Cancelled');
            insert item;
            order sampleorder1 = new order(Accountid=acc.id,ShipToContactid=con.id,Opportunityid=opp.id,EffectiveDate=system.today(),Status='New',Pricebook2Id=customPB.id,CurrencyIsoCode = userinfo.getDefaultCurrency(),type=System.Label.Order_Type);
            insert sampleorder1;
            orderitem item1 = new orderitem(orderid=sampleorder1.id,Shipped_Product__c = prod.id,Quantity = 1,pricebookentryid= pbe.id, unitprice=pbe.unitprice,Shipping_Method__c= 'Ground' );
            insert item1;
        
           return sampleorder1;
    }
    
     //public static Territory2 createTerritory(String devName, Territory2Model t2m){
     public static Territory2 createTerritory(){
      List<sObject> listTerritoryType = Test.loadData(Territory2Type.sObjectType, 'TerritoryType');
      Territory2Type tt=(Territory2Type) listTerritoryType[0];
      //Territory2Type tt = [select Id from Territory2Type limit 1];     
      Territory2Model t2m = new Territory2Model(Name='TestClassTerritoryModel',developername='TestClassTerritoryModel');    //ActivatedDate=System.Today()
      insert t2m;
         system.debug('Territory2TypeId //'+tt.Id);
      Territory2 tr0 = new Territory2(Name ='TestTerritory0',Territory2TypeId = tt.Id, DeveloperName = 'TestClassParentTerritory', Territory2ModelId = t2m.Id);
      system.debug('tro id'+tr0.Id);
      return tr0;
    }
    
    //code for creating course for territory
    public static list<UniversityCourse__c> insertCourse()
    {
      List<UniversityCourse__c> course_create=new List<UniversityCourse__c>();
        UniversityCourse__c course = new UniversityCourse__c();
          course.Name = 'TerritoryCourseNameandcode';
          course.Catalog_Code__c = 'Territorycoursecode';
          course.Course_Name__c = 'Territorycoursename';
          course.CurrencyIsoCode = 'USD';
          course_create.add(course);
          
      UniversityCourse__c course1 = new UniversityCourse__c();
          course1.Name = 'TerritoryCourseNameandcode1';
          course1.Catalog_Code__c = 'Territorycoursecode1';
          course1.Course_Name__c = 'Territorycoursename1';
          course1.CurrencyIsoCode = 'USD';
          course_create.add(course1);
      
      UniversityCourse__c course2 = new UniversityCourse__c();
          course2.Name = 'TerritoryCourseNameandcode2';
          course2.Catalog_Code__c = 'Territorycoursecode2';
          course2.Course_Name__c = 'Territorycoursename2';
          course2.CurrencyIsoCode = 'USD';
          course_create.add(course2); 
       
       return course_create; 
     }
     
    //code for creating pearson_course_equivalent for territory
    public static list<Pearson_Course_Equivalent__c> insertCourseEqv()
    {
      List<Pearson_Course_Equivalent__c> courseEqv_create=new List<Pearson_Course_Equivalent__c>();
      Pearson_Course_Equivalent__c pce = new Pearson_Course_Equivalent__c();
      pce.Active__c = true;  
      pce.Primary__c = true;
      courseEqv_create.add(pce); 
      
      Pearson_Course_Equivalent__c pce1 = new Pearson_Course_Equivalent__c();
      pce1.Active__c = true;   
      pce1.Primary__c = true;
      courseEqv_create.add(pce1); 
      
      Pearson_Course_Equivalent__c pce2 = new Pearson_Course_Equivalent__c();
      pce2.Active__c = true;   
      pce2.Primary__c = true;
      courseEqv_create.add(pce2);
      
      return courseEqv_create; 
      }
      
    /*public static Apttus_Config2__ClassificationName__c insertClassName(){
        Apttus_Config2__ClassificationName__c classname = new Apttus_Config2__ClassificationName__c();
        classname.Apttus_Config2__HierarchyLabel__c = 'TestClassifcation';
        return classname; 
        
    }*/
  }