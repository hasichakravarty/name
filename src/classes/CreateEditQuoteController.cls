public class CreateEditQuoteController {
    public Id opportunityId;
    
    public PageReference onLoad (){
        opportunityId =  ApexPages.currentPage().getParameters().get('id');
        System.debug('opportunityId  :'+opportunityId);
        Opportunity oppty = [ SELECT Id, Name, Academic_Start_Date__c  FROM Opportunity Where Id =:opportunityId limit 1];
        List<OpportunityContactRole> Opptycontact = [SELECT Id, ContactId, Role, IsPrimary, OpportunityId FROM OpportunityContactRole WHERE OpportunityId =: opportunityId];
        Id Pricelistid = calcuate_priceList();
        Date First_Payment_Date = date.newInstance(oppty.Academic_Start_Date__c.year(),oppty.Academic_Start_Date__c.month(),oppty.Academic_Start_Date__c.day());
        system.debug(' First_Payment_Date  :'+ First_Payment_Date);
        Apttus_Proposal__Proposal__c proposal_new = new Apttus_Proposal__Proposal__c();
        //proposal_new = 
       /* https://na10.salesforce.com/a0lF0000002Z86T/e?cancelURL=%2Fa0lF0000002Z86T&retURL=%2F003F000001BPE2W*/
       PageReference pg = new PageReference('/a1F/e?cancelURL=%2000611000008yiG9&retURL=%2a1F110000017Bdr');
        //PageReference pg = new PageReference('/a1F/e?retURL=&RecordType=012110000004qFe&ent=01I110000009PNt&00N1100000145U7='+oppty.Name+'&00N110000016AAq='+oppty.Academic_Start_Date__c);
        return pg;
        //CF00N1100000145ys_lkid == price list id field 
        //00N110000016AAq = 
        /*if(proposal_new.id != null){
             PageReference pg = new PageReference('/'+proposal_new.id);
             return pg;
         }else{
             PageReference pg = new PageReference('/'+opportunityId);
             return pg;
         }*/
       // return null;
    }
    
    public Id calcuate_priceList(){
         Quote_Settings__c qsvalue = Quote_Settings__c.getValues('System Properties');
         if(qsvalue.Early_Bird__c > = system.Date.today()){
            return qsvalue.Early_Bird_Price_List_Id__c;
         }
         else{ 
            return qsvalue.Non_Early_Bird_Price_List_Id__c;
         }
     }

}