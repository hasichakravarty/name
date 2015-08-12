/************************************************************************************************************
* Apex Class Name	: OpportunityLineItemTriggerHandler.cls
* Version 			: 1.0 
* Created Date  	: 06 MAY 2014
* Function 			: Handler class for Opportunitu Object Trigger
* Modification Log	:
* Developer                   Date                    Description
* -----------------------------------------------------------------------------------------------------------
* Mitch Hunt                  06/05/2014              Created Default Handler Class Template
************************************************************************************************************/

public without sharing class OpportunityLineItemTriggerHandler
{
	private boolean m_bIsExecuting = false;
	private integer iBatchSize = 0;
	
	public OpportunityLineItemTriggerHandler(boolean bIsExecuting, integer iSize)
	{
		m_bIsExecuting = bIsExecuting;
		iBatchSize = iSize;
	}
	
	OpportunityUtils Utils = new OpportunityUtils();
	
	// EXECUTE BEFORE INSERT LOGIC
	//
	public void OnBeforeInsert(OpportunityLineItem[] lstNewOrders)
	{
		
	}
	
	// EXECUTE AFTER INSERT LOGIC
	//
	public void OnAfterInsert(OpportunityLineItem[] lstNewOrderLines)
	{
		set<ID> setOrderIds = new set<ID>();
		Id OpptyRecordtype = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Opportunity').getRecordTypeId();
		
		for(OpportunityLineItem oli : lstNewOrderLines)
		{
			setOrderIds.add(oli.OpportunityId);
		}
		
		String strQuery = 'SELECT ';
		
		Map<String, Schema.SObjectField> schemaFieldMap = Schema.SObjectType.Opportunity.fields.getMap();
		for (String fieldName: schemaFieldMap.keySet())
		{
			strQuery += fieldName + ', ';
		}
		
		strQuery = strQuery.substring(0, strQuery.length() - 2);
		strQuery += ' FROM Opportunity WHERE ID IN : setOrderIds and RecordTypeId = : OpptyRecordtype';
		
		system.debug('thequery:::' + strQuery);
		
		list<Opportunity> lstOpportunities = database.query(strQuery);
		if(lstOpportunities != null && !lstOpportunities.isEmpty())
		    Utils.createFollowUpActivities(lstOpportunities);
	}
	
	// BEFORE UPDATE LOGIC
	//
	public void OnBeforeUpdate(OpportunityLineItem[] lstOldOrderLines, OpportunityLineItem[] lstUpdatedOrderLines, map<ID, OpportunityLineItem> mapIDOrderLines)
	{
		
	}
	
	// AFTER UPDATE LOGIC
	//
	public void OnAfterUpdate(OpportunityLineItem[] lstOldOrderLines, OpportunityLineItem[] lstUpdatedOrderLines, map<ID, OpportunityLineItem> mapIDOrderLines)
	{
		
	}
	
	// BEFORE DELETE LOGIC
	//
	public void OnBeforeDelete(OpportunityLineItem[] lstOrderLinesToDelete, map<ID, OpportunityLineItem> mapIDOrderLines)
	{
		system.debug('in Delete Opportunity product');
		Set<Id> OpptyId = new Set<Id>();
		Map<Id,Opportunity> mapOppty;
		Map<Id,Boolean> hasspecialPriceRequest = new Map<Id,Boolean>();
		User Usr = new User();
		Usr = [SELECT  Id, Line_of_Business__c, Market__c FROM User WHERE Id = : UserInfo.getUserId()];
		system.debug('Usr  :'+Usr);
		if(Usr.Line_of_Business__c == 'Higher Ed' && Usr.Market__c == 'US'){
		    for(OpportunityLineItem eachOpptyprod: lstOrderLinesToDelete){
		        OpptyId.add(eachOpptyprod.OpportunityId);
		    }
		    if(OpptyId != null && !OpptyId.isEmpty()){
		        mapOppty = new Map<Id,Opportunity>([SELECT Id, RecordType.Name FROM Opportunity WHERE Id in : OpptyId]);
		    
    		    for(Special_Price_Request__c specialPriceRequest : [Select Id, Status__c, Opportunity__c from Special_Price_Request__c where Opportunity__c in : OpptyId And Status__c != 'Completed' And Status__c != 'Rejected' And Status__c != 'Recalled']){
    		        hasspecialPriceRequest.put(specialPriceRequest.Opportunity__c,True);
    		    }
		    }
		       
		    for(OpportunityLineItem eachOpptyprod: lstOrderLinesToDelete){
		        if(mapOppty.get(eachOpptyprod.OpportunityId) != null && hasspecialPriceRequest.get(eachOpptyprod.OpportunityId) != null && mapOppty.get(eachOpptyprod.OpportunityId).RecordType.Name == 'B2B' && hasspecialPriceRequest.get(eachOpptyprod.OpportunityId)){
		            string errormsg = 'A Special Price Request is pending for this Opportunity. Products cannot be Deleted until the request is completed.';
		            eachOpptyprod.addError(errormsg,false);
		            
		        } 
		    }
		    
		}
		
	}
	
	// AFTER DELETE LOGIC
	//
	public void OnAfterDelete(OpportunityLineItem[] lstDeletedOrderLines, map<ID, OpportunityLineItem> mapIDOrderLines)
	{
		
	}
	
	// AFTER UNDELETE LOGIC
	//
	public void OnUndelete(OpportunityLineItem[] lstRestoredOrderLines)
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

}