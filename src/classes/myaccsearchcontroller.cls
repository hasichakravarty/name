public with sharing class myaccsearchcontroller {  
   public list <orderItem> acc {get;set;}  
   public string searchstring {get;set;}  
   public myaccsearchcontroller(ApexPages.StandardController controller) {  
   }  
   public void search(){  
     string searchquery='select Product_Name__c,OrderItemNumber,id from orderItem where Product_Name__c like \'%'+searchstring+'%\' Limit 20';  
     acc= Database.query(searchquery);  
   }
   public void search1(){  
     string searchquery='select Product_Name__c,OrderItemNumber,id from orderItem Limit 20';  
     acc= Database.query(searchquery);  
   }   
   public void clear(){  
   acc.clear();  
   }  
 }