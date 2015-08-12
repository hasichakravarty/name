/*************************************************************
@Author     : Accenture IDC
@Description: Controller to 'SendEmailInstructor' page - sends email to contact(s) that has been associated to opportunity
@Date       : 19/03/2015
**************************************************************/
public class SendEmailInstructor{

public Map<Id,Pearson_Choice__c> mapWithPearsonChoice{get;set;}
public List<Pearson_Choice__c> listWithPearsonChoices{get;set;}
public Id productFamilyIdFromURL{get;set;}
public List<InnerWrapperClass> listWithContactValues{get;set;}
public List<Contact> selectedContacts{get;set;}
public Id opportunityIdFromURL;
public Id productIdFromURL ;
public Id primaryContactId{get;set;}
public String primaryContact{get;set;}
public List<OpportunityContactRole> primaryContactList{get;set;}
public String subject{get;set;}
public String emailBody{get;set;}
public String emailBody1{get;set;}
public blob documentbody{get;set;}
public String documentname{get;set;}
public boolean notifySender{get;set;}
public String additionalEmailAddress{get;set;}
public Map<Id,String> mapWithContactRoleAndID{get;set;}
private String author='',title='',edition='',name='',iSBN='',pcStr='',selectedPrice='',iRCLink='';
public List<Apttus_Config2__PriceListItem__c>  suggestedPrice{get; set;}
public Map<Id,Apttus_Config2__PriceListItem__c> suggestedPricemap{get; set;}

public Decimal suggestedRetailprice {get;set;} 
public  boolean mailsent {get;set;}
Set<Id> prodIdset=new Set<Id>();
public Map<String ,String> mapStr=null;
//Wrapper class to allow user to select multiple contact(s)
public class InnerWrapperClass{
    public boolean selectBox{get;set;}
    public Contact contactList{get;set;} 
    public boolean primaryContact{get;set;}
    public InnerWrapperClass(Contact contactRec)//constructor for warapper class
    {
        contactList =  contactRec;
        selectBox = false;   
    }
}

//Constructor
public SendEmailInstructor()
{
    mapWithContactRoleAndID = new Map<Id,String>();
    opportunityIdFromURL = ApexPages.currentPage().getParameters().get('opportunityId');
    productIdFromURL = ApexPages.currentPage().getParameters().get('productId');
    pcStr =ApexPages.currentPage().getParameters().get('pc');
    system.debug('pcStr----->'+pcStr);
    selectedPrice =ApexPages.currentPage().getParameters().get('col');
    List<Id> ids = pcStr.split(',');
    List<String> priceList =  selectedPrice.split(',');
    //System.debug('ids---'+ids);
    listWithContactValues = new List<InnerWrapperClass>();  
    primaryContactList = new List<OpportunityContactRole>();
    additionalEmailAddress = UserInfo.getUserEmail()+';'+' ';    
    retrieveContactDetails(); //call to pull opportunity contacts
    retrieveProductDetails(); //call to pull product details
    //system.debug('////constructor///. ....productIdFromURL'+productIdFromURL);
    //system.debug('////constructor///. ....opportunityIdFromURL'+opportunityIdFromURL);
    //List<Pearson_Choice__c> listWithPearsonChoices1 = getPearsonChoices(ids); 
    getPearsonChoices(ids);
    subject  = System.Label.Email_Subject+' '+name+'"';
    Messaging.SingleEmailMessage sendEmailMsg= new Messaging.SingleEmailMessage();
    //Header used in Subject
     String headerStr1 = '<br>'+System.Label.EmailBody+'</br>'  +'<br>'+System.Label.EmailBody0+
                        '</br><br><b><font size="4">'+name+'</font></b></br><br>'+System.Label.EmailBody1+iRCLink+
                        '</br><br> <table border="2" style="width:150%"> <tr><td>';
    //Header used in email body                 
    String headerStr = '</td><td> Includes Pearson eText?</td><td>Access Length</td><td>Bookstore ISBN(s)</td>';
    mapStr = new Map<String,String>();
    if(priceList.size() >0){
        for(String s : priceList){
            if(s.equalsIgnoreCase('Bookstore_Price__c')){        
                headerStr = headerStr + '<td> Price to Bookstore</td>' ;
             }else if(s.equalsIgnoreCase('Suggested Retail Price')){
                 headerStr = headerStr + '<td> Suggested Retail Price</td>';
             }
            else if(s.equalsIgnoreCase('Instant_Access_Price__c')){
                headerStr = headerStr + '<td> Instant Access</td>';
            }else if(s.equalsIgnoreCase('eText_Offer_Price__c')){
                headerStr = headerStr + '<td> eText Offer</td>';
            }
            //else if(s.equalsIgnoreCase('Print_Offer_Price__c')){
            else{
                headerStr = headerStr + '<td> Print Offer</td>';
            }
            mapStr.put(s,s);
        }
        headerStr = headerStr + '</tr>';
    }else{
        headerStr = headerStr + '</tr>';
    }
    String conCat=ConstructingEmailBody();
    sendEmailMsg.setHtmlBody(headerStr1+headerStr + conCat + '</table></br><br>'+System.Label.EmailBody2+'</br>');
    List<String> lstEmail = new List<String>();
    lstEmail.add(String.valueof('s.reddy.bathula@accenture.com'));
    sendEmailMsg.setToAddresses(lstEmail);
    List<Messaging.SingleEmailMessage> lstMAils = new List<Messaging.SingleEmailMessage>();
    lstMAils.add(sendEmailMsg);  
    //System.debug('sendEmailMsg----->'+ sendEmailMsg.htmlbody);
    emailBody1 = sendEmailMsg.htmlbody;
    Messaging.sendEmail(lstMAils); 
}

public String ConstructingEmailBody(){
    String concat='';
    //System.debug('listWithPearsonChoices1'+listWithPearsonChoices1.size());
    String loggedUserpriceList;
    List<User> loggedInUserpriceListName = [select Price_List__c from User where id =: UserInfo.getUserId() limit 1];
    if(!loggedInUserpriceListName.isEmpty())
    {
        //System.debug('success....loggedInUserpriceListName'+prodIdset.size());
        loggedUserpriceList = String.ValueOf(loggedInUserpriceListName[0].Price_List__c);
    }
    if (prodIdset.size()>0){
        //System.debug('success....suggestedPrice ');
        suggestedPrice = [select Apttus_Config2__ProductId__c,Apttus_Config2__ListPrice__c from Apttus_Config2__PriceListItem__c 
                      where Apttus_Config2__ProductId__c =:prodIdset  and 
                      Apttus_Config2__PriceListId__r.name=:loggedUserpriceList and 
                      Apttus_Config2__Active__c = true order by lastmodifieddate desc limit 1000];
        if (!suggestedPrice.isEmpty()){
            if (suggestedPricemap == null)
                suggestedPricemap =new Map<Id,Apttus_Config2__PriceListItem__c>();
            for(Apttus_Config2__PriceListItem__c acp:suggestedPrice){
                system.debug(suggestedPricemap);
                if (!suggestedPricemap.containsKey(acp.Apttus_Config2__ProductId__c)){
                    suggestedPricemap.put(acp.Apttus_Config2__ProductId__c,acp);
                }
            }
        }              
    }
    if (!listWithPearsonChoices.isEmpty()){
    //System.debug('success....listWithPearsonChoices');
    for(Pearson_Choice__c pc : listWithPearsonChoices){   
        if(pc.Bookstore_ISBN_s__c == null){pc.Bookstore_ISBN_s__c = '0.00';}
        if(pc.Access_Length__c == null) {pc.Access_Length__c = ' ';}
        if(pc.Instant_Access_Price__c == null) {pc.Instant_Access_Price__c = 0.00;}
        if(pc.eText_Offer_Price__c == null) {pc.eText_Offer_Price__c = 0.00;}
        if(pc.Print_Offer_Price__c == null) {pc.Print_Offer_Price__c = 0.00;}
        if(pc.Includes_Pearon_eText__c == null) {pc.Includes_Pearon_eText__c = ' ';}
        if(conCat == ''){
            if(null != pc.Bookstore_ISBN_s__c){
                conCat = '<tr><td>'+pc.Brand__c+'</td><td>'+pc.Includes_Pearon_eText__c+
                '</td><td>'+pc.Access_Length__c+'</td><td>'+pc.Bookstore_ISBN_s__c+'</td>';
            }
        }
        else{
            if(null != pc.Brand__c ){
                conCat = conCat + '<tr><td>'+pc.Brand__c+'</td><td>'+pc.Includes_Pearon_eText__c+
                        '</td><td>'+pc.Access_Length__c+'</td><td>'+pc.Bookstore_ISBN_s__c+'</td>';
            }
        }
        
        if(mapStr.containsKey('Bookstore_Price__c')){
            if(pc.Bookstore_Price__c == null){
                    conCat = conCat + '<td>'+' '+'</td>';
            }
            else{
                    conCat = conCat + '<td>'+ pc.Bookstore_Price__c.setScale(2)+'</td>';
            }            
        }
        if(mapStr.containsKey('Suggested Retail Price') ){
            //system.debug('user selected sp');
            if(suggestedPricemap != null && !suggestedPricemap.isEmpty()){
                //system.debug('suggested map is not empty:'+suggestedPricemap.values());
                //system.debug(suggestedPricemap.get(pc.Bookstore__c).Apttus_Config2__ListPrice__c);
                    //if(suggestedPrice[0].Apttus_Config2__ListPrice__c !=null){
                if(pc.Bookstore__c != null){    
                if(suggestedPricemap.containsKey(pc.Bookstore__c)){
                    suggestedRetailprice  = suggestedPricemap.get(pc.Bookstore__c).Apttus_Config2__ListPrice__c ;
                    suggestedRetailprice  = suggestedRetailprice.setScale(2);
                }
                }
                else if (pc.Instant_Access__c != null){
                 if(suggestedPricemap.containsKey(pc.Instant_Access__c)){
                    suggestedRetailprice  = suggestedPricemap.get(pc.Instant_Access__c).Apttus_Config2__ListPrice__c ;
                    suggestedRetailprice  = suggestedRetailprice.setScale(2);
                 }
                }
            }
            else{ 
                suggestedRetailprice  = 0.00;
                }
            
            if(suggestedRetailprice  == 0.00){
                conCat = conCat + '<td>'+' '+'</td>'; 
            } else {
                conCat = conCat + '<td>'+suggestedRetailprice+'</td>';
            }      
        }       
        if(mapStr.containsKey('Instant_Access_Price__c') && null !=pc.Instant_Access_Price__c){
            if(pc.Instant_Access_Price__c == 0.00)
               conCat = conCat + '<td>'+' ' +'</td>';
            else
               conCat = conCat + '<td>'+pc.Instant_Access_Price__c.setScale(2) +'</td>';
        }
        if(mapStr.containsKey('eText_Offer_Price__c') && null != pc.eText_Offer_Price__c ){
            if(pc.eText_Offer_Price__c == 0.00)
                conCat = conCat + '<td>'+' '+'</td>';
            else
                conCat = conCat + '<td>'+pc.eText_Offer_Price__c.setScale(2) +'</td>';
        }        
        if(mapStr.containsKey('Print_Offer_Price__c') && null!= pc.Print_Offer_Price__c ){
            if(pc.Print_Offer_Price__c == 0.00)
                conCat = conCat + '<td>'+' '+'</td>';
            else
                conCat = conCat + '<td>'+ pc.Print_Offer_Price__c.setScale(2)+'</td>';
        }     
        conCat = conCat + '</tr>';    
    }
    }
    return conCat;
}
public void retrieveProductDetails()
{
    Product2 product = [select Name, Author__c, Full_Title__c,  Edition__c, ISBN__c,IRC_Link__c from Product2 
                        where Id =:productIdFromURL limit 1000];    
    if(product.Author__c!=null){ author= product.Author__c ; }
    if(product.Full_Title__c !=null){  title =product.Full_Title__c;  } 
    if(product.Edition__c  !=null){  edition =product.Edition__c ;  }
    if(product.Name  !=null){ name =product.Name ;  }
    if(product.ISBN__c !=null){    iSBN =product.ISBN__c;  }
    if(product.IRC_Link__c !=null){    iRCLink =product.IRC_Link__c;  }
    else {  iRCLink ='';  }
}

//Method to retrieve the contact details from opportunity
public void retrieveContactDetails()
{
    for(OpportunityContactRole contId : [select ContactId,Role from OpportunityContactRole where OpportunityId =: opportunityIdFromURL AND IsDeleted = False limit 1000])
    {    
        //listWithOpptyContactId.add(contId.ContactId); 
        if(contId.Role!=null){
            mapWithContactRoleAndID.put(contId.ContactId,contId.Role);
            }
        else{
            mapWithContactRoleAndID.put(contId.ContactId,'');
            }
    }    
    if(!(mapWithContactRoleAndID.keyset()).isEmpty() && (mapWithContactRoleAndID.keyset()).size()>0)
    {    
        for(Contact conVal :  getContacts(mapWithContactRoleAndID.keyset()))
        {
            listWithContactValues.add(new InnerWrapperClass(conVal));
        }   
    } 
    
    //get primary contact
    primaryContactList = [select ContactId from OpportunityContactRole where OpportunityId =: opportunityIdFromURL AND IsDeleted = False AND IsPrimary=true limit 1000];
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
 listWithContact = [select Id,Name,Email,MailingCity,MailingCountry,MailingState,MailingStreet,MailingPostalCode from Contact where Id IN : contactId limit 1000];
 return listWithContact;
}

//get single contact utility
public List<Contact> getPrimaryContact(Id contactId)
{
 List<Contact> listWithContact = new List<Contact>();
 listWithContact = [select Id,Name,Email,MailingCity,MailingCountry,MailingState,MailingStreet,MailingPostalCode from Contact where Id = : contactId limit 1000];
 return listWithContact;
}
//Return list of contact
public List<InnerWrapperClass> getContactValues()
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
    pageReference nextPage = page.Email_Choice;
    nextPage.setRedirect(false);
    return nextPage;   
}

//Add the selected contacts to a list and return to next page
public pageReference addContactToList0()
{
  
    pageReference nextPage = page.PS_SendEmail_Contacts;
    nextPage.setRedirect(false);
    return nextPage;   
}

//Add the selected contacts to a list and return to next page
public pageReference addContactToList1()
{
    selectedContacts = new List<Contact>();    
    pageReference nextPage = page.Pearson_Choice_SendEmail;
    for(InnerWrapperClass cCon: getContactValues()) 
    {
        if(cCon.selectBox == true) 
        {
            selectedContacts.add(cCon.contactList);
        }
    }
    if(selectedContacts != null && !selectedContacts.isEmpty())
    { 
        if(primaryContact == null)
        primaryContact = selectedContacts[0].Email;
        for(Contact contEmail: selectedContacts)    
        {
            if(contEmail.Email != null && contEmail.Email != primaryContact)
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

 /*
 if(opportunityIdFromURL != null)
 {
   urlParameters += '&p3_lkid=' + opportunityIdFromURL;   
 }
 
 if(subject != null)
 {
   urlParameters += '&p6=' + EncodingUtil.urlEncode(subject.left(100), 'UTF-8');
 }
 if(emailBody1 != null)
 {
   urlParameters += '&p7=' + EncodingUtil.urlEncode(emailBody1, 'UTF-8');
 }*/
  
 Outbound_Notification__c message = new Outbound_Notification__c();
 message.Subject__c = subject.left(100);
 message.Rich_Body__c = emailBody1;
 insert message;
 
 List<EmailTemplate> templates = [SELECT id FROM EmailTemplate WHERE NAME = 'Email Body Pearson Choices HTML'];
 Id templateId = null;
 if(templates != null && templates.size() > 0)
 {
   templateId = templates.get(0).Id;
   urlParameters += '&p3_lkid=' + message.Id;    
   //urlParameters += '&template_id=00Xg0000000NIwF';
   urlParameters += '&template_id=' + templateId;
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
    //List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();
    //Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
    List<String> toAddress = new List<String>();
   
    try
    { 
        toAddress.add(primaryContact );
        List<String> addEmails = additionalEmailAddress.split('; ');
        if(addEmails.size()>0){
            for(String addEmail : addEmails )
            {
                if(addEmail.length()>0 && addEmail!=null)
                    toAddress.add(addEmail.trim());
            }
        }
        //system.debug('toAddress///'+toAddress);
        email.setToAddresses(toAddress);    
        email.setHtmlBody(emailBody1); 
        email.setSubject(subject);      
        if(toAddress!=null)
        {         
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Info,'Email Sent Successfully.');
            ApexPages.addMessage(myMsg);
            mailsent = true;
        }          
      }  
      catch(Exception e)
      {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Error occurred.Please contact your administrator.');
            ApexPages.addMessage(myMsg);
      }  
}

//  Method to build the pearson choices tab
public void getPearsonChoices(List<Id> ids)
{
    mapWithPearsonChoice = new Map<Id,Pearson_Choice__c>();
    listWithPearsonChoices = new List<Pearson_Choice__c>();
    //if (listWithPearsonChoices == null){ 
        listWithPearsonChoices = [select Id,Access_Length__c,Bookstore__c,Bookstore__r.Name,Bookstore__r.Author__c,
            Bookstore__r.Copyright_Year__c,Bookstore__r.Edition__c,Bookstore__r.ISBN__c,Bookstore__r.InstockDate__c,
            Bookstore__r.Status__c,Bookstore__r.Sub_Brand__c,Bookstore_ISBN_s__c,Bookstore_Price__c,Brand__c,
            eText_Offer__c,eText_Offer_Price__c,Includes_Pearon_eText__c,Instant_Access__r.Name,
            Instant_Access__r.Author__c,Instant_Access__r.Copyright_Year__c,Instant_Access__r.Edition__c,
            Instant_Access__r.ISBN__c,Instant_Access__r.InstockDate__c,Instant_Access__r.Status__c,
            Instant_Access__r.Sub_Brand__c,Instant_Access__c,Instant_Access_Price__c,Master_Product__c,
            Offer_Type__c,Platform__c,Print_Offer__c,Print_Offer__r.Name,Print_Offer__r.Author__c,
            Print_Offer__r.Copyright_Year__c,Print_Offer__r.Edition__c,Print_Offer__r.ISBN__c,
            Print_Offer__r.InstockDate__c,Print_Offer__r.Status__c,Print_Offer__r.Sub_Brand__c,Print_Offer_Price__c,
            eText_Offer__r.Name,eText_Offer__r.Author__c,eText_Offer__r.Copyright_Year__c,eText_Offer__r.Edition__c,eText_Offer__r.ISBN__c,eText_Offer__r.InstockDate__c,eText_Offer__r.Status__c,eText_Offer__r.Sub_Brand__c,Product_Family__c,Sequence__c 
            from Pearson_Choice__c where  id in: ids Order By Sequence__c,Bookstore_Price__c,Instant_Access_Price__c ASC limit 1000];
    //}   
    if(listWithPearsonChoices.size()>0){
        //prodIdset=new Set<Id>();
        System.debug('success....Init Pearson Choices');
        for(Pearson_Choice__c pearsonCho : listWithPearsonChoices ) 
        {
            if (pearsonCho.Bookstore__c != null){
                System.debug('success....Init Product Id set');
                prodIdset.add(pearsonCho.Bookstore__c);
            }
            else if(pearsonCho.Instant_Access__c != null){
                System.debug('success....Init Product Id set');
                prodIdset.add(pearsonCho.Instant_Access__c);
            }
            mapWithPearsonChoice.put(pearsonCho.Id,pearsonCho);
        }        
    }
    //return listWithPearsonChoices;
} 

//Redirect to opportunity
public pageReference cancel()
{
    pageReference productPage; 
    productPage = new  pageReference(System.Label.onecrmFamilyVF+'productFamilyId='+productIdFromURL+'&oppId='+opportunityIdFromURL);
    productPage .setRedirect(true);   
    return productPage;  
}

}