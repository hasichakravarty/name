global class EmailLoginHistoryReport {
 /* AA (Deloitte) - Deactivated as UK Users not onboarded yet
 global class EmailLoginHistoryReport implements System.Schedulable {
	/*
    global void execute(SchedulableContext sc) {
        Apexpages.Pagereference report = new Apexpages.Pagereference('/00OE0000002ESrk?excel=1');
        Messaging.Emailfileattachment attachment = new Messaging.Emailfileattachment();
        attachment.setFileName('HEUK Login History-6 months.xls');
        attachment.setBody(report.getContent());
        attachment.setContentType('application/vnd.ms-excel');
        Apexpages.Pagereference report1 = new Apexpages.Pagereference('/00OE0000002EVLN?excel=1');
        Messaging.Emailfileattachment attachment1 = new Messaging.Emailfileattachment();
        attachment1.setFileName('HEUK-Not logged in for 6 months.xls');
        attachment1.setBody(report1.getContent());
        attachment1.setContentType('application/vnd.ms-excel');
        Apexpages.Pagereference report2 = new Apexpages.Pagereference('/00OE0000002EVKy?excel=1');
        Messaging.Emailfileattachment attachment2 = new Messaging.Emailfileattachment();
        attachment2.setFileName('HE UK-Not logged in for 30 days.xls');
        attachment2.setBody(report2.getContent());
        attachment2.setContentType('application/vnd.ms-excel');
        Messaging.Singleemailmessage message = new Messaging.Singleemailmessage();
        message.setFileAttachments(new Messaging.Emailfileattachment[] {attachment, attachment1, attachment2});
        message.setSubject('HEUK Login History Reports');
        message.setPlainTextBody('Please see the attached HEUK Login History reports.');
        message.setToAddresses(new String[] {'sfdc.support@pearson.com', 'sharon.maidment@pearson.com', 'Steven.Brimble@pearson.com', 'lisa.oneill@pearson.com'});
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { message });
    }
    */

}