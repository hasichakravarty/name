/* ----------------------------------------------------------------------------------------------------------------------------------------------------------
   Name:            Rollover 
   Description:     This class provide the ability to create a Returning Opportunity from an Opportunity record to assist the User journey as per RD-00182.. 
   Date             Version         Author                             Summary of Changes 
   -----------      ----------      -----------------    ---------------------------------------------------------------------------------------------------
  03/2015         1.0            Accenture IDC                       Initial Release 
------------------------------------------------------------------------------------------------------------------------------------------------------------ */
//This class provide the ability to create a Returning Opportunity from an Opportunity record to assist the User journey as per RD-00182..
public class Rollover {

    public Id opportunityId;
    public Opportunity Oppty_new;
    public Opportunity Oppty_old;
    public List<OpportunityContactRole> Opptycontact_old;
    public List<OpportunityTeamMember> OpptyTeamMember_new;
    public Apttus_Proposal__Proposal__c proposal_new;
    public CretaeApttusCPQ cpq = new CretaeApttusCPQ();
    public Id cartID;
    public Date earlybirddate;
    public String Earlybird_Payment_Reference;
    public Quote_Settings__c qsvalue = Quote_Settings__c.getValues(Utils_allfields.customSettingName);
    public Boolean pricePending{get; set;}  
    public Boolean hasError{get; set;}
    public string proposalName {get;set;} 
    //static Decimal Level;
    public Rollover(){
        opportunityId =  ApexPages.currentPage().getParameters().get('id');
        System.debug('opportunityId   :'+opportunityId );
        hasError = false;
        proposalName = '';
        pricePending = true;
        
        if(opportunityId  == null) {  
                        hasError = true;
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: No opportunityId Id selected');
                        ApexPages.addMessage(myMsg);
        }
       Opptycontact_old = new List<OpportunityContactRole>();
        OpptyTeamMember_new = new List<OpportunityTeamMember>();
    }
    

     //method called on onLoad of Page
     public PageReference routeToQuote(){
         //String soql = Utils_allfields.getCreatableFieldsSOQL('Opportunity','id =: opportunityId');
        // Opportunity Op = (Opportunity)Database.query(soql);
         //system.debug('Op------..'+Op);
         /*if(Op.Qualification__c == null || Op.Level__c == null || Op.Conferer__c == null || Op.Campus__c == null){
             Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,''+'There is no Product synced to this Opportunity'));
         }*/
         //createOppty();
         //Create_ContactRoles();
         //Create_OpportunityTeam();
         //Create_Quote();
         //cretaeApttusobjects();
                   
         if(proposal_new != null && proposal_new.id != null){
             PageReference pg = new PageReference('/'+proposal_new.id+'/e?cancelURL=%2F'+proposal_new.id+'&retURL=%2F'+proposal_new.id);
             pg.setRedirect(true);
             system.debug('this is for testing'+'/'+proposal_new.id+'/e?cancelURL=%2F'+proposal_new.id+'&retURL=%2F'+proposal_new.id);
             return pg;
         }else if(Oppty_new != null && Oppty_new.id != null){
                 PageReference pg = new PageReference('/'+Oppty_new.id);                 
                 pg.setRedirect(true);
                 return pg;
         }
         else{
                 PageReference pg = new PageReference('/'+opportunityId);                 
                 pg.setRedirect(true);
                 return pg;
         }
         //return null;
     }
     
     //Method for creating oppty
     public void createOppty(){
         String soql = 'SELECT '+ Utils_allfields.getCreatableFieldsList('Opportunity') + ', account.name'+' FROM Opportunity WHERE id =: opportunityId';
         Oppty_old = (Opportunity)Database.query(soql);
         if(Oppty_old.Qualification__c == null || Oppty_old.Level__c == null || Oppty_old.Conferer__c == null || Oppty_old.Campus__c == null){
             hasError = true;
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'There is no Product synced to this Opportunity');
            ApexPages.addMessage(myMsg);
            return;
         }
         Oppty_new = Oppty_old.clone(false, true);
         Oppty_new.Related_Opportunity__c = Oppty_old.Id;
         Oppty_new.Level__c = Oppty_new.Level__c == null? 1:Oppty_new.Level__c + 1;
         //Oppty_new.Name = Oppty_new.Name+' '+ String.valueOf(Oppty_new.Level__c);
         Oppty_new.Name = GetOpptyname();
         Oppty_new.Type = Utils_allfields.opType1;
         Oppty_new.StageName =Utils_allfields.opStage1;
         Oppty_new.Enrolment_Status__c = null;
         Oppty_new.Earlybird_Payment_Reference__c = false;
         Oppty_new.Void__c = false;
         Oppty_new.CloseDate = system.Date.today().addMonths(1);
         Oppty_new.StageName = Utils_allfields.opStage2;
         Oppty_new.Probability = 20;
         Oppty_new.Academic_Vetting_Status__c = Utils_allfields.opAcademic1;
         Oppty_new.Academic_Vetting_Escalated__c = false;
         Oppty_new.Academic_Vetting_Escalation_Status__c = null;
         Oppty_new.Reviewer__c = null;
         Oppty_new.Enrolment_Contract__c = Oppty_old.Enrolment_Contract__c;
         Oppty_new.Ownerid = UserInfo.getUserId();
         //Davi Borges 05062015 added to remove the flag when the original opportunity is from lead conversion
         Oppty_new.isConvertedFromLead__c=false;
         
         try{
            insert Oppty_new;
            system.debug('$$Oppty_new'+Oppty_new);
         }
         catch(Exception ex){
             system.debug('Exception Message---'+ ex.getMessage());
             throw ex;
         }
     }
     
 public String GetOpptyname(){
         system.debug('in oppty name ');
         String Opptyname;
         String Level_Name;
         if(Oppty_old != null)
         {
             Decimal  Level = Oppty_old.Level__c == null? 1:Oppty_old.Level__c +1;
             system.debug('$$level'+Level);
             Level_Name = 'L'+String.valueOf(Level);
             system.debug('Oppty_old.Name  :'+Oppty_old.Name);
             system.debug('Oppty_old.Qualification__c  :'+Oppty_old.Qualification__c);
             system.debug('Level_Name  :'+Level_Name);
             //if(Oppty_old.Name.contains(Oppty_old.Qualification__c) && Oppty_old.Name.contains(Level_Name)){
                 
                 Opptyname = Oppty_old.Account.Name;
                 //Opptyname.remove(Oppty_old.Qualification__c);
                 Opptyname = Opptyname.remove(Level_Name);
                 System.debug('Opptyname without level'+Opptyname);
                 //Level = Level + 1;
                 if((Oppty_old.Account.Name.length() + Oppty_old.Qualification__c.length()) >116){
                      Opptyname = Oppty_old.Account.name.left(58) +' '+Oppty_old.Qualification__c.left(58)+' L'+String.valueOf(Level);
                      system.debug(Opptyname);
                 }
                 else{
                     Opptyname = Oppty_old.account.Name +' '+Oppty_old.Qualification__c+' L'+String.valueOf(Level);
                     system.debug(Opptyname);
                 }
                 //Opptyname = Oppty_old.Name +' '+ Oppty_old.Qualification__c +' L'+String.valueOf(Level);
                 system.debug('oppty Name  :'+Opptyname);
             //}else {
                 
               //  Opptyname = Oppty_old.Account.Name +' '+ Oppty_old.Qualification__c +' L'+String.valueOf(Level);
            // }
             
             return Opptyname;
             system.debug('$$opptyname'+Opptyname);
             //Opptyname = Oppty_old.Name +' '+ Oppty_old.Qualification__c +' L'+String.valueOf(Level);
         }
         
         return null;
     }
     // As per D-613 Commented Method to remove duplicates because Contact roles are also getting created from PS_opportunity_MapAccountcontactRole class after insert of Opportunity which is getting called from PS_Opportunitytrigger.
      //method to create ContactRoles
   /*  public void Create_ContactRoles(){
         if(Oppty_new != null){
            List<OpportunityContactRole> Opptycontact_old = [SELECT ContactId, Id, IsPrimary, OpportunityId, Role FROM OpportunityContactRole WHERE OpportunityId =: opportunityId];
             if(!Opptycontact_old.isEmpty()){
                 for(OpportunityContactRole eachOpportunityContactRole : Opptycontact_old){
                     
                     OpportunityContactRole tempopptycontractRole = new OpportunityContactRole();
                     tempopptycontractRole.ContactId = eachOpportunityContactRole.ContactId;
                     tempopptycontractRole.IsPrimary = eachOpportunityContactRole.IsPrimary;
                     tempopptycontractRole.OpportunityId = Oppty_new.id;
                     tempopptycontractRole.Role = eachOpportunityContactRole.Role;
                     Opptycontact_new.add(tempopptycontractRole);
                 } 
         }
         
        }else{
            hasError = true;
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: No Contact Roles Created');
            ApexPages.addMessage(myMsg);
        }
         if(!Opptycontact_new.isEmpty() && Opptycontact_new != null){
             try{
                insert Opptycontact_new;
             }catch(Exception ex){
                system.debug('Exception Message---'+ ex.getMessage());
                throw ex;
         }
         }
     }
     */
      //Method to creae Quote
     public void Create_Quote(){
         
         if(Oppty_new != null){
             proposal_new = new Apttus_Proposal__Proposal__c();
             proposal_new.Apttus_Proposal__Opportunity__c = Oppty_new.Id;
             proposal_new.Apttus_Proposal__Proposal_Name__c = Oppty_new.Name;
             proposal_new.Apttus_Proposal__Account__c = Oppty_new.AccountId;
             proposal_new.Apttus_QPConfig__PriceListId__c = calcuate_priceList();
             proposal_new.Early_Bird__c = calcuate_EarlyBird();
             proposal_new.Early_Bird_Date__c = calcuate_EarlyBirddate();
             proposal_new.Apttus_Proposal__Approval_Stage__c = Utils_allfields.propStage1;
             proposal_new.Deposit__c = 0;
             proposal_new.First_Payment_Date__c = Oppty_new.Academic_Start_Date__c;
             proposal_new.Apttus_Proposal__Primary__c = false;
             proposal_new.recordtypeid =Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Quote').getRecordTypeId();
             proposal_new.Degree_Type__c = Utils_allfields.propDegree1;
             //proposal_new.Total_Early_Bird_Securing_Fee_Payments__c = 0;
             proposal_new.Payment_Method__c = Utils_allfields.propPayMethod1;
             if(Oppty_new.International_Sponsor__c != null && Oppty_new.International_Sponsor__c.equals(Utils_allfields.y)){
                  proposal_new.Payment_Type__c = Utils_allfields.propPayType1;
             }else {
                 proposal_new.Payment_Type__c = Utils_allfields.propPayType2;
             }
             // on Quote creation if the Opportunity type is New Business then early Bird fee  = customsetting.Earlybird Securing Fee New Business
             // on Quote creation if the Opportunity type is returning business then early Bird fee  = customsetting.Earlybird Securing Fee Return Business
             if(Oppty_old.Type != null && Oppty_old.Type.equals(Utils_allfields.oppType2) && proposal_new.Apttus_QPConfig__PriceListId__c != null && proposal_new.Apttus_QPConfig__PriceListId__c.equals(qsvalue.Early_Bird_Price_List_Id__c)){
                 proposal_new.Total_Early_Bird_Securing_Fee_Payments__c =  qsvalue.Earlybird_Securing_Fee_New_Business__c;
             } else if(Oppty_old.Type != null && Oppty_old.Type.equals(Utils_allfields.oppType3) && proposal_new.Apttus_QPConfig__PriceListId__c != null && proposal_new.Apttus_QPConfig__PriceListId__c.equals(qsvalue.Early_Bird_Price_List_Id__c)){
                 proposal_new.Total_Early_Bird_Securing_Fee_Payments__c =  qsvalue.Earlybird_Securing_Fee_Return_Business__c;
             } else {
                 proposal_new.Total_Early_Bird_Securing_Fee_Payments__c = 0;
             }
             //set contacts
             try{
             if(!Opptycontact_old.isEmpty()){
                 for(OpportunityContactRole eachOpportunityContactRole : Opptycontact_old){
                        if(eachOpportunityContactRole.Role != null && eachOpportunityContactRole.Role.equals(Utils_allfields.OppConRole1)){
                            proposal_new.Apttus_Proposal__Primary_Contact__c =  eachOpportunityContactRole.ContactId;
                        }
                        if(eachOpportunityContactRole.Role != null && eachOpportunityContactRole.Role.equals(Utils_allfields.OppConRole2)){
                            proposal_new.Sponsor__c = eachOpportunityContactRole.ContactId;
                        }
                 }
             }
             insert proposal_new;
             }catch(Exception ex){
                    
                    system.debug('Exception Message---'+ ex.getMessage());
                    throw ex;
             }
         }else{
             hasError = true;
             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error:  Proposal / Quote Not Cretaed');
            ApexPages.addMessage(myMsg);
         }
         
     }
    //Method for PriceList 
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
  //  cretaeApttusobjects using Apttus Api's Create cart, Add product , Reprice , Finalize
     
     public void cretaeApttusobjects(){
         /* find the bundle product  */
         List<Product2> product_rollover = new List<Product2>();
         if(Oppty_new != null && Oppty_new.Qualification__c != null && Oppty_new.Level__c != null){
            product_rollover = [SELECT Id FROM Product2 
                                                where Apttus_Config2__ConfigurationType__c = 'Bundle' 
                                                and Conferer__c =: Oppty_new.Conferer__c
                                                and Qualification_Name__c =: Oppty_new.Qualification__c
                                                and Campus__c =:  Oppty_new.Campus__c
                                                and Qualification_Level_Name__c =:Oppty_new.Level__c
                                                and IsActive = true];
         }
         if(Oppty_new != null && Oppty_new.Level__c == null){
          Oppty_new.Level__c.adderror('incremented level product not found');
         
         }
         
         if(product_rollover != null && !product_rollover.isEmpty() ){
             /******* create a CART **************/
         
            cartID = cpq.CreateApttusCart(proposal_new.Id);
            
         /******** END of CART Creation ****************/
         
         if(cartID != null){
             cpq.AddMultiProduct(product_rollover,cartID);
             cpq.RepriceProposal(CartID);
             cpq.Finalizeproposal(CartID);
         }
           
         }else{
             hasError = true;
             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: NO Rollover Product Found');
            ApexPages.addMessage(myMsg);
         }
      
         
     }
     //Method to create Oppty Team
     public void Create_OpportunityTeam(){
         List<OpportunityTeamMember> OpptyTeamMember_old = [SELECT CurrencyIsoCode, DM_Identifier__c, Id, Job_Function__c, OpportunityAccessLevel, OpportunityId, TeamMemberRole,Team_Member_s_Manager__c, UserId ,User.IsActive
                                                            FROM OpportunityTeamMember where OpportunityId =: opportunityId];
                                                            
         system.debug('OpptyTeamMember_old  :'+OpptyTeamMember_old);
         if(!OpptyTeamMember_old.isEmpty() && OpptyTeamMember_old != null){
             for(OpportunityTeamMember eachOpportunityTeamMember : OpptyTeamMember_old){
              if(eachOpportunityTeamMember.User.IsActive==TRUE  ){  
                 OpportunityTeamMember tempopptyTeamMember = new OpportunityTeamMember();
                  tempopptyTeamMember.CurrencyIsoCode= eachOpportunityTeamMember.CurrencyIsoCode;
                  //tempopptyTeamMember.DM_Identifier__c= eachOpportunityTeamMember.DM_Identifier__c;
                  tempopptyTeamMember.OpportunityId = Oppty_new.id;
                  tempopptyTeamMember.TeamMemberRole = eachOpportunityTeamMember.TeamMemberRole;
                  tempopptyTeamMember.Team_Member_s_Manager__c = eachOpportunityTeamMember.Team_Member_s_Manager__c;
                  tempopptyTeamMember.UserId = eachOpportunityTeamMember.UserId;
                  OpptyTeamMember_new.add(tempopptyTeamMember);
                }
                 
             }
        }
         if(!OpptyTeamMember_new.isEmpty() && OpptyTeamMember_new != null){
             try{
                insert OpptyTeamMember_new;
             }catch(Exception ex){
                system.debug('Exception Message---'+ ex.getMessage());
                throw ex;
         }
         }
         
     }
     

}