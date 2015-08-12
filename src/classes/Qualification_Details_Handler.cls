/*
Handler class for Qualification Details Trigger.
Created by Accenture IDC
*/
public with sharing class Qualification_Details_Handler {
    
    public void proposalMethod(List<Apttus_Proposal__Proposal__c> newPropsalList, Map<Id,Apttus_Proposal__Proposal__c> oldMap){
        //logic to populate proposals currency with Pricelists currency 
            system.debug(' in  pricelist currency ');
            List<Apttus_Proposal__Proposal__c> proposal_procelistchange = new List<Apttus_Proposal__Proposal__c>();
            for(Apttus_Proposal__Proposal__c eachproposal: newPropsalList){
                if(trigger.isInsert && eachproposal.Apttus_QPConfig__PriceListId__c != null){
                    proposal_procelistchange.add(eachproposal);
                }else if(trigger.isUpdate && eachproposal.Apttus_QPConfig__PriceListId__c != null && eachproposal.Apttus_QPConfig__PriceListId__c != oldMap.get(eachproposal.Id).Apttus_QPConfig__PriceListId__c){
                            proposal_procelistchange.add(eachproposal);
                }
            }
            // if the proposal is created or the pricelist is changed
            if(proposal_procelistchange != null && !proposal_procelistchange.isEmpty()){
                Proposal_currency(proposal_procelistchange);
            }
    }
    
    public void proposalMethod1(List<Apttus_Proposal__Proposal__c> newPropsalList, Map<Id,Apttus_Proposal__Proposal__c> oldMap){
        Set<Id> proposalids = new Set<Id>();
        Set<Id> proposals_Deposit = new Set<Id>();
        for(Apttus_Proposal__Proposal__c eachproposal: newPropsalList){
            system.debug('eachproposal.Apttus_QPConfig__ConfigurationFinalizedDate__c  :'+ eachproposal.Apttus_QPConfig__ConfigurationFinalizedDate__c);
            system.debug('oldMap.get(eachproposal.Id).Apttus_QPConfig__ConfigurationFinalizedDate__c :'+ oldMap.get(eachproposal.Id).Apttus_QPConfig__ConfigurationFinalizedDate__c);
            if(eachproposal.Apttus_QPConfig__ConfigurationFinalizedDate__c != null && eachproposal.Apttus_QPConfig__ConfigurationFinalizedDate__c != oldMap.get(eachproposal.Id).Apttus_QPConfig__ConfigurationFinalizedDate__c){
                proposalids.add(eachproposal.id);
                proposals_Deposit.add(eachproposal.id);
            }
            if(eachproposal.Payment_Type__c != null && eachproposal.Payment_Type__c != oldMap.get(eachproposal.Id).Payment_Type__c && !proposals_Deposit.contains(eachproposal.Id)){
                proposals_Deposit.add(eachproposal.id);
            }
    
        }
        
        if(!proposalids.isEmpty()){
            
            system.debug(' proposalids  :'+ proposalids);
            List<Apttus_Proposal__Proposal_Line_Item__c> propline = [select Id, 
                                                                        Apttus_QPConfig__ClassificationHierarchy__c,
                                                                        Apttus_QPConfig__LineNumber__c,
                                                                        Apttus_QPConfig__LineType__c,
                                                                        Apttus_QPConfig__ItemSequence__c,
                                                                        Outside_Module__c,
                                                                        Apttus_Proposal__Product__r.Qualification_Level_Code__c,
                                                                        Apttus_Proposal__Product__r.Qualification_Level_Name__c,
                                                                        Apttus_Proposal__Product__r.Conferer__c,
                                                                        Apttus_Proposal__Product__r.Campus__c,
                                                                        Apttus_Proposal__Product__r.Qualification_Name__c,
                                                                        Apttus_Proposal__Proposal__r.Apttus_Proposal__Opportunity__r.International_Student_Status__c,
                                                                        Apttus_Proposal__Proposal__r.Apttus_Proposal__Opportunity__r.International_Sponsor__c,
                                                                        Apttus_Proposal__Proposal__r.Course_Fee_Rollup__c,
                                                                        Apttus_Proposal__Proposal__c 
                                                                        from Apttus_Proposal__Proposal_Line_Item__c 
                                                                        where Apttus_Proposal__Proposal__c in: proposalids order by Apttus_Proposal__Proposal__c, Apttus_QPConfig__ItemSequence__c];
                                                                         
            Map<Id, List<Apttus_Proposal__Proposal_Line_Item__c>> Mapproline = new Map<Id, List<Apttus_Proposal__Proposal_Line_Item__c>>();
            Map<Id, Apttus_Proposal__Proposal_Line_Item__c> lineselected = new Map<Id, Apttus_Proposal__Proposal_Line_Item__c>();
            Map<Id,String> proposal_is_internation_student = new Map<Id,String>();
            Map<Id,decimal> proposal_Course_Fee = new Map<Id,decimal>();
            List<String> Account_string = new List<String>();
            Set<String> Conferer_string = new Set<String>();
            Map<String,Id> map_Account = new Map<String,Id>();
                if(!propline.isEmpty()){
                    for(Apttus_Proposal__Proposal_Line_Item__c eachpli: propline){
                        List<Apttus_Proposal__Proposal_Line_Item__c> temppli = new List<Apttus_Proposal__Proposal_Line_Item__c>();
                        if(Mapproline.get(eachpli.Apttus_Proposal__Proposal__c) == null){
                            temppli.add(eachpli);
                            Mapproline.put(eachpli.Apttus_Proposal__Proposal__c, temppli);
                        }else{
                            temppli = Mapproline.get(eachpli.Apttus_Proposal__Proposal__c);
                            temppli.add(eachpli);
                            Mapproline.put(eachpli.Apttus_Proposal__Proposal__c, temppli);
                        }
                        if(proposal_is_internation_student.get(eachpli.Apttus_Proposal__Proposal__c) == null){
                            proposal_is_internation_student.put(eachpli.Apttus_Proposal__Proposal__c,eachpli.Apttus_Proposal__Proposal__r.Apttus_Proposal__Opportunity__r.International_Sponsor__c);
                        }
                        
                        if(proposal_Course_Fee.get(eachpli.Apttus_Proposal__Proposal__c) == null){
                            proposal_Course_Fee.put(eachpli.Apttus_Proposal__Proposal__c, eachpli.Apttus_Proposal__Proposal__r.Course_Fee_Rollup__c);
                        }
                    }
                }
            system.debug('propline  :'+propline);
            system.debug('Mapproline   :'+Mapproline);
            
            
           
            AggregateResult[]  pli = [SELECT Apttus_Proposal__Proposal__c,
                                             MAX(Apttus_QPConfig__ItemSequence__c) maxvalue 
                                             FROM Apttus_Proposal__Proposal_Line_Item__c WHERE Apttus_Proposal__Proposal__c in: proposalids
                                             Group by Apttus_Proposal__Proposal__c];
            system.debug(' pli :'+ pli);
            Map<Id,Decimal> maxlineseq = new Map<Id,Decimal>();
                if(!pli.isEmpty()){
                    For(AggregateResult eachpli : pli){
                        Id proposalvalue = (Id) eachpli.get('Apttus_Proposal__Proposal__c');
                        Decimal Maxval = (Decimal)eachpli.get('maxvalue');
                        system.debug('proposalvalue :'+proposalvalue);
                        System.debug('maxvalue  :'+Maxval );
                        maxlineseq.put(proposalvalue,Maxval);
                    }
                }
        
            system.debug('maxlineseq :'+maxlineseq);
            
            Map<Id,Decimal> proposallinenumber = new Map<Id,Decimal>();
                if(!Mapproline.isEmpty()){
                    for(Id eachproposal :  Mapproline.keyset()){
                        for(Apttus_Proposal__Proposal_Line_Item__c eachPLI :Mapproline.get(eachproposal)){
                            if(eachPLI.Apttus_QPConfig__ItemSequence__c == maxlineseq.get(eachproposal)){
                                proposallinenumber.put(eachproposal, eachPLI.Apttus_QPConfig__LineNumber__c);
                                break;
                            }
                       
                        }
                    }
                }
            
            system.debug('proposallinenumber  :'+  proposallinenumber);
            
            for(Apttus_Proposal__Proposal__c eachproposal : newPropsalList){
                system.debug('eachproposal.Id  :'+eachproposal.Id);
                system.debug('Mapproline   :'+Mapproline);
                if(!Mapproline.isEmpty() && Mapproline != null)
                for(Apttus_Proposal__Proposal_Line_Item__c eachPLI :Mapproline.get(eachproposal.Id)){
                    if(eachPLI.Apttus_QPConfig__LineNumber__c == proposallinenumber.get(eachproposal.Id)){
                       eachPLI.Outside_Module__c = false;
                       if(eachPLI.Apttus_QPConfig__LineType__c == 'Product/Service' && eachPLI.Apttus_QPConfig__ClassificationHierarchy__c != null){
                           //String Qualification_Details = eachPLI.Apttus_QPConfig__ClassificationHierarchy__c;
                           //system.debug('qualification_Details: '+ qualification_Details );
                           //Integer length = qualification_Details.split('\\|').size();
                           //String [] strsplit = qualification_Details.split('\\|');
                           //system.debug('length :'+length);
                           /*for(String str : qualification_Details.split('\\|')){
                             system.debug('STR :'+str);
                           }*/
                               eachproposal.Conferer__c = eachPLI.Apttus_Proposal__Product__r.Conferer__c;
                               eachproposal.Qualification__c = eachPLI.Apttus_Proposal__Product__r.Qualification_Name__c;
                               eachproposal.Campus__c = eachPLI.Apttus_Proposal__Product__r.Campus__c;
                               eachproposal.Level__c = eachPLI.Apttus_Proposal__Product__r.Qualification_Level_Name__c;
                               Account_string.add(eachproposal.Campus__c.toUpperCase());
                               Conferer_string.add(eachproposal.Conferer__c.toUpperCase());
                           
                       }
                       
                    }else {
                        eachPLI.Outside_Module__c = true;
                    }
        
                }
                
                system.debug('proposal_is_internation_student.get(eachproposal.Id)  :'+ proposal_is_internation_student.get(eachproposal.Id));
                system.debug('proposal_Course_Fee.get(eachproposal.Id)  :'+ proposal_Course_Fee.get(eachproposal.Id));
                //if inernational studen 50% deposit 
                /*if(proposal_is_internation_student.get(eachproposal.Id) != null && proposal_is_internation_student.get(eachproposal.Id) == 'Yes'){
                    if(proposal_Course_Fee.get(eachproposal.Id) != null && proposal_Course_Fee.get(eachproposal.Id) != 0){
                          eachproposal.Deposit__c = (proposal_Course_Fee.get(eachproposal.Id)) / 2 ;
                          system.debug('eachproposal.Deposit__c  :'+eachproposal.Deposit__c);
                    }
                }*/
                
                
            }
                // logic to update  Account in Qualification compus 
                if(Account_string != null && !Account_string.isEmpty() && Conferer_string != null && !Conferer_string.isEmpty()){
                    system.debug('Account_string'+Account_string);
                    system.debug('Conferer_string :'+Conferer_string);
                    Id orgrecordid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Organisation').getRecordTypeId();
                    system.debug('orgrecordid  :'+orgrecordid);
                    
                    List<Account> list_account =  [select Id, Name, Pearson_Campus_Picklist__c, Pearson_Campus__c  
                                                    from Account where
                                                                       RecordTypeId =:orgrecordid and 
                                                                       Pearson_Campus_Picklist__c in: Account_string and
                                                                       Pearson_Institution__c in:Conferer_string and
                                                                       Pearson_Campus__c = true and
                                                                       Pearson_Account_Number__c = 'Campus'
                                                                       ];
                   
                        if(list_account != null && !list_account.isEmpty()){
                            
                            for(Account eachaccount : list_account){
                                map_Account.put(eachaccount.Pearson_Campus_Picklist__c.trim().toUpperCase(),eachaccount.Id);
                            }
                            
                            for(Apttus_Proposal__Proposal__c eachproposal : newPropsalList){
                                if(proposalids.contains(eachproposal.id) && map_Account.get(eachproposal.Campus__c.toUpperCase()) != null){
                                    eachproposal.Qualification_Campus__c = map_Account.get(eachproposal.Campus__c.toUpperCase());
                                }
                            }
                        }
                    
                }
                
            if(!propline.isEmpty() &&  propline != null) 
                try{
                    update propline;
                }catch(Exception e){
                    system.debug('Exception Message'+ e.getMessage());
                }
        }  
        
        
            for(Apttus_Proposal__Proposal__c eachproposal : newPropsalList){
                if(proposals_Deposit.contains(eachproposal.id) && eachproposal.Payment_Type__c != null){
                    if(eachproposal.Payment_Type__c == '50% Deposit'){
                        eachproposal.Deposit__c = eachproposal.Course_Fee_Rollup__c * 0.5 ;
                    } else if (eachproposal.Payment_Type__c == '30% Deposit'){
                                 eachproposal.Deposit__c = eachproposal.Course_Fee_Rollup__c * 0.3;
                             }
                }
            }
    }
    public void proposalMethod2(List<Apttus_Proposal__Proposal__c> newPropsalList, Map<Id,Apttus_Proposal__Proposal__c> oldMap){
        List<Id> proposalids = new List<Id>();
         List<Apttus_Proposal__Proposal__c> proposals = new List<Apttus_Proposal__Proposal__c>();
         for(Apttus_Proposal__Proposal__c eachproposal: newPropsalList){
           if( eachproposal.Apttus_QPConfig__ConfigurationFinalizedDate__c != null && eachproposal.Apttus_QPConfig__ConfigurationFinalizedDate__c != oldMap.get(eachproposal.Id).Apttus_QPConfig__ConfigurationFinalizedDate__c ){
                    proposalids.add(eachproposal.id);
                    proposals.add(eachproposal);
            } else if (eachproposal.Apttus_QPConfig__ConfigurationFinalizedDate__c != null && 
                        (eachproposal.Payment_Period_In_Month__c != oldMap.get(eachproposal.Id).Payment_Period_In_Month__c ||
                        eachproposal.First_Payment_Date__c != oldMap.get(eachproposal.Id).First_Payment_Date__c)){
                            
                            proposalids.add(eachproposal.id);
                            proposals.add(eachproposal);
                            
                    }
         }
        
        if(proposalids.isEmpty()){
            return;
        }else{
            Repayment_Calculator RC = New Repayment_Calculator();
            RC.delete_Repayment_Calculator(proposalids);
            RC.create_Repayment_Calculator(proposals);
        }
         // call Repayment_Calculator 
    }
    //logic to match Pricelists currency with proposals currency
     public void Proposal_currency(List<Apttus_Proposal__Proposal__c> proposal_list){
         Map<Id,String> pricelist_currency = new Map<Id,String>();
         List<Id> pricelistId = new List<String>();
         List<Apttus_Config2__PriceList__c> price_lists = new List<Apttus_Config2__PriceList__c>();
         if(!proposal_list.isEmpty()){
             for(Apttus_Proposal__Proposal__c eachproposal: proposal_list){
                 pricelistId.add(eachproposal.Apttus_QPConfig__PriceListId__c);
             }
         }
         if(pricelistId != null && !pricelistId.isEmpty()){
             price_lists = [select Id, CurrencyIsoCode from Apttus_Config2__PriceList__c where Id in :pricelistId];
         }
         if(!price_lists.isEmpty()){
             for(Apttus_Config2__PriceList__c eachpricelist : price_lists){
                 pricelist_currency.put(eachpricelist.Id,eachpricelist.CurrencyIsoCode);
             }
         }
         if(!proposal_list.isEmpty()){
             for(Apttus_Proposal__Proposal__c eachproposal:proposal_list){
                if(pricelist_currency.get(eachproposal.Apttus_QPConfig__PriceListId__c) != null){
                    eachproposal.CurrencyIsoCode = pricelist_currency.get(eachproposal.Apttus_QPConfig__PriceListId__c);
                }
             }
         }
     }
}