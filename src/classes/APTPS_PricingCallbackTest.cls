/*******************************************************************************************************************
* Apex Class Name  : APTPS_PricingCallbackTest
* Version          : 1.0 
* Created Date     : 30 March 2015
* Function         : Test Class of the APTPS_PricingCallback Class
* Modification Log :
*
* Developer                                Date                    Description
* ------------------------------------------------------------------------------------------------------------------
*   Accenture IDC                          19/03/2015              Created Initial Version
*******************************************************************************************************************/
@isTest (seeAllData=True)                  
public class APTPS_PricingCallbackTest{
/* static testMethod void myTest() { 
 
   Account acc = new Account(Name = 'AccTest1',Line_of_Business__c='Schools',CurrencyIsoCode='ZAR',Geography__c = 'Growth',Organisation_Type__c = 'Higher Education',Type = 'School');
   Contact con = new Contact(LastName = 'con1',FirstName = 'test2' , accountid = acc.id, Phone = '4545');
   insert acc;
   insert con; 
       
    asset ass = new asset(name='ass1',AccountId = acc.id);     
    insert ass;
      
    Apttus_Config2__ProductConfiguration__c prod = new Apttus_Config2__ProductConfiguration__c();
    prod.Name = 'testp';
    insert prod;
      
     List<Apttus_Config2__LineItem__c>lineitemlist = new List<Apttus_Config2__LineItem__c>();
     Apttus_Config2__LineItem__c al = new Apttus_Config2__LineItem__c();
      al.Apttus_Config2__AssetId__c = ass.id;
      al.Discount_Reference__c =  'Academic Credit' ;
      al.Apttus_Config2__LineNumber__c = 30;
      al.Apttus_Config2__ItemSequence__c = 8;
      al.Apttus_Config2__ConfigurationId__c= prod.id;
      al.Apttus_Config2__AdjustmentType__c = '% Discount';
      al.Apttus_Config2__AdjustmentAmount__c = 88;
      lineitemlist.add(al);
      
      Apttus_Config2__LineItem__c al2 = new Apttus_Config2__LineItem__c();
      al2.Apttus_Config2__AssetId__c = ass.id;
      al2.Discount_Reference__c =  'Financial Credit' ;
      al2.Apttus_Config2__LineNumber__c = 30;
      al2.Apttus_Config2__ItemSequence__c = 8;
      al2.Apttus_Config2__ConfigurationId__c= prod.id;
      al2.Apttus_Config2__AdjustmentType__c = '% Discount';
      al2.Apttus_Config2__AdjustmentAmount__c = 99;
      lineitemlist.add(al2);
      
      test.starttest();
      
      insert lineitemlist;
            
       APTPS_PricingCallback app = new  APTPS_PricingCallback();
       
       Apttus_Config2.ProductConfiguration.LineItemColl itemColl;
       app.beforePricing(itemColl);
       app.afterPricing(itemColl);
       
       
       Apttus_Config2.CustomClass.PricingMode mode ;
       app.setMode(mode);
     
     //afterPricingLineItem(Apttus_Config2.ProductConfiguration.LineItemColl itemcoll, Apttus_Config2.LineItem li){
       
       Apttus_Config2.ProductConfiguration.LineItemColl itemcoll2;
       Apttus_Config2.LineItem li;
       app.afterPricingLineItem(itemcoll2,li);
      
       Apttus_Config2.ProductConfiguration ac;
       app.start(ac);
              
       
       
       
       // global void beforePricingLineItem(Apttus_Config2.ProductConfiguration.LineItemColl itemcoll, Apttus_Config2.LineItem lineItemMO){
       
       Apttus_Config2.ProductConfiguration.LineItemColl itemcoll3;
       Apttus_Config2.LineItem lineItemMO;
       app.beforePricingLineItem(itemcoll3,lineItemMO);
       
       //onPriceItemSet(Apttus_Config2__PriceListItem__c itemSO, Apttus_Config2.LineItem lineItemMO){
       
       Apttus_Config2__PriceListItem__c itemSO;
       Apttus_Config2.LineItem lineItemMO2;
       app.onPriceItemSet(itemSO,lineItemMO2);
       
       app.finish();
       
       
      test.stoptest();
 
 }*/
}