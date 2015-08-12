public with sharing class CreateQuoteChain {

    List<Apttus_Config2__PriceList__c> pSOList = new List<Apttus_Config2__PriceList__c>();
    List <Account> accSOList = new List<Account>();
    List <Opportunity> oppSOList = new List<Opportunity>();
    ID proposalID;
    ID cartID;
    Integer numProdSelected = 0;
    List<ProductDOWrapper> selectedProductDOWrapperList = new List<ProductDOWrapper>();
    List<String> errorMessageList = new List<String>();
    List<String> warningMessageList = new List<String>();

    public Boolean pricePending{get; set;}  
    public Boolean hasError{get; set;}
    public Boolean newOppty {get;set;}
    public ID selectedPriceListID{get;set;}
    public ID selectedAccID{get;set;}
    public ID selectedOpptyID{get;set;}
    public List<ProductDOWrapper> productDOWrapperList{get;set;}
    public Boolean hasProducts {get;set;}   
    public string proposalName {get;set;}   
    //Constructor
    public CreateQuoteChain() {
        productDOWrapperList = new List<ProductDOWrapper>();        
        hasError = false;
        hasProducts = false;
        proposalName = '';
        pricePending = true;
        pSOList = [select id, 
                    name 
                    from Apttus_Config2__PriceList__c 
                    where Apttus_Config2__Active__c = true 
                    and Apttus_Config2__Type__c = 'Standard'];
                    
        accSOList = [select id, name 
                    from Account ]; 
    }
    
    public List<SelectOption> getPriceLists() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('', '---None---'));
        for(Apttus_Config2__PriceList__c pSO : pSOList) {
            options.add(new SelectOption(pSO.ID, pSO.NAME));
        }
        return options;
    }
    
    public List<SelectOption> getAccounts() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('', '---None---'));
        for(Account accSO : accSOList) {
            options.add(new SelectOption(accSO.ID, accSO.NAME));
        }
        return options;
    }
    
    public void searchOppty() {
        newOppty = false;
        if(selectedAccID == null) {
            hasError = true;
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: No Account Selected. Please select a Account.');
            ApexPages.addMessage(myMsg);
        }
        else {
            hasError = false;
            oppSOList = [select id, name 
                            from Opportunity 
                            /*where AccountID = :selectedAccID*/];
        }
    }

    public List<SelectOption> getOpptys() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('', '---None---'));
        for(Opportunity opptySO : oppSOList) {
            options.add(new SelectOption(opptySO.ID, opptySO.NAME));
        }
        return options;
    }
    
    public void searchProducts() {
    	if(productDOWrapperList.size() > 0 && productDOWrapperList != null) {
    		productDOWrapperList.clear();
    	}
        if(selectedPriceListID == null) {
            hasError = true;
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: No Price List Selected. Please select a Price List.');
            ApexPages.addMessage(myMsg);
        }
        else {
            hasError = false;
            Apttus_CPQApi.CPQ.ProductSearchResultDO prodSearchResultDO = Apttus_CPQApi.CPQWebService.getProductsForPriceList(selectedPriceListID);
            hasProducts = prodSearchResultDO.HasProducts;
            List<Apttus_CPQApi.CPQ.ProductDO> prodDOList = prodSearchResultDO.Products;
                for(Apttus_CPQApi.CPQ.ProductDO prodDOInLoop: prodDOList) {
                    productDOWrapperList.add(new ProductDOWrapper(prodDOInLoop, 1, false));
                }
        }
    }
    
    public void createQuote() {
    	hasError = false;
    	if(selectedProductDOWrapperList != null && selectedProductDOWrapperList.size() > 0) {
    		selectedProductDOWrapperList.clear();
    	}
        for(ProductDOWrapper prodDOWrap: productDOWrapperList) {
            if(prodDOWrap.isSelected) {
                numProdSelected++;
                selectedProductDOWrapperList.add(prodDOWrap);
            }
        }
        if(numProdSelected <= 0) {
			hasError = true;
	        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: No Product(s) Selected. Please select the Product(s) to be added in the Quote.');
	        ApexPages.addMessage(myMsg);            
	    }
	    else {
	        if(proposalID == null) {
		        if(selectedAccID != null && selectedOpptyID != null) {
		            Opportunity selectedOpptySO = [select name from Opportunity where id = :selectedOpptyID limit 1];
		            Apttus_Proposal__Proposal__c proposalSO = new Apttus_Proposal__Proposal__c();
		            proposalSO.Apttus_Proposal__Proposal_Name__c = selectedOpptySO.NAME;
		            proposalSO.Apttus_Proposal__Account__c = selectedAccID;
		            proposalSO.Apttus_Proposal__Opportunity__c = selectedOpptyID;
		            proposalSO.Apttus_QPConfig__PriceListId__c = selectedPriceListID;
		            proposalSO.Apttus_Proposal__Approval_Stage__c = 'Draft';
		            proposalSO.Deposit__c = 0;
		            proposalSO.Apttus_Proposal__Primary__c = false;
                    proposalSO.Degree_Type__c = 'Full-Time';
                    proposalSO.Total_Early_Bird_Securing_Fee_Payments__c = 0;
		            try {
		                insert proposalSO;
		                proposalID = proposalSO.ID;
		                Apttus_Proposal__Proposal__c propSO = [select name from Apttus_Proposal__Proposal__c where id = :proposalID limit 1];
		                proposalName = propSO.NAME;
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
		        }
		        else {
		            hasError = true;
		            if(selectedAccID == null) { 
		                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: No Account Selected. Please select a Account.');
		                ApexPages.addMessage(myMsg);
		            }
		            if(selectedOpptyID == null) {   
		                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: No Opportunity Selected. Please select a Opportunity.');
		                ApexPages.addMessage(myMsg);
		            }
		        } 
	        }
	    }
    }
    public void createCart() {
    	if(cartID == null) {
	        if(proposalID != null) {
	            hasError = false;
	            Apttus_CPQApi.CPQ.CreateCartRequestDO request = new Apttus_CPQApi.CPQ.CreateCartRequestDO();
	            request.QuoteID = proposalID;
	            Apttus_CPQApi.CPQ.CreateCartResponseDO cartRespDO = Apttus_CPQApi.CPQWebService.CreateCart(request);
	            cartID = cartRespDO.cartID;         
	        }
	        else {
	            hasError = true;
	            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Cart Creation Failed. Quote Was not Created. ' + ' <a href=\'' + '/' + proposalID + '\'>' +proposalName+' </a>');
	            ApexPages.addMessage(myMsg);
	        }
    	}
    }
    
    public void addLinesToCart() {
        if(cartID != null) {
            hasError = false;
            List<Apttus_CPQApi.CPQ.SelectedProductDO> selectedProdDOList = new List<Apttus_CPQApi.CPQ.SelectedProductDO>();
			List<Decimal> lineNumList = new List<Decimal>();
            if(selectedProdDOList != null && selectedProdDOList.size() > 0) {
            	selectedProdDOList.clear();
            }
            if(lineNumList != null && lineNumList.size() > 0) {
            	lineNumList.clear();
            }
		
			List<Apttus_Config2__LineItem__c> liSOList = [select id, 
															Apttus_Config2__LineNumber__c 
															from Apttus_Config2__LineItem__c 
															where Apttus_Config2__ConfigurationId__c = :cartID];
			if(liSOList != null && liSOList.size() > 0) {
				for(Apttus_Config2__LineItem__c liSO : liSOList) {
					lineNumList.add(liSO.Apttus_Config2__LineNumber__c);
				}
				Apttus_CPQApi.CPQ.RemoveMultiBundlesRequestDO request = new Apttus_CPQApi.CPQ.RemoveMultiBundlesRequestDO();
				request.CartId = cartID;
				request.LineNumbers = lineNumList;
				Apttus_CPQApi.CPQ.RemoveMultiBundlesResponseDO response = Apttus_CPQApi.CPQWebService.removeMultiBundles(request);
				Boolean isSuccess = response.IsSuccess;
				
			}															
            for(ProductDOWrapper selProdWrap: selectedProductDOWrapperList) {
                Apttus_CPQApi.CPQ.SelectedProductDO selProdDO = new Apttus_CPQApi.CPQ.SelectedProductDO();
                selProdDO.ProductID = selProdWrap.prodDOWrapper.ProductID;
                selProdDO.Quantity = selProdWrap.quantity;
                selProdDO.SellingTerm = 12;
                selProdDO.StartDate = Date.Today();
                selProdDO.EndDate = Date.Today() + 12;
                selProdDO.Comments = 'Added by Code'; 
                selectedProdDOList.add(selProdDO);
            }
            Apttus_CPQApi.CPQ.AddMultiProductRequestDO bundleReqDO = new Apttus_CPQApi.CPQ.AddMultiProductRequestDO();
            bundleReqDO.cartID = cartID;
            bundleReqDO.SelectedProducts = selectedProdDOList;
            Apttus_CPQApi.CPQ.AddMultiProductResponseDO bundleRespDO = Apttus_CPQApi.CPQWebService.addMultiProducts(bundleReqDO);       
        }
        else {
            hasError = true;
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Adding Products to Cart Failed. Cart Was not Created.'  + ' <a href=\'' + '/' + proposalID + '\'>' +proposalName+' </a>');
            ApexPages.addMessage(myMsg);
        }
    }
    
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
            if(appliedActDO.MessageType.equals('Error') && appliedActDO.IsPending) {
                errorMessageList.add(appliedActDO.Message);
            }
            if(appliedActDO.MessageType.equals('Warning') && appliedActDO.IsPending) {
                warningMessageList.add(appliedActDO.Message);
            }
        }
        if(errorMessageList.size() > 0) {
            hasError = true;
            for(string errorMessage : errorMessageList) {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: ' + errorMessage);
                ApexPages.addMessage(myMsg);
            }
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Quote Link ' + ' <a href=\'' + '/' + proposalID + '\'>' +proposalName+' </a>' );
            ApexPages.addMessage(myMsg);
        }
    }
    
    public void priceCart() {
        Apttus_CPQApi.CPQ.UpdatePriceRequestDO priceReqDO = new Apttus_CPQApi.CPQ.UpdatePriceRequestDO();
        priceReqDO.cartID = cartID;
        Apttus_CPQApi.CPQ.UpdatePriceResponseDO priceRespDO = Apttus_CPQApi.CPQWebService.updatePriceForCart(priceReqDO);       
        List<Decimal> complLineNums = priceRespDO.CompletedLineNumbers;
        pricePending = priceRespDO.IsPricePending;
    }   
    
    public void finalizeCart() {
        Apttus_CPQApi.CPQ.FinalizeCartRequestDO request = new Apttus_CPQApi.CPQ.FinalizeCartRequestDO();
        request.CartId = cartID; 
        Apttus_CPQApi.CPQ.FinalizeCartResponseDO resp = Apttus_CPQApi.CPQWebService.finalizeCart(request);
    }
    
    public PageReference routeToQuote() {
        PageReference pageRef = new PageReference('/'+proposalID);
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    public with sharing class ProductDOWrapper {
        public Decimal quantity {get;set;}
        public Apttus_CPQApi.CPQ.ProductDO prodDOWrapper {get;set;}
        public boolean isSelected {get;set;}
        
        public ProductDOWrapper(Apttus_CPQApi.CPQ.ProductDO prodDOInput, Decimal quantityInput, boolean isSelectedInput) {
            prodDOWrapper = prodDOInput;
            quantity = quantityInput;
            isSelected = isSelectedInput;
        }
    }
    
}