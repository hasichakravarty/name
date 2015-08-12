public with sharing class PS_BrowseTaxonomyController {
    transient List < Apttus_Config2__PriceListCategory__c > grndParentLst { get;set;}
    transient String loggedInUserpriceListNamebase {get;set;}
    Public PS_BrowseTaxonomyController() {
        loggedInUserpriceListNamebase = [select Price_List__c from User where id = : UserInfo.getUserId() limit 1].Price_List__c;
        if (grndParentLst == null){
            if (loggedInUserpriceListNamebase != null) { 
                grndParentLst = [Select Apttus_Config2__HierarchyId__r.Id, Apttus_Config2__HierarchyId__r.Name from 
                Apttus_Config2__PriceListCategory__c where Apttus_Config2__PriceListId__r.Name = : loggedInUserpriceListNamebase And 
                Apttus_Config2__HierarchyId__c != null order by name asc ];
            }//end user pricelist        
        }//end grandparent
    }//end constructor
    public List < Apttus_Config2__PriceListCategory__c > getgrndParentLst(){
        return grndParentLst;
    }
}//end class