/*************************************************************
@Author     : Accenture IDC
@Description: Controller to 'sendEmailToOpportunityContactWizard' page - sends email to contact(s) that has been associated to opportunity
@Date       : 19/03/2015
**************************************************************/
public class sendEmailToOpportunityContact{
//public List<Id> listWithOpptyContactId;
public List<innerWrapperClass> listWithContactValues{get;set;}
public List<Contact> selectedContacts;
public Id opportunityIdFromURL;
public String primaryContact{get;set;}
public Id primaryContactId{get;set;}
public List<OpportunityContactRole> primaryContactList;
public String subject{get;set;}
public String emailBody{get;set;}
public blob documentbody{get;set;}
public String documentname{get;set;}
public boolean notifySender{get;set;}
public String additionalEmailAddress{get;set;}
public Map<Id,String> mapWithContactRoleAndID{get;set;}
//Constructor
public sendEmailToOpportunityContact()
{
    mapWithContactRoleAndID = new Map<Id,String>();
    opportunityIdFromURL = ApexPages.currentPage().getParameters().get('opportunityId');
    //listWithOpptyContactId = new List<Id>();
    listWithContactValues = new List<innerWrapperClass>();  
    primaryContactList = new List<OpportunityContactRole>();
    additionalEmailAddress = UserInfo.getUserEmail()+';'+' ';    
    retrieveContactDetails();  
}

//Method to retrieve the contact details from opportunity
public void retrieveContactDetails()
{
    for(OpportunityContactRole contId : [select ContactId,Role from OpportunityContactRole where OpportunityId =: opportunityIdFromURL AND IsDeleted = False limit 1000])
    {    
        //listWithOpptyContactId.add(contId.ContactId);
        if(contId.Role != null)
            mapWithContactRoleAndID.put(contId.ContactId,contId.Role);
        else
            mapWithContactRoleAndID.put(contId.ContactId,'No Role Identified');
    }    
    if(!(mapWithContactRoleAndID.keyset()).isEmpty() && (mapWithContactRoleAndID.keyset()).size()>0)
    {    
        for(Contact conVal :  getContacts(mapWithContactRoleAndID.keyset()))
        {
            listWithContactValues.add(new innerWrapperClass(conVal));
        }   
    } 
    
    //get primary contact
    primaryContactList = [select ContactId from OpportunityContactRole where OpportunityId =: opportunityIdFromURL AND IsDeleted = False AND IsPrimary=true];
    if(!primaryContactList.isEmpty() && primaryContactList.size()>0) 
     {   
         List<Contact> listWithPrimaryContact = new List<Contact>();
         listWithPrimaryContact = getPrimaryContact(primaryContactList[0].ContactId);
         primaryContact = listWithPrimaryContact[0].Email; 
     }  
     if(listWithContactValues.isEmpty())
    {    
      ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Info,'No Contacts are currently related via the Opportunity Contact Roles related list on this Opportunity. Please relate some contacts and try emailing contacts again');
      ApexPages.addMessage(myMsg); 
    }  
}

//get bulk contact utility
public List<Contact> getContacts(Set<Id> contactId)
{
 List<Contact> listWithContact = new List<Contact>();
 listWithContact = [select Id,Name,Email,MailingCity,MailingCountry,MailingState,MailingStreet,MailingPostalCode from Contact where Id IN : contactId];
 return listWithContact;
}

//get single contact utility
public List<Contact> getPrimaryContact(Id contactId)
{
 List<Contact> listWithContact = new List<Contact>();
 listWithContact = [select Id,Name,Email,MailingCity,MailingCountry,MailingState,MailingStreet,MailingPostalCode from Contact where Id = : contactId];
 return listWithContact;
}


//Return list of contact
public List<innerWrapperClass> getContactValues()
{
    if(listWithContactValues.isEmpty())
    {    
      ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Info,'No Contacts are currently related via the Opportunity Contact Roles related list on this Opportunity. Please relate some contacts and try emailing contacts again.');
      ApexPages.addMessage(myMsg); 
    }   
    return listWithContactValues;
}

//Add the selected contacts to a list and return to next page
public pageReference addContactToList()
{
 selectedContacts = new List<Contact>();    
 pageReference nextPage = page.sendEmailToOpportunityContactWizardPg2;
 for(innerWrapperClass cCon: getContactValues()) 
 {
   if(cCon.selectBox == true) 
   {
       selectedContacts.add(cCon.contactList);
       
   }
 }
 if(selectedContacts != null && !selectedContacts.isEmpty())
 { 
  for(Contact contEmail: selectedContacts)    
  {
     if(contEmail.Email != null)
     additionalEmailAddress=additionalEmailAddress+contEmail.Email+';'+' ';
  }    
 }        
 nextPage.setRedirect(false);
 return nextPage;   
}

//Add the selected contacts to a list and return to next page
public pageReference addContactToListRM()
{
 selectedContacts = new List<Contact>(); 
    
 for(innerWrapperClass cCon: getContactValues()) 
 {   
   if(cCon.selectBox == true && cCon.contactList.Id != primaryContactId )
   {
     selectedContacts.add(cCon.contactList);
   }   
 }
 
 String urlParameters = '';
 if(primaryContactId != null)
 {    
   urlParameters = '?p2_lkid=' + primaryContactId;  
 } 
 else
 {
   urlParameters = '?p2_lkid=';
 }
 
 if(selectedContacts != null && !selectedContacts.isEmpty())
 {
   urlParameters += '&p24=';
   for(Contact cont: selectedContacts)    
   {
     if(cont.Email != null)
     {
       urlParameters += cont.Email + '; ';  
     }
   } 
 }
 
 if(opportunityIdFromURL != null)
 {
   urlParameters += '&p3_lkid=' + opportunityIdFromURL;
 }
 
 urlParameters += '&retURL=/' + opportunityIdFromURL;
 PageReference nextPage = new PageReference('/_ui/core/email/author/EmailAuthor'+urlParameters);
     
 nextPage.setRedirect(false);
 return nextPage;   
}

//Set email fields in page
public List<Contact> getselectedContacts()
{
    return selectedContacts;
}

//Send email 
public void sendEmail()
{
    Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage(); 
    List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();
    Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
    List<String> toAddress = new List<String>();
    try
    {    
    if(documentbody != null && documentname != null)
    {  
     efa.setFileName(documentname);
     efa.setBody(documentbody);
     fileAttachments.add(efa);     
    }     
        
    if(!selectedContacts.isEmpty() && selectedContacts.size()>0 || primaryContact!=null)
    { 
     if(primaryContact != null)
     toAddress.add(primaryContact);    
     for(Contact conEmail : selectedContacts)
     {
        if(conEmail.Email != null)
        toAddress.add(conEmail.Email);
     }     
       //Setting the values
        if(fileAttachments!=null && !fileAttachments.isEmpty())
         {       
         email.setFileAttachments(fileAttachments);
         }        
         email.setToAddresses(toAddress);
         email.setPlainTextBody(emailBody); 
         email.setSubject(subject);       
         if(toAddress!=null)
         {         
         Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
         ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Info,'Email Sent Successfully.');
         ApexPages.addMessage(myMsg);
         }         
     
    } 
    if(notifySender == true)
    {
       User loggedInUserEmail = new User();
        if(UserInfo.getUserId() != null)
        {   
           Messaging.SingleEmailMessage emailToSender = new Messaging.SingleEmailMessage(); 
           List<String> toAddressSender = new List<String>();           
           loggedInUserEmail = [select Id,Email from User where Id =: UserInfo.getUserId()];
           if(loggedInUserEmail.Email != null)
           {
            toAddressSender.add(loggedInUserEmail.Email);            
            emailToSender.setToAddresses(toAddressSender);
            emailToSender.setPlainTextBody('Email has been sent successfully to the targeted person.'); 
            emailToSender.setSubject('Email Sent'); 
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {emailToSender});            
           }           
        }
    } 
  }catch(Exception e)
   {
     ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Error occurred.Please contact your administrator.');
     ApexPages.addMessage(myMsg);
   }  
}

//Redirect to opportunity
public pageReference cancel()
{
    pageReference opptyPage = new pageReference('/'+opportunityIdFromURL);
    opptyPage.setRedirect(true);   
    return opptyPage;  
}

//Wrapper class to allow user to select multiple contact(s)
public class innerWrapperClass{
public boolean selectBox{get;set;}
public boolean primaryContact{get;set;}
public Contact contactList{get;set;} 
public boolean isPrimary{get;set;} 


        
public innerWrapperClass(Contact contactRec)
{
   isPrimary = false;
   contactList = contactRec;
   selectBox = false; 
   primaryContact = false;  
}
}
}