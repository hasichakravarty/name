public class OpportunitieCourseAssets {
    private List<Asset> AssetList;
    private Opportunity Oppty; 
    private OpportunityUniversityCourse__c OUC;
    private integer totalRecs = 0;     
    private integer index = 0;
    private integer blockSize = 4;   
    private Boolean hasAssetsrecords = false;
    private Id UniversityCourse;
    
    public OpportunitieCourseAssets(ApexPages.StandardController controller) {
        this.Oppty= (Opportunity)controller.getRecord();
        try{
         OUC = [Select id, Opportunity__c, UniversityCourse__c From OpportunityUniversityCourse__c where Opportunity__c =: Oppty.Id LIMIT 1];
         system.debug('OUC  :'+OUC);
         if(OUC.UniversityCourse__c != null)
             UniversityCourse =  OUC.UniversityCourse__c;
        }catch (System.QueryException e){
            system.debug('No OpportunityUniversityCourse Record found'+e );
        }
        try{
             if(OUC != null && UniversityCourse != null){
                 totalRecs = [select count() from Asset WHERE Course__c =:UniversityCourse];
                 if(totalRecs != 0){
                     hasAssetsrecords = true;
                 }
             }
        }catch (System.QueryException e){
            system.debug('Aggregate Query error '+e );
        }

    }
    
    public List<Asset> getCourseAssets(){
        AssetList =  Database.Query('SELECT Id, University_Course__c, Name, Product_Author__c, Product_Edition__c, Copyright_Year__c, Publisher__c, ContactId, Contact.Name, Usage__c, Rollover__c, Status, InstallDate FROM Asset WHERE Course__c =:UniversityCourse LIMIT :blockSize OFFSET :index');
        
        system.debug('AssetList :' +AssetList);                   
        return AssetList;
    }
    
    public void beginning(){
        index = 0;
    }
    
    public void previous(){
        index = index - blockSize;
    }
    
    public void next(){
        index = index + blockSize;
    }
    
    public void end() { //user clicked end
        if(math.mod(totalRecs,blockSize)==0)
        index= totalrecs -blockSize; 
        else
        index = totalrecs - math.mod(totalRecs,blockSize);
    }
    
    public boolean getprev(){
        if(index == 0)
            return true;
        else
            return false;
    }
    
    public Boolean getnxt() { //this will disable the next and end buttons
        if (index + blockSize >= totalrecs) 
            return true; 
        else 
            return false;
    }
    
    public Boolean gethasAssets(){
        return hasAssetsrecords;
    }
}