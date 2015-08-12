global class OppProductToAsset {
    //Class to convert opportunity line items to Product in use.
    private Static Opportunity opportunity;
    private static Account account;
    private static List <OpportunityLineItem> olis {get;set;}
    private Static List<Asset> assets = new List<Asset>();
    // List of Opportunity University Courses
    public static list<OpportunityUniversityCourse__c> oucs {get;set;}   
    private static List<OpportunityContactRole> ocrs {get;set;}
    // Stores final list of assetuniversitycourses to be upserted into SFDC
    public static List<AssetUniversityCourse__c> assetuniversitycourses = new List<AssetUniversityCourse__c>();
    
     //method called from button click to convert opportunity line items to assets 
    webservice static void convertToAsset(Id oppId,Id accId) {
         try {
            //system.debug('Record you work on : '+oppId+';'+accId);
            opportunity = new Opportunity(id=oppId);
            account = new Account(id=accId);
            system.debug('Opportunity id-->'+opportunity.id);
            if(opportunity.ID == null) {
                system.Debug('Opp id or Acc id is null');
            }
            setOLIS();
            setOUCS();
            convert();
         } catch (Exception e) {
            System.debug(e.getMessage());
            throw e;
         }
            
    }
    //Method definition to get opportunity line items.
    public List<OpportunityLineItem> getOlis() {
       return olis;
    }
    
     /**
    ** setOUCS: runs query on Opportunity University Course table to retrieve University Courses on opportunity 
    **/
    public static void setOUCS() {
        try {
            oucs=[Select    o.Id, 
                            o.Opportunity__c, 
                            o.UniversityCourse__c
                            
                    from    OpportunityUniversityCourse__c o  
                    where   o.Opportunity__c=:opportunity.ID];        
        } catch (DmlException e) {
            for(Integer i = 0; i < e.getNumDml(); i++)
                System.debug(e.getDmlMessage(i));
        } catch (Exception e) {
            System.debug(e.getMessage());
            throw e;
        }
    }
    //Method definition to pull opportunity line items
      public static void setOLIS() {
        try {
            olis=[Select    o.Id, 
                            o.IsDeleted, 
                            o.ListPrice,
                            o.OpportunityId, 
                            o.Opportunity.CloseDate,
                            o.Opportunity.Name, //added Opportunity Name for concatenation in Asset Name
                            o.PricebookEntry.Product2Id,
                            o.PricebookEntryId, 
                            o.PricebookEntry.Name, 
                            o.Quantity, 
                            o.ServiceDate, //Relabeled to the Forecasted Install Date
                            o.TotalPrice, 
                            o.UnitPrice, 
                            //o.Forecasted_Install_Date__c, //Forecasted Install Date field; Displaying in Visualforce page
                            o.Sales_Channel__c, //Sales Channel Picklist field; Displaying in Visualforce page
                            o.Bookshop__c,  //Bookshop Lookup field
                            o.Expected_Sales_Quantity__c,
                            o.Required_by_Date__c, 
                            o.Suggested_Order_Quantity__c,
                            o.Discount,
                            o.Description,
                            o.Mode_of_Delivery__c  //Mode of Delivery Picklist field; Displaying in Visualforce page
                    from    OpportunityLineItem o  
                    where   o.IsDeleted=false and 
                            o.OpportunityId=:opportunity.ID];
        
        
        } catch (DmlException e) {
            for(Integer i = 0; i < e.getNumDml(); i++)
               System.debug(e.getDmlMessage(i));
        } catch (Exception e) {
            System.debug(e.getMessage());
            throw e;
        }
    }
    //Method definition to pull contact details along with their role definitions.
    private static void setContactRoles(){
        try {
            ocrs = [select ContactId,Contact.Name from OpportunityContactRole where OpportunityId =:opportunity.id];
            system.debug('ocrs-->'+ocrs);
        }
        catch (DmlException e) {
            for(Integer i = 0; i < e.getNumDml(); i++)
               System.debug(e.getDmlMessage(i));
        } catch (Exception e) {
            System.debug(e.getMessage());
            throw e;
        }
    }
    //Method definition to create Product In Use
    public static void setAssetList() {
        try {
            setContactRoles();
            system.debug('>>>>>>Start-SetAssetList');
            Integer counter=0;
            Asset a1, b1;
            string combinednames;
            if(!olis.isEmpty()) {
            
                for(OpportunityLineItem o: olis) {
                    if(ocrs.size()>0){
                        for(OpportunityContactRole ocr : ocrs){
                            system.debug('>>>>>>Start2-contact' +ocr.ContactId);
                            a1 = new Asset();
                            a1.Name                     = o.PriceBookEntry.Name;
                            a1.Product2Id               = o.PriceBookEntry.Product2Id;
                            a1.AccountId                = account.Id;
                            a1.Purchase_Opportunity__c  = opportunity.Id;
                            a1.ContactId                = ocr.ContactId;
                            a1.InstallDate              = system.today();
                            a1.Converted_Asset__c       = true;
                          if(o.Discount!=null){
                            a1.Discount__c              =o.Discount;
                             }                            
                            
                            assets.add(a1);
                        }
                    }
                    else{
                        a1 = new Asset();
                            a1.Name                     = o.PriceBookEntry.Name;
                            a1.Product2Id               = o.PriceBookEntry.Product2Id;
                            a1.AccountId                = account.Id;
                            a1.Purchase_Opportunity__c  = opportunity.Id;
                            a1.Contact                  = null;
                            a1.InstallDate              = system.today();
                            a1.Converted_Asset__c       = true;
                            
                            if(o.Discount!=null){
                            a1.Discount__c              =o.Discount;
                             }
                             assets.add(a1);
                    }
                } 
            //insert assets;
            }
        }catch (Exception e){
           System.debug(e.getMessage());
            throw e;
        }
        
    }
   // public PageReference convert() {
      public static void convert() {
        
        try {
            Integer num_of_assets = 0;
     
            // Setup the assets to be upserted
            setAssetList();
            num_of_assets = assets.size();
            
            if(num_of_assets > 0) {
                // Insert or Update Assets [Upsert]
                //upsert assets;  //replaced this line with the UpsertResult line below to let us capture asset ids for writing of AssetUniversityCourse records
                
                //begin code for inserting AssetUniversityCourse for each opportunity product converted to an asset
                 Database.UpsertResult[] lur = Database.upsert(assets);
                if(oucs.size()>0){ //don't act unless there are university courses associated with this opportunity
                    //system.debug('OUCS size is '+oucs.size());           
                    id assetid;
                    id universitycourseid;
                    Integer count = 0;
                    List<Asset> Alist = new List<Asset>();
                    system.debug('Entering first for loop');
                    for(Database.UpsertResult ur : lur){ //loop through assets that were just upserted
                        assetid= ur.Id;
                        system.debug('Entered first for loop');
                        Asset assetrec = new Asset(Id=assetid);
                            count=0; 
                            system.debug('Entered if check');
                            for(OpportunityUniversityCourse__c ouc : oucs){  //loop through all university courses associated with this opportunity
                                system.debug('Inside for--->'+ouc);
                                if(count==0)
                                {
                                    system.Debug('Inside If---->'+count);
                                    OpportunityUniversityCourse__c oucRec = [select name,Opportunity__c, Opportunity__r.Primary_Contact__c,UniversityCourse__c from OpportunityUniversityCourse__c where id =: ouc.id];
                                    //assetrec.ContactId =oucRec.Opportunity__r.Primary_Contact__c;
                                    assetrec.Course__c = oucRec.UniversityCourse__c;
                                    assetrec.Status__c = 'Active';
                                    system.debug('assetrec--------->'+assetrec.Contact+ ' ststus-->'+assetrec.Status__c);
                                    Alist.add(assetrec);
                                    system.debug('Alist---------@'+Alist);
                                }
                                count+=1;
                                //universitycourseid = ouc.UniversityCourse__c;                     
                                //assetuniversitycourses.add(new AssetUniversityCourse__c(Asset__c=assetid,UniversityCourse__c=universitycourseid)); //create the junction record                                
                            }
                        
                    }
                    //insert assetuniversitycourses;
                    system.debug('Insert done');
                    update Alist;
                    system.debug('Update done');
                } 
                opportunity.Product_Converted__c = true;
                update opportunity;
                //end code for inserting AssetUniversityCourse for each opportunity product converted to an asset                                 
            }
        } catch (Exception e) {
           System.debug('Convert: ' + e.getMessage());            
           throw e;
        }
    }
}