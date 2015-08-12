public class PS_ProductFamilyInstructorResources{
    public string productFamilyId{get;set;}
    public List<Apttus_Config2__RelatedProduct__c> listForInstructorResource=null;
    
    public PS_ProductFamilyInstructorResources(){
        System.debug('Inside Constructor');
    }
    
    public void setlistForInstructorResource(List<Apttus_Config2__RelatedProduct__c> insreslist){
        listForInstructorResource=insreslist;
    }
    public List<Apttus_Config2__RelatedProduct__c> getlistForInstructorResource(){
        if (listForInstructorResource == null){
            if (productFamilyId != ''){
                listForInstructorResource=[select elearning_Assessment__c,Instructor_Resource__c,Student_Resource__c,
                Apttus_Config2__RelatedProductId__r.Id,Apttus_Config2__RelatedProductId__r.Name,
                Apttus_Config2__RelatedProductId__r.Author__c,Apttus_Config2__RelatedProductId__r.SBN__c,
                Apttus_Config2__RelatedProductId__r.ISBN__c,Apttus_Config2__RelatedProductId__r.Copyright_Year__c,
                Apttus_Config2__RelatedProductId__r.Binding__c,Apttus_Config2__RelatedProductId__r.Status__c,
                Apttus_Config2__RelatedProductId__r.InstockDate__c,Apttus_Config2__RelatedProductId__r.Priority__c,
                Apttus_Config2__RelatedProductId__r.Sub_Brand__c,Apttus_Config2__RelatedProductId__r.Platform__c,
                Apttus_Config2__RelatedProductId__r.URL__c,Apttus_Config2__RelatedProductId__r.IRC_Link__c from 
                Apttus_Config2__RelatedProduct__c where Apttus_Config2__ProductId__c =: productFamilyId And 
                (Instructor_Resource__c =: True Or Student_Resource__c =: True Or elearning_Assessment__c =: True)];
            }
        }
        return listForInstructorResource;
    }
}