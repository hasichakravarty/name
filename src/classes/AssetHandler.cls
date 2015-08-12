public class AssetHandler {
    
    //Creates Apttus asset from opportunity products 
    public void CreateAssetLineItem(Id OpptyId){
        List<Apttus_Config2__AssetLineItem__c> AssetlineItem = new List<Apttus_Config2__AssetLineItem__c>();
        if(OpptyId != null){
            List<OpportunityLineItem> OpptyProduct = [select Id, Product2Id, OptionId__c, Discount_Reference__c, UnitPrice, Outside_Module__c,
                                                             Amendment_Action__c, Quantity, Opportunity.Accountid, Opportunity.CurrencyIsoCode, OpportunityId
                                                        from OpportunityLineItem where OpportunityId  =: OpptyId];
            if(OpptyProduct != null && !OpptyProduct.isEmpty()){
                for(OpportunityLineItem eachOpptyproduct :OpptyProduct){
                    Apttus_Config2__AssetLineItem__c temp_AssetlineItem = new Apttus_Config2__AssetLineItem__c();
                    temp_AssetlineItem.Apttus_Config2__ProductId__c = eachOpptyproduct.Product2Id;
                    temp_AssetlineItem.Apttus_Config2__OptionId__c = eachOpptyproduct.OptionId__c;
                    temp_AssetlineItem.Discount_Reference__c = eachOpptyproduct.Discount_Reference__c;
                    temp_AssetlineItem.CurrencyIsoCode = eachOpptyproduct.Opportunity.CurrencyIsoCode;
                    temp_AssetlineItem.Apttus_Config2__NetPrice__c = eachOpptyproduct.UnitPrice;
                    temp_AssetlineItem.Outside_Module__c = eachOpptyproduct.Outside_Module__c;
                    temp_AssetlineItem.Amendment_Action__c = null;
                    temp_AssetlineItem.Apttus_Config2__AssetStatus__c = 'New';
                    temp_AssetlineItem.Apttus_Config2__Quantity__c = eachOpptyproduct.Quantity;
                    temp_AssetlineItem.Apttus_Config2__AccountId__c = eachOpptyproduct.Opportunity.Accountid;
                    temp_AssetlineItem.Opportunity__c = eachOpptyproduct.OpportunityId;

                    AssetlineItem.add(temp_AssetlineItem);
                }
                
                if(AssetlineItem != null && !AssetlineItem.isEmpty()){
                    try{
                        insert AssetlineItem;
                    } catch(DMLException e){
                        String dmlError = e.getMessage();
                        String dmlStack = e.getStackTraceString();
                        Integer dmlLineNumber = e.getLineNumber();
                        system.debug('Asset creation Error:'+ dmlError+' '+ e.getStackTraceString()+' '+dmlLineNumber);
                    }
                    
                }
            }
        }
        
    }
    
    //Deletes All Apttus Asset for given Opportunity  
    public void DeleteAssetLineItem(Id OpptyId){
        if(OpptyId != null){
            List<Apttus_Config2__AssetLineItem__c> AssetlineItems = [ select Id from Apttus_Config2__AssetLineItem__c where Opportunity__c =: OpptyId ];
            if(AssetlineItems!= null && !AssetlineItems.isEmpty()){
                try{
                    delete AssetlineItems;
                    
                }catch(DMLException e){
                        String dmlError = e.getMessage();
                        String dmlStack = e.getStackTraceString();
                        Integer dmlLineNumber = e.getLineNumber();
                        system.debug('Apttus Asset Deletion Error:'+ dmlError+' '+ e.getStackTraceString()+' '+dmlLineNumber);
                    }
                
            }
        
         }
    }
    
    //Deletes All SFDC Asset for given Opportunity  
    public void DeleteAssets(Id OpptyId){
        if(OpptyId != null){
            List<Asset> assets = [select Id from Asset where Opportunity__c =: OpptyId];
            if(assets!= null && !assets.isEmpty()){
                try{
                    delete assets;
                    
                }catch(DMLException e){
                        String dmlError = e.getMessage();
                        String dmlStack = e.getStackTraceString();
                        Integer dmlLineNumber = e.getLineNumber();
                        system.debug('SFDC Asset Deletion Error:'+ dmlError+' '+ e.getStackTraceString()+' '+dmlLineNumber);
                    }
                
            }
        }
            
    }
    
    //copies Apttus All Asset Records to SFDC Asset for given Opportunity.
    public void cloneAssetLineItemtoSFDCAsset(Id OpptyId){
        List<Asset> assets = new List<Asset>();
        if(OpptyId != null){
            List<Apttus_Config2__AssetLineItem__c> AssetlineItems = [ select Id,
                                                                             Apttus_Config2__ProductId__c,
                                                                             Apttus_Config2__OptionId__c,
                                                                             Discount_Reference__c,
                                                                             CurrencyIsoCode,
                                                                             Apttus_Config2__NetPrice__c,
                                                                             Outside_Module__c,
                                                                             Amendment_Action__c,
                                                                             Apttus_Config2__AssetStatus__c,
                                                                             Apttus_Config2__Quantity__c,
                                                                             Apttus_Config2__AccountId__c,
                                                                             Opportunity__c,
                                                                             Opportunity__r.Name 
                                                                             from Apttus_Config2__AssetLineItem__c
                                                                             where Opportunity__c =: OpptyId ];
            if(AssetlineItems != null && !AssetlineItems.isEmpty()){
                for(Apttus_Config2__AssetLineItem__c eachAssetLineItem: AssetlineItems){
                    Asset temp_asset = new Asset();
                    temp_asset.Name = eachAssetLineItem.Opportunity__r.Name;
                    temp_asset.Product2Id = eachAssetLineItem.Apttus_Config2__ProductId__c;
                    temp_asset.OptionId__c = eachAssetLineItem.Apttus_Config2__OptionId__c;
                    temp_asset.Discount_Reference__c = eachAssetLineItem.Discount_Reference__c;
                    temp_asset.CurrencyIsoCode =  eachAssetLineItem.CurrencyIsoCode;
                    temp_asset.Net_Sales_Price__c =  eachAssetLineItem.Apttus_Config2__NetPrice__c;
                    temp_asset.Outside_Module__c = eachAssetLineItem.Outside_Module__c;
                    temp_asset.Amendment_Action__c = eachAssetLineItem.Amendment_Action__c;
                    if(eachAssetLineItem.Apttus_Config2__AssetStatus__c == 'New'){
                        temp_asset.Status = 'Active';
                    }else {
                         temp_asset.Status = eachAssetLineItem.Apttus_Config2__AssetStatus__c;
                    }
                    
                    temp_asset.Quantity = eachAssetLineItem.Apttus_Config2__Quantity__c;
                    temp_asset.AccountId = eachAssetLineItem.Apttus_Config2__AccountId__c;
                    temp_asset.Opportunity__c = eachAssetLineItem.Opportunity__c;

                     assets.add(temp_asset);
                }
                
            }
            
            if(assets != null && !assets.isEmpty()){
                try{
                    insert assets;
                }catch(DMLException e){
                        String dmlError = e.getMessage();
                        String dmlStack = e.getStackTraceString();
                        Integer dmlLineNumber = e.getLineNumber();
                        system.debug('cloning Asset from Apttus Asset Error:'+ dmlError+' '+ e.getStackTraceString()+' '+dmlLineNumber);
                    }
            }
            
        }
        
    }
   
   // change the product on the Apttus & SFDC Asset for given new campass
    public void ChangeofCampus_Asset(Id AssetId, String newCampus){
        system.debug('newCampus :'+newCampus);
        if(AssetId != null && newCampus != null){
            List<Asset> asset_record = [select Product2Id, Opportunity__c, Product2.Qualification_Name__c, Product2.Qualification_Level_Name__c from Asset where Id =: AssetId limit 1];
            if(asset_record != null && !asset_record.isEmpty()){
                List<Asset> assets = [select Id,
                                             Product2Id,
                                             Product2.Campus__c,
                                             Product2.Qualification_Name__c,
                                             Product2.Qualification_Level_Name__c,
                                             Opportunity__c
                                             from Asset 
                                             where Opportunity__c =:asset_record[0].Opportunity__c and 
                                             Product2Id =:asset_record[0].Product2Id];
                                         
                List<Apttus_Config2__AssetLineItem__c> AssetlineItems = [select Id,
                                                                                Apttus_Config2__ProductId__c, 
                                                                                Apttus_Config2__ProductId__r.Campus__c,
                                                                                Apttus_Config2__ProductId__r.Qualification_Name__c,
                                                                                Apttus_Config2__ProductId__r.Qualification_Level_Name__c  
                                                                                from Apttus_Config2__AssetLineItem__c 
                                                                                where Opportunity__c =: asset_record[0].Opportunity__c and 
                                                                                Apttus_Config2__ProductId__c =:asset_record[0].Product2Id];
                

                String Qualification = asset_record[0].Product2.Qualification_Name__c;
                Decimal Level = asset_record[0].Product2.Qualification_Level_Name__c;
                
                System.debug('Qualification-->'+Qualification +'newCampus-->' +newCampus + 'Level-->'+Level);
                
                Product2 Product_record = [SELECT Id,
                                                  Qualification_Name__c,
                                                  Campus__c,
                                                  Qualification_Level_Name__c
                                                  FROM Product2 
                                                  where Apttus_Config2__ConfigurationType__c ='Bundle' 
                                                  and Qualification_Name__c =: Qualification
                                                  and Campus__c =: newCampus
                                                  and Qualification_Level_Name__c =: Level
                                                  and IsActive = true limit 1]; 
                        
                        
                if(Product_record != null){
                    for(Apttus_Config2__AssetLineItem__c eachAssetlineItems : AssetlineItems){
                        if(Product_record.Id != eachAssetlineItems.Apttus_Config2__ProductId__c){
                            eachAssetlineItems.Apttus_Config2__ProductId__c = Product_record.Id;
                        }
                                    
                    }
                            
                    for(Asset eachasset :assets){
                        if(Product_record.Id != eachasset.Product2Id)
                            eachasset.Product2Id = Product_record.Id;
                    }
                }
                try{
                    update AssetlineItems;
                    update assets;
                }catch(DMLException e){
                    String dmlError = e.getMessage();
                    String dmlStack = e.getStackTraceString();
                    Integer dmlLineNumber = e.getLineNumber();
                    system.debug('Asset update issue :'+ dmlError+' '+ e.getStackTraceString()+' '+dmlLineNumber);
                }
                        
            }
       }
            
   }
      // changes all the Apttus Asset and SFDC Asset status to Cancelled for smiller product on opportunity.
      public void AssetCancelled(Id AssetID){
           if(AssetId != null){
                Asset asset_record = [select Product2Id,
                                             Opportunity__c,
                                             Product2.Qualification_Name__c,
                                             Product2.Qualification_Level_Name__c
                                             from Asset where Id =: AssetId];
                                             
                List<Asset> assets = [select Id,
                                             Product2Id,
                                             Product2.Campus__c,
                                             Product2.Qualification_Name__c,
                                             Product2.Qualification_Level_Name__c,
                                             Opportunity__c,
                                             Status
                                             from Asset 
                                             where Opportunity__c =:asset_record.Opportunity__c and 
                                             Product2Id =:asset_record.Product2Id];
                                             
                List<Apttus_Config2__AssetLineItem__c> AssetlineItems = [ select Id,
                                                                                 Apttus_Config2__ProductId__c, 
                                                                                 Apttus_Config2__ProductId__r.Campus__c,
                                                                                 Apttus_Config2__ProductId__r.Qualification_Name__c,
                                                                                 Apttus_Config2__ProductId__r.Qualification_Level_Name__c,
                                                                                 Apttus_Config2__AssetStatus__c
                                                                                 from Apttus_Config2__AssetLineItem__c 
                                                                                 where Opportunity__c =: asset_record.Opportunity__c and 
                                                                                 Apttus_Config2__ProductId__c =:asset_record.Product2Id];
                                                                                 
              if(assets != null && !assets.isEmpty() && AssetlineItems != null && !AssetlineItems.isEmpty()){
                  for(Asset eachasset :assets){
                        eachasset.Status ='Cancelled';
                  }
                  for(Apttus_Config2__AssetLineItem__c eachAssetlineItems : AssetlineItems){
                      eachAssetlineItems.Apttus_Config2__AssetStatus__c = 'Cancelled';
                  }
              }
              try{
                        update AssetlineItems;
                        update assets;
                    }catch(DMLException e){
                        String dmlError = e.getMessage();
                        String dmlStack = e.getStackTraceString();
                        Integer dmlLineNumber = e.getLineNumber();
                        system.debug('Asset update issue :'+ dmlError+' '+ e.getStackTraceString()+' '+dmlLineNumber);
                    }
           }
          
      }
    // Modify Contract for Amendment asset create compair old and new oppty and create amendment asset
    public void Modify_Asset(Id New_OpptyId){
        system.debug('New_OpptyId  :'+New_OpptyId);
        if(New_OpptyId != null){
            List<Asset> Asset_New = new List<Asset>();
            List<Asset> Asset_Old = new List<Asset>();
            Map<Id,Apttus_Config2__AssetLineItem__c> Updated_AssetLineItem_Old = new Map<Id,Apttus_Config2__AssetLineItem__c>();
            Map<Id,Apttus_Config2__AssetLineItem__c> delete_AssetLineItem_Old = new Map<Id,Apttus_Config2__AssetLineItem__c>();
            Map<Id,Asset>  Updated_Assets_Old = new Map<Id,Asset>();
            Map<Id,Asset>  delete_Assets_Old = new Map<Id,Asset>();
            
            List<Apttus_Config2__AssetLineItem__c> AssetLineItem_new = [select Id,
                                                                               Apttus_Config2__ProductId__c,
                                                                               Apttus_Config2__OptionId__c,
                                                                               Discount_Reference__c,
                                                                               CurrencyIsoCode,
                                                                               Apttus_Config2__NetPrice__c,
                                                                               Outside_Module__c,
                                                                               Amendment_Action__c,
                                                                               Apttus_Config2__AssetStatus__c,
                                                                               Apttus_Config2__Quantity__c,
                                                                               Apttus_Config2__AccountId__c,
                                                                               Opportunity__c, Opportunity__r.Name,
                                                                               Opportunity__r.Related_Opportunity__c
                                                                               from Apttus_Config2__AssetLineItem__c 
                                                                               where Opportunity__c =: New_OpptyId];
                                                                             
           if(AssetLineItem_New != null &&  !AssetLineItem_New.isEmpty() && AssetLineItem_New[0].Opportunity__r.Related_Opportunity__c != null){
             Id Old_OpptyId =   AssetLineItem_New[0].Opportunity__r.Related_Opportunity__c;
             List<Apttus_Config2__AssetLineItem__c> AssetLineItem_old = [select Id,
                                                                                Apttus_Config2__ProductId__c,
                                                                                Apttus_Config2__OptionId__c,
                                                                                Discount_Reference__c,
                                                                                CurrencyIsoCode,
                                                                                Apttus_Config2__NetPrice__c,
                                                                                Outside_Module__c,
                                                                                Amendment_Action__c,
                                                                                Apttus_Config2__AssetStatus__c,
                                                                                Apttus_Config2__Quantity__c,
                                                                                Apttus_Config2__AccountId__c,
                                                                                Opportunity__c, Opportunity__r.Name,
                                                                                Opportunity__r.Related_Opportunity__c
                                                                                from Apttus_Config2__AssetLineItem__c 
                                                                                where Opportunity__c =: Old_OpptyId];
             List<Asset> Assets = [select Id,
                                          Name,
                                          Product2Id,
                                          OptionId__c,
                                          Discount_Reference__c,
                                          CurrencyIsoCode,
                                          Net_Sales_Price__c,
                                          Outside_Module__c,
                                          Amendment_Action__c,
                                          Status,
                                          Quantity,
                                          AccountId,
                                          Opportunity__c
                                          from Asset 
                                          where Opportunity__c =: Old_OpptyId OR Opportunity__c =: New_OpptyId];
                                          
            for(Asset eachAsset : Assets){
               if(eachAsset.Opportunity__c == Old_OpptyId){
                    Asset_Old.add(eachAsset);
               }else if (eachAsset.Opportunity__c == New_OpptyId){
                    Asset_New.add(eachAsset);
               }
            }
            
            if(Asset_Old != null && !Asset_Old.isEmpty() && Asset_New != null && !Asset_New.isEmpty()){
                
                // Asset Line Item Logic.
                for(Apttus_Config2__AssetLineItem__c eachAssetlineItem_Old :AssetLineItem_Old){
                    for(Apttus_Config2__AssetLineItem__c eachAssetlineItem_New :AssetLineItem_New){
                        //system.debug('eachAssetlineItem_Old.Apttus_Config2__ProductId__c :'+eachAssetlineItem_Old.Apttus_Config2__ProductId__c+'eachAssetlineItem_Old.Apttus_Config2__OptionId__c :'+eachAssetlineItem_Old.Apttus_Config2__OptionId__c);
                        //system.debug('eachAssetlineItem_New.Apttus_Config2__ProductId__c :'+eachAssetlineItem_New.Apttus_Config2__ProductId__c+'eachAssetlineItem_New.Apttus_Config2__OptionId__c  :'+eachAssetlineItem_New.Apttus_Config2__OptionId__c);
                        if(eachAssetlineItem_Old.Apttus_Config2__ProductId__c == eachAssetlineItem_New.Apttus_Config2__ProductId__c &&
                           eachAssetlineItem_Old.Apttus_Config2__OptionId__c == eachAssetlineItem_New.Apttus_Config2__OptionId__c){
                               delete_AssetLineItem_Old.put(eachAssetlineItem_Old.ID,eachAssetlineItem_Old);
                               
                           }
                    }
                }
                for(Apttus_Config2__AssetLineItem__c eachAssetlineItem_Old :AssetLineItem_Old){
                    if(delete_AssetLineItem_Old.get(eachAssetlineItem_Old.Id) == null){
                        eachAssetlineItem_Old.Apttus_Config2__AssetStatus__c = 'Cancelled';
                          Updated_AssetLineItem_Old.put(eachAssetlineItem_Old.Id,eachAssetlineItem_Old);
                    }
                }
                
                // Asset records logic 
                for(Asset eachAsset_Old :Asset_Old){
                    for(Asset eachAsset_New :Asset_New){
                        if(eachAsset_Old.Product2Id == eachAsset_New.Product2Id &&
                           eachAsset_Old.OptionId__c == eachAsset_New.OptionId__c){
                               delete_Assets_Old.put(eachAsset_Old.ID,eachAsset_Old);
                               
                           }
                    }
                }
                for(Asset eachAsset_Old :Asset_Old){
                    if(delete_Assets_Old.get(eachAsset_Old.Id) == null){
                        eachAsset_Old.Status = 'Cancelled';
                        Updated_Assets_Old.put(eachAsset_Old.Id,eachAsset_Old);
                    }
                }
                
            }
            
            system.debug('delete_AssetLineItem_Old  :'+delete_AssetLineItem_Old.keyset());
            system.debug('Updated_AssetLineItem_Old :'+Updated_AssetLineItem_Old.keyset());
            system.debug('Updated_Assets_Old :'+Updated_Assets_Old);
            system.debug('delete_Assets_Old  :'+delete_Assets_Old);
            
            try{
                if(delete_AssetLineItem_Old != null && !delete_AssetLineItem_Old.isEmpty()){
                    delete delete_AssetLineItem_Old.values();
                }
                
                if(Updated_AssetLineItem_Old!= null && !Updated_AssetLineItem_Old.isEmpty()){
                    update Updated_AssetLineItem_Old.values();
                }
                if(delete_Assets_Old != null && !delete_Assets_Old.isEmpty()){
                    delete delete_Assets_Old.values();
                }
                if(Updated_Assets_Old != null && !Updated_Assets_Old.isEmpty()){
                    update Updated_Assets_Old.values();
                }
            }catch(DMLException e){
                        String dmlError = e.getMessage();
                        String dmlStack = e.getStackTraceString();
                        Integer dmlLineNumber = e.getLineNumber();
                        system.debug('Asset update issue :'+ dmlError+' '+ e.getStackTraceString()+' '+dmlLineNumber);
                    }

           }
            

        }
        
    }
    
    public void Enrol_Student(Id OpptyId){
        if(OpptyId != null){
             DeleteAssetLineItem(OpptyId);
             DeleteAssets(OpptyId);
             CreateAssetLineItem(OpptyId);
             cloneAssetLineItemtoSFDCAsset(OpptyId);
        }
    }
    
    public void Modify_Contract(Id OpptyId){
        if(OpptyId != null){
            DeleteAssetLineItem(OpptyId);
            DeleteAssets(OpptyId);
            CreateAssetLineItem(OpptyId);
            cloneAssetLineItemtoSFDCAsset(OpptyId);
            Modify_Asset(OpptyId);
        }
        
    }

}