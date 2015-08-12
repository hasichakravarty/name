/*Controller For BulkContactPIUEditPage*/


public with sharing class BulkPIUEditController{

    Public Id courseID;
    public List<AssetsWrapper> assetList {get;set;}
    public Map<String,List<AssetsWrapper>> assetDetails{get;set;}
    public Map<Id,String> productIdWithName{get;set;}
        
    public List<Asset> selectedAssets = new List<Asset>();
    public Asset asset;
    public String primcntmap {get;set;}
    public String schangedcId {get;set;}
    public boolean schangedflg {get;set;}
    public String sproduct{get;set;}

// It returns Asset details
    public Map<String,List<AssetsWrapper>>  getAsset()
    {
        return assetDetails;
    }
        
// It returns productIdWithName
    public Map<Id,String> getProductIdWithName()
    {        
       return productIdWithName;       
    }
        

// to navigate to the courseid page

    public pagereference courseCancelDetailPage(){       
      return new pagereference('/'+courseID);
    }
    
    public void updateContactList(){
        system.debug('Contact that is changed:'+schangedcId);
        system.debug('contact list:'+primcntmap);
        system.debug('Flag:'+schangedflg);
        if(schangedflg == false)
        {
        for (String key : assetDetails.keySet()) {  
             List<AssetsWrapper> assetListOnChange = assetDetails.get(key);    
                  for(AssetsWrapper asswrapper: assetListOnChange){ 
                  system.debug('current selector:'+asswrapper.selected);
                  if (schangedcId != '' && schangedcId != null){
                  System.debug('asswrapper.ass.Contact.id...'+asswrapper.ass.Contact.id+'asswrapper.ass.Primary__c....'+asswrapper.ass.Primary__c);       
                             if(asswrapper.ass.Contact.id==schangedcId && asswrapper.ass.Primary__c == true && asswrapper.ass.Product2id!=sproduct)    
                                 
                                asswrapper.ass.Primary__c = false; 
                                }             

            }        
         }
     }
        schangedflg = null;
        schangedcId ='';
        sproduct='';
    }
    
// to display contacts of PIU on VF page

    public BulkPIUEditController (){    
        primcntmap = '';   
        productIdWithName= new Map<Id,String>();
        courseID= ApexPages.currentPage().getParameters().get('courseId');
        
        List<aggregateResult> results = [select contactid,count(id)Qty from asset where course__c=:courseID and primary__c=true and contactid != '' group by contactid];
        if(results.size()>0)
        {
            for(AggregateResult ar : results)
            {
            String conId=(String)ar.get('contactid');
            primcntmap=primcntmap+conId;
            }    
        }    
        getPIUContacts();
     }

// to display contacts of PIU on VF page
    Public void getPIUContacts()
    {
    assetDetails= new Map<String,List<AssetsWrapper>>();   
    for(Asset a:[Select id,name,Product2id,Product_Author__c from Asset where Course__r.id =:courseID and Status__c ='Active' and Contact.id!='' order by Name])
    {
        String productName_Author = '';
        If(a.Product_Author__c!=null)
         productName_Author=a.Product_Author__c+' '+':'+' '+a.name;
        Else
         productName_Author=a.name;

        If(a.Product2Id!=null){
        productIdWithName.put(a.Product2Id,productName_Author);
        }
    }
    set<ID> productIdSet = new set<ID>();
    productIdSet=productIdWithName.keySet();
    //List<Asset> assList = new List<Asset>();
    for(Asset assetList1:[Select id,Product2Id,name,Contact.name,Usage__c, Status__c, Third_Party_LMS__c,Primary__c
    from Asset where course__c=:courseID and Product2Id IN: productIdSet and Status__c='Active' and Contact.id!=null order by Usage__c,Contact.name])
    {
        if(assetDetails.containsKey(assetList1.Product2Id))
        assetDetails.get(assetList1.Product2id).add(new AssetsWrapper(assetList1,false));
        else{
        List<AssetsWrapper> tempLst1 = new List<AssetsWrapper>();
        tempLst1.add(new AssetsWrapper(assetList1,false));
        assetDetails.put(assetList1.Product2id, tempLst1);
        }
     }
    
}

//Mass update Logic.
    public PageReference getAssetSelected(){
        System.debug('..............mapppppppppp'+assetDetails);
        if(selectedAssets != null && !selectedAssets.isEmpty())
        selectedAssets.clear();
        for (String key : assetDetails.keySet()) {
        
        List<AssetsWrapper> assetList = assetDetails.get(key);
        
            for(AssetsWrapper asswrapper: assetList){        
            //if(asswrapper.selected == true)    
                selectedAssets.add(asswrapper.ass);    
            }
        }
        boolean flag = editAll();    
        if (flag)
            return new pagereference('/'+courseID);
        else
            return null;
    }

    //To get the SelectedAssets
    public List<Asset> getSelectedAssets(){
    if(selectedAssets.size()>0)
    return selectedAssets;
    else
    return null;
    }

// Logic to Edit the assets
    public boolean editAll(){
        try{
            List<Asset> updateAsset = new List<Asset>();
            List<Asset> selAssets=getSelectedAssets();
            
            if(selAssets.size()>0){
            System.debug('selected assets...............'+selAssets.size());
            
            for(Asset a:selAssets){    
               updateAsset.add(a);    
            }
            update updateAsset;
            System.debug('###########Data Updated Successfully###########');
            }   
            return true;        
        }    
        Catch(DMLException e){       
           ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Data Base Error:'+e.getMessage()));        
           return false;   
        }
    }
    

// Wrapper class
     public class AssetsWrapper{    
        public Asset ass{get; set;}    
        public Boolean selected {get; set;}    
        public AssetsWrapper(Asset a,boolean primary)
        {
            ass = a;   
            if(primary!=null)
                 selected =primary;
            else
                selected = false;
        }
    }
}