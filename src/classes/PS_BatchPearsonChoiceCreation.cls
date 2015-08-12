global class PS_BatchPearsonChoiceCreation implements Database.Batchable<sObject>{  
  Date dummyDate;
  String sMarket,sBusUnit,sId,sPriceList; 
  Set<Id> setWithProductId = new Set<Id>();
  Map<String,oneCRMPearsonChoicesBrand__c> mapWithBrandValues;
  Map<Id,List<Apttus_Config2__RelatedProduct__c>> pftorpmap=new  Map<Id,List<Apttus_Config2__RelatedProduct__c>>();
  Map<Id,Product2> mapWithPriceListItem;
  List<Apttus_Config2__RelatedProduct__c> rpwithoutbrand = new List<Apttus_Config2__RelatedProduct__c>();
  Set<String> PlatformBrandValidation = new set<String>{'MyLab', 'MyLab + Books a la carte', 'MyLab + Lab Workbook', 'MyLab + Loose-Leaf', 'MyLab + Note Taking Guide', 'MyLab + Print Text', 'MyLab + Student Value Edition', 'MyLab + Workbook', 'MyLab + eText Reference', 'MyLabsPlus', 'MyLabsPlus + Books a la carte', 'MyLabsPlus + Student Value Edition', 'MyKit', 'MyKit + Books a la carte', 'MyKit + Print Text', 'MyKit + Student Value Edition', 'MyKitsPlus', 'MyKitsPlus + Student Value Edition', 'Mastering', 'Mastering + Books a la carte', 'Mastering + Print Text', 'Mastering + Student Value Edition', 'MasteringPlus', 'MasteringPlus + Books a la carte'};
  global PS_BatchPearsonChoiceCreation(String countryName,String businessUnit,String sPrice,String sRecId) 
  {
        try{
            
        mapWithBrandValues = oneCRMPearsonChoicesBrand__c.getall();
            
        sMarket=countryName;
        sBusUnit=businessUnit;
        sId=sRecId;
        sPriceList=sPrice;
        if(Test.isRunningtest()){
        ExceptionFramework.LogException('BatchPearsonChoice','PS_BatchPearsonChoiceCreation','PS_BatchPearsonChoiceCreation','Test Exception',UserInfo.getUserName(),'');
        }
        }
        
        catch(Exception e){
            ExceptionFramework.LogException('BatchPearsonChoice','PS_BatchPearsonChoiceCreation','PS_BatchPearsonChoiceCreation','Exception:'+e+' \n line Number :'+e.getLineNumber()+'\n Stack trace :'+e.getStackTraceString(),UserInfo.getUserName(),'');
        }
  }

  global Database.QueryLocator start(Database.BatchableContext BC) {
  if(Test.isRunningtest()){
          return Database.getQueryLocator([select Id,Name,Relevance_Value__c, (select Id,Apttus_Config2__RelatedProductId__c,Apttus_Config2__RelatedProductId__r.Name,
          Apttus_Config2__RelatedProductId__r.Brand__c,Apttus_Config2__RelatedProductId__r.Relevance_Value__c,Apttus_Config2__RelatedProductId__r.Contains_eText__c,
          Apttus_Config2__RelatedProductId__r.Binding__c,Apttus_Config2__RelatedProductId__r.ISBN__c,
          Apttus_Config2__RelatedProductId__r.SBN__c,Apttus_Config2__RelatedProductId__r.Status__c,Apttus_Config2__RelatedProductId__r.Medium2__c,
          Association_Category__c,Relation_Package__c,Apttus_Config2__RelatedProductId__r.Platform__c,
          Apttus_Config2__RelatedProductId__r.Duration__c,Apttus_Config2__RelatedProductId__r.InstockDate__c,
          Apttus_Config2__RelatedProductId__r.Category2__c,Apttus_Config2__RelatedProductId__r.Accounting_Code__c,
          Apttus_Config2__ProductId__c,Apttus_Config2__ProductId__r.Name, PSELL__c from Apttus_Config2__RelatedProducts__r where
          Apttus_Config2__RelatedProductId__r.Relevance_Value__c >= 10 and Apttus_Config2__RelatedProductId__r.Relevance_Value__c <= 100) 
          from Product2 where Apttus_Config2__ConfigurationType__c =: 'Bundle' And Market__c =:sMarket And Line_of_Business__c = 'Higher Ed' And 
          Business_Unit__c = :sBusUnit and id = :sId and (Relevance_Value__c >=10 and Relevance_Value__c <= 100)
          order by name]);
   }else{
       return Database.getQueryLocator([select Id,Name,Relevance_Value__c
          from Product2 where Apttus_Config2__ConfigurationType__c =: 'Bundle' And Market__c =:sMarket And Line_of_Business__c = 'Higher Ed' And 
          Business_Unit__c = :sBusUnit and (Relevance_Value__c >=10 and Relevance_Value__c <= 100)
          //and id in ('01tg0000002YEM7','01tg0000002YmOXAA0') 
          //and id in ('01t11000003RIagAAG') 
          order by name]);
    }
  }
   
  global void execute(Database.BatchableContext BC,List<Product2> productList) {
      //system.debug('Inside execute:'+productList.size());
      InitProcessMaps(productList);
      PearsonChoiceCreation();    
  }//end execute method
  
  global void finish(Database.BatchableContext BC) {
     /* List<PS_ExceptionLogger__c> errloggerlist=new List<PS_ExceptionLogger__c>();
      try{            
          if (upresult != null){
          for (Database.UpsertResult sr : upresult) {
          String ErrMsg='';
          if (!sr.isSuccess()){              
                  PS_ExceptionLogger__c errlogger=new PS_ExceptionLogger__c();
                  errlogger.InterfaceName__c='BatchPearsonChoice';
                  errlogger.ApexClassName__c='PS_BatchPearsonChoiceCreation';
                  errlogger.CallingMethod__c='finish';
                  errlogger.UserLogin__c=UserInfo.getUserName(); 
                  for(Database.Error err : sr.getErrors()) {
                  ErrMsg=ErrMsg+err.getStatusCode() + ': ' + err.getMessage(); 
                  }
                  errloggerlist.add(errlogger);                    
           }
           }
           if(errloggerlist.size()>0){insert errloggerlist;}
           }
       }
       catch(DMLException e){
           throw(e);
       }   */    
  }
  
  //Method for PearsonChoice Creation Logic  
  public void PearsonChoiceCreation(){
      id errorprodid;
      try{
      List<Pearson_Choice__c> listFinalPearsonChoices = new List<Pearson_Choice__c>();   
      List<Pearson_Choice__c> listWithNewPearsonChoices = new List<Pearson_Choice__c>();   
      List<Pearson_Choice__c> listtmpPearsonChoices = new List<Pearson_Choice__c>();   
      List<Apttus_Config2__RelatedProduct__c> relatedProductList = new List<Apttus_Config2__RelatedProduct__c>();
      Integer removeRelatedProductId;
      List<Integer> listWithRemoveRelatedProductId = new List<Integer>();
      Pearson_Choice__c newMasterProd;
      List<Apttus_Config2__RelatedProduct__c> dummylistWithRelatedProduct = new List<Apttus_Config2__RelatedProduct__c>();
      String MainTitlePlatform;
      for(Id pf:pftorpmap.keyset()){
          errorprodid = pf;
          newMasterProd = null;
          MainTitlePlatform = null;
          listtmpPearsonChoices.clear();
          listWithRemoveRelatedProductId.clear();
          listWithNewPearsonChoices.clear();
          relatedProductList.clear();
          removeRelatedProductId = 0;
          relatedProductList = pftorpmap.get(pf)!=null?pftorpmap.get(pf):dummylistWithRelatedProduct ;
           
          for(Apttus_Config2__RelatedProduct__c relatedProd : relatedProductList) {
              if(relatedProd.PSELL__c){
                  MainTitlePlatform = relatedProd.Apttus_Config2__RelatedProductId__r.Platform__c;
              }
          }
          
          //Scenario -1: Price to Bookstore creation
          for(Apttus_Config2__RelatedProduct__c relatedProd : relatedProductList) {
             //added code to execute for test class
             if(((relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c == 'MyLab' || 
             relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c == 'Mastering' || 
             relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c == 'MyKit'|| 
             relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c == 'Pearson eText' || 
             relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c == 'REVEL') && 
             (relatedProd.Apttus_Config2__RelatedProductId__r.Binding__c == 'Access Code Card' || 
             relatedProd.Apttus_Config2__RelatedProductId__r.Binding__c == 'Access Card Package') && 
             (relatedProd.Association_Category__c == 'Student Supplement' || relatedProd.Association_Category__c == 'Alternate Binding' || relatedProd.Association_Category__c == 'Main Title')) &&
             (MainTitlePlatform == null || !(PlatformBrandValidation.contains(relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c) && relatedProd.Apttus_Config2__RelatedProductId__r.Platform__c != MainTitlePlatform) ))             
             {
                    newMasterProd = new Pearson_Choice__c();
                    newMasterProd.Brand__c = relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c;
                    if(mapWithBrandValues.get(relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c) != null &&
                        (mapWithBrandValues.get(relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c).Offer_Type__c == 'Learning Application + Text' ||
                         mapWithBrandValues.get(relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c).Offer_Type__c == 'Learning Application' ||
                         mapWithBrandValues.get(relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c).Offer_Type__c == 'Special Offer Type Rule')){
                             newMasterProd.Includes_Pearon_eText__c = (relatedProd.Apttus_Config2__RelatedProductId__r.Contains_eText__c==True?'with eText':'no eText');
                        }
                   
                    newMasterProd.Access_Length__c = relatedProd.Apttus_Config2__RelatedProductId__r.Duration__c;
                    newMasterProd.Bookstore_ISBN_s__c = relatedProd.Apttus_Config2__RelatedProductId__r.SBN__c+'<br/>'+relatedProd.Apttus_Config2__RelatedProductId__r.ISBN__c+'<br/>'+(relatedProd.Apttus_Config2__RelatedProductId__c != null && relatedProd.Apttus_Config2__RelatedProductId__r.InstockDate__c!=null?DateTime.newInstance(relatedProd.Apttus_Config2__RelatedProductId__r.InstockDate__c.year(), relatedProd.Apttus_Config2__RelatedProductId__r.InstockDate__c.month(), relatedProd.Apttus_Config2__RelatedProductId__r.InstockDate__c.day()).format('MM/dd/yyyy'):' ')+' '+relatedProd.Apttus_Config2__RelatedProductId__r.Status__c;
                    newMasterProd.Product_Family__c = relatedProd.Apttus_Config2__ProductId__c;
                    newMasterProd.Platform__c = relatedProd.Apttus_Config2__RelatedProductId__r.Platform__c;
                    newMasterProd.Bookstore__c = relatedProd.Apttus_Config2__RelatedProductId__c;
                    
                    if(mapWithPriceListItem.get(relatedProd.Apttus_Config2__RelatedProductId__c) != null){
                        if(mapWithPriceListItem.get(relatedProd.Apttus_Config2__RelatedProductId__c).Apttus_Config2__PriceLists__r.size()>0)
                             newMasterProd.Bookstore_Price__c = mapWithPriceListItem.get(relatedProd.Apttus_Config2__RelatedProductId__c).
                                                                Apttus_Config2__PriceLists__r[0].Net_Price__c;
                         else 
                             newMasterProd.Bookstore_Price__c = 0.0;
                    }
                    else 
                         newMasterProd.Bookstore_Price__c = 0.0;
                     
                    if(mapWithBrandValues.get(relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c) != null)
                        newMasterProd.Offer_Type__c = mapWithBrandValues.get(relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c).Offer_Type__c=='Special Offer Type Rule'?(newMasterProd.Includes_Pearon_eText__c=='with eText'?'Learning Application + Text':'Learning Application'):mapWithBrandValues.get(relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c).Offer_Type__c;
                    if(mapWithBrandValues.get(relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c) != null)
                        newMasterProd.Sequence__c = mapWithBrandValues.get(relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c).Offer_Type_Sequence__c == 0?(newMasterProd.Includes_Pearon_eText__c=='with eText'?1:2):mapWithBrandValues.get(relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c).Offer_Type_Sequence__c;
                    listWithNewPearsonChoices.add(newMasterProd);
                    listWithRemoveRelatedProductId.add(removeRelatedProductId);
              } //end if block for scenario 1    
              removeRelatedProductId = removeRelatedProductId + 1;   
            }
            //System.debug('After scenario 1 to remove:'+listWithRemoveRelatedProductId);
            //system.debug('After scenario -1....size for '+pf+':'+listWithNewPearsonChoices.size());  
            listWithRemoveRelatedProductId.sort();
            for(Integer i=listWithRemoveRelatedProductId.size()-1;i>=0;i--){     
                  if(listWithRemoveRelatedProductId[i]<relatedProductList.size()){
                        relatedProductList.remove(listWithRemoveRelatedProductId[i]);}
            }//end for loop to init remove list
            
            listtmpPearsonChoices.clear();
            listWithRemoveRelatedProductId.clear();
            removeRelatedProductId = 0;
       
            
            //Scenrio -2 : Instant Access with Rules
          
            listtmpPearsonChoices.addall(listWithNewPearsonChoices);
            for(Apttus_Config2__RelatedProduct__c relatedProd : relatedProductList){ 
                if(((relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c == 'MyLab' || relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c == 'Mastering' 
                || relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c == 'MyKit'|| relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c == 'Pearson eText' 
                || relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c == 'REVEL') && 
                (relatedProd.Apttus_Config2__RelatedProductId__r.Binding__c == 'Website' || relatedProd.Apttus_Config2__RelatedProductId__r.Binding__c == 'On-line Supplement' || 
                relatedProd.Apttus_Config2__RelatedProductId__r.Binding__c == 'Electronic Package' || relatedProd.Apttus_Config2__RelatedProductId__r.Binding__c == 'Electronic Book') && 
                (relatedProd.Association_Category__c == 'Premium Website' || 
                relatedProd.Association_Category__c == 'CourseCompass' || relatedProd.Association_Category__c == 'WebCT' || 
                relatedProd.Association_Category__c == 'Blackboard' || relatedProd.Association_Category__c == 'ECollege' || 
                relatedProd.Association_Category__c == 'eBook+ (standalone)')) &&
                (MainTitlePlatform == null || !(PlatformBrandValidation.contains(relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c) && relatedProd.Apttus_Config2__RelatedProductId__r.Platform__c != MainTitlePlatform) )
                ){
                    //System.debug('Matching with scenario 2:'+relatedProd.Id+';'+relatedProd.Association_Category__c);
                    boolean updatematch=false;
                    if(listtmpPearsonChoices!= null){
                        for(Pearson_Choice__c pearsonChoice : listtmpPearsonChoices){
                                if((pearsonChoice.Access_Length__c == relatedProd.Apttus_Config2__RelatedProductId__r.Duration__c && 
                                    pearsonChoice.Brand__c == relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c && 
                                    pearsonChoice.Platform__c == relatedProd.Apttus_Config2__RelatedProductId__r.Platform__c && 
                                    ((pearsonChoice.Includes_Pearon_eText__c == 'with eText' && relatedProd.Apttus_Config2__RelatedProductId__r.Contains_eText__c == true) || 
                                    (pearsonChoice.Includes_Pearon_eText__c == 'no eText' && relatedProd.Apttus_Config2__RelatedProductId__r.Contains_eText__c == false))) 
                                    ) {
                                    //System.debug('Match Found');
                                    if(pearsonChoice.Instant_Access__c == null){
                                        pearsonChoice.Instant_Access__c = relatedProd.Apttus_Config2__RelatedProductId__c;
                                        //pearsonChoice.Instant_Access_Price__c = (mapWithPriceListItem.get(relatedProd.Apttus_Config2__RelatedProductId__c) !=null  && mapWithPriceListItem.get(relatedProd.Apttus_Config2__RelatedProductId__c).Apttus_Config2__PriceLists__r.size()>0)?
                                          //                              mapWithPriceListItem.get(relatedProd.Apttus_Config2__RelatedProductId__c).Apttus_Config2__PriceLists__r[0].Net_Price__c:0.0;
                                        if(mapWithPriceListItem.get(relatedProd.Apttus_Config2__RelatedProductId__c) != null){
                                            if(mapWithPriceListItem.get(relatedProd.Apttus_Config2__RelatedProductId__c).Apttus_Config2__PriceLists__r.size()>0)
                                                 pearsonChoice.Instant_Access_Price__c = mapWithPriceListItem.get(relatedProd.Apttus_Config2__RelatedProductId__c).
                                                                                         Apttus_Config2__PriceLists__r[0].Net_Price__c;
                                             else 
                                                 pearsonChoice.Instant_Access_Price__c = 0.0;
                                        }
                                        else 
                                             pearsonChoice.Instant_Access_Price__c = 0.0;                                          
                                        listWithRemoveRelatedProductId.add(removeRelatedProductId);
                                        updatematch = true;   
                                        break; 
                                    }else{ // check if the price is grater then 
                                         if(mapWithPriceListItem.get(relatedProd.Apttus_Config2__RelatedProductId__c) !=null && pearsonChoice.Instant_Access_Price__c < mapWithPriceListItem.get(relatedProd.Apttus_Config2__RelatedProductId__c).Apttus_Config2__PriceLists__r[0].Net_Price__c ){
                                             pearsonChoice.Instant_Access__c = relatedProd.Apttus_Config2__RelatedProductId__c;
                                             //pearsonChoice.Instant_Access_Price__c = (mapWithPriceListItem.get(relatedProd.Apttus_Config2__RelatedProductId__c) !=null  && mapWithPriceListItem.get(relatedProd.Apttus_Config2__RelatedProductId__c).Apttus_Config2__PriceLists__r.size()>0)?
                                               //                         mapWithPriceListItem.get(relatedProd.Apttus_Config2__RelatedProductId__c).Apttus_Config2__PriceLists__r[0].Net_Price__c:0.0;
                                         if(mapWithPriceListItem.get(relatedProd.Apttus_Config2__RelatedProductId__c) != null){
                                             if(mapWithPriceListItem.get(relatedProd.Apttus_Config2__RelatedProductId__c).Apttus_Config2__PriceLists__r.size()>0)
                                                 pearsonChoice.Instant_Access_Price__c = mapWithPriceListItem.get(relatedProd.Apttus_Config2__RelatedProductId__c).Apttus_Config2__PriceLists__r[0].Net_Price__c;
                                             else 
                                                 pearsonChoice.Instant_Access_Price__c = 0.0;
                                         }
                                         else 
                                             pearsonChoice.Instant_Access_Price__c = 0.0;                                               
                                         listWithRemoveRelatedProductId.add(removeRelatedProductId);
                                         updatematch = true;   
                                         break;
                                         }else {//if the price is already greater then just remove
                                             listWithRemoveRelatedProductId.add(removeRelatedProductId);
                                             updatematch = true;   
                                             break;
                                         }
                                    }
                                                                                                       
                                }//update match scenario
                            }
                        }//end for loop PC
                   // }//end if PC
                    if(!updatematch 
                    ){//insert
                        //System.debug('Match not Found');
                        newMasterProd = new Pearson_Choice__c();
                        newMasterProd.Brand__c = relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c;
                        if(mapWithBrandValues.get(relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c) != null &&
                          (mapWithBrandValues.get(relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c).Offer_Type__c == 'Learning Application + Text' ||
                           mapWithBrandValues.get(relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c).Offer_Type__c == 'Learning Application' ||
                           mapWithBrandValues.get(relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c).Offer_Type__c == 'Special Offer Type Rule')){
                            newMasterProd.Includes_Pearon_eText__c = (relatedProd.Apttus_Config2__RelatedProductId__r.Contains_eText__c==True?'with eText':'no eText');
                        }
                        newMasterProd.Access_Length__c = relatedProd.Apttus_Config2__RelatedProductId__r.Duration__c;
                        newMasterProd.Bookstore_ISBN_s__c = relatedProd.Apttus_Config2__RelatedProductId__r.SBN__c+'<br/>'+relatedProd.Apttus_Config2__RelatedProductId__r.ISBN__c+'<br/>'+(relatedProd.Apttus_Config2__RelatedProductId__c != null && relatedProd.Apttus_Config2__RelatedProductId__r.InstockDate__c!=null?DateTime.newInstance(relatedProd.Apttus_Config2__RelatedProductId__r.InstockDate__c.year(), relatedProd.Apttus_Config2__RelatedProductId__r.InstockDate__c.month(), relatedProd.Apttus_Config2__RelatedProductId__r.InstockDate__c.day()).format('MM/dd/yyyy'):' ')+' '+relatedProd.Apttus_Config2__RelatedProductId__r.Status__c;
                        newMasterProd.Product_Family__c = relatedProd.Apttus_Config2__ProductId__c;
                        newMasterProd.Platform__c = relatedProd.Apttus_Config2__RelatedProductId__r.Platform__c;
                        newMasterProd.Instant_Access__c = relatedProd.Apttus_Config2__RelatedProductId__c;
                        
                        //newMasterProd.Instant_Access_Price__c = (mapWithPriceListItem.get(relatedProd.Apttus_Config2__RelatedProductId__c) !=null  && mapWithPriceListItem.get(relatedProd.Apttus_Config2__RelatedProductId__c).Apttus_Config2__PriceLists__r.size()>0)?
                          //                                      mapWithPriceListItem.get(relatedProd.Apttus_Config2__RelatedProductId__c).Apttus_Config2__PriceLists__r[0].Net_Price__c:0.0;
                        //newMasterProd.Instant_Access_Price__c = mapWithPriceListItem.get(relatedProd.Apttus_Config2__RelatedProductId__c);
                        if(mapWithPriceListItem.get(relatedProd.Apttus_Config2__RelatedProductId__c) != null){
                            if(mapWithPriceListItem.get(relatedProd.Apttus_Config2__RelatedProductId__c).Apttus_Config2__PriceLists__r.size()>0)
                                 newMasterProd.Instant_Access_Price__c = mapWithPriceListItem.get(relatedProd.Apttus_Config2__RelatedProductId__c).
                                                                Apttus_Config2__PriceLists__r[0].Net_Price__c;
                             else 
                                 newMasterProd.Instant_Access_Price__c = 0.0;
                        }
                        else 
                             newMasterProd.Instant_Access_Price__c = 0.0;                        
                        if(mapWithBrandValues.get(relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c) != null)
                            newMasterProd.Offer_Type__c = mapWithBrandValues.get(relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c).Offer_Type__c=='Special Offer Type Rule'?(newMasterProd.Includes_Pearon_eText__c=='with eText'?'Learning Application + Text':'Learning Application'):mapWithBrandValues.get(relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c).Offer_Type__c;
                        if(mapWithBrandValues.get(relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c) != null)
                            newMasterProd.Sequence__c = mapWithBrandValues.get(relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c).Offer_Type_Sequence__c == 0?(newMasterProd.Includes_Pearon_eText__c=='with eText'?1:2):mapWithBrandValues.get(relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c).Offer_Type_Sequence__c;
                        listWithNewPearsonChoices.add(newMasterProd);
                        listWithRemoveRelatedProductId.add(removeRelatedProductId);                        
                    }
                   
                }//end if insta access rules
                removeRelatedProductId = removeRelatedProductId + 1;
            }//end for loop
            //System.debug('After scenario 2 to remove:'+listWithRemoveRelatedProductId);
            //System.debug('After scenario 2:'+listWithNewPearsonChoices.size());           
            listWithRemoveRelatedProductId.sort();
            for(Integer i=listWithRemoveRelatedProductId.size()-1;i>=0;i--){     
                if(listWithRemoveRelatedProductId[i]<relatedProductList.size()){
                     relatedProductList.remove(listWithRemoveRelatedProductId[i]);}
            }
            
            listtmpPearsonChoices.clear();
            listWithRemoveRelatedProductId.clear();
            removeRelatedProductId = 0;
            
            //Scenario -3: Insta access without rules
            for(Apttus_Config2__RelatedProduct__c relatedProd : relatedProductList){
                if(relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c == 'CourseSmart' || relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c == 'Safari' || 
                    relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c == 'Inkling'
                    ){
                    newMasterProd = new Pearson_Choice__c();
                    newMasterProd.Brand__c = relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c;
                    if(mapWithBrandValues.get(relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c) != null &&
                        (mapWithBrandValues.get(relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c).Offer_Type__c == 'Learning Application + Text' ||
                         mapWithBrandValues.get(relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c).Offer_Type__c == 'Learning Application' ||
                         mapWithBrandValues.get(relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c).Offer_Type__c == 'Special Offer Type Rule')){
                             newMasterProd.Includes_Pearon_eText__c = (relatedProd.Apttus_Config2__RelatedProductId__r.Contains_eText__c==True?'with eText':'no eText');
                    }
                    newMasterProd.Access_Length__c = relatedProd.Apttus_Config2__RelatedProductId__r.Duration__c;
                    newMasterProd.Bookstore_ISBN_s__c = relatedProd.Apttus_Config2__RelatedProductId__r.SBN__c+'<br/>'+relatedProd.Apttus_Config2__RelatedProductId__r.ISBN__c+'<br/>'+(relatedProd.Apttus_Config2__RelatedProductId__c != null && relatedProd.Apttus_Config2__RelatedProductId__r.InstockDate__c!=null?DateTime.newInstance(relatedProd.Apttus_Config2__RelatedProductId__r.InstockDate__c.year(), relatedProd.Apttus_Config2__RelatedProductId__r.InstockDate__c.month(), relatedProd.Apttus_Config2__RelatedProductId__r.InstockDate__c.day()).format('MM/dd/yyyy'):' ')+' '+relatedProd.Apttus_Config2__RelatedProductId__r.Status__c;
                    newMasterProd.Product_Family__c = relatedProd.Apttus_Config2__ProductId__c;
                    newMasterProd.Platform__c = relatedProd.Apttus_Config2__RelatedProductId__r.Platform__c;
                    newMasterProd.Instant_Access__c = relatedProd.Apttus_Config2__RelatedProductId__c;
                    //newMasterProd.Instant_Access_Price__c = mapWithPriceListItem.get(relatedProd.Apttus_Config2__RelatedProductId__c);
                    
                    //newMasterProd.Instant_Access_Price__c = (mapWithPriceListItem.get(relatedProd.Apttus_Config2__RelatedProductId__c) !=null && mapWithPriceListItem.get(relatedProd.Apttus_Config2__RelatedProductId__c).Apttus_Config2__PriceLists__r.size()>0)
                      //                                      ? mapWithPriceListItem.get(relatedProd.Apttus_Config2__RelatedProductId__c).Apttus_Config2__PriceLists__r[0].Net_Price__c:0.0;
                    if(mapWithPriceListItem.get(relatedProd.Apttus_Config2__RelatedProductId__c) != null){
                        if(mapWithPriceListItem.get(relatedProd.Apttus_Config2__RelatedProductId__c).Apttus_Config2__PriceLists__r.size()>0)
                             newMasterProd.Instant_Access_Price__c = mapWithPriceListItem.get(relatedProd.Apttus_Config2__RelatedProductId__c).
                                                                Apttus_Config2__PriceLists__r[0].Net_Price__c;
                         else 
                             newMasterProd.Instant_Access_Price__c = 0.0;
                    }
                    else 
                         newMasterProd.Instant_Access_Price__c= 0.0;                      
                    if(mapWithBrandValues.get(relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c) != null)
                        newMasterProd.Offer_Type__c = mapWithBrandValues.get(relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c).Offer_Type__c=='Special Offer Type Rule'?(newMasterProd.Includes_Pearon_eText__c=='with eText'?'Learning Application + Text':'Learning Application'):mapWithBrandValues.get(relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c).Offer_Type__c;
                    if(mapWithBrandValues.get(relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c) != null)
                        newMasterProd.Sequence__c = mapWithBrandValues.get(relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c).Offer_Type_Sequence__c == 0?(newMasterProd.Includes_Pearon_eText__c=='with eText'?1:2):mapWithBrandValues.get(relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c).Offer_Type_Sequence__c;
                    listWithNewPearsonChoices.add(newMasterProd);
                    listWithRemoveRelatedProductId.add(removeRelatedProductId);
                }//end match  -3
                removeRelatedProductId = removeRelatedProductId + 1;
            }//end for loop -3
            //System.debug('After scenario 3 to remove:'+listWithRemoveRelatedProductId);           
            //System.debug('After scenario 3:'+listWithNewPearsonChoices.size());           
            listWithRemoveRelatedProductId.sort();
            for(Integer i=listWithRemoveRelatedProductId.size()-1;i>=0;i--){     
                if(listWithRemoveRelatedProductId[i]<relatedProductList.size()){
                    //system.debug('Remove list in 3:'+ relatedProductList[listWithRemoveRelatedProductId[i]]);
                   relatedProductList.remove(listWithRemoveRelatedProductId[i]);
                }
            }
            listtmpPearsonChoices.clear();
            listWithRemoveRelatedProductId.clear();
            removeRelatedProductId = 0;
          
            system.debug( '4 - steps');
            //scenario -4:ETEXT Offer
            for(Apttus_Config2__RelatedProduct__c relatedProd : relatedProductList){
                //system.debug(relatedProd.Apttus_Config2__RelatedProductId__c+';'+relatedProd.Apttus_Config2__RelatedProductId__r.Binding__c +';'+relatedProd.Apttus_Config2__RelatedProductId__r.Accounting_Code__c);
                //system.debug('check accounting '+(relatedProd.Apttus_Config2__RelatedProductId__r.Accounting_Code__c!=''?relatedProd.Apttus_Config2__RelatedProductId__r.Accounting_Code__c:'test').contains('J'));
                if( relatedProd.Apttus_Config2__RelatedProductId__r.Binding__c == 'Electronic Book' && 
                    relatedProd.Apttus_Config2__RelatedProductId__r.Category2__c == 'eBook+ upgrade (component)' && 
                    ((relatedProd.Apttus_Config2__RelatedProductId__r.Accounting_Code__c!=''?relatedProd.Apttus_Config2__RelatedProductId__r.Accounting_Code__c:'test').contains('J') || 
                     (relatedProd.Apttus_Config2__RelatedProductId__r.Accounting_Code__c!=''?relatedProd.Apttus_Config2__RelatedProductId__r.Accounting_Code__c:'test').contains('D') ||
                     (relatedProd.Apttus_Config2__RelatedProductId__r.Accounting_Code__c!=''?relatedProd.Apttus_Config2__RelatedProductId__r.Accounting_Code__c:'test').contains('L') ||
                     (relatedProd.Apttus_Config2__RelatedProductId__r.Accounting_Code__c!=''?relatedProd.Apttus_Config2__RelatedProductId__r.Accounting_Code__c:'test').contains('Q') ||
                     (relatedProd.Apttus_Config2__RelatedProductId__r.Accounting_Code__c!=''?relatedProd.Apttus_Config2__RelatedProductId__r.Accounting_Code__c:'test').contains('G') ||
                     (relatedProd.Apttus_Config2__RelatedProductId__r.Accounting_Code__c!=''?relatedProd.Apttus_Config2__RelatedProductId__r.Accounting_Code__c:'test').contains('R-86')) &&
                     relatedProd.Apttus_Config2__RelatedProductId__r.Platform__c == 'eBook+ Upgrade' 
                 )
                {
                    if(listWithNewPearsonChoices != null){
                        for(Pearson_Choice__c pearsonChoice : listWithNewPearsonChoices){
                            if(pearsonChoice.eText_Offer__c == null && pearsonChoice.Brand__c != null &&
                               (pearsonChoice.Brand__c.contains('MyLab') || pearsonChoice.Brand__c.contains('Mastering') || pearsonChoice.Brand__c.contains('MyKit') ) && pearsonChoice.Includes_Pearon_eText__c == 'no eText' ) 
                            {
                                //System.debug('Match found for 4');
                                pearsonChoice.eText_Offer__c = relatedProd.Apttus_Config2__RelatedProductId__c;
                                
                                //pearsonChoice.eText_Offer_Price__c = (mapWithPriceListItem.get(relatedProd.Apttus_Config2__RelatedProductId__c)!=null && mapWithPriceListItem.get(relatedProd.Apttus_Config2__RelatedProductId__c).Apttus_Config2__PriceLists__r.size()>0)
                                  //                                   ?mapWithPriceListItem.get(relatedProd.Apttus_Config2__RelatedProductId__c).Apttus_Config2__PriceLists__r[0].Net_Price__c:0.0;
                                if(mapWithPriceListItem.get(relatedProd.Apttus_Config2__RelatedProductId__c) != null){
                                    if(mapWithPriceListItem.get(relatedProd.Apttus_Config2__RelatedProductId__c).Apttus_Config2__PriceLists__r.size()>0)
                                         pearsonChoice.eText_Offer_Price__c = mapWithPriceListItem.get(relatedProd.Apttus_Config2__RelatedProductId__c).
                                                                            Apttus_Config2__PriceLists__r[0].Net_Price__c;
                                    else 
                                         pearsonChoice.eText_Offer_Price__c = 0.0;
                                }
                                else 
                                         pearsonChoice.eText_Offer_Price__c = 0.0;                                  
                                
                            }//end update if                          
                        }//end for loop
                        
                    }//end exist list if
                    listWithRemoveRelatedProductId.add(removeRelatedProductId);
                }//end match for -4
                removeRelatedProductId = removeRelatedProductId + 1;
            }//end for loop scenario-4
            //System.debug('After scenario 4 to remove:'+listWithRemoveRelatedProductId);           
           // System.debug('After scenario 4:'+listWithNewPearsonChoices.size());           
            listWithRemoveRelatedProductId.sort();
            for(Integer i=listWithRemoveRelatedProductId.size()-1;i>=0;i--){     
                if(listWithRemoveRelatedProductId[i]<relatedProductList.size()){
                   relatedProductList.remove(listWithRemoveRelatedProductId[i]);
                }
            }
            listtmpPearsonChoices.clear();
            listWithRemoveRelatedProductId.clear();
            removeRelatedProductId = 0;
            //Scenario-5: Print Offer
            //for(Apttus_Config2__RelatedProduct__c relatedProd : rpwithoutbrand){
            for(Apttus_Config2__RelatedProduct__c relatedProd : relatedProductList){
                system.debug(relatedProd.Apttus_Config2__RelatedProductId__c+';'+removeRelatedProductId+';'+relatedProd.Apttus_Config2__RelatedProductId__r.Binding__c);
                if( relatedProd.Apttus_Config2__RelatedProductId__r.Binding__c == 'Unbound (Saleable)' && 
                    relatedProd.Apttus_Config2__RelatedProductId__r.Category2__c == 'Special Item' &&  
                    relatedProd.Apttus_Config2__RelatedProductId__r.Platform__c == 'Print Offer'
                    && (relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c=='' || relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c==null))
                {                    
                    if(listWithNewPearsonChoices != null){
                        for(Pearson_Choice__c pearsonChoice : listWithNewPearsonChoices){
                            if(pearsonChoice.Print_Offer__c == null &&
                               (pearsonChoice.Brand__c == 'MyLab' || pearsonChoice.Brand__c == 'Mastering' || pearsonChoice.Brand__c == 'MyKit') ) 
                            {
                            //system.debug('Print offer Match found');
                                pearsonChoice.Print_Offer__c = relatedProd.Apttus_Config2__RelatedProductId__c;
                                
                                if(mapWithPriceListItem.get(relatedProd.Apttus_Config2__RelatedProductId__c) != null){
                                    if(mapWithPriceListItem.get(relatedProd.Apttus_Config2__RelatedProductId__c).Apttus_Config2__PriceLists__r.size()>0)
                                        pearsonChoice.Print_Offer_Price__c = mapWithPriceListItem.get(relatedProd.Apttus_Config2__RelatedProductId__c).Apttus_Config2__PriceLists__r[0].Net_Price__c;
                                    else
                                        pearsonChoice.Print_Offer_Price__c = 0.0;   
                                }
                                else
                                    pearsonChoice.Print_Offer_Price__c = 0.0;
                            }//end update if                          
                        }//end for loop
                    }//end exist list if
                    listWithRemoveRelatedProductId.add(removeRelatedProductId);
                }//end match-5               
                removeRelatedProductId = removeRelatedProductId + 1;                
            }//end for loop -5
            //System.debug('After scenario 5 to remove:'+listWithRemoveRelatedProductId);           
           // System.debug('After scenario 5:'+listWithNewPearsonChoices.size());                        
            listWithRemoveRelatedProductId.sort();
            for(Integer i=listWithRemoveRelatedProductId.size()-1;i>=0;i--){     
                if(listWithRemoveRelatedProductId[i]<relatedProductList.size()){
                   relatedProductList.remove(listWithRemoveRelatedProductId[i]);
                }
            }       
            listtmpPearsonChoices.clear();
            listWithRemoveRelatedProductId.clear();
            removeRelatedProductId = 0;  
            
            //system.debug('6- step');
            //scenario -6: PCL
            for(Apttus_Config2__RelatedProduct__c relatedProd : relatedProductList){
                //system.debug(relatedProd.Apttus_Config2__RelatedProductId__c + ';'+ relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c);
                if(relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c == 'Pearson Custom Library (PCL)' 
                ){
                    newMasterProd = new Pearson_Choice__c();
                    newMasterProd.Brand__c = 'Pearson Custom Library :'+relatedProd.Apttus_Config2__ProductId__r.Name;
                    newMasterProd.Product_Family__c = relatedProd.Apttus_Config2__ProductId__c;
                    newMasterProd.Bookstore__c = relatedProd.Apttus_Config2__RelatedProductId__c;
                    newMasterProd.Offer_Type__c = mapWithBrandValues.get('Pearson Custom Library (PCL)').Offer_Type__c;
                    newMasterProd.Sequence__c = mapWithBrandValues.get('Pearson Custom Library (PCL)').Offer_Type_Sequence__c;
                    listWithNewPearsonChoices.add(newMasterProd);                
                    listWithRemoveRelatedProductId.add(removeRelatedProductId);
                }//end if match -6
                removeRelatedProductId = removeRelatedProductId + 1;
            }//end loop - 6
           // System.debug('After scenario 6:'+listWithNewPearsonChoices.size());                       
          //System.debug('After scenario 6 to remove:'+listWithRemoveRelatedProductId);                       
            listWithRemoveRelatedProductId.sort();
            for(Integer i=listWithRemoveRelatedProductId.size()-1;i>=0;i--){     
                if(listWithRemoveRelatedProductId[i]<relatedProductList.size()){
                   relatedProductList.remove(listWithRemoveRelatedProductId[i]);
                }
            }
            listtmpPearsonChoices.clear();
            listWithRemoveRelatedProductId.clear();
            removeRelatedProductId = 0;
            
            //scenario -7:Remaining           
                
            for(Apttus_Config2__RelatedProduct__c relatedProd : relatedProductList){
                system.debug(relatedProd.Apttus_Config2__RelatedProductId__c);
                if ((!relatedProd.Relation_Package__c) &&
                    (relatedProd.Association_Category__c != 'Previous Edition' &&
                    relatedProd.Association_Category__c != 'Premium Item' &&
                    relatedProd.Association_Category__c != 'Premium Website' &&
                    relatedProd.Association_Category__c != 'eBook+ upgrade (component)' &&
                    relatedProd.Association_Category__c != 'Special Item' &&
                    relatedProd.Association_Category__c != 'Component Item'
                    && (relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c != '' && relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c != null)) &&
                    (MainTitlePlatform == null || !(PlatformBrandValidation.contains(relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c) && relatedProd.Apttus_Config2__RelatedProductId__r.Platform__c != MainTitlePlatform) )
                    ){
                        newMasterProd = new Pearson_Choice__c();
                        newMasterProd.Brand__c = relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c;
                        
                        if(mapWithBrandValues.get(relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c) != null &&
                          (mapWithBrandValues.get(relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c).Offer_Type__c == 'Learning Application + Text' ||
                           mapWithBrandValues.get(relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c).Offer_Type__c == 'Learning Application' ||
                           mapWithBrandValues.get(relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c).Offer_Type__c == 'Special Offer Type Rule')){
                           newMasterProd.Includes_Pearon_eText__c = (relatedProd.Apttus_Config2__RelatedProductId__r.Contains_eText__c==True?'with eText':'no eText');
                        }
                        
                        newMasterProd.Access_Length__c = relatedProd.Apttus_Config2__RelatedProductId__r.Duration__c;
                        newMasterProd.Bookstore_ISBN_s__c = relatedProd.Apttus_Config2__RelatedProductId__r.SBN__c+'<br/>'+relatedProd.Apttus_Config2__RelatedProductId__r.ISBN__c+'<br/>'+(relatedProd.Apttus_Config2__RelatedProductId__c != null && relatedProd.Apttus_Config2__RelatedProductId__r.InstockDate__c!=null?DateTime.newInstance(relatedProd.Apttus_Config2__RelatedProductId__r.InstockDate__c.year(), relatedProd.Apttus_Config2__RelatedProductId__r.InstockDate__c.month(), relatedProd.Apttus_Config2__RelatedProductId__r.InstockDate__c.day()).format('MM/dd/yyyy'):' ')+' '+relatedProd.Apttus_Config2__RelatedProductId__r.Status__c;
                        newMasterProd.Product_Family__c = relatedProd.Apttus_Config2__ProductId__c;
                        newMasterProd.Platform__c = relatedProd.Apttus_Config2__RelatedProductId__r.Platform__c;
                        newMasterProd.Bookstore__c = relatedProd.Apttus_Config2__RelatedProductId__c;
                        //newMasterProd.Bookstore_Price__c = mapWithPriceListItem.get(relatedProd.Apttus_Config2__RelatedProductId__c);
                        //newMasterProd.Bookstore_Price__c = (mapWithPriceListItem.get(relatedProd.Apttus_Config2__RelatedProductId__c) !=null && mapWithPriceListItem.get(relatedProd.Apttus_Config2__RelatedProductId__c).Apttus_Config2__PriceLists__r.size()>0)
                              //                  ?mapWithPriceListItem.get(relatedProd.Apttus_Config2__RelatedProductId__c).Apttus_Config2__PriceLists__r[0].Net_Price__c:0.0;
                        if(mapWithPriceListItem.get(relatedProd.Apttus_Config2__RelatedProductId__c) != null){
                            if(mapWithPriceListItem.get(relatedProd.Apttus_Config2__RelatedProductId__c).Apttus_Config2__PriceLists__r.size()>0)
                                newMasterProd.Bookstore_Price__c = mapWithPriceListItem.get(relatedProd.Apttus_Config2__RelatedProductId__c).
                                                                Apttus_Config2__PriceLists__r[0].Net_Price__c;
                             else 
                                 newMasterProd.Bookstore_Price__c = 0.0;
                        }
                        else 
                             newMasterProd.Bookstore_Price__c = 0.0;                              
                        if(mapWithBrandValues.containsKey(relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c)){
                            newMasterProd.Offer_Type__c = mapWithBrandValues.get(relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c).Offer_Type__c =='Special Offer Type Rule'?(newMasterProd.Includes_Pearon_eText__c=='with eText'?'Learning Application + Text':'Learning Application'):mapWithBrandValues.get(relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c).Offer_Type__c;
                            newMasterProd.Sequence__c = mapWithBrandValues.get(relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c).Offer_Type_Sequence__c == 0?(newMasterProd.Includes_Pearon_eText__c=='with eText'?1:2):mapWithBrandValues.get(relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c).Offer_Type_Sequence__c;                    
                        }
                
                        //if(mapWithBrandValues.get(relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c) != null)
                            //newMasterProd.Sequence__c = mapWithBrandValues.get(relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c).Offer_Type_Sequence__c == 0?(newMasterProd.Includes_Pearon_eText__c=='with eText'?1:2):mapWithBrandValues.get(relatedProd.Apttus_Config2__RelatedProductId__r.Brand__c).Offer_Type_Sequence__c;
                        listWithNewPearsonChoices.add(newMasterProd);
                        listWithRemoveRelatedProductId.add(removeRelatedProductId);
                        
                }
                
                removeRelatedProductId = removeRelatedProductId + 1;
                
            }//end loop - 7
            
            //System.debug('After scenario 7:'+listWithNewPearsonChoices.size());                       
            listWithRemoveRelatedProductId.sort();
          
            for(Integer i=listWithRemoveRelatedProductId.size()-1;i>=0;i--){     
                if(listWithRemoveRelatedProductId[i]<relatedProductList.size()){                    
                   relatedProductList.remove(listWithRemoveRelatedProductId[i]);
                }
            }  
           
            listtmpPearsonChoices.clear();
            listWithRemoveRelatedProductId.clear();
            removeRelatedProductId = 0;   
            
           //scenario -8: Alternate edition
          for(Apttus_Config2__RelatedProduct__c relatedPro : relatedProductList){
              if ((relatedPro.Apttus_Config2__RelatedProductId__r.Medium2__c == 'Print' &&
              (relatedPro.Apttus_Config2__RelatedProductId__r.Binding__c == 'Paper' || 
               relatedPro.Apttus_Config2__RelatedProductId__r.Binding__c == 'Cloth' ||
               relatedPro.Apttus_Config2__RelatedProductId__r.Binding__c == 'Ringbound'||
               relatedPro.Apttus_Config2__RelatedProductId__r.Binding__c == 'Spiral Bound'||
               relatedPro.Apttus_Config2__RelatedProductId__r.Binding__c == 'Pearson Custom Library Content'||
               relatedPro.Apttus_Config2__RelatedProductId__r.Binding__c == 'Paper Bound with Access Card') && 
               (relatedPro.Association_Category__c == 'Alternate Binding' ||
                relatedPro.Association_Category__c == 'Main Title' )
               && (relatedPro.Apttus_Config2__RelatedProductId__r.Brand__c == '' || relatedPro.Apttus_Config2__RelatedProductId__r.Brand__c == null)
              ) 
                  ){
                  //system.debug('Match Found');
                  newMasterProd = new Pearson_Choice__c();

                  newMasterProd.Brand__c = 'Print Text: '+relatedPro.Apttus_Config2__RelatedProductId__r.Binding__c+'<br/>'+relatedPro.Apttus_Config2__RelatedProductId__r.Name;
                  newMasterProd.Product_Family__c = relatedPro.Apttus_Config2__ProductId__c;
                  newMasterProd.Bookstore__c = relatedPro.Apttus_Config2__RelatedProductId__c;
                  if(mapWithPriceListItem.get(relatedPro.Apttus_Config2__RelatedProductId__c) != null){
                    if (mapWithPriceListItem.get(relatedPro.Apttus_Config2__RelatedProductId__c).Apttus_Config2__PriceLists__r.size()>0)
                        newMasterProd.Bookstore_Price__c = mapWithPriceListItem.get(relatedPro.Apttus_Config2__RelatedProductId__c).Apttus_Config2__PriceLists__r[0].Net_Price__c;
                    else
                        newMasterProd.Bookstore_Price__c = 0.0;     
                  }                   
                  else
                    newMasterProd.Bookstore_Price__c = 0.0;
                  newMasterProd.Bookstore_ISBN_s__c = relatedPro.Apttus_Config2__RelatedProductId__r.SBN__c+'<br/>'+relatedPro.Apttus_Config2__RelatedProductId__r.ISBN__c+'<br/>'+(relatedPro.Apttus_Config2__RelatedProductId__c != null && relatedPro.Apttus_Config2__RelatedProductId__r.InstockDate__c!=null?DateTime.newInstance(relatedPro.Apttus_Config2__RelatedProductId__r.InstockDate__c.year(), relatedPro.Apttus_Config2__RelatedProductId__r.InstockDate__c.month(), relatedPro.Apttus_Config2__RelatedProductId__r.InstockDate__c.day()).format('MM/dd/yyyy'):' ')+' '+relatedPro.Apttus_Config2__RelatedProductId__r.Status__c;
                  if (mapWithBrandValues.containsKey('Print Text')){
                      newMasterProd.Offer_Type__c = mapWithBrandValues.get('Print Text').Offer_Type__c;
                      newMasterProd.Sequence__c = mapWithBrandValues.get('Print Text').Offer_Type_Sequence__c;
                  }
                  listWithNewPearsonChoices.add(newMasterProd);
              }
              listWithRemoveRelatedProductId.add(removeRelatedProductId);
              removeRelatedProductId = removeRelatedProductId + 1;                   
      }//end for loop -8     
     //System.debug('After scenario 8:'+listWithNewPearsonChoices.size());                       
      listWithRemoveRelatedProductId.sort();
      for(Integer i=listWithRemoveRelatedProductId.size()-1;i>=0;i--){     
          if(listWithRemoveRelatedProductId[i]<relatedProductList.size()){
               relatedProductList.remove(listWithRemoveRelatedProductId[i]);
          }
      }  
      listtmpPearsonChoices.clear();
      listWithRemoveRelatedProductId.clear();
      removeRelatedProductId = 0;
      listFinalPearsonChoices.addAll(listWithNewPearsonChoices);
      }//end for loop each product family
      
      errorprodid = null;
      system.debug(' before 8 count :'+listFinalPearsonChoices.size() );     
            

      if (listFinalPearsonChoices.size()>0){
      System.debug('Total # of records:'+listFinalPearsonChoices.size());
      List<Database.UpsertResult> upresult = Database.upsert(listFinalPearsonChoices,false);
      }
      }
      catch(Exception e){
          system.debug('Error in record :'+e);
          ExceptionFramework.LogException('BatchPearsonChoice','PS_BatchPearsonChoiceCreation','PearsonChoiceCreation','product family :'+ errorprodid +'Exception:'+e+' \n line Number :'+e.getLineNumber()+'\n Stack trace :'+e.getStackTraceString(),UserInfo.getUserName(),'');
      }
  }
  
  //Method to init product family and pricebook
  public void InitProcessMaps(List<Product2> productList){
      List<Apttus_Config2__RelatedProduct__c> dummylistWithRelatedProduct = new List<Apttus_Config2__RelatedProduct__c>(); 
      Set<Id> setWithProdIdForNetPrice = new Set<ID>();     
      set<Id> setpftoquery=new set<Id>(); 
      try{
      //Map Product Family Id to Related Products
      for(Product2 tempprod:productList){
          setpftoquery.add(tempprod.id);
      }

      for(Product2 tempprod: [select Id,Name,Relevance_Value__c,(select Id,Apttus_Config2__RelatedProductId__c,Apttus_Config2__RelatedProductId__r.Name,
          Apttus_Config2__RelatedProductId__r.Brand__c,Apttus_Config2__RelatedProductId__r.Relevance_Value__c,Apttus_Config2__RelatedProductId__r.Contains_eText__c,
          Apttus_Config2__RelatedProductId__r.Binding__c,Apttus_Config2__RelatedProductId__r.ISBN__c,
          Apttus_Config2__RelatedProductId__r.SBN__c,Apttus_Config2__RelatedProductId__r.Status__c,Apttus_Config2__RelatedProductId__r.Medium2__c,
          Association_Category__c,Relation_Package__c,Apttus_Config2__RelatedProductId__r.Platform__c,
          Apttus_Config2__RelatedProductId__r.Duration__c,Apttus_Config2__RelatedProductId__r.InstockDate__c,
          Apttus_Config2__RelatedProductId__r.Category2__c,Apttus_Config2__RelatedProductId__r.Accounting_Code__c,
          Apttus_Config2__ProductId__c,Apttus_Config2__ProductId__r.Name, PSELL__c from Apttus_Config2__RelatedProducts__r where
          Apttus_Config2__RelatedProductId__r.Relevance_Value__c >= 10 and Apttus_Config2__RelatedProductId__r.Relevance_Value__c <= 100) 
          from Product2 where id in : setpftoquery]){
              List<Apttus_Config2__RelatedProduct__c> tmplist=new List<Apttus_Config2__RelatedProduct__c>();       
              for(Apttus_Config2__RelatedProduct__c relprod: tempprod.getSObjects('Apttus_Config2__RelatedProducts__r')){
                  if (relprod != null){
                  if(mapWithBrandValues.containsKey(relProd.Apttus_Config2__RelatedProductId__r.Brand__c) ||
                      relProd.Apttus_Config2__RelatedProductId__r.Brand__c == '' ||
                      relProd.Apttus_Config2__RelatedProductId__r.Brand__c == null){
                     setWithProdIdForNetPrice.add(relprod.Apttus_Config2__RelatedProductId__c);
                     tmplist.add(relprod);
                  }
                  }
              }
              if (tmplist.size()>0){
                  pftorpmap.put(tempprod.id,tmplist);}//init  map of pf to rp           
      }   
      //system.debug('pftorpmap :'+pftorpmap);
         
      //Pricelist
      if (setWithProdIdForNetPrice.size()>0){
          mapWithPriceListItem = new Map<Id,Product2>([select id,(select id,net_price__c, Name from Apttus_Config2__PriceLists__r where Apttus_Config2__PriceListId__r.Name =:sPriceList) from
                            Product2 where id IN :setWithProdIdForNetPrice]);
          if (mapWithPriceListItem == null){
              mapWithPriceListItem=new Map<Id,Product2>();
          }
              
                            
      }
      
      }
      catch(Exception e){
          ExceptionFramework.LogException('BatchPearsonChoice','PS_BatchPearsonChoiceCreation','InitProcessMaps','Exception:'+e+' \n line Number :'+e.getLineNumber()+'\n Stack trace :'+e.getStackTraceString(),UserInfo.getUserName(),'');
      }
  }

}