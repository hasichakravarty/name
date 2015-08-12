public with sharing class WrapTestClass {
List<string> lstselectedNames = new List<string>();
public PageReference selRecDisplay() {
for(wrapper w: lstwrap){
if(w.ischecked==true){
lstselectedNames.add(w.Tname);
}
}
List<TestObject1__c> lstselectedrecords = [select Id,name,city__c from TestObject1__c where name in : lstselectedNames];
List<String> lstselectedRecordIds = new List<String>();
for(Integer i=0;i<lstselectedrecords.size();i++){
lstselectedRecordIds.add(lstselectedrecords[i].Id);
}
string s='';
for(Integer i=0;i<lstselectedRecordIds.size();i++)
{
if(i<lstselectedRecordIds.size()-1)
s=s+lstselectedRecordIds[i]+':';
else
s=s+lstselectedRecordIds[i];
}
pagereference ref = new pagereference('/apex/TestPage2?value='+s);
ref.setredirect(true);
return ref;
}
List<wrapper> lstwrap = new List<wrapper>();
List<TestObject1__c> lsttest = new List<TestObject1__c>();
public List<wrapper> getTestingrecords() {
lsttest = [select Id,name,city__c from TestObject1__c];
for(Integer i=0;i<lsttest.size();i++)
{
lstwrap.add(new wrapper(lsttest[i].name,lsttest[i].city__c));
}
return lstwrap;
}
public class wrapper{
public String Tname{get;set;}
public String Tcity{get;set;}
public boolean ischecked{get;set;}
public wrapper(String Tname,String Tcity)
{
this.Tname=Tname;
this.Tcity=Tcity;
this.ischecked=false;
}
}
}