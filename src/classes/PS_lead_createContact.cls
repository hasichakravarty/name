/* ----------------------------------------------------------------------------------------------------------------------------------------------------------   
Name:            PS_Lead_RecordTaggingCtrlr.cls    
Description:     On After_update/ of Lead record    
Date             Version         Author                             Summary of Changes    
-----------      ----------      -----------------    ---------------------------------------------------------------------------------------------------  
04/2015         1.0                Rahul Garje                       Initial Release 
------------------------------------------------------------------------------------------------------------------------------------------------------------ */
public without sharing class PS_lead_createContact {
  //private static boolean pasrun = false;

  public static Set<Id> processedLead = new Set<Id>(); //this variable is to garantee that this code is only execute once

  public static void createAccountContact(List<Lead> input, Map<id, lead> leadMap){
    
    List<Lead> CreateAccountContactList = new List<Lead>();

    for(Lead p : input)
    {
    
      if(!processedLead.contains(p.Id))
      {
        CreateAccountContactList.add(p);
      }
    }

    if(CreateAccountContactList.isEmpty()) 
    {

      system.debug(' --> ALL ITEMS WHERE PROCESSED');
      return;
    }
   

    system.debug(' --> Start... PS_lead_createContact Class');
    
  
    List<ID> leadID = new List<ID>();  // List of Leads
    List<Contact> contactList = new List<Contact>(); //List of contacts
    List<Contact> defaultContactList = new List<Contact>(); //List of Contacts
    List<AccountContact__c> acc_cont = new List<AccountContact__c>(); //List of AccountContacs
    List<AccountContact__c> AcctConrole = new List<AccountContact__c>(); //List of Account Contacts
    List<Id> conId = new List<Id>();  //List of Ids
    List<Contact> conlist = new List<Contact>(); //List of contacts
    List<Account> Acclist = new List<Account>(); //List of Accounts
    List<Opportunity> OppList = new List<Opportunity>(); //List of Opportunities
    List<Id> oppId = new List<Id>();  //List of Ids
    String SponsorType; // sponsor type
    String strRoleDetail;
    
    //code added to get the Record type from account ids starts
        
    Map<String, Schema.SObjectType> sObjectMap = Schema.getGlobalDescribe() ;
    
    //get the recordtype for the opportunity that will be assigned to the created opportunity.
    Schema.SObjectType oppty = sObjectMap.get('Opportunity') ; // getting Sobject Type
    Schema.DescribeSObjectResult resSchema = oppty.getDescribe() ;
    Map<String,Schema.RecordTypeInfo> recordTypeInfo = resSchema.getRecordTypeInfosByName(); //getting all Recordtype for the Sobject
    Id rtId = recordTypeInfo.get('D2L').getRecordTypeId();//particular RecordId by  Name
    System.debug('--> Opportunity recordtype id ---->'+rtId);
        
    //get the recordtype for account Learnet
    Schema.SObjectType Accnt = sObjectMap.get('Account') ; // getting Sobject Type
    Schema.DescribeSObjectResult accntresSchema = Accnt.getDescribe() ;
    Map<String,Schema.RecordTypeInfo> accntrecordTypeInfo = accntresSchema.getRecordTypeInfosByName(); //getting all Recordtype for the Sobject
    Id actrtId = accntrecordTypeInfo.get('Learner').getRecordTypeId();//particular RecordId by  Name 
    Id actrtId1 = accntrecordTypeInfo.get('Organisation').getRecordTypeId();//particular RecordId by  Name 
      system.debug('Organisation actrtId1 --->'+actrtId1); 
      

    //get the recordtype for the Lead that will be assigned to the created opportunity.
    Schema.SObjectType leadrt = sObjectMap.get('Lead') ; // getting Sobject Type
    Schema.DescribeSObjectResult ldresSchema = leadrt.getDescribe() ;
    Map<String,Schema.RecordTypeInfo> ldrecordTypeInfo = ldresSchema.getRecordTypeInfosByName(); //getting all Recordtype for the Sobject
    Id LeadrtId = ldrecordTypeInfo.get('B2B').getRecordTypeId();//particular RecordId by  Name
    System.debug('--> Lead B2B recordtype id ---->'+LeadrtId);


    // 08/05/2015 - Smark
    // Added requirement 01365
    // Get any existing sponsor contacts to avoid creating duplicates
    
    List<String> emailList = new List<String>();
    
    for(Lead l : CreateAccountContactList){

        if(l.isConverted && (leadMap.get(l.id).isConverted != true)) { 
            
            if(leadMap.get(l.id).Sponsor_Type__c != 'Self') {
                
                if (l.Sponsor_Email__c != NULL) {
                    system.debug('ADDED EMAIL TO LIST ' + l.Sponsor_Email__c);
                    emailList.add(l.Sponsor_Email__c);
                }
            }
        }
    } // End for
    
    Map<String, Contact> existingContactMap = new Map<String, Contact>(); // Map holding the contact details indexed by email address
    
    // Do not query for existing contacts if none of the leads have sponsor/sponsor email
    if (!emailList.isEmpty()) 
    {
        List<Contact> existingContacts = [SELECT Id, Name, Email, AccountId FROM Contact WHERE Email IN :emailList];
        
        for (Contact c : existingContacts) {
            system.debug('FOUND CONTACT ' + c.Name);
            
            existingContactMap.put(c.Email, c);
        } // End for    
    } // End email list check
    //*-------------------------------------------------------------------
    // Code added to get the Record type from account ids ends
    // if(Trigger.isAfter){
     Contact contact2;
     // This map is used to figure out the contact account Id. Contact ID cannot be used as existing contacts can be re-used
     Map<String, String> contactAccountIDMap = new Map<String, String>(); 
     
     for(Lead l:CreateAccountContactList){
     
        
      if(l.isConverted && (leadMap.get(l.id).isConverted != true)) 
      { 
          

       if(leadMap.get(l.id).Sponsor_Type__c != 'Self'){
          contact2 = new Contact();  
          
          System.Debug('@@@ when sponser!= self'+l+'-----'+l.Sponsor_Salutation__c);
          contact2.Salutation = l.Sponsor_Salutation__c;  
          contact2.FirstName = l.Sponsor_Sponsor__c;
          contact2.LastName = l.Sponsor_Name__c;
          contact2.AccountId = l.ConvertedAccountId;    
          contact2.MobilePhone = String.valueOf(l.Sponsor_Mobile__c);          
          contact2.Home_Phone__c = String.valueOf(l.Sponsor_Home_Phone__c);
          contact2.Phone = String.valueOf(l.Sponsor_Phone__c);          
          contact2.Email = l.Sponsor_Email__c;    
          contact2.Role__c = 'Sponsor';
          contact2.Role_Detail__c = l.Sponsor_Type__c;
          
          contact2.MailingCity = l.Sponsor_Address_City__c;          
          contact2.MailingStreet = l.Sponsor_Address_Street__c;          
          contact2.MailingState = l.Sponsor_Address_State_Province__c;          
          contact2.MailingCountry = l.Sponsor_Address_Country__c ;         
          contact2.MailingPostalcode = l.Sponsor_Address_ZIP_Postal_Code__c;
          contact2.isleadConvertedContact__c = true;
          contact2.Preferred_Method_of_Communication__c = l.Sponsor_Preferred_Method_of_Contact__c ;
          //contact2.recordTypeId = conRecordTypeIds[0].RecordType.id; 
          
          // If the contact exists already, then update it instead
          if (l.Sponsor_Email__c != NULL) {
              
              if (existingContactMap.containsKey(l.Sponsor_Email__c))
                  contact2 = existingContactMap.get(l.Sponsor_Email__c);

                  contactAccountIDMap.put(contact2.Id, l.ConvertedAccountId);
                  
                  system.debug('CONTACT RESET ' + contact2.Id);
          } // End email check
          
          contactList.add(contact2); 

        } 
        /* else {
          
          createTask ct = new CreateTask();
          ct.createTaskOnLead(l.ConvertedAccountId);         
        } */
         
        // To copy studentId from Lead to converted Account
        if(l.ConvertedAccountId != null){
            
            SponsorType = 'Sponsor';
            
            strRoleDetail = l.Sponsor_Type__c;
            
            if (l.Sponsor_Type__c == 'Self') {
                SponsorType = 'Learner'; 
                strRoleDetail = '';
            }
            
            Account acc = new Account();
            acc.Id = l.ConvertedAccountId;
            acc.Pearson_Account_Number__c = leadMap.get(l.id).Pearson_ID_Number__c;
            if(l.recordtypeid == LeadrtId){
                acc.recordTypeId = actrtId1;
                system.debug('Entered'+acc.recordTypeId );               
            }
            else {
               acc.recordTypeId = actrtId;
                system.debug('Entered'+acc.recordTypeId );                              
            }
            
              //added [Stacey Walter 15062015]  to update billing address on Account if Sponsor is created
              if(leadMap.get(l.id).Sponsor_Type__c != 'Self' && leadMap.get(l.id).Sponsor_Address_Street__c!=null && leadMap.get(l.id).Sponsor_Address_ZIP_Postal_Code__c!=null && leadMap.get(l.id).Sponsor_Address_Country__c!=null){
                acc.BillingCity=l.Sponsor_Address_City__c;
                acc.BillingCountry=l.Sponsor_Address_Country__c;
                acc.BillingPostalCode=l.Sponsor_Address_ZIP_Postal_Code__c;
                acc.BillingStreet=l.Sponsor_Address_Street__c;
                acc.BillingState=l.Sponsor_Address_State_Province__c;
              }
            //Abhinav Srivastava -18/06/2015
            //Adding the functionality of mapping billing adreess of account to shipping address of account            
               if(leadMap.get(l.id).City!=null && leadMap.get(l.id).Street!=null && leadMap.get(l.id).PostalCode!=null && leadMap.get(l.id).Country!=null){
                acc.ShippingCity=l.City;
                acc.ShippingCountry =l.Country;
                acc.ShippingPostalCode=l.PostalCode;
                acc.ShippingStreet=l.Street;
                acc.ShippingState =l.State;
                acc.Email__c = l.Email;                
              }
                         
            AccList.add(Acc);
        }

        if(l.ConvertedContactId != null&& l.RecordTypeId!=LeadrtId){              
            
            AccountContact__c acc = new AccountContact__c();
            acc.Contact__c = l.ConvertedContactId;
            acc.Account__c = l.ConvertedAccountId; 
            acc.AccountRole__c = 'Learner';
            acc.Role_Detail__c = '';
            acc.Sync_In_Progress__c = TRUE;
            acc.Financially_Responsible__c = (leadMap.get(l.id).Sponsor_Type__c == 'Self')?TRUE:FALSE;
            acc.Primary__c = true;                 
            AcctConrole.add(Acc);
            
            
        }

        if(l.recordtypeId==LeadrtId){
          AccountContact__c acc = new AccountContact__c();
            acc.Contact__c = l.ConvertedContactId;
            acc.Account__c = l.ConvertedAccountId; 
            acc.AccountRole__c = '';
            acc.Role_Detail__c = '';
            acc.Sync_In_Progress__c = TRUE;
            acc.Financially_Responsible__c = (leadMap.get(l.id).Sponsor_Type__c == 'Self')?TRUE:FALSE;
            acc.Primary__c = true;                 
            AcctConrole.add(Acc);
        }
            
               
        //code written for passing D2L record type on Opportunity while lead conversion starts
        if(l.ConvertedOpportunityId != null){
            Opportunity opp = new Opportunity();
            opp.Id = l.ConvertedOpportunityId;
            oppId.add(opp.Id);       
            opp.recordTypeId = rtId;
            opp.StageName = System.Label.D2L_Opportunity_StageName_Value; //'Needs Analysis';
            opp.Type = System.Label.D2L_Opportunity_Type_Value; 
            Opplist.add(opp);
            system.debug('Opplist is'+Opplist); 
            system.debug('opp is'+opp); 
            
        }           
         //code written for passing D2L record type on Opportunity while lead conversion ends 
        system.debug('--> my opportunity id'+l.ConvertedOpportunityId+l.ConvertedAccountId+l.ConvertedContactId);        
       //code added to get map the passport number and identification number on lead conversion starts
   
        if(l.ConvertedContactId!=null){
          
           Contact defaultcontact = new Contact(); 
           defaultcontact.Id = l.ConvertedContactId; 
           defaultcontact.Passport_Number__c = l.Passport_Number__c;
           defaultcontact.National_Identity_Number__c = l.Identification_Number__c;
           defaultcontact.OtherPhone = l.Other_Phone__c;
           defaultContactList.add(defaultcontact);
        }  
        //code added to get map the passport number and identification number on lead conversion ends 
       }//if close

       processedLead.add(l.Id);

      }// for close 
    //}//is after close
    
     if(contactList != null){                    //&& Utility.stopRecursion != True
        System.debug(contactList+'---RRRR----');
        
        Database.UpsertResult[] lsr = Database.Upsert(contactList, false);
        
        for(Integer i=0;i<lsr.size();i++){ 
          if(lsr.get(i).isSuccess()){
              system.debug('CONTACT SUCCESS ' + lsr.get(i).getid());
              ConId.add(lsr.get(i).getid());
           }
         }
        
        System.debug(lsr);                  
      }  
    
     if(ConId.size()>0){
       conlist = [SELECT Id, Name, AccountId FROM Contact WHERE Id IN :ConId];
       if(conlist.size() > 0){
          for(contact c:conlist){
            AccountContact__c acc = new AccountContact__c();
            acc.Contact__c = c.Id;
            acc.Account__c = c.AccountId; // For new contacts
            if (contactAccountIDMap.containsKey(c.Id)) 
                acc.Account__c = contactAccountIDMap.get(c.Id); // For existing contacts
            
            system.debug('CONTACT NAME ' + c.Name);
            system.debug('@@@SponsorType'+SponsorType);
            acc.AccountRole__c = SponsorType;
            acc.Role_Detail__c = strRoleDetail;
            acc.Sync_In_Progress__c = TRUE; // Flag the records so that the validation does not fire (primary contact and financial responsible person are inserted serially)
            acc.Financially_Responsible__c = True;
            AcctConrole.add(Acc);
          }
       }
     } 
       
    if(AcctConrole!=null && AcctConrole.size()>0)
    {
     
        System.debug('-->Adding Account Contacts');
      
        Insert AcctConrole;      
       
    }
      
    if(AccList.size()>0)
    {
      System.debug('-->Updating Accounts');
      Update AccList;
    }
     
     //Code for update Opportunity record type starts 
    if(OppList.size() > 0 && OppList!= null)
    {
       System.debug('-->Updating Opportunities');
       Update OppList;

       //Davi Borges: 12 May 2015 
       List<Opportunity> opps =  [SELECT Id, Type, International_Student_Status__c FROM Opportunity WHERE Id IN: oppId];
       System.debug('-->Adding opportunity contacts');
       PS_opportunity_MapAccountcontactRole.MapAccountcontactRole(opps);
       System.debug('-->Adding opportunity taks');
       PS_CreateAssetbasedStudentRegistration.createTask(opps);
       sendEmailToOpptyContact.OppOutboundNotification(opps,null,false);
    }      
     
     //Code for update Opportunity record type ends 
     if(defaultContactList.size()>0){
      System.debug('-->Updating Learner Contacts');
       Update defaultContactList;  
     } 

   }//method close   
} //class close