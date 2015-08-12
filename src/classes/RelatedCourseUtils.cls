/*******************************************************************************************************************
* Apex Class Name	: RelatedCourseUtils.cls
* Version 			: 1.0 
* Created Date  	: 09 APRIL 2014
* Function 			: Utility Class for RelatedCourse Object
* Modification Log	:
* Developer						Date                    Description
* ------------------------------------------------------------------------------------------------------------------
* Mitch Hunt					09/04/2014              Created Initial Version of Utility Class.
* Mitch Hunt					09/04/2014              Added method to
*******************************************************************************************************************/

public with sharing class RelatedCourseUtils
{
	// Clone Record
	// 
	// 
	public void cloneRecords(RelatedCourse__c[] lstRelatedCourses)
	{
		list<RelatedCourse__c>	lstRelatedCoursestoInsert	= new list<RelatedCourse__c>();
		list<RelatedCourse__c>	lstRelatedCoursestoUpdate	= new list<RelatedCourse__c>();
		map<ID,ID>				mapIDtoCloneID				= new map<ID,ID>();
		
		for(RelatedCourse__c sRelationship : lstRelatedCourses)
		{
			// If this is the first record being created, clone the record
			if(sRelationship.RelationshipClone__c == null)
			{
				lstRelatedCoursestoInsert.add(new RelatedCourse__c
											(	Course__c 				= sRelationship.Related_Course__c, 
												Related_Course__c			= sRelationship.Course__c,
												Type__c					= sRelationship.Type__c,
												RelationshipClone__c	= sRelationship.Id
											)
											);
			}
			
			// If this is the clone record being created update the original record with the correct Id
			if(sRelationship.RelationshipClone__c != null)
			{
				mapIDtoCloneID.put(sRelationship.RelationshipClone__c, sRelationship.Id);
			}
		}
		
		insert lstRelatedCoursestoInsert;
		
		for(RelatedCourse__c sRelationship : [SELECT Id FROM RelatedCourse__c WHERE Id IN : mapIDtoCloneID.keyset()])
		{
			sRelationship.RelationshipClone__c	= mapIDtoCloneID.get(sRelationship.Id);
			lstRelatedCoursestoUpdate.add(sRelationship);
		}
		
		update lstRelatedCoursestoUpdate;
	}
	
	// Update Record
	// 
	// 
	public void updateRecords(RelatedCourse__c[] lstOldRelatedCourses, map<ID, RelatedCourse__c> mapIDRelationship)
	{
		if(GlobalUtils.m_RelationshipUpdateTriggerFired == null || GlobalUtils.m_RelationshipUpdateTriggerFired == false)
		{
			GlobalUtils.m_RelationshipUpdateTriggerFired = true;
		}
		else if(GlobalUtils.m_RelationshipUpdateTriggerFired == true)
		{
			return;
		}
		
		list<RelatedCourse__c>		lstRelatedCoursestoUpdate		= new list<RelatedCourse__c>();
		
		for(RelatedCourse__c sOldRelationship : lstOldRelatedCourses)
		{
			RelatedCourse__c sRelationship = mapIDRelationship.get(sOldRelationship.Id);
			
			lstRelatedCoursestoUpdate.add(new RelatedCourse__c
										(	Id						= sRelationship.RelationshipClone__c,
											Course__c 				= sRelationship.Related_Course__c, 
											Related_Course__c		= sRelationship.Course__c,
											Type__c					= sRelationship.Type__c
										)
										);
										
			system.debug('lstRelatedCoursestoUpdate:::' + lstRelatedCoursestoUpdate);
		}
		
		update lstRelatedCoursestoUpdate;
		
		GlobalUtils.m_RelationshipUpdateTriggerFired = false;
	}
	
	
	// Delete Records
	// 
	// 
	public void deleteRecords(RelatedCourse__c[] lstDeletedRelatedCourses)
	{
		if(GlobalUtils.m_RelationshipDeleteTriggerFired == null || GlobalUtils.m_RelationshipDeleteTriggerFired == false)
		{
			GlobalUtils.m_RelationshipDeleteTriggerFired = true;
		}
		else if(GlobalUtils.m_RelationshipDeleteTriggerFired == true)
		{
			return;
		}
		
		set<ID>						setRelatedCoursestoDelete		= new set<ID>();
		set<ID>						setRelatedCoursesSFDCtoDelete	= new set<ID>();
		list<RelatedCourse__c>		lstRelatedCoursestoDelete		= new list<RelatedCourse__c>();
		
		// Push into a set so that if we are batch deleting we do not get duplicate values
		for(RelatedCourse__c sRelationship : lstDeletedRelatedCourses)
		{
			setRelatedCoursestoDelete.add(sRelationship.RelationshipClone__c);
			setRelatedCoursesSFDCtoDelete.add(sRelationship.ID);
		}
		
		// Now that we have a set of all of the RelatedCourses to delete, check if they are in the original delete list
		// that salesforce is going to perform, if they are not push all the ids into a list so that we can perform DML operation.
		for(ID sRelationshipID : setRelatedCoursestoDelete)
		{
			if(setRelatedCoursesSFDCtoDelete.contains(sRelationshipID) == false)
			{
				lstRelatedCoursestoDelete.add(new RelatedCourse__c
											(	Id						= sRelationshipID
											)
											);
			}
		}
		
		system.debug('lstRelatedCoursestoDelete:::' + lstRelatedCoursestoDelete);
		
		delete lstRelatedCoursestoDelete;
		
		GlobalUtils.m_RelationshipDeleteTriggerFired = false;
	}
	
}