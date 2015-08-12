/*************************************************************
@Author : Accenture IDC
@Description: Controller for Leave Behind(NA Sol Doc Gen.)- sends email to opp contact(s), Generates PDF
@Date  :
**************************************************************/
public class PS_LeaveBehindController{
    /*Variable Declaration Start */
    //public List<Id> listWithOpptyContactId;
    public List<InnerWrapperClass> listWithContactValues{get;set;}
    public List<Contact> selectedContacts{get;set;}
    public Id opportunityIdFromURL;
    public Id productIdFromURL{get;set;}
    public Id productFamilyIdFromUrl{get;set;}
    public String primaryContact{get;set;}
    public Id primaryContactId{get;set;}
    public List<OpportunityContactRole> primaryContactList{get; set;}
    public String subject{get;set;}
    public String emailBody{get;set;}
    public blob documentbody{get;set;}
    public String documentname{get;set;}
    public String additionalEmailAddress{get;set;}
    public Map<Id,String> mapWithContactRoleAndID{get;set;}
    private String author;
    private String title;
    private String edition;
    private String name;
    private String iSBN;
    private String iRCLink;
    public List<Marketing_Information__c> marketingInfo{get; set;}
    public Map<String,String> marketingcontent{get; set;}
    public Map<String,String> marketinginfoMap{get; set;}
    public List<Apttus_Config2__RelatedProduct__c> InstructortResources{get;set;}
    public List<Apttus_Config2__RelatedProduct__c> StudentResources{get;set;}
    public List<Apttus_Config2__PriceListItem__c> priceList {get; set;}
    public List<Apttus_Config2__RelatedProduct__c> productListPackage{get;set;}
    public List<Pearson_Choice__c> PearsonChoiceList{get;set;}
    public Product2 product {get; set;}
    public boolean tableofcontents {get;set;}
    public boolean description {get; set;}
    public boolean producturl{get;set;}
    public boolean newtothisedition{get;set;}
    public boolean features{get; set;}
    public boolean abouttheauthor{get;set;}
    public boolean instructor{get; set;}
    public boolean selected{get;set;}
    public boolean student{get; set;}
    public boolean pearsonchoices{get; set;}
    public boolean PricetoBookstore{get; set;}
    public boolean Printoffer{get; set;}
    public boolean InstantAccess{get; set;}
    public boolean SuggestedRetailPrice{get; set;}
    public boolean eTextOffer{get; set;}
    public boolean instDescriptions{get;set;}
    public boolean studntDescriptions{get;set;}
    //public Id Image {get;set;}
    public boolean booleanNetprice {get;set;}
    public boolean booleanListprice {get;set;}
    public Decimal sNetprice {get;set;}
    public Decimal sListprice {get;set;}
    public String mailAttachment{get;
        set {mailAttachment= 'mailAttachment';}
    }
    public String product_status{get;set;}
    public String inst_status{get;set;}
    public String stdnt_status{get;set;}
    public Integer InstResourcesSize {get;set;}
    public Integer StndResourcesSize {get;set;}
    public Integer pearschoiceSize {get;set;}
    public Integer PackageSize {get;set;}
    public boolean mailsent {get;set;}
    public Map<ID,Decimal> suggestedRetPrice{get; set;}
    public List<String> toAddress ;
    /*Constructor Start*/
    public PS_LeaveBehindController()
    {
        system.debug('//constructor//.');
        mapWithContactRoleAndID = new Map<Id,String>();
        If(null !=ApexPages.currentPage().getParameters().get('opportunityId')){
            opportunityIdFromURL = ApexPages.currentPage().getParameters().get('opportunityId');
        }
        if(null != ApexPages.currentPage().getParameters().get('productFamilyId')){
            productIdFromURL = ApexPages.currentPage().getParameters().get('productFamilyId');
            productFamilyIdFromUrl = ApexPages.currentPage().getParameters().get('productFamilyId');
        }
        if(null != ApexPages.currentPage().getParameters().get('productId')){
            productIdFromURL = ApexPages.currentPage().getParameters().get('productId');
        }
        if(null != ApexPages.currentPage().getParameters().get('mailAttachment')){
            mailAttachment = ApexPages.currentPage().getParameters().get('mailAttachment');
            system.debug('mailAttachment in constr.'+mailAttachment );
        }
        if(null != ApexPages.currentPage().getParameters().get('instructor')){
            instructor = Boolean.valueof(ApexPages.currentPage().getParameters().get('instructor'));
            system.debug('selected instructor in construc..'+instructor);
        }
        if(null != ApexPages.currentPage().getParameters().get('student')){
            student = Boolean.valueof(ApexPages.currentPage().getParameters().get('student'));
            system.debug('selected student in construc..'+instructor);
        }
        if(null != ApexPages.currentPage().getParameters().get('pearsonchoices')){
            pearsonchoices = Boolean.valueof(ApexPages.currentPage().getParameters().get('pearsonchoices'));
        }
        if(null != ApexPages.currentPage().getParameters().get('booleanNetprice')){
            booleanNetprice = Boolean.valueof(ApexPages.currentPage().getParameters().get('booleanNetprice'));
        }
        if(null != ApexPages.currentPage().getParameters().get('booleanListprice ')){
            booleanListprice = Boolean.valueof(ApexPages.currentPage().getParameters().get('booleanListprice '));
        }
        if(null != ApexPages.currentPage().getParameters().get('tableofcontents')){
            tableofcontents = Boolean.valueof(ApexPages.currentPage().getParameters().get('tableofcontents'));
        }
        if(null != ApexPages.currentPage().getParameters().get('description')){
            description= Boolean.valueof(ApexPages.currentPage().getParameters().get('description'));
        }
        if(null != ApexPages.currentPage().getParameters().get('producturl')){
            producturl= Boolean.valueof(ApexPages.currentPage().getParameters().get('producturl'));
        }
        if(null != ApexPages.currentPage().getParameters().get('newtothisedition')){
            newtothisedition= Boolean.valueof(ApexPages.currentPage().getParameters().get('newtothisedition'));
        }
        if(null != ApexPages.currentPage().getParameters().get('features')){
            features= Boolean.valueof(ApexPages.currentPage().getParameters().get('features'));
        }
        if(null != ApexPages.currentPage().getParameters().get('abouttheauthor')){
            abouttheauthor= Boolean.valueof(ApexPages.currentPage().getParameters().get('abouttheauthor'));
        }
        if(null != ApexPages.currentPage().getParameters().get('PricetoBookstore')){
            system.debug('PricetoBookstore in const.'+PricetoBookstore);
            PricetoBookstore = Boolean.valueof(ApexPages.currentPage().getParameters().get('PricetoBookstore'));
        }
        if(null != ApexPages.currentPage().getParameters().get('Printoffer')){
            Printoffer = Boolean.valueof(ApexPages.currentPage().getParameters().get('Printoffer'));
        }
        if(null != ApexPages.currentPage().getParameters().get('InstantAccess')){
            InstantAccess = Boolean.valueof(ApexPages.currentPage().getParameters().get('InstantAccess'));
        }
        if(null != ApexPages.currentPage().getParameters().get('eTextOffer')){
            eTextOffer = Boolean.valueof(ApexPages.currentPage().getParameters().get('eTextOffer'));
        }
        if(null != ApexPages.currentPage().getParameters().get('SuggestedRetailPrice')){
            SuggestedRetailPrice = Boolean.valueof(ApexPages.currentPage().getParameters().get('SuggestedRetailPrice'));
        }
        listWithContactValues = new List<InnerWrapperClass>();
        primaryContactList = new List<OpportunityContactRole>();
        additionalEmailAddress = UserInfo.getUserEmail()+';'+' ';
        retrieveContactDetails();
        retrieveProductDetails();
        if(null!=product.Status__c ){
            if(product.Status__c.equalsIgnoreCase(System.Label.PUB)) { product_status =System.Label.Published; }
            if(product.Status__c.equalsIgnoreCase(System.Label.BO)) { product_status =System.Label.Back_Ordered;}
            if(product.Status__c.equalsIgnoreCase(System.Label.AOD)) { product_status =System.Label.Available_on_Demand;}
            if(product.Status__c.equalsIgnoreCase(System.Label.NYP)) { product_status =System.Label.Not_Yet_Published;}
            if(product.Status__c.equalsIgnoreCase(System.Label.TU)) { product_status =System.Label.Temporarily_Unavailable;}
        }
        if(null!= mailAttachment ){
            if(null!= name) { subject = System.Label.PearsonLabel+''+name; }
            if(null!= author){ subject = subject +','+author;}
            if(null!=edition){ subject = subject +','+edition+'"';}
            if(product.IRC_Link__c !=null){ emailBody = product.IRC_Link__c;}
            createPdf();
        }
        else{
            subject = System.Label.Email_Subject_for_NA_Sol_doc+' '+name +', '+author+', '+edition+'"' ;
            generatePDF();
            emailBody = System.Label.Email_Body1_for_NASol_doc+' '+name +' .'+System.Label.Email_Body1_1_for_NA_Sol_doc+'n'+iRCLink+'nn'+System.Label.Email_Body1_2_for_NA_Sol_doc;
        }
    }
    /*Constructor End*/
    //Method to retrieve the Product details from opportunity
    public void retrieveProductDetails()
    {
        product = [select Name, Full_Title__c,Family, Author__c,Edition__c, Copyright_Year__c,Status__c,SBN__c,ISBN__c,URL__c,Image__c,InstockDate__c,Digital_Instock_Date__c,Digital_Status__c,Sub_Brand__c,Platform__c,Full_Author_and_Affiliation__c,Publisher__c,Publish_Date__c,Free_Copy_Substitute__c,Apttus_Config2__ConfigurationType__c,Priority__c,IRC_Link__c from Product2 where Id =:productIdFromURL limit 10];
        if(product.Author__c!=null){ author= product.Author__c ; }
        else {  author='';  }
        if(product.Full_Title__c !=null){ title =product.Full_Title__c; }
        else{ title =''; }
        if(product.Edition__c !=null){ edition =product.Edition__c ; }
        else { edition =''; }
        if(product.Name !=null){ name =product.Name ; }
        else { name =''; }
        if(product.ISBN__c !=null){ iSBN =product.ISBN__c; }
        else { iSBN =''; }
        if(product.IRC_Link__c !=null){ iRCLink =product.IRC_Link__c; }
        else { iRCLink =''; }
    }
    /**
    * Description : Method to retrieve the contact details from opportunity
    * @param NA
    * @return Void
    * @throws NA
    **/
    //Method to retrieve the contact details from opportunity
    public void retrieveContactDetails()
    {
        for(OpportunityContactRole contId : [select ContactId,Role from OpportunityContactRole where OpportunityId =: opportunityIdFromURL AND IsDeleted = False limit 1000])
        {
            //listWithOpptyContactId.add(contId.ContactId);
            if(contId.Role!=null)
            mapWithContactRoleAndID.put(contId.ContactId,contId.Role);
            else
            mapWithContactRoleAndID.put(contId.ContactId,'');
        }
        if(!(mapWithContactRoleAndID.keyset()).isEmpty() && (mapWithContactRoleAndID.keyset()).size()>0)
        {
            for(Contact conVal : getContacts(mapWithContactRoleAndID.keyset()))
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
            primaryContactId = listWithPrimaryContact[0].Id;
        }
        if(listWithContactValues.isEmpty())
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Info,System.Label.NoContactRoles);
            ApexPages.addMessage(myMsg);
        }
    }
    /**
    * Description : Method to retrieve bulk contact utility
    * @param contactId
    * @return List of contacts
    * @throws NA
    **/
    // Method to retrieve bulk contact utility
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
    public List<InnerWrapperClass> getContactValues()
    {
        if(listWithContactValues.isEmpty())
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Info,System.Label.NoContactRoles);
            ApexPages.addMessage(myMsg);
        }
        return listWithContactValues;
    }
    //Add the selected contacts to a list and return to next page
    public pageReference addContactToList()
    {
        selectedContacts = new List<Contact>();
        pageReference nextPage = new pageReference(System.Label.SendEmailtoOppcontactsURL+'opportunityId='+opportunityIdFromURL+'&productFamilyId='+productIdFromURL);
        for(InnerWrapperClass cCon: getContactValues())
        {
            if(cCon.selectBox == true)
            {
                selectedContacts.add(cCon.contactList);
            }
        }
        if(selectedContacts != null && !selectedContacts.isEmpty())
        {
            if(primaryContact == null){
                primaryContact = selectedContacts[0].Email;
            }
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
            if(cCon.selectBox == true && cCon.contactList.Id != primaryContactId)
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
        if(subject != null)
        {
            urlParameters += '&p6=' + EncodingUtil.urlEncode(subject.left(100), 'UTF-8');
        }
        if(emailBody != null)
        {
            urlParameters += '&p7=' + EncodingUtil.urlEncode(emailBody, 'UTF-8');
        }
        if(null != mailAttachment )
        {
            documentname = Name+'.pdf';
            Blob b = null;
            PageReference pdf = generatePDF();
            // Blob b = pdf.getContentAsPDF();
            if (Test.isRunningTest()){
                b = Blob.valueof('Test String');
            }
            else{
                b = pdf.getContentAsPDF();
            }
            Document d = new Document();
            //d.FolderId = UserInfo.getUserId();
            List<Folder> folders = [SELECT id FROM Folder WHERE NAME = 'Email Attachments'];
            Id folderId = null;
            if(folders != null && folders.size() > 0)
            {
                folderId = folders.get(0).Id;
            }
            else
            {
                folderId = UserInfo.getUserId();
            }
            d.FolderId = folderId;
            d.Body = b;
            //d.Name = 'pdf_email_attachment_file.pdf';
            d.Name = documentname;
            d.ContentType = 'application/pdf';
            d.Type = 'pdf';
            insert d;
            urlParameters += '&doc_id=' + d.Id;
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
    /**
    * Description : Method to send Email(s)
    * @param NA
    * @return NA
    * @throws NA
    **/
    //Method to send Email(s)
    public void sendEmail()
    {
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();
        Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
        toAddress = new List<String>();
        try
        {
            documentname = Name+'.pdf';
            system.debug('Before blob before ..'+mailAttachment);
            Blob b = null;
            PageReference pdf =generatePDF();
            system.debug('Before blob ..'+mailAttachment);
            if (Test.isRunningTest()){
                b = Blob.valueof('Test String');
            }
            else{
                b = pdf.getContentAsPDF();
            }
            system.debug('after blob ..'+mailAttachment);
            if(null != mailAttachment ){
                documentbody = b;
            }
            if(documentbody != null && documentname != null)
            {
                efa.setFileName(documentname);
                efa.setBody(documentbody );
                fileAttachments.add(efa);
            }
            //Setting the values
            if(fileAttachments!=null && !fileAttachments.isEmpty())
            {
                email.setFileAttachments(fileAttachments);
            }
            toAddress.add(primaryContact );
            List<String> addEmails = additionalEmailAddress.split('; ');
            if(addEmails.size()>0 && addEmails != null ){
                for(String addEmail : addEmails )
                {
                    if(addEmail.length()>0 && addEmail!=null)
                    toAddress.add(addEmail.trim());
                }
            }
            email.setToAddresses(toAddress);
            email.setPlainTextBody(emailBody);
            email.setSubject(subject);
            if(toAddress!=null)
            {
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Info,System.Label.EmailSuccessMessage);
                ApexPages.addMessage(myMsg);
                mailsent = true;
            }
        }
        catch(Exception e)
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,System.Label.EmailErrorMsg);
            ApexPages.addMessage(myMsg);
        }
    }
    //Redirect to Products page
    public pageReference cancel()
    {
        pageReference productPage;
        if(productIdFromURL == productFamilyIdFromUrl ){
            productPage = new pageReference(System.Label.onecrmFamilyVF+'productFamilyId='+productIdFromURL+'&oppId='+opportunityIdFromURL);
            }else{
            productPage = new pageReference(System.Label.productCatalogueVF+'productId='+productIdFromURL+'&oppId='+opportunityIdFromURL);
        }
        productPage .setRedirect(false);
        return productPage;
    }
    //Wrapper class to allow user to select multiple contact(s)
    public class InnerWrapperClass{
        public boolean selectBox{get;set;}
        public boolean primaryContact{get;set;}
        public Contact contactList{get;set;}
        public InnerWrapperClass(Contact contactRec)
        {
            contactList = contactRec;
            selectBox = false;
        }
    }
    /**
    * Description : Method invokes generate Pdf
    * @param NA
    * @return PageReference
    * @throws NA
    **/
    //Method invokes generate Pdf
    public pageReference generatePDF(){
        createPdf();
        pageReference nextPage = page.PS_MarketingLeaveBehindPDF;
        nextPage.setRedirect(false);
        return nextPage;
    }
    /**
    * Description : Method to generate Pdf
    * @param NA
    * @return PDF
    * @throws NA
    **/
    //Method to generate Pdf
    public void createPdf()
    {
        // to fetch pearson choice list
        PearsonChoiceList = [select Product_Family__c,Bookstore__c,Brand__c,BrandCalc1__c,BrandCalc2__c,Includes_Pearon_eText__c, Access_Length__c, Bookstore_ISBN_s__c, Bookstore_Price__c, Print_Offer__c, Instant_Access_Price__c, eText_Offer_Price__c from Pearson_Choice__c where Product_Family__c=:productIdFromURL Order By Sequence__c,Bookstore_Price__c,Instant_Access_Price__c ASC limit 1000 ];
        pearschoiceSize = PearsonChoiceList.size();
        // to fetch netprice and retail price under product info.
        String loggedUserpriceList;
        List<User> loggedInUserpriceListName = new List<User>();
        List<Apttus_Config2__PriceListItem__c> suggestedPrice = new List<Apttus_Config2__PriceListItem__c>();
        loggedInUserpriceListName = [select Price_List__c from User where id =: UserInfo.getUserId() limit 10 ];
        if(loggedInUserpriceListName != null && !loggedInUserpriceListName .isEmpty())
        {
            loggedUserpriceList = String.ValueOf(loggedInUserpriceListName[0].Price_List__c);
        }
        set<Id> pcprodId = new set<Id>();
        for(Pearson_Choice__c pc : PearsonChoiceList){
            if(pc.Bookstore__c != null)
                pcprodId.add(pc.Bookstore__c);
        }
        
        suggestedRetPrice = new Map<ID,Decimal>();
        suggestedPrice = [select Apttus_Config2__ListPrice__c,Apttus_Config2__ProductId__c from Apttus_Config2__PriceListItem__c where 
                Apttus_Config2__ProductId__c =:pcprodId and Apttus_Config2__PriceListId__r.name=:loggedUserpriceList];
                // and Apttus_Config2__Active__c = true limit 100];
        Map<Id,Apttus_Config2__PriceListItem__c> sugprodprice= new Map<Id,Apttus_Config2__PriceListItem__c>();  
        for(Apttus_Config2__PriceListItem__c pli:suggestedPrice){
            //if(!suggestedRetPrice.containsKey(pli.Apttus_Config2__ProductId__c))
              //   suggestedRetPrice.put(pli.Apttus_Config2__ProductId__c,pli);
            if(!sugprodprice.containsKey(pli.Apttus_Config2__ProductId__c ))
                sugprodprice.put(pli.Apttus_Config2__ProductId__c,pli);
        }
        
        if(null != PearsonChoiceList && !PearsonChoiceList.isEmpty()){
            for(Pearson_Choice__c pc : PearsonChoiceList){
                //suggestedPrice = [select Apttus_Config2__ListPrice__c from Apttus_Config2__PriceListItem__c where 
                //Apttus_Config2__ProductId__c =:pc.Bookstore__c and Apttus_Config2__PriceListId__r.name=:loggedUserpriceList
                // and Apttus_Config2__Active__c = true limit 100];
                //limit 100];
                
                /*if(null != suggestedPrice && suggestedPrice.size()>0){
                    if(null !=pc.Bookstore__c && null!= suggestedPrice[0].Apttus_Config2__ListPrice__c){
                        suggestedRetPrice.put(pc.Bookstore__c,suggestedPrice[0].Apttus_Config2__ListPrice__c);
                    }
                }*/
                if(null != sugprodprice && sugprodprice.size()>0){
                    if(null !=pc.Bookstore__c && null!= sugprodprice.get(pc.Bookstore__c).Apttus_Config2__ListPrice__c){
                        suggestedRetPrice.put(pc.Bookstore__c,sugprodprice.get(pc.Bookstore__c).Apttus_Config2__ListPrice__c);
                    } 
                }               
                
            }
        }
        if(null!=productIdFromURL){
            priceList = new List<Apttus_Config2__PriceListItem__c>();
            priceList= [select Net_Price__c, Apttus_Config2__ListPrice__c from Apttus_Config2__PriceListItem__c where Apttus_Config2__ProductId__c =: productIdFromURL and Apttus_Config2__PriceListId__r.name=:loggedUserpriceList and Apttus_Config2__Active__c = true limit 10];
        }
        if(priceList!=null && !priceList.isEmpty())
        {
            if(priceList[0].Net_Price__c != null){
                sNetprice = priceList[0].Net_Price__c;
                sNetprice = sNetprice.setScale(2);
            }
            if(priceList[0].Apttus_Config2__ListPrice__c!=null){
                sListprice = priceList[0].Apttus_Config2__ListPrice__c ;
                sListprice = sListprice .setScale(2);
            }
        }
        // to fetch marketing info.
        marketingInfo = [SELECT Id, Sub_Type__c, Family__c, Product__c, Content__c FROM Marketing_Information__c WHERE
        (Family__c =:productIdFromURL AND Order__c = 1 AND Type__c = 'About this Product' AND Sub_Type__c IN
        ('Table of Contents','Description','New To This Edition','Features','About the Author(s)')) limit 100 ];
        marketingcontent = new Map<String,String>();
        if(!marketingInfo .isempty()){
            for(Marketing_Information__c content: marketingInfo)
            {
                if(null !=tableofcontents && tableofcontents == true){
                    if(null !=content.Sub_Type__c && content.Sub_Type__c.equalsIgnoreCase(System.Label.Table_of_Contents) && null !=content.Content__c) {
                    marketingcontent.put(content.Sub_Type__c,content.Content__c );}
                }
                if(null !=description && description== true){
                    if(null !=content.Sub_Type__c && content.Sub_Type__c.equalsIgnoreCase(System.Label.Description) && null !=content.Content__c ){
                    marketingcontent.put(content.Sub_Type__c,content.Content__c );}
                }
                if(null !=newtothisedition && newtothisedition == true){
                    if(null !=content.Sub_Type__c && content.Sub_Type__c.equalsIgnoreCase(System.Label.New_To_This_Edition) && null !=content.Content__c ){
                    marketingcontent.put(content.Sub_Type__c,content.Content__c );}
                }
                if(null !=features && features == true){
                    if(null !=content.Sub_Type__c && content.Sub_Type__c.equalsIgnoreCase(System.Label.Features) && null !=content.Content__c ){
                    marketingcontent.put(content.Sub_Type__c,content.Content__c );}
                }
                if(null !=abouttheauthor && abouttheauthor == true){
                    if(null !=content.Sub_Type__c && content.Sub_Type__c.equalsIgnoreCase(System.Label.About_the_Author_s) && null !=content.Content__c ){
                    marketingcontent.put(content.Sub_Type__c,content.Content__c );}
                }
            }
        }
        // to fetch Instructor Resources
        InstructortResources =[select Instructor_Resource__c, Student_Resource__c, Apttus_Config2__RelatedProductId__r.Id, Apttus_Config2__RelatedProductId__r.Name, Apttus_Config2__RelatedProductId__r.Author__c, Apttus_Config2__RelatedProductId__r.SBN__c, Apttus_Config2__RelatedProductId__r.ISBN__c, Apttus_Config2__RelatedProductId__r.Copyright_Year__c, Apttus_Config2__RelatedProductId__r.Binding__c, Apttus_Config2__RelatedProductId__r.Status__c, Apttus_Config2__RelatedProductId__r.instockDate__c, Apttus_Config2__RelatedProductId__r.Priority__c, Apttus_Config2__RelatedProductId__r.Sub_Brand__c,
        Apttus_Config2__RelatedProductId__r.Platform__c,
        Apttus_Config2__RelatedProductId__r.URL__c ,
        Apttus_Config2__RelatedProductId__r.Full_Author_and_Affiliation__c,Apttus_Config2__RelatedProductId__r.Description,Apttus_Config2__RelatedProductId__r.Publish_Date__c
        from Apttus_Config2__RelatedProduct__c where Apttus_Config2__ProductId__c =: productIdFromURL And Instructor_Resource__c =:True limit 100];
        InstResourcesSize = InstructortResources.size();
        // to fetch Student Resources
        StudentResources = [select Instructor_Resource__c, Student_Resource__c, Apttus_Config2__RelatedProductId__r.Id, Apttus_Config2__RelatedProductId__r.Name, Apttus_Config2__RelatedProductId__r.Author__c, Apttus_Config2__RelatedProductId__r.SBN__c, Apttus_Config2__RelatedProductId__r.ISBN__c, Apttus_Config2__RelatedProductId__r.Copyright_Year__c, Apttus_Config2__RelatedProductId__r.Binding__c, Apttus_Config2__RelatedProductId__r.Status__c, Apttus_Config2__RelatedProductId__r.instockDate__c, Apttus_Config2__RelatedProductId__r.Priority__c, Apttus_Config2__RelatedProductId__r.Sub_Brand__c,
        Apttus_Config2__RelatedProductId__r.Platform__c,
        Apttus_Config2__RelatedProductId__r.URL__c ,
        Apttus_Config2__RelatedProductId__r.Full_Author_and_Affiliation__c,Apttus_Config2__RelatedProductId__r.Description,Apttus_Config2__RelatedProductId__r.Publish_Date__c
        from Apttus_Config2__RelatedProduct__c where Apttus_Config2__ProductId__c =: productIdFromURL And Student_Resource__c =:True limit 100 ];
        StndResourcesSize = StudentResources.size();
        if(null!=InstructortResources){
            for(Apttus_Config2__RelatedProduct__c inst_obj :InstructortResources){
                if(inst_obj.Apttus_Config2__RelatedProductId__r.Status__c.equalsIgnoreCase(System.Label.PUB)) {inst_obj.Apttus_Config2__RelatedProductId__r.Status__c =System.Label.Published;}
                if(inst_obj.Apttus_Config2__RelatedProductId__r.Status__c.equalsIgnoreCase(System.Label.BO)) { inst_obj.Apttus_Config2__RelatedProductId__r.Status__c =System.Label.Back_Ordered;}
                if(inst_obj.Apttus_Config2__RelatedProductId__r.Status__c.equalsIgnoreCase(System.Label.AOD)) { inst_obj.Apttus_Config2__RelatedProductId__r.Status__c =System.Label.Available_on_Demand;}
                if(inst_obj.Apttus_Config2__RelatedProductId__r.Status__c.equalsIgnoreCase(System.Label.NYP)) { inst_obj.Apttus_Config2__RelatedProductId__r.Status__c =System.Label.Not_Yet_Published;}
                if(inst_obj.Apttus_Config2__RelatedProductId__r.Status__c.equalsIgnoreCase(System.Label.TU))  { inst_obj.Apttus_Config2__RelatedProductId__r.Status__c =System.Label.Temporarily_Unavailable;}
                inst_status = inst_obj.Apttus_Config2__RelatedProductId__r.Status__c ;
            }
        }
        if(null!=StudentResources ){
            for(Apttus_Config2__RelatedProduct__c stdnt_obj :StudentResources ){
                if(stdnt_obj.Apttus_Config2__RelatedProductId__r.Status__c.equalsIgnoreCase(System.Label.PUB)) { stdnt_obj .Apttus_Config2__RelatedProductId__r.Status__c = System.Label.Published;}
                if(stdnt_obj.Apttus_Config2__RelatedProductId__r.Status__c.equalsIgnoreCase(System.Label.BO)) { stdnt_obj.Apttus_Config2__RelatedProductId__r.Status__c = System.Label.Back_Ordered;}
                if(stdnt_obj.Apttus_Config2__RelatedProductId__r.Status__c.equalsIgnoreCase(System.Label.AOD)) { stdnt_obj.Apttus_Config2__RelatedProductId__r.Status__c = System.Label.Available_on_Demand;}
                if(stdnt_obj.Apttus_Config2__RelatedProductId__r.Status__c.equalsIgnoreCase(System.Label.NYP)) { stdnt_obj.Apttus_Config2__RelatedProductId__r.Status__c = System.Label.Not_Yet_Published;}
                if(stdnt_obj.Apttus_Config2__RelatedProductId__r.Status__c.equalsIgnoreCase(System.Label.TU))  { stdnt_obj.Apttus_Config2__RelatedProductId__r.Status__c = System.Label.Temporarily_Unavailable;}
                stdnt_status= stdnt_obj.Apttus_Config2__RelatedProductId__r.Status__c ;
            }
        }
        productListPackage = [select Apttus_Config2__ProductId__r.Id,Apttus_Config2__ProductId__r.Name,Apttus_Config2__RelatedProductId__r.Name, Apttus_Config2__RelatedProductId__r.Author__c,Apttus_Config2__RelatedProductId__r.SBN__c,Component_Package__c from Apttus_Config2__RelatedProduct__c where Apttus_Config2__ProductId__c =:productIdFromURL AND Component_Package__c=true limit 100 ];
        PackageSize = productListPackage.size();
    }
    /**
    * Description : Method to Redirect to contacts Page
    * @param NA
    * @return PageRef
    * @throws NA
    **/
    //Method to Redirect to contacts Page
    public pageReference sendEmailWithAttachement()
    {
        pageReference nextPage = new pageReference(System.Label.DisplayOppContactsVF+'opportunityId='+opportunityIdFromURL+'&productFamilyId='+productIdFromURL+'&mailAttachment='+mailAttachment+'&instructor='+instructor+'&student='+student+'&pearsonchoices='+pearsonchoices+'&booleanNetprice='+booleanNetprice+'&booleanListprice ='+booleanListprice+'&tableofcontents='+tableofcontents+'&description='+description+'&producturl='+producturl+'&newtothisedition='+newtothisedition+'&features='+features+'&abouttheauthor='+abouttheauthor+'&Printoffer='+Printoffer+'&InstantAccess='+InstantAccess+'&eTextOffer='+eTextOffer+'&SuggestedRetailPrice='+SuggestedRetailPrice);
        nextPage.setRedirect(true);
        return nextPage;
    }
}