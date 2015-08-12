/************************************************************************************************************************
* Apex Class Name	: RelatedCourseTriggerHandler.cls
* Version 			: 1.0 
* Created Date  	: 14 MARCH 2014
* Function 			: Handler class for RelatedCourse Object Trigger
* Modification Log	:
* Developer                   Date                    Description
* -----------------------------------------------------------------------------------------------------------------------
* Mitch Hunt                  14/03/2014              Created Default Handler Class Template
************************************************************************************************************************/

public with sharing class RelatedCourseTriggerHandler
{
	private boolean m_bIsExecuting = false;
	private integer iBatchSize = 0;
	
	public RelatedCourseTriggerHandler(boolean bIsExecuting, integer iSize)
	{
		m_bIsExecuting = bIsExecuting;
		iBatchSize = iSize;
	}
	
	// Init RelatedCourse Utils
	RelatedCourseUtils utils = new RelatedCourseUtils();
	
	// EXECUTE BEFORE INSERT LOGIC
	//
	public void OnBeforeInsert(RelatedCourse__c[] lstNewRelatedCourses)
	{
		
	}
	
	// EXECUTE AFTER INSERT LOGIC
	//
	public void OnAfterInsert(RelatedCourse__c[] lstNewRelatedCourses)
	{
		utils.cloneRecords(lstNewRelatedCourses);
	}
	
	// BEFORE UPDATE LOGIC
	//
	public void OnBeforeUpdate(RelatedCourse__c[] lstOldRelatedCourses, RelatedCourse__c[] lstUpdatedRelatedCourses, map<ID, RelatedCourse__c> mapIDRelatedCourse)
	{
		
	}
	
	// AFTER UPDATE LOGIC
	//
	public void OnAfterUpdate(RelatedCourse__c[] lstOldRelatedCourses, RelatedCourse__c[] lstUpdatedRelatedCourses, map<ID, RelatedCourse__c> mapIDRelatedCourse)
	{
		utils.updateRecords(lstOldRelatedCourses, mapIDRelatedCourse);
	}
	
	// BEFORE DELETE LOGIC
	//
	public void OnBeforeDelete(RelatedCourse__c[] lstRelatedCoursesToDelete, map<ID, RelatedCourse__c> mapIDRelatedCourse)
	{
		utils.deleteRecords(lstRelatedCoursesToDelete);
	}
	
	// AFTER DELETE LOGIC
	//
	public void OnAfterDelete(RelatedCourse__c[] lstDeletedRelatedCourses, map<ID, RelatedCourse__c> mapIDRelatedCourse)
	{
		
	}
	
	// AFTER UNDELETE LOGIC
	//
	public void OnUndelete(RelatedCourse__c[] lstRestoredRelatedCourses)
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