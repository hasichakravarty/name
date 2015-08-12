trigger AssignmentRuleactivation on Case (after Insert,after update) {
 List<Id> caseIds = new list<Id>();
 List<case> caselistupdated = new List<case>();
 Id Caserecordtype = [SELECT Id FROM RecordType WHERE SobjectType='Case' and Name= 'General'].Id;
 if(Trigger.isInsert){
  for(case c:trigger.new){
   if(c.RecordtypeId == Caserecordtype && (c.type=='Request Account Update' ||c.type=='Request Account Access'||c.type=='Request Account Handover')){
     caseIds.add(c.Id);
   }}}
   
   IF(Trigger.isUpdate){
    List<FeedItem> Listfeed = new List<Feeditem>();
    for(case c:Trigger.new){
     if(c.RecordtypeId == Caserecordtype && (c.type=='Request Account Update' ||c.type=='Request Account Access'||c.type=='Request Account Handover') && c.status!=trigger.oldmap.get(c.id).status){
         FeedItem Post = new FeedItem();
         Post.ParentId = c.AccountId;
         Post.Body = 'The status of case with case number'+' '+c.caseNumber+' '+'and case subject'+' '+c.Subject+' changed from'+' '+trigger.oldmap.get(c.id).status+' '+'to'+' '+c.status;
         Listfeed.add(Post);
     }
    }
    if(Listfeed.size()>0){
       Insert Listfeed;}
   }
  
   List<case> listcases = new list<case>();
   Listcases = [select Id,AccountId,Type from case where Id IN:caseIds];
  
    AssignmentRule AR;
    list<AssignmentRule> assignmentRuleList = [select id from AssignmentRule where SobjectType = 'Case' and Active = true limit 1];
    if(!assignmentRuleList.isEmpty() && assignmentRuleList != null){
      if(assignmentRuleList[0] != null){
        AR = new AssignmentRule();
        AR = assignmentRuleList[0];
       }
     } 
  
     Database.DMLOptions dmlOpts;
     if(AR != null){
      dmlOpts = new Database.DMLOptions();
      dmlOpts.assignmentRuleHeader.assignmentRuleId= AR.id;
     }   
   
   
   if(Listcases.size()>0){
     for(case c1:Listcases){
       if(dmlOpts != null){
        c1.setOptions(dmlOpts);}}
   }
   
   Update Listcases;

}