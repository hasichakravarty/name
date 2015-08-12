global class oneCRMCreatePearsonChoicesBatch_V2 implements Database.Batchable<sObject>{

  Set<Id> setWithProductId = new Set<Id>();
  Date dummyDate;
  List<String> brandFromCustomSetting = new List<String>();
  Map<String,oneCRMPearsonChoicesBrand__c> mapWithBrandValues;
  String country_Name;
  String business_Unit;
 
  global oneCRMCreatePearsonChoicesBatch_V2(String countryName,String businessUnit ) 
  {
        country_Name = countryName;
        business_Unit = businessUnit;
        mapWithBrandValues = oneCRMPearsonChoicesBrand__c.getall();
        for(oneCRMPearsonChoicesBrand__c s : mapWithBrandValues.values())
        {
            brandFromCustomSetting.add(s.PearsonChoicesBrandValues__c);
        }  
        
  }

  global Database.QueryLocator start(Database.BatchableContext BC) {
                  
  return Database.getQueryLocator([select Id,Name,(select Id,Apttus_Config2__RelatedProductId__c,Apttus_Config2__RelatedProductId__r.Brand__c,Apttus_Config2__RelatedProductId__r.Contains_eText__c,Apttus_Config2__RelatedProductId__r.Binding__c,Apttus_Config2__RelatedProductId__r.ISBN__c,Apttus_Config2__RelatedProductId__r.SBN__c,Apttus_Config2__RelatedProductId__r.Status__c,Association_Category__c,Apttus_Config2__RelatedProductId__r.Platform__c,Apttus_Config2__RelatedProductId__r.Duration__c,Apttus_Config2__RelatedProductId__r.InstockDate__c,Apttus_Config2__RelatedProductId__r.Category2__c,Apttus_Config2__RelatedProductId__r.Accounting_Code__c,Apttus_Config2__ProductId__c,Apttus_Config2__ProductId__r.Name from Apttus_Config2__RelatedProducts__r) from Product2 where Apttus_Config2__ConfigurationType__c =: 'Bundle' And Market__c =: country_Name And Line_of_Business__c = 'Higher Ed' And Business_Unit__c =: business_Unit]);
  
  }
   
  global void execute(Database.BatchableContext BC,List<Product2> productList) {
      
     List<Apttus_Config2__RelatedProduct__c> relatedProductList = new List<Apttus_Config2__RelatedProduct__c>();
     List<Apttus_Config2__RelatedProduct__c> listWithRelatedProduct = new List<Apttus_Config2__RelatedProduct__c>();   
     List<Apttus_Config2__RelatedProduct__c> dummylistWithRelatedProduct = new List<Apttus_Config2__RelatedProduct__c>(); 
     List<Apttus_Config2__RelatedProduct__c> listWithAlternateEdition  = new List<Apttus_Config2__RelatedProduct__c>();
     Integer removeRelatedProductId = 0;
     List<Integer> listWithRemoveRelatedProductId = new List<Integer>();
     Map<Id,Decimal> mapWithPriceListItem = new Map<Id,Decimal>();
     Set<Id> setWithProdIdForNetPrice = new Set<ID>();
     List<Pearson_Choice__c> listWithNewPearsonChoices = new List<Pearson_Choice__c>();   
     List<Pearson_Choice__c> Pearson_Choice = new List<Pearson_Choice__c>();
     //List<Pearson_Choice__c> listToUpdateInstantAccessRecord = new List<Pearson_Choice__c>();
     List<Pearson_Choice__c> listToCreateInstantAccessRecord = new List<Pearson_Choice__c>();
     Pearson_Choice__c newMasterProd;
     List<Pearson_Choice__c> listWithInstantAccessPearsonChoiceRecords = new List<Pearson_Choice__c>(); 
     for(Product2 product2Result : productList)
        { 
            listWithRelatedProduct = product2Result.getSObjects('Apttus_Config2__RelatedProducts__r')!=null?product2Result.getSObjects('Apttus_Config2__RelatedProducts__r'):dummylistWithRelatedProduct ;
            
            if(!listWithRelatedProduct.isEmpty() && listWithRelatedProduct != null)
            {
                for(Apttus_Config2__RelatedProduct__c relProd : listWithRelatedProduct)
                {
                    for(String brand : brandFromCustomSetting)
                    {
                        if(relProd.Apttus_Config2__RelatedProductId__r.Brand__c == brand)
                        {
                            relatedProductList.add(relProd);
                            setWithProdIdForNetPrice.add(relProd.Apttus_Config2__RelatedProductId__c);
                        }
                    }
                }
            }    
            setWithProductId.add(product2Result.Id);
        }
     
    for(Apttus_Config2__PriceListItem__c priceListItem : [select Apttus_Config2__ProductId__c,Net_Price__c from Apttus_Config2__PriceListItem__c where Apttus_Config2__ProductId__c IN : setWithProdIdForNetPrice limit 50000])
    {
     mapWithPriceListItem.put(priceListItem.Apttus_Config2__ProductId__c,priceListItem.Net_Price__c);
    }    
     
      for(Apttus_Config2__RelatedProduct__c relatedProd : relatedProductList)
      {
          if(relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c == 'MyLab' || relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c == 'Mastering' || relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c == 'MyKit'|| relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c == 'Pearson eText' || relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c == 'REVEL' && relatedProd.Apttus_Config2__RelatedProductId__r.Binding__c == 'Access Code Card' || relatedProd.Apttus_Config2__RelatedProductId__r.Binding__c == 'Access Card Package' && relatedProd.Association_Category__c == 'Student Supplement' || relatedProd.Association_Category__c == 'Alternate Binding')
          {
            newMasterProd = new Pearson_Choice__c();
            newMasterProd.Brand__c = relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c;
            newMasterProd.Includes_Pearon_eText__c = (relatedProd.Apttus_Config2__RelatedProductId__r.Contains_eText__c==True?'with eText':'no eText');
            newMasterProd.Access_Length__c = relatedProd.Apttus_Config2__RelatedProductId__r.Duration__c;
            newMasterProd.Bookstore_ISBN_s__c = relatedProd.Apttus_Config2__RelatedProductId__r.SBN__c+'<br/>'+relatedProd.Apttus_Config2__RelatedProductId__r.ISBN__c+'<br/>'+(relatedProd.Apttus_Config2__RelatedProductId__r.InstockDate__c!=null?relatedProd.Apttus_Config2__RelatedProductId__r.InstockDate__c:dummyDate).format()+' '+relatedProd.Apttus_Config2__RelatedProductId__r.Status__c;
            newMasterProd.Product_Family__c = relatedProd.Apttus_Config2__ProductId__c;
            newMasterProd.Platform__c = relatedProd.Apttus_Config2__RelatedProductId__r.Platform__c;
            newMasterProd.Bookstore__c = relatedProd.Apttus_Config2__RelatedProductId__c;
            newMasterProd.Bookstore_Price__c = mapWithPriceListItem.get(relatedProd.Apttus_Config2__RelatedProductId__c);
            if(mapWithBrandValues.get(relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c) != null)
            newMasterProd.Offer_Type__c = mapWithBrandValues.get(relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c).Offer_Type__c=='Special Offer Type Rule'?(newMasterProd.Includes_Pearon_eText__c=='with eText'?'Learning Application + Text':'Learning Application'):mapWithBrandValues.get(relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c).Offer_Type__c;
            if(mapWithBrandValues.get(relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c) != null)
            newMasterProd.Sequence__c = mapWithBrandValues.get(relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c).Offer_Type_Sequence__c == 0?(newMasterProd.Includes_Pearon_eText__c=='with eText'?1:2):mapWithBrandValues.get(relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c).Offer_Type_Sequence__c;
            listWithNewPearsonChoices.add(newMasterProd);
            listWithRemoveRelatedProductId.add(removeRelatedProductId);
            System.debug(removeRelatedProductId); 
          } 
          removeRelatedProductId = removeRelatedProductId + 1;
          
      }
      if(!listWithNewPearsonChoices.isEmpty() && listWithNewPearsonChoices != null)
      {
        insert listWithNewPearsonChoices;
      }
      listWithRemoveRelatedProductId.sort();
    for(Integer i=listWithRemoveRelatedProductId.size()-1;i>=0;i--)
    {     
        if(listWithRemoveRelatedProductId[i]<relatedProductList.size())
        {
           relatedProductList.remove(listWithRemoveRelatedProductId[i]);
        }
    }
    if(setWithProductId != null)
    Pearson_Choice = [select Id,Product_Family__c,Access_Length__c,Brand__c,Platform__c,Includes_Pearon_eText__c from Pearson_Choice__c where Product_Family__c IN : setWithProductId];
    listWithRemoveRelatedProductId.clear();
    removeRelatedProductId = 0;
    for(Apttus_Config2__RelatedProduct__c relatedProd : relatedProductList)
    { 
        if(relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c == 'MyLab' || relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c == 'Mastering' || relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c == 'MyKit'|| relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c == 'Pearson eText' || relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c == 'REVEL' && relatedProd.Apttus_Config2__RelatedProductId__r.Binding__c == 'Website' || relatedProd.Apttus_Config2__RelatedProductId__r.Binding__c == 'On-line Supplement' || relatedProd.Apttus_Config2__RelatedProductId__r.Binding__c == 'Electronic Package' || relatedProd.Apttus_Config2__RelatedProductId__r.Binding__c == 'Electronic Book' && relatedProd.Association_Category__c == 'Premium Website' || relatedProd.Association_Category__c == 'CourseCompass' || relatedProd.Association_Category__c == 'WebCT' || relatedProd.Association_Category__c == 'Blackboard' || relatedProd.Association_Category__c == 'ECollege' || relatedProd.Association_Category__c == 'eBook + Standalone')
        {
                if(Pearson_Choice != null)
                {
                for(Pearson_Choice__c pearsonChoice : Pearson_Choice)
                {
                    if(relatedProd.Apttus_Config2__RelatedProductId__r.Duration__c == pearsonChoice.Access_Length__c && relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c == pearsonChoice.Brand__c && relatedProd.Apttus_Config2__RelatedProductId__r.Platform__c == pearsonChoice.Platform__c && (pearsonChoice.Includes_Pearon_eText__c == 'with eText' && relatedProd.Apttus_Config2__RelatedProductId__r.Contains_eText__c == True) || (pearsonChoice.Includes_Pearon_eText__c == 'no eText' && relatedProd.Apttus_Config2__RelatedProductId__r.Contains_eText__c == False))
                    {
                        pearsonChoice.Instant_Access__c = relatedProd.Apttus_Config2__RelatedProductId__c;
                        pearsonChoice.Instant_Access_Price__c = mapWithPriceListItem.get(relatedProd.Apttus_Config2__RelatedProductId__c);
                        //listToUpdateInstantAccessRecord.add(pearsonChoice);
                        listWithRemoveRelatedProductId.add(removeRelatedProductId);
                    }else
                    {
                        newMasterProd = new Pearson_Choice__c();
                        newMasterProd.Brand__c = relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c;
                        newMasterProd.Includes_Pearon_eText__c = (relatedProd.Apttus_Config2__RelatedProductId__r.Contains_eText__c==True?'with eText':'no eText');
                        newMasterProd.Access_Length__c = relatedProd.Apttus_Config2__RelatedProductId__r.Duration__c;
                        newMasterProd.Bookstore_ISBN_s__c = relatedProd.Apttus_Config2__RelatedProductId__r.SBN__c+'<br/>'+relatedProd.Apttus_Config2__RelatedProductId__r.ISBN__c+'<br/>'+(relatedProd.Apttus_Config2__RelatedProductId__r.InstockDate__c!=null?relatedProd.Apttus_Config2__RelatedProductId__r.InstockDate__c:dummyDate).format()+' '+relatedProd.Apttus_Config2__RelatedProductId__r.Status__c;
                        newMasterProd.Product_Family__c = relatedProd.Apttus_Config2__ProductId__c;
                        newMasterProd.Platform__c = relatedProd.Apttus_Config2__RelatedProductId__r.Platform__c;
                        newMasterProd.Instant_Access__c = relatedProd.Apttus_Config2__RelatedProductId__c;
                        newMasterProd.Instant_Access_Price__c = mapWithPriceListItem.get(relatedProd.Apttus_Config2__RelatedProductId__c);
                        if(mapWithBrandValues.get(relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c) != null)
                        newMasterProd.Offer_Type__c = mapWithBrandValues.get(relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c).Offer_Type__c=='Special Offer Type Rule'?(newMasterProd.Includes_Pearon_eText__c=='with eText'?'Learning Application + Text':'Learning Application'):mapWithBrandValues.get(relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c).Offer_Type__c;
                        if(mapWithBrandValues.get(relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c) != null)
                        newMasterProd.Sequence__c = mapWithBrandValues.get(relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c).Offer_Type_Sequence__c == 0?(newMasterProd.Includes_Pearon_eText__c=='with eText'?1:2):mapWithBrandValues.get(relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c).Offer_Type_Sequence__c;
                        listToCreateInstantAccessRecord.add(newMasterProd);
                        listWithRemoveRelatedProductId.add(removeRelatedProductId);
                    }
                }
                }
            
        }
        
        removeRelatedProductId = removeRelatedProductId + 1;
    } 
        /*if(!listToUpdateInstantAccessRecord.isEmpty() && listToUpdateInstantAccessRecord != null)
        {
            update listToUpdateInstantAccessRecord;
        }*/
        if(!Pearson_Choice.isEmpty() && Pearson_Choice != null)
        {
            update Pearson_Choice;
        }
        if(!listToCreateInstantAccessRecord.isEmpty() && listToCreateInstantAccessRecord != null)
        {
            insert listToCreateInstantAccessRecord;
        }
        listWithRemoveRelatedProductId.sort();
    for(Integer i=listWithRemoveRelatedProductId.size()-1;i>=0;i--)
    {     
        if(listWithRemoveRelatedProductId[i]<relatedProductList.size())
        {
           relatedProductList.remove(listWithRemoveRelatedProductId[i]);
        }
    }
    listToCreateInstantAccessRecord.clear();
    listWithRemoveRelatedProductId.clear();
    removeRelatedProductId = 0;
    for(Apttus_Config2__RelatedProduct__c relatedProd : relatedProductList)
    { 
        
        if(relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c == 'CourseSmart' || relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c == 'Safari' || relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c == 'Inkling')
        {
                newMasterProd = new Pearson_Choice__c();
                newMasterProd.Brand__c = relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c;
                newMasterProd.Includes_Pearon_eText__c = (relatedProd.Apttus_Config2__RelatedProductId__r.Contains_eText__c==True?'with eText':'no eText');
                newMasterProd.Access_Length__c = relatedProd.Apttus_Config2__RelatedProductId__r.Duration__c;
                newMasterProd.Bookstore_ISBN_s__c = relatedProd.Apttus_Config2__RelatedProductId__r.SBN__c+'<br/>'+relatedProd.Apttus_Config2__RelatedProductId__r.ISBN__c+'<br/>'+(relatedProd.Apttus_Config2__RelatedProductId__r.InstockDate__c!=null?relatedProd.Apttus_Config2__RelatedProductId__r.InstockDate__c:dummyDate).format()+' '+relatedProd.Apttus_Config2__RelatedProductId__r.Status__c;
                newMasterProd.Product_Family__c = relatedProd.Apttus_Config2__ProductId__c;
                newMasterProd.Platform__c = relatedProd.Apttus_Config2__RelatedProductId__r.Platform__c;
                newMasterProd.Instant_Access__c = relatedProd.Apttus_Config2__RelatedProductId__c;
                newMasterProd.Instant_Access_Price__c = mapWithPriceListItem.get(relatedProd.Apttus_Config2__RelatedProductId__c);
                if(mapWithBrandValues.get(relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c) != null)
                newMasterProd.Offer_Type__c = mapWithBrandValues.get(relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c).Offer_Type__c=='Special Offer Type Rule'?(newMasterProd.Includes_Pearon_eText__c=='with eText'?'Learning Application + Text':'Learning Application'):mapWithBrandValues.get(relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c).Offer_Type__c;
                if(mapWithBrandValues.get(relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c) != null)
                newMasterProd.Sequence__c = mapWithBrandValues.get(relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c).Offer_Type_Sequence__c == 0?(newMasterProd.Includes_Pearon_eText__c=='with eText'?1:2):mapWithBrandValues.get(relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c).Offer_Type_Sequence__c;
                listToCreateInstantAccessRecord.add(newMasterProd);
                listWithRemoveRelatedProductId.add(removeRelatedProductId);
        }
        removeRelatedProductId = removeRelatedProductId + 1;
    }
        if(!listToCreateInstantAccessRecord.isEmpty() && listToCreateInstantAccessRecord != null)
        {
            insert listToCreateInstantAccessRecord;
        }   
        listWithRemoveRelatedProductId.sort();
    for(Integer i=listWithRemoveRelatedProductId.size()-1;i>=0;i--)
    {     
        if(listWithRemoveRelatedProductId[i]<relatedProductList.size())
        {
           relatedProductList.remove(listWithRemoveRelatedProductId[i]);
        }
    }
    listToCreateInstantAccessRecord.clear();
    listWithRemoveRelatedProductId.clear();
    //listToUpdateInstantAccessRecord.clear();
    Pearson_Choice.clear();
    removeRelatedProductId = 0;
    if(setWithProductId != null)
    Pearson_Choice = [select Id,Product_Family__c,Access_Length__c,Brand__c,Platform__c,Includes_Pearon_eText__c from Pearson_Choice__c where Product_Family__c IN : setWithProductId];
    for(Apttus_Config2__RelatedProduct__c relatedProd : relatedProductList)
    { 
        if(relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c == 'Mastering' || relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c == 'MyKit' || relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c == 'MyLab' && relatedProd.Apttus_Config2__RelatedProductId__r.Binding__c == 'Electronic Book' && relatedProd.Apttus_Config2__RelatedProductId__r.Category2__c == 'eBook+ upgrade (component)' && (relatedProd.Apttus_Config2__RelatedProductId__r.Accounting_Code__c).contains('J') || (relatedProd.Apttus_Config2__RelatedProductId__r.Accounting_Code__c).contains('D') || (relatedProd.Apttus_Config2__RelatedProductId__r.Accounting_Code__c).contains('L') || (relatedProd.Apttus_Config2__RelatedProductId__r.Accounting_Code__c).contains('Q') || (relatedProd.Apttus_Config2__RelatedProductId__r.Accounting_Code__c).contains('G') || relatedProd.Apttus_Config2__RelatedProductId__r.Accounting_Code__c == 'R-86' && relatedProd.Apttus_Config2__RelatedProductId__r.Platform__c == 'eBook+ Upgrade' && relatedProd.Association_Category__c == 'Supplement')
        {
            if(Pearson_Choice != null)
            {
                for(Pearson_Choice__c pearsonChoice : Pearson_Choice)
                {
                    if(relatedProd.Apttus_Config2__RelatedProductId__r.Duration__c == pearsonChoice.Access_Length__c && relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c == pearsonChoice.Brand__c && pearsonChoice.Includes_Pearon_eText__c == 'no eText')
                    {
                        pearsonChoice.eText_Offer__c = relatedProd.Apttus_Config2__RelatedProductId__c;
                        pearsonChoice.eText_Offer_Price__c = mapWithPriceListItem.get(relatedProd.Apttus_Config2__RelatedProductId__c);
                        //listToUpdateInstantAccessRecord.add(pearsonChoice);
                        listWithRemoveRelatedProductId.add(removeRelatedProductId);
                    }
                }
            }
            
        }
        removeRelatedProductId = removeRelatedProductId + 1;
    }
    /*if(!listToUpdateInstantAccessRecord.isEmpty() && listToUpdateInstantAccessRecord != null)
        {
            update listToUpdateInstantAccessRecord;
        }*/
    if(!Pearson_Choice.isEmpty() && Pearson_Choice != null)
        {
            update Pearson_Choice;
        }
    listWithRemoveRelatedProductId.sort();
    for(Integer i=listWithRemoveRelatedProductId.size()-1;i>=0;i--)
    {     
        if(listWithRemoveRelatedProductId[i]<relatedProductList.size())
        {
           relatedProductList.remove(listWithRemoveRelatedProductId[i]);
        }
    }
    listToCreateInstantAccessRecord.clear();
    listWithRemoveRelatedProductId.clear();
    //listToUpdateInstantAccessRecord.clear();
    Pearson_Choice.clear();
    removeRelatedProductId = 0;
    if(setWithProductId != null)
    Pearson_Choice = [select Id,Product_Family__c,Access_Length__c,Brand__c,Platform__c,Includes_Pearon_eText__c from Pearson_Choice__c where Product_Family__c IN : setWithProductId];
    for(Apttus_Config2__RelatedProduct__c relatedProd : relatedProductList)
    { 
        if(relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c == 'Mastering' || relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c == 'MyKit' || relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c == 'MyLab' && relatedProd.Apttus_Config2__RelatedProductId__r.Binding__c == 'Unbound (Saleable)' && relatedProd.Apttus_Config2__RelatedProductId__r.Category2__c == 'Special Item' &&  relatedProd.Apttus_Config2__RelatedProductId__r.Platform__c == 'Print Offer' && relatedProd.Association_Category__c == 'Supplement')
        {
            if(Pearson_Choice != null)
            {
                for(Pearson_Choice__c pearsonChoice : Pearson_Choice)
                {
                    if(relatedProd.Apttus_Config2__RelatedProductId__r.Duration__c == pearsonChoice.Access_Length__c && relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c == pearsonChoice.Brand__c && pearsonChoice.Includes_Pearon_eText__c == 'with eText' && relatedProd.Apttus_Config2__RelatedProductId__r.Contains_eText__c == True || pearsonChoice.Includes_Pearon_eText__c == 'no eText' || relatedProd.Apttus_Config2__RelatedProductId__r.Contains_eText__c == False)
                    {
                        pearsonChoice.Print_Offer__c = relatedProd.Apttus_Config2__RelatedProductId__c;
                        pearsonChoice.Print_Offer_Price__c = mapWithPriceListItem.get(relatedProd.Apttus_Config2__RelatedProductId__c);
                        //listToUpdateInstantAccessRecord.add(pearsonChoice);
                        listWithRemoveRelatedProductId.add(removeRelatedProductId);
                    }
                }
            }
        }
        removeRelatedProductId = removeRelatedProductId + 1;
    }
    /*if(!listToUpdateInstantAccessRecord.isEmpty() && listToUpdateInstantAccessRecord != null)
        {
            update listToUpdateInstantAccessRecord;
        }*/
       if(!Pearson_Choice.isEmpty() && Pearson_Choice != null)
        {
            update Pearson_Choice;
        }
    listWithRemoveRelatedProductId.sort();
    for(Integer i=listWithRemoveRelatedProductId.size()-1;i>=0;i--)
    {     
        if(listWithRemoveRelatedProductId[i]<relatedProductList.size())
        {
           relatedProductList.remove(listWithRemoveRelatedProductId[i]);
        }
    }
    listToCreateInstantAccessRecord.clear();
    listWithRemoveRelatedProductId.clear();
    removeRelatedProductId = 0;
    
    for(Apttus_Config2__RelatedProduct__c relatedProd : relatedProductList)
    { 
        if(relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c == 'Pearson Custom Library (PCL)')
        {
                newMasterProd = new Pearson_Choice__c();
                newMasterProd.Brand__c = 'Pearson Custom Library :'+relatedProd.Apttus_Config2__ProductId__r.Name;
                newMasterProd.Product_Family__c = relatedProd.Apttus_Config2__ProductId__c;
                newMasterProd.Bookstore__c = relatedProd.Apttus_Config2__RelatedProductId__c;
                newMasterProd.Offer_Type__c = mapWithBrandValues.get('Pearson Custom Library').Offer_Type__c;
                newMasterProd.Sequence__c = mapWithBrandValues.get('Pearson Custom Library').Offer_Type_Sequence__c;
                listToCreateInstantAccessRecord.add(newMasterProd);
                
                listWithRemoveRelatedProductId.add(removeRelatedProductId);
        }
        removeRelatedProductId = removeRelatedProductId + 1;
    }   
    if(!listToCreateInstantAccessRecord.isEmpty() && listToCreateInstantAccessRecord != null)
        {
            insert listToCreateInstantAccessRecord;
        } 
            listWithRemoveRelatedProductId.sort();
    for(Integer i=listWithRemoveRelatedProductId.size()-1;i>=0;i--)
    {     
        if(listWithRemoveRelatedProductId[i]<relatedProductList.size())
        {
           relatedProductList.remove(listWithRemoveRelatedProductId[i]);
        }
    }
    listToCreateInstantAccessRecord.clear();
    listWithRemoveRelatedProductId.clear();
    removeRelatedProductId = 0;
    for(Apttus_Config2__RelatedProduct__c relatedProd : relatedProductList)
    { 
        newMasterProd = new Pearson_Choice__c();
                newMasterProd.Brand__c = relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c;
                newMasterProd.Includes_Pearon_eText__c = (relatedProd.Apttus_Config2__RelatedProductId__r.Contains_eText__c==True?'with eText':'no eText');
                newMasterProd.Access_Length__c = relatedProd.Apttus_Config2__RelatedProductId__r.Duration__c;
                newMasterProd.Bookstore_ISBN_s__c = relatedProd.Apttus_Config2__RelatedProductId__r.SBN__c+'<br/>'+relatedProd.Apttus_Config2__RelatedProductId__r.ISBN__c+'<br/>'+(relatedProd.Apttus_Config2__RelatedProductId__r.InstockDate__c!=null?relatedProd.Apttus_Config2__RelatedProductId__r.InstockDate__c:dummyDate).format()+' '+relatedProd.Apttus_Config2__RelatedProductId__r.Status__c;
                newMasterProd.Product_Family__c = relatedProd.Apttus_Config2__ProductId__c;
                newMasterProd.Platform__c = relatedProd.Apttus_Config2__RelatedProductId__r.Platform__c;
                newMasterProd.Bookstore__c = relatedProd.Apttus_Config2__RelatedProductId__c;
                newMasterProd.Bookstore_Price__c = mapWithPriceListItem.get(relatedProd.Apttus_Config2__RelatedProductId__c);
                system.debug(relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c);
                if(relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c != null)
                {
                    if(mapWithBrandValues.get(relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c) != null)
                    {
                        newMasterProd.Offer_Type__c = mapWithBrandValues.get(relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c).Offer_Type__c=='Special Offer Type Rule'?(newMasterProd.Includes_Pearon_eText__c=='with eText'?'Learning Application + Text':'Learning Application'):mapWithBrandValues.get(relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c).Offer_Type__c;
                    }
                }
                if(mapWithBrandValues.get(relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c) != null)
                newMasterProd.Sequence__c = mapWithBrandValues.get(relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c).Offer_Type_Sequence__c == 0?(newMasterProd.Includes_Pearon_eText__c=='with eText'?1:2):mapWithBrandValues.get(relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c).Offer_Type_Sequence__c;
                listToCreateInstantAccessRecord.add(newMasterProd);
        listWithRemoveRelatedProductId.add(removeRelatedProductId);
        removeRelatedProductId = removeRelatedProductId + 1;
    }
    if(!listToCreateInstantAccessRecord.isEmpty() && listToCreateInstantAccessRecord != null)
        {
            insert listToCreateInstantAccessRecord;
        } 
            listWithRemoveRelatedProductId.sort();
    for(Integer i=listWithRemoveRelatedProductId.size()-1;i>=0;i--)
    {     
        if(listWithRemoveRelatedProductId[i]<relatedProductList.size())
        {
           relatedProductList.remove(listWithRemoveRelatedProductId[i]);
        }
    }
    listWithAlternateEdition = [select Id,Apttus_Config2__RelatedProductId__c,Apttus_Config2__RelatedProductId__r.Brand__c,Apttus_Config2__RelatedProductId__r.Contains_eText__c,Apttus_Config2__RelatedProductId__r.Binding__c,Apttus_Config2__RelatedProductId__r.ISBN__c,Apttus_Config2__RelatedProductId__r.SBN__c,Apttus_Config2__RelatedProductId__r.Status__c,Association_Category__c,Apttus_Config2__RelatedProductId__r.Platform__c,Apttus_Config2__RelatedProductId__r.Duration__c,Apttus_Config2__RelatedProductId__r.InstockDate__c,Apttus_Config2__RelatedProductId__r.Category2__c,Apttus_Config2__RelatedProductId__r.Accounting_Code__c,Apttus_Config2__ProductId__c,Apttus_Config2__ProductId__r.Name from Apttus_Config2__RelatedProduct__c where Apttus_Config2__ProductId__c IN : setWithProductId  And Apttus_Config2__RelatedProductId__r.Brand__c = '' And Apttus_Config2__RelatedProductId__r.Medium2__c = 'Print' And Apttus_Config2__RelatedProductId__r.Binding__c =  'Paper' And (Apttus_Config2__RelatedProductId__r.Binding__c = 'Cloth' Or Apttus_Config2__RelatedProductId__r.Binding__c = 'Ringbound' Or Apttus_Config2__RelatedProductId__r.Binding__c = 'Spiral Bound' Or  Apttus_Config2__RelatedProductId__r.Binding__c = 'Pearson Custom Library Content' Or  Apttus_Config2__RelatedProductId__r.Binding__c = 'Paper Bound with Access Card')];
    listToCreateInstantAccessRecord.clear();
   for(Apttus_Config2__RelatedProduct__c relatedPro : listWithAlternateEdition)
   {
        newMasterProd = new Pearson_Choice__c();
                newMasterProd.Brand__c = 'Print Text:'+relatedPro.Apttus_Config2__RelatedProductId__r.Binding__c+' '+relatedPro.Apttus_Config2__ProductId__r.Name;
                newMasterProd.Product_Family__c = relatedPro.Apttus_Config2__ProductId__c;
                newMasterProd.Bookstore__c = relatedPro.Apttus_Config2__RelatedProductId__c;
                newMasterProd.Offer_Type__c = mapWithBrandValues.get('Print Text  : Sub Medium').Offer_Type__c;
                newMasterProd.Sequence__c = mapWithBrandValues.get('Print Text  : Sub Medium').Offer_Type_Sequence__c;
                listToCreateInstantAccessRecord.add(newMasterProd);
   }
   if(!listToCreateInstantAccessRecord.isEmpty() && listToCreateInstantAccessRecord != null)
        {
            insert listToCreateInstantAccessRecord;
        } 
  }
  
  global void finish(Database.BatchableContext BC) {
     
  }
}