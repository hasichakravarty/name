trigger Call on Call__c (after delete, after insert, after undelete, after update, before delete, before insert, before update)
{
	CallTriggerHandler Handler = new CallTriggerHandler(Trigger.isExecuting, Trigger.size);
	
	// Before Insert Logic
	//
	if(Trigger.isInsert && Trigger.isBefore)
	{
		Handler.OnBeforeInsert(Trigger.new);
	}
	// After Insert Logic
	//
	else if(Trigger.isInsert && Trigger.isAfter)
	{
		Handler.OnAfterInsert(Trigger.new);
	}
	// Before Update Logic
	//
	else if(Trigger.isUpdate && Trigger.isBefore)
	{
		Handler.OnBeforeUpdate(Trigger.old, Trigger.new, Trigger.newMap);
	}
	// After Update Logic
	//
	else if(Trigger.isUpdate && Trigger.isAfter)
	{
		Handler.OnAfterUpdate(Trigger.old, Trigger.new, Trigger.newMap);
	}
	// Before Delete Logic
	//
	else if(Trigger.isDelete && Trigger.isBefore)
	{
		Handler.OnBeforeDelete(Trigger.old, Trigger.oldMap);
	}
	// After Delete Logic
	//
	else if(Trigger.isDelete && Trigger.isAfter)
	{
		Handler.OnAfterDelete(Trigger.old, Trigger.oldMap);
	}
	
	// After Undelete Logic
	//
	else if(Trigger.isUnDelete)
	{
		Handler.OnUndelete(Trigger.new);
	}
}