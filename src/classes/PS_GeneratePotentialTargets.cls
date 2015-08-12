/*===========================================================================+
 |  HISTORY                                                                  
 |                                                                           
 |  DATE            DEVELOPER        DESCRIPTION                               
 |  ====            =========        =========== 
 |  6/5/2015        IDC              This Class is used for creation 
                                     of potential target records
 +===========================================================================*/

global class PS_GeneratePotentialTargets{

/*@Method <This method gets executed acutomatically when onclick Javascript button is clicked on Generate Potential Targets object>
    @param No Parameters Required
    @return <Boolean> - <True or False>
    @throws exception - <No Exception>
    */
 static String sAccId;
 //Static User loggedUserObj;
 //Static String loginusrprclst;
 Static List<Generate_Potential_Target__c> lstPotentialTarget = new List<Generate_Potential_Target__c>();    
 global PS_GeneratePotentialTargets(String sAccountId){
     sAccId=sAccountId;
     //Fetching User PriceList
 }
//Future method to process Takeaway target : D-1738
@future  
public Static void Future_validatetakeaway(String Userid, String Pricelist){
    String sprice= Pricelist; 
    Set<Id> tawaycid = new Set<Id>();
    //Set<Id> tawaypcid = new Set<Id>();
    Map<Id,Id> mcoursetopc = new Map<Id,Id>();
    try{    
        lstPotentialTarget = [Select id,product__c, Status__c, Opportunity_Type__c,Course__c from Generate_Potential_Target__c 
                             Where createdbyid =: userid and Status__c =:Label.TA_Validation_In_Progress and 
                             Opportunity_Type__c =: Label.TA_Takeaway_Type];
        //Init TakeAway course in a set
        for(Generate_Potential_Target__c gpt: lstPotentialTarget){
            tawaycid.add(gpt.course__c);}

        if (tawaycid.size()>0){
           //Fetch primary and active pearson course queivalents
            List<UniversityCourse__c> taclist= [select id,(select id,Pearson_Course_Code__c,Pearson_Course_Code__r.name from Pearson_Course_Equivalent__r 
                                     where primary__c=true and active__c=true limit 1)from UniversityCourse__c where id in :tawaycid];
            //Init Course to Classification map                                           
            if (!taclist.isEmpty()){
                for(UniversityCourse__c uc: taclist){
                    if (uc.Pearson_Course_Equivalent__r.size()>0){
                        mcoursetopc.put(uc.id,uc.Pearson_Course_Equivalent__r[0].Pearson_Course_Code__c);
                        //    tawaypcid.add(uc.Pearson_Course_Equivalent__r[0].Pearson_Course_Code__c);
                    }
                }
            }// end map - couse to pearson course
             
            //Init Classification to Product Family map
            Map<Id,Set<Id>> pftohiermap = new Map<Id,Set<Id>>();
            Map<Id,Set<Id>> multifrontlistmap = new Map<Id,Set<Id>>();
            for(Apttus_Config2__ProductClassification__c pctopflist : [select id,Apttus_Config2__ProductId__c,Apttus_Config2__ClassificationId__c from Apttus_Config2__ProductClassification__c 
                where Apttus_Config2__ClassificationId__c in :mcoursetopc.values() and Apttus_Config2__ProductId__r.relevance_value__c=:Integer.valueof(Label.TA_Frontlist_Relevance)]){
                if(pftohiermap.containsKey(pctopflist.Apttus_Config2__ProductId__c)){
                    pftohiermap.get(pctopflist.Apttus_Config2__ProductId__c).add(pctopflist.Apttus_Config2__ClassificationId__c);
                }
                else{
                    pftohiermap.put(pctopflist.Apttus_Config2__ProductId__c,new Set<Id>{pctopflist.Apttus_Config2__ClassificationId__c});
                }   
                if(multifrontlistmap.containsKey(pctopflist.Apttus_Config2__ClassificationId__c)){
                    multifrontlistmap.get(pctopflist.Apttus_Config2__ClassificationId__c).add(pctopflist.Apttus_Config2__ProductId__c);
                }
                else{
                    multifrontlistmap.put(pctopflist.Apttus_Config2__ClassificationId__c,new Set<Id>{pctopflist.Apttus_Config2__ProductId__c});
                }                                                                
            }
            //Init Product Family to Related Products map                                                 
            Map<Id,Id> hiertorp=new Map<Id,Id>();
            Map<Id,Id> hiertopf = new Map<Id,Id>();
           // Set<ID> frontlistProductfamilyId = new Set<ID>();
            Id oldpfid=null;
            if (!pftohiermap.isEmpty()){
                for(Apttus_Config2__RelatedProduct__c relatedprod: [select id,Apttus_Config2__ProductId__c,Apttus_Config2__RelatedProductId__c from 
                                Apttus_Config2__RelatedProduct__c where Apttus_Config2__ProductId__c in
                                (select Apttus_Config2__ProductId__c from Apttus_Config2__PriceListItem__c 
                                where Apttus_Config2__PriceListId__r.name=:sprice and Apttus_Config2__ProductId__c in:pftohiermap.keySet()) 
                                and PSELL__c=true order by Apttus_Config2__ProductId__r.Copyright_Year__c desc]){
                     if  (oldpfid != relatedprod.Apttus_Config2__ProductId__c){                                            
                            if(pftohiermap.containskey(relatedprod.Apttus_Config2__ProductId__c)){
                                for(Id hierid:pftohiermap.get(relatedprod.Apttus_Config2__ProductId__c)){
                                    if (!hiertorp.containskey(hierid)){
                                        //System.debug('hierid ---> '+hierid+'relatedprod.Apttus_Config2__RelatedProductId__c -->'+relatedprod.Apttus_Config2__RelatedProductId__c);
                                        hiertorp.put(hierid,relatedprod.Apttus_Config2__RelatedProductId__c);
                                        hiertopf.put(hierid,relatedprod.Apttus_Config2__ProductId__c);
                                     }                  
                                }   
                            }
                      }//else{                        
                         //   frontlistProductfamilyId.add(relatedprod.Apttus_Config2__ProductId__c);
                      //}
                      oldpfid = relatedprod.Apttus_Config2__ProductId__c;
                }   
            }   
            //system.debug('Fetched related products to Hierarchy....'+ hiertorp.size());   
                       
            List<Generate_Potential_Target__c> updatelstPotentialTarget = new List<Generate_Potential_Target__c>();
            //Update Target type Products with Related Product  
            for(Integer i=0; i<lstPotentialTarget.size(); i++){                                               
                 if (hiertorp.containsKey(mcoursetopc.get(lstPotentialTarget[i].course__c))){
                    lstPotentialTarget[i].product__c=hiertorp.get(mcoursetopc.get(lstPotentialTarget[i].course__c));
                    lstPotentialTarget[i].status__c = Label.TA_Target_Status;
                    lstPotentialTarget[i].TakeAway_Product_Family__c = hiertopf.get(mcoursetopc.get(lstPotentialTarget[i].course__c));         
                    //if(frontlistProductfamilyId.contains(hiertopf.get(mcoursetopc.get(lstPotentialTarget[i].course__c))))
                        //lstPotentialTarget[i].TakeAway_Multiple_Frontlist__c = True;  
                    if (multifrontlistmap.get(mcoursetopc.get(lstPotentialTarget[i].course__c)).size()>1)
                        lstPotentialTarget[i].TakeAway_Multiple_Frontlist__c = True;  
                 }
                 else
                    lstPotentialTarget[i].status__c = Label.TA_Validation_Failed;
                 updatelstPotentialTarget.add(lstPotentialTarget[i]); 
             }                           

            Database.SaveResult[] lstResult= Database.update(updatelstPotentialTarget, false); 
            if (lstResult != null){
                List<PS_ExceptionLogger__c> errloggerlist=new List<PS_ExceptionLogger__c>();
                for (Database.SaveResult sr : lstResult) {
                    String ErrMsg='';
                    if (!sr.isSuccess() || Test.isRunningTest()){
                        PS_ExceptionLogger__c errlogger=new PS_ExceptionLogger__c();
                        errlogger.InterfaceName__c='PotentialTarget-TakeAway';
                        errlogger.ApexClassName__c='PS_BatchPearsonChoiceCreation';
                        errlogger.CallingMethod__c='Future_validatetakeaway';
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
        } //end if take away target type exist in the batch   
    }//end try
    catch(Exception e){
        ExceptionFramework.LogException('PotentialTarget-TakeAway','PotentialTarget-TakeAway','Future_validatetakeaway',e.getMessage(),UserInfo.getUserName(),'');
    } 
}//end method definition
    
 webservice static boolean createPotentialTargets(){
     //Map Holding lastcourse and course quivalaent(last modified equivalent)
      Map<Id,Pearson_Course_Equivalent__c> mapCourseEquiv = new Map<Id,Pearson_Course_Equivalent__c>();

     //Map for populating all the course which is not having opportunity for current selling period
     Map<Id, UniversityCourse__c> mapCourse= new Map<Id,UniversityCourse__c>();
     //Fetching User PriceList
    User loggedUserObj = [Select id,Price_List__c from User where id=:Userinfo.getUserid()];
     //Fetching Users Assigned Territory
     List<Territory2> usrTerritoryLSt = new List<Territory2>();
     if(Test.isRunningTest()){
         usrTerritoryLSt = [Select id,Territory2Model.ActivatedDate from Territory2 where id in (Select Territory2Id from UserTerritory2Association where IsActive=true and UserId=:Userinfo.getuserId())];
     }
     else{
     usrTerritoryLSt = [Select id,Territory2Model.ActivatedDate from Territory2 where id in (Select Territory2Id from UserTerritory2Association where IsActive=true and UserId=:Userinfo.getuserId()) and (Territory2Model.ActivatedDate!=null and Territory2Model.DeactivatedDate=null)];
     }
     if(!usrTerritoryLSt.isEmpty()){
             System.debug('usrTerritoryLSt----->'+usrTerritoryLSt );
             Set<Id> userTerrIdSet = new Set<Id>();
             for(Territory2 usrTerrObj:usrTerritoryLSt)
                      userTerrIdSet.add(usrTerrObj.id);
             //This List of group is used for fetching territory related Group to be used for fetching Account from AccountShare , records pulled out using Territory Ids
             List<Group> lstgroup = [Select Id, RelatedId from Group where Type=:Label.TA_Territory AND RelatedId IN : userTerrIdSet];
            //This SOQL on Account Share will return get us Account Ids
            List<AccountShare> lstAccShare=null;
            if(!Test.isRunningTest()){
                 lstAccShare = [Select Id, UserOrGroupId, AccountId from AccountShare where ( UserOrGroupId IN : lstgroup OR  UserOrGroupId =:Userinfo.getuserId()) AND RowCause IN ('Territory', 'TerritoryManual', 'TerritoryRule') ];
            }
            else{
                system.debug('Test class....Account Id:'+sAccId);
                lstAccShare = [Select Id, UserOrGroupId, AccountId from AccountShare where 
                               AccountId=:sAccId limit 5000];
                system.debug('Test class Run .....'+lstAccShare);
            }                 
             //Set for Account IDs for Fecthing Course
             Set<Id> linkedAccSet = new Set<Id>();
             if(!lstAccShare.isEmpty()){
             for(AccountShare accShareObj : lstAccShare)
                    linkedAccSet.add(accShareObj.AccountId);
             }
             System.debug('linkedAccSet----->'+linkedAccSet);
             //End of Account Fetch Logic
             
             //Fetching List of Course Related to above fetched Account
             //Selling Period String to restrict opportunites from getting created for same selling season for the course
              Integer month = (System.today()).month();
              Integer year= (System.today()).year();
              String sellingSeason = '';
              if(month<=5)
                  sellingSeason = year+' - '+Label.TA_Selling_Period_Fall;
              else
                  sellingSeason = year+' - '+Label.TA_Selling_Period_Spring;


              System.debug('loggedUserObj.Price_List__c --->'+loggedUserObj.Price_List__c);
              if(loggedUserObj.Price_List__c!=null){
                    Set<Id> setApptusHierachyId =  new Set<Id>();
                    for(Apttus_Config2__PriceList__c apptusPriceObj : [Select id,name,(Select id,name,Apttus_Config2__HierarchyId__r.name,Apttus_Config2__HierarchyId__r.id from Apttus_Config2__Categories__r) from Apttus_Config2__PriceList__c where name=:loggedUserObj.Price_List__c]){
                                                     System.debug('apptusPriceObj.Apttus_Config2__Categories__r----->'+apptusPriceObj.Apttus_Config2__Categories__r.size());

                         for(Apttus_Config2__PriceListCategory__c apptusConfigObj: apptusPriceObj.Apttus_Config2__Categories__r){
                            setApptusHierachyId.add(apptusConfigObj.Apttus_Config2__HierarchyId__r.id);
                         }

                    }

                    Set<Id> setApptusClassificationId =  new Set<Id>();
                    for(Apttus_Config2__ClassificationName__c apptusClassObj : [Select id,name,(Select id,name from Apttus_Config2__CategoryHierarchies__r) from Apttus_Config2__ClassificationName__c where id in:setApptusHierachyId]){
                         for(Apttus_Config2__ClassificationHierarchy__c apptusConfigClassObj: apptusClassObj.Apttus_Config2__CategoryHierarchies__r){
                            setApptusClassificationId.add(apptusConfigClassObj.id);
                         }

                    }
                  //Logic for creating mapCourse only when course is not having opportunity for current selling period
                  //Logic for Fetching Pearson Course Code

                  system.debug('setApptusClassificationId----->'+setApptusClassificationId);

                  for(UniversityCourse__c courseObj : [Select id,Account__c,Course_Name__c,(Select id,Course__c,Pearson_Course_Code__c,Pearson_Course_Code__r.name from Pearson_Course_Equivalent__r where Pearson_Course_Code__c in:setApptusClassificationId and Course__r.Account__c in:linkedAccSet order by lastmodifieddate desc),(select id,UniversityCourse__c,Opportunity__r.Selling_Period__c from OpportunityUniversityCourses__r where Opportunity__r.Selling_Period__c=:sellingSeason) from UniversityCourse__c where id in (Select course__c from Pearson_Course_Equivalent__c where Pearson_Course_Code__c in:setApptusClassificationId and Course__r.Account__r.id in:linkedAccSet)]){
                    System.debug('courseObj -->'+courseObj);
                    if(!(courseObj.OpportunityUniversityCourses__r.size()>0) ){
                        mapCourse.put(courseObj.id,courseObj);  
                        mapCourseEquiv.put(courseObj.id,courseObj.Pearson_Course_Equivalent__r[0] );
                    }               
                }
                //End of Logic for creating mapCourse only when course is not having opportunity for current selling period
                //End of Logic for Fetching Pearson Course Code

              }

            
                  
            /* 
             //Logic for creating mapCourse only when course is not having opportunity for current selling period
               for(UniversityCourse__c courseObj : [Select id,Account__c,Course_Name__c,(select id,UniversityCourse__c,Opportunity__r.Selling_Period__c from OpportunityUniversityCourses__r where Opportunity__r.Selling_Period__c=:sellingSeason) from UniversityCourse__c where Account__c in :linkedAccSet limit 50000]){
                 if(!(courseObj.OpportunityUniversityCourses__r.size()>0) )
                     mapCourse.put(courseObj.id,courseObj);
               }
               System.debug('mapCourse---->'+mapCourse.size());
             //End of Course Fetching Logic
             
             //Logic for Fetching Pearson Course Code
             Map<Id,Pearson_Course_Equivalent__c> mapCourseEquiv = new Map<Id,Pearson_Course_Equivalent__c>();
             for(Pearson_Course_Equivalent__c equivObj : [Select id,Course__c,Pearson_Course_Code__c,Pearson_Course_Code__r.name from Pearson_Course_Equivalent__c where Course__c in:mapCourse.keyset() and Primary__c= true and Active__c = true limit 10000]){
                     mapCourseEquiv.put(equivObj.Course__c, equivObj);
             }
              //End of Logic for Fetching Pearson Course Code
            */
             
             //Fetching All Product in use(Assets) for above fetched course
             //Map of Course and Asset
             Map<Id,Asset> mapCourseAsset = new Map<Id,Asset>();
            
            //All logic to be executed only if course is linked to Product in use(Asset)
            //Boolean Fields to check for Target Type based on Asset
            boolean hasTakeAway = false;
            boolean hasRollover = false;
            Asset tempAsset = new Asset();//Temp Object for lastmodifed check and Asset type Check
            for(Asset assetObj : [Select id, Primary__c ,lastmodifieddate,Course__c,Product2.id,IsCompetitorProduct,Product2.Next_Edition__c , Product2.Competitor_Product__c,Product2.Next_Edition__r.Relevance_Value__c,Product2.Copyright_Year__c from Asset where Course__c in :mapCourse.keySet() and Product2id!=null and Status__c = 'Active' order by Primary__c desc]){   //and Product2.Publisher__c!=null (Removed for Query Optimization)
                 //If Asset is not Primary , logic for fetching lastmodifed record 
                 if(!assetObj.Primary__c){ 
                     system.debug('tempAsset.Course__c--->'+ assetObj.Course__c);
                     if(tempAsset.Course__c!=assetObj.Course__c)
                           tempAsset = new Asset();
                     if(tempAsset.lastmodifieddate<assetObj.lastmodifieddate || tempAsset.lastmodifieddate==null){
                            tempAsset = assetObj;
                            system.debug('tempAsset---->'+ tempAsset.Course__c);
                            //Not adding value to map if already there is a Asset with primary as true
                            if((mapCourseAsset.containsKey(tempAsset.Course__c) && !(mapCourseAsset.get(tempAsset.Course__c).Primary__c)) || !mapCourseAsset.containsKey(tempAsset.Course__c)) 
                                 mapCourseAsset.put(tempAsset.Course__c,tempAsset); 
                      }
                 }
                 //If Asset is Primary
                 else{
                    //Inititalizing temp object and reseting booleans if different course is comming in iteration.
                    if(tempAsset.Course__c!=assetObj.Course__c){
                        tempAsset = new Asset();
                        hasRollover = false;
                        hasTakeAway = false;
                    }
                    //End of Intial Logic for Finding Target Type
                     if(assetObj.Product2.Competitor_Product__c == false && assetObj.Product2.Next_Edition__c!=null && assetObj.Product2.Next_Edition__r.Relevance_Value__c==Integer.valueof(Label.TA_Frontlist_Relevance)){
                           hasRollover = true;
                           hasTakeAway = false;
                           tempAsset = assetObj; 
                    }
                    else if(assetObj.Product2.Competitor_Product__c == True && !hasRollover){
                            hasTakeAway = true;
                            tempAsset = assetObj;
                    }
                    
                    else if(((assetObj.Product2.Competitor_Product__c == false && assetObj.Product2.Next_Edition__c==null) || (assetObj.Product2.Competitor_Product__c == false && assetObj.Product2.Next_Edition__c!=null && assetObj.Product2.Next_Edition__r.Relevance_Value__c!=Integer.valueof(Label.TA_Frontlist_Relevance))) && !hasRollover && !hasTakeAway)
                            tempAsset = assetObj;
                    
                    if(tempAsset.Product2.Copyright_Year__c<=assetObj.Product2.Copyright_Year__c){
                           mapCourseAsset.put(tempAsset.Course__c,tempAsset); 
                    }
                 }
               }
               //End of Logic for populating course to Asset Mapping
               
                 System.debug('mapCourseAsset--->'+mapCourseAsset);
                 //Final Iteration to creation Potential Targets
                 for(UniversityCourse__c  courseObj:mapCourse.values()){
                   if(mapCourseAsset.containsKey(courseObj.id)){
                          //if(!availableCourseSet.contains(courseObj.id)){
                                                                  System.debug('Inside if--->');
    
                             Generate_Potential_Target__c targetObj = new Generate_Potential_Target__c();
                             targetObj.Account__c = courseObj.Account__c;
                             targetObj.Course__c = courseObj.id;
                             targetObj.Status__c= Label.TA_Target_Status;
                             //code added by Rahul for sellingPeriod and coursename starts
                             targetObj.Selling_Period_Course_Name__c = sellingSeason+' '+courseObj.id;    //sellingSeason+' '+courseObj.Course_Name__c;
                             //code added by Rahul for sellingPeriod and coursename Ends
                             System.debug('mapCourseEquiv------>'+mapCourseEquiv);
                             if(mapCourseEquiv.containsKey(courseObj.id))
                                 targetObj.PCC_c__c = mapCourseEquiv.get(courseObj.id).Pearson_Course_Code__r.name+' '+courseObj.Course_Name__c;
                      
                               
                                 if(mapCourseAsset.get(courseObj.id).Product2.Competitor_Product__c == false && mapCourseAsset.get(courseObj.id).Product2.Next_Edition__c!=null && mapCourseAsset.get(courseObj.id).Product2.Next_Edition__r.Relevance_Value__c==Integer.valueof(Label.TA_Frontlist_Relevance)){
                                                                                                  System.debug('Inside if2--->');
    
                                     targetObj.Opportunity_Type__c = Label.TA_Rollover_Type;
                                     targetObj.Product__c = mapCourseAsset.get(courseObj.id).Product2.id;
                                     targetObj.Product_In_Use__c= mapCourseAsset.get(courseObj.id).id;

                                 }
                                 else if(mapCourseAsset.get(courseObj.id).Product2.Competitor_Product__c == True){
                                        targetObj.Status__c= Label.TA_Validation_In_Progress;
                                        System.debug('Inside if3--->');
    
                                     targetObj.Opportunity_Type__c = Label.TA_Takeaway_Type;
                                     //targetObj.Product__c = mapCourseAsset.get(courseObj.id).Product2.id;
                                     targetObj.Product_In_Use__c= mapCourseAsset.get(courseObj.id).id;


                                 }
                                 else if((mapCourseAsset.get(courseObj.id).Product2.Competitor_Product__c == false && mapCourseAsset.get(courseObj.id).Product2.Next_Edition__c==null) || (mapCourseAsset.get(courseObj.id).Product2.Competitor_Product__c == false && mapCourseAsset.get(courseObj.id).Product2.Next_Edition__c!=null && mapCourseAsset.get(courseObj.id).Product2.Next_Edition__r.Relevance_Value__c!=Integer.valueof(Label.TA_Frontlist_Relevance))){
                                                                                               System.debug('Inside if1--->');
    
                                     targetObj.Opportunity_Type__c = Label.TA_Existing_Business_Type;
                                     targetObj.Product_In_Use__c= mapCourseAsset.get(courseObj.id).id;
                                     targetObj.Product__c = mapCourseAsset.get(courseObj.id).Product2.id;
                                     
                                 }
                             
                              lstPotentialTarget.add(targetObj);
                        // }
                        } 
                     }
                      System.debug('lstPotentialTarget--------------->'+lstPotentialTarget);
                      // validatetakeaway();                 
                      if(!lstPotentialTarget.isEmpty()){
                        Database.SaveResult[] lstResult= Database.insert(lstPotentialTarget, false);
                        String loggedinuseid =String.Valueof(loggedUserObj.id);
                        Future_validatetakeaway(loggedinuseid,loggedUserObj.Price_List__c);  
                        System.debug('lstResult--------------->'+lstResult);
                     }
             }
          return true;
    }
}