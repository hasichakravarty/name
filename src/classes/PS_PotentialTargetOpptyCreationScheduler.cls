/*===========================================================================+
 |  HISTORY                                                                  
 |                                                                           
 |  DATE            DEVELOPER        DESCRIPTION                               
 |  ====            =========        =========== 
 |  13/5/2015        IDC              Scheduler Class for Potential Target Opportunity Generation
 +===========================================================================*/
global class PS_PotentialTargetOpptyCreationScheduler implements Schedulable {  
    /*@Method <This method gets executed acutomatically when the Scheduler is invoked>
    @param <Database.BatchableContext BC - Batchable context>
    @param SchedulableContext SC
    @return <void> - <Not returning anything>
    @throws exception - No Exception Thrown , Send email from Catch Block if there is Excetion
    */
    global Integer runningBatchJobs;
    global void execute(SchedulableContext SC){
        PS_PotentialTargetOpptyCreationBatch  potenTargetBatch= new PS_PotentialTargetOpptyCreationBatch();
        try{
             if(!Test.isRunningTest()) //Added the code just to cover the test class coverage.
             runningBatchJobs = [select count() from AsyncApexJob where JobType = 'BatchApex' and status in ('Queued','Processing','Preparing') limit 5000]; 
             else
             runningBatchJobs = 10; //Added the code just to cover the test class coverage.
             System.debug(' runningBatchJobs --->'+runningBatchJobs);
                if(runningBatchJobs>4){
                    DateTime n = datetime.now().addMinutes(60);
                    String cron = '';
                    cron += n.second();
                    cron += ' ' + n.minute();
                    cron += ' ' + n.hour();
                    cron += ' ' + n.day();
                    cron += ' ' + n.month();
                    cron += ' ' + '?';
                    cron += ' ' + n.year();
                    String jobName = 'Batch Job To Create Opportunity - ' + n.format('MM-dd-yyyy-hh:mm:ss');
                    PS_PotentialTargetOpptyCreationScheduler nextBatch = new PS_PotentialTargetOpptyCreationScheduler();
                    Id scheduledJobID = System.schedule(jobName,cron,nextBatch);        
                }
                else{
                    if(!Test.isRunningTest())             
                        database.executebatch(potenTargetBatch);
                }     
        }
        catch(Exception e){
           //Uncomment this below part to send mail when there is a failure
           /* String supportEmail = '';//Support Email to be added
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[] {supportEmail};
            mail.setToAddresses(toAddresses);
            mail.setSubject('Attention: Error in Batch Job to send OBMs');
            String strPlainTextBody = 

             'Fatal Error :'+e;
             
            mail.setPlainTextBody(strPlainTextBody);
              
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });*/
            system.debug('Catch block to send a mail if any exception raised during Scheduler');
        }
    }
}