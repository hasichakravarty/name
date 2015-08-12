public class NewAccountRequest{
public lead leadvalues{get;set;}
public ID rtID;  
 
//Map<String, Schema.SObjectType> sObjectMap = Schema.getGlobalDescribe();
 public NewAccountRequest(Apexpages.standardcontroller controller){
  Schema.DescribeSObjectResult d = Schema.SObjectType.Lead;
        Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
       rtID =  rtMapByName.get('B2B').RecordTypeID;         
               
  leadvalues = new lead();  
 }
     
   public pagereference save(){
   
         /*Schema.SObjectType lv = sObjectMap.get('Lead') ;   
         Schema.DescribeSObjectResult resSchema = lv.getDescribe() ;    
         Map<String,Schema.RecordTypeInfo> recordTypeInfo = resSchema.getRecordTypeInfosByName();    
         Id rtId = recordTypeInfo.get('B2B').getRecordTypeId();*/
         
         
        
   list<User> userlist=new list<User>();
   userlist=[select id,Market__c,profile.name from user where id =:Userinfo.getUserId()];
   //List<Lead> leadRecordTypeIds = new List<Lead>(); 
   //leadRecordTypeIds = [Select id, RecordType.id FROM Lead WHERE RecordType.Name IN ('B2B') limit 1];
   system.debug('@@@@user1'+userlist);
           
        if(userlist[0].Market__c == 'ZA')
        {
                 if((Leadvalues.Phone == ''||Leadvalues.Phone == null) || (Leadvalues.Phone != null && (!(Leadvalues.Phone).startsWith('+'))))
             {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'please enter valid Phone number along with the country code');
                     ApexPages.addMessage(myMsg); 
                     return null;
             }
                        
        }
        
        
        if((Leadvalues.Home_Phone__c == null || Leadvalues.Home_Phone__c == '') && (Leadvalues.Other_Phone__c == null || Leadvalues.Other_Phone__c == '') && 
        (Leadvalues.Email == null || Leadvalues.Email == '') && (Leadvalues.MobilePhone== null || Leadvalues.MobilePhone== ''))
        {
                     ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Enter either Home Phone or Other Phone or Email or Mobile to save the record');
                     ApexPages.addMessage(myMsg); 
                     return null;         
        }     

        if((Leadvalues.Academic_Achievement__c == null && Leadvalues.Organisation_Type1__c == 'School'))
        {
                     ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'A value must be provided for the Academic Achiever level for School Organisation types.');
                     ApexPages.addMessage(myMsg); 
                     return null;         
        }    

    AssignmentRule AR;
    list<AssignmentRule> assignmentRuleList = [select id from AssignmentRule where SobjectType = 'Lead' and Active = true limit 1];
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
            
       
        
        system.debug('leadvalues...'+leadvalues);
        leadvalues.setoptions(dmlopts);
        leadvalues.Leadsource = 'Employee/External Referrals';
        leadvalues.status= 'Qualified';
        leadvalues.recordTypeId = rtId;
        //System.debug('aarr' +rtId);        
        //leadvalues.recordTypeId = leadRecordTypeIds[0].RecordType.id; 
        //System.debug('@@@@@@@ recordTypeId --->'+recordTypeId);        
        Insert leadvalues;
       
        //Davi Borges -- Removed in 15-06-2015
     //leadvalues.recordTypeId = rtId;
     //update leadvalues;
     
       System.debug('kkkk'+leadvalues.recordTypeId );
       
              PageReference secondPage = new PageReference ('/00Q/o?nooverride=1');
              secondPage.setRedirect(true);
              return secondPage ;  
    }
}