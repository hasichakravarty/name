public Class AssetTriggerHandler{
    public void primaryContactv2(Asset asList){       
        if(asList.contactid != null && asList.course__c != null) {
            List<Asset> asExistLists = [select id,name,Primary__c,ContactId from Asset where ContactId =:asList.contactid and 
                                    primary__c=true and status__c='Active' and product2id != '' and course__c=:asList.course__c];
        
        if   (!asExistLists.isEmpty())  {
            List<Asset> ass_toupdate=new List<Asset>();
            for(Asset asExist : asExistLists){
              if(asExist .id != asList.id){
                  asExist.primary__c=false;
                  ass_toupdate.add(asExist);                  
              }
            }
            if (!ass_toupdate.isEmpty())
                update ass_toupdate;
        }  
        }                              
    } 
}