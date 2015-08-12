//Apex class "Repayment_Calculator" to create or Delete Repayment Calculator records.
public class Repayment_Calculator{
    
    /** method to create Repayment Calculator records  **/
    public void create_Repayment_Calculator(List<Apttus_Proposal__Proposal__c> proposals){
        List<Repayment_Calculator__c> create_Repayment_Calculator = new  List<Repayment_Calculator__c>();
        Quote_Settings__c qsvalue = Quote_Settings__c.getValues(Utils_allfields.customSettingName);
       
        
        for(Apttus_Proposal__Proposal__c eachpropsal : proposals){
            
            Repayment_Calculator__c temp_Repayment_Calculator = new Repayment_Calculator__c();
                   temp_Repayment_Calculator.Quote_Proposal__c = eachpropsal.ID;
                  
                   temp_Repayment_Calculator.Payment_Date__c = eachpropsal.First_Payment_Date__c;
                   temp_Repayment_Calculator.Beginning_Balance__c = eachpropsal.Remaining_Payment_Amount_f__c;
                   temp_Repayment_Calculator.Scheduled_Payment__c = eachpropsal.Scheduled_Monthly_Payments_f__c;
                   temp_Repayment_Calculator.Interest_Rate__c = qsvalue.Administration_Fee_Rate__c;
                   temp_Repayment_Calculator.Extra_Payment__c = null;
                   temp_Repayment_Calculator.Discount_Reversed__c = temp_Repayment_Calculator.Beginning_Balance__c * (qsvalue.Administration_Fee_Rate__c / 100) / 12;
                   temp_Repayment_Calculator.Total_Payment__c = eachpropsal.Scheduled_Monthly_Payments_f__c;// - temp_Repayment_Calculator.Extra_Payment__c;
                   temp_Repayment_Calculator.Principal__c = temp_Repayment_Calculator.Total_Payment__c- temp_Repayment_Calculator.Discount_Reversed__c ;
                   temp_Repayment_Calculator.Ending_Balance__c = eachpropsal.Remaining_Payment_Amount_f__c - temp_Repayment_Calculator.Principal__c;
            
            /*system.debug('  Beginning_Balance:'+temp_Repayment_Calculator.Beginning_Balance__c);
            system.debug('  Scheduled_Payment:'+temp_Repayment_Calculator.Scheduled_Payment__c);
            system.debug('  Interest_Rate:'+temp_Repayment_Calculator.Interest_Rate__c);
            system.debug('  Extra_Payment:'+temp_Repayment_Calculator.Extra_Payment__c );
            system.debug('  Discount_Reversed  :'+temp_Repayment_Calculator.Discount_Reversed__c);
            system.debug('  Total_Payment:'+temp_Repayment_Calculator.Total_Payment__c );
            system.debug('  Principal :'+ temp_Repayment_Calculator.Principal__c);
            system.debug('  Ending_Balance:'+temp_Repayment_Calculator.Ending_Balance__c);*/
            
            
           for(integer count = 1 ; count <= Integer.valueof(eachpropsal.Payment_Period_In_Month__c); count++){
               
                   Repayment_Calculator__c Repayment_Calculator = new Repayment_Calculator__c();
                   Repayment_Calculator.Quote_Proposal__c = temp_Repayment_Calculator.Quote_Proposal__c;
                   Repayment_Calculator.Sequence_No__c = count;
                   Repayment_Calculator.Payment_Date__c = temp_Repayment_Calculator.Payment_Date__c;
                   Repayment_Calculator.Beginning_Balance__c = temp_Repayment_Calculator.Beginning_Balance__c;
                   Repayment_Calculator.Scheduled_Payment__c = temp_Repayment_Calculator.Scheduled_Payment__c;
                   Repayment_Calculator.Interest_Rate__c = temp_Repayment_Calculator.Interest_Rate__c;
                   Repayment_Calculator.Extra_Payment__c = temp_Repayment_Calculator.Extra_Payment__c;
                   Repayment_Calculator.Discount_Reversed__c = temp_Repayment_Calculator.Discount_Reversed__c;
                   Repayment_Calculator.Total_Payment__c = temp_Repayment_Calculator.Total_Payment__c;
                   Repayment_Calculator.Principal__c = temp_Repayment_Calculator.Principal__c;
                   Repayment_Calculator.Ending_Balance__c = temp_Repayment_Calculator.Ending_Balance__c;
                   create_Repayment_Calculator.add(Repayment_Calculator);
                   
                   // logic for Repayment calculation.
                   temp_Repayment_Calculator.Payment_Date__c = temp_Repayment_Calculator.Payment_Date__c.addMonths(1);
                   temp_Repayment_Calculator.Beginning_Balance__c = temp_Repayment_Calculator.Ending_Balance__c;
                   temp_Repayment_Calculator.Scheduled_Payment__c = eachpropsal.Scheduled_Monthly_Payments_f__c;
                   temp_Repayment_Calculator.Interest_Rate__c = qsvalue.Administration_Fee_Rate__c;
                   temp_Repayment_Calculator.Extra_Payment__c = null;
                   temp_Repayment_Calculator.Discount_Reversed__c = temp_Repayment_Calculator.Beginning_Balance__c * (qsvalue.Administration_Fee_Rate__c /100) / 12;
                   temp_Repayment_Calculator.Total_Payment__c = eachpropsal.Scheduled_Monthly_Payments_f__c;// - temp_Repayment_Calculator.Extra_Payment__c;
                   temp_Repayment_Calculator.Principal__c = temp_Repayment_Calculator.Total_Payment__c- temp_Repayment_Calculator.Discount_Reversed__c ;
                   temp_Repayment_Calculator.Ending_Balance__c = temp_Repayment_Calculator.Beginning_Balance__c - temp_Repayment_Calculator.Principal__c;
               
           }
           system.debug('create_Repayment_Calculator  :'+create_Repayment_Calculator);
           
           
        }
        
        if(!create_Repayment_Calculator.isEmpty()){
            try{
                insert create_Repayment_Calculator;
            }catch (DMLException e) {
                        System.debug('Exception: Repayment_Calculator deleting records');   
                        throw e;        
                    }
            
        }
        
        
    }
    
    //Method to delete Repayment_Calculator records given list of proposals
    
    public void delete_Repayment_Calculator(List<Id> ProposalId){
        List <Repayment_Calculator__c> Del_Repayment_Calculator = new List <Repayment_Calculator__c>();
       if(ProposalId != Null && !ProposalId.isEmpty()){
           Del_Repayment_Calculator = [select Id from Repayment_Calculator__c where Quote_Proposal__c in:ProposalId];
       }
       if(!Del_Repayment_Calculator.isEmpty()){
           try{
               delete Del_Repayment_Calculator;
           }catch (DMLException e) {
                        System.debug('Exception: Repayment_Calculator deleting records');      
                        throw e;     
                    }
           
           
       }
        
    }

}