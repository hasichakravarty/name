public class MyDynamicCategoryController {
    public string sUserPlist{get;set;}
    public String[] sCategory{get;set;}
    public String[] sCategoryId{get;set;}
    public MyDynamicCategoryController(){
        system.debug('This is a constructor');
        User u = [select id,name,Price_List__c from user where id=:UserInfo.getUserId()];
        sUserPlist=u.Price_List__c;
        List<Apttus_Config2__PriceListCategory__c> pcatlist= [Select Apttus_Config2__HierarchyId__r.Id, Apttus_Config2__HierarchyId__r.Name from 
                                                      Apttus_Config2__PriceListCategory__c where Apttus_Config2__PriceListId__r.Name = : sUserPlist And 
                                                      Apttus_Config2__HierarchyId__c != null order by name asc];
        for(Apttus_Config2__PriceListCategory__c pcat: pcatlist){
            if (sCategory == null)
                sCategory=new String[]{};
            if (sCategoryId == null)
                sCategoryId=new String[]{};          
            sCategoryId.add(pcat.Apttus_Config2__HierarchyId__r.Id);
            sCategory.add(pcat.Apttus_Config2__HierarchyId__r.Name);
        }        
    }
}