public with sharing class Testclass2{
List<TestObject1__c > lsttest = new List<TestObject1__c >();
public List<TestObject1__c> getRecords() {
List<String> ids = url.split(':');
lsttest = [select Id,name,city__c from TestObject1__c where id in : ids];
return lsttest;
}
String url = apexpages.currentpage().getparameters().get('value');
}