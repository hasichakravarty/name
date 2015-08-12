//Class Name : CreateContractChain
//This class is Called from the button on the Quote.
public with sharing class CreateContractChain {

    @TestVisible ID proposalID;
    @TestVisible ID Proposal_NewID;
    @TestVisible ID cartID;
    List<String> errorMessageList = new List<String>();
    List<String> warningMessageList = new List<String>();
    public Map<Decimal,WrapperProductController> productwrapper = new Map<Decimal,WrapperProductController>();
    @TestVisible public Apttus_Proposal__Proposal__c proposal_new;
    public Boolean pricePending{get; set;}  
    public Boolean hasError{get; set;}
    public string proposalName {get;set;}   
    public Quote_Settings__c qsvalue = Quote_Settings__c.getValues(Utils_allfields.customSettingName);
    //Constructor
    public CreateContractChain (){
        proposalID =  ApexPages.currentPage().getParameters().get('id');
        System.debug('Proposal Id  :'+proposalID);
        hasError = false;
        proposalName = '';
        pricePending = true;
        
        if(proposalID == null) {  
                        hasError = true;
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: No Proposal Id selected');
                        ApexPages.addMessage(myMsg);
        } else {
            //Clone_proposal();
            }
     }
    //Method to CreateCart
    
    public void createCart() {
        if(cartID == null) {
            if(Proposal_NewID != null) {
                hasError = false;
                Apttus_CPQApi.CPQ.CreateCartRequestDO request = new Apttus_CPQApi.CPQ.CreateCartRequestDO();
                request.QuoteID = Proposal_NewID;
                Apttus_CPQApi.CPQ.CreateCartResponseDO cartRespDO = Apttus_CPQApi.CPQWebService.CreateCart(request);
                cartID = cartRespDO.cartID;         
            }
            else {
                hasError = true;
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Cart Creation Failed. Quote Was not Created. ' + ' <a href=\'' + '/' + Proposal_NewID + '\'>' +proposalName+' </a>');
                ApexPages.addMessage(myMsg);
            }
        }
    }
   //Method
    
    public void addLinesToCart() {
        if(proposalId != null){
            hasError = false;
            List<Apttus_Config2__LineItem__c> prodSOList = [select Id,
                                                                   Apttus_Config2__ProductId__c, 
                                                                   Discount_Reference__c, 
                                                                   Apttus_Config2__LineType__c, 
                                                                   Apttus_Config2__LineNumber__c, 
                                                                   Apttus_Config2__Quantity__c 
                                                                   from Apttus_Config2__LineItem__c 
                                                                   where Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c =: proposalId and
                                                                   Apttus_Config2__ConfigurationId__r.Apttus_Config2__Status__c = 'Finalized' and 
                                                                   Apttus_Config2__LineType__c = 'Product/Service'];
             system.debug('prodSOList Size'+prodSOList.size());
             if(prodSOList.size() >0){
                 hasError = false;
                 for(Apttus_Config2__LineItem__c lineitem : prodSOList){
                      WrapperProductController tempproduct = new WrapperProductController();
                      tempproduct.ProductId = lineitem.Apttus_Config2__ProductId__c;
                      tempproduct.Discount_Reference = lineitem.Discount_Reference__c;
                      tempproduct.LineType = lineitem.Apttus_Config2__LineType__c;
                      tempproduct.LineNumber = lineitem.Apttus_Config2__LineNumber__c;
                      tempproduct.Quantity = lineitem.Apttus_Config2__Quantity__c;
                      productwrapper.put(lineitem.Apttus_Config2__LineNumber__c,tempproduct);
                 }
                 List<Apttus_Config2__LineItem__c> prodOptionList = [select Id, 
                                                                            Apttus_Config2__ProductId__c, 
                                                                            Discount_Reference__c, 
                                                                            Apttus_Config2__LineType__c, 
                                                                            Apttus_Config2__LineNumber__c, 
                                                                            Apttus_Config2__OptionId__c, 
                                                                            Apttus_Config2__ProductOptionId__c, 
                                                                            Apttus_Config2__Quantity__c 
                                                                            from Apttus_Config2__LineItem__c 
                                                                            where Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c =: proposalId and 
                                                                            Apttus_Config2__ConfigurationId__r.Apttus_Config2__Status__c = 'Finalized' and 
                                                                            Apttus_Config2__LineType__c != 'Product/Service'];
                                                                            
                                                                            
                for(Apttus_Config2__LineItem__c lineitem : prodOptionList){
                     WrapperProductController tempproduct = new WrapperProductController();
                     WrapperProductController.WrapperProductOption tempproductoption = new WrapperProductController.WrapperProductOption();
                     if(productwrapper.get(lineitem.Apttus_Config2__LineNumber__c) != null){
                         tempproduct = productwrapper.get(lineitem.Apttus_Config2__LineNumber__c);
                         if(tempproduct.productoptions != null){
                             tempproductoption.RecordId = lineitem.Id;
                             tempproductoption.ProductId = lineitem.Apttus_Config2__OptionId__c;
                             tempproductoption.ProductOptionId = lineitem.Apttus_Config2__ProductOptionId__c;
                             tempproductoption.LineType = lineitem.Apttus_Config2__LineType__c;
                             tempproductoption.LineNumber = lineitem.Apttus_Config2__LineNumber__c;
                             tempproductoption.Quantity = lineitem.Apttus_Config2__Quantity__c;
                             tempproductoption.Discount_Reference = lineitem.Discount_Reference__c;
                             tempproduct.productoptions.add(tempproductoption);
                         }else{
                              List<WrapperProductController.WrapperProductOption> templistproductoption = new List<WrapperProductController.WrapperProductOption>();
                              tempproductoption.RecordId = lineitem.Id;
                              tempproductoption.ProductId = lineitem.Apttus_Config2__OptionId__c;
                              tempproductoption.ProductOptionId = lineitem.Apttus_Config2__ProductOptionId__c;
                              tempproductoption.LineType = lineitem.Apttus_Config2__LineType__c;
                              tempproductoption.LineNumber = lineitem.Apttus_Config2__LineNumber__c;
                              tempproductoption.Quantity = lineitem.Apttus_Config2__Quantity__c;
                              tempproductoption.Discount_Reference = lineitem.Discount_Reference__c;
                              templistproductoption.add(tempproductoption);
                              tempproduct.productoptions = templistproductoption;
                              //tempproduct.productoptions 
                         }
                         
                         productwrapper.put(lineitem.Apttus_Config2__LineNumber__c,tempproduct);
                     }else{
                         //option without a bundle ?
                         system.debug(' option without a Bundle ');
                     }
                 }
                 system.debug('productwrapper with options :'+ productwrapper);
                 if(productwrapper != null){
                 for(Decimal eachbundle : productwrapper.keySet()){
                     // create line items and reprice 
                     CreateBundle(productwrapper.get(eachbundle), cartID);
                 }
                 }
             } else {
                  
                 hasError = true;
                 ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: NO Products to add. ' + ' <a href=\'' + '/' + Proposal_NewID + '\'>' +proposalName+' </a>');
                 ApexPages.addMessage(myMsg);
               }
        }else{
             hasError = true;
             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Adding products to Cart failed. ' + ' <a href=\'' + '/' + Proposal_NewID + '\'>' +proposalName+' </a>');
            ApexPages.addMessage(myMsg);
        }
         
    }
     //Method to create Bundle
    public void CreateBundle(WrapperProductController productbundle, Id cartID){
        
        if(cartID != null) {
            hasError = false;
            Apttus_CPQApi.CPQ.AddBundleRequestDO Brequest = new Apttus_CPQApi.CPQ.AddBundleRequestDO();
            Brequest.CartId = cartID;
            Brequest.SelectedBundle = new Apttus_CPQApi.CPQ.SelectedBundleDO();
            Brequest.SelectedBundle.SelectedProduct = new Apttus_CPQApi.CPQ.SelectedProductDO();
            Brequest.SelectedBundle.SelectedProduct.ProductId = productbundle.ProductId;
            Brequest.SelectedBundle.SelectedProduct.Quantity = productbundle.Quantity;
            if(productbundle.productoptions != null){
                List<Apttus_CPQApi.CPQ.SelectedOptionDO> options = new List<Apttus_CPQApi.CPQ.SelectedOptionDO>();
                    for(WrapperProductController.WrapperProductOption optionComponent :productbundle.productoptions){
                        system.debug('in option component');
                        Apttus_CPQApi.CPQ.SelectedOptionDO objSelectedOptionDO = new Apttus_CPQApi.CPQ.SelectedOptionDO();
                        objSelectedOptionDO.ComponentId = optionComponent.ProductOptionId;
                        objSelectedOptionDO.ComponentProductId = optionComponent.ProductId;
                        objSelectedOptionDO.Quantity = optionComponent.Quantity;
                        //Add customFields
                        List<String> customFields = new List<String>();
                        CustomFields.add(Utils_allfields.CustomField);
                        objSelectedOptionDO.CustomFields = customFields;
                        Apttus_Config2__LineItem__c liSO = new Apttus_Config2__LineItem__c();
                        liSO.Discount_Reference__c  = optionComponent.Discount_Reference;
                        objSelectedOptionDO.CustomData = liSO;
                        options.Add(objSelectedOptionDO);
                    }
                    if(options.size()>0){
                        Brequest.SelectedBundle.SelectedOptions = options;
                    }
                    system.debug('options  :'+options.size());
            }
                
                
                Apttus_CPQApi.CPQ.AddBundleResponseDO Bresponse = Apttus_CPQApi.CPQWebService.addBundle(Brequest);
        }else{
             hasError = true;
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Adding Products to Cart Failed. Cart Was not Created.'  + ' <a href=\'' + '/' + Proposal_NewID + '\'>' +proposalName+' </a>');
            ApexPages.addMessage(myMsg);
        }
    }
    //Method to validate Constraints
    public void validateConstraints() {
        if(errorMessageList != null && errorMessageList.size() > 0) {
            errorMessageList.clear();
        }
        if(warningMessageList != null && warningMessageList.size() > 0) {
            warningMessageList.clear();
        }
        Apttus_CPQApi.CPQWebService.associateConstraintRules(cartID,null);
        Apttus_CPQApi.CPQWebService.applyConstraintRules(cartID, true);
        
        Apttus_CPQApi.CPQ.ConstraintResultDO constRuleResultDO = Apttus_CPQApi.CPQWebService.getConstraintRuleResult(cartID);
        List<Apttus_CPQApi.CPQ.AppliedActionDO> appliedActionDOList = constRuleResultDO.ConstraintRuleActions;
        for(Apttus_CPQApi.CPQ.AppliedActionDO appliedActDO:appliedActionDOList) {
            if(appliedActDO.MessageType.equals(Utils_allfields.errorVar) && appliedActDO.IsPending) {
                errorMessageList.add(appliedActDO.Message);
            }
            if(appliedActDO.MessageType.equals(Utils_allfields.warningVar) && appliedActDO.IsPending) {
                warningMessageList.add(appliedActDO.Message);
            }
        }
        if(errorMessageList.size() > 0) {
            hasError = true;
            for(string errorMessage : errorMessageList) {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: ' + errorMessage);
                ApexPages.addMessage(myMsg);
            }
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Quote Link ' + ' <a href=\'' + '/' + proposal_new + '\'>' +proposalName+' </a>' );
            ApexPages.addMessage(myMsg);
        }
    }
     //Method
    public void priceCart() {
        Apttus_CPQApi.CPQ.UpdatePriceRequestDO priceReqDO = new Apttus_CPQApi.CPQ.UpdatePriceRequestDO();
        priceReqDO.cartID = cartID;
        Apttus_CPQApi.CPQ.UpdatePriceResponseDO priceRespDO = Apttus_CPQApi.CPQWebService.updatePriceForCart(priceReqDO);       
        List<Decimal> complLineNums = priceRespDO.CompletedLineNumbers;
        pricePending = priceRespDO.IsPricePending;
    }   
     //Method to finalize cart
    public void finalizeCart() {
        Apttus_CPQApi.CPQ.FinalizeCartRequestDO request = new Apttus_CPQApi.CPQ.FinalizeCartRequestDO();
        request.CartId = cartID; 
        Apttus_CPQApi.CPQ.FinalizeCartResponseDO resp = Apttus_CPQApi.CPQWebService.finalizeCart(request);
    }
     //Method to routeToQuote
    public PageReference routeToQuote() {
        PageReference pageRef = new PageReference('/'+Proposal_NewID+'/e?cancelURL=%2F'+Proposal_NewID+'&retURL=%2F'+Proposal_NewID);
        pageRef.setRedirect(true);
        return pageRef;
    }
     //Method to clone Proposal
    public void Clone_proposal(){
         
         // until class that prepares the SOQL for all the editable fields.
         String soql = Utils_allfields.getCreatableFieldsSOQL('Apttus_Proposal__Proposal__c','id =: proposalId');
         system.debug('soql :'+soql);
         Apttus_Proposal__Proposal__c proposal_old = (Apttus_Proposal__Proposal__c)Database.query(soql);
         proposal_new = proposal_old.clone(false, true);
         if(proposal_new != null){
             if(proposal_new.RecordTypeId == Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get(Utils_allfields.quoteVar).getRecordTypeId()){
                 //change record type from Quote to Contract.
                 proposal_new.RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get(Utils_allfields.contractVar).getRecordTypeId();
                 // update the clone from field to the 
                 proposal_new.Clone_From__c = proposalId;
                 proposal_new.Apttus_Proposal__Primary__c = false;
                 proposal_new.Ownerid = UserInfo.getUserId();
                 Apttus_Proposal__Proposal__c proposal_temp = [select Apttus_Proposal__Opportunity__r.Earlybird_Payment_Reference__c, Apttus_Proposal__Opportunity__r.Type from Apttus_Proposal__Proposal__c where Id =:proposal_old.Id Limit 1];
                 updatepricelist(proposal_temp.Apttus_Proposal__Opportunity__r.Earlybird_Payment_Reference__c);
                 
                 // on contract creation if the Opportunity type is New Business then registration fee = customsetting.Default_Registration_Fee_New_Business__c
                 // on contract creation if the Opportunity type is Returning Business then registration fee = customsetting.Default_Registration_Fee_ReturnBusiness__c
                 if(proposal_temp.Apttus_Proposal__Opportunity__r.Type != null && proposal_temp.Apttus_Proposal__Opportunity__r.Type.equals(Utils_allfields.oppType2)){
                     proposal_new.Registration_Fee__c = qsvalue.Default_Registration_Fee_New_Business__c;
                 }else if(proposal_temp.Apttus_Proposal__Opportunity__r.Type != null && proposal_temp.Apttus_Proposal__Opportunity__r.Type.equals(Utils_allfields.oppType3)) {
                     proposal_new.Registration_Fee__c = qsvalue.Default_Registration_Fee_ReturnBusiness__c;
                 }else{
                    proposal_new.Registration_Fee__c = 0; // Suggested by Novasuite
                 }
                 
             }else {
                    hasError = true;
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: A Contract cannot be converted to Contract');
                    ApexPages.addMessage(myMsg);
                 
             }
             try {
                        insert proposal_new;
                        Proposal_NewID = proposal_new.Id;
                        proposalName = proposal_new.Name;
                    }
                    catch (DMLException e) {
                        hasError = true;
                        String dmlError = e.getMessage();
                        String dmlStack = e.getStackTraceString();
                        Integer dmlLineNumber = e.getLineNumber(); 
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Cannnot Create Quote. Please contact your Administrator. ' 
                            + ' ' + dmlError + ' ' + dmlStack + ' ' + dmlLineNumber);
                        ApexPages.addMessage(myMsg);            
                    }
         } else {
             hasError = true;
             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Error in creating Contract. Please contact your Admin ');
             ApexPages.addMessage(myMsg);
         }
     }
     //Check for the early bird logic and apply the price list.
     public void updatepricelist(Boolean Earlybird_Payment_Reference){
         
         system.debug('Earlybird_Payment_Reference  :'+ Earlybird_Payment_Reference);
         if(Earlybird_Payment_Reference == true){
                 // he is a Early Bird.
                 proposal_new.Early_Bird__c = true;
                 //set to 2014 price list
                 proposal_new.Apttus_QPConfig__PriceListId__c = qsvalue.Early_Bird_Price_List_Id__c;
                 proposal_new.Early_Bird_Date__c = qsvalue.Early_Bird__c;
             }else {
                 // he is not a Early Bird.
                 proposal_new.Early_Bird__c = false;
                 //set to 2015 price list
                 proposal_new.Apttus_QPConfig__PriceListId__c = qsvalue.Non_Early_Bird_Price_List_Id__c;
                 proposal_new.Early_Bird_Date__c = null;
             }
             
     }
    
}