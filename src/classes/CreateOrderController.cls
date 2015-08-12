public without sharing class CreateOrderController
{
	private final	Opportunity		sOpportunity;
	public			Id				orderID;
	public			Id				opptyID;
	// Retreive field listings from custom settings
	list<OpportunityToOrderEntryCriteria__c>	lstcsCriteria			= OpportunityToOrderEntryCriteria__c.getall().values();
	list<OpportunityToOrderFieldMapping__c>		lstcsMappings			= OpportunityToOrderFieldMapping__c.getall().values();
	
	public CreateOrderController(ApexPages.StandardController stdController)
	{
		list<String> stringstoQuery = new list<String>();
		
		for(OpportunityToOrderFieldMapping__c csMapping : lstcsMappings)
		{
			if(csMapping.Source_Object__c == 'Opportunity')
			{
				stringstoQuery.add(csMapping.Source_Field__c);
			}
		}
		
		for(OpportunityToOrderEntryCriteria__c csCriteria : lstcsCriteria)
		{
			stringstoQuery.add(csCriteria.Field_Name__c);
		}
		if(Test.isRunningTest() == false)
		{
			stdController.addFields(stringstoQuery);
		}
		this.sOpportunity = (Opportunity)stdController.getRecord();
	}
	
	public pageReference init()
	{
			boolean bCriteriaMet = true;
			
			for(OpportunityToOrderEntryCriteria__c csCriteria : lstcsCriteria)
			{
				sObject sOppty				= sOpportunity;
				boolean bCriteriaVal		= (boolean)sOppty.get(csCriteria.Field_Name__c);
				
				if(bCriteriaVal != boolean.valueof(csCriteria.Required_Value__c))
				{
					system.debug('::: ErrorMsg :::' + csCriteria.Error_Message__c);
					ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,  csCriteria.Error_Message__c));
					bCriteriaMet = false;
				}
			}
			
			if(bCriteriaMet == true)
			{
				// use sObject instead to get dynamic references
				sObject sOrder = Schema.getGlobalDescribe().get('Order__c').newSObject();
				sObject sOppty = sOpportunity;
				
				for(OpportunityToOrderFieldMapping__c csMapping : lstcsMappings)
				{
					if(csMapping.Source_Object__c == 'Opportunity')
					{
						sOrder.put(csMapping.Destination_Field__c, sOppty.get(csMapping.Source_Field__c));
					}
				}
				
				insert sOrder;
				orderID = sOrder.Id;
				opptyID = sOpportunity.Id;
			
			list<sObject>			lstOrderLineItems	= new list<sObject>();
			list<sObject>			lstOpptyLineItems	= new list<sObject>();
			
			string strQuery = 'SELECT Id';
			
			for(OpportunityToOrderFieldMapping__c csMapping : lstcsMappings)
			{
				if(csMapping.Source_Object__c == 'OpportunityLineItem')
				{
					strQuery += ', ' + csMapping.Source_Field__c;
				}
			}
			
			strQuery += ' FROM OpportunityLineItem WHERE OpportunityId = : opptyID';

			lstOpptyLineItems = database.query(strQuery);
			
			for(sObject sOpptyLI : lstOpptyLineItems)
			{
				sObject sOrderLI = Schema.getGlobalDescribe().get('OrderLineItem__c').newSObject();
				
				for(OpportunityToOrderFieldMapping__c csMapping : lstcsMappings)
				{
					if(csMapping.Source_Object__c == 'OpportunityLineItem')
					{
						sOrderLI.put(csMapping.Destination_Field__c, sOpptyLI.get(csMapping.Source_Field__c));
					}
				}
				
				sOrderLI.put('Order__c', orderID);
				
				lstOrderLineItems.add(sOrderLI);
			}
			
			insert lstOrderLineItems;
			
			pageReference pageRef = new PageReference('/' + orderID);
			return pageRef;
			}
			
		return null;
	}
	
	public pagereference actionReturn()
	{
		pagereference pageRef = new pageReference('/' + sOpportunity.Id);
		return pageRef;
	}
	
}