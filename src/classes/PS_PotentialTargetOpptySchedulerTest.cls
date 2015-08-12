@isTest(SeeAllData=true)
//class for covering the test class
private class PS_PotentialTargetOpptySchedulerTest {
    //Method to cover the test class
    static testMethod void myUnitTest() {
        PS_PotentialTargetOpptyCreationScheduler  ptoc = new PS_PotentialTargetOpptyCreationScheduler();
        //ptoc.runningBatchJobs = 5;
        //code for running the scheduler
                Test.startTest();
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
                    String jobId = System.schedule(jobName, cron, new PS_PotentialTargetOpptyCreationScheduler());

                    CronTrigger ct = [select id, CronExpression, TimesTriggered, NextFireTime from CronTrigger where id = :jobId];

                    System.assertEquals(cron, ct.CronExpression); 
                    System.assertEquals(0, ct.TimesTriggered);
                    //System.assertEquals('2015-05-27 02:27:07', String.valueOf(ct.NextFireTime));

            Test.stopTest();
    }
}