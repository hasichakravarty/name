/************************************************************************************************************
* Apex Interface Name : PS_Util
* Version             : 1.0 
* Created Date        : 10 Jul 2015
* Function            : This class holds different utility methods that are used in other class for One CRM.
* Modification Log    :
* Developer                   Date                    Description
* -----------------------------------------------------------------------------------------------------------
* Leonard Victor            10/Jul/2015            Initial version
-------------------------------------------------------------------------------------------------------------
************************************************************************************************************/


public class PS_Util{

    private static Map<Id,Map<String,PermissionSet>> userPermissions;


    public static Map<String, Map<String,ID>> fetchAllRecordType(){
         Map<String, Map<String,ID>> recordTypeMap = new Map<String, Map<String,ID>>();
         Map<String, Schema.SObjectType> sObjectMap = Schema.getGlobalDescribe() ;
         for(String objName : sObjectMap.keySet()){
                Schema.SObjectType sObjType = sObjectMap.get(objName) ;
                Schema.DescribeSObjectResult sObjTypeDescribe = sObjType.getDescribe() ;
                Map<String,Schema.RecordTypeInfo> rtMapByName = sObjTypeDescribe.getRecordTypeInfosByName();
                    for(String recTypeName : rtMapByName.keyset()){
                        if(recordTypeMap.containsKey(String.valueof(sObjectMap.get(objName)))){
                            recordTypeMap.get(String.valueof(sObjectMap.get(objName))).put(recTypeName,rtMapByName.get(recTypeName).getRecordTypeId());
                        }

                        else{
                            Map<String,ID> tempMap = new Map<String,ID>();
                            tempMap.put(recTypeName,rtMapByName.get(recTypeName).getRecordTypeId());
                            recordTypeMap.put(String.valueof(sObjectMap.get(objName)),tempMap);
                        }
                    }
         }
         return recordTypeMap;
    }



    public static ID fetchRecordTypeByName(SObjectType sObj, String recordTypeName){

        Id recordTypeId;
        recordTypeId = sObj.getDescribe().getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId();
        return recordTypeId;

    }


    public static Map<Id,Map<String,PermissionSet>> retrieveUserPermissionSets(List<Id> usersId)
    {
        if(userPermissions == null)
        {
           userPermissions = new Map<Id,Map<String,PermissionSet>>(); 
        }

        List<Id> idToSearch = new  List<Id>();
        for(Id userId : usersId)
        {
            if(! userPermissions.containsKey(userId))
            {
                idToSearch.add(userId);
            }
        }

        if(! idToSearch.isEmpty())
        {

            List<PermissionSetAssignment> perms = [SELECT Id, AssigneeId, PermissionSet.Label FROM PermissionSetAssignment WHERE AssigneeId in :idToSearch];

            for(PermissionSetAssignment perm : perms)
            {
                if( ! userPermissions.containsKey(perm.AssigneeId))
                {
                    userPermissions.put(perm.AssigneeId, new Map<String,PermissionSet>());
                }

                userPermissions.get(perm.AssigneeId).put(perm.PermissionSet.Label,perm.PermissionSet);

            }
        }
      

        return userPermissions;
    }

    public static Boolean hasUserPermissionSet(Id userId, String permissionSetName)
    {
        List<Id> userIds = new  List<Id>();
        userIds.add(userId);

        Map<Id,Map<String,PermissionSet>> permissions = retrieveUserPermissionSets(userIds);
        
        System.debug('-->permissions');
        System.debug(permissions);

        return (permissions.containsKey(userId) && permissions.get(userId).containsKey(permissionSetName));

    }

    public static void addErrors(Map<String,SObject> objs, Map<String,List<String>> exceptions)
    {
        for( String id: objs.keyset())
        {
            if(exceptions.containsKey(id))
            {
                String errorMessage = '';   

                for(String err: exceptions.get(id))
                {
                    if(!err.containsIgnoreCase('Delete'))
                        errorMessage += err + '</br>';
                    else
                        errorMessage += err;
                }

                System.debug('Object Id:' + id + '--' + errorMessage);

                objs.get(id).addError(errorMessage, false);
            }
        }
    }
     public static User getUserDetail(Id usrId)
    {
        
        Schema.DescribeSObjectResult dsor = User.getSObjectType().getDescribe();
        String selectSoql= 'Select ';
        Map<String, Schema.SObjectField> objectFields = dsor.fields.getMap();
        List<String> lstFields = new List<String>();                
        for(String field : objectFields.keyset()){
            selectSoql+= field+','; 
        }
        String idVal = '\''+ usrId+'\'';
        selectSoql= selectSoql.removeEnd(',')+' '+'From User where id ='+idVal;
        System.debug('query---------->'+selectSoql);
        User usrObj = database.query(selectSoql);
        
        return usrObj;
        
            
                    
    }


}