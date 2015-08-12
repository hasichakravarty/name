/*******************************************************************************************************************
* Apex Class Name  : ActionFrameworkPlugin
* Version          : 1.0 
* Created Date     : 19 March 2015
* Function         : Plugin of the ActionFramework functinality to use in flows
* Modification Log :
*
* Developer                   Date                    Description
* ------------------------------------------------------------------------------------------------------------------
*                          19/03/2015                 Created Initial Version
*******************************************************************************************************************/
global without sharing class ActionFrameworkPlugin implements Process.Plugin
{

   global Process.PluginResult invoke(Process.PluginRequest request)
   {   
        String TemplateName = (String)request.inputParameters.get('TemplateName');
        String ParentObjectType = (String)request.inputParameters.get('ParentObjectType');
        String ParentObjectID = (String)request.inputParameters.get('ParentObjectID');
   
       Map<String,Object> result = new Map<String,Object>();
       
       result = GenerateActions(TemplateName, ParentObjectType ,ParentObjectID);
       
       return new Process.PluginResult(result);
   }
   
   /*************************************************************************************************************
    * Description : Returns the describe information for the interface (input parameters, output paramenters)
    *************************************************************************************************************/
   global Process.PluginDescribeResult describe()
   {
        // Set up plugin metadata
        Process.PluginDescribeResult result = new Process.PluginDescribeResult();
        result.description = 'The Action Framework plugin generate action records related with the parent object provided based on the specified action template definition';
        result.tag = 'Action Framework';
        
        // Define plugin input parameters
        result.inputParameters = new List<Process.PluginDescribeResult.InputParameter>
        {
                // Template Name
                new Process.PluginDescribeResult.InputParameter('TemplateName', Process.PluginDescribeResult.ParameterType.STRING, true),
                // Parent Object Type
                new Process.PluginDescribeResult.InputParameter('ParentObjectType', Process.PluginDescribeResult.ParameterType.STRING, true),
                // Parent Object Id
                new Process.PluginDescribeResult.InputParameter('ParentObjectID', Process.PluginDescribeResult.ParameterType.STRING, true)
        };
        
        // Define plugin output parameters
        result.outputParameters = new List<Process.PluginDescribeResult.OutputParameter>
        {
            // Actions Inserted
            new Process.PluginDescribeResult.OutputParameter('ActionsInserted', Process.PluginDescribeResult.ParameterType.BOOLEAN),
            // Result Message
            new Process.PluginDescribeResult.OutputParameter('ResultMessage', Process.PluginDescribeResult.ParameterType.STRING)
        };
        
        return result;
    }
   
    /*************************************************************************************************************
    * Name        : GenerateActions
    * Description : Insert Action records related with the specified object id based on the action template
    * Input       : ActionTemplateName (String) - Name of the action template
    *               ParentObjectTypeName (String) - Type of parent object
    *               ParentObjectId (String) - Id of the parent object
    * Output      : Message with the result of the action generation ( 'Suscess' if the action where successfully inserted)
    *************************************************************************************************************/
    public Map<String,Object> GenerateActions(String ActionTemplateName, String ParentObjectType, String ParentObjectId){
    
        try
        {
            Map<String,Object> result = new Map<String,Object>();
            
            String resultMessage = 'Success';
            
            // Get the list of items related with the actions template
            List<ActionTemplateItem__c> TemplateItemsList = [SELECT Id, Sequence__c, Title__c, Description__c, TimeToComplete__c, AssignToType__c, User__c, QueueName__c  FROM ActionTemplateItem__c WHERE TemplateName__c =:ActionTemplateName AND ParentObjectType__c=:ParentObjectType];
            
            // Get the list of available queues
            Map<String,QueueSobject> mapAvailableQueues = GetAvailableQueues('Action__c');
            
            // Get the list of active users
            List<User> ActiveUserList = [SELECT Id, Username FROM User WHERE IsActive = true];  
            Map<ID,User> mapActiveUsers = new Map<ID,User>(ActiveUserList);
            
            // Get the Action active record type
            List<RecordType> ActionActiveRecordTypesList = [SELECT Id FROM RecordType WHERE SobjectType = 'Action__c' AND DeveloperName = 'Default_Action'];
                        
            List<Action__c> ActionsToInsert = new List<Action__c>();
            
            // Generate the actions
            for(ActionTemplateItem__c item :TemplateItemsList)
            {
                Action__c act = new Action__c();
                
                act.Template__c = ActionTemplateName;
                act.Title__c = item.Title__c;
                act.Description__c = item.Description__c;
                act.Status__c = 'New';
                act.Sequence__c = item.Sequence__c;
                
                if(ActionActiveRecordTypesList.size()>0)
                {
                    act.RecordTypeId = ActionActiveRecordTypesList.get(0).Id;
                }
                //Define the time to complete the action
                if((item.TimeToComplete__c != null)&&(item.TimeToComplete__c <> 0))
                {
                    act.DueTo__c = DateTime.Now().addMinutes(Integer.valueOf(item.TimeToComplete__c));
                }
                
                //Define the owner
                if(item.AssignToType__c == 'User')
                {
                    if(mapActiveUsers.containsKey(item.User__c))
                    {
                       act.OwnerId = mapActiveUsers.get(item.User__c).Id;
                    }
                }
                else if(item.AssignToType__c == 'Queue')
                {
                    if(mapAvailableQueues.containsKey(item.QueueName__c))
                    {
                       act.OwnerId = mapAvailableQueues.get(item.QueueName__c).QueueId;
                    }
                }
                else
                {
                    act.OwnerId = UserInfo.getUserId();
                }
                
                // Define Parent Object
                if(ParentObjectType == 'Account')
                {
                    List<Account> accnts = [SELECT Id FROM Account WHERE Id =:ParentObjectId];
                    
                    if(accnts.size()>0){
                        act.Account__c = accnts.get(0).Id;
                    }
                }
                else if(ParentObjectType == 'Contact')
                {
                    List<Contact> conts = [SELECT Id FROM Contact WHERE Id =:ParentObjectId];
                    
                    if(conts.size()>0){
                        act.Contact__c= conts.get(0).Id;
                    }
                }
                else if(ParentObjectType == 'Case')
                {
                    List<Case> cases = [SELECT Id FROM Case WHERE Id =:ParentObjectId];
                    
                    if(cases.size()>0){
                        act.Case__c = cases.get(0).Id;
                    }
                }
                else if(ParentObjectType == 'Lead')
                {
                    List<Lead> leads = [SELECT Id FROM Lead WHERE Id =:ParentObjectId];
                    
                    if(leads.size()>0){
                        act.Lead__c= leads.get(0).Id;
                    }
                }
                else if(ParentObjectType == 'Opportunity')
                {
                    List<Opportunity> opps = [SELECT Id FROM Opportunity WHERE Id =:ParentObjectId];
                    
                    if(opps.size()>0){
                        act.Opportunity__c = opps.get(0).Id;
                    }
                }    
                
                ActionsToInsert.add(act);
            }
            
            if(ActionsToInsert.size()>0)
            {
                insert ActionsToInsert;
            }
            
            
            result.put('ActionsInserted',true);
            result.put('ResultMessage',resultMessage);
            return result;
        }
        catch(Exception e)
        {
            Map<String,Object> result = new Map<String,Object>();
            String resultMessage = e.getMessage();
            result.put('ActionsInserted',false);
            result.put('ResultMessage',resultMessage);
            return result;
        }

    }
   
    /*************************************************************************************************************
    * Name        : GetAvailableQueues
    * Description : Retrieve the a map with the available queues for the specified object type
    * Input       : ObjectType (String) - Type of object
    * Output      : Map with the queue object by name
    *************************************************************************************************************/
    public Map<String,QueueSobject> GetAvailableQueues(String ObjectType)
    {
        Map<String,QueueSobject> mapAvailableQueues = new Map<String,QueueSobject>();
            
        List<QueueSobject> QueueList = [SELECT Id, QueueId, Queue.Name FROM QueueSobject WHERE SobjectType =:ObjectType];
            
        for( QueueSobject q :QueueList)
        {
            if(mapAvailableQueues.containsKey(q.Queue.Name)== false){
                mapAvailableQueues.put(q.Queue.Name,q);
            }
        }    
           
        return mapAvailableQueues;
    }

}