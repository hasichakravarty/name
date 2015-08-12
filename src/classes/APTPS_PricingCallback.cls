// Purpose : This class handles the functionality of Price Call back
// Before pricing the quantity of options gets calculated according to 'APTPS_Quantity_Calc__c' field.
// Created Date : Feb-16-2015

global with sharing class APTPS_PricingCallback implements Apttus_Config2.CustomClass.IPricingCallback3{
  //It will store the mapping of Bundle No (Line number) and it's correspondance options's quantity sum if option has contribute to value present in the record.
  //It will store the unique operations which could be present in option.
  Set<string> operations = new Set<string>();
  @TestVisible Apttus_Config2.CustomClass.PricingMode systemMode;
//Start Method
  global void start(Apttus_Config2.ProductConfiguration cart) {  
        
    }

  //Setmode Method
  global void setMode(Apttus_Config2.CustomClass.PricingMode mode) {
  
    systemMode = mode;

  }
    
    /**
   * Callback before pricing the line item collection
   * Use this method to do all required pre-processing to prepare the line items for pricing.
   * Purpose of this method to calculate quantity of option line item which has APTPS_Quantity_Calc__c field value is present in the record
   * on the basis of those optoin line items's qunatity which has APTPS_Contributes_To__c field present in the record.
   * @param itemColl the line item collection to pre-process
   */
    global void beforePricing(Apttus_Config2.ProductConfiguration.LineItemColl itemColl) {
        System.debug('Before pricing');
        // if Discount Reference = 'Academic Credit' or 'Financial Credit' then default AdjustmentAmount = 100 and AdjustmentType = '% Discount'
        if(SystemMode == Apttus_Config2.CustomClass.PricingMode.BASEPRICE){
          if(!itemColl.getAllLineItems().isEmpty() && itemColl.getAllLineItems()!= null){
            for(Apttus_Config2.LineItem lineitem:itemColl.getAllLineItems()){
                       Apttus_Config2__LineItem__c item = lineitem.getLineItemSO();
                       if((item.Discount_Reference__c != null && item.Discount_Reference__c.equals(Utils_allfields.DiscountRef1)) || (item.Discount_Reference__c != null && item.Discount_Reference__c.equals(Utils_allfields.DiscountRef2)))
                            {
                                item.Apttus_Config2__AdjustmentType__c = Utils_allfields.AdjustmentType;
                                item.Apttus_Config2__AdjustmentAmount__c = 100;
                            }else{
                                item.Apttus_Config2__AdjustmentType__c = null;
                                item.Apttus_Config2__AdjustmentAmount__c = 0;
                            }
                       
            }
        }
     }


//if (SystemMode == Apttus_Config2.CustomClass.PricingMode.BASEPRICE){
                    
                //loop through the line items
                /* for(Apttus_Config2.LineItem lineitem:itemColl.getAllLineItems()){
                     
                  
                   //get the line item
                   Apttus_Config2__LineItem__c item = lineitem.getLineItemSO();
                   item.Apttus_Config2__Quantity__c = 7;

                  }*/

            
    //  }
    }    
    
    /**
   * Callback after pricing the line item collection
   * Use this method to do all required post-processing after line items are priced.
   * @param itemColl the line item collection to post-process
   */
    global void afterPricing(Apttus_Config2.ProductConfiguration.LineItemColl itemColl) {
      System.debug('lclc afterPricing');
        
        if (SystemMode == Apttus_Config2.CustomClass.PricingMode.ROLLDOWN){

                

                 /*for(Apttus_Config2__LineItem__c al:amendedLines.values()){
                  if(item.Id==al.Id){
                    Apttus_Config2__AssetLineItem__c ali;
                    List<Apttus_Config2__AssetLineItem__c> alis=[select Apttus_Config2__Quantity__c from Apttus_Config2__AssetLineItem__c 
                                                                    where Id=:al.Apttus_Config2__AssetLineItemId__c];
                    if(!alis.isEmpty()){
                      ali=alis[0];
                    }
                    System.debug('lclc for realted quantity initial second '+item.Apttus_Config2__Quantity__c);
                    item.Apttus_Config2__Quantity__c=item.Apttus_Config2__Quantity__c-(ali.Apttus_Config2__Quantity__c);
                    System.debug('lclc for related quantity set second '+item.Apttus_Config2__Quantity__c);
                  }
                }*/
        }


       }

  /**
   * Callback after line items
   */
global void afterPricingLineItem(Apttus_Config2.ProductConfiguration.LineItemColl itemcoll, Apttus_Config2.LineItem li){
}
                             
  
  /**
   * Callback before line items
   */
    global void beforePricingLineItem(Apttus_Config2.ProductConfiguration.LineItemColl itemcoll, Apttus_Config2.LineItem lineItemMO){
        }
    
        
    

    /**
   * Callback after all batches of line items are processed
   */
    global void finish() {

    }     
//Method
   global void onPriceItemSet(Apttus_Config2__PriceListItem__c itemSO, Apttus_Config2.LineItem lineItemMO){
           
    }           
}