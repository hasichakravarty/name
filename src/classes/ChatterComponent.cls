public with sharing class ChatterComponent {
    public Id recordId       {get;set;}
    
    public String getRecordId() {
        return recordId;
    }
    
    public ChatterComponent() {
        recordId = apexPages.currentPage().getParameters().get('id');
         System.debug('************ recordId to post on chatter: ************'+recordId);
    }
}