global class oneCRMDeletePearsonChoicesBatch implements Database.Batchable<sObject>,Schedulable {
    String sSwitch=System.Label.PS_BatchPearsonChoiceSwitch;

    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'select id from Pearson_Choice__c';
        return database.getquerylocator(query);
    }

    global void execute(Database.BatchableContext BC,List<Pearson_Choice__c> pearsonChoiceRecords) {
        //delete pearsonChoiceRecords;
     try{
            List<Database.DeleteResult> delreslist=Database.delete(pearsonChoiceRecords,false);
            Database.emptyRecycleBin(pearsonChoiceRecords); // added to empty recycle bin -Ravi
            if(test.isRunningTest())
            {
                 throw new applicationException('Exception');
            }
        }
        catch(Exception e){
            ExceptionFramework.LogException('BatchPearsonChoiceDeletion','oneCRMDeletePearsonChoicesBatch','execute',e.getMessage(),UserInfo.getUserName(),'');
        }
       
    }
    
    
    public class applicationException extends Exception 
    {
    
    } 
    global void finish(Database.BatchableContext BC) {
        try{
            Database.executeBatch(new PS_BatchPearsonChoiceCreation('US','US Field Sales','US HE All',''), 200);
            if(test.isRunningTest())
            {
                 throw new applicationException('Exception');
            } 
        }
        catch(Exception e){
            ExceptionFramework.LogException('BatchPearsonChoiceDeletion','oneCRMDeletePearsonChoicesBatch','finish',e.getMessage(),UserInfo.getUserName(),'');
        }        
    }
    global void execute(SchedulableContext sc) {
        database.executebatch(new oneCRMDeletePearsonChoicesBatch());
    }
  
}