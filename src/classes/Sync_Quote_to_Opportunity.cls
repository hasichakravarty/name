// This class is controller for Sync_Quote_to_Opportunity.
//Copy Quotes/Contracts Custom Fields from Proposal to Opportunity on click of Opportunity Sync Button.
public class Sync_Quote_to_Opportunity extends ApttusSyncProposalSupport {
    
    @TestVisible ID proposalID;
    
    //Constructor
    public Sync_Quote_to_Opportunity (){
        proposalID =  ApexPages.currentPage().getParameters().get('id');
        System.debug('Proposal Id  :'+proposalID);
        
        if(proposalID == null) {  
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: No Proposal Id selected');
                        ApexPages.addMessage(myMsg);
        }
     }
     
     // method to retrive selected field data from proposal and copy it to Opportunity.
     public PageReference Copy_Proposal_to_Oppty(){
         Apttus_Proposal__Proposal__c proposal = [select Id,
                                                         Apttus_Proposal__Opportunity__c,
                                                         Qualification__c,
                                                         Qualification_Campus__c,
                                                         campus__c,
                                                         Level__c,
                                                         Conferer__c,
                                                         Apttus_Proposal__Description__c,
                                                         Apttus_QPConfig__PriceListId__r.CurrencyIsoCode
                                                         from Apttus_Proposal__Proposal__c where Id =:proposalID];
       
        if(proposal.Apttus_Proposal__Opportunity__c != null){
            Opportunity Oppty = [select Id,
                                    Qualification__c,
                                    Qualification_Campus__c,
                                    campus__c,
                                    Level__c,
                                    Conferer__c,
                                    Description,
                                    CurrencyIsoCode ,Academic_Vetting_Status__c,Type
                                    from Opportunity where Id =:proposal.Apttus_Proposal__Opportunity__c];
                                    
            // Fields to be copied from Proposal to Opportunity
            
            Oppty.Qualification__c = proposal.Qualification__c;
            Oppty.campus__c = proposal.campus__c;
            Oppty.Qualification_Campus__c = proposal.Qualification_Campus__c;
            Oppty.Level__c = proposal.Level__c;
            Oppty.Conferer__c = proposal.Conferer__c;
            Oppty.Description = proposal.Apttus_Proposal__Description__c;
            //Davi Borges 20/05/2015
            
            if(canChangeToPreVetted (Oppty)){            
              
            Oppty.Academic_Vetting_Status__c = 'Pre-Vetted';
            }

            if(proposal.Apttus_QPConfig__PriceListId__r.CurrencyIsoCode != null)
                Oppty.CurrencyIsoCode = proposal.Apttus_QPConfig__PriceListId__r.CurrencyIsoCode;
            // End of Copy 
            
            try{
                
                update Oppty;
                // call Apttus OOB page to copy the Opportunity Product to Proposal linitems.
                system.debug('calling synclineitems');
                syncToOpportunity(proposal);
                PageReference pageRef = new PageReference('/'+proposalID);
                pageRef.setRedirect(true);
                return pageRef;
                /*PageReference pageRef = new PageReference('/apex/Apttus_QPConfig__ProposalSyncWithOpportunity?id='+proposalID);
                pageRef.setRedirect(true);
                return pageRef;*/
                //ApttusSyncProposalSupport synclines = new ApttusSyncProposalSupport();
                //synclines.
            }catch (DMLException e) {
                        String dmlError = e.getMessage();
                        String dmlStack = e.getStackTraceString();
                        Integer dmlLineNumber = e.getLineNumber(); 
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Cannnot update Opportunity. Please contact your Administrator. ' 
                            + ' ' + dmlError + ' ' + dmlStack + ' ' + dmlLineNumber);
                        ApexPages.addMessage(myMsg); 
                        PageReference pageRef = new PageReference('/'+proposalID);
                        pageRef.setRedirect(true);
                        return pageRef;
                        
                    }
            // call Apttus OOB page to copy the Opportunity Product to Proposal linitems.
                                    
        } else {
              ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: No Opportunity on Proposal');
              ApexPages.addMessage(myMsg);
              PageReference pageRef = new PageReference('/'+proposalID);
              pageRef.setRedirect(true);
              return pageRef;
        }                                           
        
        
     }
     
 //This method is implemented to resolve the Defect D-0611.Updating of Academic Vetting Status to "Pre-Vetted" should occur on Opportunities of "New Business" only 
 //when products are changed/re-synced to the opportunity where the academic vetting status was previously set to "Vetted - Approved" 
//This defaulting of Academic Vetting Status to "Pre-Vetted" upon Opportunity creation only occurs when it is created via the "Returning Opportunity" or "Amendment Opportunity" Buttons.      
     
     Private boolean canChangeToPreVetted(Opportunity oppty){                      
          
         if(oppty.Type == 'New Business' &&  oppty.Academic_Vetting_Status__c == 'Vetted - Approved'){
            
            System.debug('Passed by canChangeToPrevetted and returned true, Type='+ oppty.Type + ', Academic_Vetting_Status__c=' + oppty.Academic_Vetting_Status__c);
              
              return true ;                        
         }
          else{   
                   
             System.debug('Passed by canChangeToPrevetted and returned false, Type='+ oppty.Type + ', Academic_Vetting_Status__c=' + oppty.Academic_Vetting_Status__c);  
                     
              return false;            
              
              }          
         
     }


}