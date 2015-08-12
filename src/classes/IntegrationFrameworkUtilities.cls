/*******************************************************************************************************************
* Apex Class Name  : IntegrationFrameworkUtilities
* Version          : 1.0 
* Created Date     : 27 March 2015
* Function         : Class to group the functionalities of the Integration Framework
* Modification Log :
*
* Developer                   Date                    Description
* ------------------------------------------------------------------------------------------------------------------
*                             27/03/2015              Created Initial Version of IntegrationFrameworkUtilities Class
*******************************************************************************************************************/
public without sharing class IntegrationFrameworkUtilities
{
   //Variables -- Start

   static Map<String,Integration_Framework_Configuration__c> configs = null;

   //Variables -- END

     /*************************************************************************************************************
    * Name        : SetObjectsJSONRepresentation
    * Description : Get the JSON representation of the Outbound Integration Request Parent Objects
    * Input       : IntReqList - List of Integration Request records to include
    * Output      : 
    *************************************************************************************************************/
    public void SetObjectsJSONRepresentation(List<Integration_Request__c> IntReqList)
    {
        // Get the JSON representation of the Integration Request Parent Object
        Map<Id, String> IntReqJSONRepresentations = GetObjectsJSONRepresentation(IntReqList);
        
        // Set the JSON Representation of the Parent Objet in the Integration Request
        for(Integration_Request__c IntReq :IntReqList)
        {
            if(IntReqJSONRepresentations.containsKey(IntReq.Id))
            {
                IntReq.Object_Original__c = IntReqJSONRepresentations.get(IntReq.Id);
            }
        }
    }
    
    /*************************************************************************************************************
    * Name        : GetObjectsJSONRepresentation
    * Description : Get the JSON representation of the Outbound Integration Request Parent Objects
    * Input       : IntReqList - List of Integration Request records to include
    * Output      : Map with the JSON representation of the Integration Request Parent Object per Integration Request Id
    *************************************************************************************************************/
    public Map<Id, String> GetObjectsJSONRepresentation(List<Integration_Request__c> IntReqList)
    {
        Map<Id, String> IntReqJSONRepresentations = new Map<Id, String>();
        
        //Get the JSON Definition details from the custom setting
        List<IntegrationFrameworkJSONDefinition__c> JSONDefinitions = [SELECT Id, Object_Fields__c, Event__c, ObjectType__c,
                                                                        Geo__c, Market__c, LoB__c, Sub_Event__c
                                                                        FROM IntegrationFrameworkJSONDefinition__c];
        
        // Generate a map with the JSON definitions fields per Object Type and Event
        Map<String,String> mapJSONDefinitions = new Map<String,String>();
        
        for(IntegrationFrameworkJSONDefinition__c JSONDefItem :JSONDefinitions)
        {
            String MapKey;
            
            String MainFieldsMapKey;
            
            if(JSONDefItem.Sub_Event__c == null)
            {
                MainFieldsMapKey = JSONDefItem.ObjectType__c + JSONDefItem.Event__c; 
            }            
            else
            {
                MainFieldsMapKey = JSONDefItem.ObjectType__c + JSONDefItem.Event__c + JSONDefItem.Sub_Event__c;
            }
            
            if(JSONDefItem.LoB__c == null)
            {
                if(JSONDefItem.Geo__c == null)
                {
                    if(JSONDefItem.Market__c== null)
                    {
                        MapKey = MainFieldsMapKey; 
                    }
                    else
                    {
                        MapKey = MainFieldsMapKey  +  JSONDefItem.Market__c; 
                    }
                }
                else
                {
                    if(JSONDefItem.Market__c== null)
                    {
                        MapKey = MainFieldsMapKey  + JSONDefItem.Geo__c; 
                    }
                    else
                    {
                        MapKey = MainFieldsMapKey  + JSONDefItem.Geo__c + JSONDefItem.Market__c; 
                    }
                }
                
            }
            else
            {
                if(JSONDefItem.Geo__c == null)
                {
                    if(JSONDefItem.Market__c== null)
                    {
                        MapKey = MainFieldsMapKey  + JSONDefItem.LoB__c; 
                    }
                    else
                    {
                        MapKey = MainFieldsMapKey  + JSONDefItem.LoB__c + JSONDefItem.Market__c; 
                    }
                }
                else
                {
                    if(JSONDefItem.Market__c== null)
                    {
                        MapKey = MainFieldsMapKey  + JSONDefItem.LoB__c + JSONDefItem.Geo__c;  
                    }
                    else
                    {
                        MapKey = MainFieldsMapKey  + JSONDefItem.LoB__c + JSONDefItem.Geo__c + JSONDefItem.Market__c;   
                    }
                }
            }
            mapJSONDefinitions.put(MapKey,JSONDefItem.Object_Fields__c);
            
        }
        
        //Assign the corresponding JSON definition fields to each of the Integration Request records
        Map<ID,String> mapIntReqJSONDefFiels = new Map<ID,String>();
        List<Integration_Request__c> IntReqWithNoJSONDef = new List<Integration_Request__c>();
        
        for(Integration_Request__c IntReq :IntReqList)
        {
            if(IntReq.Direction__c == 'Outbound')
            {
                // Assign a JSONDef with the following logic: 
                // Check if there is a JSON definition specified for the integration request record Market, LoB and Geography values. 
                
                String MapKeySpecific;
                
                String MainFieldsMapKeySpecific;
                
                if(IntReq.Sub_Event__c ==  null)
                {
                    MainFieldsMapKeySpecific = IntReq.Object_Name__c + IntReq.Event__c;
                }
                else
                {
                    MainFieldsMapKeySpecific = IntReq.Object_Name__c + IntReq.Event__c + IntReq.Sub_Event__c;
                } 
                
                if(IntReq.LoB__c == null)
                {
                    if(IntReq.Geo__c == null)
                    {
                        if(IntReq.Market__c== null)
                        {
                            MapKeySpecific = MainFieldsMapKeySpecific; 
                        }
                        else
                        {
                            MapKeySpecific = MainFieldsMapKeySpecific  +  IntReq.Market__c; 
                        }
                    }
                    else
                    {
                        if(IntReq.Market__c== null)
                        {
                            MapKeySpecific = MainFieldsMapKeySpecific  + IntReq.Geo__c; 
                        }
                        else
                        {
                            MapKeySpecific = MainFieldsMapKeySpecific  + IntReq.Geo__c + IntReq.Market__c; 
                        }
                    }
                    
                }
                else
                {
                    if(IntReq.Geo__c == null)
                    {
                        if(IntReq.Market__c== null)
                        {
                            MapKeySpecific = MainFieldsMapKeySpecific  + IntReq.LoB__c; 
                        }
                        else
                        {
                            MapKeySpecific = MainFieldsMapKeySpecific  + IntReq.LoB__c + IntReq.Market__c; 
                        }
                    }
                    else
                    {
                        if(IntReq.Market__c== null)
                        {
                            MapKeySpecific = MainFieldsMapKeySpecific  + IntReq.LoB__c + IntReq.Geo__c;  
                        }
                        else
                        {
                            MapKeySpecific = MainFieldsMapKeySpecific  + IntReq.LoB__c + IntReq.Geo__c + IntReq.Market__c;   
                        }
                    }
                }
                
                System.debug('MAIN MAP KEY OF INT REQ: '+MapKeySpecific );
                
                System.debug('MAIN FIELDS MAP KEY OF INT REQ: '+MainFieldsMapKeySpecific  );
                
                String FieldsToInclude = '';
                
                if(mapJSONDefinitions.containsKey(MapKeySpecific))
                {
                    mapIntReqJSONDefFiels.put(IntReq.Id,mapJSONDefinitions.get(MapKeySpecific));
                }
                else
                {
                    IntReqWithNoJSONDef.add(IntReq);
                }
            }
        }
        
        if(IntReqWithNoJSONDef.size()==0)
        {
            //Assign to each Integration Request record the JSON Representation
            for(Integration_Request__c IntReq :IntReqList)
            {                
                String FieldsToInclued = mapIntReqJSONDefFiels.get(IntReq.Id);
                
                String SObjectIdValue = IntReq.Object_Id__c;
                
                String QueryString =  'SELECT ' + FieldsToInclued + ' FROM ' + IntReq.Object_Name__c + ' WHERE Id = :SObjectIdValue LIMIT 1';
                
                try
                {
                    sObject ParentObject = Database.query(QueryString);
                
                    if(ParentObject != null)
                    {
                        String OutputJSON = JSON.serialize(ParentObject);
                        IntReqJSONRepresentations.put(IntReq.Id,OutputJSON);
                    }
                }
                catch(QueryException qe)
                {
                    IntReq.addError('No record with the Id '+ IntReq.Object_Id__c + ' exists in the '+ IntReq.Object_Name__c + ' object. Please enter a valid Id.');
                }
            }
        }
        
        return IntReqJSONRepresentations;
    }
    
    /*************************************************************************************************************
    * Name        : GetsObjectFromJSONRepresentation
    * Description : Get the Integration Request parent sObject from the JSON Representation
    * Input       : IntReqList - List of Integration Request record completed
    * Output      : Map with the corresponding sObject per Integration Request Id
    *************************************************************************************************************/
    public static Map<ID,sObject> GetsObjectFromJSONRepresentation(List<Integration_Request__c> IntReqList)
    {
        Map<ID,sObject> ParentsObjectMap = new Map<ID,sObject>();
        
        // Loop the input Integration Request records to get the Parent sObject from the JSON representation
        for(Integration_Request__c IntReq :IntReqList)
        {
            try{
                if((IntReq.Object_Original__c != null)&&(IntReq.Object_Original__c != ''))
                {
                    sObject ParentObject = (sObject)JSON.deserialize(IntReq.Object_Original__c, sObject.class);
                    ParentsObjectMap.put(IntReq.Id, ParentObject);
                }
            }
            catch(Exception e)
            {
                
            }
        }
        
        return ParentsObjectMap;
    }


    /*************************************************************************************************************
    * Name        : SetStatusBasedSystemResponse
    * Description : Method that hold the logic to set the integration request based on system response
    * Input       : IntReqList - List of Integration Request record completed
    * Output      : None
    *************************************************************************************************************/
    public static void SetStatusBasedSystemResponse(List<Integration_Request__c> IntReqList)
    {
        
        System.debug('INT_DEBUG: Calling SetStatusBasedSystemResponse');
        
        Map<Id, Integration_Request__c> mapIntReq = new Map<Id, Integration_Request__c>();
        Map<String, String> mapEventSystem = new Map<String, String>();
        Map<Id, String> mapIntReqComp = new Map<Id, String>();

        
        for(Integration_Request__c intReq :IntReqList)
        {
            if(intReq.check_responses__c)
            {
                intReq.check_responses__c = false;
                intReq.Status__c = 'Received';
                mapIntReq.put(intReq.Id, intReq);
            }
        }
        

        if(!mapIntReq.isEmpty())
        {

             System.debug('INT_DEBUG: Integration Requests to be Updated');
            
            List<System_Response__c> listSysResp = [SELECT Id, External_System__c, Error_Code__c, Error_Message__c, Status__c, Integration_Request__c
             FROM System_Response__c WHERE Integration_Request__c IN :mapIntReq.keySet()
             ORDER BY Integration_Request__c, External_System__c];

           

             if(listSysResp == null || listSysResp.isEmpty() ) return;

             List<Integration_Framework_Configuration__c> listConfig = [SELECT Event__c, Geo__c, LoB__c, Market__c, Sub_Event__c, System_1__c, System_2__c
              FROM Integration_Framework_Configuration__c ];

            if(listConfig == null || listConfig.isEmpty() ) return;

            for(Integration_Framework_Configuration__c config : listConfig)
            {
                String eventKey = config.Geo__c + config.LoB__c + config.Market__c + config.Event__c + config.Sub_Event__c;
                String eventSystem = (config.System_2__c ==null) ? config.System_1__c : config.System_1__c + config.System_2__c;
                mapEventSystem.put(eventKey,eventSystem);
            }             

             for(System_Response__c resp : listSysResp)
             {
                Id intId = resp.Integration_Request__c;

                Integration_Request__c intreq = mapIntReq.get(intId);

                if(mapIntReqComp.containsKey(intId))
                {
                    mapIntReqComp.put(intId,mapIntReqComp.get(intId) + resp.External_System__c);
                }else
                {
                     mapIntReqComp.put(intId, resp.External_System__c);
                }

                if(resp.Status__c == 'Technical Error' || resp.Status__c == 'Functional Error' )
                {
                    if(intreq.Status__c != 'Technical Error')
                    { 
                        intreq.Status__c = resp.Status__c;
                        intreq.Error_Code__c = resp.Error_Code__c;
                        intreq.Error_Description__c = resp.Error_Message__c;
                    }
                }

             }

             for(Id intReqId : mapIntReq.keySet())
             {
                Integration_Request__c intreq = mapIntReq.get(intReqId);

                if(intReq.Status__c =='Received')
                {
                    String sysToComplete =  intreq.Geo__c + intreq.LoB__c + intreq.Market__c + intreq.Event__c + intreq.Sub_Event__c;
                    
                    String systems = mapEventSystem.get(sysToComplete);
                    System.debug( 'INT_DEBUG: systems:' + systems);   

                    String systemConcat = mapIntReqComp.get(intReqId);
                    System.debug( 'INT_DEBUG: systemConcat:' + systemConcat); 
                    

                    if(systems != null && systems == systemConcat)
                    {
                         intreq.Status__c = 'Completed';
                        intreq.Error_Code__c = '';
                         intreq.Error_Description__c = '';
                    }
                }

                System.debug('INT_DEBUG: Integration Requests [' + intreq.Id +'] updated with status: ' + intreq.Status__c);

             }

        }
        
        
    }


     /*************************************************************************************************************
    * Name        : retreiveIntegrationRequest
    * Description : Method used to retreive a single Integration Request by a single Id
    * Input       : Integration Request Id
    * Output      : A Single integration Request
    *************************************************************************************************************/
    public static Integration_Request__c retreiveIntegrationRequest(Id id)
    {
        List<id> ids = new List<id>();
        ids.add(id);

        List<Integration_Request__c> output = retreiveIntegrationRequests(ids);

        if( output != null && output.size() > 0)
        {
            return output.get(0);
        }

        return null;
    }

    /*************************************************************************************************************
    * Name        : retreiveIntegrationRequest
    * Description : Method used to retreive multiple Integration Request by a list of Ids
    * Input       : List of Integration Request Ids
    * Output      : List integration Request
    *************************************************************************************************************/
    public static List<Integration_Request__c> retreiveIntegrationRequests(List<id> ids)
    {

        Set<String> setFields  = Integration_Request__c.sObjectType.getDescribe().fields.getMap().keySet();

        List<String> fields = new List<String>(setFields);

        String strQuery = 'SELECT ';

        for(Integer i = 0; i < fields.size(); i++)
        {
            strQuery = strQuery + fields[i];

            if(i < fields.size() -1)
            {
                strQuery = strQuery + ', ';
            }
        }  

        strQuery = strQuery + ' FROM Integration_Request__c WHERE Id IN: ids';

        return (List<Integration_Request__c>)Database.query(strQuery);
    }


    /*************************************************************************************************************
    * Name        : validExternalSystem
    * Description : Method return if the system is a valid external system for integration request
    * Input       : intergrationRequest that will be checked if the externalSystem valid
    * Output      : true if the system is valid
    *************************************************************************************************************/
    public static Boolean validExternalSystem(Integration_Request__c intergrationRequest , String externalSystem )
    {

        Map<String,Integration_Framework_Configuration__c> configurations = retreiveConfiguration();

        Integration_Framework_Configuration__c configuration = configurations.get(getKeyCombination(intergrationRequest));

        
        // if there is no configuration the validation return false
        if(configuration == null)
        {
            System.debug('No Configuration found for :' + intergrationRequest);
            return false;
        }

        //if the event does not have system configuraded the solution will accept any system

        if((configuration.System_1__c == null ||  configuration.System_1__c == '') && (externalSystem ==null  || externalSystem == ''))
        {
            return true;
        }


        if(configuration.System_1__c == externalSystem || configuration.System_2__c == externalSystem )
        {
            return true;
        }

        return false;
    }

    /*************************************************************************************************************
    * Name        : getKeyCombination
    * Description : Method used to retreive a unique key for the object, this is an util method
    * Input       : Object holding the information that will be used to generate the code.
    * Output      : String key combination
    *************************************************************************************************************/
    static String getKeyCombination(SObject inObject)
    {

        Schema.SObjectType configType= Schema.Integration_Framework_Configuration__c.getSObjectType();
        Schema.SObjectType RequestType = Schema.Integration_Request__c.getSObjectType();

        if(inObject.getSObjectType() == RequestType)
        {
            Integration_Request__c input = (Integration_Request__c) inObject;
            return input.Event__c+input.Sub_Event__c+input.Geo__c+input.LoB__c+input.Market__c;
           
        }

        if(inObject.getSObjectType() == configType)
        {
            Integration_Framework_Configuration__c input = (Integration_Framework_Configuration__c) inObject;

            return input.Event__c+input.Sub_Event__c+input.Geo__c+input.LoB__c+input.Market__c;
        }

        return null;   
    }

     /*************************************************************************************************************
    * Name        : retreiveConfiguration
    * Description : Method return eventsconfiguration
    * Input       : none
    * Output      : map with event configuration
    *************************************************************************************************************/
    static Map<String,Integration_Framework_Configuration__c> retreiveConfiguration()
    {
        if(configs != null)
        {
            return configs;
        }
      
        List<Integration_Framework_Configuration__c> listConfig =
            [SELECT Event__c,Geo__c,LoB__c,Market__c,Sub_Event__c,System_1__c,System_2__c 
            FROM Integration_Framework_Configuration__c];

        Map<String,Integration_Framework_Configuration__c> output =  new Map<String,Integration_Framework_Configuration__c>();

        for(Integration_Framework_Configuration__c config:listConfig)
        {
            output.put(getKeyCombination(config), config);
        }    

        return output;
    }


    /*************************************************************************************************************
    * Name        : retreiveListOfStatus
    * Description : Method returns ist of active status for Integration Request Object
    * Input       : none
    * Output      : list of active status for Integration Request Object
    *************************************************************************************************************/
    public static Set<String> retreiveListOfStatus()
    {
        Set<String> output = new Set<String>();

        Schema.DescribeFieldResult fieldResult = Integration_Request__c.Status__c.getDescribe();

        List<Schema.PicklistEntry> listStatus = fieldResult.getPicklistValues();

        for(Schema.PicklistEntry entry: listStatus)
        {
          if(entry.isActive())
          {
            output.add(entry.getLabel());
          }

        }

        return output;

    }


}