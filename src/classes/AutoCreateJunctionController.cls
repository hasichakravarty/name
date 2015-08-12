public with sharing class AutoCreateJunctionController
{
	public Id originalId;
	public Id newId;
	
	public AutoCreateJunctionController()
	{
		originalId = apexPages.currentPage().getParameters().get('originalid');
		newID = apexPages.currentPage().getParameters().get('newid');
	}
	
	public pagereference createJunctionandredirect()
	{
		String originalObjectAPIName	= originalId.getSObjectType().getDescribe().getName();
		String newObjectAPIName			= newId.getSObjectType().getDescribe().getName();
		
		system.debug('newObjectAPIName:::' + newObjectAPIName);
		system.debug('originalObjectAPIName:::' + originalObjectAPIName);
		
		if(originalObjectAPIName == 'Opportunity' && newObjectAPIName == 'Call__c')
		{
			system.debug(':::1');
			CallOpportunity__c sCallOppty = new CallOpportunity__c();
			sCalloppty.Call__c = newId;
			sCalloppty.Opportunity__c = originalId;
		
			insert sCallOppty;
		}
		else if(originalObjectAPIName == 'Call__c' && newObjectAPIName == 'Opportunity')
		{
			system.debug(':::2');
			CallOpportunity__c sCallOppty = new CallOpportunity__c();
			sCalloppty.Call__c = originalId;
			sCalloppty.Opportunity__c = newId;
			
			insert sCallOppty;
		}
		
		pagereference pageref = new pagereference('/' + newId);
		return pageref;
	}
}