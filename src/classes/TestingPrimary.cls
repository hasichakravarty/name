public class TestingPrimary{
  
  public void updatePrimary(List<Pearson_Course_Equivalent__c> courseEqvList){
  
   List<Id> courseLst = new List<Id>();
   
   for(Pearson_Course_Equivalent__c ce: courseEqvList){
        courseLst.add(ce.Course__c);
   }
   
    List<Pearson_Course_Equivalent__c> courseeqlList = [select Course__c , Primary__c from Pearson_Course_Equivalent__c where Course__c IN :courseLst and Primary__c = true];
    List<Pearson_Course_Equivalent__c> listToupdate= new List<Pearson_Course_Equivalent__c>();
    system.debug('courseeqlList -----'+courseeqlList);
        for(Pearson_Course_Equivalent__c newce: courseeqlList){
            system.debug('newce.Primary__c----->'+newce.Primary__c);
            newce.Primary__c = false;
            listToupdate.add(newce);
         }
         if(!listToupdate.isEmpty()){
             update listToupdate;
         }           
    }
}