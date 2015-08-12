/**
* Name : PS_LeaveBehindController_Test
* Author : Accenture
* Description : Test class used for testing the PS_LeaveBehindController
* Date : 6/22/15
* Version : <intial Draft>
*/
@isTest
public class PS_LeaveBehindController_Test {
    static testMethod void LeaveBehindTest() {
        List<Opportunity> lstOppty = TestDataFactory.createOpportunity(1,'D2L');
        insert lstOppty;
        List<Contact> contactLst = TestDataFactory.createContact(1);
        insert contactLst ;
        List<OpportunityContactRole> lstRole = new List<OpportunityContactRole>();
        for(Integer i =0 ; i<2 ; i++){
            OpportunityContactRole opptyContactObj = new OpportunityContactRole();
            opptyContactObj.opportunityId = lstOppty[0].id;
            opptyContactObj.Role ='Decision Maker';
            if(i==0){
                opptyContactObj.IsPrimary = true;
                opptyContactObj.contactId = contactLst[0].id;
            }
            else{
                opptyContactObj.IsPrimary = false;
                opptyContactObj.contactId = contactLst[0].id;
            }
            lstRole.add(opptyContactObj);
        }
        insert lstRole;
        // Insert Product
        List<Product2> prdList = TestDataFactory.createProduct(1);
        insert prdList;
        // Insert Pearson choices
       List<Pearson_Choice__c> pc = TestDataFactory.insertPC();
         // insert Marketing Info.
       TestDataFactory.insertMarketInfo();
        List<User> listWithUser = new List<User>();
        
        listWithUser = TestDataFactory.createUser([select Id from Profile where Name =: 'System Administrator'].Id,1);
        if(listWithUser != null && !listWithUser.isEmpty())
        {
            listWithUser[0].Price_List__c = 'Math & Science';
            insert listWithUser;
        }     
        TestDataFactory.insertpricelist();       
        Test.startTest();
        Test.setCurrentPage(Page.PS_DisplayOppContacts);
        Test.setCurrentPage(Page.PS_MarketingLeaveBehindPDF);
        ApexPages.currentPage().getParameters().put('opportunityId',lstOppty[0].id);
        ApexPages.currentPage().getParameters().put('productFamilyId', prdList[0].id);
        ApexPages.currentPage().getParameters().put('productId', prdList[0].id);
        ApexPages.currentPage().getParameters().put('mailAttachment', 'mailAttachment');
        ApexPages.currentPage().getParameters().put('instructor', 'instructor');
        ApexPages.currentPage().getParameters().put('student', 'student');
        ApexPages.currentPage().getParameters().put('pearsonchoices', 'pearsonchoices');
        ApexPages.currentPage().getParameters().put('tableofcontents', 'tableofcontents');
        ApexPages.currentPage().getParameters().put('description', 'description');
        ApexPages.currentPage().getParameters().put('producturl', 'producturl');
        ApexPages.currentPage().getParameters().put('newtothisedition', 'newtothisedition');
        ApexPages.currentPage().getParameters().put('features', 'features');
        ApexPages.currentPage().getParameters().put('abouttheauthor', 'abouttheauthor');
        ApexPages.currentPage().getParameters().put('PricetoBookstore', 'PricetoBookstore');
        ApexPages.currentPage().getParameters().put('Printoffer', 'Printoffer');
        ApexPages.currentPage().getParameters().put('booleanListprice', 'booleanListprice');
        ApexPages.currentPage().getParameters().put('booleanNetprice', 'booleanNetprice');
        ApexPages.currentPage().getParameters().put('Printoffer', 'Printoffer');
        ApexPages.currentPage().getParameters().put('InstantAccess', 'InstantAccess');
        ApexPages.currentPage().getParameters().put('eTextOffer', 'eTextOffer');
        ApexPages.currentPage().getParameters().put('SuggestedRetailPrice', 'SuggestedRetailPrice');
        PS_LeaveBehindController pS_LeaveBehindController = new PS_LeaveBehindController();
        pS_LeaveBehindController.mailAttachment ='mailAttachment';
        List<Apttus_Config2__PriceListItem__c> suggestedPrice = new List<Apttus_Config2__PriceListItem__c>();
       // pS_LeaveBehindController.retrieveProductDetails();
        pS_LeaveBehindController.InnerWrapperClass wrapClassObj = new PS_LeaveBehindController.InnerWrapperClass(contactLst[0]);
        wrapClassObj.selectBox = true;
        pS_LeaveBehindController.listWithContactValues.get(0).selectBox = true;
        pS_LeaveBehindController.getContactValues();
        pS_LeaveBehindController.getselectedContacts();
        pS_LeaveBehindController.addContactToList();
        pS_LeaveBehindController.cancel();
        pS_LeaveBehindController.addContactToListRM();
        String myString = 'StringToBlob';
        Blob myBlob = Blob.valueof(myString);
        pS_LeaveBehindController.documentbody= myBlob;
        pS_LeaveBehindController.documentname ='Test document Name';
        Map<String,String> marketingcontent = new Map<String,String>();
        pS_LeaveBehindController.marketinginfoMap = marketingcontent ;
        pS_LeaveBehindController.mapWithContactRoleAndID.put(contactLst[0].id,'Decision Maker');
        pS_LeaveBehindController.tableofcontents=true;
        pS_LeaveBehindController.description = true;
        pS_LeaveBehindController.newtothisedition =true;
        pS_LeaveBehindController.features = true;
        pS_LeaveBehindController.abouttheauthor = true;
        pS_LeaveBehindController.selected = true;
        pS_LeaveBehindController.PricetoBookstore =true;
        pS_LeaveBehindController.Printoffer = true;
        pS_LeaveBehindController.InstantAccess = true;
        pS_LeaveBehindController.SuggestedRetailPrice = true;
        pS_LeaveBehindController.eTextOffer = true;
        pS_LeaveBehindController.instDescriptions = true;
        pS_LeaveBehindController.studntDescriptions = true;
        List<Pearson_Choice__c> PearsonChoiceList;
        PearsonChoiceList = new List<Pearson_Choice__c>();
        PearsonChoiceList.addall(pc)  ;
        pS_LeaveBehindController.createPdf();
        List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();
        Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
        efa.setFileName('Test document Name');
        efa.setBody(myBlob );
        fileAttachments.add(efa);
        pS_LeaveBehindController.sendEmail();
        pS_LeaveBehindController.sendEmailWithAttachement();
        pS_LeaveBehindController.mailsent = true;
        pS_LeaveBehindController.sNetprice = 0.0;
        pS_LeaveBehindController.sListprice = 0.0;
        pS_LeaveBehindController.inst_status = 'PUB';
        pS_LeaveBehindController.stdnt_status = 'TU';
        pS_LeaveBehindController.emailBody = 'emailBody';
        pS_LeaveBehindController.toAddress.add('test@gmail.com');
        pS_LeaveBehindController.toAddress.add('test@gmail.com');
        pS_LeaveBehindController.toAddress.add('test@gmail.com');
        pS_LeaveBehindController.additionalEmailAddress='test@gmail.com';
        System.assert(true);
        Test.stopTest();        
    }
}