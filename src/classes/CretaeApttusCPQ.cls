//****  this class will contain all the Apttus web service calls    ****/

public class CretaeApttusCPQ {
    
    //******* create a CART on Given Proposal  **************/
    public ID CreateApttusCart(Id ProposalID){
        
         Apttus_CPQApi.CPQ.CreateCartRequestDO request = new Apttus_CPQApi.CPQ.CreateCartRequestDO();
         request.QuoteID = ProposalID;
         Apttus_CPQApi.CPQ.CreateCartResponseDO cartRespDO = Apttus_CPQApi.CPQWebService.CreateCart(request);
         ID cartID = cartRespDO.cartID;
         
         return cartID;
    }
    
    
     /******* create a CART on Given Proposal  **************/
    public void CreateBundle(WrapperProductController productbundle, Id cartID){
        
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
                            CustomFields.add('Discount_Reference__c');
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
            if(Bresponse != null){
        			system.debug('resp'+Bresponse);
        		}
        		else{
        			system.debug('Response is null');
        		}
    }
    
    //********* Run the constRules and Reprice the cart**************/
    
    public void RepriceProposal(Id CartID){
               /****** run ConstraintRules  ****/
        Integer numErrors = 0;
        Integer numWarnings = 0;
        List<string> errorMsgs = new List<string>();
        List<string> warningMsgs = new List<string>();
        List<Integer> primaryLines = new List<Integer>();
        Apttus_CPQApi.CPQWebService.associateConstraintRules(cartID,primaryLines);
        Apttus_CPQApi.CPQWebService.applyConstraintRules(cartID, true);
        		
        Apttus_CPQApi.CPQ.ConstraintResultDO constRuleResultDO = Apttus_CPQApi.CPQWebService.getConstraintRuleResult(cartID);
        List<Apttus_CPQApi.CPQ.AppliedActionDO> appliedActionDOList = constRuleResultDO.ConstraintRuleActions;
        for(Apttus_CPQApi.CPQ.AppliedActionDO appliedActDO:appliedActionDOList) {
        	if(appliedActDO.MessageType.equals(Utils_allfields.errorVar) && appliedActDO.IsPending) {
        		numErrors++;
        		errorMsgs.add(appliedActDO.Message);
        	}
        	else if(appliedActDO.MessageType.equals(Utils_allfields.warningVar) && appliedActDO.IsPending) {
        		numWarnings++;
        		warningMsgs.add(appliedActDO.Message);
        	}
        	else{
        		numWarnings++;
        		warningMsgs.add(appliedActDO.Message);
        	}
        }
        /*************  END of ConstraintRules   *************/
        if(numErrors < = 0 ) {
        	/*
        		Repeat this in a javascript till IsPricePending is false. 
        		This will Price the Cart Lines and will set the IsPricePendingFlag to TRUE if more lines have to be priced
        		IsPricePending will be FALSE when all the Lines in the Cart are Finalized.
        	*/
        	Apttus_CPQApi.CPQ.UpdatePriceRequestDO priceReqDO = new Apttus_CPQApi.CPQ.UpdatePriceRequestDO();
        	priceReqDO.cartID = cartID;
        	Apttus_CPQApi.CPQ.UpdatePriceResponseDO priceRespDO = Apttus_CPQApi.CPQWebService.updatePriceForCart(priceReqDO);		
        	List<Decimal> complLineNums = priceRespDO.CompletedLineNumbers;
        	Boolean IsPricePending = priceRespDO.IsPricePending;
        	List<Decimal> PendingLineNumbers = priceRespDO.PendingLineNumbers;
        	
        	system.debug(' IsPricePending :'+ IsPricePending);
        }
        
    }
    
        /********  finalizeCart  *************/
        public void Finalizeproposal(ID cartID){
        		/*
        			Finalize the Cart
        		*/
        		system.debug('in FinalizeCart');
        		Apttus_CPQApi.CPQ.FinalizeCartRequestDO request = new Apttus_CPQApi.CPQ.FinalizeCartRequestDO();
        		request.CartId = cartID; 
        		Apttus_CPQApi.CPQ.FinalizeCartResponseDO resp = Apttus_CPQApi.CPQWebService.finalizeCart(request);
        		if(resp != null){
        			system.debug('resp'+resp);
        		}
        		else{
        			system.debug('Response is null');
        		}
        }
        //Method for AddMultiProduct
        public void AddMultiProduct(List<Product2> List_product_rollover,ID cartID){
            
            // method to add products to cart. if the method is a Bundle then it adds the Bundle with default options on it. 
            
            List <Apttus_CPQApi.CPQ.SelectedProductDO> selectedProdDOList = new List <Apttus_CPQApi.CPQ.SelectedProductDO>();
            for(Product2 eachproduct :List_product_rollover){
                Apttus_CPQApi.CPQ.SelectedProductDO selProdDO = new Apttus_CPQApi.CPQ.SelectedProductDO();
                selProdDO.ProductID = eachproduct.Id;
            	selProdDO.Quantity = 1;
            	//selProdDO.SellingTerm = 12;
            	//selProdDO.StartDate = Date.Today();
            	//selProdDO.EndDate = Date.Today() + 12;
            	selProdDO.Comments = 'Added by Opportunitie Rollover code';
            	//This is the way to add custom fields created on the line item object
            	
            	/*List<String> customFields = new List<String>();
            	 customFields.add('Apttus_Config2__LocationID__c');
            	 selProdDO.CustomFields = customFields;
            	
            	 Apttus_Config2__LineItem__c liSO = new Apttus_Config2__LineItem__c();
            	 liSO.Apttus_Config2__LocationID__c = 'xxxxxxx';
            	 selProdDO.CustomData = liSO;*/
            	 selectedProdDOList.add(selProdDO);
            }
            
        	 if(!selectedProdDOList.isEmpty() && selectedProdDOList != null){
        	     Apttus_CPQApi.CPQ.AddMultiProductRequestDO bundleReqDO = new Apttus_CPQApi.CPQ.AddMultiProductRequestDO();
                 bundleReqDO.cartID = cartID;
                 bundleReqDO.SelectedProducts = selectedProdDOList;
                 Apttus_CPQApi.CPQ.AddMultiProductResponseDO bundleRespDO = Apttus_CPQApi.CPQWebService.addMultiProducts(bundleReqDO);
        	 }
        	 
        	 
        }
        

}