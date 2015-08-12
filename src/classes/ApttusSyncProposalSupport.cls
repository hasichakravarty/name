/**
 *  Apttus Proposal-Config Integration
 *  ApttusSyncProposalSupport
 *   
 *  @2012-2013 Apttus Inc. All rights reserved.
 */
public abstract class ApttusSyncProposalSupport {
    /**
     * Synchronize the given quote/Proposal sobject with the associated opportunity
     * @param ProposalSO the Proposal sobject to synchronize 
     */
    public static void syncToOpportunity(Apttus_Proposal__Proposal__c ProposalSO) {
        // if no associated opportunity, abort
        if (ProposalSO.Apttus_Proposal__Opportunity__c == null) {
            return;
        }
        ID opptyId = ProposalSO.Apttus_Proposal__Opportunity__c;
        ID opptyPricebookId;
        String CurrencyIsoCode;
        // Get the Opportunity Line Items prior to deletion
        List<OpportunityLineItem> listOptyLines = new List<OpportunityLineItem>();
        //listOptyLines = getLineItemsForOpportunity(opptyId);
          // delete existing opportunity line items
        deleteLineItemsForOpportunity(opptyId);
          // get the Proposal lineitem objects
        List<Apttus_Proposal__Proposal_Line_Item__c> lineItems = getLineItemsForQuoteOrProposal(ProposalSO.Id,'Finalized');
        if (lineItems.isEmpty()) {
            return;     
        }   
        // get the opportunity price book id
        for(List<Opportunity> optys : [SELECT Pricebook2Id, CurrencyIsoCode FROM Opportunity WHERE Id = :opptyId LIMIT 1]){
            for (Opportunity opty : optys){
                opptyPricebookId = opty.Pricebook2Id;
                CurrencyIsoCode = opty.CurrencyIsoCode;
            }
        }
       
        // if no price book associated with the opportunity, use the standard price book
        if (opptyPricebookId == null) {
              // set the opportunity to use the standard price book
            for(List<Pricebook2> pbs : [SELECT Id FROM Pricebook2 WHERE IsStandard = TRUE LIMIT 1]){
                for (Pricebook2 pb : pbs){
                    opptyPricebookId = pb.Id;
                }
            }             
        }
        system.debug('opptyPricebookId  :'+opptyPricebookId);

    // need to restrict 30,600+ PBE records to just products in play
        Set<ID> mapLineProductIds = new Set<ID>();
        for (Apttus_Proposal__Proposal_Line_Item__c lineItemSO : lineItems){
                mapLineProductIds.add(lineItemSO.Apttus_Proposal__Product__c);
            }
     system.debug('mapLineProductIds  :'+mapLineProductIds);
    //map PricebookEntry id to Product2Id

        Map<ID, id> mapPbEpropri = new Map<ID, id>();
        for(PricebookEntry pbe : [select Id, Product2Id from PricebookEntry where Product2Id in :mapLineProductIds and Pricebook2Id = :opptyPricebookId and CurrencyIsoCode =: CurrencyIsoCode ]){
                 mapPbEpropri.put(pbe.Product2Id,pbe.Id);
            }
     system.debug('mapPbEpropri  :'+mapPbEpropri);
    //map lineItems.id to lineItems.Product2Id

        Map<ID, id> mapProPris = new Map<ID, id>();
        for (Apttus_Proposal__Proposal_Line_Item__c lineItemSO : lineItems) {
                mapProPris.put(lineItemSO.ID,mapPbEpropri.get(lineItemSO.Apttus_Proposal__Product__c ));
            }
             
             system.debug('mapProPris :'+mapProPris);   
        // create opportunity lineitems
        List<OpportunityLineItem> oppLineItems = new List<OpportunityLineItem>();
        for (Apttus_Proposal__Proposal_Line_Item__c lineItemSO : lineItems) {

            // skip if no product 
            if (lineitemSO.Apttus_Proposal__Product__c == null ) {
                continue;
            }

                // create a new opportunity line item
                OpportunityLineItem oppLineItemSO   = new OpportunityLineItem(OpportunityId = opptyId);
                
                // copy custom fields from Proposal line item to opportunity line item
                
                //Modified on 9/4/2013 to resolve a production issue. The Net Adjustment Percent from Apttus can be outside of 0 to 100 range
                // and ins such cases there was field integrity exception because teh field was being synced back to the OTB Disocunt field 
                // in the Opportunity Product. Instead we are now syncing this back to custom field in the opportunity product.
                
                //oppLineItemSO.Discount                  = math.abs(lineItemSO.Apttus_QPConfig__NetAdjustmentPercent__c);
                //oppLineItemSO.Net_Adjustment_Percent__c = math.abs(lineItemSO.Apttus_QPConfig__NetAdjustmentPercent__c);
                
                oppLineItemSO.Quantity                  = lineItemSO.Apttus_QPConfig__Quantity2__c;
                oppLineItemSO.Discount_Reference__c     = lineItemSO.Discount_Reference__c;
                oppLineItemSO.OptionId__c               = lineItemSO.Apttus_QPConfig__OptionId__c;
                oppLineItemSO.LineType__c               = lineItemSO.Apttus_QPConfig__LineType__c;
                oppLineItemSO.Outside_Module__c         = lineItemSO.Outside_Module__c;
                ID priceBookEntryId                     = mapProPris.get(lineItemSO.ID);
                system.debug('priceBookEntryId map:'+priceBookEntryId);
                oppLineItemSO.PricebookEntryId          = priceBookEntryId;
                oppLineItemSO.LineNumber__c             = lineItemSO.Apttus_QPConfig__LineNumber__c;
                oppLineItemSO.Amendment_Action__c       = lineItemSO.Amendment_Action__c;
                oppLineItemSO.ProductOptionId__c        = lineItemSO.Apttus_QPConfig__ProductOptionId__c;
                //system.debug('mapProPris.get(lineItemSO.ID)  :'+mapProPris.get(lineItemSO.ID));
                if((lineItemSO.Apttus_QPConfig__LineType__c == 'Product/Service')){
                    oppLineItemSO.UnitPrice = 0.00;
                 }else {
                     oppLineItemSO.UnitPrice = lineItemSO.Apttus_QPConfig__NetPrice__c;
                 }
                
                //oppLineItemSO.PricebookEntryId = opptyPricebookId;
                //oppLineItemSO.UnBundledPrice__c         = lineItemSO.Apttus__NetPrice__c ;
                //oppLineItemSO.ChargeType__c         = lineItemSO.Apttus_QPConfig__ChargeType__c ;
                
                // Added on 09/23/2013 to populate 3 more fields during the sync, as per Brian/Gopal's request
                //oppLineItemSO.Item_Sequence__c = lineItemSO.Apttus_QPConfig__ItemSequence__c;
                //oppLineItemSO.Line_Number__c = lineItemSO.Apttus_QPConfig__LineNumber__c;
                //oppLineItemSO.Line_Type__c = lineItemSO.Apttus_QPConfig__LineType__c;

                //if (lineItemSO.Apttus__Quantity__c==null || lineItemSO.Apttus__Quantity__c<=0)
                   // oppLineItemSO.Quantity = 1;                    

                
                    //else{
                    //oppLineItemSO.TotalPrice= lineItemSO.Apttus__ExtendedPrice__c == null ?0.00:lineItemSO.Apttus__ExtendedPrice__c;    
                    //GPetrie - Refactored the Above Line to the one below.  This was done to assure that Opportunity Value = NetValue from Proposal
                    //oppLineItemSO.TotalPrice= (lineItemSO.Apttus__NetPrice__c == null ?0.00:lineItemSO.Apttus__NetPrice__c); 
                    //}

                //GPetrie - Added line below to add Option Name to Product Related List
                //oppLineItemSO.Option__c =  lineItemSO.Apttus_QPConfig__OptionId__r.Name; 
               // oppLineItemSO.Category__c=lineItemSO.Apttus_QPConfig__ClassificationId__r.name;  
                //if (lineItemSO.Apttus_QPConfig__ClassificationHierarchy__c != null)
                 //   oppLineItemSO.Category_Hierarchy__c =lineItemSO.Apttus_QPConfig__ClassificationHierarchy__c;
                // update opportunity product from line item
                
                // add the line item to the collection
                oppLineItems.add(oppLineItemSO);
        }
           
        
        // bulk insert the opportunity line items
        system.debug('before oppLineItems  :'+ oppLineItems);
        if (!oppLineItems.isEmpty()) {
            insert(oppLineItems);
        }  
        system.debug('oppLineItems  :'+ oppLineItems);        
    } 
    
    /**
     * Deletes the line item sobjects for the given opportunity id
     * @param opptyId the opportunity id associated with the line items 
     */
    private static void deleteLineItemsForOpportunity(ID opptyId) {
        // delete opportunity line items
        for (List<OpportunityLineItem> items : [SELECT Id        
                                                FROM OpportunityLineItem
                                                WHERE OpportunityId = :opptyId]) {
                                                            
            // bulk delete line items
            Database.delete(items);
        }   
    }       
    /**
     * Gets the list of Proposal lineitem sobjects for the given quote/Proposal id
     * @param quoteOrProposalId the quote/Proposal id associated with the Proposal lineitem
     * @return the list of Proposal lineitem sobjects 
     */
    public static List<Apttus_Proposal__Proposal_Line_Item__c> getLineItemsForQuoteOrProposal(ID quoteOrProposalId,string Option) {

        // get the Proposal lineitems
       
        List<Apttus_Proposal__Proposal_Line_Item__c> lineItems = [ Select  ID, Name,
                                                                    Apttus_Proposal__Description__c, 
                                                                    Apttus_QPConfig__NetPrice__c,  
                                                                    Apttus_Proposal__Product__c, 
                                                                    Apttus_Proposal__Proposal__c, 
                                                                    Apttus_QPConfig__AdjustedPrice__c, 
                                                                    Apttus_QPConfig__AdjustmentAmount__c, 
                                                                    Apttus_QPConfig__AdjustmentType__c,                                                                    
                                                                    Apttus_QPConfig__BaseExtendedPrice__c, 
                                                                    Apttus_QPConfig__BasePrice__c, 
                                                                    Apttus_QPConfig__BasePriceMethod__c, 
                                                                    Apttus_QPConfig__BaseProductId__c, 
                                                                    Apttus_QPConfig__ChargeType__c, 
                                                                    Apttus_QPConfig__ClassificationHierarchy__c, 
                                                                    Apttus_QPConfig__ClassificationId__c, 
                                                                    Apttus_QPConfig__ClassificationId__r.name,
                                                                    Apttus_QPConfig__ClassificationId__r.Apttus_Config2__Label__c,
                                                                    Apttus_QPConfig__Comments__c, 
                                                                    Apttus_QPConfig__ConfigurationId__c, 
                                                                    Apttus_QPConfig__Cost__c, 
                                                                    Apttus_QPConfig__DerivedFromId__c, 
                                                                    Apttus_QPConfig__EndDate__c, 
                                                                    Apttus_QPConfig__ExtendedDescription__c, 
                                                                    Apttus_QPConfig__ExtendedPrice__c, 
                                                                    Apttus_QPConfig__Frequency__c, 
                                                                    Apttus_QPConfig__GroupAdjustmentPercent__c, 
                                                                    Apttus_QPConfig__IsOptionRollupLine__c, 
                                                                    Apttus_QPConfig__IsPrimaryLine__c, 
                                                                    Apttus_QPConfig__ItemSequence__c, 
                                                                    Apttus_QPConfig__LineNumber__c, 
                                                                    Apttus_QPConfig__LineStatus__c, 
                                                                    Apttus_QPConfig__LineType__c, 
                                                                    Apttus_QPConfig__ListPrice__c, 
                                                                    Apttus_QPConfig__NetAdjustmentPercent__c, 
                                                                    Apttus_QPConfig__OptionId__c,
                                                                    Apttus_QPConfig__OptionId__r.Name, 
                                                                    Apttus_QPConfig__OptionPrice__c, 
                                                                    Apttus_QPConfig__PriceAdjustment__c, 
                                                                    Apttus_QPConfig__PriceAdjustmentAmount__c, 
                                                                    Apttus_QPConfig__PriceAdjustmentType__c, 
                                                                    Apttus_QPConfig__PriceListId__c, 
                                                                    Apttus_QPConfig__PriceListItemId__c, 
                                                                    Apttus_QPConfig__PriceMethod__c, 
                                                                    Apttus_QPConfig__PriceType__c, 
                                                                    Apttus_QPConfig__PriceUom__c, 
                                                                    Apttus_QPConfig__ProductOptionId__c, 
                                                                    Apttus_QPConfig__Quantity2__c, 
                                                                    Apttus_QPConfig__SellingFrequency__c, 
                                                                    Apttus_QPConfig__SellingTerm__c, 
                                                                    Apttus_QPConfig__StartDate__c, 
                                                                    Apttus_QPConfig__SummaryGroupId__c, 
                                                                    Apttus_QPConfig__Term__c, 
                                                                    Apttus_QPConfig__Uom__c,
                                                                    Discount_Reference__c,
                                                                    Outside_Module__c,
                                                                    Amendment_Action__c
                                                                    from Apttus_Proposal__Proposal_Line_Item__c a
                                              where Apttus_Proposal__Proposal__c = :quoteOrProposalId                                                       
                                                    and  Apttus_QPConfig__ConfigurationId__r.Apttus_Config2__Status__c =: Option 
                                                    ];        
        return lineitems;
    }
  /**
     * Gets the list of Opportunity lineitem sobjects for the given quote/Opportunity id
     * @param quoteOrOpportunityId the quote/Opportunity id associated with the Opportunity lineitem
     * @return the list of Opportunity lineitem sobjects 
     */
   /* public static List<OpportunityLineItem> getLineItemsForOpportunity(ID quoteOrOpportunityId) {
        // get the Opportunity lineitems       
        List<OpportunityLineItem> optylineItems = [Select ID,
                                                  
                                                  Category__c,
                                                 // Category_Hierarchy__c,
                                                  //ChargeType__c,
                                                  //DDLP_CC__c,
                                                  //Eastern_Canada_CC__c,
                                                  //GTA_CC__c,
                                                  //Instalment_Period__c,
                                                  //ItemID__c,
                                                  //Lease_Approval_Number__c,
                                                  //Net_Adjustment_Percent__c,
                                                  //Number_of_Instalments__c,
                                                  //Opp_Product_Key__c,
                                                  //Option__c,
                                                  //Start_Date__c,
                                                  //UnBundledPrice__c,
                                                  //ServiceDate,
                                                  //Discount,
                                                  //Description,                                                  
                                                  //ListPrice,
                                                  OpportunityID,
                                                  PricebookEntryId,
                                                  PricebookEntry.Product2.Id,
                                                  //Product2Id, // weirdness with this field, unable to retrieve
                                                  //ProductCode, // Read only field, unable to retrieve
                                                  Quantity, 
                                                  UnitPrice,
                                                  Subtotal,
                                                  TotalPrice,
                                                  Unique_Key__c,
                                                  Line_Number__c,
                                                  Item_Sequence__c
                                                  FROM OpportunityLineItem
                                      WHERE OpportunityId = :quoteOrOpportunityId];        
        return optylineitems;
    }*/
}