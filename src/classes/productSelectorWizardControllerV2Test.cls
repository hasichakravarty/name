/*************************************************************
@Author     : Accenture IDC 
@Description: Test class for 'oneCRMProductSelectorWizardControllerV2' class
@Date       : 06/25/2015
**************************************************************/
@isTest
public class productSelectorWizardControllerV2Test{
static testMethod void testOneCRMProductSelectorWizardV2()
{
    
    List<Opportunity> listWithOpportunity = new List<Opportunity>();
    Product2 newProduct2 = new Product2();
    List<User> listWithUser = new List<User>();
    List<Product2> listWithProduct2 = new List<Product2>();
    listWithUser  = TestDataFactory.createUser([select Id from Profile where Name =: 'System Administrator'].Id,1);
    test.StartTest();
    listWithOpportunity = TestDataFactory.createnewopportnity(1);
   
    if(listWithUser != null && !listWithUser.isEmpty())
    {
        listWithUser[0].Price_List__c = 'Math & Science';
        insert listWithUser;
    }
    
    List<Apttus_Config2__ClassificationName__c> listWithCategory = new List<Apttus_Config2__ClassificationName__c>();
    Apttus_Config2__ClassificationName__c newCategory = new Apttus_Config2__ClassificationName__c();
    newCategory.Apttus_Config2__HierarchyLabel__c = 'Professional & Career Services';
    newCategory.Name = 'Professional & Career Services';
    listWithCategory.add(newCategory);
    insert listWithCategory;
    
    List<Apttus_Config2__ClassificationHierarchy__c> listWithApttusConfig2ClassificationHierarchy = new List<Apttus_Config2__ClassificationHierarchy__c>();
    Apttus_Config2__ClassificationHierarchy__c newApttusConfig2ClassificationHierarchy = new Apttus_Config2__ClassificationHierarchy__c();
    newApttusConfig2ClassificationHierarchy.Apttus_Config2__HierarchyId__c =  listWithCategory[0].Id;
    newApttusConfig2ClassificationHierarchy.Apttus_Config2__Label__c = '(BIM) Building Information Modeling';
    newApttusConfig2ClassificationHierarchy.Name = '(BIM) Building Information Modeling';
    newApttusConfig2ClassificationHierarchy.Type__c = 'Course';
    listWithApttusConfig2ClassificationHierarchy.add(newApttusConfig2ClassificationHierarchy);
    insert listWithApttusConfig2ClassificationHierarchy;
    
    List<Opportunity_Pearson_Course_Code__c> listWithOpportunityPearsonCourseCode = new List<Opportunity_Pearson_Course_Code__c>();
    Opportunity_Pearson_Course_Code__c newOpportunityPearsonCourseCode;
    newOpportunityPearsonCourseCode = new Opportunity_Pearson_Course_Code__c();
    newOpportunityPearsonCourseCode.Opportunity__c = listWithOpportunity[0].Id;
    newOpportunityPearsonCourseCode.Pearson_Course_Code_Name__c = listWithApttusConfig2ClassificationHierarchy[0].Id;
    newOpportunityPearsonCourseCode.Primary__c = true;
    listWithOpportunityPearsonCourseCode.add(newOpportunityPearsonCourseCode);
    insert listWithOpportunityPearsonCourseCode;
    
    newProduct2.Name = 'X-FULWIL & RIO SALADO - COLLEGE WRITERS REFERENCE:2009 MLA UPD EDTN, 2/e';
    newProduct2.Apttus_Config2__ConfigurationType__c = 'Bundle';
    newProduct2.Author__c = 'FULWIL & RIO SALADO';
    newProduct2.Copyright_Year__c = '2010';
    listWithProduct2.add(newProduct2);
    insert listWithProduct2;
    
    List<Marketing_Information__c> listWithMarketingInformation = new List<Marketing_Information__c>();
    Marketing_Information__c newMarketingInformation = new Marketing_Information__c();
    newMarketingInformation.Type__c = 'Rep Tools';
    newMarketingInformation.Family__c = listWithProduct2[0].Id;
    newMarketingInformation.Sub_Type__c = 'Features';
    listWithMarketingInformation.add(newMarketingInformation);
    insert listWithMarketingInformation;
    
    List<Apttus_Config2__ProductClassification__c> listWithProductClassification = new List<Apttus_Config2__ProductClassification__c>();
    Apttus_Config2__ProductClassification__c newApttusConfig2ProductClassification = new Apttus_Config2__ProductClassification__c();
    newApttusConfig2ProductClassification.Apttus_Config2__ClassificationId__c = listWithApttusConfig2ClassificationHierarchy[0].Id;
    newApttusConfig2ProductClassification.Apttus_Config2__ProductId__c = listWithProduct2[0].Id;
    listWithProductClassification.add(newApttusConfig2ProductClassification);
    insert listWithProductClassification;
    
    List<PriceBook2> listWithPriceBook = new List<PriceBook2>();
    PriceBook2 newPriceBook = new PriceBook2();
    newPriceBook.Name = 'Standard Price Book';
    listWithPriceBook.add(newPriceBook);
    insert listWithPriceBook;
        
    List<PriceBookEntry> listWithPriceBookEntry = new List<PriceBookEntry>();
    PriceBookEntry newPriceBookEntry = new PriceBookEntry();
    newPriceBookEntry.Pricebook2Id = Test.getStandardPricebookId();//listWithPriceBook[0].Id;
    newPriceBookEntry.UnitPrice = 10.0;
    newPriceBookEntry.Product2Id = listWithProduct2[0].Id; 
    newPriceBookEntry.IsActive = true;
    listWithPriceBookEntry.add(newPriceBookEntry);
    insert listWithPriceBookEntry;
    
    List<OpportunityLineItem> listWithOpportunityProduct = new List<OpportunityLineItem>();
    OpportunityLineItem newOpportunityProduct = new OpportunityLineItem();
    newOpportunityProduct.Quantity = 12;
    newOpportunityProduct.UnitPrice = 10.0;
    newOpportunityProduct.PricebookEntryId = listWithPriceBookEntry[0].Id;
    newOpportunityProduct.OpportunityId = listWithOpportunity[0].Id;
    listWithOpportunityProduct.add(newOpportunityProduct);
    insert listWithOpportunityProduct;
   
    List<SelectOption> productFieldLst = new List<SelectOption>();
    productFieldLst.add(new SelectOption('Name', 'Name'));
    
    List<SelectOption> conditionLst = new List<SelectOption>();
    conditionLst.add(new SelectOption('equals', 'equals'));
      
    List<SelectOption> searchType = new List<SelectOption>();
    searchType.add(new SelectOption('Product Family', 'Product Family'));
                
    test.StopTest();
    System.runAs(listWithUser[0])
    {
        PageReference pageRef = Page.oneCRMProductSelectorWizardV2;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('oppId', listWithOpportunity[0].Id);
        oneCRMProductSelectorWizardControllerV2 fireMethods = new oneCRMProductSelectorWizardControllerV2();
        fireMethods.indexForPearsonChoiceRedirection = 0;
        fireMethods.productFamilyIdFromURL = listWithProduct2[0].Id; 
        fireMethods.getMarketingInformationDetails();
        fireMethods.selectedSearchType = 'Product';
        fireMethods.opptyProdId = listWithOpportunity[0].Id;
        fireMethods.productFamilyIdRedirect = '';
        fireMethods.opportunityIDRedirect = '';
        fireMethods.selectPearsonChoiceRecords = false;
        fireMethods.familyTagId = listWithOpportunity[0].Id;
        fireMethods.quantity = '10';
        fireMethods.FileId = listWithOpportunity[0].Id;
        List<SelectOption> s = new List<SelectOption>();
        List<Apttus_Config2__RelatedProduct__c> d = new List<Apttus_Config2__RelatedProduct__c>();
        fireMethods.options = s;
        fireMethods.listForInstructorResource = d;
        fireMethods.listForStudentResource = d;
        fireMethods.listForeLearningAssessment = d;
        fireMethods.addToOptyProductsList = d;
        fireMethods.descriptionRepToolsFlag = false;
        fireMethods.appropriateCoursesRepToolsFlag = false;
        fireMethods.reviewsRepToolsFlag = true;
        fireMethods.abouttheAuthorRepToolsFlag = true;
        fireMethods.interviewTabbingGuideRepToolsFlag = true;
        fireMethods.technologyTipsRepToolsFlag = true;
        fireMethods.adoptionListRepToolsFlag = true;
        fireMethods.cutPasteEMailsRepToolsFlag = true;
        fireMethods.repCopyRepToolsFlag = true;
        fireMethods.forthcomingEditionRepToolsFlag = true;
        fireMethods.strategyRepToolsFlag = true;
        fireMethods.strengthsWeaknessesRepToolsFlag = true;
        fireMethods.checkListRepToolsFlag = true;
        fireMethods.descriptionAboutThisProdFlag = true;
        fireMethods.appropriateCoursesAboutThisProdFlag = true;
        fireMethods.reviewsAboutThisProdFlag = true;
        fireMethods.abouttheAuthorAboutThisProdFlag = true;
        fireMethods.interviewTabbingGuideAboutThisProdFlag = true;
        fireMethods.technologyTipsAboutThisProdFlag = true;
        fireMethods.adoptionListAboutThisProdFlag = true;
        fireMethods.cutPasteEMailsAboutThisProdFlag = true;
        fireMethods.repCopyAboutThisProdFlag = true;
        fireMethods.forthcomingEditionAboutThisProdFlag = true;
        fireMethods.strategyAboutThisProdFlag = true;
        fireMethods.strengthsWeaknessesAboutThisProdFlag = true;
        fireMethods.checkListAboutThisProdFlag = true;
        fireMethods.QueryString = '';
        fireMethods.disablePrevious = true;
        Marketing_Information__c m = new Marketing_Information__c();
        fireMethods.content = m;
        fireMethods.relevance = '';
        Set<Id> setWithProdId = new Set<Id>();
        setWithProdId.add(listWithProduct2[0].Id);
        fireMethods.productIdsSet = setWithProdId;
        List<Product2>  p = new List<Product2>();
        fireMethods.productsList = p;
        fireMethods.selectedValueFromPopup = '';
        fireMethods.digitalproductfamily = d;
        fireMethods.ProductFileId = listWithProduct2[0].Id;
        fireMethods.descriptionAboutThisProdFlagForProduct = true;
        fireMethods.appropriateCoursesAboutThisProdFlagForProduct = true;
        fireMethods.reviewsAboutThisProdFlagForProduct = true;
        fireMethods.abouttheAuthorAboutThisProdFlagForProduct = true;
        fireMethods.interviewTabbingGuideAboutThisProdFlagForProduct = true;
        fireMethods.technologyTipsAboutThisProdFlagForProduct = true;
        fireMethods.adoptionListAboutThisProdFlagForProduct = true;
        fireMethods.cutPasteEMailsAboutThisProdFlagForProduct = true;
        fireMethods.repCopyAboutThisProdFlagForProduct = true;
        fireMethods.forthcomingEditionAboutThisProdFlagForProduct = true;
        fireMethods.strategyAboutThisProdFlagForProduct = true;
        fireMethods.strengthsWeaknessesAboutThisProdFlagForProduct = true;
        fireMethods.checkListAboutThisProdFlagForProduct = true;
        fireMethods.CatalogRelatedProductId = listWithProduct2[0].Id;
        fireMethods.subtype = '';
        fireMethods.onClickLinkAbout = true;
        fireMethods.onClickLinkAboutProduct = true;
        fireMethods.onClickLinkRep = true;
        fireMethods.currParent = listWithCategory[0].Id;
        fireMethods.CountTotalRecords1 = 10;
        fireMethods.QueryLimit = 3;
        fireMethods.OffsetSize = 10;
        fireMethods.listWithProdFamilyCount = 9;
        fireMethods.indexOfListToSetQty = 0;
        fireMethods.valueOfQty = 10;
        fireMethods.createOpplineitems();
        fireMethods.addNewFilter();
        fireMethods.displayProductFamilyOnLoad = true;
        fireMethods.displayProductFamilyOnSerach = true;
        fireMethods.displayOnPearsonClick = true;
        fireMethods.fromTaxanomy = true;
        fireMethods.searchFilterResultsFlag = true;
        fireMethods.ProductId = listWithProduct2[0].Id;
        fireMethods.addToOppty();
        fireMethods.selectedSearchType = 'Product Family';
        fireMethods.PreviousSearch();
        fireMethods.fromTaxanomy = true;
        fireMethods.NextSearchPearsonClick();
        fireMethods.fromTaxanomy = true;
        fireMethods.PreviousSearchPearsonClick();
        fireMethods.NextFilterSearch();
        fireMethods.PreviousFilterSearch();
        fireMethods.setQuantity();
        fireMethods.checkPermission();
        fireMethods.selectedCondition = 'equals';
        fireMethods.selectedSearchType = 'Product';
        fireMethods.OffsetSize = 10;
        oneCRMProductSelectorWizardControllerV2.dynamicAddFilterSearch wrapperInstance = new oneCRMProductSelectorWizardControllerV2.dynamicAddFilterSearch(productFieldLst,conditionLst,searchType,'Product','Product','Equals',true,1);
        fireMethods.listWithSelectOptions.add(wrapperInstance);
        
        wrapperInstance.selectedProductFilterValue  = 'Publisher';
        fireMethods.listWithSelectOptions.add(wrapperInstance);
        fireMethods.searchResults();
                        
        wrapperInstance.selectedProductFilterValue  = 'Copyright Year';
        fireMethods.listWithSelectOptions.add(wrapperInstance);
        fireMethods.searchResults();
        
        wrapperInstance.selectedProductFilterValue  = 'Edition';
        fireMethods.listWithSelectOptions.add(wrapperInstance);
        fireMethods.searchResults();
        
        wrapperInstance.selectedProductFilterValue  = 'Instock Date';
        wrapperInstance.searchText = '1989/10/10';
        fireMethods.listWithSelectOptions.add(wrapperInstance);
        fireMethods.searchResults();
        
        wrapperInstance.selectedProductFilterValue  = 'Platform';
        fireMethods.listWithSelectOptions.add(wrapperInstance);
        fireMethods.searchResults();
        
        wrapperInstance.selectedProductFilterValue  = 'Author';
        fireMethods.listWithSelectOptions.add(wrapperInstance);
        fireMethods.searchResults();
        
        fireMethods.isGrandParentChanged = true;
        fireMethods.productFamilyIdFromURL = null;
        fireMethods.productCatalogIdFromURL = null;
        fireMethods.browseOnDefault();
        
    }
}

static testMethod void testOneCRMProductFamilyDetailPage()
{
    List<Opportunity> listWithOpportunity = new List<Opportunity>();
    Product2 newProduct2 = new Product2();
    List<User> listWithUser = new List<User>();
    List<Product2> listWithProduct2 = new List<Product2>();
    listWithUser  = TestDataFactory.createUser([select Id from Profile where Name =: 'System Administrator'].Id,1);
    test.StartTest();
    listWithOpportunity = TestDataFactory.createnewopportnity(1);
    listWithOpportunity[0].Selling_Period__c = '2015 - Fall'; 
    update listWithOpportunity;
    if(listWithUser != null && !listWithUser.isEmpty())
    {
        listWithUser[0].Price_List__c = 'Math & Science';
        insert listWithUser;
    }
    
    listWithOpportunity[0].OwnerId = listWithUser[0].Id;
    update listWithOpportunity;
    
    List<PriceBook2> listWithPriceBook = new List<PriceBook2>();
    PriceBook2 newPriceBook = new PriceBook2();
    newPriceBook.Name = 'Standard Price Book';
    newPriceBook.isActive = true;
    listWithPriceBook.add(newPriceBook);
    insert listWithPriceBook;
           
    newProduct2.Name = 'X-FULWIL & RIO SALADO - COLLEGE WRITERS REFERENCE:2009 MLA UPD EDTN, 2/e';
    newProduct2.Apttus_Config2__ConfigurationType__c = 'Bundle';
    newProduct2.Author__c = 'FULWIL & RIO SALADO';
    newProduct2.Copyright_Year__c = '2010';
    listWithProduct2.add(newProduct2);
    insert listWithProduct2;
   
    List<Apttus_Config2__RelatedProduct__c> listWithApttusConfig2RelatedProduct = new List<Apttus_Config2__RelatedProduct__c>();
    Apttus_Config2__RelatedProduct__c newApttusConfig2RelatedProduct = new Apttus_Config2__RelatedProduct__c();
    newApttusConfig2RelatedProduct.Apttus_Config2__ProductId__c = listWithProduct2[0].Id;
    newApttusConfig2RelatedProduct.Apttus_Config2__RelatedProductId__c = listWithProduct2[0].Id;
    newApttusConfig2RelatedProduct.Instructor_Resource__c = true;
    newApttusConfig2RelatedProduct.Student_Resource__c = true;
    newApttusConfig2RelatedProduct.Relation_Package__c = true;
    newApttusConfig2RelatedProduct.Component_Package__c = true;
    newApttusConfig2RelatedProduct.PSAM__c = true;
    listWithApttusConfig2RelatedProduct.add(newApttusConfig2RelatedProduct);
    insert listWithApttusConfig2RelatedProduct; 
    
    List<Apttus_Config2__ClassificationName__c> listWithApttusConfig2ClassificationName = new List<Apttus_Config2__ClassificationName__c>();
    Apttus_Config2__ClassificationName__c newApttusConfig2ClassificationName = new Apttus_Config2__ClassificationName__c();
    newApttusConfig2ClassificationName.Apttus_Config2__Active__c = true;
    newApttusConfig2ClassificationName.Name = 'Test';
    newApttusConfig2ClassificationName.DM_Identifier__c = '1234';
    newApttusConfig2ClassificationName.Apttus_Config2__HierarchyLabel__c = 'Test';
    listWithApttusConfig2ClassificationName.add(newApttusConfig2ClassificationName);
    insert listWithApttusConfig2ClassificationName;
    
    List<Apttus_Config2__PriceList__c> listWithApttusConfig2PriceList = new List<Apttus_Config2__PriceList__c>();
    Apttus_Config2__PriceList__c newApttusConfig2PriceList = new Apttus_Config2__PriceList__c();
    newApttusConfig2PriceList.Name = 'Math & Science';
    newApttusConfig2PriceList.Apttus_Config2__Active__c = true;
    newApttusConfig2PriceList.Apttus_Config2__Type__c = 'Standard';
    listWithApttusConfig2PriceList.add(newApttusConfig2PriceList);
    insert listWithApttusConfig2PriceList;


    List<Apttus_Config2__PriceListItem__c> listWithApttusConfig2PriceListItem = new List<Apttus_Config2__PriceListItem__c>();
    Apttus_Config2__PriceListItem__c newApttusConfig2PriceListItem = new Apttus_Config2__PriceListItem__c();
    newApttusConfig2PriceListItem.Apttus_Config2__ProductId__c = listWithProduct2[0].Id;
    newApttusConfig2PriceListItem.Apttus_Config2__Active__c = true;
    newApttusConfig2PriceListItem.Apttus_Config2__PriceListId__c = listWithApttusConfig2PriceList[0].Id;
    listWithApttusConfig2PriceListItem.add(newApttusConfig2PriceListItem);
    insert listWithApttusConfig2PriceListItem;
    
    List<Marketing_Information__c> listWithMarketingInformation = new List<Marketing_Information__c>();
    Marketing_Information__c newMarketingInformation = new Marketing_Information__c();
    newMarketingInformation.Type__c = 'About this Product';
    newMarketingInformation.Family__c = listWithProduct2[0].Id;
    newMarketingInformation.Sub_Type__c = 'Features';
    listWithMarketingInformation.add(newMarketingInformation);
    insert listWithMarketingInformation;
    
    List<Pearson_Choice__c> listWithPearsonChoice = new List<Pearson_Choice__c>();
    Pearson_Choice__c newPearsonChoice = new Pearson_Choice__c();
    newPearsonChoice.Name = 'TestPearsonChoice';
    newPearsonChoice.Product_Family__c = listWithProduct2[0].Id;
    newPearsonChoice.Brand__c = 'Mastering';
    newPearsonChoice.Bookstore__c = listWithProduct2[0].Id;
    newPearsonChoice.Bookstore_Price__c  = 234;
    listWithPearsonChoice.add(newPearsonChoice);
    insert listWithPearsonChoice;
    
    test.StopTest();
    System.debug('$$$$$$$$'+listWithPriceBook);
    String cartProdFromURL = listWithProduct2[0].Id+',10,';
    String samplecartcontents = listWithProduct2[0].Id+',10,';
    
    List<SelectOption> productFieldLst = new List<SelectOption>();
    productFieldLst.add(new SelectOption('Name', 'Name'));
    
    List<SelectOption> conditionLst = new List<SelectOption>();
    conditionLst.add(new SelectOption('equals', 'equals'));
      
    List<SelectOption> searchType = new List<SelectOption>();
    searchType.add(new SelectOption('Product Family', 'Product Family'));
    
    System.runAs(listWithUser[0])
    {
        PageReference pageRef = Page.OneCRMProductFamilyDetailPage;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('oppId', listWithOpportunity[0].Id);
        ApexPages.currentPage().getParameters().put('productFamilyId',listWithProduct2[0].Id);
        ApexPages.currentPage().getParameters().put('cartProdFromURL',cartProdFromURL);
        ApexPages.currentPage().getParameters().put('samplecartcontents',samplecartcontents);
        ApexPages.currentPage().getParameters().put('selectedFilterbyValue','Contains eText');
        ApexPages.currentPage().getParameters().put('selectedRow','1');
        ApexPages.currentPage().getParameters().put('pearsonCodeIdFromProdFamily',listWithApttusConfig2ClassificationName[0].Id);
        oneCRMProductSelectorWizardControllerV2 fireMethods = new oneCRMProductSelectorWizardControllerV2();
        oneCRMProductSelectorWizardControllerV2.pearsonChoiceToSendEmail wrapperInstance = new oneCRMProductSelectorWizardControllerV2.pearsonChoiceToSendEmail(listWithPearsonChoice[0]); 
        fireMethods.getMarketingInformationDetailsForProduct();
        fireMethods.selectedSearchType = 'Product Family';
        fireMethods.pearsonChoiceIndex = 0;
        fireMethods.selectedCondition = 'equals';
        fireMethods.OffsetSize = 10;
        fireMethods.fromTaxanomy = true;
        fireMethods.rowToRemove = 0;
        fireMethods.InitCartandURL();
        fireMethods.relatedProductId1 = listWithApttusConfig2RelatedProduct[0].Id;
        fireMethods.CatalogMarketId = listWithProduct2[0].Id;
        fireMethods.createOpplineitems();
        fireMethods.checkPermission();
        fireMethods.serachOnDefault();
        fireMethods.searchTypeList();
        fireMethods.OffsetSize = 10;
        fireMethods.getPearsonChoices();
        fireMethods.pearsonChoiceAddToOppty();
        fireMethods.addToOpptyFromPearsonChoice();
        oneCRMProductSelectorWizardControllerV2.dynamicAddFilterSearch wrapperInstanceProdFamily = new oneCRMProductSelectorWizardControllerV2.dynamicAddFilterSearch(productFieldLst,conditionLst,searchType,'Product Family','Product Family','Equals',true,1);
        fireMethods.listWithSelectOptions.add(wrapperInstanceProdFamily);
        wrapperInstanceProdFamily.selectedProductFilterValue  = 'Name';
        fireMethods.listWithSelectOptions.add(wrapperInstanceProdFamily);
        fireMethods.searchResults();
        wrapperInstanceProdFamily.selectedProductFilterValue  = 'Brand';
        fireMethods.listWithSelectOptions.add(wrapperInstanceProdFamily);
        fireMethods.searchResults();
        wrapperInstanceProdFamily.selectedProductFilterValue  = 'Platform';
        fireMethods.listWithSelectOptions.add(wrapperInstanceProdFamily);
        fireMethods.searchResults();
        wrapperInstanceProdFamily.selectedProductFilterValue  = 'Relevance';
        fireMethods.listWithSelectOptions.add(wrapperInstanceProdFamily);
        wrapperInstanceProdFamily.rowNumber = 1;
        fireMethods.changeSerachTextType();
        fireMethods.searchResults();
        wrapperInstanceProdFamily.selectedProductFilterValue  = 'Status';
        wrapperInstanceProdFamily.rowNumber = 1;
        fireMethods.listWithSelectOptions.add(wrapperInstanceProdFamily);
        fireMethods.searchResults();
        fireMethods.changeSerachTextType();
        fireMethods.getProducts();
        fireMethods.getProductFamilys();
        fireMethods.displayProductFamilyOnLoad = true;
        fireMethods.displayProductFamilyOnSerach = true;
        fireMethods.displayOnPearsonClick = true;
        fireMethods.fromTaxanomy = true;
        fireMethods.searchFilterResultsFlag = true;
        fireMethods.addToOppty();
        fireMethods.addToOpty();
        fireMethods.removeProdCart();
        fireMethods.OffsetSize = 10;
        fireMethods.searchProductFamilyFilter();
        fireMethods.removeFilter();
        fireMethods.currParent = listWithApttusConfig2ClassificationName[0].Id;
        fireMethods.pearsonCodeId = listWithApttusConfig2ClassificationName[0].Id;
        fireMethods.productFamily();
        fireMethods.getPrice();
        fireMethods.isNone();
        fireMethods.isLoad();
        fireMethods.getProdFamily();
        fireMethods.Next();
        fireMethods.Previous();
        fireMethods.getPageNumber();
        fireMethods.closePopup();
        fireMethods.showPopup();
        fireMethods.getValue();
        fireMethods.showPopup1();
        fireMethods.getProductFamilyDetails();
        fireMethods.getProductCatalogDetails();
        fireMethods.returnToProdSelection();
        fireMethods.getAddToOppty();
        fireMethods.getChildDetailsForProduct();
        fireMethods.getProdMap();
        fireMethods.getsetWithRelatedPkgID1();
        fireMethods.setTabInFocus();
        fireMethods.getComponentDetails();
        fireMethods.getProductPackageDetails();
        fireMethods.getPackageDetails();
        fireMethods.getInstructorResourceDetails();
        fireMethods.getStudentResourceDetails();
        fireMethods.getPriceForInstStud();
        fireMethods.getMarketingDetails();
        fireMethods.getMarketingDetailsForRep();
        fireMethods.getMarketingDetailsForProduct();
        fireMethods.getStatuses();
        fireMethods.getCategories();
        fireMethods.getCompetitiveDetails();
        fireMethods.showMarketPopup();
        fireMethods.showvalueinpopup();
        fireMethods.closePearsonChoicePopUp();
        fireMethods.redirectProduct();
        fireMethods.getProductfamilymembers(listWithProduct2[0].Id);
        fireMethods.formsampleurl();
        fireMethods.getListProductsToSample();
        fireMethods.getProductSample(listWithProduct2[0].Id);
        fireMethods.submitsampleorder();
        oneCRMProductSelectorWizardControllerV2.getRoleSubordinateUsers(listWithUser[0].Id);
        fireMethods.dsproduct();
        fireMethods.removeSampleCart();
        fireMethods.checkforpricelist(listWithProduct2[0].Id);
        fireMethods.getMarketingMaterialContent();
        fireMethods.getContacts();
        fireMethods.setCurrParentInClass();
        fireMethods.cancel();
        fireMethods.returntoopportunity();
        fireMethods.returntoProductSelectorWizardV2();
        fireMethods.addContactToList();
        fireMethods.booleanBookstoreprice = true;
        fireMethods.booleanSelectedOffer = true;
        fireMethods.booleanInstantAccessPrice = true;
        fireMethods.booleaneTextOfferPrice = true;
        fireMethods.booleanPrintOfferPricec = true;
        fireMethods.ActionOK();
        fireMethods.NextSearch();
        fireMethods.setSearchText();
        fireMethods.indexForPearsonChoiceRedirection = 0;
        fireMethods.redirectPearsonChoice();
        fireMethods.selectedCondition = 'equals';
        fireMethods.selectedSearchType = 'Product';
        fireMethods.searchTypeList();
        fireMethods.getChildDetails();
        fireMethods.getFamMap();
        fireMethods.getsetWithRelatedPkgID2();
        fireMethods.indexOfListTosampleQty = 0;
        fireMethods.valueOfsampleQty = 10;
        fireMethods.setSampleQuantity();
        
    }
   
}
static testMethod void testProductCatalogDetailPage()
{
    List<Opportunity> listWithOpportunity = new List<Opportunity>();
    Product2 newProduct2 = new Product2();
    List<User> listWithUser = new List<User>();
    List<Product2> listWithProduct2 = new List<Product2>();
    listWithUser  = TestDataFactory.createUser([select Id from Profile where Name =: 'System Administrator'].Id,1);
    test.StartTest();
    listWithOpportunity = TestDataFactory.createnewopportnity(1);
    listWithOpportunity[0].Spring__c = 0;
    update listWithOpportunity;
    if(listWithUser != null && !listWithUser.isEmpty())
    {
        listWithUser[0].Price_List__c = 'Math & Science';
        insert listWithUser;
    }
    
    newProduct2.Name = 'X-FULWIL & RIO SALADO - COLLEGE WRITERS REFERENCE:2009 MLA UPD EDTN, 2/e';
    newProduct2.Apttus_Config2__ConfigurationType__c = 'Option';
    newProduct2.Author__c = 'FULWIL & RIO SALADO';
    newProduct2.Copyright_Year__c = '2010';
    listWithProduct2.add(newProduct2);
    insert listWithProduct2;
     
    List<Apttus_Config2__RelatedProduct__c> listWithApttusConfig2RelatedProduct = new List<Apttus_Config2__RelatedProduct__c>();
    Apttus_Config2__RelatedProduct__c newApttusConfig2RelatedProduct = new Apttus_Config2__RelatedProduct__c();
    newApttusConfig2RelatedProduct.Apttus_Config2__ProductId__c = listWithProduct2[0].Id;
    newApttusConfig2RelatedProduct.Apttus_Config2__RelatedProductId__c = listWithProduct2[0].Id;
    newApttusConfig2RelatedProduct.Instructor_Resource__c = true;
    newApttusConfig2RelatedProduct.Student_Resource__c = true;
    newApttusConfig2RelatedProduct.Relation_Package__c = true;
    newApttusConfig2RelatedProduct.Component_Package__c = true;
    newApttusConfig2RelatedProduct.PSAM__c = true;
    listWithApttusConfig2RelatedProduct.add(newApttusConfig2RelatedProduct);
    insert listWithApttusConfig2RelatedProduct; 
      
    test.StopTest();
    System.runAs(listWithUser[0])
    {
        PageReference pageRef = Page.ProductCatalogDetailPage;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('oppId', listWithOpportunity[0].Id);
        ApexPages.currentPage().getParameters().put('productId',listWithProduct2[0].Id);
        oneCRMProductSelectorWizardControllerV2 fireMethods = new oneCRMProductSelectorWizardControllerV2();
        fireMethods.fromTaxanomy = true;
        fireMethods.addToOptyProductId = listWithProduct2[0].Id;
        fireMethods.addToOppty();
        fireMethods.checkurllength(listWithProduct2[0].Id);
        fireMethods.getComponentDetails();
        fireMethods.getContacts();
        fireMethods.getProductPackageDetails();
        fireMethods.productsToSample=null;
        fireMethods.selectedproducts=null;
        fireMethods.productfamily();
        fireMethods.productidlist=null;
        fireMethods.prodId=null;
        fireMethods.productMode=null;
        fireMethods.sampletabfocus='';
        fireMethods.indexOfListTosampleQty=1;
        fireMethods.valueOfsampleQty=10;
        fireMethods.selectedSearchType = 'Product';
        List<SelectOption> productFieldLst = new List<SelectOption>();
        productFieldLst.add(new SelectOption('Name', 'Name'));
    
        List<SelectOption> conditionLst = new List<SelectOption>();
        conditionLst.add(new SelectOption('equals', 'equals'));
      
        List<SelectOption> searchType = new List<SelectOption>();
        searchType.add(new SelectOption('Product Family', 'Product Family'));

        oneCRMProductSelectorWizardControllerV2.dynamicAddFilterSearch wrapperInstance = new oneCRMProductSelectorWizardControllerV2.dynamicAddFilterSearch(productFieldLst,conditionLst,searchType,'Product','Product','Equals',true,1);
        fireMethods.listWithSelectOptions.add(wrapperInstance);
        wrapperInstance.selectedProductFilterValue  = 'Publisher';
        wrapperInstance.selectedCondition = 'starts with';
        fireMethods.searchResults();
        
        wrapperInstance.selectedProductFilterValue  = 'Product';
        wrapperInstance.selectedCondition = 'starts with';
        fireMethods.searchResults();
       
        wrapperInstance.selectedProductFilterValue  = 'ISBN10';
        wrapperInstance.selectedCondition = 'starts with';
        fireMethods.searchResults();
        
        wrapperInstance.selectedProductFilterValue  = 'ISBN13';
        wrapperInstance.selectedCondition = 'starts with';
        fireMethods.searchResults();
       
        wrapperInstance.selectedProductFilterValue  = 'Brand';
        wrapperInstance.selectedCondition = 'starts with';
        fireMethods.searchResults();
      
        wrapperInstance.selectedProductFilterValue  = 'Sub Brand';
        wrapperInstance.selectedCondition = 'starts with';
        fireMethods.searchResults();
        wrapperInstance.selectedProductFilterValue  = 'Sub Brand';
        wrapperInstance.selectedCondition = 'contains';
        fireMethods.searchResults();
     
        wrapperInstance.selectedProductFilterValue  = 'Category';
        wrapperInstance.selectedCondition = 'starts with';
        fireMethods.searchResults();
      
        wrapperInstance.selectedProductFilterValue  = 'Contains eText';
        wrapperInstance.selectedCondition = 'starts with';
        fireMethods.searchResults();
      
        wrapperInstance.selectedProductFilterValue  = 'Copyright Year';
        wrapperInstance.selectedCondition = 'not equal to';
        fireMethods.searchResults();
        wrapperInstance.selectedProductFilterValue  = 'Copyright Year';
        wrapperInstance.selectedCondition = 'starts with';
        fireMethods.searchResults();
        
        wrapperInstance.selectedProductFilterValue  = 'Edition';
        wrapperInstance.selectedCondition = 'not equal to';
        fireMethods.searchResults();
        wrapperInstance.selectedProductFilterValue  = 'Edition';
        wrapperInstance.selectedCondition = 'starts with';
        fireMethods.searchResults();
       
        wrapperInstance.selectedProductFilterValue  = 'Instock Date';
        wrapperInstance.searchText = '1989/10/10';
        wrapperInstance.selectedCondition = 'not equal to';
        fireMethods.searchResults();
        wrapperInstance.selectedProductFilterValue  = 'Instock Date';
        wrapperInstance.searchText = '1989/10/10';
        wrapperInstance.selectedCondition = 'starts with';
        fireMethods.searchResults();
        
        wrapperInstance.selectedProductFilterValue  = 'Platform';
        wrapperInstance.selectedCondition = 'not equal to';
        fireMethods.searchResults();
        wrapperInstance.selectedProductFilterValue  = 'Platform';
        wrapperInstance.selectedCondition = 'starts with';
        fireMethods.searchResults();
        
        wrapperInstance.selectedProductFilterValue  = 'Author';
        wrapperInstance.selectedCondition = 'not equal to';
        fireMethods.searchResults();
        wrapperInstance.selectedProductFilterValue  = 'Author';
        wrapperInstance.selectedCondition = 'starts with';
        fireMethods.searchResults();
        
        fireMethods.isGrandParentChanged = true;
        Map <Id,List<Apttus_Config2__ClassificationHierarchy__c>> j = new Map <Id,List<Apttus_Config2__ClassificationHierarchy__c>>();
        Map <Id,Boolean>  v = new Map <Id,Boolean>();
        fireMethods.mapChild = j;
        fireMethods.mapChildHasNext = v;
        oneCRMProductSelectorWizardControllerV2.productFamilyClass ProdFamClass;
        oneCRMProductSelectorWizardControllerV2.ProductFamilyClass listOfproductFamilyClass = ProdFamClass;
        fireMethods.browseOnDefault();
        fireMethods.serachOnDefault();
        fireMethods.pearsonChoiceSampling();
        fireMethods.userselectedproducts();
        fireMethods.selectedSearchType = 'Product';
        fireMethods.PreviousSearch();
        fireMethods.NextSearch();
        fireMethods.getProductfamilymembers(listWithProduct2[0].Id);
        
    }
}

}