@isTest(seeAllData=True)
public with sharing class DeleteEmailAttachmentDocumentsTest 
{
  static testMethod void  myUnitTest() 
  {    
    Test.startTest(); 
    DeleteEmailAttachmentDocuments batchObject = new DeleteEmailAttachmentDocuments();
    database.executeBatch(batchObject); 
    List<Document> emailAttachments = new List<Document>();
    batchObject.execute(new testBC(), emailAttachments); 
    batchObject.execute(new testSC());  
    Test.stopTest();
  }  
  
  class testBC implements Database.BatchableContext
  {
    public Id getChildJobId()
    {
      return null;
    }
    public Id getJobId()
    {
      return null;
    }
  }
  
  class testSC implements SchedulableContext
  {
    public Id getTriggerId()
    {
      return null;
    }    
  }
}