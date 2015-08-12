// Project: Convert Assets from Product Info.
// Created by: Comity Designs [Developer: Rashi Girdhar]
// Class: ProductsToAssets.cls      
// Description: Custom controller
// Other Package Classes: AssetWrapper.cls
// VisualForce Page: ProductsToAssets.page
// Date: 8/3/2009

/**
 ** Class: ProductsToAssets
**/
public with sharing class ProductsToAssets {

    //Variables
    // The toggleFlag changes from true to false to true, all depending on the user toggling the various
    ///quantity asset view on the VF page. This flag needs to be set to false as the initial load value.
    private Boolean toggleFlag = false;

    // The section Header variables define the heading for the top/editable page block's section header 
    private String sectionHeader;
    private final String sectionHeaderSingle = 'Single Quantity Asset View';
    private final String sectionHeaderMultiple = 'Multiple Quantity Asset View';
    
    // The toggle Button variables define the button label, as the user toggles between the single asset quantity view
    ///and the multiple asset quantity view.
    private String toggleButtonHeader;
    private final String toggleButtonHeaderSingle = 'View Single Quantity Assets';
    private final String toggleButtonHeaderMultiple = 'View Multiple Quantity Assets';

    // SObject variables and Lists
    private Opportunity opportunity;
    private Account account;
    
    // List of Opportunity University Courses
    public list<OpportunityUniversityCourse__c> oucs;    
    
    // List of Opportunity Line Items [Retreived via DB Query]
    private List <OpportunityLineItem> olis;
    
    // Stores final list of assets to be upserted into SFDC
    public List<Asset> assets;
    
    // Stores final list of assetuniversitycourses to be upserted into SFDC
    public List<AssetUniversityCourse__c> assetuniversitycourses = new List<AssetUniversityCourse__c>();
    
    // List of Converted Assets [Retreived via DB Query]
    public List<Asset> convertedAssets;
    
    // Asset object for setting mass status on all entries from VF page.
    private Asset assetStatus = new Asset();
    
    // AssetWrapper lists - aid in defining the view that is displayed to the end-user
    ///Multiple Asset Quantity view, or the, Single Asset Quantity view
    public List<AssetWrapper> assetW;
    private List<AssetWrapper> assetW_Single = new List<AssetWrapper>();
    private List<AssetWrapper> assetW_Multiple = new List<AssetWrapper>();
    
    // Inner Exception Class
    private class InnerException extends Exception {}
    
    // Debug and Exception flags - Only for Test Cases
    Boolean isDebug = false;
    Boolean throwException = false;
    
    /** 
    ** Constructor: takes no arugments 
    ** -isDebug is always false
    **/    
    public ProductsToAssets() {
        try {
            //Call init
            init();
        } catch (InnerException e) {
            System.debug(e.getMessage());
            throw e;
        }
    }
    
    /**
    ** Overloaded Constructor: only for testing purposes, sets isDebug = input argument
    **/
    public ProductsToAssets(Boolean dBug) {
        try {
            // Set isDebug
            this.isDebug = dBug;
            // Call 
            init();
        } catch (InnerException e){
            if(isDebug) System.debug(e.getMessage());
            throw e;
        }
    }
    
    /**
    ** Init Method
    **/
    public void init() {
        try {
            //Set the sectionHeader, AssetWrapper List reference, 
            setSectionHeader();
            setAssetW();
            setToggleButtonHeader();
            
            //Get query parameters - OID & AID [Opportunity ID, Account ID]        
            getOIDQueryParameter();
            getAIDQueryParameter();
            
            //Set Account and Opportunity names
            setAccountOpportunityName();
            
            //Query Opportunity Line Item table and store in opportunity line item list
            setOLIS();
            
            //Query Opportunity University Course table and store in opportunity university course list
            setOUCS();

            //Query the Assets table to isolate Converted Assets on the Account for display 
            setConvertedAssets();
            
            //Utilize the OLI list to set the Asset Wrapper List to be used by the VF Page
            setAssetWrapperList();
                 
            // Setup OLIS to null - speedup controller.
            olis = null;
                                  
        } catch (InnerException e) {
            if(isDebug) System.debug(e.getMessage());
            throw e;
        }    
    }

    // Getters
    /**
    ** getOIDQueryParameter: gets the OID Query parameter [Opportunity ID]
    **/
    public Boolean getOIDQueryParameter(){
        try {
            opportunity = new Opportunity(id=ApexPages.currentPage().getParameters().get('oid'));
            
            if(opportunity.ID == null) {
                throw new InnerException('Manual Exception: OID or AID is Null!');
            }
            
            return true;
            
        } catch (Exception e) {
            if(isDebug) System.debug(e.getMessage());
            throw e;
        }
    }
    
    /**
    ** getAIDQueryParameter: gets the AID Query parameter [Account ID]
    **/    
    public Boolean getAIDQueryParameter(){
        try {
            account = new Account(id=ApexPages.currentPage().getParameters().get('aid'));
            
            if(account.ID == null) {
                throw new InnerException('Manual Exception: OID or AID is Null!');
            }
            
            return true;
            
        } catch (Exception e) {
            if(isDebug) System.debug(e.getMessage());
            throw e;
        }
    }
     
    public String getOpportunityID() {
        return this.opportunity.ID;
    } 
    
    
    public Account getAccount() {
        return this.account;
    }
    
    public Opportunity getOpportunity() {
        return this.opportunity;
    }
    
    public String getAccountID() {
        return this.account.ID;
    }
    
    public String getSectionHeader() {
        return this.sectionHeader;
    }
    
    public Asset getAssetStatus() {
        return assetStatus;
    }
    
    public Boolean getToggleFlag() {
        return this.toggleFlag;
    }
    
    public List<OpportunityLineItem> getOlis() {
        return this.olis;
    }
    
    public String getToggleButtonHeader() {
        return this.toggleButtonHeader; 
    }

    public List<AssetWrapper> getAssetW(){
        return this.assetW;
    }
    
    public List<Asset> getConvertedAssets(){
        return this.convertedAssets;
    }

    public Integer getConvertedAssetsCount(){
        return this.convertedAssets.size();
    }

    
    // Setters
    public void setThrowException(Boolean te) {
        this.throwException = te;
    }
    
    
    /**
    ** setAccountName: runs query to get Account name
    **/ 
    public void setAccountOpportunityName(){
        try {
            Opportunity opp = [Select o.Name, o.Account.Name from Opportunity o where o.ID=:opportunity.ID LIMIT 1];
            this.opportunity.Name = opp.Name;
            this.account.Name = opp.Account.Name;
            
            // For debugging purposes only
            if(throwException) throw new InnerException('Manual Exception!');
            
        } catch (DmlException e) {
            for(Integer i = 0; i < e.getNumDml(); i++)
                if(isDebug) System.debug(e.getDmlMessage(i));
            throw new InnerException(e);
        } catch (InnerException e) {
            if(isDebug) System.debug(e.getMessage());
            throw e;
        }
    }
    
    /**
    ** setSectionHeader:
    ** -if toggleFlag=false, then sectionHeader=sectionHeaderMultiple [displays multiple quantity asset header]
    ** -else, sectionHeader = sectionHeaderSingle [displays single quantity asset header]
    **/
    private void setSectionHeader(){
        if(!toggleFlag)
            sectionHeader = sectionHeaderMultiple;
        else
            sectionHeader = sectionHeaderSingle;
    }
    
    /**
    ** setAssetW:
    ** -if toggleFlag=false, then assetW=assetW_Multiple [displays editable data list for multiple quantity asset view]
    ** -else, assetW=assetW_Single [displays editable data list for single quantity asset view]
    **/
    public void setAssetW(){
        if(!toggleFlag) {
           assetW = assetW_Multiple;
        } else {
           assetW = assetW_Single;
        }
    }
    
    /**
    ** setToggleButtonHeader:
    ** -if toggleFlag=false, then toggleButtonHeader=toggleButtonHeaderSingle [displays button header to toggle to single quantity asset view]
    ** -else, toggleButtonHeader=toggleButtonHeaderMultiple [displays button header to toggle to multiple quantity asset view]
    **/
    public void setToggleButtonHeader() {
        if(!toggleFlag) {
           toggleButtonHeader = toggleButtonHeaderSingle; 
        } else {
           toggleButtonHeader = toggleButtonHeaderMultiple;
        }
    }
    
    /**
    ** setOLIS: runs query on Opportunity Line Item table to retrieve products on opportunity 
    **/
    public void setOLIS() {
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
        
            // For debugging purposes only
            if(throwException) throw new InnerException('Manual Exception!');
        
        } catch (DmlException e) {
            for(Integer i = 0; i < e.getNumDml(); i++)
                if(isDebug) System.debug(e.getDmlMessage(i));
            throw new InnerException(e);
        } catch (InnerException e) {
            if(isDebug) System.debug(e.getMessage());
            throw e;
        }
    }
    
 /**
    ** setOUCS: runs query on Opportunity University Course table to retrieve University Courses on opportunity 
    **/
    public void setOUCS() {
        try {
            oucs=[Select    o.Id, 
                            o.Opportunity__c, 
                            o.UniversityCourse__c
                            
                    from    OpportunityUniversityCourse__c o  
                    where   o.Opportunity__c=:opportunity.ID];
        
            // For debugging purposes only
            if(throwException) throw new InnerException('Manual Exception!');
        
        } catch (DmlException e) {
            for(Integer i = 0; i < e.getNumDml(); i++)
                if(isDebug) System.debug(e.getDmlMessage(i));
            throw new InnerException(e);
        } catch (InnerException e) {
            if(isDebug) System.debug(e.getMessage());
            throw e;
        }
    }
    



    /**
    ** setConvertedAssets: runs query against Assets table to retreive already converted assets against the account for read-only view.
    **/
    public void setConvertedAssets(){
        try {
            convertedAssets = [Select   Name, 
                                        Quantity, 
                                        Price, 
                                        Product2.Name, 
                                        Status, 
                                        InstallDate, 
                                        PurchaseDate, 
                                        UsageEndDate, 
                                        SerialNumber, 
                                        Account.Name, 
                                        Purchase_Opportunity__r.Name 
                                from    Asset 
                                where   Converted_Asset__c=true and
                                        AccountId=:account.ID and
                                        Purchase_Opportunity__r.ID=:opportunity.ID];
            
            // For debugging purposes only
            if(throwException) throw new InnerException('Manual Exception!');                           
                
        } catch (DmlException e){
            for(Integer i = 0; i < e.getNumDml(); i++)
                if(isDebug) System.debug(e.getDmlMessage(i));
            throw new InnerException(e);
        } catch (InnerException e) {
            if(isDebug) System.debug(e.getMessage());
            throw e;
        } 
    }
    
    /**
    ** setAssetWrapperList: creates the single quantity asset list, and the multiple quanity list view
    ** -Depending on the toggleFlag, one or the other will be displayed.
    **/
    public void setAssetWrapperList() {
        try {
            Integer counter=0;
            Asset a1, b1;
            //SMG: variable used to concatenate the Opportunity name and name of the Product
            string combinednames;
            
            for(OpportunityLineItem o: olis) {
                a1 = new Asset();
                b1 = new Asset();
                
                //a1.Name                     = o.PriceBookEntry.Name; //replaced wrapper asset name with concatenated Product and Opportunity Names
                //SMG: variable used to concatenate Product Name and Opportunity Names 
                combinednames               = o.PriceBookEntry.Name + ' + ' + o.Opportunity.Name;            
                
                //SMG: Assigned Asset Name to combinednames variable that concatenates Opportunity and Product Names
                a1.Name                     = combinednames; 
                a1.Product2Id               = o.PriceBookEntry.Product2Id;
                 
                a1.AccountId                = account.Id;
                a1.Purchase_Opportunity__c  = opportunity.Id;
                a1.Contact                  = null;
                
                //Relabeled to the Stock Quantity on the Asset
                a1.Quantity                 = o.Quantity;
                a1.Price                    = o.TotalPrice;
                a1.InstallDate              = o.ServiceDate;
                a1.PurchaseDate             = o.Opportunity.CloseDate;
                //a1.UsageEndDate           = null;
                //a1.SerialNumber           = null;
                a1.Converted_Asset__c       = true;
                //Forecasted Install Date Steven Brimble requested on the Opportunity Product object
                //SMG: Assigned Forecasted Install Date on Asset to Forecasted Install Date on Opportunity Product
                
                //a1.Forecasted_Install_Date__c = o.Forecasted_Install_Date__c;
                //SMG: Assigned Sales Channel on Asset to Sales Channel on the Opportunity Product line item
                
                
                a1.Sales_Channel__c = o.Sales_Channel__c;
                //SMG: Assigned Bookshop on Asset to Bookshop on the Opportunity Product line item
                a1.Bookshop__c = o.Bookshop__c;
                //SMG: Assigned Expected Sales Quantity on Asset to Expected Sales Quantity on Opportunity Product line item
                a1.Expected_Sales_Quantity__c = o.Expected_Sales_Quantity__c;
                //SMG: Assigned Required by Date on Asset to the Required by Date field on the Opportunity Product line item
                a1.Required_by_Date__c = o.Required_by_Date__c;
                //SMG: Assigned Suggested Order Quantity on Asset to Suggested Order Quantity on the Opportunity Product line item
                a1.Suggested_Order_Quantity__c = o.Suggested_Order_Quantity__c;
                //SMG: Assigned Discount on Asset to Discount on the Opportunity Product line item
                a1.Discount__c = o.Discount;
                //SMG: Assigned the Service Date on the Asset to the Service Date on the Opportunity Product Line item
                a1.Service_Date__c = o.ServiceDate;
                //SMG: Assigned the Opportunity Product Line Description on the Asset to the Line Description on the Opportunity Product Line item
                a1.Line_Description__c = o.Description;
                
                //SMG: Assigned the Mode of Delivery on the Asset to the Mode of Delivery on the Opportunity Product Line Item
                a1.Mode_Of_Delivery__c = o.Mode_of_Delivery__c;
                
                //SMG: Assigned the Sales Price/Net Sales Price to the Total Net Price field on the Opportunity Product Line Item
                a1.Net_Sales_Price__c = o.UnitPrice;
                
                /*
                Default Value of Asset should be set to Purchased
                Frank Sullivan: 
                I tested the changes for a couple of opportunities.  How much effort to default status on the Asset to "Purchased"?  It makes sense to add this but I will let u know if it comes up in the meeting with Steven b.
                http://boards.developerforce.com/t5/Visualforce-Development/Assign-default-value-to-an-inputfield-of-type-picklist/td-p/94256
                http://boards.developerforce.com/t5/Visualforce-Development/Assign-a-default-value-to-a-field/td-p/74752
                */
                
                a1.Status = 'Purchased';
                             
                assetW_Multiple.add(new AssetWrapper(a1, o.Id));
                
                b1 = a1.clone();
                
                if(o.Quantity > 1.00){
                    b1.Quantity=1.00;
                    
                    b1.Price=o.TotalPrice/(o.Quantity.intValue() == 0? 1 : o.Quantity.intValue());
                }
                
                counter=o.Quantity.intValue();
                for(Integer i=0; i < counter; i++){
                    assetW_Single.add(new AssetWrapper(b1.clone(), o.Id));
                }   
            } 
            
            // For debugging purposes only
            if(throwException) throw new InnerException('Manual Exception!');
            
        }catch (Exception e){
            if(isDebug) System.debug(e.getMessage());
            throw e;
        }
        
    }
    
    /**
    ** setAssetLists: creates the final asset list to be upserted 
    **/
    public void setAssetLists() {
        try {
            assets = new List<Asset>();
            
            for(AssetWrapper aW1: assetW) {
                if(aW1.getIsAssetSelected())
                    assets.add(aW1.getAsset().clone());
            }
            
            // For debugging purposes only
            if(throwException) throw new InnerException('Manual Exception!');
            
        } catch (Exception e) {
            if(isDebug) System.debug(e.getMessage());
            throw e;
        }
    }
    
    // PageReference Methods for handling buttons on the VF page
    /** 
    ** Cancel Button
    **/
    public PageReference cancel() {
        try {
            PageReference opportunityPage = new ApexPages.StandardController(opportunity).view();
            opportunityPage.setRedirect(true);
            
            // For debugging purposes only
            if(throwException) throw new InnerException('Manual Exception!');
            
            return opportunityPage;
        } catch (Exception e) {
            if(isDebug) System.debug(e.getMessage());
            throw e;
        } 
    }

    /**
    ** Toggle Button - 'View Single Asset Quantities' / 'View Multiple Asset Quantities'
    **/
    public PageReference toggleView() {
        try {
            if(toggleFlag) {
                toggleButtonHeader = toggleButtonHeaderSingle;
                sectionHeader = sectionHeaderMultiple;
                assetW = assetW_Multiple;
                
                toggleFlag = false;
            } else {
                toggleButtonHeader = toggleButtonHeaderMultiple;
                sectionHeader = sectionHeaderSingle;
                assetW = assetW_Single;
                
                toggleFlag = true;
            }
            
            assetStatus.Status = null;
            
            // For debugging purposes only
            if(throwException) throw new InnerException('Manual Exception!');
            
            return null;
        } catch (Exception e) {
            if(isDebug) System.debug(e.getMessage());
            throw e;
        }
    }
    
    /**
    ** selectAll: checks/selects all checkboxes
    **/
    public PageReference selectAll() {
        for(AssetWrapper aW: assetW){
            aW.setIsAssetSelected(true);
        }
        
        return null;
    }
    
    /** 
    ** deslectAll: unchecks all checkboxes
    **/
    public PageReference deselectAll() {
        for(AssetWrapper aW: assetW){
            aW.setIsAssetSelected(false);
        }
        
        return null;
    }
    
    /**
    ** selectAllStatus: Global select all picklist for Status
    **/
    public PageReference selectAllStatus() {
        for(AssetWrapper aw: AssetW) {
            aw.getAsset().Status = assetStatus.Status;
        }
        
        return null;
    }

    /** 
    ** Convert Button
    **/
    public PageReference convert() {
        PageReference accountPage;
        try {
            Integer num_of_assets = 0;
     
            // Setup the assets to be upserted
            setAssetLists();
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
                    for(Database.UpsertResult ur : lur){ //loop through assets that were just upserted
                        assetid= ur.Id;
                        for(OpportunityUniversityCourse__c ouc : oucs){  //loop through all university courses associated with this opportunity
                            universitycourseid = ouc.UniversityCourse__c;                     
                            assetuniversitycourses.add(new AssetUniversityCourse__c(Asset__c=assetid,UniversityCourse__c=universitycourseid)); //create the junction record
                        }
                    }
                    insert assetuniversitycourses;
                }              
                //end code for inserting AssetUniversityCourse for each opportunity product converted to an asset
                 
                // Goto Account
                accountPage = new ApexPages.StandardController(account).view();
                accountPage.setRedirect(true);
                return accountPage;
    
            } else {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'ERROR: You have not selected any line items!');
                ApexPages.addMessage(myMsg);
                return null;
            }
        } catch (Exception e) {
            if(isDebug) System.debug('Convert: ' + e.getMessage());            
            throw e;
        }
    }
}