/*===========================================================================+
 |  HISTORY                                                                  
 |                                                                           
 |  DATE            DEVELOPER        DESCRIPTION                               
 |  ====            =========        =========== 
 |  7/5/2015        IDC              This Batch Class is used for Opportunity creation 
                                     from potential target records
 +===========================================================================*/
global class PS_PotentialTargetOpptyCreationBatch implements Database.Batchable<sObject> ,Database.Stateful {
    public string batchQuery;
    List<Generate_Potential_Target__c> lstTargetstoProcess = new List<Generate_Potential_Target__c>();
    Set<Id> oppttCreatedCourse = new Set<Id>();
    List<Opportunity> lstOppty= new List<Opportunity>();
    Public Boolean hasTakeAway = false;
    Map<ID,Opportunity> mapCourOppty = new Map<ID,Opportunity>();
    Map<ID,UniversityCourse__c> mapPsCoursequOppty = new Map<ID,UniversityCourse__c>();
    Map<Id,PriceBookEntry> mapordPrceBook = new Map<Id,PriceBookEntry>();
    Map<Id,Apttus_Config2__PriceListItem__c> mapordPriceLst= new Map<Id,Apttus_Config2__PriceListItem__c>();
     //Set of Course Ids to pull Contact so it can be mapped to Opportunity
    Set<Id> setCourseId = new Set<Id>();
    Map<Id, id> coursetopc = new map<id,id>();
    //Constructor for Batch Class
    public PS_PotentialTargetOpptyCreationBatch(){    
        batchQuery = 'SELECT TakeAway_Multiple_Frontlist__c,TakeAway_Product_Family__c,Account__c, Action__c, Author__c,'+
        'Summer__c,Winter__c,Adoption_Type__c, Catalog_Code_Course_Name__c, Copyright_Year__c, Course__r.Mass_Sampling__c,'+
        'Course__r.Summer_Enrollment__c,Course__r.Winter_Enrollment__c,Course__r.name, Fall__c, Fall_Frontlist__c,'+
        'Next_Edition__c,Next_Edition_Currency__c, Opportunity_Type__c, Primary_Selling_Account__c, Product__c,'+
        'Product__r.CurrencyIsoCode , Product_In_Use__c, Product_In_Use_Publisher__c, Publisher__c, Id, Spring__c, '+
        'Spring_Frontlist__c, Status__c,createdby.id FROM Generate_Potential_Target__c where '+
        'Action__c =  \'Create\'  and Status__c =  \'In Progress\' and Processed__c = false';    
    }
    //End of Contructor

    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(batchQuery);
    }    
    
   //added for D-1904 for mapping opportunity Pearson course code
    public void coursePearsoncode(){
      Set<ID> pcce = new Set<ID>();
         List<Pearson_Course_Equivalent__c> pcc = [Select id,name,Pearson_Course_Code__c,course__c from Pearson_Course_Equivalent__c where Course__c  In :setCourseId and Primary__c = true and Active__c = true];
          for(Pearson_Course_Equivalent__c pccObj : pcc){
              if(!coursetopc.containsKey(pccObj.course__c)){
                      coursetopc.put(pccObj.course__c,pccObj.Pearson_Course_Code__c);
              }  
          }
    }
    //added for D-1904 mapping opportunity Pearson course code
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){
          Map<ID,Generate_Potential_Target__c> mapCourTargets = new Map<ID,Generate_Potential_Target__c>();
          Set<ID> productIds= new Set<ID>();
          List<OpportunityContactRole> lstOpptyContact = new List<OpportunityContactRole>();
          lstTargetstoProcess.clear();
          lstTargetstoProcess = (Generate_Potential_Target__c [])scope;
          System.debug('lstTargetstoProcess------>'+lstTargetstoProcess );
          //Fetching B2B record TYpe Id
          Schema.DescribeSObjectResult recordTypeDescr = Opportunity.SObjectType.getDescribe();
          Map<String,Schema.RecordTypeInfo> rtMapByName = recordTypeDescr.getRecordTypeInfosByName();
          Id opprtRecordId =  rtMapByName.get('B2B').getRecordTypeId();

   
          try{
              //Map To Find FrontList PRoducts
              for(Generate_Potential_Target__c  tagetObj :lstTargetstoProcess ){
                  if (tagetObj.product__c != null){
                  Opportunity opptyObj = new Opportunity();
                  opptyObj.name = tagetObj.Course__r.name;
                  opptyObj.recordtypeid= opprtRecordId;
                  opptyObj.ownerid= tagetObj.createdby.id;
                  System.debug('Test---->'+tagetObj.Account__c);
                
                  opptyObj.Accountid = tagetObj.Account__c;
                  if(tagetObj.Opportunity_Type__c.equalsIgnoreCase(Label.TA_Takeaway_Type))
                      opptyObj.StageName = Label.TA_Pending_Stage;
                  else
                      opptyObj.StageName = Label.TA_Qualified_Stage;
                  
                  opptyObj.Amount = 0;
                  opptyObj.Type = tagetObj.Opportunity_Type__c;
                  
                  if(tagetObj.Opportunity_Type__c.equalsIgnoreCase(Label.TA_Rollover_Type))
                       opptyObj.CurrencyIsoCode= tagetObj.Next_Edition_Currency__c;
                  else
                       opptyObj.CurrencyIsoCode= tagetObj.Product__r.CurrencyIsoCode;
                             
                  opptyObj.Fall__c = tagetObj.Fall__c;
                  opptyObj.Mass_Opportunity_Generation_Indicator__c = true;
                  opptyObj.Spring__c = tagetObj.Spring__c;
                  opptyObj.Summer__c = tagetObj.Summer__c;
                  opptyObj.Winter__c= tagetObj.Winter__c;
                  opptyObj.CourseId__c = tagetObj.Course__c;
                  opptyObj.Adoption_Type__c = tagetObj.Adoption_Type__c;
                  Integer month = (System.today()).month();
                  Integer year= (System.today()).year();
                  
                    
                if(system.Date.today().month() == 12 || (system.Date.today().month() >=1 && system.Date.today().month() <= 5)){
                    if(system.Date.today().month() == 12){
                    opptyObj.Selling_Period__c = string.valueof(system.Date.today().year()+1)+' - '+Label.TA_Selling_Period_Fall;
                     opptyObj.CloseDate = Date.newInstance (system.Date.today().year(), 4, 15);
                    }else{
                     opptyObj.Selling_Period__c = string.valueof(system.Date.today().year())+' - '+Label.TA_Selling_Period_Fall;
                     opptyObj.CloseDate = Date.newInstance (system.Date.today().year(), 4, 15);
                    }
                
                }else if(system.Date.today().month() >= 6 && system.Date.today().month() <= 11){
                    opptyObj.Selling_Period__c = string.valueof(system.Date.today().year()+1)+' - '+Label.TA_Selling_Period_Spring;
                    opptyObj.CloseDate = Date.newInstance (system.Date.today().year(), 10, 15);
                }
                  
                     
                  setCourseId.add(tagetObj.Course__c);
                  //Filling Product Set which will be used for running SOQL on Apttus_Config2__PriceListItem__c to Fetch List Price and unit price
                  if(tagetObj.Opportunity_Type__c.equalsIgnoreCase(Label.TA_Rollover_Type))
                      productIds.add(tagetObj.Next_Edition__c);
                  else{
                      productIds.add(tagetObj.Product__c);
                      hasTakeAway = true;
                   }
                  //Map of Course ID and Target
                  mapCourTargets.put(tagetObj.Course__c,tagetObj );
                  lstOppty.add(opptyObj);
                  }
                }
              
               System.debug('productIds ------->'+productIds );
               Set<Id> setTakeAwayProd = new Set<Id>();
               Map<Id,Set<Id>> mapProdFrontLsit = new Map<Id,Set<Id>>();
    
             //Logic for Fectching PriceBookentry and currency iso to map to LineItem
             List<Apttus_Config2__RelatedProduct__c> lstTakeAwayProd = new List<Apttus_Config2__RelatedProduct__c>();
             
             if(hasTakeAway){
                 lstTakeAwayProd = [Select Apttus_Config2__RelatedProductId__r.Status__c,Apttus_Config2__RelatedProductId__r.Publisher__c,Apttus_Config2__RelatedProductId__r.Competitor_Product__c,Apttus_Config2__RelatedProductId__r.Relevance_Value__c,Apttus_Config2__RelatedProductId__c,Apttus_Config2__ProductId__c  from  Apttus_Config2__RelatedProduct__c where Apttus_Config2__RelatedProductId__c in:productIds limit 50000]; // where Apttus_Config2__ProductId__c 
                             
              }         
             System.debug('lstTakeAwayProd--------------->'+lstTakeAwayProd );
             if(!lstTakeAwayProd.isEmpty()){
                 for(Apttus_Config2__RelatedProduct__c relatedObj:lstTakeAwayProd ){
                     if(relatedObj.Apttus_Config2__RelatedProductId__r.Competitor_Product__c == false && relatedObj.Apttus_Config2__RelatedProductId__r.Relevance_Value__c==Integer.valueof(Label.TA_Frontlist_Relevance)){
                             setTakeAwayProd.add(relatedObj.Apttus_Config2__RelatedProductId__c);
                          if(mapProdFrontLsit.containsKey(relatedObj.Apttus_Config2__ProductId__c))
                              mapProdFrontLsit.get(relatedObj.Apttus_Config2__ProductId__c).add(relatedObj.Apttus_Config2__RelatedProductId__c);
                          else{
                              Set<Id> tempSet = new Set<Id>();
                              tempSet.add(relatedObj.Apttus_Config2__RelatedProductId__c);
                              mapProdFrontLsit.put(relatedObj.Apttus_Config2__ProductId__c, tempSet);
                          }
                      }
                 }
             }
  
             System.debug('mapProdFrontLsit--------------->'+mapProdFrontLsit);
    
             //To Set Multiple_Product_Options__c on Oppty , reason for Iterating Oppty list again is to Fetch Poructs and then perform checkbox value updation.
             for(Integer i=0 ;i<lstOppty.size(); i++){
                  if(Label.PS_PotentialTargetFrontListSwitch.equalsIgnoreCase('ON')){
                      if(mapCourTargets.get(lstOppty[i].CourseId__c).TakeAway_Multiple_Frontlist__c == true){                    
                          System.debug('Updating Map for opprtunity...KP');
                          lstOppty[i].Multiple_Product_Options__c = true;    
                      }
                  }
                  else{
                     
                      if(mapProdFrontLsit.containsKey(mapCourTargets.get(lstOppty[i].CourseId__c).product__c) && 
                      (lstOppty[i].type.equalsIgnoreCase( Label.TA_Takeaway_Type))){
                        if((mapProdFrontLsit.get(mapCourTargets.get(lstOppty[i].CourseId__c).product__c)).size()>1){
                            //System.debug('Updating Map for opprtunity...KP');
                            lstOppty[i].Multiple_Product_Options__c = true;
                        }
                      }
                     
                  }                 
             } //end code for multi frontlist
             System.debug('lstOppty---->'+ lstOppty);
              
              //Fetching Contacts for Course
              List<UniversityCourseContact__c> lstContact = [Select Contact__c,UniversityCourse__c from UniversityCourseContact__c where UniversityCourse__c in:setCourseId limit 50000];
              Map<ID,List<ID>> mapCourseContact = new Map<ID,List<ID>>();
              for(UniversityCourseContact__c courContactObj : lstContact){
                  if(mapCourseContact.containsKey(courContactObj.UniversityCourse__c))
                      mapCourseContact.get(courContactObj.UniversityCourse__c).add(courContactObj.Contact__c);
                  else{
                      List<ID> tempID = new List<ID>();
                      tempID.add(courContactObj.Contact__c);
                      mapCourseContact.put(courContactObj.UniversityCourse__c, tempID);
                  }
              }
              System.debug('mapCourseContact---->'+ mapCourseContact);
              //End of Course Contact Mapping
              
              if(!lstOppty.isEmpty()){
                 Database.SaveResult[] lstResult = Database.insert(lstOppty, false); 
                 if (lstResult != null){
                    List<PS_ExceptionLogger__c> errloggerlist=new List<PS_ExceptionLogger__c>();
                    for (Database.SaveResult sr : lstResult) {
                        String ErrMsg='';
                        if (!sr.isSuccess() || Test.isRunningTest()){
                            PS_ExceptionLogger__c errlogger=new PS_ExceptionLogger__c();
                            errlogger.InterfaceName__c='Opportunity Insert';
                            errlogger.ApexClassName__c='PS_PotentialTargetOpptyCreationBatch';
                            errlogger.CallingMethod__c='Execute';
                            errlogger.UserLogin__c=UserInfo.getUserName(); 
                            errlogger.recordid__c=sr.getId();
                            for(Database.Error err : sr.getErrors()) 
                              ErrMsg=ErrMsg+err.getStatusCode() + ': ' + err.getMessage(); 
                            errlogger.ExceptionMessage__c=  ErrMsg;
                            errloggerlist.add(errlogger);    
                        }
                    }
                    if(errloggerlist.size()>0){insert errloggerlist;}
                }   
                  Set<ID> setOpptyId = new Set<ID>();  
                  if(!lstResult.isEmpty()){
                      for(Database.SaveResult resultObj : lstResult){
                          if(resultObj.isSuccess())
                             setOpptyId.add(resultObj.getID());
                       }
                  if(!setOpptyId.isEmpty())
                          mapCourOppty = new Map<ID,Opportunity>([Select Fall__c,Spring__c,id,Selling_Period__c,Type,CurrencyIsoCode,CourseId__c,Multiple_Product_Options__c,Account.id,amount,CloseDate,name from Opportunity where id in:setOpptyId limit 50000]);
                  }
                  System.debug('mapCourOppty----->'+ mapCourOppty);
                  //Opportunity Course Mapping and Opportunity Contact mapping
                  List<OpportunityUniversityCourse__c> lstopptyCourse = new List<OpportunityUniversityCourse__c>();
                  if(!mapCourOppty.isEmpty()){
                      for(Opportunity newOpptyObj : mapCourOppty.values()){
                          OpportunityUniversityCourse__c opptyCourseObj = new OpportunityUniversityCourse__c();
                          opptyCourseObj.Close_Date__c = mapCourOppty.get(newOpptyObj.id).CloseDate;
                          opptyCourseObj.Opportunity_Name__c = mapCourOppty.get(newOpptyObj.id).name;
                          opptyCourseObj.Opportunity__c = newOpptyObj.id;
                          opptyCourseObj.Account__c  = mapCourOppty.get(newOpptyObj.id).Account.id;
                          opptyCourseObj.Opportunity_University_Course_Amount__c = mapCourOppty.get(newOpptyObj.id).Amount;
                          opptyCourseObj.UniversityCourse__c = mapCourOppty.get(newOpptyObj.id).CourseId__c;
                          lstopptyCourse.add(opptyCourseObj);
                          if(mapCourseContact.containsKey(mapCourOppty.get(newOpptyObj.id).CourseId__c)){
                              for(ID contactID : mapCourseContact.get(mapCourOppty.get(newOpptyObj.id).CourseId__c)){
                                  OpportunityContactRole opptContactObj = new OpportunityContactRole();
                                  opptContactObj.ContactId = contactID;
                                  opptContactObj.Role= 'Non Participant';
                                  opptContactObj.OpportunityId = newOpptyObj.id;
                                  lstOpptyContact.add(opptContactObj);
                             }
                          }                          
                      }
                      //Invoking method for mapping Asset(Product in Use to Opportunity)
                      mapProductInUsetoOpportunity(mapCourTargets,mapCourOppty);
                  }
                  System.debug('lstopptyCourse---->'+lstopptyCourse);
                  if(!lstopptyCourse.isEmpty()){
                      Database.SaveResult[] lstopptyCourseReult = Database.insert(lstopptyCourse ,false);
                      if (lstopptyCourseReult != null){
                        List<PS_ExceptionLogger__c> errloggerlist=new List<PS_ExceptionLogger__c>();
                        for (Database.SaveResult sr : lstopptyCourseReult) {
                        String ErrMsg='';
                            if (!sr.isSuccess() || Test.isRunningTest()){
                                PS_ExceptionLogger__c errlogger=new PS_ExceptionLogger__c();
                                errlogger.InterfaceName__c='Opportunity Course Insert';
                                errlogger.ApexClassName__c='PS_PotentialTargetOpptyCreationBatch';
                                errlogger.CallingMethod__c='Execute';
                                errlogger.UserLogin__c=UserInfo.getUserName(); 
                                errlogger.recordid__c=sr.getId();
                                for(Database.Error err : sr.getErrors()) 
                                  ErrMsg=ErrMsg+err.getStatusCode() + ': ' + err.getMessage(); 
                                errlogger.ExceptionMessage__c=  ErrMsg;                                  
                                errloggerlist.add(errlogger);    
                            }    
                        }
                        if(errloggerlist.size()>0){insert errloggerlist;}
                       }            
                  }
                  if(!lstOpptyContact.isEmpty()){
                      Database.SaveResult[] lstOpptyContactReult = Database.insert(lstOpptyContact,false);
                      if (lstOpptyContactReult != null){
                        List<PS_ExceptionLogger__c> errloggerlist=new List<PS_ExceptionLogger__c>();
                        for (Database.SaveResult sr : lstOpptyContactReult) {
                        String ErrMsg='';
                            if (!sr.isSuccess() || Test.isRunningTest()){
                                PS_ExceptionLogger__c errlogger=new PS_ExceptionLogger__c();
                                errlogger.InterfaceName__c='Opportunity Contact Creation';
                                errlogger.ApexClassName__c='PS_PotentialTargetOpptyCreationBatch';
                                errlogger.CallingMethod__c='Execute';
                                errlogger.UserLogin__c=UserInfo.getUserName(); 
                                errlogger.recordid__c=sr.getId();
                                for(Database.Error err : sr.getErrors()) 
                                  ErrMsg=ErrMsg+err.getStatusCode() + ': ' + err.getMessage(); 
                                errlogger.ExceptionMessage__c=  ErrMsg;  
                                errloggerlist.add(errlogger);    
                            }    
                        }
                        if(errloggerlist.size()>0){insert errloggerlist;}
                    }
                  }
                  //End of Opportunity Course Mapping & Opportunity Contact mapping                  //Opportunity Product Creation
                  opptyProductCreation(mapCourOppty,mapCourTargets,productIds,mapCourseContact,setTakeAwayProd,mapProdFrontLsit);
              }
         }catch(Exception e){
              ExceptionFramework.LogException('Opportunity Insert,Opportunity Contact Creation','PS_PotentialTargetOpptyCreationBatch','Future_validatetakeaway',e.getMessage(),UserInfo.getUserName(),'');
         }     
     }
    //Opportunity Line item creation
    @TestVisible private void opptyProductCreation(Map<Id,Opportunity> mapOppty, Map<ID,Generate_Potential_Target__c> mapCourTargets , Set<ID> productIds , Map<Id, List<Id>> mapCourseContact, Set<Id> setTakeAwayProd,Map<Id,Set<Id>> mapProdFrontLsit ){
         //System.debug('mapOppty------->'+mapOppty);
         //System.debug('opptyProductCreation------->'+lstTargetstoProcess );
         //System.debug('setTakeAwayProd111------->'+setTakeAwayProd);
         //System.debug('mapProdFrontLsit------->'+mapProdFrontLsit );
         //System.debug('productIds ------->'+productIds );
         //List of Line Item used for Oppty Product Insert
         List<OpportunityLineItem> lstOpptyProduct = new List<OpportunityLineItem>();
        
         Map<Id,Map<String,PriceBookEntry>> mapprodPriceBook = new Map<Id,Map<String,PriceBookEntry>>();
         List<PriceBookEntry> lstPrceBook = [SELECT Id, Product2.Id, CurrencyIsoCode, Product2.Name,Product2.Relevance_Value__c,
         Product2.Publisher__c  FROM PriceBookEntry WHERE (Product2.Id in:productIds or Product2.Id in:setTakeAwayProd)  AND 
         PriceBook2.isStandard=true limit 50000];
         //System.debug('Test Result:'+lstPrceBook);
         for(PriceBookEntry priceBookObj : lstPrceBook ){
             if(mapprodPriceBook.containsKey(priceBookObj.Product2.Id))
                 mapprodPriceBook.get(priceBookObj.Product2.Id).put(priceBookObj.CurrencyIsoCode,priceBookObj);
             else{
                 Map<String,PriceBookEntry> tempMap = new Map<String,PriceBookEntry>();
                 tempMap.put(priceBookObj.CurrencyIsoCode,priceBookObj);  
                 mapprodPriceBook.put(priceBookObj.Product2.Id, tempMap);     
             
             }
            }
             system.debug('Test Map:'+mapprodPriceBook.size());
         //End of PriceBookentry to map to LineItem
         
          //Logic for Fectching List Price and Unit Price from Apttus_Config2__ProductId__c object so that It can be mapped to Line Item
         Map<Id,Apttus_Config2__PriceListItem__c> mapPriceLst = new Map<Id,Apttus_Config2__PriceListItem__c>();
         List<Apttus_Config2__PriceListItem__c> lstAptusPriceList= [Select id , Apttus_Config2__ListPrice__c,Net_Price__c,Apttus_Config2__ProductId__c from Apttus_Config2__PriceListItem__c where (Apttus_Config2__ProductId__c in:productIds or Apttus_Config2__ProductId__c in:setTakeAwayProd) limit 50000];         
         //System.debug('lstAptusPriceList------->'+lstAptusPriceList);
         for(Apttus_Config2__PriceListItem__c aptPriceObj : lstAptusPriceList){
             mapPriceLst.put(aptPriceObj.Apttus_Config2__ProductId__c , aptPriceObj );
         }          
         //End of Price Fecting Logic
         
         //Logic For Fetching Product Family
        /*  Set<ID> pcce = new Set<ID>();
         List<Pearson_Course_Equivalent__c> pcc = [Select id,name,Pearson_Course_Code__c from Pearson_Course_Equivalent__c where Course__c  In :setCourseId];
          for(Pearson_Course_Equivalent__c pccObj : pcc){
                pcce.add(pccObj.Pearson_Course_Code__c);
          }
          List<Apttus_Config2__ProductClassification__c> pc = new List<Apttus_Config2__ProductClassification__c>();
          Set<ID> rpfid = new set<ID>();
          pc = [select id,Apttus_Config2__ClassificationId__c,Apttus_Config2__ProductId__c from Apttus_Config2__ProductClassification__c where Apttus_Config2__ClassificationId__c In :pcce];
          for(Apttus_Config2__ProductClassification__c pcobj : pc){
           rpfid.add(pcobj.Apttus_Config2__ProductId__c);
          } */
         
         List<Apttus_Config2__RelatedProduct__c> lstProdutFamily = [Select id,Apttus_Config2__ProductId__c,Apttus_Config2__RelatedProductId__c 
         from Apttus_Config2__RelatedProduct__c where Apttus_Config2__RelatedProductId__c in:productIds and 
         Apttus_Config2__ProductId__r.Apttus_Config2__ConfigurationType__c = 'Bundle' limit 50000];   // and PSELL__c = true,  rpfid
         Map<Id,Id> mapFamily = new Map<Id,Id>();
         for(Apttus_Config2__RelatedProduct__c relatedObj : lstProdutFamily ){
                 mapFamily.put(relatedObj.Apttus_Config2__RelatedProductId__c, relatedObj.Apttus_Config2__ProductId__c);
         }
         
         //End of Logic for Product Family
         
         //Set for extracting Pearson course Code
         Map<Id,Id> personCourseMap = new Map<Id,Id>();
                  
         for(Opportunity opptyObj : mapOppty.values()){
                 //Fillign Set of course ID for which opportunity is created , setting value to set here becasue Created opportunity gets iterated here
                 if(opptyObj.CourseId__c!=null)
                     oppttCreatedCourse.add(opptyObj.CourseId__c);
                //End of Logic for Course for whihc opportunity is created
                 if(opptyObj.Type.equalsIgnoreCase(Label.TA_Rollover_Type)){
                
                     if(mapprodPriceBook.containsKey(mapCourTargets.get(opptyObj.CourseId__c).Next_Edition__c)){
                         OpportunityLineItem opptyProduct = new OpportunityLineItem();
                         if(mapprodPriceBook.get(mapCourTargets.get(opptyObj.CourseId__c).Next_Edition__c).containsKey(opptyObj.CurrencyIsoCode) && mapprodPriceBook.get(mapCourTargets.get(opptyObj.CourseId__c).Next_Edition__c).get(opptyObj.CurrencyIsoCode).id != null){
                             if((mapprodPriceBook.get(mapCourTargets.get(opptyObj.CourseId__c).Next_Edition__c).get(opptyObj.CurrencyIsoCode).Product2.Publisher__c.equalsIgnoreCase(Label.TA_Frontlist_Publisher)) && 
                               (mapprodPriceBook.get(mapCourTargets.get(opptyObj.CourseId__c).Next_Edition__c).get(opptyObj.CurrencyIsoCode).Product2.Relevance_Value__c ==10))
                                 opptyProduct.PricebookEntryId = mapprodPriceBook.get(mapCourTargets.get(opptyObj.CourseId__c).Next_Edition__c).get(opptyObj.CurrencyIsoCode).id;
                          
                          if((opptyObj.Selling_Period__c).containsIgnoreCase(Label.TA_Selling_Period_Fall) && opptyObj.Fall__c > 0)                               
                              opptyProduct.Quantity = opptyObj.Fall__c;
                          else if((opptyObj.Selling_Period__c).containsIgnoreCase(Label.TA_Selling_Period_Spring) && opptyObj.Spring__c > 0)                               
                              opptyProduct.Quantity = opptyObj.Spring__c;
                          //Code Added by Rahul for checking the OpportunityLineItem Quantity starts
                         else
                              opptyProduct.Quantity = 1;
                         //Code Added by Rahul for checking the OpportunityLineItem Quantity ends
                          opptyProduct.OpportunityId=opptyObj.id;
                          if(mapPriceLst.containsKey(mapCourTargets.get(opptyObj.CourseId__c).Next_Edition__c))
                              {
                               //System.debug('Map contains next edition pricelist');
                               if(mapPriceLst.get(mapCourTargets.get(opptyObj.CourseId__c).Next_Edition__c).Net_Price__c != null){
                                   //System.debug('Map inside null check');
                                   //System.debug('net Price--RG'+mapPriceLst.get(mapCourTargets.get(opptyObj.CourseId__c).Next_Edition__c).Net_Price__c);
                                  opptyProduct.UnitPrice= mapPriceLst.get(mapCourTargets.get(opptyObj.CourseId__c).Next_Edition__c).Net_Price__c ;
                               }
                               else{
                                   //System.debug('net price is null');
                                  opptyProduct.UnitPrice = 0;  
                               }
                              
                              }
                           else
                              opptyProduct.UnitPrice = 0;
                              system.debug('Next_Edition__c --->'+mapFamily.containsKey(mapCourTargets.get(opptyObj.CourseId__c).Next_Edition__c));
                          if(mapFamily.containsKey(mapCourTargets.get(opptyObj.CourseId__c).Next_Edition__c)){
                              system.debug('mapCourTargets.get(opptyObj.CourseId__c).Next_Edition__c inside if -->');
                              opptyProduct.Product_Family_HE__c = mapFamily.get(mapCourTargets.get(opptyObj.CourseId__c).Next_Edition__c);
                              //D-1586 : Initalised map - oppty - productfamily
                              personCourseMap.put(opptyObj.id,mapFamily.get(mapCourTargets.get(opptyObj.CourseId__c).Next_Edition__c));
                          }
                              
                          lstOpptyProduct.add(opptyProduct);
                         }
                     }
                     
                 }                 
            else{
                if(mapprodPriceBook.containsKey(mapCourTargets.get(opptyObj.CourseId__c).Product__c)){
                    OpportunityLineItem opptyProduct = new OpportunityLineItem();
                     if(mapprodPriceBook.get(mapCourTargets.get(opptyObj.CourseId__c).Product__c).containsKey(opptyObj.CurrencyIsoCode) && mapprodPriceBook.get(mapCourTargets.get(opptyObj.CourseId__c).Product__c).get(opptyObj.CurrencyIsoCode).id != null){
                          opptyProduct.PricebookEntryId = mapprodPriceBook.get(mapCourTargets.get(opptyObj.CourseId__c).Product__c).get(opptyObj.CurrencyIsoCode).id;
                     if((opptyObj.Selling_Period__c).containsIgnoreCase(Label.TA_Selling_Period_Fall) && opptyObj.Fall__c > 0)                               
                          opptyProduct.Quantity = opptyObj.Fall__c;
                     else if((opptyObj.Selling_Period__c).containsIgnoreCase(Label.TA_Selling_Period_Spring) && opptyObj.Spring__c > 0)                               
                         opptyProduct.Quantity = opptyObj.Spring__c;
                    //Code Added by Rahul for checking the OpportunityLineItem Quantity starts
                    else
                         opptyProduct.Quantity = 1;
                    //Code Added by Rahul for checking the OpportunityLineItem Quantity ends
                     opptyProduct.OpportunityId=opptyObj.id;
                     if(mapPriceLst.containsKey(mapCourTargets.get(opptyObj.CourseId__c).Product__c))
                       {
                          //system.debug('RG---map contains pricelist'); 
                         if(mapPriceLst.get(mapCourTargets.get(opptyObj.CourseId__c).Product__c).Net_Price__c != null){
                                                   system.debug('RG---map contains pricelist null');
                          opptyProduct.UnitPrice= mapPriceLst.get(mapCourTargets.get(opptyObj.CourseId__c).Product__c).Net_Price__c ;
                         }
                         else
                           opptyProduct.UnitPrice = 0;
                        }
                     else
                         opptyProduct.UnitPrice = 0;
                     //System.debug('net Price--RG'+mapPriceLst.get(mapCourTargets.get(opptyObj.CourseId__c).Product__c).Net_Price__c);
                     if(mapCourTargets.get(opptyObj.CourseId__c).TakeAway_Product_Family__c != null){
                         opptyProduct.Product_Family_HE__c = mapCourTargets.get(opptyObj.CourseId__c).TakeAway_Product_Family__c;
                              //D-1586 : Initalised map - oppty - productfamily
                         personCourseMap.put(opptyObj.id,mapCourTargets.get(opptyObj.CourseId__c).TakeAway_Product_Family__c);
                     }
                     else if(mapFamily.containsKey(mapCourTargets.get(opptyObj.CourseId__c).Product__c)){
                         opptyProduct.Product_Family_HE__c = mapFamily.get(mapCourTargets.get(opptyObj.CourseId__c).Product__c);
                             //D-1586 : Initalised map - oppty - productfamily
                         personCourseMap.put(opptyObj.id,mapFamily.get(mapCourTargets.get(opptyObj.CourseId__c).Product__c));
                     }
                     lstOpptyProduct.add(opptyProduct);
                     }
                }
                
            } 
                
        }
        
        //commented for D-1904 mapping opportunity Pearson course code
        /*Logic for Fetching Product classification which shall be used for product selctor
        List<Apttus_Config2__ProductClassification__c> lstProdClass= [Select id,Apttus_Config2__ClassificationId__c,Apttus_Config2__ProductId__c  
        from Apttus_Config2__ProductClassification__c where Apttus_Config2__ProductId__c in:personCourseMap.values() limit 50000];
        
        Map<Id,Id> mapProdPearsonCode  = new Map<Id,Id>();
        for(Apttus_Config2__ProductClassification__c prdClassObj :lstProdClass){
            mapProdPearsonCode.put(prdClassObj.Apttus_Config2__ProductId__c,prdClassObj.Apttus_Config2__ClassificationId__c);
        }
        
        System.debug('personCourseMap-------------->'+personCourseMap);
        System.debug('mapProdPearsonCode-------------->'+mapProdPearsonCode);*/
        
        //commented for D-1904 mapping opportunity Pearson course code
        
        coursePearsoncode();
        /*if(!mapProdPearsonCode.isEmpty())
             opptyPearsonCourseCodeMapping(personCourseMap,mapProdPearsonCode);*/
        opptyPearsonCourseCodeMapping();   
        
        if(!lstOpptyProduct.isEmpty()){
                try{
                   //System.debug('lstOpptyProduct --- >'+lstOpptyProduct);
                   List<OpportunityLineItem> lstOpptyProducttoinsert = new List<OpportunityLineItem>();
                   for(opportunitylineitem eacholi :lstOpptyProduct ){
                       
                       if(eacholi.PricebookEntryId == null){
                            system.debug(' eacholi :'+ eacholi);
                       }else{
                         lstOpptyProducttoinsert.add(eacholi);  
                       }        
                   }
                    Database.SaveResult[] lstOpptyProductResult = Database.insert(lstOpptyProducttoinsert,false);
                    if (lstOpptyProductResult != null){
                        List<PS_ExceptionLogger__c> errloggerlist=new List<PS_ExceptionLogger__c>();
                        for (Database.SaveResult sr : lstOpptyProductResult ) {
                            String ErrMsg='';
                            if (!sr.isSuccess() || Test.isRunningTest()){
                                PS_ExceptionLogger__c errlogger=new PS_ExceptionLogger__c();
                                errlogger.InterfaceName__c='Opportunity Line Item Creation';
                                errlogger.ApexClassName__c='PS_PotentialTargetOpptyCreationBatch';
                                errlogger.CallingMethod__c='opptyProductCreation';
                                errlogger.UserLogin__c=UserInfo.getUserName(); 
                                errlogger.recordid__c=sr.getId();
                                for(Database.Error err : sr.getErrors()) 
                                  ErrMsg=ErrMsg+err.getStatusCode() + ': ' + err.getMessage(); 
                                errlogger.ExceptionMessage__c=  ErrMsg;  
                                errloggerlist.add(errlogger);    
                            }
                        }
                        if(errloggerlist.size()>0){insert errloggerlist;}
                    }
                    //Creatin Digital Sampling after Oppty Product Mapping is done 
                    digitalSampleCreation(mapCourTargets , lstOpptyProductResult,mapCourseContact );

                }
                catch(Exception exp){
                    oppttCreatedCourse.clear();
                    //system.debug('Inside Exception');
                    ExceptionFramework.LogException('Opportunity Line Item Creation','PS_PotentialTargetOpptyCreationBatch','opptyProductCreation',exp.getMessage(),UserInfo.getUserName(),'');
                }
        }
    }
     
     //Method to create Opportunity Pearson Course Equivalents
  /*  @TestVisible private void opptyPearsonCourseCodeMapping(Map<Id,Id> personCourseMap,Map<Id,Id> mapProdPearsonCode){
        //system.debug('Inside Pearson course equivalents:');
         List<Opportunity_Pearson_Course_Code__c> lstOpptyPersonCourse = new List<Opportunity_Pearson_Course_Code__c>();
         for(Id OpptyId:personCourseMap.keySet()){
             if(mapProdPearsonCode.containsKey(personCourseMap.get(OpptyId))){
                 Opportunity_Pearson_Course_Code__c opptyPearsonObj = new Opportunity_Pearson_Course_Code__c();
                 opptyPearsonObj.Opportunity__c = OpptyId;
                 opptyPearsonObj.Pearson_Course_Code_Name__c= mapProdPearsonCode.get(personCourseMap.get(OpptyId));
                 lstOpptyPersonCourse.add(opptyPearsonObj);
             }
         }
         if(!lstOpptyPersonCourse.isEmpty())
             Database.SaveResult[] lstOpptyPearsonCourse = Database.Insert(lstOpptyPersonCourse,false);
     } */
     
     @TestVisible private void opptyPearsonCourseCodeMapping(){
         List<Opportunity_Pearson_Course_Code__c> lstOpptyPersonCourse = new List<Opportunity_Pearson_Course_Code__c>();
         for(Opportunity Oppty:mapCourOppty.Values()){
             if (coursetopc.containskey(Oppty.courseid__c)){
                 Opportunity_Pearson_Course_Code__c opptyPearsonObj = new Opportunity_Pearson_Course_Code__c();
                  opptyPearsonObj.Opportunity__c = Oppty.Id;
                  opptyPearsonObj.Pearson_Course_Code_Name__c=coursetopc.get(Oppty.courseid__c);
                  lstOpptyPersonCourse.add(opptyPearsonObj);
             }
         }
         if(!lstOpptyPersonCourse.isEmpty())
             Database.SaveResult[] lstOpptyPearsonCourse = Database.Insert(lstOpptyPersonCourse,false);         
     }
     
     @TestVisible private void productpricing(List<Id> pId){
         //Map<Id,PriceBookEntry> mapordPrceBook;
         //List<PriceBookEntry> ordlstPrceBook = ;    
         //Map<Id,PriceBookEntry> mapordPrceBook = new Map<Id,PriceBookEntry>();
         for(PriceBookEntry pbe: [SELECT Id, Product2.Id, CurrencyIsoCode, Product2.Name,Product2.Relevance_Value__c,
         Product2.Publisher__c  FROM PriceBookEntry WHERE Product2.Id in:pId AND 
         PriceBook2.isStandard=true limit 50000]){
             if(!mapordPrceBook.containsKey(pbe.Product2.Id))
                 //system.debug('check');
                 mapordPrceBook.put(pbe.Product2.Id,pbe);
         }
         
         //Logic for Fectching List Price and Unit Price from Apttus_Config2__ProductId__c object so that It can be mapped to Line Item
         //Apttus_Config2__PriceListItem__c lstAptusPriceList = ;         
         //System.debug('lstAptusPriceList------->'+lstAptusPriceList);
         for(Apttus_Config2__PriceListItem__c aptPriceObj : [Select id , Apttus_Config2__ListPrice__c,Net_Price__c,Apttus_Config2__ProductId__c 
         from Apttus_Config2__PriceListItem__c where Apttus_Config2__ProductId__c in:pId limit 50000]){
           if(!mapordPriceLst.containsKey(aptPriceObj.Apttus_Config2__ProductId__c))
             mapordPriceLst.put(aptPriceObj.Apttus_Config2__ProductId__c, aptPriceObj);
         }   

     }
     
    //@Method <This method gets called from opptyProductCreation for creating Mass Digital Sampling records based on opprotunity product mapping>
    @TestVisible private void digitalSampleCreation(Map<ID,Generate_Potential_Target__c> mapCourTargets , Database.SaveResult[] prodResult , Map<Id,List<Id>> mapCourseContact){
         
         Set<Id> lineitempf = new Set<Id>();
         Set<Id> setLineItem = new Set<Id>();
         Map<Id,Id> opptytopf=new Map<Id,Id>();
         Map<Id,List<OpportunityLineItem>> mapOpptyLineItem = new Map<Id,List<OpportunityLineItem>>();
         List<Order> lstOrder = new List<Order>();
         List<OrderItem> lstOrderLineitem = new List<OrderItem>();
         
         List<Pricebook2> lstPriceBook = [Select id from PriceBook2 where isStandard=true limit 1];
         for(Database.SaveResult resultObj: prodResult){
             if(resultObj.isSuccess()){
                 setLineItem.add(resultObj.getId());
              }
         }   
         List<OpportunityLineItem> opptyProdLst = [Select id,opportunityid,Opportunity.accountid,Product_Family_HE__c,Opportunity.CurrencyIsoCode,Opportunity.CourseId__c from OpportunityLineItem oL 
         where id in :setLineItem limit 50000]; 
         for(OpportunityLineItem oli: opptyProdLst){
            if(mapOpptyLineItem.containsKey(oli.Opportunityid))
                mapOpptyLineItem.get(oli.Opportunityid).add(oli);
            else{
                 List<OpportunityLineItem> tempLst = new List<OpportunityLineItem>();
                 tempLst.add(oli);
                 mapOpptyLineItem.put(oli.Opportunityid,tempLst);
            }
            lineitempf.add(oli.Product_Family_HE__c);
            if (!opptytopf.containsKey(oli.opportunityid))
                opptytopf.put(oli.opportunityid,oli.Product_Family_HE__c);
                
         } 
         
        Map<Id,Product2> sampleprod= new Map<Id,Product2>(
        [select id,(select id,Apttus_Config2__RelatedProductId__c from Apttus_Config2__RelatedProducts__r where PSAM__c=true and
        Apttus_Config2__RelatedProductId__r.Medium2__c like 'Digital%' and 
        (Apttus_Config2__RelatedProductId__r.Category2__c='CourseSmart' or Apttus_Config2__RelatedProductId__r.Category2__c='CourseSmart (Review Only)')
        order by Apttus_Config2__RelatedProductId__r.Category2__c) from Product2 where id in:lineitempf]);
        //Set<Id> opid=new Set<Id>();
        Map<Id,Id> opid=new Map<Id,Id>();
        for(Id pfId:sampleprod.keySet()){
            //system.debug('RG Relaeted product--->'+sampleprod.get(pfId).Apttus_Config2__RelatedProducts__r);
            if (sampleprod.get(pfId).Apttus_Config2__RelatedProducts__r.size() > 0){
                //system.debug('RG reltd pruct id'+sampleprod.get(pfId).Apttus_Config2__RelatedProducts__r[0].Apttus_Config2__RelatedProductId__c);
                opid.put(pfId,sampleprod.get(pfId).Apttus_Config2__RelatedProducts__r[0].Apttus_Config2__RelatedProductId__c);
             }
          //opid.add(sampleprod.get(pfId).Apttus_Config2__RelatedProducts__r[0].Apttus_Config2__RelatedProductId__c );
        }
        productpricing(opid.values());
        for(Id opptyId :opptytopf.keySet()){
            if(mapCourTargets.get(mapOpptyLineItem.get(opptyId)[0].Opportunity.CourseId__c).Course__r.Mass_Sampling__c){
                if(sampleprod.containsKey(opptytopf.get(opptyId))){
                    if(sampleprod.get(opptytopf.get(opptyId)).Apttus_Config2__RelatedProducts__r.size()>0){
                        for(Id  uniContactId : mapCourseContact.get(mapOpptyLineItem.get(opptyId)[0].Opportunity.CourseId__c)){
                             Order orderObj = new Order();
                             orderObj.AccountId = mapCourTargets.get(mapOpptyLineItem.get(opptyId)[0].Opportunity.CourseId__c).Account__c;
                             orderObj.OpportunityId =opptyId;
                             orderObj.EffectiveDate = System.Today(); 
                             orderObj.Pricebook2Id = lstPriceBook[0].id;
                             orderObj.Status = Label.TA_Order_Status; 
                             orderObj.CurrencyIsoCode = mapOpptyLineItem.get(opptyId)[0].Opportunity.CurrencyIsoCode; 
                             orderObj.CompanyAuthorizedByid = mapCourTargets.get(mapOpptyLineItem.get(opptyId)[0].Opportunity.CourseId__c).CreatedByid;
                             //System.debug('mapOpptyLineItem.get(opptyId)[0].Opportunity.CourseId__c----->'+mapOpptyLineItem.get(opptyId)[0].Opportunity.CourseId__c);
                             //System.debug('mapCourseContact----->'+mapCourseContact);
                             orderObj.CustomerAuthorizedByid = uniContactId;
                             orderObj.Contact__c= uniContactId;
                             //Added as per email request from Shriya
                             orderObj.ShipToContactId= uniContactId;
                             orderObj.ownerid=mapCourTargets.get(mapOpptyLineItem.get(opptyId)[0].Opportunity.CourseId__c).CreatedByid;
                             orderObj.Type=Label.TA_MassDigitalOrderType;
                             lstOrder.add(orderObj);
                        }//loop through course contact
                    }//end order check condition
                }
            }
        }
        if(!lstOrder.isEmpty()){
             Database.SaveResult[] lstOrderResult= Database.insert(lstOrder,false);        
             if (lstOrderResult != null){
                List<PS_ExceptionLogger__c> errloggerlist=new List<PS_ExceptionLogger__c>();
                for (Database.SaveResult sr : lstOrderResult) {
                    String ErrMsg='';
                    if (!sr.isSuccess() || Test.isRunningTest()){
                        PS_ExceptionLogger__c errlogger=new PS_ExceptionLogger__c();
                        errlogger.InterfaceName__c='Order Insertion';
                        errlogger.ApexClassName__c='PS_PotentialTargetOpptyCreationBatch';
                        errlogger.CallingMethod__c='Execute';
                        errlogger.UserLogin__c=UserInfo.getUserName(); 
                        errlogger.recordid__c=sr.getId();
                        for(Database.Error err : sr.getErrors()) 
                          ErrMsg=ErrMsg+err.getStatusCode() + ': ' + err.getMessage(); 
                        errlogger.ExceptionMessage__c=  ErrMsg;                          
                        errloggerlist.add(errlogger);    
                    }
                }
                if(errloggerlist.size()>0){insert errloggerlist;}
             }
             
             Set<Id> setOrderId = new Set<Id>();
             for(Database.SaveResult resultObj : lstOrderResult){
                    if(resultObj.isSuccess())
                           setOrderId.add(resultObj.getId());
             }
             List<Order> lstInsertedOrder = [Select id,Opportunityid from Order where id in :setOrderId limit 50000];
             //System.debug('lstInsertedOrder ------------>'+lstInsertedOrder );                                                   
              //Product2.Medium2__c
             for(Order orderObj : lstInsertedOrder){
                    if(mapOpptyLineItem.containsKey(orderObj.Opportunityid)){
                        for(OpportunityLineItem lineItemObj :mapOpptyLineItem.get(orderObj.Opportunityid) ){
                            OrderItem  orderLineItemObj = new OrderItem();
                            orderLineItemObj.Orderid =orderObj.Id; 
                            orderLineItemObj.Status__c = Label.TA_Order_Item_Status;
                            orderLineItemObj.Quantity= 1;
                            //orderLineItemObj.UnitPrice= lineItemObj.UnitPrice;
                            //orderLineItemObj.PricebookEntryId= lineItemObj.PricebookEntryId;
                            orderLineItemObj.UnitPrice = mapordPriceLst.get(opid.get(opptytopf.get(orderObj.Opportunityid))).Net_Price__c;
                            orderLineItemObj.PricebookEntryId= mapordPrceBook.get(opid.get(opptytopf.get(orderObj.Opportunityid))).Id;
                            orderLineItemObj.Shipping_Method__c = Label.TA_Order_Ship_Method;
                            //Added as per Shriya's email
                            orderLineItemObj.Digital_Product_System_Added__c = true;
                            lstOrderLineitem.add(orderLineItemObj);
                         }  
                    }
              }   //end of order line item loop
              if(!lstOrderLineitem.isEmpty()){
                  //insert lstOrderLineitem;
                  Database.SaveResult[] lstOrderLineitemResult= Database.insert(lstOrderLineitem,false);
                  if (lstOrderLineitemResult!= null){
                    List<PS_ExceptionLogger__c> errloggerlist=new List<PS_ExceptionLogger__c>();
                    for (Database.SaveResult sr : lstOrderLineitemResult) {
                        String ErrMsg='';
                        if (!sr.isSuccess() || Test.isRunningTest()){
                            PS_ExceptionLogger__c errlogger=new PS_ExceptionLogger__c();
                            errlogger.InterfaceName__c='Order Line Item Insertion';
                            errlogger.ApexClassName__c='PS_PotentialTargetOpptyCreationBatch';
                            errlogger.CallingMethod__c='Execute';
                            errlogger.UserLogin__c=UserInfo.getUserName(); 
                            errlogger.recordid__c=sr.getId();
                            for(Database.Error err : sr.getErrors()) 
                              ErrMsg=ErrMsg+err.getStatusCode() + ': ' + err.getMessage(); 
                            errlogger.ExceptionMessage__c=  ErrMsg;  
                            errloggerlist.add(errlogger);    
                        }
                    }
                    if(errloggerlist.size()>0){insert errloggerlist;}
                }
            
            }                        
        }
                                                      
  }//end of method
                
    //<This method gets invoked from Execute Method , used for mapping product in use with opportunity>
   @TestVisible private void mapProductInUsetoOpportunity(Map<ID,Generate_Potential_Target__c> mapCourTargets , Map<Id,Opportunity> mapOppty){
        if(!mapCourTargets.isEmpty() && !mapOppty.isEmpty()){
              Set<Id> avoidDup = new Set<Id>();
              List<Asset> lstProdinuseOppty = new List<Asset>();
              for(Opportunity opptyObj : mapOppty.values()){
                  if(!avoidDup.contains(mapCourTargets.get(opptyObj.courseID__c).Product_In_Use__c)){
                      Asset assetObj = new Asset();
                      assetObj.id = mapCourTargets.get(opptyObj.courseID__c).Product_In_Use__c;
                      assetObj.Opportunity__c = opptyObj.id;
                      lstProdinuseOppty.add(assetObj);
                      avoidDup.add(mapCourTargets.get(opptyObj.courseID__c).Product_In_Use__c);
                  }
              }
            //System.debug('lstProdinuseOppty------>'+lstProdinuseOppty);        
            try{
                if(!lstProdinuseOppty.isEmpty())
                    Database.SaveResult[] results = Database.Update(lstProdinuseOppty, false);
            }
            catch(DmlException exce){
                //Logic Should be built for Error Logging
                System.debug('Inside Target Updation Exception---->');
            }
        }
    }

    //<This method gets executed acutomatically when the batch job is execution mode.>
     global void finish(Database.BatchableContext BC){
       //System.debug('mapCourOppty------------>'+mapCourOppty);
       //System.debug('oppttCreatedCourse------------>'+oppttCreatedCourse);

       //Updating Target Potential after Opportunity creation
       List<Generate_Potential_Target__c> potentialLst = new List<Generate_Potential_Target__c>();
       for(Generate_Potential_Target__c potentialObj:lstTargetstoProcess){
           if (potentialObj.product__c == null){
               potentialObj.Action__c = '';
               potentialObj.Status__c=Label.TA_Validation_Failed;
               potentialObj.Processed__c= true;
               potentialLst.add(potentialObj);
            }
            if(oppttCreatedCourse.contains(potentialObj.Course__c)){
                potentialObj.Action__c = '';
                potentialObj.Status__c= Label.TA_Target_Status_Post_Create;
                potentialObj.Processed__c= true;
                potentialLst.add(potentialObj);
            }
        }
        //System.debug('potentialLst------------>'+potentialLst);
        try{
            if(!potentialLst.isEmpty()){
                Database.SaveResult[] results = Database.Update(potentialLst, false);
                if (results != null){
                    List<PS_ExceptionLogger__c> errloggerlist=new List<PS_ExceptionLogger__c>();
                    for (Database.SaveResult sr : results) {
                        String ErrMsg='';
                        if (!sr.isSuccess() || Test.isRunningTest()){
                            PS_ExceptionLogger__c errlogger=new PS_ExceptionLogger__c();
                            errlogger.InterfaceName__c='Update Potential Target';
                            errlogger.ApexClassName__c='PS_PotentialTargetOpptyCreationBatch';
                            errlogger.CallingMethod__c='finish';
                            errlogger.UserLogin__c=UserInfo.getUserName(); 
                            errlogger.recordid__c=sr.getId();
                            for(Database.Error err : sr.getErrors()) 
                              ErrMsg=ErrMsg+err.getStatusCode() + ': ' + err.getMessage(); 
                            errlogger.ExceptionMessage__c=  ErrMsg;  
                            errloggerlist.add(errlogger);    
                        }
                    }
                    if(errloggerlist.size()>0){insert errloggerlist;}
                }
            }
         }  
         catch(DmlException exce){
            //Logic Should be built for Error Logging
            //System.debug('Inside Target Updation Exception---->');
            ExceptionFramework.LogException('Update Potential Target','PS_PotentialTargetOpptyCreationBatch','finish',exce.getMessage(),UserInfo.getUserName(),'');
        }
            
        //Scheduling Batch Again After 60Mins  
        if(!Test.isRunningTest()){
         List<CronTrigger> listCronTrigger = [select Id from CronTrigger where State = 'DELETED' and nextfiretime = null limit 50000];
        if (listCronTrigger.size() > 0){
             for (Integer i = 0; i < listCronTrigger.size(); i++) 
                System.abortJob(listCronTrigger[i].Id); 
        }
        DateTime n = datetime.now().addMinutes(60);
        String cron = '';
        cron += n.second();
        cron += ' ' + n.minute();
        cron += ' ' + n.hour();
        cron += ' ' + n.day();
        cron += ' ' + n.month();
        cron += ' ' + '?';
        cron += ' ' + n.year();
          
        String jobName = Label.TA_Schedule_Job_Status + n.format('MM-dd-yyyy-hh:mm:ss');
        
        PS_PotentialTargetOpptyCreationScheduler objScheduler = new PS_PotentialTargetOpptyCreationScheduler();
        Id scheduledJobID = System.schedule(jobName,cron,objScheduler); 
        }
    }
}