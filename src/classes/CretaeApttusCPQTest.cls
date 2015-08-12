/*******************************************************************************************************************
* Apex Class Name  : CretaeApttusCPQTestClass
* Version          : 1.0 
* Created Date     : 30 March 2015
* Function         : Test Class of the CretaeApttusCPQ Class
* Modification Log :
*
* Developer                                Date                    Description
* ------------------------------------------------------------------------------------------------------------------
*   Accenture IDC                          31/03/2015              Created Initial Version
*******************************************************************************************************************/

@isTest(SeeAllData = True)

public class CretaeApttusCPQTest{
 static testMethod void myTest() { 
     Quote_Settings__c qsvalue = Quote_Settings__c.getValues(Utils_allfields.customSettingName);
     List<Product2> prodSOList = new List<Product2>();
     List<Product2> prodOptionList = new List<Product2>();
     
     Account acc = new Account(Name = 'AccTest1',Line_of_Business__c='Schools',CurrencyIsoCode='GBP',Geography__c = 'Growth',Organisation_Type__c = 'Higher Education',Type = 'School');
     acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Higher Education').getRecordTypeId();
     insert acc;
     
     User u = [select Id, firstname from user where id=:userinfo.getuserid()];
     
     Opportunity op = new Opportunity(Name= 'OpTest1', AccountId = acc.id, StageName = 'Solutioning', Type = 'New Business', Academic_Vetting_Status__c = 'Un-Vetted', Academic_Start_Date__c = System.Today(),CloseDate = System.Today(),International_Student__c = true, Qualification__c = 'Test Bundle', Campus__c ='Durbanville', Level__c=1);
     insert op;
     

    Apttus_Proposal__Proposal__c prop = new Apttus_Proposal__Proposal__c(Apttus_Proposal__Proposal_Name__c = 'Test Proposal',Apttus_Proposal__Opportunity__c = op.id,Degree_Type__c = 'Full-Time', Deposit__c = 1234, Payment_Method__c = 'Credit Card', Payment_Type__c = 'Monthly Payment', Payment_Period_In_Month__c = '10', First_Payment_Date__c = System.Today());
    prop.RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Quote').getRecordTypeId();
    prop.Apttus_QPConfig__PriceListId__c = qsvalue.Early_Bird_Price_List_Id__c;
    insert prop;
    
        Product2 p = new Product2();
        p.Name = 'Test Bundle Level 2';
        p.Apttus_Config2__ConfigurationType__c = 'Bundle' ;
        p.ISBN__c = '12345678901';
        p.IsActive = true;
        P.Qualification_Name__c = 'Test Bundle';
        p.Campus__c='Durbanville';
        p.Qualification_Level_Name__c= 2;
        insert p;
        
        prodSOList.add(p);
        
        Product2 p1 = new Product2();
        p1.Name = 'Test Option';
        p1.Apttus_Config2__ConfigurationType__c = 'Option' ;
        p1.ISBN__c = '123456 IS';
        p1.IsActive = true;
        insert p1;
        
        Product2 p2 = new Product2();
        p2.Name = 'Test Option';
        p2.Apttus_Config2__ConfigurationType__c = 'Option' ;
        p2.ISBN__c = '123456 T2';
        p2.IsActive = true;
        insert p2;
        
        prodOptionList.add(p1);
        prodOptionList.add(p2);
        
        Apttus_Config2__ClassificationName__c CN = new Apttus_Config2__ClassificationName__c(Name ='Test CN',Apttus_Config2__HierarchyLabel__c = 'Test CN', Apttus_Config2__Active__c = true);
        insert CN;
        
        Apttus_Config2__ClassificationHierarchy__c CH = new Apttus_Config2__ClassificationHierarchy__c(Name ='Test CH', Apttus_Config2__Label__c = 'Test CH', Apttus_Config2__HierarchyId__c = CN.Id);
        insert CH;
        
        Apttus_Config2__ProductOptionGroup__c POG = new Apttus_Config2__ProductOptionGroup__c(Apttus_Config2__RootOptionGroupId__c = CH.Id, Apttus_Config2__OptionGroupId__c = CH.Id, Apttus_Config2__ProductId__c = P.Id,Apttus_Config2__MaxOptions__c = 999, Apttus_Config2__Sequence__c = 1);
        insert POG;
        
        Apttus_Config2__ProductOptionComponent__c poc = new Apttus_Config2__ProductOptionComponent__c(Apttus_Config2__Sequence__c = 1,Apttus_Config2__ComponentProductId__c = p1.id, Apttus_Config2__RelationshipType__c = 'Option', Apttus_Config2__ParentProductId__c = p.id, Apttus_Config2__ProductOptionGroupId__c = POG.id, Apttus_Config2__Modifiable__c = true);
        insert poc;
        
    
    Map<Decimal,WrapperProductController> productwrapper = new Map<Decimal,WrapperProductController>();
             if(prodSOList.size() >0){
                 for(Product2 lineitem : prodSOList){
                      WrapperProductController tempproduct = new WrapperProductController();
                      tempproduct.ProductId = lineitem.Id;
                      tempproduct.Discount_Reference = null;
                      tempproduct.LineType = 'Product/Service';
                      tempproduct.LineNumber = 1;
                      tempproduct.Quantity = 1;
                      productwrapper.put(1,tempproduct);
                 }
                                                                            
                for(Product2 lineitem : prodOptionList){
                     WrapperProductController tempproduct = new WrapperProductController();
                     WrapperProductController.WrapperProductOption tempproductoption = new WrapperProductController.WrapperProductOption();
                     if(productwrapper.get(1) != null){
                         tempproduct = productwrapper.get(1);
                         if(tempproduct.productoptions != null){
                             tempproductoption.RecordId = lineitem.Id;
                             tempproductoption.ProductId = lineitem.Id;
                             tempproductoption.ProductOptionId = poc.Id;
                             tempproductoption.LineType = 'Option';
                             tempproductoption.LineNumber = 1;
                             tempproductoption.Quantity = 1;
                             tempproductoption.Discount_Reference = 'Financial Credit';
                             tempproduct.productoptions.add(tempproductoption);
                         }else{
                              List<WrapperProductController.WrapperProductOption> templistproductoption = new List<WrapperProductController.WrapperProductOption>();
                              tempproductoption.RecordId = lineitem.Id;
                              tempproductoption.ProductId = lineitem.Id;
                              tempproductoption.ProductOptionId = poc.Id;
                              tempproductoption.LineType = 'Option';
                              tempproductoption.LineNumber = 1;
                              tempproductoption.Quantity = 1;
                              tempproductoption.Discount_Reference = 'Financial Credit';
                              templistproductoption.add(tempproductoption);
                              tempproduct.productoptions = templistproductoption;
                              //tempproduct.productoptions 
                         }
                         
                         productwrapper.put(1,tempproduct);
                     }else{
                         //option without a bundle ?
                         system.debug(' option without a Bundle ');
                     }
                 }
                
             }
             
    ID CART ;
    system.debug('proposal :'+prop.Id);
    CretaeApttusCPQ cr = new CretaeApttusCPQ();
    CART= cr.CreateApttusCart(prop.Id);
    cr.CreateBundle(productwrapper.get(1),CART);
    cr.AddMultiProduct(prodOptionList,CART);
    cr.RepriceProposal(CART);
    cr.Finalizeproposal(CART);
    

 
 }
 
}