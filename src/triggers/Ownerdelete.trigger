trigger Ownerdelete on Office_Hours__c (before delete) {
if(trigger.isBefore){
if(trigger.isDelete){
for(Office_Hours__c o : trigger.old){
if(!(o.OwnerID == UserInfo.getUserId() )){
o.adderror('You can only delete the record which is Owned');
}
}
}
}
}