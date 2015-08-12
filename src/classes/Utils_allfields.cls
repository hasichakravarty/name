//Util class for field and Sobject
public with sharing class Utils_allfields{ 
 
	public Static String customSettingName = 'System Properties';
    public Static String opType1 = 'Existing Business';
    public Static String opStage1 = 'Pending';
    public Static String opStage2 = 'Needs Analysis';
    public Static String opAcademic1 = 'Pre-Vetted';
    public Static String propStage1 = 'Draft';
    public Static String propDegree1 = 'Full-Time';
    public Static String propPayMethod1 = 'Direct Deposit';
    public Static String propPayType1 = '50% Deposit';
    public Static String propPayType2 = 'Monthly Payment';
    public Static String y = 'Yes';
    public Static String oppType2 = 'New Business';
    public Static String oppType3 = 'Returning Business';
    public Static String OppConRole1 = 'Business User';
    public Static String OppConRole2 = 'Primary Sales Contact';
    public Static String ConfigType = 'Bundle';
    public Static String ConfigLineType = 'Product/Service';
    public Static String ConfigStatus = 'Finalized';
    public Static String CustomField = 'Discount_Reference__c';
    public Static String errorVar = 'Error';
    public Static String warningVar = 'Warning';
    public Static String quoteVar = 'Quote';
    public Static String contractVar = 'Contract';
    public Static String DiscountRef1 = 'Academic Credit';
    public Static String DiscountRef2 = 'Financial Credit';
    public Static String AdjustmentType = '% Discount';
    // Returns a dynamic SOQL statement for the whole object, includes only creatable fields since we will be inserting a cloned result of this query
    public static string getCreatableFieldsSOQL(String objectName, String whereClause){
         
        String selects = '';
         
        if (String.isEmpty(whereClause)){ return null; }
         
        // Get a map of field name and field token
        Map<String, Schema.SObjectField> fMap = Schema.getGlobalDescribe().get(objectName.toLowerCase()).getDescribe().Fields.getMap();
        list<string> selectFields = new list<string>();
        system.debug(' fMap  :'+fMap );
        if (fMap != null){
            for (Schema.SObjectField ft : fMap.values()){ // loop through all field tokens (ft)
                Schema.DescribeFieldResult fd = ft.getDescribe(); // describe each field (fd)
                if (fd.isAccessible()){ // field is creatable
                    selectFields.add(fd.getName());
                }
            }
        }
        system.debug('selectFields  :'+ selectFields);
        if (!selectFields.isEmpty()){
            for (string s:selectFields){
                selects += s + ',';
            }
            if (selects.endsWith(',')){selects = selects.substring(0,selects.lastIndexOf(','));}
             
        }
         
        return 'SELECT ' + selects + ' FROM ' + objectName + ' WHERE ' + whereClause;
         
    }
    
     public static string getCreatableFieldsList(String objectName){
         
        String selects = '';
         
         
        // Get a map of field name and field token
        Map<String, Schema.SObjectField> fMap = Schema.getGlobalDescribe().get(objectName.toLowerCase()).getDescribe().Fields.getMap();
        list<string> selectFields = new list<string>();
        system.debug(' fMap  :'+fMap );
        if (fMap != null){
            for (Schema.SObjectField ft : fMap.values()){ // loop through all field tokens (ft)
                Schema.DescribeFieldResult fd = ft.getDescribe(); // describe each field (fd)
                if (fd.isAccessible()){ // field is creatable
                    selectFields.add(fd.getName());
                }
            }
        }
        system.debug('selectFields  :'+ selectFields);
        if (!selectFields.isEmpty()){
            for (string s:selectFields){
                selects += s + ',';
            }
            if (selects.endsWith(',')){selects = selects.substring(0,selects.lastIndexOf(','));}
             
        }
         
        return  selects;
         
    }
 
}