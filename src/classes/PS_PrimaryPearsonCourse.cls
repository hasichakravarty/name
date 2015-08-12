public class PS_PrimaryPearsonCourse{

public void updatePrimaryFlag(List<Pearson_Course_Equivalent__c> newlist,Map<Id,Pearson_Course_Equivalent__c> oldmap,
Boolean isinsert,Boolean isUpdate){
    System.debug('isupdate-->' +isupdate+ 'isinsert-->' +isinsert);
    //List<Pearson_Course_Equivalent__c> newlist=newmap.values();
    Set<Id> courseId=new Set<Id>();
    List<Pearson_Course_Equivalent__c> listToupdate= new List<Pearson_Course_Equivalent__c>();

    for(Pearson_Course_Equivalent__c pce: newlist){
    if(isinsert){
        if(pce.Primary__c){
            courseId.add(pce.course__c);}
            system.debug('courseId.add isinsert-->'+courseId+'primary-->'+pce.primary__c);
    }//insert condition
     system.debug('courseId.add  after isinsert loop-->'+courseId);
    if(isUpdate){        
        system.debug('pce.Primary__c-->'+pce.Primary__c+'Oldvalue='+oldmap.get(pce.id).Primary__c);
        if(pce.Primary__c && (!oldmap.get(pce.id).Primary__c)){
            courseId.add(pce.course__c);
             system.debug('courseId.add isupdate-->'+courseId+ +'primary-->'+pce.primary__c);
            }
    } system.debug('courseId.add after if isupdate-->'+courseId);//update cn
    }//for loop
    system.debug('courseId.add after isupdate-->'+courseId);
    if (courseId.size()>0){
        system.debug('courseId.add before query-->'+courseId);
        List<Pearson_Course_Equivalent__c> preprimlist=[select id,primary__c from Pearson_Course_Equivalent__c where course__c in :courseId and primary__c=true];
        system.debug('preprimlist -->'+preprimlist);
        if (preprimlist.size()>0){
            listToupdate.clear();
            for(Pearson_Course_Equivalent__c pce: preprimlist){
                pce.primary__c=false;
                listToupdate.add(pce);
            }
         }
     }
     if (listToupdate.size()>0){
         try{
             update listToupdate;
         }
         catch(DMLException e){
             throw(e);
         }              
      }
}
}