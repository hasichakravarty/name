trigger tIUD_ProductBookshopQty_Update on Account_Product__c (before insert, after insert,
       before delete, after update) {
 /* AA (Deloitte) - Deactivated as UK Users not onboarded yet
 
 Set<Id> ProductIds = new Set<Id> ();
 List<Account_Product__c> AcctProduct  = new List<Account_Product__c> ();
 Map <String, Account_Product__c> AcctProductMap = new Map<String, Account_Product__c> ();
 List <Product2> BaseProduct;
 AggregateResult [] ProductSumQty;
 
   if (Trigger.isBefore) {
    if (Trigger.isDelete) {
      for (Account_Product__c i :Trigger.old) {
           ProductIds.Add (i.Product__c);
           AcctProduct.Add (i);
      }
    }
    else {
      for (Account_Product__c i :Trigger.new) {
           ProductIds.Add (i.Product__c);
      }
    }    
   }
   else {
      for (Account_Product__c i :Trigger.new) {
           ProductIds.Add (i.Product__c);
      }
   }

     //Get the product ids and their bookshop qty rollup
     ProductSumQty = [Select Product__c, sum(Stocked_Quantity__c) qty , sum(Actual_Sold_Quantity__c) actualqty from 
                                           Account_Product__c 
                                           where Product__c = :ProductIds group by Product__c];
   
    //Get the product ids and their bookshop qty
    BaseProduct = new List<Product2>([select Id, Bookshop_Quantity__c,Actual_Sold_Quantity__c from Product2 where Id = :ProductIds]);
       
    if (Trigger.isBefore) {
      if (Trigger.isInsert) {
         //Get the list of account product records for the list of product ids
         List<Account_Product__c> AcctProductInDB = [select Account__c, Product__c,Stocked_Quantity__c,Actual_Sold_Quantity__c
             from Account_Product__c where Product__c = :ProductIds];
        
          for (Account_Product__c i : AcctProductInDB) {
            AcctProductMap.put(i.Account__c+'-'+i.Product__c, new Account_Product__c (Account__c = i.Account__c,
                  Product__c = i.Product__c,Stocked_Quantity__c = i.Stocked_Quantity__c,
                  Actual_Sold_Quantity__c = i.Actual_Sold_Quantity__c) );         
          }
     
          //check if the account product record is being duplicated.
           for (Account_Product__c AcctProdChk : Trigger.new) {
             if (AcctProductMap.containsKey(AcctProdChk.Account__c + '-' + AcctProdChk.Product__c)) {
                    AcctProdChk.addError ('Product exists for this Account');
                    //HEUK_GlobalMessages__c msg = HEUK_GlobalMessages__c.getOrgDefaults();
                    //AcctProdChk.addError ((String)msg.Duplicate_Account_Product_Message__c);
             }
           }
       }
       if (Trigger.isDelete) {
           //Update the bookshop qty for the records where the id matches
           for (AggregateResult ar : ProductSumQty) {
             for (Product2 b : BaseProduct) {
              if (b.Id == ar.get('Product__c')) {
                b.Bookshop_Quantity__c = (Double)ar.get ('qty');
                b.Actual_Sold_Quantity__c = (Double)ar.get('actualqty');
              }
             }
           }
              
          //For the deleted rows, adjust the qty on the product record
          //based on the record deleted
          for (Product2 prod : BaseProduct) {
            for (Account_Product__c apc : AcctProduct) {
              if (prod.Id == apc.Product__c) {
                if (apc.Stocked_Quantity__c != null) {
                  prod.Bookshop_Quantity__c = prod.Bookshop_Quantity__c - apc.Stocked_Quantity__c;
                }
                if (apc.Actual_Sold_Quantity__c != null) {
                  prod.Actual_Sold_Quantity__c = prod.Actual_Sold_Quantity__c - apc.Actual_Sold_Quantity__c;
                }
              }
            }
          }
          
          update BaseProduct;     
       }
     }
     else {
       //Update the bookshop qty for the records where the id matches
       for (AggregateResult ar : ProductSumQty) {
         for (Product2 b : BaseProduct) {
          if (b.Id == ar.get('Product__c')) {
            b.Bookshop_Quantity__c = (Double)ar.get ('qty');
            b.Actual_Sold_Quantity__c = (Double)ar.get('actualqty');
          }
         }
       }
       
       update BaseProduct;
     }
     
     */
}