/*******************************************************************************************************************
* Apex Class Name   : InternalRequestsUtils.cls
* Version           : 1.0 
* Created Date      : 17 JULY 2016
* Function          : Utility Class for Internal Request Object
* Modification Log  :
* Developer                   Date                    Description
* ------------------------------------------------------------------------------------------------------------------
*Brandon Young - 17 July 2015 - Created Class
*******************************************************************************************************************/

public with sharing class InternalRequestsUtils
{
     
     public Id getRecordTypeId(){
        RecordType rt = [SELECT Id,Name FROM RecordType WHERE SobjectType='Internal_Request__c' LIMIT 1];
        Schema.DescribeSObjectResult d = Schema.SObjectType.Internal_Request__c; 
        Map<Id,Schema.RecordTypeInfo> rtMapById = d.getRecordTypeInfosById();
        Schema.RecordTypeInfo rtById =  rtMapById.get(rt.id);
        Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
        Schema.RecordTypeInfo rtByName =  rtMapByName.get(rt.name);
        system.debug('******RTNAME***'+rtByName.getName());
        system.debug('******RTID***'+rtByName.getRecordTypeId());
        
        Id rtId = rtByName.getRecordTypeId();
        String rtName = rtByName.getName();

        return rtId;
      }

     public String getRecordTypeName(){
        RecordType rt = [SELECT Id,Name FROM RecordType WHERE SobjectType='Internal_Request__c' LIMIT 1];
        Schema.DescribeSObjectResult d = Schema.SObjectType.Internal_Request__c; 
        Map<Id,Schema.RecordTypeInfo> rtMapById = d.getRecordTypeInfosById();
        Schema.RecordTypeInfo rtById =  rtMapById.get(rt.id);
        Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
        Schema.RecordTypeInfo rtByName =  rtMapByName.get(rt.name);
        system.debug('******RTNAME***'+rtByName.getName());
        system.debug('******RTID***'+rtByName.getRecordTypeId());
        
        Id rtId = rtByName.getRecordTypeId();
        String rtName = rtByName.getName();

        return rtName;
      }

    // Update Owner with Salesperson Record
    // Applies only to Finacial Workflow Recordtype
    // Recordtype Name Stored in Custom Label
    public list<Internal_Request__c> updateRecords(Internal_Request__c[] lstOldInternalRequests, map<ID, Internal_Request__c> mapIDInternalRequest)
    {
        String rtName = getRecordTypeName();
        Id rtId = getRecordTypeId();


        for(Internal_Request__c sOldInternalRequest : lstOldInternalRequests)
        {

            Internal_Request__c sOldInternalRequest1 = mapIDInternalRequest.get(sOldInternalRequest.Id);
            // Update the OwnerId with the Sales Person Name if the Recordtype = Financial Workflow
            if(rtId == sOldInternalRequest.RecordTypeId && rtName == 'Finance Workflow' ){
                sOldInternalRequest.OwnerId       =   sOldInternalRequest1.Sales_Person_Name__c ;
                system.debug('lstInternalRequeststoUpdate:::' + sOldInternalRequest );
                }
            else{// do nothing
            }
        }
        
       return lstOldInternalRequests;
    }
    
    
}