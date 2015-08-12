/**
 * Name : BulkPIUEditControllerTest 
 * Author : Accenture
 * Description : Test class used for testing the BulkPIUEditController
 * Date : 7/01/15 
 * Version : <intial Draft> 
 */


@isTest
public class BulkPIUEditControllerTest
{

    static testMethod void testUpdateContactList(){
    test.startTest();
    
    List<User> listWithUser = new List<User>();
    listWithUser  = TestDataFactory.createUser([select Id from Profile where Name =: 'System Administrator'].Id,1);
    if(listWithUser != null && !listWithUser.isEmpty())
    {
        listWithUser[0].Market__c = 'US';
        listWithUser[0].Price_List__c = 'Math & Science';
        listWithUser[0].Business_Unit__c = 'US Field Sales';
        insert listWithUser;
    }
    
    Boolean selected=false;
    
    List<Account> accountList =new List<Account>();
    List<AssetWrapper> asw= new List<AssetWrapper>();
    
    accountList=TestDataFactory.createAccount(1,'Direct SPH Inter-Division');
    insert accountList ;
    List<Contact> contactList=TestDataFactory.createContact(1);
    insert contactList;
    UniversityCourse__c course=new UniversityCourse__c(Name='T0001-kyama',Catalog_Code__c='T0001',Course_Name__c='kyama',Account__c= accountList[0].Id);
    insert course;
    system.runAs(listWithUser[0]){
    Product2 prod=new Product2 (Name='testProd',Market__c='US',Business_Unit__c='US Field Sales',Line_of_Business__c='Higher Ed');
    insert prod;
    
    Asset ass = new Asset(Product2id=prod.id,status__c='Active',Name='kyama',Product_Author__c='Kyama',AccountId= accountList[0].Id,ContactId=contactList[0].id,Course__c=course.id);
    insert ass;
    
    Asset ass1 = new Asset(Product2id=prod.id,primary__c = true,status__c='Active',Name='kyama',Product_Author__c='Kyama',AccountId= accountList[0].Id,ContactId=contactList[0].id,Course__c=course.id);
    insert ass1;
    
    BulkPIUEditController.AssetsWrapper wp = new BulkPIUEditController.AssetsWrapper(ass,true);
    
    system.assert(ass.Product_Author__c!=null);
    
   } 
    
    test.stopTest();
    PageReference pageRef = Page.BulkContactPIUEditPage;
    Test.setCurrentPage(pageRef);
    ApexPages.currentPage().getParameters().put('courseId', course.Id);
    BulkPIUEditController testBulk = new BulkPIUEditController();
    testBulk.schangedcId = contactList[0].Id;
    testBulk.schangedflg = false;
    testBulk.getPIUContacts();
     List<BulkPIUEditController.AssetsWrapper> s = new  List<BulkPIUEditController.AssetsWrapper>();
    testBulk.assetList = s; 
    testBulk.getAsset();
    testBulk.getProductIdWithName();
    testBulk.getAssetSelected();
    testBulk.updateContactList();
    testBulk.courseCancelDetailPage();
    //system.assert(testBulk.editAll());
    testBulk.selectedAssets.clear();
    testBulk.getSelectedAssets();
    
    

}
 }