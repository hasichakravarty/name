/*===========================================================================+
 |  HISTORY                                                                  
 |                                                                           
 |  DATE            DEVELOPER        DESCRIPTION                               
 |  ====            =========        =========== 
 |  7/5/2015        IDC              This Batch Class is used to update OpportunityLineItem Price
                                  
 +===========================================================================*/
global class PS_OpportunityLineItemBatch implements Database.Batchable<sObject> ,Database.Stateful {
 //Global Class Level Variables
    public string OppbatchQuery;
    Map<Id,Decimal> mapIDWithListprice= new Map<Id,Decimal>();
    Map<Id,Decimal> mapIDWithNetprice = new Map<Id,Decimal>();
    Set<ID> productsIdSet = new Set<ID>();
    List<OpportunityLineItem> OppLineItemList = new List<OpportunityLineItem>();
    List<OpportunityLineItem> OpplitoProcess = new List<OpportunityLineItem>();
    Public String Pl;
    public Id cretedby;
    public Id oppRecordId;
    
   //Constructor for Batch Class
    public PS_OpportunityLineItemBatch(ID oppcreatedby, String pricelist){
        try{
            Pl = pricelist;
            cretedby = oppcreatedby;
            //Fetching B2B record TYpe Id
            Schema.DescribeSObjectResult recordTypeDescr = Opportunity.SObjectType.getDescribe();
            Map<String,Schema.RecordTypeInfo> rtMapByName = recordTypeDescr.getRecordTypeInfosByName();
            oppRecordId =  rtMapByName.get('B2B').getRecordTypeId();
        }
        catch(Exception e){
            ExceptionFramework.LogException('BatchUpdateOpptyLineItem','PS_OpportunityLineItemBatch','PS_OpportunityLineItemBatch',e.getMessage(),UserInfo.getUserName(),'');
        }
    }
    //End of Contructor    

    global Database.QueryLocator start(Database.BatchableContext BC){
        //Query to fetch non-closed, non-lost B2B opportunity line items
        System.debug('Entered');
        return Database.getQueryLocator([Select id, UnitPrice,SRP__c,PricebookEntry.Product2Id, TotalPrice, Opportunity.Amount,Opportunity.CloseDate, Opportunity.Name From OpportunityLineItem WHERE Opportunity.StageName != 'Closed' and Opportunity.stageName != 'Lost' and Opportunity.createdbyid =:cretedby and Opportunity.RecordTypeId =:oppRecordId]);
    }
    
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        try{
        System.debug(scope);
        OpplitoProcess = (OpportunityLineItem [])scope;     
        productsIdSet.clear();
        //Code to Init Prod Id set for fetching pricelist
        for(opportunitylineitem oli: OpplitoProcess){
            productsIdSet.add(oli.PricebookEntry.Product2Id);
        }
           
           
        if(!productsIdSet.isEmpty()){
              //code fetching price
              for (Apttus_Config2__PriceListItem__c ap: [select Apttus_Config2__ProductId__c, Apttus_Config2__ListPrice__c,Net_Price__c 
                                      from Apttus_Config2__PriceListItem__c where Apttus_Config2__ProductId__c IN: productsIdSet and 
                                      Apttus_Config2__PriceListId__r.name =:Pl and Apttus_Config2__Active__c = true LIMIT 100]){
                   if (ap.Apttus_Config2__ListPrice__c != null) {
                      mapIDWithListprice.put(ap.Apttus_Config2__ProductId__c, ap.Apttus_Config2__ListPrice__c);
                   }
                   if (ap.Net_Price__c != null) {
                       mapIDWithNetprice.put(ap.Apttus_Config2__ProductId__c, ap.Net_Price__c);
                   }
              }
                
              //code to initialise opportunity line items prices to update  
              for(opportunitylineitem oli: OpplitoProcess){
                   oli.SRP__c = mapIDWithNetprice.get(oli.PricebookEntry.Product2Id);
                   oli.UnitPrice = mapIDWithListprice.get(oli.PricebookEntry.Product2Id);   
                   OppLineItemList.add(oli);
              }
  
        }   //if close
        
        if(!OppLineItemList.isempty()){
                //Update OppLineItemList;
              List<Database.SaveResult> result=Database.update(OppLineItemList,false);
              if (result!= null){
                  List<PS_ExceptionLogger__c> errloggerlist=new List<PS_ExceptionLogger__c>();
                  for (Database.SaveResult sr : result) {
                      String ErrMsg='';
                      if (!sr.isSuccess()){              
                          PS_ExceptionLogger__c errlogger=new PS_ExceptionLogger__c();
                          errlogger.InterfaceName__c='BatchUpdateOpptyLineItem';
                          errlogger.ApexClassName__c='PS_OpportunityLineItemBatch';
                          errlogger.CallingMethod__c='execute';
                          errlogger.UserLogin__c=UserInfo.getUserName(); 
                          errlogger.recordid__C=sr.getId();
                          for(Database.Error err : sr.getErrors()) {
                              ErrMsg=ErrMsg+err.getStatusCode() + ': ' + err.getMessage(); 
                          }
                          errloggerlist.add(errlogger);                    
                       }
                   }
                   if(errloggerlist.size()>0){insert errloggerlist;}
               }
              
        }
        }
        catch(Exception e){
            ExceptionFramework.LogException('BatchUpdateOpptyLineItem','PS_OpportunityLineItemBatch','execute',e.getMessage(),UserInfo.getUserName(),'');
        }
    }
     
    global void finish(Database.BatchableContext BC){
            // Logic to be Executed at finish
    }

}