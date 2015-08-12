// CreateQuote Class .this takes Opportunity Id as input.
public class CreateQuote {
    public Id opportunityId;
    public Quote_Settings__c qsvalue = Quote_Settings__c.getValues(Utils_allfields.customSettingName);
    //public Apttus_Proposal__Proposal__c proposal_new;
    //Constructor
    public CreateQuote(ApexPages.StandardController stdController){
        opportunityId =  ApexPages.currentPage().getParameters().get('id');
     }
     //Method  Quote_create
     public PageReference Quote_create(){
         String soql = Utils_allfields.getCreatableFieldsSOQL('Opportunity','id =: opportunityId');
         Opportunity Oppty = (Opportunity)Database.query(soql);
         Apttus_Proposal__Proposal__c proposal_new = new Apttus_Proposal__Proposal__c();
         Id recordtypeid =  Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get(Utils_allfields.quoteVar).getRecordTypeId();
         if(recordtypeid != null)
            proposal_new.RecordTypeId = recordtypeid; // Quote record type 
            
         proposal_new.Apttus_Proposal__Opportunity__c = Oppty.Id;
         proposal_new.Apttus_Proposal__Proposal_Name__c = Oppty.Name;
         proposal_new.Apttus_Proposal__Account__c = Oppty.AccountId;
         proposal_new.Apttus_QPConfig__PriceListId__c = calcuate_priceList();
         proposal_new.Apttus_Proposal__Approval_Stage__c = Utils_allfields.propStage1;
         proposal_new.Deposit__c = 0;
         proposal_new.First_Payment_Date__c = Oppty.Academic_Start_Date__c;
         proposal_new.Apttus_Proposal__Primary__c = false;
         proposal_new.Degree_Type__c = Utils_allfields.propDegree1;
         proposal_new.Total_Early_Bird_Securing_Fee_Payments__c = 0;
         proposal_new.Payment_Method__c = Utils_allfields.propPayMethod1;
         if(Oppty.International_Sponsor__c != null && Oppty.International_Sponsor__c.equals(Utils_allfields.y)){
              proposal_new.Payment_Type__c = Utils_allfields.propPayType1;
         } else {
             proposal_new.Payment_Type__c = Utils_allfields.propPayType2;
         }
         // on Quote creation if the Opportunity type is New Business then early Bird fee  = customsetting.Earlybird Securing Fee New Business
         // on Quote creation if the Opportunity type is returning business then early Bird fee  = customsetting.Earlybird Securing Fee Return Business
         if(Oppty.Type != null && Oppty.Type.equals(Utils_allfields.oppType2)){
             proposal_new.Total_Early_Bird_Securing_Fee_Payments__c =  qsvalue.Earlybird_Securing_Fee_New_Business__c;
         } else if(Oppty.Type != null && Oppty.Type.equals(Utils_allfields.oppType3)){
             proposal_new.Total_Early_Bird_Securing_Fee_Payments__c =  qsvalue.Earlybird_Securing_Fee_Return_Business__c;
         }
         
         //set contacts
         List<OpportunityContactRole> Opptycontact = [SELECT Id, ContactId, Role, IsPrimary, OpportunityId FROM OpportunityContactRole WHERE OpportunityId =: opportunityId];
         if(!Opptycontact.isEmpty()){
             for(OpportunityContactRole eachOpportunityContactRole : Opptycontact){
                 if(eachOpportunityContactRole.Role != null && eachOpportunityContactRole.Role.equals(Utils_allfields.OppConRole1)){
                    proposal_new.Apttus_Proposal__Primary_Contact__c =  eachOpportunityContactRole.ContactId;
                 }
                 if(eachOpportunityContactRole.Role != null && eachOpportunityContactRole.Role.equals(Utils_allfields.OppConRole2)){
                     proposal_new.Sponsor__c = eachOpportunityContactRole.ContactId;
                 }
                 
             }
        }
         if(proposal_new != null){
             try{
                insert proposal_new;
            }catch(Exception ex){
                system.debug('Exception Message--'+ ex.getMessage());
                throw ex;
            }
         }
         if(proposal_new.id != null){
             PageReference pg = new PageReference('/'+proposal_new.id+
                                                  '/e?cancelURL=%2Fapex%2Fapttus_proposal__cancelactioninterceptor%3FactionName%3Dcreate_oppty_proposal%26objectId%3D'+opportunityId+
                                                  '%26opportunityId%3D'+opportunityId+'%26proposalId%3D'+proposal_new.id+'%26rollbackId%3D'+proposal_new.id+
                                                  '&retURL=%2F'+proposal_new.id);
             return pg;
         }else{
             PageReference pg = new PageReference('/'+opportunityId);
             return pg;
         }
         
     }


//Method to calcuate priceList
     public Id calcuate_priceList(){
         if(qsvalue.Early_Bird__c > = system.Date.today()){
            return qsvalue.Early_Bird_Price_List_Id__c;
         }
         else{ 
            return qsvalue.Non_Early_Bird_Price_List_Id__c;
         }
     }
        
}