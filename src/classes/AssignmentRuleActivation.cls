public with sharing class AssignmentRuleActivation {

    public static void activateAssignmentRule(List<Case> caseList,boolean isInsert,boolean isUpdate,Map<id,Case> oldmap ){
        
        List<Id> caseIds = new list<Id>();
        List<case> caselistupdated = new List<case>();
        List<case> listCases = new list<case>();
        AssignmentRule AR;
        Database.DMLOptions dmlOpts;
            
        Id Caserecordtype = [SELECT Id FROM RecordType WHERE SobjectType='Case' and Name= 'General'].Id;
     
        if(isInsert)
            for(case cas:caseList)
                if(cas.RecordtypeId == Caserecordtype && (cas.type=='Request Account Update' ||cas.type=='Request Account Access'||cas.type=='Request Account Handover'))
                    caseIds.add(cas.Id);
       
       
        if(isUpdate){
            List<FeedItem> Listfeed = new List<Feeditem>();
            for(case c:caseList){
                if(c.RecordtypeId == Caserecordtype && (c.type=='Request Account Update' ||c.type=='Request Account Access'||c.type=='Request Account Handover') && c.status!=oldmap.get(c.id).status){
                 FeedItem Post = new FeedItem();
                 Post.ParentId = c.AccountId;
                 Post.Body = 'The status of case with case number'+' '+c.caseNumber+' '+'and case subject'+' '+c.Subject+' changed from'+' '+oldmap.get(c.id).status+' '+'to'+' '+c.status;
                 Listfeed.add(Post);
                }
            }
            
            if(Listfeed.size()>0)
                Insert Listfeed;
        }
      
      
        listCases = [select Id,AccountId,Type from case where Id IN:caseIds];
      
        list<AssignmentRule> assignmentRuleList = [select id from AssignmentRule where SobjectType = 'Case' and Active = true limit 1];
                
        if(!assignmentRuleList.isEmpty() && assignmentRuleList != null){
          if(assignmentRuleList[0] != null){
            AR = new AssignmentRule();
            AR = assignmentRuleList[0];
           }
         } 
      
        
         if(AR != null){
          dmlOpts = new Database.DMLOptions();
          dmlOpts.assignmentRuleHeader.assignmentRuleId= AR.id;
         }   
       
       
       if(Listcases.size()>0)
         for(case c1:Listcases)
           if(dmlOpts != null)
            c1.setOptions(dmlOpts);
       
       
       Update Listcases;

        
     }
    
}