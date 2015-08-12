@isTest(seeAllData=True)
public  class PS_BatchPearsonChoiceCreation_Test
{

    static testMethod void  myUnitTest() {     
        List<User> listWithUser = new List<User>();
        listWithUser  = TestDataFactory.createUser([select Id from Profile where Name =: 'System Administrator'].Id,1);
        Product2 prd = new Product2();
        List<Product2> prdList = new List<Product2>();
   
        prdList = TestDataFactory.createProduct(1);
        prd =  TestDataFactory.insertRelatedProducts();
        SYSTEM.debug('@@@/// PRD'+prd.Id); 
        
        List<Product2> plist=[select id,name,(select id,name from Apttus_Config2__RelatedProducts__r) from product2 where Market__c='US' and Apttus_Config2__ConfigurationType__c ='Bundle' and
                             Line_of_Business__c = 'Higher Ed' and Business_Unit__c='US Field Sales' and Relevance_value__c>=10 and 
                             relevance_value__c<=100 and Market__c='US' and id=:prd.Id];
        system.assert(plist.size()>0);
        system.debug('Relate Product size:'+plist[0].Apttus_Config2__RelatedProducts__r.size());
        System.runAs(listWithUser[0]){
        Test.startTest(); 

     
        
        PS_BatchPearsonChoiceCreation batchObject = new PS_BatchPearsonChoiceCreation('US','US Field Sales','US HE All',prd.Id); 
        //batchObject.PearsonChoiceCreation(); 
        //batchObject.InitProcessMaps(prdList);  
        database.executeBatch(batchObject);
        Test.stopTest();
        }
    }
}