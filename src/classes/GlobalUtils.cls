/***************************************************************************************************************************
* Apex Class Name	: GlobalUtils.cls
* Version 			: 1.0 
* Created Date  	: 06 MARCH 2014
* Function 			: This class contains Utility functions which can be used by any Trigger or Class
* Modification Log	:
* Developer					Date					Description
* --------------------------------------------------------------------------------------------------------------------------
* Mitch Hunt				06/03/2014				Created GlobalUtils.cls, Included the following methods: 
*													getMapRecordTypes,Debug, AddError, AddInfo, AddWarning.
***************************************************************************************************************************/

public with sharing class GlobalUtils
{
	// getMapRecordTypes:
	// From a passed in list of objects this method generates a map of recordtype details
	//
	public static map<string,string> getMapRecordTypes(List <String> objectTypes)
	{
		map <String, String> tmp = new Map <String, String>();
		
		try
		{
			for (RecordType rt : [SELECT Id, Name, DeveloperName FROM RecordType WHERE sObjectType IN :objectTypes])
			{
				tmp.put(rt.ID, rt.DeveloperName);
				tmp.put(String.valueOf(rt.ID).substring(0,15), rt.DeveloperName);
				tmp.put(rt.DeveloperName, rt.ID);
				tmp.put(rt.Name, rt.ID);
			}
		}
		catch (Exception e)
		{
			system.debug(e.getMessage());
		}
		
		return tmp;
	}
	
	// getprofiles
	// Return a map of all current profiles name & Id
	//
	public static map<string,string> getprofiles()
	{
		map<String, String> tmp = new map<String, String>();
		
		try
		{
			for(Profile sProfile : [SELECT Id, Name FROM Profile])
			{
				tmp.put(sProfile.Id, sProfile.Name);
				tmp.put(sProfile.Name, sProfile.Id);
			}
		}
		catch (exception e)
		{
			Debug(e.getmessage());
		}
		
		return tmp;
	}
	
	
	// Debug:
	// Used to make debug logs more visible
	//
	public static void Debug(string strDebug)
	{
		System.Debug('\n\n******************************************************************************\n'
						+ strDebug
						+ '\n******************************************************************************\n\n');
	}
	
	// AddError:
	// Shortcut code for Visualforce error messages
	//
	public static void AddError(string strError)
	{
		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, strError));
	}
	
	// AddInfo: 
	// Shortcut code for Visualforce info messages
	//
	public static void AddInfo(string strInfo)
	{
		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, strInfo));
	}
	
	// AddWarning:
	// Shortcut code for Visualforce warning messages
	//
	public static void AddWarning(string strWarning)
	{
		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning, strWarning));
	}
	
	// StaticTracker:
	// Ensure that triggers only fire once
	// 
	public static boolean m_RelationshipInsertTriggerFired		{get; set;}
	public static boolean m_RelationshipUpdateTriggerFired		{get; set;}
	public static boolean m_RelationshipDeleteTriggerFired		{get; set;}
	public static boolean m_RelationshipUnDeleteTriggerFired	{get; set;}
	
}