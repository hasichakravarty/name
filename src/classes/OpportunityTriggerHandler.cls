/************************************************************************************************************
* Apex Class Name   : OpportunityTriggerHandler.cls
* Version           : 1.0 
* Created Date      : 06 MARCH 2014
* Function          : Handler class for Opportunity Object Trigger
* Modification Log  :
* Developer                   Date                    Description
* -----------------------------------------------------------------------------------------------------------
* Mitch Hunt                  06/03/2014              Created Default Handler Class Template
* Ashleey Ashokkumar          16/09/2014              disabled oppty renewal functionality
************************************************************************************************************/

public with sharing class OpportunityTriggerHandler
{
    private boolean m_bIsExecuting = false;
    private integer iBatchSize = 0;
    
    public OpportunityTriggerHandler(boolean bIsExecuting, integer iSize)
    {
        m_bIsExecuting = bIsExecuting;
        iBatchSize = iSize;
    }
    
    OpportunityUtils Utils = new OpportunityUtils();
    
    // EXECUTE BEFORE INSERT LOGIC
    //
    public void OnBeforeInsert(Opportunity[] lstNewOpportunities)
    {
        /* AA (Deloitte) 16/09/2014 - disabled oppty renewal functionality
         *
        list<Opportunity> lstOpportunitiestoEval        = new list<Opportunity>();
        list<Opportunity> listOpportunitestoClone       = new list<Opportunity>();
        set<Id> setOpptiesToClone                       = new set<Id>();
        set<String> setCloneOpptyIds                    = new set<String>();
        
        for(Opportunity sNewOpportunity : lstNewOpportunities)
        {           
            if(sNewOpportunity.IsClosed)
            {
                // set clone value to null - if they're cloning an oppty that has a clone, this one doesn't have a clone
                sNewOpportunity.Clone_Oppty__c = null;
                // add it to the list we need to clone
                listOpportunitestoClone.add(sNewOpportunity);
                setOpptiesToClone.add(sNewOpportunity.Id);
            }
        }
        // Clone opportunities that have been entered as closed
        Utils.createReEngagementClones(setOpptiesToClone, setCloneOpptyIds, listOpportunitestoClone);
        
        */
        
        //  Logic to default the Price book to standartd pricebook on Opportunity record type = D2L
         List<Pricebook2> stdPBL = [select id from Pricebook2 where IsStandard = TRUE LIMIT 1];//ONECRM Price Book
        List<Pricebook2> ANZPBL = [select id from Pricebook2 where Name like 'ANZ%']; // ANZ Price Book
        
        if(!stdPBL.isEmpty()){
            for(Opportunity o: lstNewOpportunities){
                if(o.RecordTypeId == Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('D2L').getRecordTypeId() ||
                   o.RecordTypeId == Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('B2B').getRecordTypeId()){
                    o.PriceBook2Id = stdPBL[0].id;
                }
            }
        }
        
        
        if(!ANZPBL.isEmpty()){
            for(Opportunity o: lstNewOpportunities){
                if(o.RecordTypeId == Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Opportunity').getRecordTypeId()){
                    o.PriceBook2Id = ANZPBL[0].id;
                }
            }
        }
        
        for(Opportunity o: lstNewOpportunities){
            o.Academic_Start_Date__c = AcademicStartDate();
        }         
        
        
    }
    
    // EXECUTE AFTER INSERT LOGIC
    //
    public void OnAfterInsert(Opportunity[] lstNewOpportunities)
    {
        List<Contract> conttoinsert = new List<Contract>();

    for (Opportunity opp : lstNewOpportunities)
        {
            //if(opp.Registration_Payment_Reference__c != null && opp.Received_Signed_Registration_Contract__c){
            if(opp.Registration_Payment_Reference1__c && opp.Received_Signed_Registration_Contract__c){
                system.debug('================opp=============='+opp);
                Contract con = new Contract();
                con.Opportunity__c = opp.Id;
                con.AccountId= opp.AccountId;
                con.StartDate =system.today();
                con.ContractTerm = 4;       
                conttoinsert.add(con); // For Bulk processing of the Records.
            }
            // End of For
        }
        
        if ( !conttoinsert.isEmpty())
        {
            insert conttoinsert;
        }
          
    
    }
    
     // Rd: 153 | Pooja 
     // If Contract exist on an account and Opp is getting created on same account then Copy fields on Opportunity.
     public void copyFieldsOnOpportuity(List<Opportunity> oppList){
     system.debug('Inside copyloop---'+ oppList);
         Map<Id,Id> oppMap = new Map<Id,Id>();
         Set<Id> accIdSet = new Set<Id>();
         List<Opportunity> OpportunityList = new List<Opportunity>();
         try{
             for(Opportunity op : oppList){
                 oppMap.put(op.Id,op.AccountId);
                 accIdSet.add(op.AccountId);
             }
             System.debug('OppMap-->'+ oppMap + 'accIdSet--->'+accIdSet);
             //List<Contract> conList = [select Id,AccountId, Opportunity__c,Opportunity__r.Student_Registered__c,Opportunity__r.Registration_Payment_Reference__c,Opportunity__r.Received_Signed_Registration_Contract__c from Contract where AccountId in: accIdSet];
             List<Contract> conList = [select Id,AccountId, Opportunity__c,Opportunity__r.Student_Registered__c,Opportunity__r.Registration_Payment_Reference1__c,Opportunity__r.Received_Signed_Registration_Contract__c from Contract where AccountId in: accIdSet];
            Map<Id,Contract> conMap = new Map<Id,Contract>();
            For(Contract con : conList){
                system.debug('Insid Contract loop---'+ con);
                conMap.put(con.AccountId,con);
            }
            System.debug('ContractMap---->'+conMap);
            For(Id i : oppMap.keySet()){
                Id accountId = oppMap.get(i);
                system.debug('accountId--'+accountId);
                Contract crec = conMap.get(accountId);
                system.debug('crec --'+crec);
                Opportunity op = new Opportunity(Id=i);
                if(crec != null)
                {                
                op.Student_Registered__c=crec.Opportunity__r.Student_Registered__c;
               // op.Registration_Payment_Reference__c = crec.Opportunity__r.Registration_Payment_Reference__c;
                op.Registration_Payment_Reference1__c = crec.Opportunity__r.Registration_Payment_Reference1__c;
                op.Received_Signed_Registration_Contract__c = crec.Opportunity__r.Received_Signed_Registration_Contract__c;
                }
                OpportunityList.add(op);
            }
            update OpportunityList;
            }
         Catch(Exception e){
             system.Debug('Exception----->'+e);
         }
     }
    
    
    // BEFORE UPDATE LOGIC
    //
    public void OnBeforeUpdate(Opportunity[] lstOldOpportunities, Opportunity[] lstUpdatedOpportunities, map<ID, Opportunity> mapIDOpportunity)
    {
        list<Opportunity> lstOpportunitiestoEval        = new list<Opportunity>();
        
        /* AA (Deloitte) 16/09/2014 - disabled oppty renewal functionality
         *
        list<Opportunity> listOpportunitestoClone       = new list<Opportunity>();
        set<Id> setOpptiesToClone                       = new set<Id>();
        set<String> setCloneOpptyIds                    = new set<String>();
        */
        for(Opportunity sOldOpportunity : lstOldOpportunities)
        {
            Opportunity sNewOpportunity = mapIDOpportunity.get(sOldOpportunity.Id);
            
            /* AA (Deloitte) 16/09/2014 - disabled oppty renewal functionality
             *
            if(sOldOpportunity.IsClosed == false && sNewOpportunity.IsClosed == true)
            {
                setOpptiesToClone.add(sNewOpportunity.Id);
                listOpportunitestoClone.add(sNewOpportunity);
                if (sNewOpportunity.Clone_Oppty__c <> null)
                {
                    setCloneOpptyIds.add(sNewOpportunity.Clone_Oppty__c);
                }
            }*/
                // If an opportunity stage or status has changed evaluate if they need a task created.
            if( sOldOpportunity.StageName != sNewOpportunity.StageName ||
                sOldOpportunity.Status__c != sNewOpportunity.Status__c)
            {
                lstOpportunitiestoEval.add(sNewOpportunity);
            }
        }
        /* AA (Deloitte) 16/09/2014 - disabled oppty renewal functionality
         *
        Utils.createReEngagementClones(setOpptiesToClone, setCloneOpptyIds, listOpportunitestoClone);
        */
        Utils.createFollowUpActivities(lstOpportunitiestoEval);
    }
    
    
    // Rd: 153 | Pooja
    // If Opp is getting updated and Student Registration is checked then create a contract on this opportunity.
    public void createContract(List<Opportunity> oppList){
    List<Contract> conList = new List<Contract>();
    Set<Id> acSet = new Set<Id>(); 
    For(Opportunity op : oppList){
        acSet.add(op.Accountid);
    }
    List<Contract> contrc = [select id,Opportunity__c,AccountId from Contract where Accountid in: acSet];
    Map<Id,Contract> opCont = new Map<Id,Contract>();
    for(Contract co : contrc){
        opCont.put(co.AccountId,co);
    }
     system.debug('opCont--'+ opCont);
        try{
        For(Opportunity op : oppList){
        system.debug('insi for--'+ op);
            if(op.Student_Registered__c == True && !opCont.containsKey(op.AccountId)){
            System.debug('Inside If----->'+ opCont.containsKey(op.AccountId));
                Contract con = new Contract();
                con.Opportunity__c = op.id;
                con.AccountId = op.AccountId;
                con.StartDate = system.today();
                con.ContractTerm = 9999;
                con.status = 'Signed by Customer';
                conList.add(con);
            }
        }
        
        insert conList;
        For(Contract op : conList){
            op.Status = 'Signed by Pearson and Customer';
        }
        update conList;
        }catch(Exception e){
            system.Debug('Exception--->'+e);
        }
    }
    
    
    // BEFORE DELETE LOGIC
    //
    public void OnBeforeDelete(Opportunity[] lstOpportunitiesToDelete, map<ID, Opportunity> mapIDOpportunity)
    {
        
    }
    
    // AFTER DELETE LOGIC
    //
    public void OnAfterDelete(Opportunity[] lstDeletedOpportunities, map<ID, Opportunity> mapIDOpportunity)
    {
        
    }
    
    // AFTER UNDELETE LOGIC
    //
    public void OnUndelete(Opportunity[] lstRestoredOpportunities)
    {
        
    }
    
    public boolean bIsTriggerContext
    {
        get{ return m_bIsExecuting; }
    }
    
    public boolean bIsVisualforcePageContext
    {
        get{ return !bIsTriggerContext; }
    }
    
    public boolean bIsWebServiceContext
    {
        get{ return !bIsTriggerContext; }
    }
    
    public boolean bIsExecuteAnonymousContext
    {
        get{ return !bIsTriggerContext; }
    }
    
   
    
    //writen :@sachin Kadam Date :4/10/2015
    // logic to set the Academic Start Date Based using  4 Academic start date fields on the Custom Settings:
    // The rule for setting the date should be as follows:
    // Select the date that is the closet to the current date
    // Please keep in mind that some of these may be blank initially so we should ignore a blank field

    public void OnAfterUpdate(Opportunity[] lstOldOpportunities, Opportunity[] lstUpdatedOpportunities, map<ID, Opportunity> mapIDOpportunity)
    {
         List<Contract> conttoinsert = new List<Contract>();
         
    for (Opportunity opp : lstUpdatedOpportunities)
        {
            List<Contract> checkcontaract = [select id from Contract where Accountid =:opp.Accountid and Opportunity__c =: opp.Id and ContractTerm =: 4];
            if(checkcontaract.isEmpty())
                //if(opp.Registration_Payment_Reference__c != null && opp.Received_Signed_Registration_Contract__c){
                if(opp.Registration_Payment_Reference1__c && opp.Received_Signed_Registration_Contract__c){
                    system.debug('================opp=============='+opp);
                    Contract con = new Contract();
                    con.Opportunity__c = opp.Id;
                    con.AccountId= opp.AccountId;
                    con.StartDate =system.today();
                    con.ContractTerm = 4; 
                    
                    con.Status = 'Signed by Customer';
                    conttoinsert.add(con); // For Bulk processing of the Records.
                }
            // End of For
        }
        
        if ( !conttoinsert.isEmpty())
        {
            insert conttoinsert;
        }
        
    }
    



    public Date AcademicStartDate(){
         List<Date> AcademicStartDateTerm = new List<Date>();
         Date seletedAcademicStartdate;
         Quote_Settings__c qsvalue = Quote_Settings__c.getValues('System Properties');
         if(qsvalue != null){
             if(qsvalue.Academic_Start_Date_Term_1__c != null){
                AcademicStartDateTerm.add(qsvalue.Academic_Start_Date_Term_1__c);
             }
             if(qsvalue.Academic_Start_Date_Term_2__c != null){
                 AcademicStartDateTerm.add(qsvalue.Academic_Start_Date_Term_2__c);
             }
             if(qsvalue.Academic_Start_Date_Term_3__c != null){
                 AcademicStartDateTerm.add(qsvalue.Academic_Start_Date_Term_3__c);
             }
             if(qsvalue.Academic_Start_Date_Term_4__c != null){
                 AcademicStartDateTerm.add(qsvalue.Academic_Start_Date_Term_4__c);
             }
             if(AcademicStartDateTerm != null && !AcademicStartDateTerm.isEmpty()){
                 AcademicStartDateTerm.sort();
                 system.debug('AcademicStartDateTerm :'+ AcademicStartDateTerm);
                 for(Date eachAcademicStartDate: AcademicStartDateTerm){
                     if(system.today() < eachAcademicStartDate){
                         system.debug('add this date :'+ eachAcademicStartDate);
                         seletedAcademicStartdate = eachAcademicStartDate;
                         break;
                     }
                 }
             }
             return seletedAcademicStartdate;
         }
         return null;
    }
}