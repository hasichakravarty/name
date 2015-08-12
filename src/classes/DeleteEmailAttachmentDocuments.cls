global class DeleteEmailAttachmentDocuments implements Database.Batchable<sObject>,Database.Stateful,Schedulable 
{
  global Database.QueryLocator start(Database.BatchableContext BC) 
  {
    Date weekOld = system.today().addDays(Integer.valueof(System.Label.EmailAttachmentRetentionPeriodDays));
    List<Folder> folders = [SELECT id FROM Folder WHERE NAME = 'Email Attachments'];
    Id folderId = null;
    if(folders != null && folders.size() > 0)
    {
      folderId = folders.get(0).Id;
    }
   
    String query = 'select id from Document where CreatedDate < :weekOld and FolderId = :folderId';
    return database.getquerylocator(query);
  }

  global void execute(Database.BatchableContext BC, List<Document> emailAttachments) 
  {           
    delete emailAttachments;   
  }

  global void finish(Database.BatchableContext BC) 
  {        
  }
    
  global void execute(SchedulableContext sc) 
  {
    database.executebatch(new DeleteEmailAttachmentDocuments());
  }  
}