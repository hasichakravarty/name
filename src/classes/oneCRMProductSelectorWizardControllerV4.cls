/*************************************************************
@Author     : Accenture IDC 
@Description: Controller to 'oneCRMProductSelectorWizard' page - contains logic to add product(s) to cart
@Date       : 04/01/2015
**************************************************************/
public class oneCRMProductSelectorWizardControllerV4 {
    /*Variable Declaration Start */
    public Integer indexForPearsonChoiceRedirection {
        get;
        set;
    }
    public String errorString {
        get;
        set;
    }
    public ID opptyIdForPermissionCheck {
        get;
        set;
    }
    public ID opptyProdId {
        get;
        set;
    }
    public Integer indexOfListToSetQty {
        get;
        set;
    }
    public Integer valueOfQty {
        get;
        set;
    }
    public String productFamilyIdRedirect {
        get;
        set;
    }
    public String opportunityIDRedirect {
        get;
        set;
    }
     public String backtorelatedlist{
        get;
        set;
     }
    
    public Map < Id, Double > mapIDWithListprice;
    public Id opportunityID {
        get;
        set;
    } //Added by Kyama For Displaying Existing OpportunityPearsonCourseCodes.
    public List < Apttus_Config2__ProductClassification__c > listWithProdFamily {
            get;
            set;
        } //Added by Kyama For Displaying Existing OpportunityPearsonCourseCodes.
    public List < Opportunity_Pearson_Course_Code__c > existingPearsonCourseList {
            get;
            set;
        } //Added by Kyama For Displaying Existing OpportunityPearsonCourseCodes.
    public List < SelectOption > productFieldLst {
            get;
            set;
        } //Added For Custom Filter Search
    public List < SelectOption > conditionLst {
            get;
            set;
        } //Added For Custom Filter Search
    public boolean selectPearsonChoiceRecords {
        get;
        set;
    }
    public boolean fromTaxanomy {
        get;
        set;
    }
    public String cartProdFromURL {
        get;
        set;
    }
    public boolean displayOnPearsonClick {
        get;
        set;
    }
    public Id redirectProductId {
        get;
        set;
    }
    public Id pearsonCodeId {
        get;
        set;
    }
    public Id familyTagId {
        get;
        set;
    }
    public boolean searchMessage {
        get;
        set;
    }
    public boolean searchFilterResults {
        get;
        set;
    }
    public boolean oppCartEmpty {
        get;
        set;
    }
    public Map < Id, Pearson_Choice__c > mapWithPearsonChoice {
        get;
        set;
    }
    public List < Id > listWithPearsonProduct {
        get;
        set;
    }
    public boolean renderAddToOpptyPopUp {
        get;
        set;
    }
    public List < Pearson_Choice__c > listWithAddToOpptyProd {
        get;
        set;
    }
    public Integer pearsonChoiceIndex {
        get;
        set;
    }
    public List < pearsonChoiceWrapperClass > personChoiceWrapperList {
        get;
        set;
    }
    public set < ID > setWithPearsonCodeID;
    public set < ID > setWithProductFamilyID;
    public Map < Id, Double > mapIDWithNetprice;
    public List < dynamicAddFilterSearch > listWithSelectOptions {
        get {
            return listWithSelectOptions;
        }
        set;
    }
    public dynamicAddFilterSearch dynamicAddFilterSearch;
    public List < Apttus_Config2__RelatedProduct__c > listWithPSellFamily {
        get;
        set;
    }
    public String quantity {
        get;
        set;
    }
    public Integer rowToRemove {
        get;
        set;
    }
    public Id productFamilyIdFromURL;
    public product2 product2FamilyResult {
        get;
        set;
    }
    public boolean isDisplaySearchPanel {
        get;
        set;
    }
    public List < Attachment > bookIconFromAttachment {
        get;
        set;
    }
    public Id FileId {
        get;
        set;
    }
    public String selectedSearchType {
        get;
        set;
    }
    public List < SelectOption > searchType {
        get;
        set;
    }
    public List < SelectOption > options {
        get;
        set;
    }
    public List < String > authorNames {
        get;
        set;
    }
    public String authNameString {
        get;
        set;
    }
    public Product2 deserializedProduct {
        get;
        set;
    }
    public List < Marketing_Information__c > listWithMarketingInformation {
        get;
        set;
    }
    public List < Apttus_Config2__RelatedProduct__c > listWithInstructorResource {
        get;
        set;
    }
    public List < Apttus_Config2__RelatedProduct__c > listWithStudentResource {
        get;
        set;
    }
    public List < Apttus_Config2__RelatedProduct__c > listForInstructorResource {
        get;
        set;
    }
    public List < Apttus_Config2__RelatedProduct__c > listForStudentResource {
        get;
        set;
    }
    public List < Marketing_Information__c > listForTypeAboutThisProduct {
        get;
        set;
    }
    public List < Marketing_Information__c > listForTypeRepTools {
        get;
        set;
    }
    public List < Apttus_Config2__RelatedProduct__c > listForeLearningAssessment {
        get;
        set;
    }
    public List < Apttus_Config2__RelatedProduct__c > listForeCompetitor {
        get;
        set;
    }
    public String marketingInfoSubtypeString {
        get;
        set;
    }
    public String marketingInformationTypeString {
        get;
        set;
    }
    public List < Marketing_Information__c > listWithMarketingInfoSubType {
        get;
        set;
    }
    public boolean repToolsFlag {
        get;
        set;
    }
    public boolean featureRepToolFlag {
        get;
        set;
    }
    public boolean editionRepToolFlag {
        get;
        set;
    }
    public boolean tableRepToolsFlag {
        get;
        set;
    }
    public boolean previousEditionRepToolsFlag {
        get;
        set;
    }
    public boolean descriptionRepToolsFlag {
        get;
        set;
    }
    public boolean appropriateCoursesRepToolsFlag {
        get;
        set;
    }
    public boolean reviewsRepToolsFlag {
        get;
        set;
    }
    public boolean abouttheAuthorRepToolsFlag {
        get;
        set;
    }
    public boolean interviewTabbingGuideRepToolsFlag {
        get;
        set;
    }
    public boolean technologyTipsRepToolsFlag {
        get;
        set;
    }
    public boolean adoptionListRepToolsFlag {
        get;
        set;
    }
    public boolean cutPasteEMailsRepToolsFlag {
        get;
        set;
    }
    public boolean repCopyRepToolsFlag {
        get;
        set;
    }
    public boolean forthcomingEditionRepToolsFlag {
        get;
        set;
    }
    public boolean strategyRepToolsFlag {
        get;
        set;
    }
    public boolean strengthsWeaknessesRepToolsFlag {
        get;
        set;
    }
    public boolean checkListRepToolsFlag {
        get;
        set;
    }
    public Set < Id > selectedWrapperProduct;
    public List < Marketing_Information__c > listToCheckTheRepToolsLink {
        get;
        set;
    }
    public List < Marketing_Information__c > listToCheckTheAboutThisProdToolsLink {
        get;
        set;
    }
    public boolean aboutThisProdFlag {
        get;
        set;
    }
    public boolean featureAboutThisProdFlag {
        get;
        set;
    }
    public boolean editionAboutThisProdFlag {
        get;
        set;
    }
    public boolean tableAboutThisProdFlag {
        get;
        set;
    }
    public boolean previousEditionAboutThisProdFlag {
        get;
        set;
    }
    public boolean descriptionAboutThisProdFlag {
        get;
        set;
    }
    public boolean appropriateCoursesAboutThisProdFlag {
        get;
        set;
    }
    public boolean reviewsAboutThisProdFlag {
        get;
        set;
    }
    public boolean abouttheAuthorAboutThisProdFlag {
        get;
        set;
    }
    public boolean interviewTabbingGuideAboutThisProdFlag {
        get;
        set;
    }
    public boolean technologyTipsAboutThisProdFlag {
        get;
        set;
    }
    public boolean adoptionListAboutThisProdFlag {
        get;
        set;
    }
    public boolean cutPasteEMailsAboutThisProdFlag {
        get;
        set;
    }
    public boolean repCopyAboutThisProdFlag {
        get;
        set;
    }
    public boolean forthcomingEditionAboutThisProdFlag {
        get;
        set;
    }
    public boolean strategyAboutThisProdFlag {
        get;
        set;
    }
    public boolean strengthsWeaknessesAboutThisProdFlag {
        get;
        set;
    }
    public boolean checkListAboutThisProdFlag {
        get;
        set;
    }
    public Integer childDetailsSize {
        get;
        set;
    }
    public List < Pearson_Choice__c > listWithPearsonChoices {
        get;
        set;
    }
    public List < Apttus_Config2__RelatedProduct__c > packageDetails {
        get;
        set;
    }
    public List < Apttus_Config2__RelatedProduct__c > packageDetailsForProductCatalog {
        get;
        set;
    }
    public List < Apttus_Config2__RelatedProduct__c > packageChildDetailsForProductCatalog {
        get;
        set;
    }
    public List < Apttus_Config2__RelatedProduct__c > packageChildDetailsForProductFamily {
        get;
        set;
    }
    public Integer CountTotalRecords {
        get;
        set;
    }
    public List < Apttus_Config2__PriceListItem__c > productsToDisplay1; //for search count
    public List < Apttus_Config2__ProductClassification__c > searchFilterResultsPage {
        get;
        set;
    }
    public Integer productsToDisplay1count1 {
        get;
        set;
    }
    public Integer productsToDisplay1count2 {
        get;
        set;
    }
    public Integer productsToDisplay1count3 {
        get;
        set;
    }
    public Integer totalPages1 {
        get;
        set;
    }
    public Integer totalPages2 {
        get;
        set;
    }
    public Integer pageNumber1 {
        get;
        set;
    }
    public Integer pageNumber2 {
        get;
        set;
    }
    public Integer CountTotalRecords1 {
        get;
        set;
    }
    public Integer listWithProdFamilyCount {
        get;
        set;
    }
    public List < Apttus_Config2__ProductClassification__c > listWithProdFamily1 {
        get;
        set;
    }
    public Integer offSetFamily = 0;
    public boolean offsetFlag {
        get;
        set;
    }
    public boolean offsetTaxonomyFlag {
        get;
        set;
    }
    public boolean offsetSearchFlag {
        get;
        set;
    }
    public boolean searchoffsetFlag {
        get;
        set;
    }
    public boolean searchFilterResultsFlag {
        get;
        set;
    }
    public string sQuery;
    //for search count ends
    public String QueryString {
        get;
        set;
    }
    public Integer OffsetSize = 0;
    private Integer QueryLimit = 10;
    public Integer pageNumber {
        get;
        set;
    }
    public Integer totalPages {
        get;
        set;
    }
    public boolean disablePrevious {
        get;
        set;
    }
    public boolean disableNext {
        get;
        set;
    }
    public boolean displayPopup {
        get;
        set;
    }
    public boolean displayMarketInfoPopup {
        get;
        set;
    }
    public boolean dispVal {
        get;
        set;
    } // Added by Pooja
    public boolean addToOpty {
        get;
        set;
    }
    public boolean isRender {
        get;
        set;
    }
    public Marketing_Information__c content {
        get;
        set;
    }
    public List < Marketing_Information__c > content1;
    public List < Marketing_Information__c > content2 {
        get;
        set;
    }
    public Map < String, Marketing_Information__c > uniqueSubTypemap {
        get;
        set;
    }
    public List < Marketing_Information__c > SubList {
        get;
        set;
    }
    String value {
        get;
        set;
    }
    public Map < Id, Double > mapWithPriceAndID {
        get;
        set;
    }
    public Map < Id, Double > mapWithNetPriceAndID {
        get;
        set;
    }
    public Map < Id, String > mapWithImageID {
        get;
        set;
    }
    public String relevance {
        get;
        set;
    }
    public String productId {
        get;
        set;
    }
    public String relatedProductId {
        get;
        set;
    }
    public String relatedProductId1 {
        get;
        set;
    }
    public String familyId {
        get;
        set;
    }
    public Double Quantityopp {
        get;
        set;
    }
    public List < OpportunityLineItem > existingoppitems {
        get;
        set;
    }
    public List < Opportunity > oppQuantity {
        get;
        set;
    }
    public list < productFamilyClass > listOfproductFamilyClass {
        get;
        set;
    }
    public boolean addNewFilterLink {
        get;
        set;
    } /** Swati-Purpose: When user selects Serach Type as 'None' then Add New Filter link should not be available **/
    public boolean notToDisplayOnSerach {
        get;
        set;
    } /** Swati-Purpose: When user clicks on Search link then dont display "Filter Result(s)"  block **/
    public String searchText {
        get;
        set;
    } /** Swati-Purpose: Set default value to 'Pearson' when Serach Type is 'Product' **/
    public String selectedCondition {
        get;
        set;
    } /** Swati-Purpose: Set default value to 'Equals' when Serach Type is 'Product' and default value is 'Product' **/
    public List < Apttus_Config2__PriceListItem__c > productsToDisplay {
        get;
        set;
    } /** Swati-Purpose: Display products into Serach Result table when serach type is product **/
    public boolean toDisplayProducts {
        get;
        set;
    } /** Swati-Purpose: When user clicks on Search button and serach type is Product then  display "Product Filter Result(s)"  block **/
    public List < DisplayProductWrapper > displayProdWraprList {
        get;
        set;
    } /** Swati-Purpose: When user clicks on Search button then display productFamilyList **/
    public Map < Id, DisplayProductWrapper > mapDisplayProdWrapr {
        get;
        set;
    } /** Swati-Purpose: When user clicks on Search button then display productFamilyList **/
    public List < Apttus_Config2__PriceListItem__c > productFamilies; /** Swati-Purpose: When user clicks on Search button then display productFamilyList **/
    public String addToOptyProductId {
        get;
        set;
    } /** Swati-Purpose: Serach result when type is 'Product', add product on to oppotunity cart **/
    public Boolean displayProductFamilyOnLoad {
        get;
        set;
    } /** Swati-Purpose: Serach result when type is 'Product', add product on to oppotunity cart **/
    public Boolean displayProductFamilyOnSerach {
        get;
        set;
    } /** Swati-Purpose: Serach result when type is 'Product', add product on to oppotunity cart **/
    public List < Apttus_Config2__RelatedProduct__c > addToOptyProductsList {
        get;
        set;
    }
    public Set < Id > productIdsSet {
        get;
        set;
    }
    public List < Product2 > productsList {
        get;
        set;
    } /**Swati-Purpose: add products to opportunity cart on click of 'Add To Oppty' button*/
    public String removeProductIdFromCart {
        get;
        set;
    } /** Swati-Purpose: productId when we remove from cart which will come from page**/
    public String selectedValueFromPopup {
        get;
        set;
    } /** Swati-Purpose: selected value**/
    public Boolean toDisplayLookup {
        get;
        set;
    } /** Swati-Purpose: selected value**/
    public String selectedFilterbyValue {
        get;
        set;
    } /** Swati-Purpose: selected value**/
    public Integer selectedRow {
        get;
        set;
    } /** Swati-Purpose: selected value**/
    public Integer rowNumber {
        get;
        set;
    } /** Swati-Purpose: selected value**/
    public list < Apttus_Config2__RelatedProduct__c > digitalproductfamily {
        get;
        set;
    }
    public set < id > productfamilyids {
        get;
        set;
    }
    public List < ID > listWithProdId {
            get;
            set;
        }
        //Added By Kyama For Product Catalog Details.
    public Id productCatalogIdFromURL {
        get;
        set;
    }
    public product2 product2CatalogResult {
        get;
        set;
    }
    public List < Attachment > bookIconForProductFromAttachment {
        get;
        set;
    }
    public Id ProductFileId {
        get;
        set;
    }
    public List < String > authorNames_Product {
        get;
        set;
    }
    public String authNameString_Product {
        get;
        set;
    }
    public List < Marketing_Information__c > listWithMarketingInformationForProduct {
        get;
        set;
    }
    public List < Marketing_Information__c > listForTypeAboutThisProductForPC {
        get;
        set;
    }
    public String marketingInfoSubtypeStringForProduct {
        get;
        set;
    }
    public String marketingInformationTypeStringForProduct {
        get;
        set;
    }
    public List < Marketing_Information__c > listWithMarketingInfoSubTypeForProduct {
        get;
        set;
    }
    public List < Marketing_Information__c > listToCheckTheAboutThisProdToolsLinkForProduct {
            get;
            set;
        }
        // public List<Marketing_Information__c> listToCheckTheAboutThisProdToolsLinkForProduct{get;set;}
    public boolean aboutThisProdFlagPC {
        get;
        set;
    }
    public boolean featureAboutThisProdFlagPC {
        get;
        set;
    }
    public boolean editionAboutThisProdFlagPC {
        get;
        set;
    }
    public boolean tableAboutThisProdFlagPC {
        get;
        set;
    }
    public boolean previousEditionAboutThisProdFlagPC {
        get;
        set;
    }
    public List < Marketing_Information__c > listForTypeRepToolsTab {
        get;
        set;
    }
    public List < Marketing_Information__c > listForTypeRepToolsProduct {
        get;
        set;
    }
    public List < Marketing_Information__c > listToCheckTheRepToolsLinkProduct;
    public boolean descriptionAboutThisProdFlagForProduct {
        get;
        set;
    }
    public boolean appropriateCoursesAboutThisProdFlagForProduct {
        get;
        set;
    }
    public boolean reviewsAboutThisProdFlagForProduct {
        get;
        set;
    }
    public boolean abouttheAuthorAboutThisProdFlagForProduct {
        get;
        set;
    }
    public boolean interviewTabbingGuideAboutThisProdFlagForProduct {
        get;
        set;
    }
    public boolean technologyTipsAboutThisProdFlagForProduct {
        get;
        set;
    }
    public boolean adoptionListAboutThisProdFlagForProduct {
        get;
        set;
    }
    public boolean cutPasteEMailsAboutThisProdFlagForProduct {
        get;
        set;
    }
    public boolean repCopyAboutThisProdFlagForProduct {
        get;
        set;
    }
    public boolean forthcomingEditionAboutThisProdFlagForProduct {
        get;
        set;
    }
    public boolean strategyAboutThisProdFlagForProduct {
        get;
        set;
    }
    public boolean strengthsWeaknessesAboutThisProdFlagForProduct {
        get;
        set;
    }
    public boolean checkListAboutThisProdFlagForProduct {
        get;
        set;
    }
    public Id CatalogRelatedProductId {
        get;
        set;
    } // Added by Pooja storing Related product Id to show related Marketing Info on Catalog page
    public set < ID > setWithRelatedPkgID;
    public set < ID > setWithInstructorID;
    public set < ID > setWithFamilyPkgID;
    public set < ID > setWithProductPkgID;
    public set < ID > setWithStudentID;
    public set < ID > setWithProductComponentID;
    public Map < Id, Apttus_Config2__RelatedProduct__c > mapDisplayInsPrice {
        get;
        set;
    }
    public Map < Id, Apttus_Config2__RelatedProduct__c > mapDisplayStudPrice {
        get;
        set;
    }
    public Map < Id, Double > mapDisplayStudentListPrice {
        get;
        set;
    }
    public Map < Id, Double > mapDisplayInstructorListPrice {
        get;
        set;
    }
    public Map < Id, Double > mapDisplayStudentNetPrice {
        get;
        set;
    }
    public Map < Id, Double > mapDisplayInstructorNetPrice {
        get;
        set;
    }
    public Map < Id, Apttus_Config2__RelatedProduct__c > mapDisplayfamilyPkgPrice {
        get;
        set;
    }
    public Map < Id, Apttus_Config2__RelatedProduct__c > mapDisplayProductPkgPrice {
        get;
        set;
    }
    public Map < Id, Apttus_Config2__RelatedProduct__c > mapDisplayProductComponentPrice {
        get;
        set;
    }
    public Map < Id, Double > mapDisplayProductComponentListPrice {
        get;
        set;
    }
    public Map < Id, Double > mapDisplayProductComponentNetPrice {
        get;
        set;
    }
    public Map < Id, Double > mapDisplayFamilyPkgListPrice {
        get;
        set;
    }
    public Map < Id, Double > mapDisplayProductPkgListPrice {
        get;
        set;
    }
    public Map < Id, Double > mapDisplayFamilyPkgNetPrice {
        get;
        set;
    }
    public Map < Id, Double > mapDisplayProductPkgNetPrice {
        get;
        set;
    }
    public Map < Id, Apttus_Config2__RelatedProduct__c > mapDisplayelearnPrice {
        get;
        set;
    }
    public Map < Id, Double > mapDisplayelearnListPrice {
        get;
        set;
    }
    public Map < Id, Double > mapDisplayelearnNetPrice {
        get;
        set;
    }
    public set < ID > setWithelearningID;
    Map < Apttus_Config2__RelatedProduct__c, List < Apttus_Config2__RelatedProduct__c >> childDetailsForProduct {
        get;
        set;
    }
    Map < Apttus_Config2__RelatedProduct__c, List < Apttus_Config2__RelatedProduct__c >> childDetails {
        get;
        set;
    }
    Map < Id, List < Apttus_Config2__RelatedProduct__c >> famMap {
        get;
        set;
    }
    Map < Id, List < Apttus_Config2__RelatedProduct__c >> prodMap {
        get;
        set;
    }
    public List < Apttus_Config2__RelatedProduct__c > packageChildDetailsForProduct {
        get;
        set;
    }
    public Id CatalogMarketId {
        get;
        set;
    } // Added by Pooja 
    public Map < Id, List < Marketing_Information__c >> miMap {
            get;
            set;
        } // Added by Pooja
    public String keyString {
        get;
        set;
    } // Added by Pooja
    public String subtype {
        get;
        set;
    } // Added by Pooja
    public String oppCurrency;
    public Integer marOrder;
    public Integer marOrder_link;
    public Integer marOrder_linkProduct;
    public boolean onClickLinkAbout {
        get;
        set;
    }
    public boolean onClickLinkAboutProduct {
        get;
        set;
    }
    public boolean onClickLinkRep {
        get;
        set;
    }
    public AboutThisProduct[] aboutthisproductlist {
        get;
        set;
    }
    public RepTools[] repToolslist {
        get;
        set;
    }
    public List < Marketing_Information__c > listForContent {
        get;
        set;
    }
    public List < Marketing_Information__c > listForContentRep {
        get;
        set;
    }
    public List < Marketing_Information__c > listForContentforProduct {
        get;
        set;
    }
    public AboutThisProductForProduct[] aboutthisproductlistforProduct {
        get;
        set;
    }
    public String prodFromCartId;
    //Added For Cart Error Messages
    public boolean baseProductError {
        get;
        set;
    }
    public boolean PsellProductError {
        get;
        set;
    }
    public boolean PricebookCurrencyError {
        get;
        set;
    }
    public boolean PricebookCurrencyErrorProd {
        get;
        set;
    }
    public boolean PSellError {
        get;
        set;
    }
    public boolean ProductPriceError {
        get;
        set;
    }
    public boolean samplecart {
        get;
        set;
    } //added by Rony for Sample Tab Message
    public boolean sampleorderpermission {
        get;
        set;
    } //added by Rony for Sample Order Permissions
    public boolean emptyproduct {
        get{
            System.debug('@@@emptyproduct:' + emptyproduct);
            return emptyproduct;
        }
        set;
    }
    public List < Apttus_Config2__PriceListItem__c > ap1;
    public boolean productFamilyOnLoad {
        get;
        set;
    }
    Map < Id, Apttus_Config2__RelatedProduct__c > setWithRelatedPkgID2 {
        get;
        set;
    }
    Map < Id, Apttus_Config2__RelatedProduct__c > setWithRelatedPkgID1 {
        get;
        set;
    }
    public String loggedInUserpriceListNamebase;
    //Added To tag Prooduct family on Product Search
    public List < Apttus_Config2__RelatedProduct__c > familyForProducts;
    public Integer renderPearsonChoiceTab {
        get;
        set;
    }
    public Integer renderInstructorResourceTab {
        get;
        set;
    }
    public Integer renderStudentResourceTab {
        get;
        set;
    }
    
    public Integer renderPackageTab {
        get;
        set;
    }
    public Integer renderProductPkgTab {
        get;
        set;
    }
    
    public Integer renderComponentTab {
        get;
        set;
    }
    
    //Added by kamal for taxanomy view
    //Added by Sreenath
    public boolean booleanBookstoreprice {
        get;
        set;
    }
    public boolean booleanInstantAccessPrice {
        get;
        set;
    }
    public boolean booleaneTextOfferPrice {
        get;
        set;
    }
    public boolean booleanPrintOfferPricec {
        get;
        set;
    }
    public boolean booleanSelectedOffer {
        get;
        set;
    }
    //Sreenath-code end 
    //Getter Setter for Grand-Parent
    public List < Apttus_Config2__PriceListCategory__c > grndParentLst {
            get;
            set;
        }
        //Controller Variable for Getting Child
    public List < Apttus_Config2__ClassificationHierarchy__c > clasLst {
            get;
            set;
        }
        //Getter Setter for Repeat rendering
    public String grandparentid {
        get;
        set;
    }
    public String parentid {
        get;
        set;
    }
    public String parentid1 {
        get;
        set;
    }
    public String parentid2 {
        get;
        set;
    }
    public String parentid3 {
        get;
        set;
    }
    public String parentid4 {
        get;
        set;
    }
    public String parentid5 {
        get;
        set;
    }
    public String parentid6 {
        get;
        set;
    }
    //Added by Amit
    public List < pearsonChoiceToSendEmail > pearsonChoiceWrapList {
        get;
        set;
    }
    //end
    //Getter setter for taking current node parent
    public String currParent {
        get;
        set;
    }
    //Getter setter for checking if Grand =Parent is changed
    public Boolean isGrandParentChanged {
        get;
        set;
    }
    //Map to fill all child
    public Map < Id, List < Apttus_Config2__ClassificationHierarchy__c >> mapChild {
            get;
            set;
        }
        
     //Map to check if child is parent
    public Map < Id, Boolean > mapChildHasNext {
        get;
        set;
    }
    public String TabInFocus {
        get;
        set;
    }
    Map<id, Integer> cartmap{
        get;
        set;
    }
    map<id,integer> samplecartmap =  new map<id,integer>();
    public string samplecartfromurl{get;set;}
    public string samplecarturl{get;set;}

    public String backtorelatedlist1{get;set;}
    /*Variable Declaration End */
    /*Constructor Start*/
    Public oneCRMProductSelectorWizardControllerV4() {
            setWithRelatedPkgID2 = new Map < Id, Apttus_Config2__RelatedProduct__c > ();
            setWithRelatedPkgID1 = new Map < Id, Apttus_Config2__RelatedProduct__c > ();
            listForTypeRepToolsTab = new List < Marketing_Information__c > ();
            listForContent = new List < Marketing_Information__c > ();
            listForContentRep = new List < Marketing_Information__c > ();
            mapIDWithNetprice = new Map < Id, Double > ();
            baseProductError = false;
            TabInFocus = 'About This Product';
            PsellProductError = false;
            PriceBookCurrencyError = false;
            PricebookCurrencyErrorProd = false;
            PSellError = false;
            ProductPriceError = false;
            displayProductFamilyOnLoad = false;
            displayProductFamilyOnSerach = false;
            displayOnPearsonClick = false;
            searchFilterResultsFlag = false;
            oppCartEmpty = false;
            searchMessage = false;
            searchFilterResults = false;
            relatedProductId = null;
            relatedProductId1 = null;
            prodFromCartId = '';
            addToOpty = false;
            isRender = false;
            mapWithPriceAndID = new Map < Id, Double > ();
            mapWithNetPriceAndID = new Map < Id, Double > ();
            mapWithImageID = new Map < Id, String > ();
            isDisplaySearchPanel = false;
            disableNext = false;
            CountTotalRecords = 0;
            authNameString = '';
            authNameString_Product = '';
            repToolsFlag = false;
            fromTaxanomy = false;
            featureRepToolFlag = false;
            editionRepToolFlag = false;
            tableRepToolsFlag = false;
            previousEditionRepToolsFlag = false;
            aboutThisProdFlag = false;
            featureAboutThisProdFlag = false;
            editionAboutThisProdFlag = false;
            tableAboutThisProdFlag = false;
            previousEditionAboutThisProdFlag = false;
            aboutThisProdFlagPC = false;
            featureAboutThisProdFlagPC = false;
            editionAboutThisProdFlagPC = false;
            tableAboutThisProdFlagPC = false;
            previousEditionAboutThisProdFlagPC = false;
            packageDetails = new List < Apttus_Config2__RelatedProduct__c > ();
            //Added To tag Prooduct family on Product Search 
            familyForProducts = new List < Apttus_Config2__RelatedProduct__c > ();
            packageChildDetailsForProductFamily = new List < Apttus_Config2__RelatedProduct__c > ();
            packageChildDetailsForProduct = new List < Apttus_Config2__RelatedProduct__c > ();
            childDetails = new Map < Apttus_Config2__RelatedProduct__c, List < Apttus_Config2__RelatedProduct__c >> ();
            famMap = new Map < Id, List < Apttus_Config2__RelatedProduct__c >> ();
            prodMap = new Map < Id, List < Apttus_Config2__RelatedProduct__c >> ();
            childDetailsForProduct = new Map < Apttus_Config2__RelatedProduct__c, List < Apttus_Config2__RelatedProduct__c >> ();
            mapDisplayInsPrice = new Map < Id, Apttus_Config2__RelatedProduct__c > ();
            mapDisplayStudPrice = new Map < Id, Apttus_Config2__RelatedProduct__c > ();
            mapDisplayStudentListPrice = new Map < Id, Double > ();
            mapDisplayInstructorListPrice = new Map < Id, Double > ();
            mapDisplayStudentNetPrice = new Map < Id, Double > ();
            mapDisplayInstructorNetPrice = new Map < Id, Double > ();
            mapDisplayfamilyPkgPrice = new Map < Id, Apttus_Config2__RelatedProduct__c > ();
            mapDisplayProductPkgPrice = new Map < Id, Apttus_Config2__RelatedProduct__c > ();
            mapDisplayProductComponentPrice = new Map < Id, Apttus_Config2__RelatedProduct__c > ();
            mapDisplayFamilyPkgListPrice = new Map < Id, Double > ();
            mapDisplayProductPkgListPrice = new Map < Id, Double > ();
            mapDisplayFamilyPkgNetPrice = new Map < Id, Double > ();
            mapDisplayProductPkgNetPrice = new Map < Id, Double > ();
            mapDisplayProductComponentListPrice = new Map < Id, Double > ();
            mapDisplayProductComponentNetPrice = new Map < Id, Double > ();
            setWithelearningID = new set < ID > ();
            mapDisplayelearnPrice = new Map < Id, Apttus_Config2__RelatedProduct__c > ();
            mapDisplayelearnListPrice = new Map < Id, Double > ();
            mapDisplayelearnNetPrice = new Map < Id, Double > ();
            listToCheckTheRepToolsLink = new List < Marketing_Information__c > ();
            listToCheckTheAboutThisProdToolsLink = new List < Marketing_Information__c > ();
            listToCheckTheAboutThisProdToolsLinkForProduct = new List < Marketing_Information__c > ();
            listForTypeRepTools = new List < Marketing_Information__c > ();
            listWithSelectOptions = new List < dynamicAddFilterSearch > ();
            setWithPearsonCodeID = new set < ID > ();
            setWithProductFamilyID = new set < ID > ();
            setWithInstructorID = new set < ID > ();
            setWithStudentID = new set < ID > ();
            setWithFamilyPkgID = new set < ID > ();
            setWithProductPkgID = new set < ID > ();
            setWithProductComponentID = new set < ID > ();
            setWithRelatedPkgID = new set < ID > ();
            //backtorelatedlist1='false';
            if (null != ApexPages.currentPage().getParameters().get('oppId')) opportunityID = ApexPages.currentPage().getParameters().get('oppId');
            productFamilyIdFromURL = ApexPages.currentPage().getParameters().get('productFamilyId');
            productCatalogIdFromURL = ApexPages.currentPage().getParameters().get('productId'); //Added By Kyama For ProductCatalogdetails
            existingPearsonCourseList = new List < Opportunity_Pearson_Course_Code__c > ();
            content1 = new List < Marketing_Information__c > ();
            content2 = new List < Marketing_Information__c > ();
            uniqueSubTypemap = new Map < String, Marketing_Information__c > (); // Added by Pooja
            SubList = new List < Marketing_Information__C > (); // Added by Pooja
            miMap = new Map < Id, List < Marketing_Information__c >> (); // Added by Pooja
            keyString = ''; // Added by Pooja
            listWithPSellFamily = new List < Apttus_Config2__RelatedProduct__c > ();
            for (Opportunity_Pearson_Course_Code__c oppPearsonCodes: [select Pearson_Course_Code_Name__c, Pearson_Course_Code_Name_f__c, Pearson_Course_Code_Name__r.Pearson_Course_Structure_Code__c from Opportunity_Pearson_Course_Code__c where Opportunity__r.id = : opportunityID]) {
                existingPearsonCourseList.add(oppPearsonCodes);
                setWithPearsonCodeID.add(oppPearsonCodes.Pearson_Course_Code_Name__c);
                System.debug(setWithPearsonCodeID);
            }
            if(productFamilyIdFromURL == null && productCatalogIdFromURL == null) {
            List < Apttus_Config2__ProductClassification__c > productCount = new List < Apttus_Config2__ProductClassification__c > ();
            productCount = [select Apttus_Config2__ProductId__r.id from Apttus_Config2__ProductClassification__c where Apttus_Config2__ClassificationId__c IN: setWithPearsonCodeID];
            set < ID > count = new set < ID > ();
            for (Apttus_Config2__ProductClassification__c pc: productCount) {
                count.add(pc.Apttus_Config2__ProductId__r.id);
            }
            CountTotalRecords = count.size();
            }
            System.debug('CountTotalRecords...' + CountTotalRecords);
            notToDisplayOnSerach = true; //Swati
            addNewFilterLink = false; //Swati
            productFieldLst = new List < SelectOption > (); //Swati        
            searchText = ''; //Swati        
            productsToDisplay = new List < Apttus_Config2__PriceListItem__c > (); //Swati 
            toDisplayProducts = false; //Swati
            pageNumber = 0; //Swati
            totalPages = 0; //Swati
            //for search count
            pageNumber1 = 0;
            pageNumber2 = 0;
            totalPages1 = 0;
            totalPages2 = 0;
            //Added For Tab hiding.
            renderPearsonChoiceTab=0;
            renderInstructorResourceTab=0;
            renderStudentResourceTab=0;
            renderPackageTab=0;
            renderProductPkgTab=0;
            renderComponentTab=0;
            offsetFlag = false;
            offsetTaxonomyFlag = false;
            sQuery = '';
            backtorelatedlist = '';
            //for search count ends
            displayProdWraprList = new List < DisplayProductWrapper > (); //Swati
            mapDisplayProdWrapr = new Map < Id, DisplayProductWrapper > (); //Swati
            productFamilies = new List < Apttus_Config2__PriceListItem__c > (); //Swati
            addToOptyProductId = ''; //Swati
            removeProductIdFromCart = ''; //Swati
            toDisplayLookup = false; //Swati
            rowNumber = 0; //Swati
            //cartProdFromURL = '';
            
            productFamilyOnLoad = false;
            if (productFamilyIdFromURL == null && productCatalogIdFromURL == null) {
                addNewFilter();
                productFamily();
                getPageNumber();
                getTotalPages();
                getPrice();
            }
            if (productFamilyIdFromURL != null || productCatalogIdFromURL != null) {
            getProductFamilyDetails();
            getProductCatalogDetails();
            getMarketingInformationDetails();
            getMarketingInformationDetailsForProduct();
            getCompetitiveDetails();
            }
            OppQuantity();
            //Added For getting User PriceList.
            loggedInUserpriceListNamebase = [select Price_List__c from User where id = : UserInfo.getUserId()].Price_List__c;
            
            // Added by Pooja
            //getPriceForInstStud();
            
            listOfproductFamilyClass = new list < productFamilyClass > (); // added by Kyama  
            ProductFamilyClass productFamilyClass; /*Added For displaying Existing OpportunityLine Items for that Opp*/
          /*   if( backtorelatedlist != ''){
                backtorelatedlist1 = ApexPages.currentPage().getParameters().get('backtorelatedlist');
             System.debug('backtorelatedlist1-->'+backtorelatedlist1);
              }*/
           // if(productFamilyIdFromURL == null && productCatalogIdFromURL == null && backtorelatedlist1=='false' && opportunityID!=null) {
            backtorelatedlist1 = ApexPages.currentPage().getParameters().get('backtorelatedlist1');
            if((cartProdFromURL == null || cartProdFromURL=='') && (backtorelatedlist1 == null)){
            cartProdFromURL='';
            existingoppitems = new List < Opportunitylineitem > (); /*Added For displaying Existing OpportunityLine Items for that Opp*/
            loadOpptyLineItems();
            if (!existingoppitems.isempty()) {
                for (Opportunitylineitem family1: existingoppitems) {
                    productFamilyClass = new productFamilyClass();
                    productFamilyClass.relatedProd1 = family1;
                    if (family1 != null) {
                        Decimal decimalQuantity = family1.quantity;
                        if (decimalQuantity != null) {
                            Integer integerQuantity = decimalQuantity.intValue();
                            productFamilyClass.sQuantity = integerQuantity;
                        }
                    }
                    listOfproductFamilyClass.add(productFamilyClass);
                    cartProdFromURL = cartProdFromURL+family1.PricebookEntry.Product2.Id+'%2C'+productFamilyClass.sQuantity+'%2C';
                    System.debug('listOfproductFamilyClass******' + listOfproductFamilyClass);
                }
            } else {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'No items in the Opportunity cart'));
                oppCartEmpty = true;
                // PsellProductError=true;
                // PSellError=true;
            }}
            //}
            //Added by kamal for taxanomy view 
            if (productFamilyIdFromURL == null && productCatalogIdFromURL == null) {
            grndParentLst = new List < Apttus_Config2__PriceListCategory__c > ();
            clasLst = new List < Apttus_Config2__ClassificationHierarchy__c > ();
            mapChild = new Map < Id, List < Apttus_Config2__ClassificationHierarchy__c >> ();
            mapChildHasNext = new Map < Id, Boolean > ();
            grandparentid = '';
            parentid = '';
            parentid1 = '';
            parentid2 = '';
            parentid3 = '';
            parentid4 = '';
            parentid5 = '';
            parentid6 = '';
            currParent = '';
            isGrandParentChanged = false;
            //Fetching Price_List__c details for Logged in User
            //User loggedinUser = [Select Id,Price_List__c from User where Id =:UserInfo.getUserID()];
            if (loggedInUserpriceListNamebase != null) grndParentLst = [Select Apttus_Config2__HierarchyId__r.Id, Apttus_Config2__HierarchyId__r.Name from Apttus_Config2__PriceListCategory__c where Apttus_Config2__PriceListId__r.Name = : loggedInUserpriceListNamebase And Apttus_Config2__HierarchyId__c != null order by name asc];
            system.debug('grndParentLst------>' + grndParentLst);
            }
            productfamilyids = new set < id > ();
            //Added by madhu
            if (null != ApexPages.currentPage().getParameters().get('pearsonCodeIdFromProdFamily')) {
                pearsonCodeId = ApexPages.currentPage().getParameters().get('pearsonCodeIdFromProdFamily');
                productFamily();
            }
            samplecart = false; // added by Rony for sample table
            sampleorderpermission = false; // added by Rony for order permission
            emptyproduct = false; // added by Rony for sample table
            /* if(listWithProdId.isEmpty())
                {
                    productFamilyOnLoad = true;
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'No Products Found'));
                }*/
            mapIDWithListprice = new Map < Id, Double > ();
            //Added for getting count for hiding tabs.
            if (productFamilyIdFromURL != null) {
                renderPearsonChoiceTab = [select count() from Pearson_Choice__c where Product_Family__c = : productFamilyIdFromURL limit 1];
                renderInstructorResourceTab = [select count() from Apttus_Config2__RelatedProduct__c where Apttus_Config2__ProductId__c = : productFamilyIdFromURL And Instructor_Resource__c = True LIMIT 1];
                renderStudentResourceTab = [select count() from Apttus_Config2__RelatedProduct__c where Apttus_Config2__ProductId__c = : productFamilyIdFromURL And Student_Resource__c = True LIMIT 1];
                renderPackageTab=[select count() from Apttus_Config2__RelatedProduct__c where Apttus_Config2__ProductId__c = : productFamilyIdFromURL And Relation_Package__c = True LIMIT 1];
              
              //Added To load the ProductFamily tabs
                if (!listForTypeAboutThisProduct.isEmpty() && listForTypeAboutThisProduct.size()!=0) 
            {
            }
            else{
            if(renderPearsonChoiceTab!=0){
            getPearsonChoices();
            }
            else if(renderInstructorResourceTab!=0){
            getInstructorResourceDetails();
            }
            else if(renderStudentResourceTab!=0){
            getStudentResourceDetails();
            }
            else if(renderPackageTab!=0){
            getPackageDetails();
            }
            }  
            
            }
            if(productCatalogIdFromURL!=null){
            renderProductPkgTab=[select count() from Apttus_Config2__RelatedProduct__c where Apttus_Config2__RelatedProductId__c = : productCatalogIdFromURL AND Relation_Package__c = true AND Apttus_Config2__ProductId__r.Apttus_Config2__ConfigurationType__c = 'Option' LIMIT 1];
            renderComponentTab=[select count() from Apttus_Config2__RelatedProduct__c where Apttus_Config2__ProductId__c = : productCatalogIdFromURL AND Component_Package__c = true LIMIT 1];
            
           //Added To load Productcatalg Tabs
            if (!listForTypeAboutThisProductForPC.isEmpty() && listForTypeAboutThisProductForPC.size()!=0) 
            {
            }
            else{
            if(renderComponentTab!=0){
            getComponentDetails();
            }
            /*else if(renderProductPkgTab!=0){
            getProductPackageDetails();
            }*/
            } 
            }
            System.debug('cartProdFromURL outside...........'+cartProdFromURL);
            String newcartProdFromURL = ApexPages.currentPage().getParameters().get('cartProdFromURL');
            List<Id> productIdFromCart = new List<ID>();
            Map<Integer,Id> prodseqfromCart=New Map<Integer,Id>();
            Map<Integer,decimal> quanseqfromCart=New Map<Integer,decimal>();
            
            System.debug('newcartProdFromURL..........'+newcartProdFromURL);
             cartmap = new Map<Id, Integer>();
             Id  cartid;
             Integer Qnty;
             Integer seq =1;
           if(newcartProdFromURL!='' && newcartProdFromURL != null){
            oppCartEmpty = false;
            System.debug('newcartProdFromURL...........'+newcartProdFromURL);
            listOfproductFamilyClass.clear();
              list<String> cartbreak = new list<String>();
              cartbreak = newcartProdFromURL.split('\\,');
              System.debug('cartbreak[i] -->'+cartbreak.size());
                for(Integer i=0 ;i<cartbreak.size(); i++){
                 if((math.mod(i,2))== 0){                   
                  System.debug('cartbreak[i] -->'+cartbreak[i]);
                  cartid  = Id.valueof(cartbreak[i]);
                  productIdFromCart.add(cartid);
                  prodseqfromCart.put(seq,cartid);
                  }
                  else{
                  Qnty = Integer.valueof(cartbreak[i]);
                  quanseqfromCart.put(seq,Qnty);
                  system.debug('Integer.valueof(cartbreak[i]) -- >'+Integer.valueof(cartbreak[i]));
                  seq++;
                  }
                  cartmap.put(cartid,Qnty);        
                  
              } 
              system.debug('Init of maps done......KP');
              system.debug(prodseqfromCart.size()+';'+prodseqfromCart);
              system.debug(quanseqfromCart.size()+';'+quanseqfromCart);
                       
               System.debug('cartmap........'+cartmap);
            } 
            List<Apttus_Config2__PriceListItem__c> cartProducts= new List<Apttus_Config2__PriceListItem__c>();
            List<Id> productidSet = new List<Id>();
            //productidSet = cartmap.keySet();
            productidSet.addAll(productIdFromCart);
            system.debug('productidSet ---->'+productidSet);
            System.debug('cartProducts --->'+cartProducts);
            Integer cartCounter =0;
            /*KPMap<Id,Apttus_Config2__PriceListItem__c> mapForDupProd = new Map<Id,Apttus_Config2__PriceListItem__c>();
            Map<Id,Integer> mapWithCartDoubler = new Map<Id,Integer>();KP*/
            if (productIdFromCart.size()>0){
                cartProdFromURL='';
                seq=1;
                cartProducts= [Select id,Apttus_Config2__ProductId__r.name, Apttus_Config2__ProductId__r.Edition__c,Apttus_Config2__ProductId__r.Copyright_Year__c,Apttus_Config2__ProductId__r.ISBN__c ,Apttus_Config2__ProductId__r.Author__c from Apttus_Config2__PriceListItem__c where Apttus_Config2__ProductId__c 
                                IN :productidSet and Apttus_Config2__PriceListId__r.name= :loggedInUserpriceListNamebase];
                Map<Id,Apttus_Config2__PriceListItem__c> cartprodmap=new Map<Id,Apttus_Config2__PriceListItem__c>();
                for(Apttus_Config2__PriceListItem__c prod:cartProducts) {
                    if(!cartprodmap.containsKey(prod.Apttus_Config2__ProductId__c)){
                        cartprodmap.put(prod.Apttus_Config2__ProductId__c,prod);
                    }
                }           
                system.debug('Product details map init..'+cartprodmap.size());
                for(integer i=0;i<prodseqfromCart.size();i++){
                    productFamilyClass = new productFamilyClass();
                    system.debug(cartprodmap.get(prodseqfromCart.get(seq)));
                    productFamilyClass.oppProd = cartprodmap.get(prodseqfromCart.get(seq));
                    system.debug(quanseqfromCart.get(seq));
                    productFamilyClass.sQuantity =quanseqfromCart.get(seq);
                    listOfproductFamilyClass.add(productFamilyClass);
                    cartProdFromURL = cartProdFromURL+prodseqfromCart.get(seq)+'%2C'+quanseqfromCart.get(seq)+'%2C';
                    seq++;
                }                           
                
            }
            if(listOfproductFamilyClass.size()==0){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'No items in the Opportunity cart'));
                oppCartEmpty = true;
            }
            samplecartfromurl = ApexPages.currentPage().getParameters().get('samplecartcontents');
            samplecarturl= samplecartfromurl;
             List<Id> sampleIdFromCart = new List<ID>();
             id sampleid; 
             list<integer> samplequanseqfromCart = new list<integer>();
             integer sampleseq = 0;
             integer sampleqnty;
             Map<Integer,decimal> quanseqfromsampleCart=New Map<Integer,decimal>();
             Map<Integer,Id> prodseqfromsampleCart=New Map<Integer,Id>();
             system.debug('$$$$$$$'+samplecartfromurl);
             if((samplecartfromurl != null) && (samplecartfromurl != ''))
             {
                 system.debug('$$$$$$$'+samplecartfromurl);
                 samplecart = true;
                 list<String> samplecartbreak = new list<String>();
                 samplecartbreak = samplecartfromurl.split('\\,');
                 for(Integer i=0 ;i<samplecartbreak.size(); i++){
                 if((math.mod(i,2))== 0){                   
                  System.debug('samplecartbreak[i] -->'+samplecartbreak[i]);
                  sampleid  = Id.valueof(samplecartbreak[i]);
                  sampleidfromcart.add(sampleid);
                  prodseqfromsampleCart.put(sampleseq,sampleid);
                  }
                  else{
                  sampleqnty = Integer.valueof(samplecartbreak[i]);
                  quanseqfromsampleCart.put(sampleseq,sampleqnty);
                  system.debug('Integer.valueof(samplecartbreak[i]) -- >'+Integer.valueof(samplecartbreak[i]));
                  sampleseq++;
                  }
      
              } 
              for(integer i=0;i<sampleseq;i++)
              {
                 samplecartmap.put(prodseqfromsampleCart.get(i),integer.valueof(quanseqfromsampleCart.get(i)));
              }
              
              system.debug(sampleIdFromCart.size()+';'+sampleIdFromCart);
              system.debug(quanseqfromsampleCart.size()+';'+quanseqfromsampleCart);
                       
               System.debug('samplecartmap........'+samplecartmap);
               list<product2> urlproductlist = [select id,name,Author__c  from product2 where id in :sampleidfromcart];
               selectedproductslist = new list < selectedproductlineitem > ();
               for(product2 prod2:urlproductlist)
               {selectedproductslist.add(new selectedproductlineitem(prod2));}
               for(selectedproductlineitem temp:selectedproductslist){temp.squantity = samplecartmap.get(temp.product.id);}
               
             }
            /*KPif(productidSet.size()!=0){
                for(Apttus_Config2__PriceListItem__c cartprod : [Select id,Apttus_Config2__ProductId__r.name, Apttus_Config2__ProductId__r.Edition__c,Apttus_Config2__ProductId__r.Copyright_Year__c,Apttus_Config2__ProductId__r.ISBN__c ,Apttus_Config2__ProductId__r.Author__c from Apttus_Config2__PriceListItem__c where Apttus_Config2__ProductId__c IN :productidSet and Apttus_Config2__PriceListId__r.name= :loggedInUserpriceListNamebase]){
                mapForDupProd.put(cartprod.Apttus_Config2__ProductId__c,cartprod);
                    productFamilyClass = new productFamilyClass();
                    productFamilyClass.oppProd = cartprod;
                    if (cartprod != null) {
                        Decimal cartQuantity = cartmap.get(cartprod.Apttus_Config2__ProductId__c);
                        if (cartQuantity != null)    
                            productFamilyClass.sQuantity = cartQuantity;
                    }
                    listOfproductFamilyClass.add(productFamilyClass);
                    cartProdFromURL = cartProdFromURL+cartprod.Apttus_Config2__ProductId__c+'%2C'+productFamilyClass.sQuantity+'%2C';
                    System.debug('listOfproductFamilyClass****** cart ' + listOfproductFamilyClass);
                }
                if(productidSet.size()>0)
                {
                    for(Integer j=0;j<productidSet.size();j++)
                    {
                        for(Integer f=0;f<productidSet.size();f++)
                        {
                            if(productIdFromCart[j] == productIdFromCart[f])
                            {
                                cartCounter++;
                                mapWithCartDoubler.put(productIdFromCart[j],cartCounter);
                            }
                        }
                    }
                }
                System.debug(mapWithCartDoubler);
                Integer stopRecursion=0;
                if(!mapWithCartDoubler.isEmpty())
                {
                     for(Id cartLogicCounter : mapWithCartDoubler.keyset())
                     {
                       if(productidSet.size() != (mapWithCartDoubler.get(cartLogicCounter))/(productidSet.size()) && productidSet.size() > (mapWithCartDoubler.get(cartLogicCounter))/(productidSet.size()))    
                       {
                        Integer repeatedId = mapWithCartDoubler.get(cartLogicCounter);
                        
                             Integer iterationCount = (repeatedId/(productidSet.size()))-1;
                                                
                            for(Integer r=0;r<iterationCount;r++)
                            {
                                productFamilyClass = new productFamilyClass();
                                productFamilyClass.oppProd = mapForDupProd.get(cartLogicCounter);
                                if (cartLogicCounter != null) 
                                {
                                    System.debug(cartmap);
                                    System.debug(cartmap.get(cartLogicCounter));
                                    Decimal cartQuantity = cartmap.get(cartLogicCounter);
                                    if (cartQuantity != null)    
                                    productFamilyClass.sQuantity = cartQuantity;
                                }
                                listOfproductFamilyClass.add(productFamilyClass);
                                cartProdFromURL = cartProdFromURL+cartLogicCounter+'%2C'+productFamilyClass.sQuantity+'%2C';
                            }
                        }
                        
                     }
                     
                     
                }
            }*/
        }
        /*Constructor End*/
        /**
         * Description : Load oppty line items
         * @param NA
         * @return Void
         * @throws NA
         **/
  public void InitCartandURL(){         
    if (listOfproductFamilyClass.size()>0){
        cartProdFromURL='';
        for(productFamilyClass pfc:listOfproductFamilyClass){
            if (pfc.oppProd != null)
                cartProdFromURL = cartProdFromURL+pfc.oppProd.Apttus_Config2__ProductId__c+'%2C'+pfc.sQuantity+'%2C';
            else  if(pfc.relatedProd1 != null)
                cartProdFromURL = cartProdFromURL+pfc.relatedProd1.PricebookEntry.Product2.Id+'%2C'+pfc.sQuantity+'%2C';
            else
                cartProdFromURL = cartProdFromURL+pfc.relatedProd.Apttus_Config2__ProductId__c+'%2C'+pfc.sQuantity+'%2C';
        }
     }
     system.debug('URL initialised after setquantity'+cartProdFromURL);
   }
    public void loadOpptyLineItems() {
        System.debug(opportunityID);
        for (Opportunitylineitem family: [select PricebookEntry.Product2.Id, SRP__c, PricebookEntry.Product2.Name, PricebookEntry.Product2.ISBN__c, Product2.name, PricebookEntry.Product2.Author__c, PricebookEntry.Product2.Copyright_Year__c, PricebookEntry.Product2.Edition__c, Quantity, ListPrice, Unitprice, Product_Family_HE__c from OpportunityLineItem where OpportunityId = : opportunityID]) {
            existingoppitems.add(family); /*Added For displaying Existing OpportunityLine Items for that Opp*/
            System.debug('existingoppitems....' + existingoppitems);
        }
    }
    public void setListPriceToList(Set < ID > Relatedproduct, Set < ID > RelatedproductOppLineId, Set < ID > productsIdSet) {
            String loggedInUserpriceListName = [select Price_List__c from User where id = : UserInfo.getUserId()].Price_List__c;
            for (Apttus_Config2__PriceListItem__c ap: [select Apttus_Config2__ProductId__c, Apttus_Config2__ListPrice__c,
                    Net_Price__c from Apttus_Config2__PriceListItem__c
                    where(Apttus_Config2__ProductId__c IN: Relatedproduct OR Apttus_Config2__ProductId__c IN: RelatedproductOppLineId OR Apttus_Config2__ProductId__c IN: productsIdSet) and Apttus_Config2__PriceListId__r.name = : loggedInUserpriceListName and Apttus_Config2__Active__c = true LIMIT 100
                ]) {
                if (ap.Apttus_Config2__ListPrice__c != null) {
                    mapIDWithListprice.put(ap.Apttus_Config2__ProductId__c, ap.Apttus_Config2__ListPrice__c);
                }
                if (ap.Net_Price__c != null) {
                    mapIDWithNetprice.put(ap.Apttus_Config2__ProductId__c, ap.Net_Price__c);
                }
            }
        }
        /**
         * Description : Retrieve Code (4 char) values from Multi - Select picklist
         * @param String
         * @return String
         * @throws NA
         **/
    public Pagereference createOpplineitems() {
            system.debug('product cart items'+listOfproductFamilyClass);
            List < OpportunityLineItem > oliList = new List < OpportunityLineItem > ();
            set < ID > productsIdSet = new set < ID > (); //Swati
            set < ID > Relatedproduct = new set < ID > ();
            set < ID > RelatedproductOppLineId = new set < ID > ();
            //Deleting the existing OpportunitylineItems
            List < Opportunitylineitem > existingoppitemstodel = new List < Opportunitylineitem > ();
            for (Opportunitylineitem existingopp: [select PricebookEntry.Product2.Name, Product2.name, Quantity, ListPrice, Unitprice from OpportunityLineItem where Opportunity.id = : opportunityID]) {
                existingoppitemstodel.add(existingopp); /*Added For displaying Existing OpportunityLine Items for that Opp*/
            }
            if (!existingoppitemstodel.isEmpty()) {
                try {
                    delete existingoppitemstodel;
                } catch (Exception e) {
                    system.debug(e);
                }
            }
            if (!listOfproductFamilyClass.isEmpty()) {
                for (productFamilyClass prodClass: listOfproductFamilyClass) {
                    Relatedproduct.add(prodClass.relatedProd.apttus_config2__relatedproductid__c);
                    RelatedproductOppLineId.add(prodClass.relatedProd1.PricebookEntry.Product2Id);
                    if (prodClass.oppProd != null) {
                        productsIdSet.add(prodClass.oppProd.Apttus_Config2__ProductId__r.id);
                    }
                }
            }
            setListPriceToList(Relatedproduct, RelatedproductOppLineId, productsIdSet);
            SYstem.debug(mapIDWithNetprice);
            if (!listOfproductFamilyClass.isEmpty()) {
                for (productFamilyClass prodClass: listOfproductFamilyClass) {
                    OpportunitylineItem opLineItem = new OpportunitylineItem();
                    if (prodClass.relatedProd != null) {
                        System.debug('prodClass.relatedProd.apttus_config2__relatedproductid__r.id' + prodClass.relatedProd.apttus_config2__relatedproductid__r.id);
                        Id ProductId = prodClass.relatedProd.apttus_config2__relatedproductid__r.id;
                        System.debug('inside equals condition ProductId' + ProductId);
                        if (ProductId != null) {
                            List < PriceBookEntry > priceBookList = [SELECT Id, Product2Id, Product2.Name FROM PriceBookEntry WHERE Product2Id = : ProductId AND PriceBook2.isStandard = true AND isActive = true AND CurrencyISOCode =: oppCurrency LIMIT 1];
                            if (!priceBookList.isEmpty()) {
                                opLineItem.OpportunityId = opportunityID;
                                opLineItem.PricebookEntryId = priceBookList[0].Id;
                                opLineItem.quantity = prodClass.sQuantity;
                                opLineItem.Unitprice = mapIDWithNetprice.get(prodClass.relatedProd.apttus_config2__relatedproductid__r.id) != null ? mapIDWithNetprice.get(prodClass.relatedProd.apttus_config2__relatedproductid__r.id) : 0.00;
                                opLineItem.Product_Family_HE__c = prodClass.relatedProd.Apttus_Config2__ProductId__c;
                                opLineItem.SRP__c = mapIDWithListprice.get(prodClass.relatedProd.apttus_config2__relatedproductid__r.id) != null ? mapIDWithListprice.get(prodClass.relatedProd.apttus_config2__relatedproductid__r.id) : 0.00;
                                oliList.add(opLineItem);
                            }
                        }
                    }
                    if (prodClass.relatedProd1 != null) {
                        Id oppProductid = prodClass.relatedProd1.PricebookEntry.Product2Id;
                        System.debug('oppProductid...' + oppProductid);
                        if (oppProductid != null) {
                            List < PriceBookEntry > priceBookList1 = [SELECT Id, Product2Id, Product2.Name FROM PriceBookEntry WHERE Product2Id = : oppProductid AND PriceBook2.isStandard = true AND isActive = true AND CurrencyISOCode =: oppCurrency LIMIT 1];
                            if (!priceBookList1.isEmpty()) {
                                opLineItem.OpportunityId = opportunityID;
                                opLineItem.PricebookEntryId = priceBookList1[0].Id;
                                opLineItem.quantity = prodClass.sQuantity;
                                opLineItem.Unitprice = prodClass.relatedProd1.UnitPrice;
                                opLineItem.SRP__c = prodClass.relatedProd1.SRP__c;
                                opLineItem.Product_Family_HE__c = prodClass.relatedProd1.Product_Family_HE__c;
                                oliList.add(opLineItem);
                            }
                        }
                    }
                    /*swati: Add carts product to opportunityLineItem*/
                    if (prodClass.oppProd != null) {
                        Id oppProductid1 = prodClass.oppProd.Apttus_Config2__ProductId__r.id;
                        System.debug('oppProductid1...' + oppProductid1);
                        if (oppProductid1 != null) {
                            List < PriceBookEntry > oppProdPriceBookList = [SELECT Id, Product2Id,
                                Product2.Name FROM
                                PriceBookEntry WHERE
                                Product2Id = : oppProductid1 AND PriceBook2.isStandard = true AND isActive = true AND CurrencyISOCode =: oppCurrency LIMIT 1
                            ];
                            if (!oppProdPriceBookList.isEmpty()) {
                                opLineItem.OpportunityId = opportunityId;
                                opLineItem.PricebookEntryId = oppProdPriceBookList[0].Id;
                                opLineItem.quantity = prodClass.sQuantity;
                                opLineItem.Unitprice = mapIDWithNetprice.get(prodClass.oppProd.Id) != null ? mapIDWithNetprice.get(prodClass.oppProd.Id) : 0.00;
                                opLineItem.SRP__c = mapIDWithListprice.get(prodClass.oppProd.Id) != null ? mapIDWithListprice.get(prodClass.oppProd.Id) : 0.00;
                                System.debug('in oppline item familyId...' + familyId);
                                if (familyTagId != null) {
                                    opLineItem.Product_Family_HE__c = familyTagId;
                                } else {
                                    set < ID > famId = new set < ID > ();
                                    set < ID > famOppid = new set < ID > ();
                                    List < ID > prodFam = new List < ID > ();
                                    familyForProducts = [select Apttus_Config2__ProductId__r.id, Apttus_Config2__ProductId__r.name, Apttus_Config2__RelatedProductId__r.name, Apttus_Config2__RelatedProductId__r.ISBN__c,
                                        Apttus_Config2__RelatedProductId__r.Author__c, Apttus_Config2__RelatedProductId__r.Edition__c, Apttus_Config2__RelatedProductId__r.Copyright_Year__c,
                                        Apttus_Config2__RelatedProductId__r.id, PSELL__c from Apttus_Config2__RelatedProduct__c
                                        where Apttus_Config2__RelatedProductId__r.id = : oppProductid1
                                    ];
                                    //System.debug('inside if(toDisplayProducts && !productsToDisplay.isEmpty())'+familyForProducts[0].Apttus_Config2__ProductId__r.name+familyForProducts);
                                    if (familyForProducts != null) {
                                        if (familyForProducts.size() > 1) {
                                            System.Debug('inside gerate dan one');
                                            for (productFamilyClass prodClass1: listOfproductFamilyClass) {
                                                if (prodClass1.relatedProd != null) {
                                                    famId.add(prodClass1.relatedProd.Apttus_Config2__ProductId__c);
                                                }
                                                if (prodClass1.relatedProd1 != null) famOppid.add(prodClass1.relatedProd1.Product_Family_HE__c);
                                            }
                                            System.debug(famId + 'inside size greater' + famOppid);
                                            for (Integer i = 0; i < familyForProducts.size(); i++) {
                                                if (famId.contains(familyForProducts[i].Apttus_Config2__ProductId__r.id) || famOppid.contains(familyForProducts[i].Apttus_Config2__ProductId__r.id)) {
                                                    prodFam.add(familyForProducts[i].Apttus_Config2__ProductId__r.id);
                                                }
                                            }
                                            System.debug('prodFam....' + prodFam + prodFam.size());
                                            if (prodFam.size() >= 1) {
                                                opLineItem.Product_Family_HE__c = prodFam[0];
                                            } else
                                            if (familyForProducts != null && !familyForProducts.isEmpty()) opLineItem.Product_Family_HE__c = familyForProducts[0].Apttus_Config2__ProductId__c;
                                        } else {
                                            if (familyForProducts != null && !familyForProducts.isEmpty()) opLineItem.Product_Family_HE__c = familyForProducts[0].Apttus_Config2__ProductId__c;
                                        }
                                    }
                                }
                                oliList.add(opLineItem);
                            }
                        }
                    }
                    System.debug('inside createOpplineitems() op values' + oliList);
                }
            }
            try {
                if (!oliList.isEmpty()) {
                    insert oliList;
                }
            } catch (Exception e) {
                System.debug(e);
            }
            System.debug('inserted successfully');
            if (selectedproductslist == null) {
                selectedproductslist = new list < selectedproductlineitem > ();
            }
            if (selectedproductslist.size() > 0) {
                order sampleorder = new order();
                list < OrderItem > samplelineitems = new list < OrderItem > ();
                OrderItem templineorder = new OrderItem();
                sampleorder.opportunityID = opportunityID;
                sampleorder.Accountid = [select accountid from opportunity where id = : opportunityID].accountid;
                sampleorder.EffectiveDate = system.today();
                sampleorder.status = 'Cancelled';
                sampleorder.Pricebook2Id = [select id from Pricebook2 where name = 'Standard Price Book'].id;
                sampleorder.CurrencyIsoCode = userinfo.getDefaultCurrency();
                insert sampleorder;
                system.debug('$$$$$' + sampleorder);
                productidlist = new set < id > ();
                map < id, decimal > prcmap = new map < id, decimal > ();
                digitalproductfamily = [select id, Apttus_Config2__RelatedProductId__r.name, Apttus_Config2__RelatedProductId__r.Author__c, Apttus_Config2__RelatedProductId__r.ISBN__c, Apttus_Config2__RelatedProductId__r.InstockDate__c, Apttus_Config2__RelatedProductId__r.Status__c, Apttus_Config2__RelatedProductId__r.IRC_Indicator__c, Apttus_Config2__RelatedProductId__r.Brand__c, Apttus_Config2__RelatedProductId__r.Sampling_Restriction__c, Apttus_Config2__RelatedProductId__r.Free_Copy_Substitute__r.ISBN__c, Apttus_Config2__RelatedProductId__r.Free_Copy_Substitute__r.name, Apttus_Config2__RelatedProductId__r.Category2__c from Apttus_Config2__RelatedProduct__c where PSAM__c = true and Apttus_Config2__ProductId__r.id in : productfamilyids and Apttus_Config2__RelatedProductId__r.Category2__c in ('CourseSmart', 'CourseSmart (Review Only)')];
                map < id, Apttus_Config2__RelatedProduct__c > uniquedigitalproduct = new map < id, Apttus_Config2__RelatedProduct__c > ();
                for (Apttus_Config2__RelatedProduct__c temp: digitalproductfamily) {
                    uniquedigitalproduct.put(temp.id, temp);
                }
                for (id temp: uniquedigitalproduct.keyset()) {
                    productidlist.add(uniquedigitalproduct.get(temp).Apttus_Config2__RelatedProductId__c);
                }
                system.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@' + uniquedigitalproduct + uniquedigitalproduct.size());
                for (selectedproductlineitem temp: selectedproductslist) {
                    //Davi Borges Changed here
                    productidlist.add(temp.product.id);
                }
                system.debug('###########' + productidlist);
                List < PriceBookEntry > lstPrceBook = [SELECT Id, Product2Id, Product2.Id, CurrencyIsoCode, Product2.Name, UnitPrice FROM PriceBookEntry WHERE(Product2Id in : productidlist) and CurrencyIsoCode = : sampleorder.CurrencyIsoCode];
                system.debug('Curreny' + lstPrceBook);
                map < id, id > prcbkmap = new map < id, id > ();
                for (id prodid: productidlist) {
                    for (PriceBookEntry temp: lstPrceBook) {
                        if (temp.Product2Id == prodid) {
                            prcbkmap.put(prodid, temp.id);
                        }
                    }
                }
                for (id prodid: productidlist) {
                    for (PriceBookEntry temp: lstPrceBook) {
                        if (temp.Product2Id == prodid) {
                            prcmap.put(prodid, temp.UnitPrice);
                        }
                    }
                }
                for (selectedproductlineitem temp: selectedproductslist) {
                    Orderitem temp1 = new OrderItem();
                    temp1.orderid = sampleorder.id;
                    //Davi Borges: Changed Here
                    temp1.Shipped_Product__c = temp.product.id;
                    temp1.Quantity = temp.sQuantity;
                    //Davi Borges: Cahnged Here
                    temp1.pricebookentryid = prcbkmap.get(temp.product.id);
                    //Davi Borges: Cahnged Here
                    temp1.unitprice = prcmap.get(temp.product.id);
                    samplelineitems.add(temp1);
                    system.debug('&&&&&&&&&&&1' + samplelineitems);
                }
                for (id temp: uniquedigitalproduct.keyset()) {
                    Orderitem temp1 = new OrderItem();
                    temp1.orderid = sampleorder.id;
                    temp1.Shipped_Product__c = uniquedigitalproduct.get(temp).Apttus_Config2__RelatedProductId__c;
                    temp1.Quantity = 1;
                    temp1.pricebookentryid = prcbkmap.get(uniquedigitalproduct.get(temp).Apttus_Config2__RelatedProductId__c);
                    temp1.unitprice = prcmap.get(uniquedigitalproduct.get(temp).Apttus_Config2__RelatedProductId__c);
                    temp1.Digital_Product_System_Added__c = true;
                    samplelineitems.add(temp1);
                    system.debug('&&&&&&&&&&&2' + samplelineitems);
                }
                insert samplelineitems;
                PageReference redirectPage = new PageReference('/apex/Order_Header?orderid=' + sampleorder.id + '&&oppid=' + opportunityID);
                redirectPage.setRedirect(true);
                return redirectPage;
            } else {
                PageReference redirectPage = new PageReference('/' + opportunityID);
                redirectPage.setRedirect(true);
                return redirectPage;
            }
            return null;
        }
        /**
         * Description : Retrieve Code (4 char) values from Multi - Select picklist
         * @param String
         * @return String
         * @throws NA
         **/
    public void browseOnDefault() {
            notToDisplayOnSerach = true;
            isDisplaySearchPanel = false;
            if (listOfproductFamilyClass == null || listOfproductFamilyClass.isEmpty()) {
                searchMessage = false;
                oppCartEmpty = true;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'No items in the Opportunity cart'));
            }
            showChildren();
        }
        /**
         * Description : on click of serach link hide 'Filters result' section
         * @param String
         * @return String
         * @throws NA
         **/
    public void serachOnDefault() {
            isDisplaySearchPanel = true;
            notToDisplayOnSerach = false;
            selectedSearchType = 'Product Family';
            rowNumber = 0;
            searchTypeList();
            if (listOfproductFamilyClass == null || listOfproductFamilyClass.isEmpty()) {
                searchMessage = false;
                oppCartEmpty = true;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'No items in the Opportunity cart'));
            }
        }
        /**
         * Description : in Serach, if user selects date type then display search text of date etc
         * @param String
         * @return String
         * @throws NA
         **/
    public void changeSerachTextType() {
            selectedFilterbyValue = Apexpages.currentPage().getParameters().get('selectedFilterbyValue');
            selectedRow = Integer.valueOf(Apexpages.currentPage().getParameters().get('selectedRow'));
            system.debug('DEBUG selectedRow::' + selectedRow);
            system.debug('DEBUG selectedFilterbyValue::' + selectedFilterbyValue);
            for (dynamicAddFilterSearch wrapperClass: listWithSelectOptions) {
                system.debug('DEBUG wrapperClass.rowNumber::' + wrapperClass.rowNumber);
                system.debug('DEBUG selectedRow::' + selectedRow);
                system.debug('wrapperClass.selectedProductFilterValue::' + selectedFilterbyValue);
                if ((wrapperClass.selectedProductFilterValue == 'Contains eText' || wrapperClass.selectedProductFilterValue == 'Status' || wrapperClass.selectedProductFilterValue == 'Category') && wrapperClass.rowNumber == selectedRow) {
                    wrapperClass.toDisplayLookup = true;
                    conditionLst = new List < SelectOption > ();
                    conditionLst.add(new SelectOption('', '--None--'));
                    conditionLst.add(new SelectOption('equals', 'equals'));
                    conditionLst.add(new SelectOption('not equal to', 'not equal to'));
                    conditionLst.add(new SelectOption('starts with', 'starts with'));
                    conditionLst.add(new SelectOption('contains', 'contains'));
                    conditionLst.add(new SelectOption('does not contain', 'does not contain'));
                    wrapperClass.conditionLists = conditionLst;
                } else if ((wrapperClass.selectedProductFilterValue != 'Contains eText' || wrapperClass.selectedProductFilterValue != 'Status' || wrapperClass.selectedProductFilterValue == 'Category') && wrapperClass.rowNumber == selectedRow) {
                    wrapperClass.toDisplayLookup = false;
                    if (wrapperClass.selectedProductFilterValue == 'Instock Date' && wrapperClass.rowNumber == selectedRow) {
                        wrapperClass.toDisplayLookup = false;
                        system.debug('wrapperClass.conditionLists*********** ' + wrapperClass.conditionLists);
                        conditionLst = new List < SelectOption > ();
                        conditionLst.add(new SelectOption('starts with', 'starts with'));
                        conditionLst.add(new SelectOption('ends with', 'ends with'));
                        wrapperClass.conditionLists = conditionLst;
                    } else {
                        wrapperClass.toDisplayLookup = false;
                        conditionLst = new List < SelectOption > ();
                        conditionLst.add(new SelectOption('', '--None--'));
                        conditionLst.add(new SelectOption('equals', 'equals'));
                        conditionLst.add(new SelectOption('not equal to', 'not equal to'));
                        conditionLst.add(new SelectOption('starts with', 'starts with'));
                        conditionLst.add(new SelectOption('contains', 'contains'));
                        conditionLst.add(new SelectOption('does not contain', 'does not contain'));
                        wrapperClass.conditionLists = conditionLst;
                    }
                }
            }
        }
        /**
         * Description : Retrieve Code (4 char) values from Multi - Select picklist
         * @param String
         * @return String
         * @throws NA
         **/
    public pageReference addNewFilter() {
            SelectOptionList();
            toDisplayLookup = false;
            searchText = '';
            selectedCondition = '';
            if (listWithSelectOptions.size() <= 4) {
                rowNumber = listWithSelectOptions.size();
                system.debug('DEBUG In AddNewFilter Method rowNumber::' + rowNumber);
                /** Swati : Provided selectedSearchType parameter to constructor **/
                listWithSelectOptions.add(new dynamicAddFilterSearch(productFieldLst, conditionLst, searchType, selectedSearchType, searchText, selectedCondition, toDisplayLookup, rowNumber));
            } else {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Info, 'You can have only five filter(s)');
                ApexPages.addMessage(myMsg);
            }
            System.debug('**********listWithSelectOptions*******' + listWithSelectOptions);
            return null;
        }
        /**
         * Description : Retrieve Code (4 char) values from Multi - Select picklist
         * @param String
         * @return String
         * @throws NA
         **/
    public void searchTypeList() {
            productFieldLst = new List < SelectOption > ();
            toDisplayLookup = false;
            searchText = '';
            selectedCondition = '';
            rowNumber = 0;
            addNewFilterLink = false;
            listWithSelectOptions = new List < dynamicAddFilterSearch > ();
            if (selectedSearchType == 'Product Family') {
                addNewFilterLink = true;
                productFieldLst.add(new SelectOption('', '--None--'));
                productFieldLst.add(new SelectOption('Name', 'Name'));
                productFieldLst.add(new SelectOption('Brand', 'Brand'));
                productFieldLst.add(new SelectOption('Platform', 'Platform'));
                productFieldLst.add(new SelectOption('Relevance', 'Relevance'));
                productFieldLst.add(new SelectOption('Status', 'Status'));
                productFieldLst.add(new SelectOption('Sub Brand', 'Sub Brand'));
                listWithSelectOptions.add(new dynamicAddFilterSearch(productFieldLst, conditionLst, searchType, selectedSearchType, searchText, selectedCondition, toDisplayLookup, rowNumber));
            } else if (selectedSearchType == 'Product') {
                addNewFilterLink = true;
                productFieldLst.add(new SelectOption('Publisher', 'Publisher')); //text          
                productFieldLst.add(new SelectOption('ISBN10', 'ISBN10')); // text
                productFieldLst.add(new SelectOption('ISBN13', 'ISBN13')); // text
                productFieldLst.add(new SelectOption('Product', 'Product')); // name text
                productFieldLst.add(new SelectOption('Author', 'Author')); // text area
                productFieldLst.add(new SelectOption('Copyright Year', 'Copyright Year')); //text
                productFieldLst.add(new SelectOption('Edition', 'Edition')); //text
                productFieldLst.add(new SelectOption('Brand', 'Brand')); //multiselectPicklist
                productFieldLst.add(new SelectOption('Sub Brand', 'Sub Brand')); //multiselectPicklist
                productFieldLst.add(new SelectOption('Category', 'Category')); // picklist
                productFieldLst.add(new SelectOption('Contains eText', 'Contains eText')); // Checkbox                       
                productFieldLst.add(new SelectOption('Instock Date', 'Instock Date')); //Date
                productFieldLst.add(new SelectOption('Platform', 'Platform')); //multiselectPicklist                           
                selectedCondition = 'equals'; //purpose: to display default value equals to "equals" for the first time                      
                searchText = 'Pearson';
                listWithSelectOptions.add(new dynamicAddFilterSearch(productFieldLst, conditionLst, searchType, selectedSearchType, searchText, selectedCondition, toDisplayLookup, rowNumber));
                addNewFilter();
            } else {
                addNewFilterLink = false;
                productFieldLst.add(new SelectOption('', '--None--'));
                listWithSelectOptions.add(new dynamicAddFilterSearch(productFieldLst, conditionLst, searchType, selectedSearchType, searchText, selectedCondition, toDisplayLookup, rowNumber));
            }
        }
        /**
         * Description : Added To Populate Custom Filter Values in VF Page
         * @param String
         * @return String
         * @throws NA
         **/
    public void SelectOptionList() {
            addNewFilterLink = false;
            productFieldLst = new List < SelectOption > ();
            searchType = new List < SelectOption > ();
            conditionLst = new List < SelectOption > ();
            toDisplayLookup = false;
            searchType.add(new SelectOption('', '--None--'));
            searchType.add(new SelectOption('Product', 'Product'));
            searchType.add(new SelectOption('Product Family', 'Product Family'));
            if (selectedSearchType == 'Product Family' || notToDisplayOnSerach == true) {
                addNewFilterLink = true;
                productFieldLst.add(new SelectOption('', '--None--'));
                productFieldLst.add(new SelectOption('Name', 'Name'));
                productFieldLst.add(new SelectOption('Brand', 'Brand'));
                productFieldLst.add(new SelectOption('Platform', 'Platform'));
                productFieldLst.add(new SelectOption('Relevance', 'Relevance'));
                productFieldLst.add(new SelectOption('Status', 'Status'));
                productFieldLst.add(new SelectOption('Sub Brand', 'Sub Brand'));
            } else if (selectedSearchType == 'Product') {
                addNewFilterLink = true;
                productFieldLst.add(new SelectOption('', '--None--'));
                productFieldLst.add(new SelectOption('ISBN10', 'ISBN10')); // text
                productFieldLst.add(new SelectOption('ISBN13', 'ISBN13')); // text
                productFieldLst.add(new SelectOption('Product', 'Product')); // name text
                productFieldLst.add(new SelectOption('Author', 'Author')); // Checkbox
                productFieldLst.add(new SelectOption('Copyright Year', 'Copyright Year')); //text
                productFieldLst.add(new SelectOption('Edition', 'Edition')); //text
                productFieldLst.add(new SelectOption('Brand', 'Brand')); //multiselectPicklist
                productFieldLst.add(new SelectOption('Sub Brand', 'Sub Brand')); //multiselectPicklist
                productFieldLst.add(new SelectOption('Category', 'Category')); // text
                productFieldLst.add(new SelectOption('Contains eText', 'Contains eText')); // Checkbox                       
                productFieldLst.add(new SelectOption('Instock Date', 'Instock Date')); //Date
                productFieldLst.add(new SelectOption('Platform', 'Platform')); //multiselectPicklist   
                productFieldLst.add(new SelectOption('Publisher', 'Publisher'));
            } else {
                addNewFilterLink = false;
                productFieldLst.add(new SelectOption('', '--None--'));
            }
            conditionLst.add(new SelectOption('', '--None--'));
            conditionLst.add(new SelectOption('equals', 'equals'));
            conditionLst.add(new SelectOption('not equal to', 'not equal to'));
            conditionLst.add(new SelectOption('starts with', 'starts with'));
            conditionLst.add(new SelectOption('contains', 'contains'));
            conditionLst.add(new SelectOption('does not contain', 'does not contain'));
        }
        /**
         * Description : Returns Serach Result
         * @param String
         * @return String
         * @throws NA
         **/
    public void searchResults() {
            System.debug('**********in searchResults*******' + productsToDisplay);
            oppCartEmpty = true;
            toDisplayLookup = false;
            CountTotalRecords1 = 0;
            productsToDisplay = new List < Apttus_Config2__PriceListItem__c > ();
            displayProdWraprList = new List < DisplayProductWrapper > ();
            mapDisplayProdWrapr = new Map < Id, DisplayProductWrapper > ();
            String loggedInUserpriceListName = [select Price_List__c from User where id = : UserInfo.getUserId()].Price_List__c;
            System.debug('**********in searchResults*******' + selectedSearchType);
            if (!String.isBlank(loggedInUserpriceListName)) {
                if (selectedSearchType == 'Product') {
                    System.debug('offsetSearchFlag in Product....' + offsetSearchFlag);
                    if (offsetSearchFlag != true) {
                        OffsetSize = 0;
                    }
                    sQuery = 'SELECT Apttus_Config2__ProductId__r.Name, Apttus_Config2__PriceListId__r.name,' + 'Apttus_Config2__ProductId__r.Apttus_Config2__ConfigurationType__c,' + 'Apttus_Config2__ProductId__r.Author__c,' + 'Apttus_Config2__ProductId__r.Copyright_Year__c,' + 'Apttus_Config2__ProductId__r.Edition__c,' + 'Apttus_Config2__ProductId__r.ISBN__c,' + 'Apttus_Config2__ProductId__r.InstockDate__c ,' + 'Apttus_Config2__ProductId__r.Status__c,' + 'Apttus_Config2__ProductId__r.Sub_Brand__c,' + 'Apttus_Config2__ProductId__r.Relevance__c,' + 'Apttus_Config2__ProductId__r.Publisher__c ' + 'FROM Apttus_Config2__PriceListItem__c where ' + 'Apttus_Config2__ProductId__r.Apttus_Config2__ConfigurationType__c = \'Option\'' + ' AND ' + 'Apttus_Config2__PriceListId__r.name= \'' + loggedInUserpriceListName + '\'';
                    for (dynamicAddFilterSearch wrapperClass: listWithSelectOptions) {
                        System.debug('**********wrapperClass.searchText *******' + wrapperClass.searchText);
                        wrapperClass.searchText = wrapperClass.searchText.trim();
                        if (wrapperClass.selectedCondition != '--None--' && wrapperClass.selectedProductFilterValue != '--None--' && wrapperClass.searchText != null) {
                            if (wrapperClass.selectedProductFilterValue == 'Publisher' && wrapperClass.searchText != null) {
                                system.debug('inside value is ==>>' + wrapperClass.searchText);
                                if (wrapperClass.selectedCondition == 'equals' && !wrapperClass.searchText.equals('')) {
                                    sQuery += ' AND Apttus_Config2__ProductId__r.Publisher__c = \'' + String.escapeSingleQuotes(wrapperClass.searchText) + '\'';
                                } else if (wrapperClass.selectedCondition == 'not equal to' && !wrapperClass.searchText.equals('')) {
                                    sQuery += ' AND Apttus_Config2__ProductId__r.Publisher__c != \'' + String.escapeSingleQuotes(wrapperClass.searchText) + '\'';
                                } else if (wrapperClass.selectedCondition == 'starts with' && !wrapperClass.searchText.equals('')) {
                                    sQuery += ' AND Apttus_Config2__ProductId__r.Publisher__c LIKE \'' + String.escapeSingleQuotes(wrapperClass.searchText) + '%\'';
                                } else if (wrapperClass.selectedCondition == 'contains' && !wrapperClass.searchText.equals('')) {
                                    sQuery += ' AND Apttus_Config2__ProductId__r.Publisher__c LIKE \'%' + String.escapeSingleQuotes(wrapperClass.searchText) + '%\'';
                                } else if (wrapperClass.selectedCondition == 'does not contain' && !wrapperClass.searchText.equals('')) {
                                    sQuery += ' AND (NOT Apttus_Config2__ProductId__r.Publisher__c LIKE  \'%' + String.escapeSingleQuotes(wrapperClass.searchText) + '%\')';
                                }
                            }
                            if (wrapperClass.selectedProductFilterValue == 'Product' && wrapperClass.searchText != null) {
                                system.debug('inside value is ==>>' + wrapperClass.searchText);
                                if (wrapperClass.selectedCondition == 'equals' && !wrapperClass.searchText.equals('')) {
                                    sQuery += ' AND Apttus_Config2__ProductId__r.Name = \'' + String.escapeSingleQuotes(wrapperClass.searchText) + '\'';
                                } else if (wrapperClass.selectedCondition == 'not equal to' && !wrapperClass.searchText.equals('')) {
                                    sQuery += ' AND Apttus_Config2__ProductId__r.Name != \'' + String.escapeSingleQuotes(wrapperClass.searchText) + '\'';
                                } else if (wrapperClass.selectedCondition == 'starts with' && !wrapperClass.searchText.equals('')) {
                                    sQuery += ' AND Apttus_Config2__ProductId__r.Name LIKE \'' + String.escapeSingleQuotes(wrapperClass.searchText) + '%\'';
                                } else if (wrapperClass.selectedCondition == 'contains' && !wrapperClass.searchText.equals('')) {
                                    sQuery += ' AND Apttus_Config2__ProductId__r.Name LIKE \'%' + String.escapeSingleQuotes(wrapperClass.searchText) + '%\'';
                                } else if (wrapperClass.selectedCondition == 'does not contain' && !wrapperClass.searchText.equals('')) {
                                    sQuery += ' AND (NOT Apttus_Config2__ProductId__r.Name LIKE  \'%' + String.escapeSingleQuotes(wrapperClass.searchText) + '%\')';
                                }
                            }
                            if (wrapperClass.selectedProductFilterValue == 'ISBN10' && wrapperClass.searchText != null) {
                                system.debug('inside value is ==>>' + wrapperClass.searchText);
                                if (wrapperClass.selectedCondition == 'equals' && !wrapperClass.searchText.equals('')) {
                                    sQuery += ' AND Apttus_Config2__ProductId__r.SBN__c = \'' + String.escapeSingleQuotes(wrapperClass.searchText) + '\'';
                                } else if (wrapperClass.selectedCondition == 'not equal to' && !wrapperClass.searchText.equals('')) {
                                    sQuery += ' AND Apttus_Config2__ProductId__r.SBN__c != \'' + String.escapeSingleQuotes(wrapperClass.searchText) + '\'';
                                } else if (wrapperClass.selectedCondition == 'starts with' && !wrapperClass.searchText.equals('')) {
                                    sQuery += ' AND Apttus_Config2__ProductId__r.SBN__c LIKE \'' + String.escapeSingleQuotes(wrapperClass.searchText) + '%\'';
                                } else if (wrapperClass.selectedCondition == 'contains' && !wrapperClass.searchText.equals('')) {
                                    sQuery += ' AND Apttus_Config2__ProductId__r.SBN__c LIKE \'%' + String.escapeSingleQuotes(wrapperClass.searchText) + '%\'';
                                } else if (wrapperClass.selectedCondition == 'does not contain' && !wrapperClass.searchText.equals('')) {
                                    sQuery += ' AND (NOT Apttus_Config2__ProductId__r.SBN__c LIKE  \'%' + String.escapeSingleQuotes(wrapperClass.searchText) + '%\')';
                                }
                            }
                            if (wrapperClass.selectedProductFilterValue == 'ISBN13' && wrapperClass.searchText != null) {
                                system.debug('inside value is ==>>' + wrapperClass.searchText);
                                if (wrapperClass.selectedCondition == 'equals' && !wrapperClass.searchText.equals('')) {
                                    sQuery += ' AND Apttus_Config2__ProductId__r.ISBN__c = \'' + String.escapeSingleQuotes(wrapperClass.searchText) + '\'';
                                } else if (wrapperClass.selectedCondition == 'not equal to' && !wrapperClass.searchText.equals('')) {
                                    sQuery += ' AND Apttus_Config2__ProductId__r.ISBN__c != \'' + String.escapeSingleQuotes(wrapperClass.searchText) + '\'';
                                } else if (wrapperClass.selectedCondition == 'starts with' && !wrapperClass.searchText.equals('')) {
                                    sQuery += ' AND Apttus_Config2__ProductId__r.ISBN__c LIKE \'' + String.escapeSingleQuotes(wrapperClass.searchText) + '%\'';
                                } else if (wrapperClass.selectedCondition == 'contains' && !wrapperClass.searchText.equals('')) {
                                    sQuery += ' AND Apttus_Config2__ProductId__r.ISBN__c LIKE \'%' + String.escapeSingleQuotes(wrapperClass.searchText) + '%\'';
                                } else if (wrapperClass.selectedCondition == 'does not contain' && !wrapperClass.searchText.equals('')) {
                                    sQuery += ' AND (NOT Apttus_Config2__ProductId__r.ISBN__c LIKE  \'%' + String.escapeSingleQuotes(wrapperClass.searchText) + '%\')';
                                }
                            }
                            if (wrapperClass.selectedProductFilterValue == 'Brand' && wrapperClass.searchText != null) {
                                if (wrapperClass.selectedCondition == 'equals' && !wrapperClass.searchText.equals('')) {
                                    sQuery += ' AND Apttus_Config2__ProductId__r.Brand__c = \'' + String.escapeSingleQuotes(wrapperClass.searchText) + '\'';
                                } else if (wrapperClass.selectedCondition == 'not equal to' && !wrapperClass.searchText.equals('')) {
                                    sQuery += ' AND Apttus_Config2__ProductId__r.Brand__c != \'' + String.escapeSingleQuotes(wrapperClass.searchText) + '\'';
                                } else if (wrapperClass.selectedCondition == 'starts with' && !wrapperClass.searchText.equals('')) {
                                    sQuery += ' AND Apttus_Config2__ProductId__r.Brand__c LIKE \'' + String.escapeSingleQuotes(wrapperClass.searchText) + '%\'';
                                } else if (wrapperClass.selectedCondition == 'contains' && !wrapperClass.searchText.equals('')) {
                                    sQuery += ' AND Apttus_Config2__ProductId__r.Brand__c LIKE \'%' + String.escapeSingleQuotes(wrapperClass.searchText) + '%\'';
                                } else if (wrapperClass.selectedCondition == 'does not contain' && !wrapperClass.searchText.equals('')) {
                                    sQuery += ' AND (NOT Apttus_Config2__ProductId__r.Brand__c LIKE \'%' + String.escapeSingleQuotes(wrapperClass.searchText) + '%\')';
                                }
                            }
                            if (wrapperClass.selectedProductFilterValue == 'Sub Brand' && wrapperClass.searchText != null) {
                                if (wrapperClass.selectedCondition == 'equals' && !wrapperClass.searchText.equals('')) {
                                    sQuery += ' AND Apttus_Config2__ProductId__r.Sub_Brand__c = \'' + String.escapeSingleQuotes(wrapperClass.searchText) + '\'';
                                } else if (wrapperClass.selectedCondition == 'not equal to' && !wrapperClass.searchText.equals('')) {
                                    sQuery += ' AND Apttus_Config2__ProductId__r.Sub_Brand__c != \'' + String.escapeSingleQuotes(wrapperClass.searchText) + '\'';
                                } else if (wrapperClass.selectedCondition == 'starts with' && !wrapperClass.searchText.equals('')) {
                                    sQuery += ' AND Apttus_Config2__ProductId__r.Sub_Brand__c LIKE \'' + String.escapeSingleQuotes(wrapperClass.searchText) + '%\'';
                                } else if (wrapperClass.selectedCondition == 'contains' && !wrapperClass.searchText.equals('')) {
                                    sQuery += ' AND Apttus_Config2__ProductId__r.Sub_Brand__c LIKE \'%' + String.escapeSingleQuotes(wrapperClass.searchText) + '%\'';
                                } else if (wrapperClass.selectedCondition == 'does not contain' && !wrapperClass.searchText.equals('')) {
                                    sQuery += ' AND (NOT Apttus_Config2__ProductId__r.Sub_Brand__c LIKE \'%' + String.escapeSingleQuotes(wrapperClass.searchText) + '%\')';
                                }
                            }
                            if (wrapperClass.selectedProductFilterValue == 'Category' && wrapperClass.searchText != null) {
                                if (!wrapperClass.searchText.equals('')) {
                                    wrapperClass.searchText = wrapperClass.searchText.replaceAll(',', '\',\'');
                                    wrapperClass.searchText = '\'' + wrapperClass.searchText + '\'';
                                    system.debug('wrapperClass.searchText->' + wrapperClass.searchText);
                                }
                                system.debug('wrapperClass.searchText--->' + wrapperClass.searchText);
                                if (wrapperClass.selectedCondition == 'equals' && !wrapperClass.searchText.equals('')) {
                                    sQuery += ' AND Apttus_Config2__ProductId__r.Category2__c in (' + wrapperClass.searchText + ')';
                                } else if (wrapperClass.selectedCondition == 'not equal to' && !wrapperClass.searchText.equals('')) {
                                    sQuery += ' AND Apttus_Config2__ProductId__r.Category2__c not in (' + wrapperClass.searchText + ')';
                                } else if (wrapperClass.selectedCondition == 'starts with' && !wrapperClass.searchText.equals('')) {
                                    sQuery += ' AND Apttus_Config2__ProductId__r.Category2__c in (' + wrapperClass.searchText + ')';
                                } else if (wrapperClass.selectedCondition == 'contains' && !wrapperClass.searchText.equals('')) {
                                    sQuery += ' AND Apttus_Config2__ProductId__r.Category2__c in (' + wrapperClass.searchText + ')';
                                } else if (wrapperClass.selectedCondition == 'does not contain' && !wrapperClass.searchText.equals('')) {
                                    sQuery += ' AND Apttus_Config2__ProductId__r.Category2__c not in (' + wrapperClass.searchText + ')';
                                }
                            }
                            if (wrapperClass.selectedProductFilterValue == 'Contains eText' && wrapperClass.searchText != null) {
                                system.debug('inside value is ==>>' + wrapperClass.searchText);
                                if (wrapperClass.selectedCondition == 'equals' && !wrapperClass.searchText.equals('')) {
                                    sQuery += ' AND Apttus_Config2__ProductId__r.Contains_eText__c = ' + String.escapeSingleQuotes(wrapperClass.searchText);
                                } else if (wrapperClass.selectedCondition == 'not equal to' && !wrapperClass.searchText.equals('')) {
                                    sQuery += ' AND Apttus_Config2__ProductId__r.Contains_eText__c != ' + String.escapeSingleQuotes(wrapperClass.searchText);
                                } else if (wrapperClass.selectedCondition == 'starts with' && !wrapperClass.searchText.equals('')) {
                                    sQuery += ' AND Apttus_Config2__ProductId__r.Contains_eText__c = ' + String.escapeSingleQuotes(wrapperClass.searchText);
                                } else if (wrapperClass.selectedCondition == 'contains' && !wrapperClass.searchText.equals('')) {
                                    sQuery += ' AND Apttus_Config2__ProductId__r.Contains_eText__c = ' + String.escapeSingleQuotes(wrapperClass.searchText);
                                } else if (wrapperClass.selectedCondition == 'does not contain' && !wrapperClass.searchText.equals('')) {
                                    sQuery += ' AND (NOT Apttus_Config2__ProductId__r.Contains_eText__c = ' + String.escapeSingleQuotes(wrapperClass.searchText) + ')';
                                }
                            }
                            if (wrapperClass.selectedProductFilterValue == 'Copyright Year' && wrapperClass.searchText != null) {
                                system.debug('inside value is ==>>' + wrapperClass.searchText);
                                if (wrapperClass.selectedCondition == 'equals' && !wrapperClass.searchText.equals('')) {
                                    sQuery += ' AND Apttus_Config2__ProductId__r.Copyright_Year__c = \'' + String.escapeSingleQuotes(wrapperClass.searchText) + '\'';
                                } else if (wrapperClass.selectedCondition == 'not equal to' && !wrapperClass.searchText.equals('')) {
                                    sQuery += ' AND Apttus_Config2__ProductId__r.Copyright_Year__c != \'' + String.escapeSingleQuotes(wrapperClass.searchText) + '\'';
                                } else if (wrapperClass.selectedCondition == 'starts with' && !wrapperClass.searchText.equals('')) {
                                    sQuery += ' AND Apttus_Config2__ProductId__r.Copyright_Year__c LIKE \'' + String.escapeSingleQuotes(wrapperClass.searchText) + '%\'';
                                } else if (wrapperClass.selectedCondition == 'contains' && !wrapperClass.searchText.equals('')) {
                                    sQuery += ' AND Apttus_Config2__ProductId__r.Copyright_Year__c LIKE \'%' + String.escapeSingleQuotes(wrapperClass.searchText) + '%\'';
                                } else if (wrapperClass.selectedCondition == 'does not contain' && !wrapperClass.searchText.equals('')) {
                                    sQuery += ' AND (NOT Apttus_Config2__ProductId__r.Copyright_Year__c LIKE  \'%' + String.escapeSingleQuotes(wrapperClass.searchText) + '%\')';
                                }
                            }
                            if (wrapperClass.selectedProductFilterValue == 'Edition' && wrapperClass.searchText != null) {
                                system.debug('inside value is ==>>' + wrapperClass.searchText);
                                if (wrapperClass.selectedCondition == 'equals' && !wrapperClass.searchText.equals('')) {
                                    sQuery += ' AND Apttus_Config2__ProductId__r.Edition__c = \'' + String.escapeSingleQuotes(wrapperClass.searchText) + '\'';
                                } else if (wrapperClass.selectedCondition == 'not equal to' && !wrapperClass.searchText.equals('')) {
                                    sQuery += ' AND Apttus_Config2__ProductId__r.Edition__c != \'' + String.escapeSingleQuotes(wrapperClass.searchText) + '\'';
                                } else if (wrapperClass.selectedCondition == 'starts with' && !wrapperClass.searchText.equals('')) {
                                    sQuery += ' AND Apttus_Config2__ProductId__r.Edition__c LIKE \'' + String.escapeSingleQuotes(wrapperClass.searchText) + '%\'';
                                } else if (wrapperClass.selectedCondition == 'contains' && !wrapperClass.searchText.equals('')) {
                                    sQuery += ' AND Apttus_Config2__ProductId__r.Edition__c LIKE \'%' + String.escapeSingleQuotes(wrapperClass.searchText) + '%\'';
                                } else if (wrapperClass.selectedCondition == 'does not contain' && !wrapperClass.searchText.equals('')) {
                                    sQuery += ' AND (NOT Apttus_Config2__ProductId__r.Edition__c LIKE  \'%' + String.escapeSingleQuotes(wrapperClass.searchText) + '%\')';
                                }
                            }
                            // change to instock date
                            if (wrapperClass.selectedProductFilterValue == 'Instock Date' && wrapperClass.searchText != null) {
                                system.debug('inside value is ==>>' + wrapperClass.searchText);
                                string[] dateStr = wrapperClass.searchText.split('/');
                                Date dateToCompare = date.newInstance(Integer.valueOf(dateStr[2]), Integer.valueOf(dateStr[1]), Integer.valueOf(dateStr[0])); // yyyy-mm-dd                            
                                system.debug('inside value is ==>>' + dateToCompare);
                                if (wrapperClass.selectedCondition == 'starts with' && !wrapperClass.searchText.equals('')) {
                                    sQuery += ' AND Apttus_Config2__ProductId__r.InstockDate__c >=: dateToCompare';
                                } else if (wrapperClass.selectedCondition == 'ends with' && !wrapperClass.searchText.equals('')) {
                                    sQuery += ' AND Apttus_Config2__ProductId__r.InstockDate__c <=: dateToCompare';
                                }
                            }
                            if (wrapperClass.selectedProductFilterValue == 'Platform' && wrapperClass.searchText != null) {
                                if (wrapperClass.selectedCondition == 'equals' && !wrapperClass.searchText.equals('')) {
                                    sQuery += ' AND Apttus_Config2__ProductId__r.Platform__c = \'' + String.escapeSingleQuotes(wrapperClass.searchText) + '\'';
                                } else if (wrapperClass.selectedCondition == 'not equal to' && !wrapperClass.searchText.equals('')) {
                                    sQuery += ' AND Apttus_Config2__ProductId__r.Platform__c != \'' + String.escapeSingleQuotes(wrapperClass.searchText) + '\'';
                                } else if (wrapperClass.selectedCondition == 'starts with' && !wrapperClass.searchText.equals('')) {
                                    sQuery += ' AND Apttus_Config2__ProductId__r.Platform__c LIKE \'' + String.escapeSingleQuotes(wrapperClass.searchText) + '%\'';
                                } else if (wrapperClass.selectedCondition == 'contains' && !wrapperClass.searchText.equals('')) {
                                    sQuery += ' AND Apttus_Config2__ProductId__r.Platform__c LIKE \'%' + String.escapeSingleQuotes(wrapperClass.searchText) + '%\'';
                                } else if (wrapperClass.selectedCondition == 'does not contain' && !wrapperClass.searchText.equals('')) {
                                    sQuery += ' AND (NOT Apttus_Config2__ProductId__r.Platform__c LIKE \'%' + String.escapeSingleQuotes(wrapperClass.searchText) + '%\')';
                                }
                            }
                            if (wrapperClass.selectedProductFilterValue == 'Author' && wrapperClass.searchText != null) {
                                system.debug('inside value is ==>>' + wrapperClass.searchText);
                                if (wrapperClass.selectedCondition == 'equals' && !wrapperClass.searchText.equals('')) {
                                    sQuery += ' AND Apttus_Config2__ProductId__r.Author__c = \'' + String.escapeSingleQuotes(wrapperClass.searchText) + '\'';
                                } else if (wrapperClass.selectedCondition == 'not equal to' && !wrapperClass.searchText.equals('')) {
                                    sQuery += ' AND Apttus_Config2__ProductId__r.Author__c != \'' + String.escapeSingleQuotes(wrapperClass.searchText) + '\'';
                                } else if (wrapperClass.selectedCondition == 'starts with' && !wrapperClass.searchText.equals('')) {
                                    sQuery += ' AND Apttus_Config2__ProductId__r.Author__c LIKE \'' + String.escapeSingleQuotes(wrapperClass.searchText) + '%\'';
                                } else if (wrapperClass.selectedCondition == 'contains' && !wrapperClass.searchText.equals('')) {
                                    sQuery += ' AND Apttus_Config2__ProductId__r.Author__c LIKE \'%' + String.escapeSingleQuotes(wrapperClass.searchText) + '%\'';
                                } else if (wrapperClass.selectedCondition == 'does not contain' && !wrapperClass.searchText.equals('')) {
                                    sQuery += ' AND (NOT Apttus_Config2__ProductId__r.Author__c LIKE  \'%' + String.escapeSingleQuotes(wrapperClass.searchText) + '%\')';
                                }
                            }
                        }
                    }
                    sQuery += ' limit ' + QueryLimit + ' offset ' + OffsetSize;
                    system.debug('sQuery===>>>>' + sQuery);
                    try {
                        productsToDisplay = Database.query(sQuery);
                        System.debug(sQuery);
                        CountTotalRecords1 = searchResults1(); //productsToDisplay.size();
                        getSearchTotalPages(); //for count search
                        getSearchPageNumberSearchClick();
                        //for count search ends
                        if (!productsToDisplay.isEmpty()) {
                            system.debug('listWithProdFamily ===>>>>' + productsToDisplay);
                            system.debug('CountTotalRecords1 ===>>>>' + CountTotalRecords1);
                        } else {
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'No records were found based on your criteria'));
                            searchMessage = true;
                        }
                        toDisplayProducts = true;
                        displayProductFamilyOnSerach = false;
                        displayOnPearsonClick = false;
                        fromTaxanomy = false;
                        displayProductFamilyOnLoad = false;
                    } catch (Exception e) {
                        system.debug('exception===>>>>' + e);
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Ooops! Contact your Administrator' + e.getTypeName() + ':' + e.getMessage() + ':LINE ' + e.getLineNumber()));
                    }
                } else if (selectedSearchType == 'Product Family') {
                    System.debug('offsetSearchFlag in ProductFamily....' + offsetSearchFlag);
                    if (offsetSearchFlag != true) {
                        offSetFamily = 0;
                    }
                    System.debug('offSetFamily.......' + offSetFamily);
                    sQuery = 'SELECT Apttus_Config2__ProductId__r.Name, Apttus_Config2__PriceListId__r.name,' + 'Apttus_Config2__ProductId__r.Apttus_Config2__ConfigurationType__c,' + 'Apttus_Config2__ProductId__r.Author__c,' + 'Apttus_Config2__ProductId__r.Copyright_Year__c,' + 'Apttus_Config2__ProductId__r.Edition__c,' + 'Apttus_Config2__ProductId__r.ISBN__c,' + 'Apttus_Config2__ProductId__r.InstockDate__c ,' + 'Apttus_Config2__ProductId__r.Status__c,' + 'Apttus_Config2__ProductId__r.Sub_Brand__c,' + 'Apttus_Config2__ProductId__r.Priority__c,' + 'Apttus_Config2__ProductId__r.Platform__c,' + 'Apttus_Config2__ProductId__r.Relevance__c,' + 'Apttus_Config2__ListPrice__c,' + 'Net_Price__c,' + 'Apttus_Config2__ProductId__r.Publisher__c ' + 'FROM Apttus_Config2__PriceListItem__c where ' + 'Apttus_Config2__ProductId__r.Apttus_Config2__ConfigurationType__c = \'Bundle\'' + ' AND ' + 'Apttus_Config2__PriceListId__r.name= \'' + loggedInUserpriceListName + '\'';
                    for (dynamicAddFilterSearch wrapperClass: listWithSelectOptions) {
                        if (wrapperClass.selectedCondition != '--None--' && wrapperClass.selectedProductFilterValue != '--None--' && wrapperClass.searchText != null) {
                            wrapperClass.searchText = wrapperClass.searchText.trim();
                            if (wrapperClass.selectedProductFilterValue == 'Name' && wrapperClass.searchText != null) {
                                system.debug('inside value is ==>>' + wrapperClass.searchText);
                                if (wrapperClass.selectedCondition == 'equals' && !wrapperClass.searchText.equals('')) {
                                    sQuery += ' AND Apttus_Config2__ProductId__r.Name = \'' + String.escapeSingleQuotes(wrapperClass.searchText) + '\'';
                                } else if (wrapperClass.selectedCondition == 'not equal to' && !wrapperClass.searchText.equals('')) {
                                    sQuery += ' AND Apttus_Config2__ProductId__r.Name != \'' + String.escapeSingleQuotes(wrapperClass.searchText) + '\'';
                                } else if (wrapperClass.selectedCondition == 'starts with' && !wrapperClass.searchText.equals('')) {
                                    sQuery += ' AND Apttus_Config2__ProductId__r.Name LIKE \'' + String.escapeSingleQuotes(wrapperClass.searchText) + '%\'';
                                } else if (wrapperClass.selectedCondition == 'contains' && !wrapperClass.searchText.equals('')) {
                                    sQuery += ' AND Apttus_Config2__ProductId__r.Name LIKE \'%' + String.escapeSingleQuotes(wrapperClass.searchText) + '%\'';
                                } else if (wrapperClass.selectedCondition == 'does not contain' && !wrapperClass.searchText.equals('')) {
                                    sQuery += ' AND (NOT Apttus_Config2__ProductId__r.Name LIKE \'%' + String.escapeSingleQuotes(wrapperClass.searchText) + '%\')';
                                }
                            }
                            if (wrapperClass.selectedProductFilterValue == 'Brand' && wrapperClass.searchText != null) {
                                if (wrapperClass.selectedCondition == 'equals' && !wrapperClass.searchText.equals('')) {
                                    sQuery += ' AND Apttus_Config2__ProductId__r.Brand__c = \'' + String.escapeSingleQuotes(wrapperClass.searchText) + '\'';
                                } else if (wrapperClass.selectedCondition == 'not equal to' && !wrapperClass.searchText.equals('')) {
                                    sQuery += ' AND Apttus_Config2__ProductId__r.Brand__c != \'' + String.escapeSingleQuotes(wrapperClass.searchText) + '\'';
                                } else if (wrapperClass.selectedCondition == 'starts with' && !wrapperClass.searchText.equals('')) {
                                    sQuery += ' AND Apttus_Config2__ProductId__r.Brand__c LIKE \'' + String.escapeSingleQuotes(wrapperClass.searchText) + '%\'';
                                } else if (wrapperClass.selectedCondition == 'contains' && !wrapperClass.searchText.equals('')) {
                                    sQuery += ' AND Apttus_Config2__ProductId__r.Brand__c LIKE \'%' + String.escapeSingleQuotes(wrapperClass.searchText) + '%\'';
                                } else if (wrapperClass.selectedCondition == 'does not contain' && !wrapperClass.searchText.equals('')) {
                                    sQuery += ' AND (NOT Apttus_Config2__ProductId__r.Brand__c LIKE \'%' + String.escapeSingleQuotes(wrapperClass.searchText) + '%\')';
                                }
                            }
                            if (wrapperClass.selectedProductFilterValue == 'Platform' && wrapperClass.searchText != null) {
                                if (wrapperClass.selectedCondition == 'equals' && !wrapperClass.searchText.equals('')) {
                                    sQuery += ' AND Apttus_Config2__ProductId__r.Platform__c = \'' + String.escapeSingleQuotes(wrapperClass.searchText) + '\'';
                                } else if (wrapperClass.selectedCondition == 'not equal to' && !wrapperClass.searchText.equals('')) {
                                    sQuery += ' AND Apttus_Config2__ProductId__r.Platform__c != \'' + String.escapeSingleQuotes(wrapperClass.searchText) + '\'';
                                } else if (wrapperClass.selectedCondition == 'starts with' && !wrapperClass.searchText.equals('')) {
                                    sQuery += ' AND Apttus_Config2__ProductId__r.Platform__c LIKE \'' + String.escapeSingleQuotes(wrapperClass.searchText) + '%\'';
                                } else if (wrapperClass.selectedCondition == 'contains' && !wrapperClass.searchText.equals('')) {
                                    sQuery += ' AND Apttus_Config2__ProductId__r.Platform__c LIKE \'%' + String.escapeSingleQuotes(wrapperClass.searchText) + '%\'';
                                } else if (wrapperClass.selectedCondition == 'does not contain' && !wrapperClass.searchText.equals('')) {
                                    sQuery += ' AND (NOT Apttus_Config2__ProductId__r.Platform__c LIKE \'%' + String.escapeSingleQuotes(wrapperClass.searchText) + '%\')';
                                }
                            }
                            if (wrapperClass.selectedProductFilterValue == 'Relevance' && wrapperClass.searchText != null) {
                                system.debug('inside value is ==>>' + wrapperClass.searchText);
                                if (wrapperClass.selectedCondition == 'equals' && !wrapperClass.searchText.equals('')) {
                                    sQuery += ' AND Apttus_Config2__ProductId__r.Relevance_Value__c = ' + String.escapeSingleQuotes(wrapperClass.searchText);
                                } else if (wrapperClass.selectedCondition == 'not equal to' && !wrapperClass.searchText.equals('')) {
                                    sQuery += ' AND Apttus_Config2__ProductId__r.Relevance_Value__c != ' + String.escapeSingleQuotes(wrapperClass.searchText);
                                } else if (wrapperClass.selectedCondition == 'starts with' && !wrapperClass.searchText.equals('')) {
                                    sQuery += ' AND Apttus_Config2__ProductId__r.Relevance_Value__c = ' + String.escapeSingleQuotes(wrapperClass.searchText);
                                } else if (wrapperClass.selectedCondition == 'contains' && !wrapperClass.searchText.equals('')) {
                                    sQuery += ' AND Apttus_Config2__ProductId__r.Relevance_Value__c = ' + String.escapeSingleQuotes(wrapperClass.searchText);
                                } else if (wrapperClass.selectedCondition == 'does not contain' && !wrapperClass.searchText.equals('')) {
                                    sQuery += ' AND Apttus_Config2__ProductId__r.Relevance_Value__c != ' + String.escapeSingleQuotes(wrapperClass.searchText);
                                }
                            }
                            if (wrapperClass.selectedProductFilterValue == 'Status' && wrapperClass.searchText != null) {
                                if (!wrapperClass.searchText.equals('')) {
                                    wrapperClass.searchText = wrapperClass.searchText.replaceAll(',', '\',\'');
                                    wrapperClass.searchText = '\'' + wrapperClass.searchText + '\'';
                                    system.debug('wrapperClass.searchText->' + wrapperClass.searchText);
                                }
                                system.debug('wrapperClass.searchText--->' + wrapperClass.searchText);
                                if (wrapperClass.selectedCondition == 'equals' && !wrapperClass.searchText.equals('')) {
                                    sQuery += ' AND Apttus_Config2__ProductId__r.Status__c in (' + wrapperClass.searchText + ')';
                                } else if (wrapperClass.selectedCondition == 'not equal to' && !wrapperClass.searchText.equals('')) {
                                    sQuery += ' AND Apttus_Config2__ProductId__r.Status__c not in (' + wrapperClass.searchText + ')';
                                } else if (wrapperClass.selectedCondition == 'starts with' && !wrapperClass.searchText.equals('')) {
                                    sQuery += ' AND Apttus_Config2__ProductId__r.Status__c in (' + wrapperClass.searchText + ')';
                                } else if (wrapperClass.selectedCondition == 'contains' && !wrapperClass.searchText.equals('')) {
                                    sQuery += ' AND Apttus_Config2__ProductId__r.Status__c in (' + wrapperClass.searchText + ')';
                                } else if (wrapperClass.selectedCondition == 'does not contain' && !wrapperClass.searchText.equals('')) {
                                    sQuery += ' AND Apttus_Config2__ProductId__r.Status__c not in (' + wrapperClass.searchText + ')';
                                }
                            }
                            if (wrapperClass.selectedProductFilterValue == 'Sub Brand' && wrapperClass.searchText != null) {
                                if (wrapperClass.selectedCondition == 'equals' && !wrapperClass.searchText.equals('')) {
                                    sQuery += ' AND Apttus_Config2__ProductId__r.Sub_Brand__c = \'' + String.escapeSingleQuotes(wrapperClass.searchText) + '\'';
                                } else if (wrapperClass.selectedCondition == 'not equal to' && !wrapperClass.searchText.equals('')) {
                                    sQuery += ' AND Apttus_Config2__ProductId__r.Sub_Brand__c != \'' + String.escapeSingleQuotes(wrapperClass.searchText) + '\'';
                                } else if (wrapperClass.selectedCondition == 'starts with' && !wrapperClass.searchText.equals('')) {
                                    sQuery += ' AND Apttus_Config2__ProductId__r.Sub_Brand__c LIKE \'' + String.escapeSingleQuotes(wrapperClass.searchText) + '%\'';
                                } else if (wrapperClass.selectedCondition == 'contains' && !wrapperClass.searchText.equals('')) {
                                    sQuery += ' AND Apttus_Config2__ProductId__r.Sub_Brand__c LIKE \'%' + String.escapeSingleQuotes(wrapperClass.searchText) + '%\'';
                                } else if (wrapperClass.selectedCondition == 'does not contain' && !wrapperClass.searchText.equals('')) {
                                    sQuery += ' AND (NOT Apttus_Config2__ProductId__r.Sub_Brand__c LIKE \'%' + String.escapeSingleQuotes(wrapperClass.searchText) + '%\')';
                                }
                            }
                        }
                    }
                    sQuery += ' order by Apttus_Config2__ProductId__r.Relevance_Value__c,Apttus_Config2__ProductId__r.Name Asc Nulls Last';
                    sQuery += ' limit ' + QueryLimit + ' offset ' + offSetFamily;
                    system.debug('sQuery===>>>>' + sQuery);
                    try {
                        listWithProdId = new List < ID > ();
                        productFamilies = Database.query(sQuery);
                        CountTotalRecords1 = searchResults1(); //productsToDisplay.size();
                        getSearchTotalPages(); //for count search
                        getSearchPageNumberSearchClick();
                        //for count search ends
                        if (!productFamilies.isEmpty()) {
                            for (Apttus_Config2__PriceListItem__c priceListItm: productFamilies) {
                                if (priceListItm != null) {
                                    listWithProdId.add(priceListItm.Apttus_Config2__ProductId__c);
                                    mapDisplayProdWrapr.put(priceListItm.Apttus_Config2__ProductId__c, new DisplayProductWrapper(priceListItm, null, null));
                                }
                            }
                            system.debug('mapDisplayProdWrapr after search===>>>>' + mapDisplayProdWrapr);
                            toDisplayProducts = false;
                            displayProductFamilyOnLoad = false;
                            fromTaxanomy = false;
                            displayProductFamilyOnSerach = true;
                            displayOnPearsonClick = false;
                            searchFilterResultsFlag = false;
                        } else {
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'No records were found based on your criteria'));
                            searchMessage = true;
                        }
                    } catch (Exception e) {
                        system.debug('exception===>>>>' + e);
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Ooops! Contact your Administrator' + e.getTypeName() + ':' + e.getMessage() + ':LINE ' + e.getLineNumber()));
                    }
                    system.debug('mapDisplayProdWrapr===>>>>' + mapDisplayProdWrapr);
                } else {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'There is no price list associated to the current user. Please contact your administrator for more details.'));
                }
            }
        }
        /**
         * Description : Returns products with configuration type ="option" on Search 
         * @param String
         * @return String
         * @throws NA
         **/
    public List < Apttus_Config2__PriceListItem__c > getProducts() {
            if (!productsToDisplay.isEmpty()) {
                toDisplayProducts = true;
             
                System.debug('**********productsToDisplay in get product******* Size:' + productsToDisplay.size());
                System.debug('**********productsToDisplay in get product*******' + productsToDisplay);
                return productsToDisplay;
            }
 
            return null;
        }
        /**
         * Description : Returns products with configuration type ="Bundle" on Search 
         * @param String
         * @return String
         * @throws NA
         **/
    public Map < Id, DisplayProductWrapper > getProductFamilys() {
            System.debug('**********productsToDisplay in get product*******' + displayProdWraprList);
            if (!displayProdWraprList.isEmpty()) {
                toDisplayProducts = false;
                displayProductFamilyOnLoad = true;
                System.debug('**********productsToDisplay in get product*******' + displayProdWraprList);
                return mapDisplayProdWrapr;
                //return displayProdWraprList;            
            }
            if (!mapDisplayProdWrapr.keySet().isEmpty()) {
                toDisplayProducts = false;
                displayProductFamilyOnLoad = true;
                System.debug('**********productsToDisplay in get product*******' + mapdisplayProdWrapr);
                return mapDisplayProdWrapr;
            }
            System.debug('i am' + mapDisplayProdWrapr);
            return null;
        }
        /* Added For Quantity logic from Opportunity*/
    public void OppQuantity() {
            oppQuantity = new List < Opportunity > ();
            oppQuantity = [select Selling_Period__c, Spring__c, Fall__c, CurrencyIsoCode from Opportunity where Opportunity.id = : opportunityID];
            if (!oppQuantity.isEmpty()) {
                for (Opportunity opp: oppQuantity) {
                    //if((opp.Selling_Period__c=='2014 - Spring'||opp.Selling_Period__c=='2015 - Spring'||opp.Selling_Period__c=='2016 - //Spring'||opp.Selling_Period__c=='2017 - Spring') && opp.Spring__c != null){
                    if ((opp.Selling_Period__c.contains('Spring')) && opp.Spring__c != null && opp.Spring__c != 0) {
                        Quantityopp = opp.Spring__c;
                    }
                    //else if((opp.Selling_Period__c=='2014 - Fall'||opp.Selling_Period__c=='2015 - Fall'||opp.Selling_Period__c=='2016 - //Fall'||opp.Selling_Period__c=='2017 - Fall') &&  opp.Fall__c != null){
                    else if ((opp.Selling_Period__c.contains('Fall')) && opp.Fall__c != null && opp.Fall__c != 0) {
                        System.debug(opp.Fall__c);
                        Quantityopp = opp.Fall__c;
                    } else if (opp.Selling_Period__c == null || opp.Spring__c == null || opp.Fall__c == null || opp.Spring__c == 0 || opp.Fall__c == 0) {
                        Quantityopp = 1;
                    }
                    if (opp.CurrencyIsoCode != null) {
                        oppCurrency = opp.CurrencyIsoCode;
                        System.debug('oppCurrency...................' + oppCurrency);
                    }
                }
            }
        }
        /**
         * Description :Added Product To Opportunity Cart on CLick of AddToOptty button in PearsonChoice Table. 
         * @param String
         * @return String
         * @throws NA
         **/
    public pageReference addToOpptyPearsonChoice() {
            List < Product2 > listWithProductFromPearsonChoice = new List < Product2 > ();
            productFamilyClass prodClassForPearsonChoice;
            try {
                //if (selectedWrapperProduct != null) 
        //listWithProductFromPearsonChoice = [select id, name, Author__c, Edition__c, ISBN__c, Copyright_Year__c from Product2 where id IN: selectedWrapperProduct];
                if (selectedWrapperProduct != null) {
                    ap1 = new List < Apttus_Config2__PriceListItem__c > ();
                    ap1 = [select Apttus_Config2__ProductId__c, Apttus_Config2__ProductId__r.name,Apttus_Config2__ProductId__r.Copyright_Year__c,Apttus_Config2__ProductId__r.Author__c,Apttus_Config2__ProductId__r.Edition__c,Apttus_Config2__ProductId__r.ISBN__c, Apttus_Config2__ListPrice__c,
                        Net_Price__c from Apttus_Config2__PriceListItem__c
                        where Apttus_Config2__ProductId__c IN: selectedWrapperProduct and Apttus_Config2__PriceListId__r.name = : loggedInUserpriceListNamebase and Apttus_Config2__Active__c = true limit 50000
                    ];
                }
                if (!ap1.isempty()) {
                    for (Apttus_Config2__PriceListItem__c prod2List: ap1) {
                        prodClassForPearsonChoice = new productFamilyClass();
                        prodClassForPearsonChoice.oppProd = prod2List;
                        Decimal decimalQuantity2 = Quantityopp;
                        if (decimalQuantity2 != null) {
                            Integer integerQuantity2 = decimalQuantity2.intValue();
                            prodClassForPearsonChoice.sQuantity = integerQuantity2;
                        }
                        listOfproductFamilyClass.add(prodClassForPearsonChoice);
                        cartProdFromURL = cartProdFromURL+prod2List.Apttus_Config2__ProductId__c+'%2C'+prodClassForPearsonChoice.sQuantity+'%2C';
                    }
                }
                if (selectedWrapperProduct != null) {
                    selectedWrapperProduct.clear();
                }
            } catch (Exception e) {
                System.debug(e);
            }
        return null;
    }
        /**
         * Description :Added Product To Opportunity Cart on CLick of AddToOptty button in ProductFamily Table. 
         * @param String
         * @return String
         * @throws NA
         **/
    public pageReference addToOppty() {
            /*List<productFamilyClass> tmp = new List<productFamilyClass>();
            tmp.addAll(listOfproductFamilyClass);
            System.debug('Before adding to cart'+tmp);    */    
            searchMessage = true;
            listWithPSellFamily = new List < Apttus_Config2__RelatedProduct__c > ();
            //String loggedInUserpriceListNamebase = [select Price_List__c from User where id =: UserInfo.getUserId()].Price_List__c;
            List < Apttus_Config2__PriceListItem__c > apBase = new List < Apttus_Config2__PriceListItem__c > ();
            if (productFamilyIdFromURL == null && productCatalogIdFromURL == null) {
            apBase = [select Apttus_Config2__ProductId__c, Apttus_Config2__ProductId__r.name, Apttus_Config2__ListPrice__c,
                Net_Price__c from Apttus_Config2__PriceListItem__c
                where Apttus_Config2__ProductId__c = : productId and Apttus_Config2__PriceListId__r.name = : loggedInUserpriceListNamebase and Apttus_Config2__Active__c = true
            ];
            System.debug('To check pricelist....' + apBase);
            // String priceBookCurrency=[SELECT Id, Product2Id,CurrencyISOCode FROM PriceBookEntry WHERE Product2Id=:productId AND PriceBook2.isStandard=true AND isActive=true LIMIT 1];
            // System.debug('priceBookCurrency....'+priceBookCurrency);
            if (selectedWrapperProduct != null) {
                //pearsonChoicesRecordProductTab = [select Apttus_Config2__ProductId__r.id,Apttus_Config2__RelatedProductId__r.name,Apttus_Config2__RelatedProductId__r.id,PSELL__c from Apttus_Config2__RelatedProduct__c where PSELL__c=true and Apttus_Config2__ProductId__r.id IN: selectedWrapperProduct ];
            }
            system.debug('productId-->' + displayProductFamilyOnLoad + displayProductFamilyOnSerach + displayOnPearsonClick + fromTaxanomy + productId);
            
                if (displayProductFamilyOnLoad || displayProductFamilyOnSerach || displayOnPearsonClick || fromTaxanomy || searchFilterResultsFlag) {
                    if (loggedInUserpriceListNamebase != null && !apBase.isEmpty()) {
                        listWithPSellFamily = [select Apttus_Config2__ProductId__r.id, Apttus_Config2__RelatedProductId__r.name, Apttus_Config2__RelatedProductId__r.ISBN__c, Apttus_Config2__RelatedProductId__r.Author__c, Apttus_Config2__RelatedProductId__r.Edition__c, Apttus_Config2__RelatedProductId__r.Copyright_Year__c, Apttus_Config2__RelatedProductId__r.id, PSELL__c from Apttus_Config2__RelatedProduct__c where PSELL__c = true and Apttus_Config2__ProductId__r.id = : productId];
                        system.debug('listWithPSellFamily-->' + listWithPSellFamily);
                        if (!listWithPSellFamily.isempty()) {
                            String RelatedId = listWithPSellFamily[0].Apttus_Config2__RelatedProductId__r.id;
                            ap1 = new List < Apttus_Config2__PriceListItem__c > ();
                            // String loggedInUserpriceListNamePsell = [select Price_List__c from User where id =: UserInfo.getUserId()].Price_List__c;
                            ap1 = [select Apttus_Config2__ProductId__c, Apttus_Config2__ProductId__r.name, Apttus_Config2__ListPrice__c,
                                Net_Price__c from Apttus_Config2__PriceListItem__c
                                where Apttus_Config2__ProductId__c = : RelatedId and Apttus_Config2__PriceListId__r.name = : loggedInUserpriceListNamebase and Apttus_Config2__Active__c = true
                            ];
                            System.debug('To check pricelist....' + ap1 + RelatedId);
                            List < PriceBookEntry > priceBookCurrency = [SELECT Id, Product2Id, CurrencyISOCode FROM PriceBookEntry WHERE Product2Id = : RelatedId AND PriceBook2.isStandard = true AND isActive = true];
                            String priceCurr;
                            System.debug('priceBookCurrency....inside family' + priceBookCurrency[0].CurrencyISOCode + priceBookCurrency.size());
                            if (priceBookCurrency.size() > 0) {
                                for (Integer i = 0; i < priceBookCurrency.size(); i++) {
                                    System.debug('inside for loop......' + oppCurrency + priceBookCurrency[i].CurrencyISOCode);
                                    if (priceBookCurrency[i].CurrencyISOCode == oppCurrency) {
                                        priceCurr = priceBookCurrency[i].CurrencyISOCode;
                                        System.debug('priceCurr..........' + priceCurr);
                                    }
                                }
                            }
                            // added by Kyama
                            // already product added to existing list, dont add
                            if (!listWithPSellFamily.isempty() && !ap1.isempty()) {
                                /*  for(productFamilyClass prodClass : listOfproductFamilyClass){
                                    if(prodClass.relatedProd!=null){
                                     System.debug('prodClass.relatedProd.apttus_config2__relatedproductid__r.id is'+prodClass.relatedProd.apttus_config2__relatedproductid__r.id);
                                     System.debug('listWithPSellFamily[0].id'+listWithPSellFamily[0].apttus_config2__relatedproductid__r.id);
                                     
                                     if(prodClass.relatedProd.apttus_config2__relatedproductid__r.id == listWithPSellFamily[0].apttus_config2__relatedproductid__r.id){
                                         return null;
                                         }
                                     }   
                                 }*/
 
                                //Commented as there is no Duplicate Logic yet.
                                if (priceBookCurrency != null && priceCurr != null) {
                                    
                                    productFamilyClass prodClass = new productFamilyClass();
                                    prodClass.relatedProd = listWithPSellFamily[0];
                                    System.debug('prodClass.relatedProd1.Product2.name...' + prodClass.relatedProd1.Product2.name);
                                    Decimal decimalQuantity1 = Quantityopp;
                                    System.debug('Quantityopp...' + Quantityopp);
                                    System.debug('listWithPSellFamily[0].Apttus_Config2__RelatedProductId__r.name...' + listWithPSellFamily[0].Apttus_Config2__RelatedProductId__r.name);
                                    if (decimalQuantity1 != null) {
                                        Integer integerQuantity1 = decimalQuantity1.intValue();
                                        prodClass.sQuantity = integerQuantity1;
                                    }
                                    listOfproductFamilyClass.add(prodClass);
                                    cartProdFromURL = cartProdFromURL+listWithPSellFamily[0].Apttus_Config2__RelatedProductId__r.id+'%2C'+prodClass.sQuantity+'%2C';
                                   // listOfproductFamilyClass.add(new productFamilyClass(listWithPSellFamily[0],Quantityopp));
                                    //System.debug(listOfproductFamilyClass);
                                    //addToOpty=true;     
                                } else {
                                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'PSell Product is not associated with Standard Pricebook/Opportunity Currency Does not match pricebook currency.'));
                                    PricebookCurrencyError = true;
                                }
                            } else {
                                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'PSell Product is not associated with  Pricelist'));
                                PsellProductError = true;
                            }
                        } else {
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, ' PSell Product is Not associated with Product Family'));
                            PSellError = true;
                        }
                    } else {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Product Family is not associated with  Pricelist'));
                        baseProductError = true;
                    }
                }
                if(listOfproductFamilyClass.isEmpty() || listOfproductFamilyClass == null)
                {
                    oppCartEmpty = true;
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'No items in the Opportunity cart'));
                } 

                
            }
            //add to cart : products
            system.debug('productsToDisplay :' + productsToDisplay);
            system.debug('packageDetailsForProductCatalog :' + packageDetailsForProductCatalog);
            system.debug('packageChildDetailsForProductCatalog :' + packageChildDetailsForProductCatalog);
            system.debug('listForeCompetitor' + listForeCompetitor);
            system.debug('listForeLearningAssessment :' + listForeLearningAssessment);
            system.debug('listForInstructorResource :' + listForInstructorResource);
            system.debug('listForStudentResource :' + listForStudentResource);
            system.debug('childDetails :' + childDetails);
            
                if (toDisplayProducts && productsToDisplay != null && !productsToDisplay.isEmpty() || (packageDetailsForProductCatalog != null && !packageDetailsForProductCatalog.isEmpty()) || (packageChildDetailsForProductCatalog != null && !packageChildDetailsForProductCatalog.isEmpty()) || (listForeCompetitor != null && !listForeCompetitor.isEmpty()) || (listWithInstructorResource != null && !listWithInstructorResource.isEmpty()) || (listWithStudentResource != null && !listWithStudentResource.isEmpty()) || (packageDetails != null && !packageDetails.isEmpty())) {
                System.debug('addToOptyProductId.............' + addToOptyProductId);
                productsList = new List < Product2 > ();
                baseProductError = false;
                PsellProductError = false;
                PSellError = false;
                searchMessage = true;
                
                if (addToOptyProductId!=null) {
                    ap1 = new List < Apttus_Config2__PriceListItem__c > ();
                    // String loggedInUserpriceListNameProduct = [select Price_List__c from User where id =: UserInfo.getUserId()].Price_List__c;
                    ap1 = [select Apttus_Config2__ProductId__c, Apttus_Config2__ProductId__r.name,Apttus_Config2__ProductId__r.Author__c,Apttus_Config2__ProductId__r.Edition__c, Apttus_Config2__ProductId__r.ISBN__c,Apttus_Config2__ProductId__r.Copyright_Year__c,Apttus_Config2__ListPrice__c,
                        Net_Price__c from Apttus_Config2__PriceListItem__c
                        where Apttus_Config2__ProductId__c = : addToOptyProductId and Apttus_Config2__PriceListId__r.name = : loggedInUserpriceListNamebase and Apttus_Config2__Active__c = true
                    ];
                    System.debug('To check product pricelist....' + ap1);
                }
               
               if (!ap1.isempty()) {
               
               List < PriceBookEntry > priceBookCurrencyProd = [SELECT Id, Product2Id, CurrencyISOCode FROM PriceBookEntry WHERE Product2Id = : addToOptyProductId AND PriceBook2.isStandard = true AND isActive = true];
                // System.debug('priceBookCurrencyProd....'+priceBookCurrencyProd[0].CurrencyISOCode+priceBookCurrencyProd.size());
                String priceProdCurr;
                if (priceBookCurrencyProd.size() > 0) {
                    for (Integer i = 0; i < priceBookCurrencyProd.size(); i++) {
                        System.debug('inside for loop......' + oppCurrency + priceBookCurrencyProd[i].CurrencyISOCode);
                        if (priceBookCurrencyProd[i].CurrencyISOCode == oppCurrency) {
                            priceProdCurr = priceBookCurrencyProd[i].CurrencyISOCode;
                            System.debug('priceProdCurr..........' + priceProdCurr);
                        }
                    }
                }
               
               
               
                    if (priceBookCurrencyProd != null && priceProdCurr != null) {
                        productFamilyClass prodClass = new productFamilyClass();
                        prodClass.oppProd = ap1[0];
                        Decimal decimalQuantity2 = Quantityopp;
                        if (decimalQuantity2 != null) {
                            Integer integerQuantity2 = decimalQuantity2.intValue();
                            prodClass.sQuantity = integerQuantity2;
                        }
                        listOfproductFamilyClass.add(prodClass);
                        cartProdFromURL = cartProdFromURL+ap1[0].Apttus_Config2__ProductId__r.id+'%2C'+prodClass.sQuantity+'%2C';
                        System.debug(listOfproductFamilyClass);
                        addToOpty = false;
                    } else {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, ' Product is not associated with Standard Pricebook/Opportunity Currency Does not match pricebook currency.'));
                        PricebookCurrencyErrorProd = true;
                    }
                } else {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Product is not associated with Pricelist'));
                    ProductPriceError = true;
                }
            }
            if(listOfproductFamilyClass.isEmpty() || listOfproductFamilyClass == null)
                {
                    oppCartEmpty = true;
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'No items in the Opportunity cart'));
                } 
            return null;
        }
        
        /**
         * Description : Returns True on CLick of AddToOppty Button in ProductFamily 
         * @param String
         * @return String
         * @throws NA
         **/
    public boolean addToOpty() {
            return addToOpty;
        }
        /**
         * Description : Returns Relatedproducts with PSELL ="True"  
         * @param String
         * @return String
         * @throws NA
         **/
    public List < Apttus_Config2__RelatedProduct__c > getAddToOppty() {
            return listWithPSellFamily;
        }
        /**
         * Description : Remove Products From cart When Click on Trash Icon
         * @param String
         * @return String
         * @throws NA
         **/
    public void removeProdCart() {
            System.debug('listOfproductFamilyClass size()....' + listOfproductFamilyClass.size());
            for (integer i = 0; i < listOfproductFamilyClass.size(); i++) {
                productFamilyClass prodClass = listOfproductFamilyClass[i];
                //System.debug('prodClass.relatedProd.id...'+prodClass.relatedProd.id);
                System.debug('relatedProductId...' + relatedProductId);
                System.debug('relatedProductId1...' + relatedProductId1);
                if (!String.isBLANK(relatedProductId1) && prodClass.relatedProd != null) {
                    if (prodClass.relatedProd.apttus_config2__relatedproductid__r.Id == relatedProductId1) {
                        listOfproductFamilyClass.remove(i);
                    }
                } else if (!String.isBLANK(relatedProductId) && prodClass.relatedProd1 != null) {
                    if (prodClass.relatedProd1.id == relatedProductId) {
                        listOfproductFamilyClass.remove(i);
                    }
                } else if (!String.isBLANK(removeProductIdFromCart) && prodClass.oppProd != null) {
                    if (prodClass.oppProd.Apttus_Config2__ProductId__r.id == removeProductIdFromCart) {
                        listOfproductFamilyClass.remove(i);
                    }
                }
            }
            if (listOfproductFamilyClass.isEmpty() || listOfproductFamilyClass == null) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'No items in the Opportunity cart'));
                oppCartEmpty = true;
            }
        }
        /**
         * Description : Returns products with configuration type ="Bundle" on Search 
         * @param String
         * @return String
         * @throws NA
         **/
    public void searchProductFamilyFilter() {
        system.debug(selectedFilterbyValue);
            string sQuery = 'select Apttus_Config2__ProductId__r.Id,Apttus_Config2__ProductId__r.Name,Apttus_Config2__ProductId__r.Author__c,Apttus_Config2__ProductId__r.Copyright_Year__c,Apttus_Config2__ProductId__r.Status__c,Apttus_Config2__ProductId__r.Relevance_Value__c,Apttus_Config2__ProductId__r.InstockDate__c,Apttus_Config2__ProductId__r.Priority__c,Apttus_Config2__ProductId__r.Sub_Brand__c,Apttus_Config2__ProductId__r.Platform__c,Apttus_Config2__ProductId__r.Relevance__c from Apttus_Config2__ProductClassification__c';
            displayProdWraprList = new List < DisplayProductWrapper > ();
            mapDisplayProdWrapr = new Map < Id, DisplayProductWrapper > ();
            list < Id > listOfIds = new list < Id > ();
            listOfIds.addAll(setWithPearsonCodeID);
            productsToDisplay1count3 = 0;
            if (searchoffsetFlag != true) {
                OffsetSize = 0;
            }
            if (!listOfIds.isEmpty()) {
                sQuery += ' where ( ';
                integer iCount = listOfIds.size() - 1;
                for (integer i = 0; i < listOfIds.size(); i++) {
                    if (iCount != i) sQuery += 'Apttus_Config2__ClassificationId__c = \'' + listOfIds[i] + '\' OR ';
                    else sQuery += 'Apttus_Config2__ClassificationId__c = \'' + listOfIds[i] + '\'';
                }
                sQuery += ') ';
                sQuery += 'AND Apttus_Config2__ProductId__r.Apttus_Config2__ConfigurationType__c = \'Bundle\'';
                sQuery += ' AND (Apttus_Config2__ProductId__r.Relevance_Value__c = ' + 10 + ' OR Apttus_Config2__ProductId__r.Relevance_Value__c = ' + 30 + ' OR Apttus_Config2__ProductId__r.Relevance_Value__c = ' + 90 + ' OR Apttus_Config2__ProductId__r.Relevance_Value__c = ' + 95 + ' OR Apttus_Config2__ProductId__r.Relevance_Value__c = ' + 100 + ')';
            }
            System.debug('sQuery===insearchProductFamilyFilter' + sQuery);
            for (dynamicAddFilterSearch wrapperClass: listWithSelectOptions) {
             System.debug('wrapperClass.selectedProductFilterValue ----->'+wrapperClass.selectedProductFilterValue);
             System.debug('wrapperClass.searchText  ----->'+wrapperClass.searchText);
                if (wrapperClass.selectedCondition != '--None--' && wrapperClass.selectedProductFilterValue != '--None--' && wrapperClass.searchText != null) {
                    wrapperClass.searchText = wrapperClass.searchText.trim();
                    if (wrapperClass.selectedProductFilterValue == 'Name' && wrapperClass.searchText != null) {
                        system.debug('inside value is ==>>' + wrapperClass.searchText);
                        if (wrapperClass.selectedCondition == 'equals' && !wrapperClass.searchText.equals('')) {
                            sQuery += ' AND Apttus_Config2__ProductId__r.Name = \'' + String.escapeSingleQuotes(wrapperClass.searchText) + '\'';
                        } else if (wrapperClass.selectedCondition == 'not equal to' && !wrapperClass.searchText.equals('')) {
                            sQuery += ' AND Apttus_Config2__ProductId__r.Name != \'' + String.escapeSingleQuotes(wrapperClass.searchText) + '\'';
                        } else if (wrapperClass.selectedCondition == 'starts with' && !wrapperClass.searchText.equals('')) {
                            sQuery += ' AND Apttus_Config2__ProductId__r.Name LIKE \'' + String.escapeSingleQuotes(wrapperClass.searchText) + '%\'';
                        } else if (wrapperClass.selectedCondition == 'contains' && !wrapperClass.searchText.equals('')) {
                            sQuery += ' AND Apttus_Config2__ProductId__r.Name LIKE \'%' + String.escapeSingleQuotes(wrapperClass.searchText) + '%\'';
                        } else if (wrapperClass.selectedCondition == 'does not contain' && !wrapperClass.searchText.equals('')) {
                            sQuery += ' AND (NOT Apttus_Config2__ProductId__r.Name LIKE \'%' + String.escapeSingleQuotes(wrapperClass.searchText) + '%\')';
                        }
                    }
                    if (wrapperClass.selectedProductFilterValue == 'Brand' && wrapperClass.searchText != null) {
                        if (wrapperClass.selectedCondition == 'equals' && !wrapperClass.searchText.equals('')) {
                            sQuery += ' AND Apttus_Config2__ProductId__r.Brand__c = \'' + String.escapeSingleQuotes(wrapperClass.searchText) + '\'';
                        } else if (wrapperClass.selectedCondition == 'not equal to' && !wrapperClass.searchText.equals('')) {
                            sQuery += ' AND Apttus_Config2__ProductId__r.Brand__c != \'' + String.escapeSingleQuotes(wrapperClass.searchText) + '\'';
                        } else if (wrapperClass.selectedCondition == 'starts with' && !wrapperClass.searchText.equals('')) {
                            sQuery += ' AND Apttus_Config2__ProductId__r.Brand__c LIKE \'' + String.escapeSingleQuotes(wrapperClass.searchText) + '%\'';
                        } else if (wrapperClass.selectedCondition == 'contains' && !wrapperClass.searchText.equals('')) {
                            sQuery += ' AND Apttus_Config2__ProductId__r.Brand__c LIKE \'%' + String.escapeSingleQuotes(wrapperClass.searchText) + '%\'';
                        } else if (wrapperClass.selectedCondition == 'does not contain' && !wrapperClass.searchText.equals('')) {
                            sQuery += ' AND (NOT Apttus_Config2__ProductId__r.Brand__c LIKE \'%' + String.escapeSingleQuotes(wrapperClass.searchText) + '%\')';
                        }
                    }
                    if (wrapperClass.selectedProductFilterValue == 'Platform' && wrapperClass.searchText != null) {
                        system.debug('inside platform value is ==>>' + wrapperClass.searchText);
                        if (wrapperClass.selectedCondition == 'equals' && !wrapperClass.searchText.equals('')) {
                            sQuery += ' AND Apttus_Config2__ProductId__r.Platform__c = \'' + String.escapeSingleQuotes(wrapperClass.searchText) + '\'';
                        } else if (wrapperClass.selectedCondition == 'not equal to' && !wrapperClass.searchText.equals('')) {
                            sQuery += ' AND Apttus_Config2__ProductId__r.Platform__c != \'' + String.escapeSingleQuotes(wrapperClass.searchText) + '\'';
                        } else if (wrapperClass.selectedCondition == 'starts with' && !wrapperClass.searchText.equals('')) {
                            sQuery += ' AND Apttus_Config2__ProductId__r.Platform__c LIKE \'' + String.escapeSingleQuotes(wrapperClass.searchText) + '%\'';
                        } else if (wrapperClass.selectedCondition == 'contains' && !wrapperClass.searchText.equals('')) {
                         system.debug('inside platform value is ==>>' + wrapperClass.searchText);
                            sQuery += ' AND Apttus_Config2__ProductId__r.Platform__c LIKE \'%' + String.escapeSingleQuotes(wrapperClass.searchText) + '%\'';
                             system.debug('inside platform value is sQuery==>>' + sQuery);
                        } else if (wrapperClass.selectedCondition == 'does not contain' && !wrapperClass.searchText.equals('')) {
                            sQuery += ' AND (NOT Apttus_Config2__ProductId__r.Platform__c LIKE \'%' + String.escapeSingleQuotes(wrapperClass.searchText) + '%\')';
                        }
                    }
                    if (wrapperClass.selectedProductFilterValue == 'Relevance' && wrapperClass.searchText != null) {
                        system.debug('inside value is ==>>' + wrapperClass.searchText);
                        if (wrapperClass.selectedCondition == 'equals' && !wrapperClass.searchText.equals('')) {
                            sQuery += ' AND Apttus_Config2__ProductId__r.Relevance_Value__c = ' + String.escapeSingleQuotes(wrapperClass.searchText);
                        } else if (wrapperClass.selectedCondition == 'not equal to' && !wrapperClass.searchText.equals('')) {
                            sQuery += ' AND Apttus_Config2__ProductId__r.Relevance_Value__c != ' + String.escapeSingleQuotes(wrapperClass.searchText);
                        } else if (wrapperClass.selectedCondition == 'starts with' && !wrapperClass.searchText.equals('')) {
                            sQuery += ' AND Apttus_Config2__ProductId__r.Relevance_Value__c = ' + String.escapeSingleQuotes(wrapperClass.searchText);
                        } else if (wrapperClass.selectedCondition == 'contains' && !wrapperClass.searchText.equals('')) {
                            sQuery += ' AND Apttus_Config2__ProductId__r.Relevance_Value__c = ' + String.escapeSingleQuotes(wrapperClass.searchText);
                        } else if (wrapperClass.selectedCondition == 'does not contain' && !wrapperClass.searchText.equals('')) {
                            sQuery += ' AND Apttus_Config2__ProductId__r.Relevance_Value__c != ' + String.escapeSingleQuotes(wrapperClass.searchText);
                        }
                    }
                    if (wrapperClass.selectedProductFilterValue == 'Status' && wrapperClass.searchText != null) {
                        if (!wrapperClass.searchText.equals('')) {
                            wrapperClass.searchText = wrapperClass.searchText.replaceAll(',', '\',\'');
                            wrapperClass.searchText = '\'' + wrapperClass.searchText + '\'';
                            system.debug('wrapperClass.searchText->' + wrapperClass.searchText);
                        }
                        system.debug('wrapperClass.searchText--->' + wrapperClass.searchText);
                        if (wrapperClass.selectedCondition == 'equals' && !wrapperClass.searchText.equals('')) {
                            sQuery += ' AND Apttus_Config2__ProductId__r.Status__c in (' + wrapperClass.searchText + ')';
                        } else if (wrapperClass.selectedCondition == 'not equal to' && !wrapperClass.searchText.equals('')) {
                            sQuery += ' AND Apttus_Config2__ProductId__r.Status__c not in (' + wrapperClass.searchText + ')';
                        } else if (wrapperClass.selectedCondition == 'starts with' && !wrapperClass.searchText.equals('')) {
                            sQuery += ' AND Apttus_Config2__ProductId__r.Status__c in (' + wrapperClass.searchText + ')';
                        } else if (wrapperClass.selectedCondition == 'contains' && !wrapperClass.searchText.equals('')) {
                            sQuery += ' AND Apttus_Config2__ProductId__r.Status__c in (' + wrapperClass.searchText + ')';
                        } else if (wrapperClass.selectedCondition == 'does not contain' && !wrapperClass.searchText.equals('')) {
                            sQuery += ' AND Apttus_Config2__ProductId__r.Status__c not in (' + wrapperClass.searchText + ')';
                        }
                    }
                    if (wrapperClass.selectedProductFilterValue == 'Sub Brand' && wrapperClass.searchText != null) {
                        if (wrapperClass.selectedCondition == 'equals' && !wrapperClass.searchText.equals('')) {
                            sQuery += ' AND Apttus_Config2__ProductId__r.Sub_Brand__c = \'' + String.escapeSingleQuotes(wrapperClass.searchText) + '\'';
                        } else if (wrapperClass.selectedCondition == 'not equal to' && !wrapperClass.searchText.equals('')) {
                            sQuery += ' AND Apttus_Config2__ProductId__r.Sub_Brand__c != \'' + String.escapeSingleQuotes(wrapperClass.searchText) + '\'';
                        } else if (wrapperClass.selectedCondition == 'starts with' && !wrapperClass.searchText.equals('')) {
                            sQuery += ' AND Apttus_Config2__ProductId__r.Sub_Brand__c LIKE \'' + String.escapeSingleQuotes(wrapperClass.searchText) + '%\'';
                        } else if (wrapperClass.selectedCondition == 'contains' && !wrapperClass.searchText.equals('')) {
                            sQuery += ' AND Apttus_Config2__ProductId__r.Sub_Brand__c LIKE \'%' + String.escapeSingleQuotes(wrapperClass.searchText) + '%\'';
                        } else if (wrapperClass.selectedCondition == 'does not contain' && !wrapperClass.searchText.equals('')) {
                            sQuery += ' AND (NOT Apttus_Config2__ProductId__r.Sub_Brand__c LIKE \'%' + String.escapeSingleQuotes(wrapperClass.searchText) + '%\')';
                        }
                    }
                }
            }
                    sQuery += ' order by Apttus_Config2__ProductId__r.Relevance_Value__c,Apttus_Config2__ProductId__r.Name Asc';
                    system.debug('sQuery in order===>>>>' + sQuery);
                    sQuery += ' limit ' + QueryLimit + ' offset ' + OffsetSize;
                    system.debug('sQuery in limit===>>>>' + sQuery);
                
                system.debug('sQuery===>>>>' + sQuery);
                try {
                    listWithProdId = new List < ID > ();
                    listWithProdFamily = Database.query(sQuery);
                    system.debug('sQuery===>>>>' + sQuery);
                    productsToDisplay1count3 = searchFilterResults1(sQuery);
                    system.debug('sQuery===>>>>' + sQuery);
                    getSearchFilterResTotalPages();
                    getSearchPageNumber();
                    if (!listWithProdFamily.isEmpty()) {
                        for (Apttus_Config2__ProductClassification__c productClassification1: listWithProdFamily) {
                            listWithProdId.add(productClassification1.Apttus_Config2__ProductId__r.Id);
                            mapDisplayProdWrapr.put(productClassification1.Apttus_Config2__ProductId__r.Id, new DisplayProductWrapper(null, null, productClassification1));
                            displayProdWraprList.add(new DisplayProductWrapper(null, null, productClassification1));
                        }
                        getPrice();
                        system.debug('listWithProdFamily ===>>>>' + listWithProdFamily);
                        toDisplayProducts = false;
                    } else {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'No records were found based on your criteria'));
                        searchFilterResults = true;
                    }
                    system.debug('listWithProdFamily ===>>>>' + listWithProdFamily);
                    displayProductFamilyOnLoad = false;
                    searchFilterResultsFlag = true;
                    displayProductFamilyOnSerach = false;
                    displayOnPearsonClick = false;
                    fromTaxanomy = false;
                } catch (Exception e) {
                    system.debug('exception===>>>>' + e);
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Ooops! Contact your Administrator' + e.getTypeName() + ':' + e.getMessage() + ':LINE ' + e.getLineNumber()));
                }
           
        }
        /**
         * Description : Remove filter functionality 
         * @param String
         * @return String
         * @throws NA
         **/
    public void removeFilter() {
            listWithSelectOptions = removeFilterRow(rowToRemove, listWithSelectOptions);
        }
        /**
         * Description : Remove selected filter functionality 
         * @param String
         * @return String
         * @throws NA
         **/
    public static List < dynamicAddFilterSearch > removeFilterRow(Integer rowToRemove, List < dynamicAddFilterSearch > listWithSelectOptionss) {
            listWithSelectOptionss.remove(rowToRemove);
            return listWithSelectOptionss;
        }
        /**
         * Description : Display Product families functinality in OneCRMProductSelectorPage.
         * @param String
         * @return String
         * @throws NA
         **/
    public void productFamily() {
            System.debug('currParent ' + currParent);
            if (currParent != null) {
                if (currParent.isAlphanumeric() && fromTaxanomy) {
                    if (offsetTaxonomyFlag != true) {
                        OffsetSize = 0;
                    }
                    pearsonCodeId = null;
                    displayOnPearsonClick = false;
                    searchFilterResultsFlag = false;
                    setWithPearsonCodeID = new Set < ID > ();
                    setWithPearsonCodeID.add(currParent);
                    PearsonCodeClick();
                    getSearchPearsonClickTotalPages();
                    getSearchPageNumber();
                } else if (fromTaxanomy) {
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Please select a course code from the taxanomy.');
                    ApexPages.addMessage(myMsg);
                }
            }
            system.debug('pearsonCodeId****' + pearsonCodeId);
            if (pearsonCodeId != null) {
                toDisplayProducts = false;
                System.debug('offsetFlag...' + offsetFlag);
                if (offsetFlag != true) {
                    OffsetSize = 0;
                }
                setWithPearsonCodeID = new Set < ID > ();
                setWithPearsonCodeID.add(pearsonCodeId);
                displayOnPearsonClick = true;
                searchFilterResultsFlag = false;
                fromTaxanomy = false;
                displayProductFamilyOnSerach = false;
                PearsonCodeClick();
                getSearchPearsonClickTotalPages();
                getSearchPageNumber();
            }
            system.debug('in productFamily****');
            listWithProdFamily = new List < Apttus_Config2__ProductClassification__c > ();
            displayProdWraprList = new List < DisplayProductWrapper > ();
            mapDisplayProdWrapr = new Map < Id, DisplayProductWrapper > ();
            system.debug('listWithProdFamily QueryLimit===>>>>' + QueryLimit);
            system.debug('listWithProdFamily OffsetSize===>>>>' + OffsetSize);
            if (OffsetSize >= 0) {
                listWithProdFamily = [select Apttus_Config2__ProductId__r.Id,
                    Apttus_Config2__ProductId__r.Name,
                    Apttus_Config2__ProductId__r.Author__c,
                    Apttus_Config2__ProductId__r.Copyright_Year__c,
                    Apttus_Config2__ProductId__r.Status__c,
                    Apttus_Config2__ProductId__r.InstockDate__c,
                    Apttus_Config2__ProductId__r.Priority__c,
                    Apttus_Config2__ProductId__r.Sub_Brand__c,
                    Apttus_Config2__ProductId__r.Platform__c,
                    Apttus_Config2__ProductId__r.Relevance__c,
                    Apttus_Config2__ProductId__r.Relevance_Value__c,
                    Apttus_Config2__ProductId__r.Edition__c
                    from Apttus_Config2__ProductClassification__c where Apttus_Config2__ClassificationId__c IN: setWithPearsonCodeID AND Apttus_Config2__ProductId__r.Apttus_Config2__ConfigurationType__c = 'Bundle'
                    AND(Apttus_Config2__ProductId__r.Relevance_Value__c = 10 OR Apttus_Config2__ProductId__r.Relevance_Value__c = 30 OR Apttus_Config2__ProductId__r.Relevance_Value__c = 90 OR Apttus_Config2__ProductId__r.Relevance_Value__c = 95 OR Apttus_Config2__ProductId__r.Relevance_Value__c = 100) order by Apttus_Config2__ProductId__r.Relevance_Value__c, Apttus_Config2__ProductId__r.Name Asc Nulls Last limit: QueryLimit offset: OffsetSize
                ];
                System.debug(listWithProdFamily);
                listWithProdId = new List < ID > ();
                if (!listWithProdFamily.isEmpty()) {
                    for (Apttus_Config2__ProductClassification__c productClassification: listWithProdFamily) {
                        listWithProdId.add(productClassification.Apttus_Config2__ProductId__r.Id);
                        system.debug('productClassification.Apttus_Config2__ProductId__r.Id' + productClassification.Apttus_Config2__ProductId__r.Id);
                        if (productClassification.Apttus_Config2__ProductId__r.Id != null || !String.isBlank(productClassification.Apttus_Config2__ProductId__r.Id)) {
                            System.debug(productClassification.Apttus_Config2__ProductId__r.Id);
                            mapDisplayProdWrapr.put(productClassification.Apttus_Config2__ProductId__r.Id, new DisplayProductWrapper(null, null, productClassification));
                            setWithProductFamilyID.add(productClassification.Apttus_Config2__ProductId__r.Id); //Added by Kyama.
                        }
                        displayProductFamilyOnLoad = true;
                        displayProductFamilyOnSerach = false;
                    }
                    System.debug(listWithProdId);
                    system.debug('listWithProdFamily ===>>>>' + mapDisplayProdWrapr);
                    system.debug('listWithProdFamily ===>>>>' + mapDisplayProdWrapr.size());
                }
            }
            if (pearsonCodeId != null || currParent != null) {
                displayProductFamilyOnLoad = false;
                getPrice();
            }
            /*if(listWithProdId == null || listWithProdId.isEmpty() && opportunityID!=null)
                    {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'No records were found based on your criteria'));
                        productFamilyOnLoad = true;
                    }*/
            System.Debug(toDisplayProducts);
            System.Debug('displayProdWraprList....inside productFamily()' + mapDisplayProdWrapr);
        }
        /**
         * Description : To Display List/Net Price in productFamily Table  
         * @param String
         * @return String
         * @throws NA
         **/
    public void getPrice() {
            System.debug('in get price method******..');
            String loggedInUserpriceListName = [select Price_List__c from User where id = : UserInfo.getUserId()].Price_List__c;
            System.debug('loggedInUserpriceListName..' + loggedInUserpriceListName);
            if (!String.isBlank(loggedInUserpriceListName)) {
                List < Apttus_Config2__PriceListItem__c > aConfigPriceList = [select Apttus_Config2__ProductId__r.id, Apttus_Config2__ListPrice__c, Net_Price__c, Apttus_Config2__ProductId__r.Name, Apttus_Config2__ProductId__r.Author__c,
                    Apttus_Config2__ProductId__r.Copyright_Year__c,
                    Apttus_Config2__ProductId__r.Status__c,
                    Apttus_Config2__ProductId__r.InstockDate__c,
                    Apttus_Config2__ProductId__r.Priority__c,
                    Apttus_Config2__ProductId__r.Sub_Brand__c,
                    Apttus_Config2__ProductId__r.Platform__c,
                    Apttus_Config2__ProductId__r.Relevance__c,
                    Apttus_Config2__ProductId__r.Edition__c,
                    Apttus_Config2__ProductId__r.Relevance_Value__c from Apttus_Config2__PriceListItem__c where Apttus_Config2__ProductId__c IN: setWithProductFamilyID and Apttus_Config2__PriceListId__r.name = : loggedInUserpriceListName and Apttus_Config2__Active__c = true
                ];
                if (!aConfigPriceList.isEmpty()) {
                    for (Apttus_Config2__PriceListItem__c priceList: aConfigPriceList) {
                        if (priceList.Apttus_Config2__ProductId__r.Id != null || !String.isBlank(priceList.Apttus_Config2__ProductId__r.Id)) {
                            if (mapDisplayProdWrapr.containsKey(priceList.Apttus_Config2__ProductId__r.Id)) {
                                if (priceList != null) {
                                    mapDisplayProdWrapr.get(priceList.Apttus_Config2__ProductId__r.Id).priceListItem = priceList;
                                }
                            }
                        }
                    }
                }
            }
            system.debug('***********IMP****************' + mapDisplayProdWrapr);
        }
        /**
         * Description : To Show/Hide Price in ProductFamily Table  
         * @param String
         * @return String
         * @throws NA
         **/
    public void isNone() {
            isRender = false;
        }
        /**
         * Description : To Show/Hide Price in ProductFamily Table 
         * @param String
         * @return String
         * @throws NA
         **/
    public void isLoad() {
            isRender = true;
        }
        /**
         * Description : Returns product families 
         * @param String
         * @return String
         * @throws NA
         **/
    public Map < Id, DisplayProductWrapper > getProdFamily() {
            toDisplayProducts = false;
            return mapDisplayProdWrapr;
        }
        /**
         * Description : Returns product families 
         * @param String
         * @return String
         * @throws NA
         **/
    public PageReference Next() {
            OffsetSize += QueryLimit;
            productFamily();
            getProductFamilys();
            getPageNumber();
            getTotalPages();
            getPrice();
            System.debug('inside next....' + OffsetSize);
            return null;
        }
        /**
         * Description : Returns product families 
         * @param String
         * @return String
         * @throws NA
         **/
    public PageReference Previous() {
            OffsetSize -= QueryLimit;
            productFamily();
            getProductFamilys();
            getPageNumber();
            getTotalPages();
            getPrice();
            System.debug('inside Previous....' + OffsetSize);
            return null;
        }
        /**
         * Description : Returns product families 
         * @param String
         * @return String
         * @throws NA
         **/
    public Integer getPageNumber() {
            System.debug('OffsetSize/QueryLimit' + OffsetSize / QueryLimit);
            pageNumber = OffsetSize / QueryLimit + 1;
            return pageNumber;
        }
        /**
         * Description : Returns product families 
         * @param String
         * @return String
         * @throws NA
         **/
    public Integer getTotalPages() {
            if (math.mod(CountTotalRecords, QueryLimit) > 0) {
                totalPages = CountTotalRecords / QueryLimit + 1;
                return totalPages;
            } else {
                totalPages = (CountTotalRecords / QueryLimit);
                return totalPages;
            }
        }
        /**
         * Description : added For ProductFamilyPopUp
         * @param String
         * @return String
         * @throws NA
         **/
    public void closePopup() {
            displayPopup = false;
            displayMarketInfoPopup = false;
            dispVal = false;
        }
        /**
         * Description : Logic To display Pop Up in Product Family Table
         * @param String
         * @return String
         * @throws NA
         **/
    public void showPopup() {
            displayPopup = true;
            System.debug('inside on click expnad button productfamilyid' + familyId);
            System.debug('inside on click expnad button oppid' + opportunityID);
            content1 = [select Content__c from Marketing_Information__c where Family__c = : familyId And Marketing_Copy_Type__c = 'Short College Description'
                limit 1
            ];
            if (content1.size() > 0) {
                for (Marketing_Information__c content: content1) {
                    System.debug('Content detailsssssssssss' + content.Content__c);
                    if (content.Content__c != null) {
                        value = content.Content__c;
                    }
                }
            } else {
                System.debug('insideeee else show pop block');
                value = 'Product family Does not Contain any Details.';
            }
        }
        /**
         * Description :Get content for productfamily in Pop Up
         * @param String
         * @return String
         * @throws NA
         **/
    public String getValue() {
            return value;
        }
        /**
         * Description : pop up for Leave Behind 
         * @param String
         * @return String
         * @throws NA
         **/
    public void showPopup1() {
            displayPopup = true;
        }
        /**
         * Description : Get product family details based on id from URL
         * @param String
         * @return String
         * @throws NA
         **/
    public product2 getProductFamilyDetails() {
            authorNames = new List < String > ();
            bookIconFromAttachment = new List < Attachment > ();
            if (productFamilyIdFromURL != null) {
                product2FamilyResult = [select id, Name, Full_Author_and_Affiliation__c, InstockDate__c, Image__c, Digital_Instock_Date__c, Copyright_Year__c, Status__c, Digital_Status__c, Apttus_Config2__Icon__c,IRC_Indicator__c from product2 where Id = : productFamilyIdFromURL];
                bookIconFromAttachment = [select Id, Body from Attachment where ParentId = : productFamilyIdFromURL And Description = : 'Image Icon'
                    limit 1
                ];
                if (bookIconFromAttachment != null && bookIconFromAttachment.size() > 0) {
                    if (bookIconFromAttachment[0].Id != null) {
                        FileId = bookIconFromAttachment[0].Id;
                    }
                }
            }
            return product2FamilyResult;
        }
        /**
         * Description : Get product family details based on id from URL
         * @param String
         * @return String
         * @throws NA
         **/
    public product2 getProductCatalogDetails() {
            bookIconForProductFromAttachment = new List < Attachment > ();
            authorNames_Product = new List < String > ();
            bookIconFromAttachment = new List < Attachment > ();
            System.Debug('Inside getProductCatalogDetails()...');
            System.Debug('Inside getProductCatalogDetails().productCatalogIdFromURL..' + productCatalogIdFromURL);
            if (productCatalogIdFromURL != null) {
                deserializedProduct = new Product2();
                product2CatalogResult = [select Name,irc_indicator__c, Full_Author_and_Affiliation__c, Image__c, Digital_Instock_Date__c, InstockDate__c, Copyright_Year__c, Status__c, Digital_Status__c, Apttus_Config2__Icon__c from product2 where Id = : productCatalogIdFromURL];
                System.debug('product2CatalogResult ' + product2CatalogResult);
                if (product2CatalogResult != null) {
                    String serializedProduct = JSON.serialize(product2CatalogResult);
                    serializedProduct = serializedProduct.replaceall('\r\n', '<BR/>');
                    deserializedProduct = (Product2) JSON.deserialize(serializedProduct, Product2.class);
                    System.debug(deserializedProduct.Full_Author_and_Affiliation__c);
                }
                bookIconForProductFromAttachment = [select Id, Body from Attachment where ParentId = : productCatalogIdFromURL And Description = : 'Image Icon'
                    limit 1
                ];
                if (bookIconForProductFromAttachment != null && !bookIconForProductFromAttachment.isEmpty()) {
                    if (bookIconForProductFromAttachment[0].Id != null) {
                        ProductFileId = bookIconForProductFromAttachment[0].Id;
                    }
                }
            }
            return product2CatalogResult;
        }
        /**
         * Description : Return to product selector page
         * @param String
         * @return String
         * @throws NA
         **/
    public pageReference returnToProdSelection() {
            pageReference prodSelectionPage = new pageReference('/apex/oneCRMProductSelectorWizardV2?oppId=' + opportunityID);
            prodSelectionPage.setRedirect(true);
            return prodSelectionPage;
        }
        /**
         * Description : Get Marketing Information Details
         * @param String
         * @return String
         * @throws NA
         **/
    public List < Marketing_Information__c > getMarketingInformationDetails() {
        listWithMarketingInformation = new List < Marketing_Information__c > ();
        listForTypeAboutThisProduct = new List < Marketing_Information__c > ();
        listForContent = new List < Marketing_Information__c > ();
        listForContentRep = new List < Marketing_Information__c > ();
        if (productFamilyIdFromURL != null) {
            listWithMarketingInformation = [select Id, Type__c, Sub_Type__c, Family__c, Product__c, Content__c from Marketing_Information__c where Family__c = : productFamilyIdFromURL And Family__r.Apttus_Config2__ConfigurationType__c = 'Bundle'
                AND((Type__c = 'About this Product') Or(Type__c = 'Rep Tools'))
            ];
        }
        if (!listWithMarketingInformation.isEmpty()) {
            for (Marketing_Information__c marketingInfo: listWithMarketingInformation) {
                if (marketingInfo.Type__c == 'About this Product') {
                    listForTypeAboutThisProduct.add(marketingInfo);
                } else if (marketingInfo.Type__c == 'Rep Tools') {
                    listForTypeRepTools.add(marketingInfo);
                }
            }
        }
        String subtype;
        Decimal order;
        if (productFamilyIdFromURL != null) {
            List < AggregateResult > order_aboutProduct = [select min(order__c) OrderValue, sub_type__c from Marketing_Information__c where Family__c = : productFamilyIdFromURL and type__c = 'About this Product'
                group by sub_type__c
            ];
            aboutthisproductlist = new List < AboutThisProduct > ();
            if (order_aboutProduct != null && !order_aboutProduct.isEmpty()) {
                subtype = (String) order_aboutProduct[0].get('sub_type__c');
                order = (Decimal) order_aboutProduct[0].get('OrderValue');
            }
            if (subtype != null && order != null) {
                listForContent = [select content__c from Marketing_Information__c where family__c = : productFamilyIdFromURL and type__c = 'About this Product'
                    and sub_type__c = : subtype and order__c = : order
                ];
            }
            if (order_aboutProduct != null && !order_aboutProduct.isEmpty()) {
                for (AggregateResult ar: order_aboutProduct) {
                    aboutthisproductlist.add(new AboutThisProduct(ar));
                    System.debug('inside Agreegate esults....' + aboutthisproductlist);
                }
            }
            String subtypeRep;
            Decimal orderRep;
            List < AggregateResult > order_Reptools = [select min(order__c) OrderValue, sub_type__c from Marketing_Information__c where Family__c = : productFamilyIdFromURL and type__c = 'Rep Tools'
                group by sub_type__c
            ];
            repToolslist = new List < RepTools > ();
            if (order_Reptools != null && !order_Reptools.isEmpty()) {
                subtypeRep = (String) order_Reptools[0].get('sub_type__c');
                orderRep = (Decimal) order_Reptools[0].get('OrderValue');
            }
            listForContentRep = [select content__c from Marketing_Information__c where family__c = : productFamilyIdFromURL and type__c = 'Rep Tools'
                and sub_type__c = : subtypeRep and order__c = : orderRep
            ];
            System.debug('listForContentRep....' + listForContentRep);
            if (order_Reptools != null && !order_Reptools.isEmpty()) {
                for (AggregateResult ar: order_Reptools) {
                    repToolslist.add(new RepTools(ar));
                    System.debug('inside Agreegate esults....' + repToolslist);
                }
            }
        }
        /* List<Apttus_Config2__RelatedProduct__c> ls = new List<Apttus_Config2__RelatedProduct__c>();
           packageDetails = [select Apttus_Config2__ProductId__r.Id,Apttus_Config2__RelatedProductId__r.Name,Apttus_Config2__RelatedProductId__r.SBN__c,
           Apttus_Config2__RelatedProductId__r.ISBN__c,Apttus_Config2__RelatedProductId__r.Copyright_Year__c,Apttus_Config2__RelatedProductId__r.Status__c,Apttus_Config2__RelatedProductId__r.Edition__c  
           from Apttus_Config2__RelatedProduct__c where Apttus_Config2__ProductId__c =: productFamilyIdFromURL AND Relation_Package__c=true ];
           
           
           for(Apttus_Config2__RelatedProduct__c relpkg: packageDetails){
           setWithFamilyPkgID.add(relpkg.Apttus_Config2__RelatedProductId__c);
           mapDisplayfamilyPkgPrice.put(relpkg.Apttus_Config2__RelatedProductId__c,relpkg);
           setWithRelatedPkgID2.put(relpkg.Apttus_Config2__RelatedProductId__c,relpkg); 
           }
           set<ID> keySetIdFam=new set<ID>();
           keySetIdFam=setWithRelatedPkgID2.keySet();
           List<Apttus_Config2__RelatedProduct__c>  relFam=new List<Apttus_Config2__RelatedProduct__c>();
           
           for(Apttus_Config2__RelatedProduct__c rel:[select Apttus_Config2__ProductId__c,Apttus_Config2__ProductId__r.Id,Apttus_Config2__ProductId__r.Name,
           Apttus_Config2__RelatedProductId__r.Name,Apttus_Config2__RelatedProductId__r.Author__c,
           Apttus_Config2__RelatedProductId__r.SBN__c,Apttus_Config2__RelatedProductId__r.Binding__c,
           Apttus_Config2__RelatedProductId__r.ISBN__c,Apttus_Config2__RelatedProductId__r.Copyright_Year__c,
           Apttus_Config2__RelatedProductId__r.Status__c,Apttus_Config2__RelatedProductId__r.InstockDate__c,
           Apttus_Config2__RelatedProductId__r.Sub_Brand__c,Apttus_Config2__RelatedProductId__r.Platform__c,
           Apttus_Config2__RelatedProductId__r.URL__c,Apttus_Config2__RelatedProductId__r.IRC_Link__c,
           Apttus_Config2__RelatedProductId__r.Priority__c,Component_Package__c 
           from Apttus_Config2__RelatedProduct__c where Apttus_Config2__ProductId__c IN:keySetIdFam 
           AND Component_Package__c=true ]){
           
               if(famMap.containsKey(rel.Apttus_Config2__ProductId__c))
                   famMap.get(rel.Apttus_Config2__ProductId__c).add(rel);
               else{
                   List<Apttus_Config2__RelatedProduct__c> tempLst = new List<Apttus_Config2__RelatedProduct__c>();
                   tempLst.add(rel);
                   famMap.put(rel.Apttus_Config2__ProductId__c , tempLst);
               }
           }
           System.debug('famMap....'+famMap);
          */
        return listWithMarketingInformation;
    }
    public Map < Apttus_Config2__RelatedProduct__c, List < Apttus_Config2__RelatedProduct__c >> getChildDetails() {
        childDetailsSize = childDetails.size();
        return childDetails;
    }
    public Map < id, List < Apttus_Config2__RelatedProduct__c >> getFamMap() {
        childDetailsSize = famMap.size();
        return famMap;
    }
    public Map < id, Apttus_Config2__RelatedProduct__c > getsetWithRelatedPkgID2() {
            //childDetailsSize = childDetails.size();
            return setWithRelatedPkgID2;
        }
        /**
         * Description : Get Marketing Information Details For ProductCatalog
         * @param String
         * @return String
         * @throws NA
         **/
    public List < Marketing_Information__c > getMarketingInformationDetailsForProduct() {
        listWithMarketingInformationForProduct = new List < Marketing_Information__c > ();
        listForTypeAboutThisProductForPC = new List < Marketing_Information__c > ();
        listForTypeRepToolsProduct = new List < Marketing_Information__c > ();
        if (productCatalogIdFromURL != null) {
            listWithMarketingInformationForProduct = [select Id, Type__c, Sub_Type__c, Family__c, Product__c, Content__c from Marketing_Information__c where Product__c = : productCatalogIdFromURL And((Type__c = 'About this Product') Or(Type__c = 'Rep Tools'))];
        }
        if (!listWithMarketingInformationForProduct.isEmpty()) {
            for (Marketing_Information__c marketingInfoProd: listWithMarketingInformationForProduct) {
                if (marketingInfoProd.Type__c == 'About this Product') {
                    listForTypeAboutThisProductForPC.add(marketingInfoProd);
                } else if (marketingInfoProd.Type__c == 'Rep Tools') {
                    listForTypeRepToolsProduct.add(marketingInfoProd);
                }
            }
        }
        String subtype1;
        Decimal order1;
        if (productCatalogIdFromURL != null) {
            List < AggregateResult > order_aboutProductforProduct = [select min(order__c) OrderValue, sub_type__c from Marketing_Information__c where Product__c = : productCatalogIdFromURL and type__c = 'About this Product'
                group by sub_type__c
            ];
            aboutthisproductlistforProduct = new List < AboutThisProductForProduct > ();
            if (order_aboutProductforProduct != null && !order_aboutProductforProduct.isEmpty()) {
                subtype1 = (String) order_aboutProductforProduct[0].get('sub_type__c');
                order1 = (Decimal) order_aboutProductforProduct[0].get('OrderValue');
            }
            listForContentforProduct = [select content__c from Marketing_Information__c where Product__c = : productCatalogIdFromURL and type__c = 'About this Product'
                and sub_type__c = : subtype1 and order__c = : order1
            ];
            if (order_aboutProductforProduct != null && !order_aboutProductforProduct.isEmpty()) {
                for (AggregateResult ar: order_aboutProductforProduct) {
                    aboutthisproductlistforProduct.add(new AboutThisProductForProduct(ar));
                    System.debug('inside Agreegate esults....' + aboutthisproductlistforProduct);
                }
            }
        }
       /* packageChildDetailsForProductCatalog = [select Apttus_Config2__ProductId__r.Id, Apttus_Config2__ProductId__r.Name, Apttus_Config2__RelatedProductId__r.Id, Apttus_Config2__RelatedProductId__r.Name, Apttus_Config2__RelatedProductId__r.Author__c, Apttus_Config2__RelatedProductId__r.Edition__c, Apttus_Config2__RelatedProductId__r.SBN__c, Apttus_Config2__RelatedProductId__r.Binding__c, Apttus_Config2__RelatedProductId__r.ISBN__c, Apttus_Config2__RelatedProductId__r.Copyright_Year__c, Apttus_Config2__RelatedProductId__r.Status__c, Apttus_Config2__RelatedProductId__r.InstockDate__c, Apttus_Config2__RelatedProductId__r.Sub_Brand__c, Apttus_Config2__RelatedProductId__r.Platform__c, Apttus_Config2__RelatedProductId__r.URL__c, Apttus_Config2__RelatedProductId__r.IRC_Link__c, Apttus_Config2__RelatedProductId__r.Priority__c, Component_Package__c from Apttus_Config2__RelatedProduct__c where Apttus_Config2__ProductId__c = : productCatalogIdFromURL AND Component_Package__c = true];
        for (Apttus_Config2__RelatedProduct__c relcomp: packageChildDetailsForProductCatalog) {
            setWithProductComponentID.add(relcomp.Apttus_Config2__RelatedProductId__r.Id);
            mapDisplayProductComponentPrice.put(relcomp.Apttus_Config2__RelatedProductId__r.Id, relcomp);
        }*/
        // Map<Id,Apttus_Config2__RelatedProduct__c> setWithRelatedPkgID1=new Map<Id,Apttus_Config2__RelatedProduct__c>();
      /*  List < Apttus_Config2__RelatedProduct__c > ls = new List < Apttus_Config2__RelatedProduct__c > ();
        packageDetailsForProductCatalog = [select Apttus_Config2__ProductId__r.Id, Apttus_Config2__ProductId__r.Name, Apttus_Config2__RelatedProductId__r.Name, Apttus_Config2__ProductId__r.SBN__c, Apttus_Config2__ProductId__r.ISBN__c, Apttus_Config2__ProductId__r.Copyright_Year__c, Apttus_Config2__ProductId__r.Edition__c, Apttus_Config2__ProductId__r.Status__c, Relation_Package__c from Apttus_Config2__RelatedProduct__c where Apttus_Config2__RelatedProductId__c = : productCatalogIdFromURL AND Relation_Package__c = true AND Apttus_Config2__ProductId__r.Apttus_Config2__ConfigurationType__c = 'Option'];
        for (Apttus_Config2__RelatedProduct__c relpkg1: packageDetailsForProductCatalog) {
            setWithProductPkgID.add(relpkg1.Apttus_Config2__ProductId__c);
            ls.add(relpkg1);
            mapDisplayProductPkgPrice.put(relpkg1.Apttus_Config2__ProductId__c, relpkg1);
            setWithRelatedPkgID1.put(relpkg1.Apttus_Config2__ProductId__c, relpkg1);
        }
        set < ID > keySetId = new set < ID > ();
        keySetId = setWithRelatedPkgID1.keySet();
        List < Apttus_Config2__RelatedProduct__c > relpack = new List < Apttus_Config2__RelatedProduct__c > ();
        for (Apttus_Config2__RelatedProduct__c relpack1: [select Apttus_Config2__ProductId__r.Id, Apttus_Config2__ProductId__r.Name,
                Apttus_Config2__ProductId__r.SBN__c, Apttus_Config2__ProductId__r.ISBN__c,
                Apttus_Config2__RelatedProductId__r.Name, Apttus_Config2__RelatedProductId__r.id, Apttus_Config2__RelatedProductId__r.Author__c,
                Apttus_Config2__RelatedProductId__r.SBN__c, Apttus_Config2__RelatedProductId__r.Binding__c,
                Apttus_Config2__RelatedProductId__r.ISBN__c, Apttus_Config2__RelatedProductId__r.Copyright_Year__c,
                Apttus_Config2__RelatedProductId__r.Status__c, Apttus_Config2__RelatedProductId__r.InstockDate__c,
                Apttus_Config2__RelatedProductId__r.Sub_Brand__c, Apttus_Config2__RelatedProductId__r.Platform__c,
                Apttus_Config2__RelatedProductId__r.URL__c, Apttus_Config2__RelatedProductId__r.IRC_Link__c,
                Apttus_Config2__RelatedProductId__r.Priority__c, Component_Package__c
                from Apttus_Config2__RelatedProduct__c where Apttus_Config2__ProductId__c IN: keySetId
                AND Relation_Package__c = true AND Apttus_Config2__RelatedProductId__r.Apttus_Config2__ConfigurationType__c = 'Option'
            ]) {
            if (prodMap.containsKey(relpack1.Apttus_Config2__ProductId__c)) prodMap.get(relpack1.Apttus_Config2__ProductId__c).add(relpack1);
            else {
                List < Apttus_Config2__RelatedProduct__c > tempLst2 = new List < Apttus_Config2__RelatedProduct__c > ();
                tempLst2.add(relpack1);
                prodMap.put(relpack1.Apttus_Config2__ProductId__c, tempLst2);
            }
        }*/
        return listWithMarketingInformationForProduct;
    }
    public Map < Apttus_Config2__RelatedProduct__c, List < Apttus_Config2__RelatedProduct__c >> getChildDetailsForProduct() {
        return childDetailsForProduct;
    }
    public Map < id, List < Apttus_Config2__RelatedProduct__c >> getProdMap() {
        //childDetailsSize = prodMap.size();
        return prodMap;
    }
    public Map < id, Apttus_Config2__RelatedProduct__c > getsetWithRelatedPkgID1() {
        //childDetailsSize = childDetails.size();
        return setWithRelatedPkgID1;
    }
    public void setTabInFocus() {
            //tabInFocus = tabInFocus;//'Instructor Resources';
            SYstem.debug(tabInFocus);
        }
        /**
         * Description : Get Packages details
         * @param String
         * @return String
         * @throws NA
         **/
        public pageReference getComponentDetails() {
            if(packageDetailsForProductCatalog != null && !packageDetailsForProductCatalog.isEmpty())
            {
                packageDetailsForProductCatalog.clear();
            }
            if(prodMap != null && !prodMap.isEmpty())
            {
                prodMap.clear();
            }
            if(productCatalogIdFromURL!=null){
            packageChildDetailsForProductCatalog = [select Apttus_Config2__ProductId__r.Id, Apttus_Config2__ProductId__r.Name, Apttus_Config2__RelatedProductId__r.Id, Apttus_Config2__RelatedProductId__r.Name, Apttus_Config2__RelatedProductId__r.Author__c, Apttus_Config2__RelatedProductId__r.Edition__c, Apttus_Config2__RelatedProductId__r.SBN__c, Apttus_Config2__RelatedProductId__r.Binding__c, Apttus_Config2__RelatedProductId__r.ISBN__c, Apttus_Config2__RelatedProductId__r.Copyright_Year__c, Apttus_Config2__RelatedProductId__r.Status__c, Apttus_Config2__RelatedProductId__r.InstockDate__c, Apttus_Config2__RelatedProductId__r.Sub_Brand__c, Apttus_Config2__RelatedProductId__r.Platform__c, Apttus_Config2__RelatedProductId__r.URL__c, Apttus_Config2__RelatedProductId__r.IRC_Link__c, Apttus_Config2__RelatedProductId__r.Priority__c, Component_Package__c from Apttus_Config2__RelatedProduct__c where Apttus_Config2__ProductId__c = : productCatalogIdFromURL AND Component_Package__c = true];
            if(packageChildDetailsForProductCatalog!=null){
                 for (Apttus_Config2__RelatedProduct__c relcomp: packageChildDetailsForProductCatalog) {
            setWithProductComponentID.add(relcomp.Apttus_Config2__RelatedProductId__r.Id);
            mapDisplayProductComponentPrice.put(relcomp.Apttus_Config2__RelatedProductId__r.Id, relcomp);
                }
                }
                }
            getPriceForInstStud();
            return null;
        }
        
        
        /**
         * Description : Get Packages details
         * @param String
         * @return String
         * @throws NA
         **/
        public pageReference getProductPackageDetails() {
        if(packageChildDetailsForProductCatalog != null && !packageChildDetailsForProductCatalog.isEmpty())
        {
            packageChildDetailsForProductCatalog.clear();
        }
        if(packageDetailsForProductCatalog!=null && !packageDetailsForProductCatalog.isEmpty() ){
        packageDetailsForProductCatalog.clear();
        }
        if(prodMap !=null && !prodMap.isEmpty()){
        prodMap.clear();
        }
            List < Apttus_Config2__RelatedProduct__c > ls = new List < Apttus_Config2__RelatedProduct__c > ();
        if(productCatalogIdFromURL!=null){
        packageDetailsForProductCatalog = [select Apttus_Config2__ProductId__r.Id, Apttus_Config2__ProductId__r.Name, Apttus_Config2__RelatedProductId__r.Name, Apttus_Config2__ProductId__r.SBN__c, Apttus_Config2__ProductId__r.ISBN__c, Apttus_Config2__ProductId__r.Copyright_Year__c, Apttus_Config2__ProductId__r.Edition__c, Apttus_Config2__ProductId__r.Status__c, Relation_Package__c from Apttus_Config2__RelatedProduct__c where Apttus_Config2__RelatedProductId__c = : productCatalogIdFromURL AND Relation_Package__c = true AND Apttus_Config2__ProductId__r.Apttus_Config2__ConfigurationType__c = 'Option'];
        if(packageDetailsForProductCatalog!=null){
        for (Apttus_Config2__RelatedProduct__c relpkg1: packageDetailsForProductCatalog) {
            setWithProductPkgID.add(relpkg1.Apttus_Config2__ProductId__c);
            ls.add(relpkg1);
            mapDisplayProductPkgPrice.put(relpkg1.Apttus_Config2__ProductId__c, relpkg1);
            setWithRelatedPkgID1.put(relpkg1.Apttus_Config2__ProductId__c, relpkg1);
        }
        }
        set < ID > keySetId = new set < ID > ();
        keySetId = setWithRelatedPkgID1.keySet();
        List < Apttus_Config2__RelatedProduct__c > relpack = new List < Apttus_Config2__RelatedProduct__c > ();
        for (Apttus_Config2__RelatedProduct__c relpack1: [select Apttus_Config2__ProductId__r.Id, Apttus_Config2__ProductId__r.Name,
                Apttus_Config2__ProductId__r.SBN__c, Apttus_Config2__ProductId__r.ISBN__c,
                Apttus_Config2__RelatedProductId__r.Name, Apttus_Config2__RelatedProductId__r.id, Apttus_Config2__RelatedProductId__r.Author__c,
                Apttus_Config2__RelatedProductId__r.SBN__c, Apttus_Config2__RelatedProductId__r.Binding__c,
                Apttus_Config2__RelatedProductId__r.ISBN__c, Apttus_Config2__RelatedProductId__r.Copyright_Year__c,
                Apttus_Config2__RelatedProductId__r.Status__c, Apttus_Config2__RelatedProductId__r.InstockDate__c,
                Apttus_Config2__RelatedProductId__r.Sub_Brand__c, Apttus_Config2__RelatedProductId__r.Platform__c,
                Apttus_Config2__RelatedProductId__r.URL__c, Apttus_Config2__RelatedProductId__r.IRC_Link__c,
                Apttus_Config2__RelatedProductId__r.Priority__c, Component_Package__c
                from Apttus_Config2__RelatedProduct__c where Apttus_Config2__ProductId__c IN: keySetId
                AND Relation_Package__c = true AND Apttus_Config2__RelatedProductId__r.Apttus_Config2__ConfigurationType__c = 'Option'
            ]) {
            if (prodMap.containsKey(relpack1.Apttus_Config2__ProductId__c)) prodMap.get(relpack1.Apttus_Config2__ProductId__c).add(relpack1);
            else {
                List < Apttus_Config2__RelatedProduct__c > tempLst2 = new List < Apttus_Config2__RelatedProduct__c > ();
                tempLst2.add(relpack1);
                prodMap.put(relpack1.Apttus_Config2__ProductId__c, tempLst2);
            }
        }
        System.debug('prodMap...............'+prodMap);
                    if(!setWithRelatedPkgID1.isEmpty())
                    {
                        List < Apttus_Config2__RelatedProduct__c > dummyLst = new List < Apttus_Config2__RelatedProduct__c > ();
                        for(Id myProParId : setWithRelatedPkgID1.keyset())
                        {
                            if(!prodMap.isEmpty())
                            {
                                if(prodMap.containsKey(myProParId))
                                {
                                    
                                }else
                                {
                                    prodMap.put(myProParId,dummyLst);
                                }
                            }   
                        }
                    }
                    if((prodMap==null || prodMap.isEmpty()) && setWithRelatedPkgID1 != null && !setWithRelatedPkgID1.isEmpty()){
                    List < Apttus_Config2__RelatedProduct__c > dummyLst = new List < Apttus_Config2__RelatedProduct__c > ();
                    for(Id prodMapPar : setWithRelatedPkgID1.keyset())
                    {
                        prodMap.put(prodMapPar,dummyLst);
                    }       
                    }
        }
            getPriceForInstStud();
            return null;
        }
        
        
        /**
         * Description : Get Packages details
         * @param String
         * @return String
         * @throws NA
         **/
    public pageReference getPackageDetails() {
            if (listWithStudentResource != null && !listWithStudentResource.isEmpty()) {
                listWithStudentResource.clear();
            }
            if (listWithInstructorResource != null && !listWithInstructorResource.isEmpty()) {
                listWithInstructorResource.clear();
            }
            if (packageDetails != null && !packageDetails.isEmpty()) {
            packageDetails.clear();
            }
           if (famMap != null && !famMap.isEmpty()) {
            famMap.clear();
           }
            List < Apttus_Config2__RelatedProduct__c > ls = new List < Apttus_Config2__RelatedProduct__c > ();
            if (productFamilyIdFromURL != null) {
                packageDetails = [select Apttus_Config2__ProductId__r.Id, Apttus_Config2__RelatedProductId__r.Name, Apttus_Config2__RelatedProductId__r.SBN__c,
                    Apttus_Config2__RelatedProductId__r.ISBN__c, Apttus_Config2__RelatedProductId__r.Copyright_Year__c, Apttus_Config2__RelatedProductId__r.Status__c, Apttus_Config2__RelatedProductId__r.Edition__c
                    from Apttus_Config2__RelatedProduct__c where Apttus_Config2__ProductId__c = : productFamilyIdFromURL AND Relation_Package__c = true
                ];
                if (packageDetails != null) {
                    for (Apttus_Config2__RelatedProduct__c relpkg: packageDetails) {
                        setWithFamilyPkgID.add(relpkg.Apttus_Config2__RelatedProductId__c);
                        mapDisplayfamilyPkgPrice.put(relpkg.Apttus_Config2__RelatedProductId__c, relpkg);
                        setWithRelatedPkgID2.put(relpkg.Apttus_Config2__RelatedProductId__c, relpkg);
                    }
                    System.debug('setWithRelatedPkgID2...........'+setWithRelatedPkgID2);
                    set < ID > keySetIdFam = new set < ID > ();
                    keySetIdFam = setWithRelatedPkgID2.keySet();
                    List < Apttus_Config2__RelatedProduct__c > relFam = new List < Apttus_Config2__RelatedProduct__c > ();
                    
                    for (Apttus_Config2__RelatedProduct__c rel: [select Apttus_Config2__ProductId__c, Apttus_Config2__ProductId__r.Id, Apttus_Config2__ProductId__r.Name,
                            Apttus_Config2__RelatedProductId__r.Name, Apttus_Config2__RelatedProductId__r.Author__c,
                            Apttus_Config2__RelatedProductId__r.SBN__c, Apttus_Config2__RelatedProductId__r.Binding__c,
                            Apttus_Config2__RelatedProductId__r.ISBN__c, Apttus_Config2__RelatedProductId__r.Copyright_Year__c,
                            Apttus_Config2__RelatedProductId__r.Status__c, Apttus_Config2__RelatedProductId__r.InstockDate__c,
                            Apttus_Config2__RelatedProductId__r.Sub_Brand__c, Apttus_Config2__RelatedProductId__r.Platform__c,
                            Apttus_Config2__RelatedProductId__r.URL__c, Apttus_Config2__RelatedProductId__r.IRC_Link__c,
                            Apttus_Config2__RelatedProductId__r.Priority__c, Component_Package__c
                            from Apttus_Config2__RelatedProduct__c where Apttus_Config2__ProductId__c IN: keySetIdFam
                            AND Component_Package__c = true
                        ]) {
                        if (famMap.containsKey(rel.Apttus_Config2__ProductId__c)) 
                        famMap.get(rel.Apttus_Config2__ProductId__c).add(rel);
                        else {
                            List < Apttus_Config2__RelatedProduct__c > tempLst = new List < Apttus_Config2__RelatedProduct__c > ();
                            tempLst.add(rel);
                            famMap.put(rel.Apttus_Config2__ProductId__c, tempLst);
                        }
                    }
                    System.debug('famMap...............'+famMap);
                    if(!setWithRelatedPkgID2.isEmpty())
                    {
                        List < Apttus_Config2__RelatedProduct__c > dummyLst = new List < Apttus_Config2__RelatedProduct__c > ();
                        for(Id myParId : setWithRelatedPkgID2.keyset())
                        {
                            if(!famMap.isEmpty())
                            {
                                if(famMap.containsKey(myParId))
                                {
                                    
                                }else
                                {
                                    famMap.put(myParId,dummyLst);
                                }
                            }   
                        }
                    }
                    if((famMap==null || famMap.isEmpty()) && setWithRelatedPkgID2 != null && !setWithRelatedPkgID2.isEmpty()){
                    List < Apttus_Config2__RelatedProduct__c > dummyLst = new List < Apttus_Config2__RelatedProduct__c > ();
                    for(Id famMapPar : setWithRelatedPkgID2.keyset())
                    {
                        famMap.put(famMapPar,dummyLst);
                    }       
                    }
                }
            }
            getPriceForInstStud();
            return null;
        }
        /**
         * Description : Get instructor resource details
         * @param String
         * @return String
         * @throws NA
         **/
    public pageReference getInstructorResourceDetails() {
        if (listWithStudentResource != null && !listWithStudentResource.isEmpty()) {
            listWithStudentResource.clear();
        }
        if (packageDetails != null && !packageDetails.isEmpty()) {
            packageDetails.clear();
        }
        if (famMap != null && !famMap.isEmpty()) {
            famMap.clear();
        }
        listWithInstructorResource = new List < Apttus_Config2__RelatedProduct__c > ();
        if (productFamilyIdFromURL != null) {
            listWithInstructorResource = [select elearning_Assessment__c, Instructor_Resource__c, Student_Resource__c, Apttus_Config2__RelatedProductId__r.Id, Apttus_Config2__RelatedProductId__r.Name, Apttus_Config2__RelatedProductId__r.Author__c, Apttus_Config2__RelatedProductId__r.SBN__c, Apttus_Config2__RelatedProductId__r.ISBN__c, Apttus_Config2__RelatedProductId__r.Copyright_Year__c, Apttus_Config2__RelatedProductId__r.Binding__c, Apttus_Config2__RelatedProductId__r.Status__c, Apttus_Config2__RelatedProductId__r.InstockDate__c, Apttus_Config2__RelatedProductId__r.Priority__c, Apttus_Config2__RelatedProductId__r.Sub_Brand__c, Apttus_Config2__RelatedProductId__r.Platform__c, Apttus_Config2__RelatedProductId__r.URL__c, Apttus_Config2__RelatedProductId__r.IRC_Link__c from Apttus_Config2__RelatedProduct__c where Apttus_Config2__ProductId__c = : productFamilyIdFromURL And Instructor_Resource__c =  True];
        }
        if (listWithInstructorResource != null) {
            for (Apttus_Config2__RelatedProduct__c InsResource: listWithInstructorResource) {
                if (InsResource.Instructor_Resource__c == True) {
                    setWithInstructorID.add(InsResource.Apttus_Config2__RelatedProductId__r.Id);
                    mapDisplayInsPrice.put(InsResource.Apttus_Config2__RelatedProductId__r.Id, InsResource);
                }
            }
        }
        getPriceForInstStud();
        return null;
    }
    public pageReference getStudentResourceDetails() {
            if (listWithInstructorResource != null && !listWithInstructorResource.isEmpty()) {
                listWithInstructorResource.clear();
            }
            if (packageDetails != null && !packageDetails.isEmpty()) {
                packageDetails.clear();
            }
            if (famMap != null && !famMap.isEmpty()) {
                famMap.clear();
            }
            listWithStudentResource = new List < Apttus_Config2__RelatedProduct__c > ();
            if (productFamilyIdFromURL != null) {
                listWithStudentResource = [select elearning_Assessment__c, Instructor_Resource__c, Student_Resource__c, Apttus_Config2__RelatedProductId__r.Id, Apttus_Config2__RelatedProductId__r.Name, Apttus_Config2__RelatedProductId__r.Author__c, Apttus_Config2__RelatedProductId__r.SBN__c, Apttus_Config2__RelatedProductId__r.ISBN__c, Apttus_Config2__RelatedProductId__r.Copyright_Year__c, Apttus_Config2__RelatedProductId__r.Binding__c, Apttus_Config2__RelatedProductId__r.Status__c, Apttus_Config2__RelatedProductId__r.InstockDate__c, Apttus_Config2__RelatedProductId__r.Priority__c, Apttus_Config2__RelatedProductId__r.Sub_Brand__c, Apttus_Config2__RelatedProductId__r.Platform__c, Apttus_Config2__RelatedProductId__r.URL__c, Apttus_Config2__RelatedProductId__r.IRC_Link__c from Apttus_Config2__RelatedProduct__c where Apttus_Config2__ProductId__c = : productFamilyIdFromURL And(Student_Resource__c = : True)];
            }
            if (listWithStudentResource != null) {
                for (Apttus_Config2__RelatedProduct__c StuResource: listWithStudentResource) {
                    if (StuResource.Student_Resource__c == True) {
                        setWithStudentID.add(StuResource.Apttus_Config2__RelatedProductId__r.Id);
                        mapDisplayStudPrice.put(StuResource.Apttus_Config2__RelatedProductId__r.Id, StuResource);
                        
                    }
                }
            }
            getPriceForInstStud();
            return null;
        }
        //Added For Student/Instructor Net/List Price.
    public void getPriceForInstStud() {
            System.debug('in get price method******..' + listOfproductFamilyClass);
            String loggedInUserpriceListName1 = [select Price_List__c from User where id = : UserInfo.getUserId()].Price_List__c;
            System.debug('loggedInUserpriceListName1..' + loggedInUserpriceListName1);
            if (!String.isBlank(loggedInUserpriceListNamebase)) {
                List < Apttus_Config2__PriceListItem__c > aConfigPriceList1 = [select Apttus_Config2__ProductId__r.id, Apttus_Config2__ProductId__r.Edition__c, Apttus_Config2__ListPrice__c, Net_Price__c from Apttus_Config2__PriceListItem__c where((Apttus_Config2__ProductId__c IN: setWithInstructorID) OR(Apttus_Config2__ProductId__c IN: setWithStudentID) OR(Apttus_Config2__ProductId__c IN: setWithFamilyPkgID) OR(Apttus_Config2__ProductId__c IN: setWithProductPkgID) OR(Apttus_Config2__ProductId__c IN: setWithProductComponentID)) and Apttus_Config2__PriceListId__r.name = : loggedInUserpriceListNamebase and Apttus_Config2__Active__c = true];
                if (!aConfigPriceList1.isEmpty()) {
                    for (Apttus_Config2__PriceListItem__c priceList1: aConfigPriceList1) {
                        System.debug('pricelist1.....' + priceList1);
                        if (priceList1.Apttus_Config2__ProductId__r.Id != null || !String.isBlank(priceList1.Apttus_Config2__ProductId__r.Id)) {
                            if (mapDisplayInsPrice.containsKey(priceList1.Apttus_Config2__ProductId__r.Id)) {
                                if (priceList1 != null) {
                                    System.debug('priceList1family.....' + priceList1);
                                    if (priceList1.Apttus_Config2__ListPrice__c != null) {
                                        mapDisplayInstructorListPrice.put(priceList1.Apttus_Config2__ProductId__r.Id, priceList1.Apttus_Config2__ListPrice__c);
                                    } else {
                                        mapDisplayInstructorListPrice.put(priceList1.Apttus_Config2__ProductId__r.Id, 0.00);
                                    }
                                    if ((priceList1.Net_Price__c != null)) mapDisplayInstructorNetPrice.put(priceList1.Apttus_Config2__ProductId__r.Id, priceList1.Net_Price__c);
                                    else mapDisplayInstructorNetPrice.put(priceList1.Apttus_Config2__ProductId__r.Id, 0.00);
                                }
                            }
                            if (mapDisplayStudPrice.containsKey(priceList1.Apttus_Config2__ProductId__r.Id)) {
                                if (priceList1 != null) {
                                    System.debug('priceList1family.....' + priceList1);
                                    if (priceList1.Apttus_Config2__ListPrice__c != null) {
                                        mapDisplayStudentListPrice.put(priceList1.Apttus_Config2__ProductId__r.Id, priceList1.Apttus_Config2__ListPrice__c);
                                    } else {
                                        mapDisplayStudentListPrice.put(priceList1.Apttus_Config2__ProductId__r.Id, 0.00);
                                    }
                                    if ((priceList1.Net_Price__c != null)) mapDisplayStudentNetPrice.put(priceList1.Apttus_Config2__ProductId__r.Id, priceList1.Net_Price__c);
                                    else mapDisplayStudentNetPrice.put(priceList1.Apttus_Config2__ProductId__r.Id, 0.00);
                                }
                            }
                            if (mapDisplayfamilyPkgPrice.containsKey(priceList1.Apttus_Config2__ProductId__r.Id)) {
                                if (priceList1 != null) {
                                    System.debug('priceList1family.....' + priceList1);
                                    if (priceList1.Apttus_Config2__ListPrice__c != null) {
                                        mapDisplayFamilyPkgListPrice.put(priceList1.Apttus_Config2__ProductId__r.Id, priceList1.Apttus_Config2__ListPrice__c);
                                    } else {
                                        mapDisplayFamilyPkgListPrice.put(priceList1.Apttus_Config2__ProductId__r.Id, 0.00);
                                    }
                                    if ((priceList1.Net_Price__c != null)) mapDisplayFamilyPkgNetPrice.put(priceList1.Apttus_Config2__ProductId__r.Id, priceList1.Net_Price__c);
                                    else mapDisplayFamilyPkgNetPrice.put(priceList1.Apttus_Config2__ProductId__r.Id, 0.00);
                                }
                            }
                            if (mapDisplayProductPkgPrice.containsKey(priceList1.Apttus_Config2__ProductId__r.Id)) {
                                if (priceList1 != null) {
                                    System.debug('priceList1family.....' + priceList1);
                                    if (priceList1.Apttus_Config2__ListPrice__c != null) {
                                        mapDisplayProductPkgListPrice.put(priceList1.Apttus_Config2__ProductId__r.Id, priceList1.Apttus_Config2__ListPrice__c);
                                    } else {
                                        mapDisplayProductPkgListPrice.put(priceList1.Apttus_Config2__ProductId__r.Id, 0.00);
                                    }
                                    if ((priceList1.Net_Price__c != null)) mapDisplayProductPkgNetPrice.put(priceList1.Apttus_Config2__ProductId__r.Id, priceList1.Net_Price__c);
                                    else mapDisplayProductPkgNetPrice.put(priceList1.Apttus_Config2__ProductId__r.Id, 0.00);
                                }
                            }
                            if (mapDisplayProductComponentPrice.containsKey(priceList1.Apttus_Config2__ProductId__r.Id)) {
                                if (priceList1 != null) {
                                    System.debug('priceList1family.....' + priceList1);
                                    if (priceList1.Apttus_Config2__ListPrice__c != null) {
                                        mapDisplayProductComponentListPrice.put(priceList1.Apttus_Config2__ProductId__r.Id, priceList1.Apttus_Config2__ListPrice__c);
                                    } else {
                                        mapDisplayProductComponentListPrice.put(priceList1.Apttus_Config2__ProductId__r.Id, 0.00);
                                    }
                                    if ((priceList1.Net_Price__c != null)) mapDisplayProductComponentNetPrice.put(priceList1.Apttus_Config2__ProductId__r.Id, priceList1.Net_Price__c);
                                    else mapDisplayProductComponentNetPrice.put(priceList1.Apttus_Config2__ProductId__r.Id, 0.00);
                                }
                            }
                            System.debug('*****elearnprice***' + priceList1.Apttus_Config2__ProductId__c);
                            if (mapDisplayelearnPrice.containsKey(priceList1.Apttus_Config2__ProductId__c)) {
                                if (priceList1 != null) {
                                    System.debug('priceList1family.....' + priceList1);
                                    if (priceList1.Apttus_Config2__ListPrice__c != null) {
                                        mapDisplayelearnListPrice.put(priceList1.Apttus_Config2__ProductId__r.Id, priceList1.Apttus_Config2__ListPrice__c);
                                    } else {
                                        mapDisplayelearnListPrice.put(priceList1.Apttus_Config2__ProductId__r.Id, 0.00);
                                    }
                                    if ((priceList1.Net_Price__c != null)) mapDisplayelearnNetPrice.put(priceList1.Apttus_Config2__ProductId__r.Id, priceList1.Net_Price__c);
                                    else mapDisplayelearnNetPrice.put(priceList1.Apttus_Config2__ProductId__r.Id, 0.00);
                                }
                            }
                        }
                    }
                }
            }
        }
        /**
         * Description : Get marketing information details for links under rep tools/About this product
         * @param String
         * @return String
         * @throws NA
         **/
    public void getMarketingDetails() {
        //listForTypeRepTools = new List<Marketing_Information__c>();
        listWithMarketingInfoSubType = new List < Marketing_Information__c > ();
        System.debug('listToCheckTheAboutThisProdToolsLink...getMarketingDetails()..' + marketingInfoSubtypeString + '...' + marketingInformationTypeString);
        List < AggregateResult > order_aboutProduct = [select min(order__c) from Marketing_Information__c where Family__c = : productFamilyIdFromURL AND Type__c = : marketingInformationTypeString And Sub_Type__c = : marketingInfoSubtypeString];
        for (AggregateResult ar: order_aboutProduct) {
            marOrder_link = integer.ValueOf(ar.get('expr0'));
            System.debug('marOrder_link..' + marOrder_link);
        }
        if (marketingInfoSubtypeString != null && marketingInformationTypeString != null) {
            listForTypeRepTools = [select Id, Content__c, Name from Marketing_Information__c where Type__c = : marketingInformationTypeString And Sub_Type__c = : marketingInfoSubtypeString AND Order__c = : marOrder_link AND Family__c = : productFamilyIdFromURL];
            listToCheckTheAboutThisProdToolsLink = listForTypeRepTools;
            System.debug('listToCheckTheAboutThisProdToolsLink...getMarketingDetails()..' + listToCheckTheAboutThisProdToolsLink);
            if (marketingInformationTypeString == 'About this Product') onClickLinkAbout = true;
        }
    }
    public void getMarketingDetailsForRep() {
            listForTypeRepToolsTab = new List < Marketing_Information__c > ();
            System.debug('listToCheckTheAboutThisProdToolsLink...getMarketingDetails()..' + marketingInfoSubtypeString + '...' + marketingInformationTypeString);
            List < AggregateResult > order_aboutProduct = [select min(order__c) from Marketing_Information__c where Family__c = : productFamilyIdFromURL AND Type__c = : marketingInformationTypeString And Sub_Type__c = : marketingInfoSubtypeString];
            for (AggregateResult ar: order_aboutProduct) {
                marOrder_link = integer.ValueOf(ar.get('expr0'));
                System.debug('marOrder_link..' + marOrder_link);
            }
            if (marketingInfoSubtypeString != null && marketingInformationTypeString != null) {
                listForTypeRepToolsTab = [select Id, Content__c, Name from Marketing_Information__c where Type__c = : marketingInformationTypeString And Sub_Type__c = : marketingInfoSubtypeString AND Order__c = : marOrder_link AND Family__c = : productFamilyIdFromURL];
                if (marketingInformationTypeString == 'Rep Tools') onClickLinkRep = true;
            }
        }
        /**
         * Description : Get marketing information details for links under rep tools/About this product For ProductCatalog
         * @param String
         * @return String
         * @throws NA
         **/
    public void getMarketingDetailsForProduct() {
            listWithMarketingInfoSubTypeForProduct = new List < Marketing_Information__c > ();
            List < AggregateResult > order_aboutProductCatalog = [select min(order__c) from Marketing_Information__c where Product__c = : productCatalogIdFromURL AND Type__c = : marketingInformationTypeStringForProduct And Sub_Type__c = : marketingInfoSubtypeStringForProduct];
            System.debug(marketingInformationTypeStringForProduct);
            System.debug('Sub_Type__c' + marketingInfoSubtypeStringForProduct);
            System.debug(productCatalogIdFromURL);
            System.debug(integer.ValueOf(order_aboutProductCatalog[0].get('expr0')));
            for (AggregateResult ar: order_aboutProductCatalog) {
                marOrder_linkProduct = integer.ValueOf(ar.get('expr0'));
                System.debug('marOrder_linkProduct..' + marOrder_linkProduct);
            }
            if (marketingInfoSubtypeStringForProduct != null && marketingInformationTypeStringForProduct != null) {
                listForTypeRepToolsProduct = [select Id, Content__c, Name from Marketing_Information__c where Type__c = : marketingInformationTypeStringForProduct And Sub_Type__c = : marketingInfoSubtypeStringForProduct AND Order__c = : marOrder_linkProduct AND Product__c = : productCatalogIdFromURL limit 1];
                listToCheckTheAboutThisProdToolsLinkForProduct = listForTypeRepToolsProduct;
                System.debug('values inside getMarketingDetailsForProduct....' + listToCheckTheAboutThisProdToolsLinkForProduct);
                if (marketingInformationTypeStringForProduct == 'About this Product') onClickLinkAboutProduct = true;
            }
        }
        /**
         * Description : Inner class for values Added For Custom Filter Search
         * @param String
         * @return String
         * @throws NA
         **/
    public class dynamicAddFilterSearch {
        public List < SelectOption > productFieldLists {
            get;
            set;
        }
        public List < SelectOption > conditionLists {
            get;
            set;
        }
        public List < SelectOption > searchType {
            get;
            set;
        }
        public String searchText {
            get;
            set;
        } //{searchText ='Pearson';}
        public String searchTextDate {
            get;
            set;
        } //{searchText ='Pearson';} 
        public String selectedCondition {
            get;
            set;
        }
        public String selectedProductFilterValue {
            get;
            set;
        }
        public String selectedSearchType {
            get;
            set;
        }
        public Boolean toDisplayLookup {
            get;
            set;
        } /** Swati-Purpose: selected value**/
        public Integer rowNumber {
            get;
            set;
        } /** Swati-Purpose: selected value**/
        public dynamicAddFilterSearch(List < SelectOption > productFieldLstWrapperCons, List < SelectOption > conditionLstWrapperCons, List < SelectOption > searchTypeLstWrapperCons, String selectedSearchTypeInput, String searchTextInput, String selectedConditionInput, boolean toDisplayLookupInput, Integer rowNumberInput) {
            productFieldLists = productFieldLstWrapperCons;
            conditionLists = conditionLstWrapperCons;
            searchType = searchTypeLstWrapperCons;
            searchText = searchTextInput;
            selectedCondition = selectedConditionInput;
            selectedProductFilterValue = '';
            selectedSearchType = selectedSearchTypeInput;
            toDisplayLookup = toDisplayLookupInput;
            rowNumber = rowNumberInput;
        }
    }
    /**
     * Description : fetch status pikclist field values dynamiccally
     * @param String
     * @return String
     * @throws NA
     **/
    public List < SelectOption > getStatuses() {
            List < SelectOption > options = new List < SelectOption > ();
            Schema.DescribeFieldResult fieldResult = Product2.Status__c.getDescribe();
            List < Schema.PicklistEntry > ple = fieldResult.getPicklistValues();
            for (Schema.PicklistEntry f: ple) {
                options.add(new SelectOption(f.getLabel(), f.getValue()));
            }
            return options;
        }
        /**
         * Description : fetch Category2__c picklist field values dynamically
         * @param String
         * @return String
         * @throws NA
         **/
    public List < SelectOption > getCategories() {
            List < SelectOption > options = new List < SelectOption > ();
            Schema.DescribeFieldResult fieldResult = Product2.Category2__c.getDescribe();
            List < Schema.PicklistEntry > ple = fieldResult.getPicklistValues();
            for (Schema.PicklistEntry f: ple) {
                options.add(new SelectOption(f.getLabel(), f.getValue()));
            }
            return options;
        }
        /**
         * Description : Inner class for Product Family Table
         * @param String
         * @return String
         * @throws NA
         **/
    public class DisplayProductWrapper {
        public Apttus_Config2__PriceListItem__c priceListItem {
            get;
            set;
        }
        public Marketing_Information__c marketingInfo {
            get;
            set;
        }
        public Apttus_Config2__ProductClassification__c productClassification {
            get;
            set;
        }
        public DisplayProductWrapper(Apttus_Config2__PriceListItem__c priceListItemInput, Marketing_Information__c marketingInfoInput, Apttus_Config2__ProductClassification__c productClassificationInput) {
            priceListItem = priceListItemInput;
            marketingInfo = marketingInfoInput;
            productClassification = productClassificationInput;
        }
    }
    /**
     * Description : Inner class for values Added For Opportunity Cart
     * @param String
     * @return String
     * @throws NA
     **/
    public class ProductFamilyClass {
        public Apttus_Config2__RelatedProduct__c relatedProd {
            get;
            set;
        }
        public OpportunityLineItem relatedProd1 {
            get;
            set;
        }
        public Apttus_Config2__PriceListItem__c oppProd {
            get;
            set;
        }
       // public integer sQuantity;
        public decimal sQuantity {
            get;
            set;
        }
        public ID oppId_productId {
            get;
            set;
        }
       /* public void setsQuantity(integer stmp){
            system.debug('updated value'+stmp);
            this.sQuantity=stmp;
        }
        public decimal getsQuantity(){
            return sQuantity;
        }
        ProductFamilyClass(Apttus_Config2__RelatedProduct__c rp,decimal sq){
            this.sQuantity=sq;
            this.relatedProd=rp;
            System.debug(sQuantity+'...........'+relatedProd);
        }
        ProductFamilyClass(){
            System.debug(sQuantity+'...........'+relatedProd);
        }*/
    }
    /**
     * Description : Will be invoked when Add To Oppty is clicked in Pearson Choice Tab - Method to show popup if more than one product is found in pearson choice
     * @param NA
     * @return void
     * @throws NA
     **/
    public void pearsonChoiceAddToOppty() {
            personChoiceWrapperList = new List < pearsonChoiceWrapperClass > ();
            listWithPearsonProduct = new List < Id > ();
            listWithAddToOpptyProd = new List < Pearson_Choice__c > ();
            System.debug(pearsonChoiceIndex);
            if (pearsonChoiceIndex != null) {
                System.debug(pearsonChoiceIndex);
                listWithAddToOpptyProd.add(listWithPearsonChoices[pearsonChoiceIndex]);
                if (listWithAddToOpptyProd != null && !listWithAddToOpptyProd.isEmpty()) {
                    if (listWithAddToOpptyProd[0].Bookstore__c != null) {
                        listWithPearsonProduct.add(listWithAddToOpptyProd[0].Bookstore__c);
                        personChoiceWrapperList.add(new pearsonChoiceWrapperClass(listWithAddToOpptyProd[0].Bookstore__c, listWithAddToOpptyProd[0].Bookstore__r.Name, listWithAddToOpptyProd[0].Bookstore__r.Author__c, listWithAddToOpptyProd[0].Bookstore__r.Copyright_Year__c, listWithAddToOpptyProd[0].Bookstore__r.Edition__c, listWithAddToOpptyProd[0].Bookstore__r.ISBN__c, listWithAddToOpptyProd[0].Bookstore__r.InstockDate__c, listWithAddToOpptyProd[0].Bookstore__r.Status__c, listWithAddToOpptyProd[0].Bookstore__r.Sub_Brand__c));
                    }
                    if (listWithAddToOpptyProd[0].eText_Offer__c != null) {
                        listWithPearsonProduct.add(listWithAddToOpptyProd[0].eText_Offer__c);
                        personChoiceWrapperList.add(new pearsonChoiceWrapperClass(listWithAddToOpptyProd[0].eText_Offer__c, listWithAddToOpptyProd[0].eText_Offer__r.Name, listWithAddToOpptyProd[0].eText_Offer__r.Author__c, listWithAddToOpptyProd[0].eText_Offer__r.Copyright_Year__c, listWithAddToOpptyProd[0].eText_Offer__r.Edition__c, listWithAddToOpptyProd[0].eText_Offer__r.ISBN__c, listWithAddToOpptyProd[0].eText_Offer__r.InstockDate__c, listWithAddToOpptyProd[0].eText_Offer__r.Status__c, listWithAddToOpptyProd[0].eText_Offer__r.Sub_Brand__c));
                    }
                    if (listWithAddToOpptyProd[0].Instant_Access__c != null) {
                        listWithPearsonProduct.add(listWithAddToOpptyProd[0].Instant_Access__c);
                        personChoiceWrapperList.add(new pearsonChoiceWrapperClass(listWithAddToOpptyProd[0].Instant_Access__c, listWithAddToOpptyProd[0].Instant_Access__r.Name, listWithAddToOpptyProd[0].Instant_Access__r.Author__c, listWithAddToOpptyProd[0].Instant_Access__r.Copyright_Year__c, listWithAddToOpptyProd[0].Instant_Access__r.Edition__c, listWithAddToOpptyProd[0].Instant_Access__r.ISBN__c, listWithAddToOpptyProd[0].Instant_Access__r.InstockDate__c, listWithAddToOpptyProd[0].Instant_Access__r.Status__c, listWithAddToOpptyProd[0].Instant_Access__r.Sub_Brand__c));
                    }
                    if (listWithAddToOpptyProd[0].Print_Offer__c != null) {
                        listWithPearsonProduct.add(listWithAddToOpptyProd[0].Print_Offer__c);
                        personChoiceWrapperList.add(new pearsonChoiceWrapperClass(listWithAddToOpptyProd[0].Print_Offer__c, listWithAddToOpptyProd[0].Print_Offer__r.Name, listWithAddToOpptyProd[0].Print_Offer__r.Author__c, listWithAddToOpptyProd[0].Print_Offer__r.Copyright_Year__c, listWithAddToOpptyProd[0].Print_Offer__r.Edition__c, listWithAddToOpptyProd[0].Print_Offer__r.ISBN__c, listWithAddToOpptyProd[0].Print_Offer__r.InstockDate__c, listWithAddToOpptyProd[0].Print_Offer__r.Status__c, listWithAddToOpptyProd[0].Print_Offer__r.Sub_Brand__c));
                    }
                }
                //Id pearsonChoiceProductId;
                if (listWithPearsonProduct.size() > 1) {
                    renderAddToOpptyPopUp = true;
                } /*else if (listWithPearsonProduct != null) {
                    if (listWithAddToOpptyProd[0].Print_Offer__c != null) {
                        pearsonChoiceProductId = listWithAddToOpptyProd[0].Print_Offer__c;
                    } else if (listWithAddToOpptyProd[0].Instant_Access__c != null) {
                        pearsonChoiceProductId = listWithAddToOpptyProd[0].Instant_Access__c;
                    } else if (listWithAddToOpptyProd[0].eText_Offer__c != null) {
                        pearsonChoiceProductId = listWithAddToOpptyProd[0].eText_Offer__c;
                    } else if (listWithAddToOpptyProd[0].Bookstore__c != null) {
                        pearsonChoiceProductId = listWithAddToOpptyProd[0].Bookstore__c;
                    }
                    personChoiceWrapperList.add(new pearsonChoiceWrapperClass(pearsonChoiceProductId, '', '', '', '', '', System.Today(), '', ''));
                }*/
                addToOpptyPearsonChoice();
            }
        }
        //Added by kamal for taxanomy view
    public void showChildren() {
        system.debug('currParent----->' + currParent);
        List < Apttus_Config2__ClassificationHierarchy__c > hasChildLsit = new List < Apttus_Config2__ClassificationHierarchy__c > ();
        Set < Id > childId = new Set < Id > ();
        system.debug('isGrandParentChanged----->' + isGrandParentChanged);
        if (isGrandParentChanged) {
            mapChild.clear();
            mapChildHasNext.clear();
            clasLst = [select Apttus_Config2__HierarchyId__c, Id, Pearson_Course_Structure_Code__c, Type__c, Name, Apttus_Config2__AncestorId__c from Apttus_Config2__ClassificationHierarchy__c where Apttus_Config2__HierarchyId__c = : currParent and(Apttus_Config2__AncestorId__c = null or Apttus_Config2__AncestorId__c = '') And (Type__c != null Or Type__c != '')
 order by name asc];
        } else {
            clasLst = [select Apttus_Config2__HierarchyId__c, Id, Type__c, Pearson_Course_Structure_Code__c, Name, Apttus_Config2__AncestorId__c from Apttus_Config2__ClassificationHierarchy__c where Apttus_Config2__AncestorId__c = : currParent And (Type__c != null Or Type__c != '')
 order by name asc];
        }
        system.debug('mapChild.clear()----->' + mapChild.size());
        system.debug('mapChildHasNext.clear()----->' + mapChildHasNext.size());
        system.debug('clasLst----->' + clasLst);
        if (!clasLst.isEmpty()) {
            hasChildLsit = [select Apttus_Config2__HierarchyId__c, Id, Name, Type__c, Pearson_Course_Structure_Code__c, Apttus_Config2__AncestorId__c from Apttus_Config2__ClassificationHierarchy__c where Apttus_Config2__AncestorId__c = : clasLst And (Type__c != null Or Type__c != '')
 order by name asc];
            for (Apttus_Config2__ClassificationHierarchy__c hasChildObj: hasChildLsit) {
                childId.add(hasChildObj.Apttus_Config2__AncestorId__c);
            }
        }
        if (!clasLst.isEmpty()) {
            for (Apttus_Config2__ClassificationHierarchy__c clasObj: clasLst) {
                if (isGrandParentChanged) {
                    if (mapChild.containsKey(clasObj.Apttus_Config2__HierarchyId__c)) {
                        List < Apttus_Config2__ClassificationHierarchy__c > tempLst = new List < Apttus_Config2__ClassificationHierarchy__c > ();
                        Set < Apttus_Config2__ClassificationHierarchy__c > avoidDuplicate = new Set < Apttus_Config2__ClassificationHierarchy__c > ();
                        avoidDuplicate.addall(mapChild.get(clasObj.Apttus_Config2__HierarchyId__c));
                        avoidDuplicate.add(clasObj);
                        tempLst.addall(avoidDuplicate);
                        tempLst.sort();
                        mapChild.put(clasObj.Apttus_Config2__HierarchyId__c, tempLst);
                    } else {
                        List < Apttus_Config2__ClassificationHierarchy__c > tempLst = new List < Apttus_Config2__ClassificationHierarchy__c > ();
                        tempLst.add(clasObj);
                        mapChild.put(clasObj.Apttus_Config2__HierarchyId__c, tempLst);
                    }
                } else {
                    if (mapChild.containsKey(clasObj.Apttus_Config2__AncestorId__c)) {
                        List < Apttus_Config2__ClassificationHierarchy__c > tempLst = new List < Apttus_Config2__ClassificationHierarchy__c > ();
                        Set < Apttus_Config2__ClassificationHierarchy__c > avoidDuplicate = new Set < Apttus_Config2__ClassificationHierarchy__c > ();
                        avoidDuplicate.addall(mapChild.get(clasObj.Apttus_Config2__AncestorId__c));
                        avoidDuplicate.add(clasObj);
                        tempLst.addall(avoidDuplicate);
                        tempLst.sort();
                        mapChild.put(clasObj.Apttus_Config2__AncestorId__c, tempLst);
                    } else {
                        List < Apttus_Config2__ClassificationHierarchy__c > tempLst = new List < Apttus_Config2__ClassificationHierarchy__c > ();
                        tempLst.add(clasObj);
                        mapChild.put(clasObj.Apttus_Config2__AncestorId__c, tempLst);
                    }
                }
                if (childId.contains(clasObj.id)) {
                    mapChildHasNext.put(clasObj.id, true);
                } else {
                    mapChildHasNext.put(clasObj.id, false);
                }
            }
        } else {
            List < Apttus_Config2__ClassificationHierarchy__c > tempLst = new List < Apttus_Config2__ClassificationHierarchy__c > ();
            mapChild.put(currParent, tempLst);
        }
        system.debug('mapChild----->' + mapChild);
        system.debug('mapChildHasNext----->' + mapChildHasNext);
    }
    public void addToOpptyFromPearsonChoice() {
            renderAddToOpptyPopUp = false;
            selectedWrapperProduct = new Set < Id > ();
            System.debug(personChoiceWrapperList);
            for (pearsonChoiceWrapperClass pearsonChoiceWrap: personChoiceWrapperList) {
                System.debug(pearsonChoiceWrap.selectedPearsonChoiceProduct);
                if (pearsonChoiceWrap.selectedPearsonChoiceProduct == true) {
                    System.debug(pearsonChoiceWrap.selectedPearsonChoiceProduct);
                    selectedWrapperProduct.add(pearsonChoiceWrap.pearsonChoiceRec);
                    selectedWrapperProduct.add(pearsonChoiceWrap.pearsonChoiceRec);
                    selectedWrapperProduct.add(pearsonChoiceWrap.pearsonChoiceRec);
                    selectedWrapperProduct.add(pearsonChoiceWrap.pearsonChoiceRec);
                }
            }
            addToOpptyPearsonChoice();
            System.debug(selectedWrapperProduct);
        }
        //Added By Pooja For ProductcatalogDetails.
    public List < Apttus_Config2__RelatedProduct__c > getCompetitiveDetails() {
            system.debug('Inside getCompetitiveDetails----**');
            listForeCompetitor = new List < Apttus_Config2__RelatedProduct__c > ();
            system.debug('Inside productFamilyIdFromURL----**' + productCatalogIdFromURL);
            if (productCatalogIdFromURL != null) {
                listForeCompetitor = [select Apttus_Config2__RelatedProductId__c, Apttus_Config2__RelatedProductId__r.Name, Apttus_Config2__RelatedProductId__r.Full_Author_and_Affiliation__c, Apttus_Config2__RelatedProductId__r.Author__c, Apttus_Config2__RelatedProductId__r.Publisher__c, Apttus_Config2__RelatedProductId__r.Edition__c, Apttus_Config2__RelatedProductId__r.Competitor_Edition_Status__c, Apttus_Config2__RelatedProductId__r.SBN__c, Apttus_Config2__RelatedProductId__r.ISBN__c, Apttus_Config2__RelatedProductId__r.Copyright_Year__c FROM Apttus_Config2__RelatedProduct__c WHERE Competitive__c = TRUE AND Apttus_Config2__ProductId__c = : productCatalogIdFromURL];
            }
            system.debug('Inside listForeCompetitor----**' + listForeCompetitor);
            system.debug('Inside listForeCompetitor----**' + CatalogRelatedProductId);
            Set < Id > rpID = new Set < ID > ();
            for (Apttus_Config2__RelatedProduct__c rd: listForeCompetitor) {
                system.debug('rd--->' + rd.Apttus_Config2__RelatedProductId__c);
                rpID.add(rd.Id);
            }
            system.debug('rpID--' + rpID);
            content2 = [select Content__c, Order__c, Related_Product__c, Sub_Type__c, Marketing_Copy_Type__c from Marketing_Information__c where Related_Product__c in : rpID And Type__c = 'Comparative Copy'
                AND Order__c != null AND Sub_Type__c != null order by Order__c Desc
            ];
            System.debug('inside on click expnad button content2---' + content2);
            if (content2 != null) {
                for (Marketing_Information__c m: content2) {
                    uniqueSubTypemap.put(m.Sub_Type__c, m);
                }
                SubList = uniqueSubTypemap.Values();
                System.debug('##$##$%' + uniqueSubTypemap);
                System.debug('##$##$%-----' + SubList);
            }
            for (Marketing_Information__c mi: SubList) {
                if (miMap.containsKey(mi.Related_Product__c)) {
                    List < Marketing_Information__c > markInfo = miMap.get(mi.Related_Product__c);
                    markInfo.add(mi);
                    miMap.put(mi.Related_Product__c, markInfo);
                }
                ELSE {
                    List < Marketing_Information__c > markInfo = new List < Marketing_Information__c > ();
                    markInfo.add(mi);
                    miMap.put(mi.Related_Product__c, markInfo);
                    keyString += mi.Related_Product__c + ',';
                    system.debug('keyString---' + keyString);
                }
            }
            system.debug('miMap---' + miMap);
            system.debug('keyString---??' + keyString);
            return listForeCompetitor;
        }
        //Added By Pooja For ProductcatalogDetails.
    public void showMarketPopup() {
        displayMarketInfoPopup = true;
    }
    public void showvalueinpopup() {
        dispVal = true;
        if (SubList.size() > 0) {
            for (Marketing_Information__c content: SubList) {
                System.debug('Content detailsssssssssss' + content.Content__c + ';' + content.Related_Product__c);
                if (content.Related_Product__c == CatalogRelatedProductId && content.Id == CatalogMarketId && content.Content__c != null && content.Sub_Type__c != null) {
                    value = content.Content__c;
                    subtype = content.Sub_Type__c;
                }
            }
        } else {
            System.debug('insideeee else show pop block');
            value = 'Product Does not Contain any Details.';
        }
    }
    public void closePearsonChoicePopUp() {
        renderAddToOpptyPopUp = false;
    }
    public pageReference redirectProduct() {
        
       //KPredirectToProductFamily();
        pageReference redirectProductToFamilyPage;
        pageReference redirectProductToProductPage;
        formsampleurl();
        List < Product2 > listWithRedirectProductInfo = new List < Product2 > ();
        System.debug('opportunityID in redirectProduct..' + opportunityID);
        if (opportunityID == null) {
            redirectProductToFamilyPage = new pageReference('/apex/OneCRMProductFamilyDetailPage?productFamilyId=' + redirectProductId);
            redirectProductToProductPage = new pageReference('/apex/ProductCatalogDetailPage?productId=' + redirectProductId);
        } else {
            //redirectProductToFamilyPage = new pageReference('/apex/OneCRMProductFamilyDetailPage?productFamilyId=' + redirectProductId + '&oppId=' + opportunityID);
            redirectProductToFamilyPage = new pageReference('/apex/Productcatalog4?productFamilyId=' + redirectProductId + '&oppId=' + opportunityID + 
            '&cartProdFromURL='+cartProdFromURL+'&samplecartcontents='+samplecarturl);
            //redirectProductToProductPage = new pageReference('/apex/ProductCatalogDetailPage?productId=' + redirectProductId + '&oppId=' + opportunityID);
            redirectProductToProductPage = new pageReference('/apex/Product4?productId=' + redirectProductId + '&oppId=' + opportunityID +
            '&cartProdFromURL='+cartProdFromURL+'&samplecartcontents='+samplecarturl);
        }
        system.debug(cartProdFromURL);
        String familyOrProductIdentifier;
        if (redirectProductId != null) {
            listWithRedirectProductInfo = [select id, Apttus_Config2__ConfigurationType__c from product2 where Id = : redirectProductId];
            if (listWithRedirectProductInfo != null && listWithRedirectProductInfo.size() > 0) {
                familyOrProductIdentifier = listWithRedirectProductInfo[0].Apttus_Config2__ConfigurationType__c;
            }
            if (familyOrProductIdentifier == 'Bundle') {
                redirectProductToFamilyPage.setRedirect(true);
                return redirectProductToFamilyPage;
            } else if (familyOrProductIdentifier == 'Option') {
                redirectProductToProductPage.setRedirect(true);
                return redirectProductToProductPage;
            }
        }
        return null;
    }
    public class pearsonChoiceWrapperClass {
        public boolean selectedPearsonChoiceProduct {
            get;
            set;
        }
        public String pearsonChoiceProductNameWrap {
            get;
            set;
        }
        public String pearsonChoiceProductAuthorWrap {
            get;
            set;
        }
        public String pearsonChoiceProductCopYearWrap {
            get;
            set;
        }
        public String pearsonChoiceProductEditionWrap {
            get;
            set;
        }
        public String pearsonChoiceProductIsbnWrap {
            get;
            set;
        }
        public Date pearsonChoiceProductInstockDateWrap {
            get;
            set;
        }
        public String pearsonChoiceProductStatusWrap {
            get;
            set;
        }
        public String pearsonChoiceProductSubBrandWrap {
            get;
            set;
        }
        public Id pearsonChoiceRec {
            get;
            set;
        }
        public pearsonChoiceWrapperClass(Id pearsonChoiceRecord, String pearsonChoiceProductName, String Author, String copYear, String edition, String isbn, Date InstockDate, String Status, String subBrand) {
            pearsonChoiceRec = pearsonChoiceRecord;
            pearsonChoiceProductNameWrap = pearsonChoiceProductName;
            pearsonChoiceProductAuthorWrap = Author;
            pearsonChoiceProductCopYearWrap = copYear;
            pearsonChoiceProductEditionWrap = edition;
            pearsonChoiceProductIsbnWrap = isbn;
            pearsonChoiceProductInstockDateWrap = InstockDate;
            pearsonChoiceProductStatusWrap = Status;
            pearsonChoiceProductSubBrandWrap = subBrand;
            selectedPearsonChoiceProduct = false;
        }
    }
    /***********************************************Rony*****************************************************************/
    //public variables
    /* Davi Borges: Changed Here
    public list < displayproductlineitem > Productfamilymembers {
        get;
        set;
    }*/

    //Propertie that holds all sample selected products
    public list < displayproductlineitem > productsToSample {
        get
        {
            emptyproduct = ! (productsToSample !=null && productsToSample.size() > 0);

            return productsToSample;  
        }
        set;
    }

    //Propertie that holds all sample selected products
    public list < selectedproductlineitem > selectedproductslist {
        get
        {
            samplecart = (selectedproductslist !=null && selectedproductslist.size() > 0);

            return selectedproductslist;           
        }
        set;
    }

    public list < Apttus_Config2__RelatedProduct__c > productfamily {
        get;
        set;
    }
    public list < Apttus_Config2__RelatedProduct__c > selectedproducts {
        get;
        set;
    }
    public ID removesampleID {
        get;
        set;
    }
    public set < id > productidlist {
        get;
        set;
    }
    public ID prodId {
        get;
        set{
            System.Debug('@@@prodId<--:' + value);
            prodId = value;
        }
    }

    //Davi Borges: This variable defines if the search is done in Produc tMode (True) or Familiy Mode (False)
    public Boolean productMode
    {
        get;
        set{
            System.Debug('@@@productMode<--:' + value);
            productMode = value;
        }
    }


    public boolean displayproduct {
        get;
        set;
    }
    public string sampletabfocus {
        get;
        set;
    }
    //to return the product family members
    private List<displayproductlineitem> getProductfamilymembers(Id familyId) 
    {
       
        List<displayproductlineitem> items = new List<displayproductlineitem>();

        productfamily = new list < Apttus_Config2__RelatedProduct__c > ();
            
        productfamily = [SELECT id, Apttus_Config2__RelatedProductId__r.name, Apttus_Config2__RelatedProductId__r.Author__c, Apttus_Config2__RelatedProductId__r.ISBN__c, Apttus_Config2__RelatedProductId__r.InstockDate__c, Apttus_Config2__RelatedProductId__r.Status__c, Apttus_Config2__RelatedProductId__r.IRC_Indicator__c, Apttus_Config2__RelatedProductId__r.Brand__c, Apttus_Config2__RelatedProductId__r.Sampling_Restriction__c, Apttus_Config2__RelatedProductId__r.Free_Copy_Substitute__r.ISBN__c, Apttus_Config2__RelatedProductId__r.Free_Copy_Substitute__r.name from Apttus_Config2__RelatedProduct__c where PSAM__c = true and Apttus_Config2__ProductId__r.id = : familyId];
            
        productfamilyids.add(familyId);
            
        for (Apttus_Config2__RelatedProduct__c temp: productfamily) {
            items.add(new displayproductlineitem(temp));
        }

        return items;
        
    }

    /*********************************
    /*public void getProduct() {
        if (checkifusercancreateorders()) {
            displayproduct = true;
            system.debug('$$$$$$$$$$$$insidefunction' + displayproduct);
            productfamily = new list < Apttus_Config2__RelatedProduct__c > ();
            Productfamilymembers = new list < displayproductlineitem > ();
            productfamily = [select id, Apttus_Config2__RelatedProductId__r.name, Apttus_Config2__RelatedProductId__r.Author__c, Apttus_Config2__RelatedProductId__r.ISBN__c, Apttus_Config2__RelatedProductId__r.InstockDate__c, Apttus_Config2__RelatedProductId__r.Status__c, Apttus_Config2__RelatedProductId__r.IRC_Indicator__c, Apttus_Config2__RelatedProductId__r.Brand__c, Apttus_Config2__RelatedProductId__r.Sampling_Restriction__c, Apttus_Config2__RelatedProductId__r.Free_Copy_Substitute__r.ISBN__c, Apttus_Config2__RelatedProductId__r.Free_Copy_Substitute__r.name from Apttus_Config2__RelatedProduct__c where Apttus_Config2__RelatedProductId__r.Id = : prodId limit 1];
            if (!productfamily.isEmpty()) {
                system.debug('productfamily ===>>>>' + productfamily);
            } else {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'No items in the cart'));
                samplecart = true;
                emptyproduct = true;
            }
            productfamilyids.add(prodId);
            system.debug('########3familymembers' + productfamily);
            for (Apttus_Config2__RelatedProduct__c temp: productfamily) {
                Productfamilymembers.add(new displayproductlineitem(temp));
            }
            if (!Productfamilymembers.isEmpty()) {
                system.debug('Productfamilymembers ===>>>>' + Productfamilymembers);
                samplecart = true;
            }
            system.debug('########3familymembers' + Productfamilymembers);
            //return Productfamilymembers;
        } else {
            system.debug('%%%%%%%%order' + sampleorderpermission);
            sampleorderpermission = true;
        }
    }*/

     public void formsampleurl()
    {      if(selectedproductslist != null) 
           {if(samplecarturl == null)
           {samplecarturl = '';}
           for(selectedproductlineitem temp:selectedproductslist)
                        {samplecarturl = samplecarturl+String.valueof(temp.product.id)+'%2C'+string.valueof(temp.squantity)+'%2C';}
           }  
           else if(samplecarturl == null)
           {samplecarturl = '';}                     
    }         

    /**
     * Description : This method create the display product for sampeling
     * @param None, but it uses class properties ProdId and ProductMode
     * @return None, but populates the productsToSample
     * @throws NA
     **/
    public void getListProductsToSample()
    {
        productsToSample = new List<displayproductlineitem>();
 
        if ( ! checkifusercancreateorders()) 
        {
            sampleorderpermission = true;  
            return ;
        }

        displayproduct = true;

        if(productMode)
        {
            productsToSample = getProductSample(prodId);
        }else
        {
            productsToSample = getProductfamilymembers(prodId);
        }


        if(productsToSample.size() == 0)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'No items in the cart'));
        }


    }

    /**
     * Description : This method create the display product for sampeling a specific product
     * @param None, but it uses class properties ProdId 
     * @return None, but populates the productsToSample
     * @throws NA
     **/
    private List<displayproductlineitem> getProductSample(Id Product)
    {

        List<displayproductlineitem> items = new List<displayproductlineitem>();

        List <Product2> products = [SELECT Id,Name, Author__c, ISBN__c, InstockDate__c, Status__c, IRC_Indicator__c, Brand__c, Sampling_Restriction__c, Free_Copy_Substitute__r.ISBN__c, Free_Copy_Substitute__r.name 
                            FROM Product2 
                            WHERE id = : prodId];
         
            for (Product2 prod :products) {
                items.add(new displayproductlineitem(prod));
            } 

        return items;   

    }





    public boolean checkifusercancreateorders() {
        set < id > usergroup = new set < id > ();
        opportunity opp = [select id, ownerid from opportunity where id = : opportunityID];
        usergroup.add(opp.ownerid);
        list < OpportunityTeamMember > otm = [select userid from OpportunityTeamMember where OpportunityId = : opp.id];
        for (OpportunityTeamMember otm1: otm) {
            usergroup.add(otm1.userid);
        }
        set < id > allbelowusers = new set < id > ();
        id userid = userinfo.getuserid();
        allbelowusers = getRoleSubordinateUsers(userid);
        id persetid = [SELECT Id from permissionset where Name = 'Pearson_Network_Sampler'].id;
        List < PermissionSetAssignment > assigneduser = [SELECT Id, PermissionSetId, AssigneeId FROM PermissionSetAssignment WHERE AssigneeId = : Userinfo.getUserId() and PermissionSetId = : persetid];
        id persetid1 = [SELECT Id from permissionset where Name = 'Pearson_Front_End_Sampling'].id;
        List < PermissionSetAssignment > assigneduser1 = [SELECT Id, PermissionSetId, AssigneeId FROM PermissionSetAssignment WHERE AssigneeId = : Userinfo.getUserId() and PermissionSetId = : persetid1];
        if (assigneduser1.size() > 0) {
            if (assigneduser.size() > 0) {
                return true;
            } else if (usergroup.contains(userid) || allbelowusers.contains(opp.ownerid)) {
                return true;
            } else {
                return false;
            }
        }
        return false;
    }





    public static Set < ID > getRoleSubordinateUsers(Id userId) {
        Id roleId = [select UserRoleId from User where Id = : userId].UserRoleId;
        Set < Id > allSubRoleIds = getAllSubRoleIds(new Set < ID > {
            roleId
        });
        Map < Id, User > users = new Map < Id, User > ([Select Id, Name From User where UserRoleId IN: allSubRoleIds]);
        return users.keySet();
    }
    private static Set < ID > getAllSubRoleIds(Set < ID > roleIds) {
        Set < ID > currentRoleIds = new Set < ID > ();
        for (UserRole userRole: [select Id from UserRole where ParentRoleId IN: roleIds AND ParentRoleID != null]) currentRoleIds.add(userRole.Id);
        if (currentRoleIds.size() > 0) {
            currentRoleIds.addAll(getAllSubRoleIds(currentRoleIds));
        }
        return currentRoleIds;
    }
    public void userselectedproducts() {
        if (selectedproductslist == null) {
            selectedproductslist = new list < selectedproductlineitem > ();
        }
        //Davi Borges: Cahnged Here
        for (displayproductlineitem temp: productsToSample) {
            if (temp.selected == true) {
                //Davi Borges Changed here
                selectedproductslist.add(new selectedproductlineitem(temp.product));
            }
        }
        system.debug('$$$$$$$$$$$selectedproduct' + selectedproductslist + opportunityID);
        sampletabfocus = 'Sample';
        displayproduct = false;
    }
    public void dsproduct() {
        system.debug('$$$$$$$$$$$$insidefunction' + displayproduct + emptyproduct);
        displayproduct = false;
        emptyproduct = false;
    }
    public void removeSampleCart() {
        System.debug('selectedproductslist size()....' + selectedproductslist.size());
        for (integer i = 0; i < selectedproductslist.size(); i++) {
            selectedproductlineitem sample = selectedproductslist[i];
            //Davi Borges: Changed Here
            if (sample.product.id == removesampleID) {
                selectedproductslist.remove(i);
            }
            if (selectedproductslist.isEmpty()) {
                system.debug('^^^^^^^^^^^^^^Insidefunctiondelat');
                samplecart = false;
            }
        }
    }
    public PageReference submitsampleorder() {
            if (selectedproductslist == null) {
                selectedproductslist = new list < selectedproductlineitem > ();
            }
            if (selectedproductslist.size() > 0) {
                list < OrderItem > samplelineitems = new list < OrderItem > ();
                OrderItem templineorder = new OrderItem();
                order sampleorder = new order();
                sampleorder.Opportunityid = opportunityID;
                sampleorder.Accountid = [select accountid from opportunity where id = : opportunityID].accountid;
                sampleorder.EffectiveDate = system.today();
                sampleorder.status = 'Cancelled';
                sampleorder.Pricebook2Id = [select id from Pricebook2 where name = 'Standard Price Book'].id;
                sampleorder.CurrencyIsoCode = userinfo.getDefaultCurrency();
                insert sampleorder;
                system.debug('$$$$$' + sampleorder);
                productidlist = new set < id > ();
                for (selectedproductlineitem temp: selectedproductslist) {
                    //Davi Borges: Canged Here
                    productidlist.add(temp.product.id);
                }
                List < PriceBookEntry > lstPrceBook = [SELECT Id, Product2Id, Product2.Id, CurrencyIsoCode, Product2.Name, UnitPrice FROM PriceBookEntry WHERE(Product2Id in : productidlist) AND PriceBook2.isStandard = true AND Product2.Publisher__c = 'Pearson'
                    and CurrencyIsoCode = : sampleorder.CurrencyIsoCode
                ];
                map < id, id > prcbkmap = new map < id, id > ();
                map < id, decimal > prcmap = new map < id, decimal > ();
                for (id prodid: productidlist) {
                    for (PriceBookEntry temp: lstPrceBook) {
                        if (temp.Product2Id == prodid) {
                            prcmap.put(prodid, temp.UnitPrice);
                        }
                    }
                }
                for (id prodid: productidlist) {
                    for (PriceBookEntry temp: lstPrceBook) {
                        if (temp.Product2Id == prodid) {
                            prcbkmap.put(prodid, temp.id);
                        }
                    }
                }
                for (selectedproductlineitem temp: selectedproductslist) {
                    Orderitem temp1 = new OrderItem();
                    temp1.orderid = sampleorder.id;
                    //Davi Borges: Changed Here
                    temp1.Shipped_Product__c = temp.product.id;
                    temp1.Quantity = temp.sQuantity;
                    //Davi Borges: Cahnged Here
                    temp1.pricebookentryid = prcbkmap.get(temp.product.id);
                    //Davi Borges: Cahnged Here
                    temp1.unitprice = prcmap.get(temp.product.id);
                    samplelineitems.add(temp1);
                }
                insert samplelineitems;
                PageReference redirectPage = new PageReference('/apex/Order_Header?orderid=' + sampleorder.id + '&&oppid=' + opportunityID);
                redirectPage.setRedirect(true);
                return redirectPage;
            } else {
                PageReference redirectPage = new PageReference('/' + opportunityID);
                redirectPage.setRedirect(true);
                return redirectPage;
            }
            return null;
        }
        //wrapper class to display and for the selction the productlineitem 
    public class displayproductlineitem {
        public boolean selected {
            get;
            set;
        }
        //public Apttus_Config2__RelatedProduct__c familymember {
        public Product2 product {
            get;
            set;
        }
        /*public list < Apttus_Config2__RelatedProduct__c > digitalproductfamily {
            get;
            set;
        }*/

        public String restriction {
            get;
            set;
        }

        public displayproductlineitem(Apttus_Config2__RelatedProduct__c temp) {       
            this(temp.Apttus_Config2__RelatedProductId__r);
        }

        public displayproductlineitem(Product2 disProduct)
        {
            selected = false;
            product = disProduct;
            restriction = disProduct.Sampling_Restriction__c ;
        }

    }
    public class selectedproductlineitem {
        public boolean selected {
            get;
            set;
        }
        public Product2 product {
            get;
            set;
        }
        public integer sQuantity {
            get;
            set;
        }
        public selectedproductlineitem(Apttus_Config2__RelatedProduct__c temp) {
            this(temp.Apttus_Config2__RelatedProductId__r);
        }

        public selectedproductlineitem(Product2 inproduct)
        {
            selected = true;
            this.product = inproduct;
            sQuantity = 1;
        }


    }
    //on click of NA  Product Catalogue Information button
    public pageReference getMarketingMaterialContent() {
            pageReference marketingcontentPage;
            if (null != opportunityID && null != productCatalogIdFromURL) {
                marketingcontentPage = new PageReference('/apex/PS_DisplayProductContent?opportunityId=' + opportunityID + '&productId=' + productCatalogIdFromURL);
            }
            return marketingcontentPage;
        }
        // on click of NA Download Instructor Resources
    public pageReference getContacts() {
            pageReference contactsPage;
            if (null != opportunityID && null != productCatalogIdFromURL) {
                contactsPage = new PageReference('/apex/PS_DisplayOppContacts?opportunityId=' + opportunityID + '&productId=' + productCatalogIdFromURL);
            }
            return contactsPage;
        }
        //on click of NA  Product family Information button
    public pageReference getMarketingMaterialContent1() {
            pageReference marketingcontentPage;
            if (null != opportunityID && null != productFamilyIdFromURL) {
                marketingcontentPage = new PageReference('/apex/PS_DisplayFamilyContent?opportunityId=' + opportunityID + '&productFamilyId=' + productFamilyIdFromURL);
            }
            return marketingcontentPage;
        }
        // on click of NA Download Instructor Resources
    public pageReference getContacts1() {
            pageReference contactsPage;
            if (null != opportunityID && null != productFamilyIdFromURL) {
                contactsPage = new PageReference('/apex/PS_DisplayOppContacts?opportunityId=' + opportunityID + '&productFamilyId=' + productFamilyIdFromURL);
            }
            return contactsPage;
        }
        //Set current parent when user clicks on taxonomy  
    public pageReference setCurrParentInClass() {
        return null;
    }
    public pageReference redirectToProductFamily() {
        Set < ID > prodIds = new Set < Id > ();
        List < Opportunitylineitem > existingoppitems = new List < Opportunitylineitem > ();
        if (opportunityID != null) {
            for (Opportunitylineitem existingopp: [select PricebookEntry.Product2.Name, Product2.name, Quantity, SRP__c, Unitprice from OpportunityLineItem where Opportunity.id = : opportunityID]) {
                existingoppitems.add(existingopp);
            }
        }
        try {
            if (!existingoppitems.isEmpty()) {
                delete existingoppitems;
            }
            for (productFamilyClass prodID: listOfproductFamilyClass) {
                if (prodID.relatedProd != null) {
                    prodIds.add(prodID.relatedProd.apttus_config2__relatedproductid__c);
                } else if (prodID.relatedProd1 != null) {
                    prodIds.add(prodID.relatedProd1.PricebookEntry.Product2Id);
                } else if (prodID.oppProd != null) {
                    prodIds.add(prodID.oppProd.Apttus_Config2__ProductId__r.id);
                }
            }
            System.debug(prodIds);
            Map < Id, Id > prodToPbe = new Map < Id, Id > ();
            List < PricebookEntry > pbeList = [SELECT Id, Product2Id FROM PricebookEntry WHERE Product2Id IN: prodIds AND PriceBook2.isStandard = true AND isActive = true AND CurrencyISOCode =: oppCurrency limit 1];
            for (PricebookEntry pbEntry: pbeList) {
                prodToPbe.put(pbEntry.Product2Id, pbEntry.Id);
            }
            System.debug(pbeList);
            if (!listOfproductFamilyClass.isEmpty()) {
                existingoppitems.clear();
                Set < ID > dummySet = new Set < ID > ();
                Set < ID > dummySet1 = new Set < ID > ();
                setListPriceToList(prodIds, dummySet, dummySet1);
                System.debug(mapIDWithNetprice);
                for (productFamilyClass prodClass: listOfproductFamilyClass) {
                    OpportunitylineItem opLineItem = new OpportunitylineItem();
                    Id ProductId;
                    Id FamilyId;
                    if (prodClass.relatedProd != null) {
                        ProductId = prodClass.relatedProd.apttus_config2__relatedproductid__c;
                    } else if (prodClass.relatedProd1 != null) {
                        ProductId = prodClass.relatedProd1.PricebookEntry.Product2Id;
                    } else if (prodClass.oppProd != null) {
                        ProductId = prodClass.oppProd.Apttus_Config2__ProductId__r.id;
                    }
                    if (prodClass.relatedProd.Apttus_Config2__ProductId__c != null) {
                        FamilyId = prodClass.relatedProd.Apttus_Config2__ProductId__c;
                    } else if (prodClass.relatedProd1.Product_Family_HE__c != null) {
                        FamilyId = prodClass.relatedProd1.Product_Family_HE__c;
                    } else if (familyTagId != null) {
                        FamilyId = familyTagId;
                    }
                    if (ProductId != null) {
                        opLineItem.OpportunityId = opportunityID;
                        opLineItem.PricebookEntryId = prodToPbe.get(ProductId);
                        opLineItem.quantity = prodClass.sQuantity;
                        opLineItem.Unitprice = mapIDWithNetprice.get(ProductId) != null ? mapIDWithNetprice.get(ProductId) : 0.00;
                        opLineItem.SRP__c = mapIDWithListprice.get(ProductId) != null ? mapIDWithListprice.get(ProductId) : 0.00;
                        opLineItem.Product_Family_HE__c = FamilyId;
                        existingoppitems.add(opLineItem);
                    }
                }
            }
            if (!existingoppitems.isEmpty()) insert existingoppitems;
        } catch (Exception e) {
            System.debug(e);
        }
        return null;
    }
    public class pearsonChoiceWrapperClass1 {
        public boolean selectedPearsonChoiceProduct {
            get;
            set;
        }
        public String pearsonChoiceProductNameWrap {
            get;
            set;
        }
        public String pearsonChoiceProductAuthorWrap {
            get;
            set;
        }
        public String pearsonChoiceProductCopYearWrap {
            get;
            set;
        }
        public String pearsonChoiceProductEditionWrap {
            get;
            set;
        }
        public String pearsonChoiceProductIsbnWrap {
            get;
            set;
        }
        public Date pearsonChoiceProductInstockDateWrap {
            get;
            set;
        }
        public String pearsonChoiceProductStatusWrap {
            get;
            set;
        }
        public String pearsonChoiceProductSubBrandWrap {
            get;
            set;
        }
        public Id pearsonChoiceRec {
            get;
            set;
        }
        public pearsonChoiceWrapperClass1(Id pearsonChoiceRecord, String pearsonChoiceProductName, String Author, String copYear, String edition, String isbn, Date InstockDate, String Status, String subBrand) {
            pearsonChoiceRec = pearsonChoiceRecord;
            pearsonChoiceProductNameWrap = pearsonChoiceProductName;
            pearsonChoiceProductAuthorWrap = Author;
            pearsonChoiceProductCopYearWrap = copYear;
            pearsonChoiceProductEditionWrap = edition;
            pearsonChoiceProductIsbnWrap = isbn;
            pearsonChoiceProductInstockDateWrap = InstockDate;
            pearsonChoiceProductStatusWrap = Status;
            pearsonChoiceProductSubBrandWrap = subBrand;
            selectedPearsonChoiceProduct = false;
        }
    }
    //Redirect to opportunity
    public pageReference cancel() {
        pageReference productPage;
        productPage = new pageReference('/apex/OneCRMProductFamilyDetailPage?productFamilyId=' + productFamilyIdFromURL + '&oppId=' + opportunityID);
        productPage.setRedirect(true);
        return productPage;
    }
    public pageReference returntoopportunity() {
        PageReference redirectPage = new PageReference('/' + opportunityID);
        redirectPage.setRedirect(true);
        return redirectPage;
    }
    public class AboutThisProduct {
        public Integer order {
            get;
            set;
        }
        public String sub_type {
            get;
            set;
        }
        public String id {
            get;
            set;
        }
        public AboutThisProduct(AggregateResult ar) {
            sub_type = (String) ar.get('sub_type__c');
        }
    }
    public class AboutThisProductForProduct {
        public Integer order {
            get;
            set;
        }
        public String sub_type {
            get;
            set;
        }
        public String id {
            get;
            set;
        }
        public AboutThisProductForProduct(AggregateResult ar) {
            sub_type = (String) ar.get('sub_type__c');
        }
    }
    public class RepTools {
        public Integer order_rep {
            get;
            set;
        }
        public String sub_type_rep {
            get;
            set;
        }
        public String content {
            get;
            set;
        }
        public RepTools(AggregateResult ar) {
            sub_type_rep = (String) ar.get('sub_type__c');
        }
    }
    public pageReference returntoProductSelectorWizardV2() {
            
            //redirectToProductFamily();
            PageReference redirectPage;
            formsampleurl();
            if (null != pearsonCodeId) {
                system.debug('// returntoProductSelwctor //' + pearsonCodeId);
                redirectPage = new PageReference('/apex/oneCRMProductSelectorWizardV2?oppId=' + opportunityID + '&pearsonCodeIdFromProdFamily=' + pearsonCodeId);
            } else {
                if (opportunityID != null){ //redirectPage = new PageReference('/apex/oneCRMProductSelectorWizardV2?oppId=' + opportunityID);
                    redirectPage = new PageReference('/apex/oneCRMProductSelectorWizardV4?oppId=' + opportunityID+'&cartProdFromURL='+cartProdFromURL+'&backtorelatedlist1=true'+'&samplecartcontents='+samplecarturl);
                }
                else redirectPage = new PageReference('/apex/oneCRMProductSelectorWizardV2');
            }
            System.debug(cartProdFromURL);
            redirectPage.setRedirect(true);
            return redirectPage;
        }
        //Added by amit
    public PageReference getPearsonChoices() {
        if (listWithStudentResource != null && !listWithStudentResource.isEmpty()) {
            listWithStudentResource.clear();
        }
        if (listWithInstructorResource != null && !listWithInstructorResource.isEmpty()) {
            listWithInstructorResource.clear();
        }
        if (famMap != null && !famMap.isEmpty()) {
            famMap.clear();
        }
        if (packageDetails != null && !packageDetails.isEmpty()) {
            packageDetails.clear();
        }   
        pearsonChoiceWrapList = new List < pearsonChoiceToSendEmail > ();
        mapWithPearsonChoice = new Map < Id, Pearson_Choice__c > ();
        listWithPearsonChoices = new List < Pearson_Choice__c > ();
        if (productFamilyIdFromURL != null) {
            listWithPearsonChoices = [select Id, Access_Length__c, Bookstore__c, Bookstore__r.Name, Bookstore__r.Author__c, Bookstore__r.Copyright_Year__c, Bookstore__r.Edition__c, Bookstore__r.ISBN__c, Bookstore__r.InstockDate__c, Bookstore__r.Status__c, Bookstore__r.Sub_Brand__c, Bookstore_ISBN_s__c, Bookstore_Price__c, Brand__c, eText_Offer__c, eText_Offer_Price__c, Includes_Pearon_eText__c, Instant_Access__r.Name, Instant_Access__r.Author__c, Instant_Access__r.Copyright_Year__c, Instant_Access__r.Edition__c, Instant_Access__r.ISBN__c, Instant_Access__r.InstockDate__c, Instant_Access__r.Status__c, Instant_Access__r.Sub_Brand__c, Instant_Access__c, Instant_Access_Price__c, Master_Product__c, Offer_Type__c, Platform__c, Print_Offer__c, Print_Offer__r.Name, Print_Offer__r.Author__c, Print_Offer__r.Copyright_Year__c, Print_Offer__r.Edition__c, Print_Offer__r.ISBN__c, Print_Offer__r.InstockDate__c, Print_Offer__r.Status__c, Print_Offer__r.Sub_Brand__c, Print_Offer_Price__c, eText_Offer__r.Name, eText_Offer__r.Author__c, eText_Offer__r.Copyright_Year__c, eText_Offer__r.Edition__c, eText_Offer__r.ISBN__c, eText_Offer__r.InstockDate__c, eText_Offer__r.Status__c, eText_Offer__r.Sub_Brand__c, Product_Family__c, Sequence__c from Pearson_Choice__c where Product_Family__c = : productFamilyIdFromURL Order By Sequence__c, Bookstore_Price__c, Instant_Access_Price__c ASC NULLS LAST limit 1000];
            if (listWithPearsonChoices != null) {
                pearsonChoiceToSendEmail pcObj;
                for (Pearson_Choice__c pearsonCho: listWithPearsonChoices) {
                    pcObj = new pearsonChoiceToSendEmail(pearsonCho);
                    mapWithPearsonChoice.put(pearsonCho.Id, pearsonCho);
                    pearsonChoiceWrapList.add(pcObj);
                }
            }
        }
        return null;
    }
    String listId;
    //Wrapper to get selected pearson
    public class pearsonChoiceToSendEmail {
        public boolean isPearsonChoiceSelected {
            get;
            set;
        }
        public Pearson_Choice__c pearsonChoiceObj {
            get;
            set;
        }
        public pearsonChoiceToSendEmail(Pearson_Choice__c pc) {
            this.pearsonChoiceObj = pc;
        }
    }
    //Add the selected contacts to a list and return to next page
    public pageReference addContactToList() {
        System.debug('pearsonChoiceWrapList----' + pearsonChoiceWrapList);
        ListId = '';
        for (pearsonChoiceToSendEmail p: pearsonChoiceWrapList) {
            if (p.isPearsonChoiceSelected) {
                if (listId != '') listId = listId + ',' + p.pearsonChoiceObj.Id;
                else {
                    listId = p.pearsonChoiceObj.Id;
                }
            }
        }
        System.debug('listId----' + ListId);
        //pageReference nextPage = page.Pearson_Choice_eCatalog;
        PageReference nextPage = new PageReference('/apex/Pearson_Choice_eCatalog?myproductId=' + listId);
        nextPage.setRedirect(false);
        return nextPage;
    }
    public PageReference ActionOK() {
        String priceList;
        Map < String, Boolean > selectedPricemap = new Map < String, Boolean > ();
        if (booleanBookstoreprice) {
            if (priceList == null) priceList = 'Bookstore_Price__c';
            else priceList = priceList + ',' + 'Bookstore_Price__c';
        }
        if (booleanSelectedOffer) {
            if (priceList == null) priceList = 'Suggested Retail Price ';
            else priceList = priceList + ',' + 'Suggested Retail Price';
        }
        if (booleanInstantAccessPrice) {
            if (priceList == null) priceList = 'Instant_Access_Price__c';
            else priceList = priceList + ',' + 'Instant_Access_Price__c';
        }
        if (booleaneTextOfferPrice) {
            if (priceList == null) priceList = 'eText_Offer_Price__c';
            else priceList = priceList + ',' + 'eText_Offer_Price__c';
        }
        if (booleanPrintOfferPricec) {
            if (priceList == null) priceList = 'Print_Offer_Price__c';
            else priceList = priceList + ',' + 'Print_Offer_Price__c';
        }
        PageReference nextPage = new PageReference('/apex/PS_SendEmail_Contacts?opportunityId=' + opportunityID + '&productId=' + productFamilyIdFromURL + '&pc=' + listId + '&col=' + priceList);
        nextPage.setRedirect(true);
        return nextPage;
    }
    public Integer searchResults1() {
        if (sQuery != null) {
            system.debug('sQuery===>>>>' + sQuery);
            String sQuery2;
            List < String > sQueryTemp = sQuery.split('limit');
            system.debug('sQueryTemp===>>>>' + sQueryTemp[0]);
            sQuery2 = sQueryTemp[0];
            sQuery2 += ' limit 1000';
            productsToDisplay1 = Database.query(sQuery2);
            productsToDisplay1count1 = productsToDisplay1.size();
            productsToDisplay1.clear();
        }
        return productsToDisplay1count1;
    }
    public Integer getSearchTotalPages() {
        System.debug('pearsonCodeId getSearchTotalPages' + pearsonCodeId);
        if (math.mod(CountTotalRecords1, QueryLimit) > 0) {
            totalPages1 = CountTotalRecords1 / QueryLimit + 1;
            System.debug(' inside if totalPages1 ===>' + totalPages1);
            return totalPages1;
        } else {
            totalPages1 = (CountTotalRecords1 / QueryLimit);
            System.debug('totalPages1 ===>' + totalPages1);
            return totalPages1;
        }
    }
    public Integer getSearchPearsonClickTotalPages() {
        if (pearsonCodeId != null || currParent != null) {
            if (math.mod(listWithProdFamilyCount, QueryLimit) > 0) {
                totalPages1 = listWithProdFamilyCount / QueryLimit + 1;
                System.debug(' inside if pearsonCodeId totalPages1 ===>' + totalPages1);
                return totalPages1;
            } else {
                totalPages1 = (listWithProdFamilyCount / QueryLimit);
                System.debug('totalPages1 pearsonCodeId ===>' + totalPages1);
                return totalPages1;
            }
        }
        return totalPages1;
    }
    public Integer getSearchFilterResTotalPages() {
        if (math.mod(productsToDisplay1count3, QueryLimit) > 0) {
            totalPages2 = productsToDisplay1count3 / QueryLimit + 1;
            System.debug(' inside if getSearchFilterResTotalPages totalPages2 ===>' + totalPages2);
            return totalPages2;
        } else {
            totalPages2 = (productsToDisplay1count3 / QueryLimit);
            System.debug('totalPages2 pearsonCodeId ===>' + totalPages2);
            return totalPages2;
        }
        return totalPages2;
    }
    public Integer getSearchPageNumber() {
        System.debug('OffsetSize/QueryLimit' + OffsetSize / QueryLimit);
        pageNumber1 = OffsetSize / QueryLimit + 1;
        System.debug('pageNumber1 ===>' + pageNumber1);
        return pageNumber1;
    }
    public Integer getSearchPageNumberSearchClick() {
        System.debug('OffsetSize/QueryLimit' + OffsetSize / QueryLimit);
        if (selectedSearchType == 'Product Family') {
            pageNumber2 = offSetFamily / QueryLimit + 1;
        } else {
            pageNumber2 = OffsetSize / QueryLimit + 1;
        }
        System.debug('pageNumber2 ===>' + pageNumber2);
        return pageNumber2;
    }
    public PageReference NextSearch() {
            if (selectedSearchType == 'Product Family') {
                offsetSearchFlag = true;
                offSetFamily += QueryLimit;
            } else {
                OffsetSize += QueryLimit;
                offsetSearchFlag = true;
            }
            searchResults(); //swati
            getPrice();
            getSearchPageNumberSearchClick();
            getSearchTotalPages();
            System.debug('inside Search next....' + OffsetSize + ':' + QueryLimit);
            return null;
        }
        /**
         * Description : Returns product families 
         * @param String
         * @return String
         * @throws NA
         **/
    public PageReference PreviousSearch() {
        if (selectedSearchType == 'Product Family') {
            offsetSearchFlag = true;
            offSetFamily -= QueryLimit;
        } else {
            OffsetSize -= QueryLimit;
            offsetSearchFlag = true;
        }
        searchResults(); //swati
        getPrice();
        getSearchPageNumberSearchClick();
        getSearchTotalPages();
        System.debug('inside Search previous....' + OffsetSize + ':' + QueryLimit);
        return null;
    }
    public PageReference NextSearchPearsonClick() {
            offsetFlag = true;
            if (fromTaxanomy) {
                offsetTaxonomyFlag = true;
            }
            OffsetSize += QueryLimit;
            productFamily();
            getPrice();
            getSearchPageNumber();
            getSearchPearsonClickTotalPages();
            System.debug('inside Search next....' + OffsetSize + ':' + QueryLimit);
            return null;
        }
        /**
         * Description : Returns product families 
         * @param String
         * @return String
         * @throws NA
         **/
    public PageReference PreviousSearchPearsonClick() {
        offsetFlag = true;
        if (fromTaxanomy) {
            offsetTaxonomyFlag = true;
        }
        OffsetSize -= QueryLimit;
        productFamily();
        getPrice();
        getSearchPageNumber();
        getSearchPearsonClickTotalPages();
        System.debug('inside Search previous....' + OffsetSize + ':' + QueryLimit);
        return null;
    }
    Public Integer PearsonCodeClick() {
        system.debug('pearsonCodeId**** currParent ' + pearsonCodeId + '--' + currParent);
        if (pearsonCodeId != null || currParent != null) {
            listWithProdFamily1 = new List < Apttus_Config2__ProductClassification__c > ();
            listWithProdFamily1 = [select Apttus_Config2__ProductId__r.Id,
                Apttus_Config2__ProductId__r.Name,
                Apttus_Config2__ProductId__r.Author__c,
                Apttus_Config2__ProductId__r.Copyright_Year__c,
                Apttus_Config2__ProductId__r.Status__c,
                Apttus_Config2__ProductId__r.InstockDate__c,
                Apttus_Config2__ProductId__r.Priority__c,
                Apttus_Config2__ProductId__r.Sub_Brand__c,
                Apttus_Config2__ProductId__r.Platform__c,
                Apttus_Config2__ProductId__r.Relevance__c,
                Apttus_Config2__ProductId__r.Relevance_Value__c,
                Apttus_Config2__ProductId__r.Edition__c
                from Apttus_Config2__ProductClassification__c where(Apttus_Config2__ClassificationId__c = : pearsonCodeId OR Apttus_Config2__ClassificationId__c = : currParent) AND Apttus_Config2__ProductId__r.Apttus_Config2__ConfigurationType__c = 'Bundle'
                AND(Apttus_Config2__ProductId__r.Relevance_Value__c = 10 OR Apttus_Config2__ProductId__r.Relevance_Value__c = 30 OR Apttus_Config2__ProductId__r.Relevance_Value__c = 90 OR Apttus_Config2__ProductId__r.Relevance_Value__c = 95 OR Apttus_Config2__ProductId__r.Relevance_Value__c = 100) order by Apttus_Config2__ProductId__r.Relevance_Value__c, Apttus_Config2__ProductId__r.Name Asc Nulls Last
            ];
        }
        listWithProdFamilyCount = 0;
        listWithProdFamilyCount = listWithProdFamily1.size();
        system.debug('listWithProdFamilyCount****' + listWithProdFamilyCount);
        return listWithProdFamilyCount;
    }
    public Integer searchFilterResults1(String sQuery) {
        System.debug(sQuery);
        if (sQuery != null) {
            system.debug('sQuery===>>>>' + sQuery);
            String sQuery2;
            List < String > sQueryTemp = sQuery.split('limit');
            system.debug('sQueryTemp===>>>>' + sQueryTemp[0]);
            sQuery2 = sQueryTemp[0];
            sQuery2 += ' limit 1000';
            searchFilterResultsPage = Database.query(sQuery2);
            productsToDisplay1count2 = searchFilterResultsPage.size();
            System.debug('productsToDisplay1count2...' + productsToDisplay1count2);
        }
        return productsToDisplay1count2;
    }
    public PageReference NextFilterSearch() {
            OffsetSize += QueryLimit;
            searchoffsetFlag = true;
            searchProductFamilyFilter(); //swati
            getPrice();
            getSearchPageNumber();
            getSearchFilterResTotalPages();
            System.debug('inside SearchFilter next....' + OffsetSize + ':' + QueryLimit);
            return null;
        }
        /**
         * Description : Returns product families 
         * @param String
         * @return String
         * @throws NA
         **/
    public PageReference PreviousFilterSearch() {
            OffsetSize -= QueryLimit;
            searchoffsetFlag = true;
            searchProductFamilyFilter(); //swati
            getPrice();
            getSearchPageNumber();
            getSearchFilterResTotalPages();
            System.debug('inside SearchFilter previous....' + OffsetSize + ':' + QueryLimit);
            return null;
        }
        //End
        
    public void setQuantity()
    {
        System.debug('Condition to check with Product Quantity is set:'+ indexOfListToSetQty);
        System.debug(valueOfQty);
        listOfproductFamilyClass[indexOfListToSetQty].sQuantity = valueOfQty;
        System.debug(listOfproductFamilyClass);
        InitCartandURL();
    } 
    
    public pageReference checkPermission() 
    {
    opptyIdForPermissionCheck  = ApexPages.currentPage().getParameters().get('oppId');
    if(ApexPages.currentPage().getParameters().get('productfamilyid') != null)
    {
        opptyProdId  = ApexPages.currentPage().getParameters().get('productfamilyid');
    }    
    errorString = '';
    ID slgUserId = UserInfo.getUserId(); 
    User slgUser = new User();
    UserRecordAccess oppEditAccess = new UserRecordAccess();
    String spstatus = Label.PS_SpecialPriceStatus;
    List<Special_Price_Request__c> specialPriceRequest = new List<Special_Price_Request__c>();
    slgUser=[select id,price_list__c from User where id =: slgUserId]; 
    System.debug(slgUser.price_list__c);
    if (slgUser.price_list__c == '' || slgUser.price_list__c == null)
    { 
        System.debug(slgUser.price_list__c);
        errorString = 'User is not associated with Price List. Please check with System Administrator.';
    }//end of price list check
    else
    { 
        //To check whether user has edit access to the opportunity
        if(slgUserId != null && opptyIdForPermissionCheck != null)
        {
        oppEditAccess =[Select RecordId, HasEditAccess FROM UserRecordAccess WHERE UserId =: slgUserId And RecordId =: opptyIdForPermissionCheck]; 
        if(oppEditAccess.HasEditAccess == true)
            {
                //to check whether is there any special price request processing for the opportunity
                specialPriceRequest = [Select Id,Status__c from Special_Price_Request__c where Opportunity__c =: opptyIdForPermissionCheck And Status__c != 'Completed' And Status__c != 'Rejected' And Status__c != 'Recalled'];
                SYstem.debug(opptyIdForPermissionCheck);
                if (specialPriceRequest.size() > 0)
                    {
                        errorString = 'A Special Price Request is pending for this Opportunity. Products cannot be edited until the request is completed.';
                    }
                    else
                    {
                        errorString = 'redirectUser';  
                    }
            }//end of conditional check for user access and special price request
           
        else
        {
            errorString = 'You do not have the level of access necessary to perform the operation you requested. Please contact the owner of the record or your administrator if access is necessary.';
        }
        }
     }   
    return null; 
    }
    public void setSearchText()
    {
    }
    public pageReference redirectPearsonChoice()
    {
        List<Pearson_Choice__c> listOfPearsonChoiceForRedirection = new List<Pearson_Choice__c>();
        Id redirectPearsonChoiceProductId;
        System.debug(indexForPearsonChoiceRedirection);
        if(!listWithPearsonChoices.isEmpty() && indexForPearsonChoiceRedirection != null)
        listOfPearsonChoiceForRedirection.add(listWithPearsonChoices[indexForPearsonChoiceRedirection]);
        if(!listOfPearsonChoiceForRedirection.isEmpty())
        {
            if(listOfPearsonChoiceForRedirection[0].Bookstore_Price__c != null)
            {
                redirectPearsonChoiceProductId = listOfPearsonChoiceForRedirection[0].Bookstore__c;
            }else if(listOfPearsonChoiceForRedirection[0].Instant_Access_Price__c != null)
            {
                redirectPearsonChoiceProductId = listOfPearsonChoiceForRedirection[0].Instant_Access__c;
            }else if(listOfPearsonChoiceForRedirection[0].eText_Offer_Price__c != null)
            {
                redirectPearsonChoiceProductId = listOfPearsonChoiceForRedirection[0].eText_Offer__c;
            }else if(listOfPearsonChoiceForRedirection[0].Print_Offer_Price__c != null)
            {
                redirectPearsonChoiceProductId = listOfPearsonChoiceForRedirection[0].Print_Offer__c;
            }
            
        }
        redirectProductId = redirectPearsonChoiceProductId;
        redirectProduct();
        return null;
    }
    
}