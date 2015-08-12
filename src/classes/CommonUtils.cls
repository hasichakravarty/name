public with sharing class CommonUtils {
    
    public static List<Account> getAccountbypassRecordType(String recordType,List<Account> triggeredAccounts){
        
        List<Account> accountList = new List<Account>();
        Schema.DescribeSObjectResult describeSobjectResult = Schema.SObjectType.Account; 
        Map<Id,Schema.RecordTypeInfo> recordTypeMap = describeSobjectResult.getRecordTypeInfosById();
        
        if(triggeredAccounts != null)
            for(Account a : triggeredAccounts){
                if(a.RecordTypeId!=null){
                    system.debug('##############recordTypeMap.get(a.RecordTypeId).getName() : '+recordTypeMap.get(a.RecordTypeId).getName());
                    if(!recordType.contains(recordTypeMap.get(a.RecordTypeId).getName()))
                        accountList.add(a);
                }
            } 
        
        return accountList;
    }
    
    public static List<Contact> getContactbypassRecordType(String recordType,List<Contact> triggeredContacts){
        
        List<Contact> contactList = new List<Contact>();
        Schema.DescribeSObjectResult describeSobjectResult = Schema.SObjectType.Contact; 
        Map<Id,Schema.RecordTypeInfo> recordTypeMap = describeSobjectResult.getRecordTypeInfosById();
        
        if(triggeredContacts != null)
            for(Contact c : triggeredContacts){
                if(c.RecordTypeId!=null){
                    system.debug('##############recordTypeMap.get(c.RecordTypeId).getName() : '+recordTypeMap.get(c.RecordTypeId).getName());
                    if(!recordType.contains(recordTypeMap.get(c.RecordTypeId).getName()))
                        contactList.add(c);
                }
            } 
        
        return contactList;
    }
    
    public static List<Account> getAccountRecordType(String recordType,List<Account> triggeredAccounts){
        
        List<Account> accountList = new List<Account>();
        Schema.DescribeSObjectResult describeSobjectResult = Schema.SObjectType.Account; 
        Map<Id,Schema.RecordTypeInfo> recordTypeMap = describeSobjectResult.getRecordTypeInfosById();
        
        if(triggeredAccounts != null)
            for(Account a : triggeredAccounts){
                if(a.RecordTypeId!=null){
                    system.debug('##############recordTypeMap.get(a.RecordTypeId).getName() : '+recordTypeMap.get(a.RecordTypeId).getName());
                    if(recordType.contains(recordTypeMap.get(a.RecordTypeId).getName()))
                        accountList.add(a);
                }
            } 
        
        return accountList;
    }

    public static List<Case> getCaseBypassANZRecordType(String recordType,List<Case> triggeredCases){
        
        List<Case> caseList = new List<Case>();
        Schema.DescribeSObjectResult describeSobjectResult = Schema.SObjectType.Case; 
        Map<Id,Schema.RecordTypeInfo> recordTypeMap = describeSobjectResult.getRecordTypeInfosById();
        
        if(triggeredCases != null)
            for(Case c : triggeredCases){
                if(c.RecordTypeId!=null){
                    system.debug('##############recordTypeMap.get(a.RecordTypeId).getName() : '+recordTypeMap.get(c.RecordTypeId).getName());
                     if(!recordType.contains(recordTypeMap.get(c.RecordTypeId).getName()))  //if(recordType.contains(recordTypeMap.get(c.RecordTypeId).getName()))   
                        caseList.add(c);
                }
            } 
        
        return caseList;
    }
    
}