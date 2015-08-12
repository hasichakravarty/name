public with sharing class Create_Amendment_Chain {

    ID proposalID;
    ID Proposal_NewID;
    ID cartID;
    ID Oid;
    List<String> errorMessageList = new List<String>();
    List<String> warningMessageList = new List<String>();
    public Map<Decimal,WrapperProductController> productwrapper = new Map<Decimal,WrapperProductController>();
    public Apttus_Proposal__Proposal__c proposal_new;
    public Boolean pricePending{get; set;}  
    public Boolean hasError{get; set;}
    public string proposalName {get;set;}   
    public Quote_Settings__c qsvalue = Quote_Settings__c.getValues('System Properties');
    public Opportunity Oppty_new;
    public Opportunity Oppty_old;
    public List<OpportunityContactRole> Opptycontact_new;
    public List<OpportunityTeamMember> OpptyTeamMember_new;
    public List<OpportunityContactRole> Opptycontact_old;
    //Constructor
    public Create_Amendment_Chain (){
        Oid = ApexPages.currentPage().getParameters().get('oid');
        //proposalID =  ApexPages.currentPage().getParameters().get('id');
        System.debug('Opportunity  :'+Oid);
        hasError = false;
        proposalName = '';
        pricePending = true;
        
        if(Oid == null) {  
                        hasError = true;
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: No Opportunity Id selected');
                        ApexPages.addMessage(myMsg);
        }else{
            Id Quoterecordtype = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Contract').getRecordTypeId();
            for(List<Apttus_Proposal__Proposal__c> eachproposal : [select Id, Apttus_Proposal__Opportunity__c, Apttus_Proposal__Primary__c, RecordTypeId 
                                                                     from Apttus_Proposal__Proposal__c
                                                                     where Apttus_Proposal__Opportunity__c =:Oid and 
                                                                     Apttus_Proposal__Primary__c = true and 
                                                                     RecordTypeId =: Quoterecordtype limit 1]){
                for (Apttus_Proposal__Proposal__c pro : eachproposal){
                    proposalID = pro.Id;
                }
            } 
             
            if(proposalID == null){
                        hasError = true;
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Opportunity Dosenot has a primary contarct');
                        ApexPages.addMessage(myMsg);
            }
        
        }
        
     }
    
    public void cloneOppty(){
        String soql = Utils_allfields.getCreatableFieldsSOQL('Opportunity','id =: Oid');
         Oppty_old = (Opportunity)Database.query(soql);
         Oppty_new = Oppty_old.clone(false, true);
         Oppty_new.Related_Opportunity__c = Oppty_old.Id;

         //The External_Opportunity_Number__c is used in integration as an order reference number that is
         //carried over all amend opportunities. The original value is the Id of the firs enrolment opportunity
         if(Oppty_new.External_Opportunity_Number__c == null || Oppty_new.External_Opportunity_Number__c =='')
         {
            Oppty_new.External_Opportunity_Number__c = Oppty_old.Id;
         }
         // External_ID__c copy for integration mapping
         Oppty_new.External_ID__c = Oppty_old.External_ID__c;
        
         Oppty_new.Level__c = Oppty_new.Level__c == null? 1:Oppty_new.Level__c + 1;
         Oppty_new.Name =  Oppty_new.Name;
         Oppty_new.Type = 'Amendment';
         Oppty_new.StageName = 'Needs Analysis';
         Oppty_new.Probability = 20;
         Oppty_new.Enrolment_Status__c = null;
         Oppty_new.Earlybird_Payment_Reference__c = false;
         Oppty_new.Void__c = false;
         Oppty_new.CloseDate = system.Date.today().addMonths(1);
         //Oppty_new.CloseDate = null; // Added to remove defect 410
         Oppty_new.Academic_Vetting_Status__c = 'Pre-Vetted';
         Oppty_new.Academic_Vetting_Escalated__c = false;
         Oppty_new.Academic_Vetting_Escalation_Status__c = null;
         Oppty_new.Reviewer__c = null;
         //Quote_Settings__c qsvalue = Quote_Settings__c.getValues('System Properties');
        // Oppty_new.Academic_Start_Date__c = qsvalue.Academic_Start_Date__c;
         Oppty_new.Enrolment_Contract__c = Oppty_old.Enrolment_Contract__c;
         Oppty_new.Void__c = false;
         Oppty_new.Ownerid = UserInfo.getUserId();
         
         try{
             // change the old oppty to void.
             Oppty_old.Void__c = true;
            insert Oppty_new;
            update Oppty_old;
            Opptycontact_old = [SELECT ContactId, Id, IsPrimary, OpportunityId, Role FROM OpportunityContactRole WHERE OpportunityId =: Oid];
         }catch(Exception ex){
             system.debug('Exception Message---'+ ex.getMessage());
             hasError = true;
             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: OpportunityCreation Failed.');
             ApexPages.addMessage(myMsg);
         }
    }
    // Commented Method to remove duplicates because Contact roles are also getting created from PS_opportunity_MapAccountcontactRole class after insert of Opportunity which is getting called from PS_Opportunitytrigger.
  /*  public void Create_ContactRoles(){
         Opptycontact_new = new List<OpportunityContactRole>();
         List<OpportunityContactRole> Opptycontact_old = [SELECT ContactId, Id, IsPrimary, OpportunityId, Role FROM OpportunityContactRole WHERE OpportunityId =: Oid];
         if(Opptycontact_old != null && !Opptycontact_old.isEmpty()){
             Opptycontact_new = new List<OpportunityContactRole>();
             for(OpportunityContactRole eachOpportunityContactRole : Opptycontact_old){
                 
                 OpportunityContactRole tempopptycontractRole = new OpportunityContactRole();
                 tempopptycontractRole.ContactId = eachOpportunityContactRole.ContactId;
                 tempopptycontractRole.IsPrimary = eachOpportunityContactRole.IsPrimary;
                 tempopptycontractRole.OpportunityId = Oppty_new.id;
                 tempopptycontractRole.Role = eachOpportunityContactRole.Role;
                 Opptycontact_new.add(tempopptycontractRole);
                 
             }
        }
         if(!Opptycontact_new.isEmpty() && Opptycontact_new != null){
             try{
                insert Opptycontact_new;
             }catch(Exception ex){
                 system.debug('Exception Message---'+ ex.getMessage());
                 hasError = true;
                 ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: OpportunityContactRole Creation Failed. Quote Was not Created. ' + ' <a href=\'' + '/' + Proposal_NewID + '\'>' +proposalName+' </a>');
                 ApexPages.addMessage(myMsg);
         }
         }
     }
     */
     public void Create_OpportunityTeam(){
         OpptyTeamMember_new = new List<OpportunityTeamMember>();
         List<OpportunityTeamMember> OpptyTeamMember_old = [SELECT CurrencyIsoCode, DM_Identifier__c, Id, Job_Function__c, OpportunityAccessLevel, OpportunityId, TeamMemberRole,Team_Member_s_Manager__c, UserId 
                                                            FROM OpportunityTeamMember where OpportunityId =: OId];
                                                            
         system.debug('OpptyTeamMember_old  :'+OpptyTeamMember_old);
         if(!OpptyTeamMember_old.isEmpty() && OpptyTeamMember_old != null){
             OpptyTeamMember_new = new List<OpportunityTeamMember>();
             for(OpportunityTeamMember eachOpportunityTeamMember : OpptyTeamMember_old){
                 
                 OpportunityTeamMember tempopptyTeamMember = new OpportunityTeamMember();
                  tempopptyTeamMember.CurrencyIsoCode= eachOpportunityTeamMember.CurrencyIsoCode;
                  tempopptyTeamMember.DM_Identifier__c= eachOpportunityTeamMember.DM_Identifier__c;
                  tempopptyTeamMember.OpportunityId = Oppty_new.id;
                  tempopptyTeamMember.TeamMemberRole = eachOpportunityTeamMember.TeamMemberRole;
                  tempopptyTeamMember.Team_Member_s_Manager__c = eachOpportunityTeamMember.Team_Member_s_Manager__c;
                  tempopptyTeamMember.UserId = eachOpportunityTeamMember.UserId;
                  OpptyTeamMember_new.add(tempopptyTeamMember);

                 
             }
        }
         if(!OpptyTeamMember_new.isEmpty() && OpptyTeamMember_new != null){
             try{
                insert OpptyTeamMember_new;
             }catch(Exception ex){
                system.debug('Exception Message---'+ ex.getMessage());
         }
         }
         
     }
     
     public void Create_Quote(){
         
         proposal_new = new Apttus_Proposal__Proposal__c();
         proposal_new.Apttus_Proposal__Opportunity__c = Oppty_new.Id;
         proposal_new.Apttus_Proposal__Proposal_Name__c = Oppty_new.Name;
         proposal_new.Apttus_Proposal__Account__c = Oppty_new.AccountId;
         proposal_new.Apttus_QPConfig__PriceListId__c = calcuate_priceList();
         proposal_new.Early_Bird__c = calcuate_EarlyBird();
         proposal_new.Early_Bird_Date__c = calcuate_EarlyBirddate();
         proposal_new.Apttus_Proposal__Approval_Stage__c = 'Draft';
         proposal_new.Deposit__c = 0;
         proposal_new.First_Payment_Date__c = Oppty_new.Academic_Start_Date__c;
         proposal_new.Apttus_Proposal__Primary__c = false;
         proposal_new.recordtypeid =Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Quote').getRecordTypeId();
         proposal_new.Degree_Type__c = 'Full-Time';
         //proposal_new.Total_Early_Bird_Securing_Fee_Payments__c = 0;
         proposal_new.Payment_Method__c = 'Direct Deposit';
         if(Oppty_new.International_Sponsor__c.equals('Yes')){
              proposal_new.Payment_Type__c = '50% Deposit';
         }else {
             proposal_new.Payment_Type__c = 'Monthly Payment';
         }
         // on Quote creation if the Opportunity type is New Business then early Bird fee  = customsetting.Earlybird Securing Fee New Business
         // on Quote creation if the Opportunity type is returning business then early Bird fee  = customsetting.Earlybird Securing Fee Return Business
         if(Oppty_old.Type.equals('New Business') && proposal_new.Apttus_QPConfig__PriceListId__c.equals(qsvalue.Early_Bird_Price_List_Id__c)){
             proposal_new.Total_Early_Bird_Securing_Fee_Payments__c =  qsvalue.Earlybird_Securing_Fee_New_Business__c;
         } else if(Oppty_old.Type.equals('Returning Business') && proposal_new.Apttus_QPConfig__PriceListId__c.equals(qsvalue.Early_Bird_Price_List_Id__c)){
             proposal_new.Total_Early_Bird_Securing_Fee_Payments__c =  qsvalue.Earlybird_Securing_Fee_Return_Business__c;
         } else {
             proposal_new.Total_Early_Bird_Securing_Fee_Payments__c = 0;
         }
         //set contacts
         if(!Opptycontact_old.isEmpty()){
             for(OpportunityContactRole eachOpportunityContactRole : Opptycontact_old){
                    if(eachOpportunityContactRole.Role.equals('Business User')){
                        proposal_new.Apttus_Proposal__Primary_Contact__c =  eachOpportunityContactRole.ContactId;
                    }
                    if(eachOpportunityContactRole.Role.equals('Primary Sales Contact')){
                        proposal_new.Sponsor__c = eachOpportunityContactRole.ContactId;
                    }
             }
         }
         try{
         
            insert proposal_new;
            Proposal_NewID = proposal_new.Id;
            proposalName = proposal_new.Apttus_Proposal__Proposal_Name__c;
         }catch(Exception ex){
                system.debug('Exception Message---'+ ex.getMessage());
                hasError = true;
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Quote Was not Created. ' + ' <a href=\'' + '/' + Proposal_NewID + '\'>' +proposalName+' </a>');
                ApexPages.addMessage(myMsg);
                
         }
     }
     
     public Id calcuate_priceList(){
         
         if(qsvalue.Early_Bird__c > = system.Date.today()){
            return qsvalue.Early_Bird_Price_List_Id__c;
         }
         else{ 
            return qsvalue.Non_Early_Bird_Price_List_Id__c;
         }
     }
     
     public Boolean calcuate_EarlyBird(){
         if(qsvalue.Early_Bird__c > = system.Date.today()){
            return true;
         }
         else{ 
            return false;
         }
     }
     
     public Date calcuate_EarlyBirddate(){
         if(qsvalue.Early_Bird__c > = system.Date.today()){
            return qsvalue.Early_Bird__c;
         }
         else{ 
            return null;
         }
     }
     
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
   
    
    public void addLinesToCart() {
        if(proposalId != null){
            hasError = false;
            /*List<Apttus_Config2__LineItem__c> prodSOList = [select Id,
                                                                   Apttus_Config2__ProductId__c, 
                                                                   Discount_Reference__c, 
                                                                   Apttus_Config2__LineType__c, 
                                                                   Apttus_Config2__LineNumber__c, 
                                                                   Apttus_Config2__Quantity__c 
                                                                   from Apttus_Config2__LineItem__c 
                                                                   where Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c =: proposalId and
                                                                   Apttus_Config2__ConfigurationId__r.Apttus_Config2__Status__c = 'Finalized'and 
                                                                   Apttus_Config2__LineType__c = 'Product/Service'];*/
             List<OpportunityLineItem> prodSOList = [select Id,
                                                            OpportunityId,
                                                            Product2Id,
                                                            Discount_Reference__c,
                                                            LineType__c,
                                                            LineNumber__c,
                                                            Quantity
                                                            from OpportunityLineItem where OpportunityId =:Oid and LineType__c = 'Product/Service'];
             system.debug('prodSOList Size'+prodSOList.size());
             if(prodSOList.size() >0){
                 hasError = false;
                 for(OpportunityLineItem lineitem : prodSOList){
                      WrapperProductController tempproduct = new WrapperProductController();
                      tempproduct.ProductId = lineitem.Product2Id;
                      tempproduct.Discount_Reference = lineitem.Discount_Reference__c;
                      tempproduct.LineType = lineitem.LineType__c;
                      tempproduct.LineNumber = lineitem.LineNumber__c;
                      tempproduct.Quantity = lineitem.Quantity;
                      productwrapper.put(lineitem.LineNumber__c,tempproduct);
                 }
                /* List<Apttus_Config2__LineItem__c> prodOptionList = [select Id, 
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
                                                                            Apttus_Config2__LineType__c != 'Product/Service'];*/
                 List<OpportunityLineItem> prodOptionList = [select Id, 
                                                                    Product2Id, 
                                                                    Discount_Reference__c, 
                                                                    LineType__c, 
                                                                    LineNumber__c, 
                                                                    OptionId__c, 
                                                                    ProductOptionId__c, 
                                                                    Quantity
                                                                    from OpportunityLineItem where OpportunityId =:Oid and LineType__c != 'Product/Service'];
                                                                            
                                                                            
                for(OpportunityLineItem lineitem : prodOptionList){
                     WrapperProductController tempproduct = new WrapperProductController();
                     WrapperProductController.WrapperProductOption tempproductoption = new WrapperProductController.WrapperProductOption();
                     if(productwrapper.get(lineitem.LineNumber__c) != null){
                         tempproduct = productwrapper.get(lineitem.LineNumber__c);
                         if(tempproduct.productoptions != null){
                             tempproductoption.RecordId = lineitem.Id;
                             tempproductoption.ProductId = lineitem.OptionId__c;
                             tempproductoption.ProductOptionId = lineitem.ProductOptionId__c;
                             tempproductoption.LineType = lineitem.LineType__c;
                             tempproductoption.LineNumber = lineitem.LineNumber__c;
                             tempproductoption.Quantity = lineitem.Quantity;
                             tempproductoption.Discount_Reference = lineitem.Discount_Reference__c;
                             tempproduct.productoptions.add(tempproductoption);
                         }else{
                              List<WrapperProductController.WrapperProductOption> templistproductoption = new List<WrapperProductController.WrapperProductOption>();
                              tempproductoption.RecordId = lineitem.Id;
                              tempproductoption.ProductId = lineitem.OptionId__c;
                              tempproductoption.ProductOptionId = lineitem.ProductOptionId__c;
                              tempproductoption.LineType = lineitem.LineType__c;
                              tempproductoption.LineNumber = lineitem.LineNumber__c;
                              tempproductoption.Quantity = lineitem.Quantity;
                              tempproductoption.Discount_Reference = lineitem.Discount_Reference__c;
                              templistproductoption.add(tempproductoption);
                              tempproduct.productoptions = templistproductoption;
                              //tempproduct.productoptions 
                         }
                         
                         productwrapper.put(lineitem.LineNumber__c,tempproduct);
                     }else{
                         //option without a bundle ?
                         system.debug(' option without a Bundle ');
                     }
                 }
                 system.debug('productwrapper with options :'+ productwrapper);
                 
                 for(Decimal eachbundle : productwrapper.keySet()){
                     // create line items and reprice 
                     CreateBundle(productwrapper.get(eachbundle), cartID);
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
        }else{
             hasError = true;
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Adding Products to Cart Failed. Cart Was not Created.'  + ' <a href=\'' + '/' + Proposal_NewID + '\'>' +proposalName+' </a>');
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
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Quote Link ' + ' <a href=\'' + '/' + proposal_new + '\'>' +proposalName+' </a>' );
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
        PageReference pageRef = new PageReference('/'+Proposal_NewID+'/e?cancelURL=%2F'+Proposal_NewID+'&retURL=%2F'+Proposal_NewID);
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    public void Clone_proposal(){
         
         // until class that prepares the SOQL for all the editable fields.
         if(proposalId != null){
             String soql = Utils_allfields.getCreatableFieldsSOQL('Apttus_Proposal__Proposal__c','id =: proposalId');
         system.debug('soql :'+soql);
         Apttus_Proposal__Proposal__c proposal_old = (Apttus_Proposal__Proposal__c)Database.query(soql);
         proposal_new = proposal_old.clone(false, true);
         if(proposal_new != null){
         
                 //change record type to Contract.
                 proposal_new.RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Quote').getRecordTypeId();
                 proposal_new.Apttus_Proposal__Opportunity__c = Oppty_new.Id;
                 proposal_new.Apttus_Proposal__Proposal_Name__c = Oppty_new.Name;
                 proposal_new.Apttus_Proposal__Account__c = Oppty_new.AccountId;
                 proposal_new.Apttus_Proposal__Approval_Stage__c = 'Draft';
                 // update the clone from field to the 
                 proposal_new.Clone_From__c = proposalId;
                 proposal_new.Apttus_Proposal__Primary__c = false;
                 proposal_new.Ownerid = UserInfo.getUserId();
                 
                 //Apttus_Proposal__Proposal__c proposal_temp = [select Apttus_Proposal__Opportunity__r.Earlybird_Payment_Reference__c, Apttus_Proposal__Opportunity__r.Type from Apttus_Proposal__Proposal__c where Id =:proposal_old.Id Limit 1];
                 //updatepricelist(proposal_temp.Apttus_Proposal__Opportunity__r.Earlybird_Payment_Reference__c);
                 // on Quote creation if the Opportunity type is New Business then early Bird fee  = customsetting.Earlybird Securing Fee New Business
                 // on Quote creation if the Opportunity type is returning business then early Bird fee  = customsetting.Earlybird Securing Fee Return Business
                 if(Oppty_old.Type.equals('New Business') && proposal_new.Apttus_QPConfig__PriceListId__c.equals(qsvalue.Early_Bird_Price_List_Id__c)){
                     proposal_new.Total_Early_Bird_Securing_Fee_Payments__c =  qsvalue.Earlybird_Securing_Fee_New_Business__c;
                 } else if(Oppty_old.Type.equals('Returning Business') && proposal_new.Apttus_QPConfig__PriceListId__c.equals(qsvalue.Early_Bird_Price_List_Id__c)){
                     proposal_new.Total_Early_Bird_Securing_Fee_Payments__c =  qsvalue.Earlybird_Securing_Fee_Return_Business__c;
                 } else {
                     proposal_new.Total_Early_Bird_Securing_Fee_Payments__c = 0;
                 }
                 //set contacts
                 if(Opptycontact_old != null && !Opptycontact_old.isEmpty()){
                     for(OpportunityContactRole eachOpportunityContactRole : Opptycontact_old){
                            if(eachOpportunityContactRole.Role != null && eachOpportunityContactRole.Role.equals('Business User')){
                                proposal_new.Apttus_Proposal__Primary_Contact__c =  eachOpportunityContactRole.ContactId;
                            }
                            if(eachOpportunityContactRole.Role != null && eachOpportunityContactRole.Role.equals('Primary Sales Contact')){
                                proposal_new.Sponsor__c = eachOpportunityContactRole.ContactId;
                            }
                     }
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
         } else {
             hasError = true;
             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Error No Contract related to Oppty ');
             ApexPages.addMessage(myMsg);
         }
         
     }
     
     public void updatepricelist(Boolean Earlybird_Payment_Reference){
         
         system.debug('Earlybird_Payment_Reference  :'+ Earlybird_Payment_Reference);
         if(Earlybird_Payment_Reference == true){
                 // he is a Early Bird.
                 proposal_new.Early_Bird__c = true;
                 //set to 2014 price list
                 proposal_new.Apttus_QPConfig__PriceListId__c = qsvalue.Early_Bird_Price_List_Id__c;
                 
             }else {
                 // he is not a Early Bird.
                 proposal_new.Early_Bird__c = false;
                 //set to 2015 price list
                 proposal_new.Apttus_QPConfig__PriceListId__c = qsvalue.Non_Early_Bird_Price_List_Id__c;
             }
             
     }
    
}