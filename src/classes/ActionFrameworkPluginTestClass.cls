/*******************************************************************************************************************
* Apex Class Name  : ActionFrameworkPluginTestClass
* Version          : 1.0 
* Created Date     : 19 March 2015
* Function         : Test Class of the ActionFrameworkPlugin Class
* Modification Log :
*
* Developer                   Date                    Description
* ------------------------------------------------------------------------------------------------------------------
*                             19/03/2015              Created Initial Version
*******************************************************************************************************************/
@isTest                   
private class ActionFrameworkPluginTestClass
{
    /*************************************************************************************************************
    * Name        : AccountActionsInsertionTest
    * Description : Verify the insertion of actions related to an account using the Action Framework Plugin    
    * Input       : 
    * Output      : 
    *************************************************************************************************************/
    static testMethod void AccountActionsInsertionTest()
    {
        //Generate an account
        Account acc = new Account(Name = 'Account 1');
        insert acc;
    
        //Generate Action Template Items
        List<ActionTemplateItem__c> ActionTemplateItemsInserted1 = GenerateActionTemplateItems(10, 'Account', 'User', 30,'Template 1');
        List<ActionTemplateItem__c> ActionTemplateItemsInserted2 = GenerateActionTemplateItems(10, 'Account', 'Queue', 30,'Template 1');
        List<ActionTemplateItem__c> ActionTemplateItemsInserted3 = GenerateActionTemplateItems(10, 'Account', '', 30,'Template 1');
        
        List<ActionTemplateItem__c> ActionTemplateItemsInserted = new List<ActionTemplateItem__c>();
        ActionTemplateItemsInserted.addAll(ActionTemplateItemsInserted1);
        ActionTemplateItemsInserted.addAll(ActionTemplateItemsInserted2);
        ActionTemplateItemsInserted.addAll(ActionTemplateItemsInserted3);
        
        // Define Plugin input and output parameters
        ActionFrameworkPlugin actionPlugin = new ActionFrameworkPlugin();
        Map<String,Object> inputParams = new Map<String,Object>();
        Map<String,Object> outputParams = new Map<String,Object>();

        inputParams.put('TemplateName','Template 1');
        inputParams.put('ParentObjectType', 'Account');
        inputParams.put('ParentObjectID', acc.Id);

        // Execute the plugin
        test.startTest();
        Process.PluginRequest request = new Process.PluginRequest(inputParams);
        Process.PluginResult result;
        result = actionPlugin.invoke(request);
        test.stopTest();

        System.debug('ERROR MESSAGE '+result.OutputParameters.get('ResultMessage'));
        
        // Check that the plugin execution is successfull
        System.Assert(Boolean.valueOf(result.OutputParameters.get('ActionsInserted')),true);
        System.assertEquals(String.valueOf(result.OutputParameters.get('ResultMessage')),'Success');
    }  
    
    /*************************************************************************************************************
    * Name        : ContactActionsInsertionTest
    * Description : Verify the insertion of actions related to a contact using the Action Framework Plugin    
    * Input       : 
    * Output      : 
    *************************************************************************************************************/
    static testMethod void ContactActionsInsertionTest()
    {
        //Generate an account
        Account acc = new Account(Name = 'Account 1');
        insert acc;
        
        //Generate contact
        Contact con = new Contact(LastName = 'Contact 1', Email = 'test@test.com.demo', AccountId = acc.Id);
        insert con;
    
        //Generate Action Template Items
        List<ActionTemplateItem__c> ActionTemplateItemsInserted1 = GenerateActionTemplateItems(10, 'Contact', 'User', 30,'Template 1');
        List<ActionTemplateItem__c> ActionTemplateItemsInserted2 = GenerateActionTemplateItems(10, 'Contact', 'Queue', 30,'Template 1');
        
        List<ActionTemplateItem__c> ActionTemplateItemsInserted = new List<ActionTemplateItem__c>();
        ActionTemplateItemsInserted.addAll(ActionTemplateItemsInserted1);
        ActionTemplateItemsInserted.addAll(ActionTemplateItemsInserted2);
        
        // Define Plugin input and output parameters
        ActionFrameworkPlugin actionPlugin = new ActionFrameworkPlugin();
        Map<String,Object> inputParams = new Map<String,Object>();
        Map<String,Object> outputParams = new Map<String,Object>();

        inputParams.put('TemplateName','Template 1');
        inputParams.put('ParentObjectType', 'Contact');
        inputParams.put('ParentObjectID', con.Id);

        // Execute the plugin
        test.startTest();
        Process.PluginRequest request = new Process.PluginRequest(inputParams);
        Process.PluginResult result;
        result = actionPlugin.invoke(request);
        test.stopTest();

        System.debug('ERROR MESSAGE '+result.OutputParameters.get('ResultMessage'));
        
        // Check that the plugin execution is successfull
        System.assertEquals(Boolean.valueOf(result.OutputParameters.get('ActionsInserted')),true);
        System.assertEquals(String.valueOf(result.OutputParameters.get('ResultMessage')),'Success');
    }  
    
    /*************************************************************************************************************
    * Name        : CaseActionsInsertionTest
    * Description : Verify the insertion of actions related to a case using the Action Framework Plugin    
    * Input       : 
    * Output      : 
    *************************************************************************************************************/
    static testMethod void CaseActionsInsertionTest()
    {
        //Generate an account
        Account acc = new Account(Name = 'Account 1');
        insert acc;
        
        //Generate contact
        Contact con = new Contact(LastName = 'Contact 1', Email = 'test@test.com.demo', AccountId = acc.Id);
        insert con;
        
        //Generate case
        Case c = new Case( AccountId = acc.Id, ContactId = con.Id);
        insert c;
    
        //Generate Action Template Items
        List<ActionTemplateItem__c> ActionTemplateItemsInserted1 = GenerateActionTemplateItems(10, 'Case', 'User', 30,'Template 1');
        List<ActionTemplateItem__c> ActionTemplateItemsInserted2 = GenerateActionTemplateItems(10, 'Case', 'Queue', 30,'Template 1');
        
        List<ActionTemplateItem__c> ActionTemplateItemsInserted = new List<ActionTemplateItem__c>();
        ActionTemplateItemsInserted.addAll(ActionTemplateItemsInserted1);
        ActionTemplateItemsInserted.addAll(ActionTemplateItemsInserted2);
        
        // Define Plugin input and output parameters
        ActionFrameworkPlugin actionPlugin = new ActionFrameworkPlugin();
        Map<String,Object> inputParams = new Map<String,Object>();
        Map<String,Object> outputParams = new Map<String,Object>();

        inputParams.put('TemplateName','Template 1');
        inputParams.put('ParentObjectType', 'Case');
        inputParams.put('ParentObjectID', c.Id);

        // Execute the plugin
        test.startTest();
        Process.PluginRequest request = new Process.PluginRequest(inputParams);
        Process.PluginResult result;
        result = actionPlugin.invoke(request);
        test.stopTest();

        System.debug('ERROR MESSAGE '+result.OutputParameters.get('ResultMessage'));
        
        // Check that the plugin execution is successfull
        System.assertEquals(Boolean.valueOf(result.OutputParameters.get('ActionsInserted')),true);
        System.assertEquals(String.valueOf(result.OutputParameters.get('ResultMessage')),'Success');
    }  
    
    /*************************************************************************************************************
    * Name        : LeadActionsInsertionTest
    * Description : Verify the insertion of actions related to a lead using the Action Framework Plugin    
    * Input       : 
    * Output      : 
    *************************************************************************************************************/
    static testMethod void LeadActionsInsertionTest()
    {

        //Generate Lead
        Lead lead = new Lead( Company = 'Account 1', LastName = 'Contact 1');
        insert lead;
    
        //Generate Action Template Items
        List<ActionTemplateItem__c> ActionTemplateItemsInserted1 = GenerateActionTemplateItems(10, 'Lead', 'User', 30,'Template 1');
        List<ActionTemplateItem__c> ActionTemplateItemsInserted2 = GenerateActionTemplateItems(10, 'Lead', 'Queue', 30,'Template 1');
        
        List<ActionTemplateItem__c> ActionTemplateItemsInserted = new List<ActionTemplateItem__c>();
        ActionTemplateItemsInserted.addAll(ActionTemplateItemsInserted1);
        ActionTemplateItemsInserted.addAll(ActionTemplateItemsInserted2);
        
        // Define Plugin input and output parameters
        ActionFrameworkPlugin actionPlugin = new ActionFrameworkPlugin();
        Map<String,Object> inputParams = new Map<String,Object>();
        Map<String,Object> outputParams = new Map<String,Object>();

        inputParams.put('TemplateName','Template 1');
        inputParams.put('ParentObjectType', 'Lead');
        inputParams.put('ParentObjectID', lead.Id);

        // Execute the plugin
        test.startTest();
        Process.PluginRequest request = new Process.PluginRequest(inputParams);
        Process.PluginResult result;
        result = actionPlugin.invoke(request);
        test.stopTest();

        System.debug('ERROR MESSAGE '+result.OutputParameters.get('ResultMessage'));
        
        // Check that the plugin execution is successfull
        System.assertEquals(Boolean.valueOf(result.OutputParameters.get('ActionsInserted')),true);
        System.assertEquals(String.valueOf(result.OutputParameters.get('ResultMessage')),'Success');
    }
    
    /*************************************************************************************************************
    * Name        : OpportunityActionsInsertionTest
    * Description : Verify the insertion of actions related to an opportunity using the Action Framework Plugin    
    * Input       : 
    * Output      : 
    *************************************************************************************************************/
    static testMethod void OpporutniyActionsInsertionTest()
    {
        //Generate an account
        Account acc = new Account(Name = 'Account 1');
        insert acc;
        
        //Generate opportunity
        Opportunity opp = new Opportunity( Name = 'Opportunity', StageName = 'Prospecting', AccountId = acc.Id, CloseDate = System.Today());
        insert opp;
    
        //Generate Action Template Items
        List<ActionTemplateItem__c> ActionTemplateItemsInserted1 = GenerateActionTemplateItems(10, 'Opportunity', 'User', 30,'Template 1');
        List<ActionTemplateItem__c> ActionTemplateItemsInserted2 = GenerateActionTemplateItems(10, 'Opportunity', 'Queue', 30,'Template 1');
        
        List<ActionTemplateItem__c> ActionTemplateItemsInserted = new List<ActionTemplateItem__c>();
        ActionTemplateItemsInserted.addAll(ActionTemplateItemsInserted1);
        ActionTemplateItemsInserted.addAll(ActionTemplateItemsInserted2);
        
        // Define Plugin input and output parameters
        ActionFrameworkPlugin actionPlugin = new ActionFrameworkPlugin();
        Map<String,Object> inputParams = new Map<String,Object>();
        Map<String,Object> outputParams = new Map<String,Object>();

        inputParams.put('TemplateName','Template 1');
        inputParams.put('ParentObjectType', 'Opportunity');
        inputParams.put('ParentObjectID', opp.Id);

        // Execute the plugin
        test.startTest();
        Process.PluginRequest request = new Process.PluginRequest(inputParams);
        Process.PluginResult result;
        result = actionPlugin.invoke(request);
        test.stopTest();

        System.debug('ERROR MESSAGE '+result.OutputParameters.get('ResultMessage'));
        
        // Check that the plugin execution is successfull
        System.assertEquals(Boolean.valueOf(result.OutputParameters.get('ActionsInserted')),true);
        System.assertEquals(String.valueOf(result.OutputParameters.get('ResultMessage')),'Success');
    } 
    
    /*************************************************************************************************************
    * Name        : ErrorActionsInsertionTest
    * Description : Verify the error handle of an insertion of actions related to an account using the Action Framework Plugin    
    * Input       : 
    * Output      : 
    *************************************************************************************************************/
    static testMethod void ErrorActionsInsertionTest()
    {
        //Generate Action Template Items
        List<ActionTemplateItem__c> ActionTemplateItemsInserted1 = GenerateActionTemplateItems(10, 'Opportunity', 'User', 30,'Template 1');
        List<ActionTemplateItem__c> ActionTemplateItemsInserted2 = GenerateActionTemplateItems(10, 'Opportunity', 'Queue', 30,'Template 1');
        
        List<ActionTemplateItem__c> ActionTemplateItemsInserted = new List<ActionTemplateItem__c>();
        ActionTemplateItemsInserted.addAll(ActionTemplateItemsInserted1);
        ActionTemplateItemsInserted.addAll(ActionTemplateItemsInserted2);
        
        // Define Plugin input and output parameters
        ActionFrameworkPlugin actionPlugin = new ActionFrameworkPlugin();
        Map<String,Object> inputParams = new Map<String,Object>();
        Map<String,Object> outputParams = new Map<String,Object>();

        inputParams.put('TemplateName','Template 1');
        inputParams.put('ParentObjectType', 'Opportunity');
        inputParams.put('ParentObjectID', '');

        // Execute the plugin
        test.startTest();
        Process.PluginRequest request = new Process.PluginRequest(inputParams);
        Process.PluginResult result;
        result = actionPlugin.invoke(request);
        test.stopTest();

        System.debug('ERROR MESSAGE '+result.OutputParameters.get('ResultMessage'));
        
        // Check that the plugin execution is successfull
        System.assertEquals(Boolean.valueOf(result.OutputParameters.get('ActionsInserted')), false);
    } 
    
    /*************************************************************************************************************
    * Name        : describeTest
    * Description : Verify the definition of the Action Framework Plugin interface
    * Input       : 
    * Output      : 
    *************************************************************************************************************/
    static testMethod void describeTest() {

        ActionFrameworkPlugin actionPlugin = new ActionFrameworkPlugin();
        
        Process.PluginDescribeResult result = actionPlugin .describe();
        
        System.AssertEquals(result.inputParameters.size(), 3);
        System.AssertEquals(result.OutputParameters.size(), 2);
        System.AssertEquals(result.description ,  'The Action Framework plugin generate action records related with the parent object provided based on the specified action template definition');
        System.AssertEquals(result.tag , 'Action Framework');
        
     }
    
    public static List<ActionTemplateItem__c> GenerateActionTemplateItems(Integer NumberOfActionTemplateItems, String ParentObjectType, String OwnerType, Integer TimeToComplete, String TemplateName)
    {
        List<ActionTemplateItem__c> actTempItemsList = new List<ActionTemplateItem__c>();
        
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        
        List<User> ActiveUsers = [SELECT Id FROM User WHERE IsActive = true];
        
        System.runAs (thisUser){
            // Create a Queue
            GenerateQueue('Action__c', 'Queue 1');
            
            for(Integer i=0; i<NumberOfActionTemplateItems; i++)
            {
                ActionTemplateItem__c tempItem = new ActionTemplateItem__c();
                
                tempItem.ParentObjectType__c = ParentObjectType;
                tempItem.TemplateName__c = TemplateName;
                tempItem.Sequence__c = (i+1);
                tempItem.Title__c = 'Title ' + (i+1);
                tempItem.Description__c = 'Description ' + (i+1);
                tempItem.TimeToComplete__c = TimeToComplete;
                
                if(OwnerType == 'User')
                {
                    tempItem.AssignToType__c = OwnerType;
                    tempItem.User__c = ActiveUsers.get(0).Id;
                }
                else if(OwnerType == 'Queue')
                {
                    tempItem.AssignToType__c = OwnerType;
                    tempItem.QueueName__c = 'Queue 1';
                }
                
                actTempItemsList.add(tempItem);
            }
            
            if(actTempItemsList.size()>0){
                insert actTempItemsList;
            }
        }
                
        return actTempItemsList;
    }
    
    public static void GenerateQueue(String ObjectType, String QueueName)
    {
        Group g = new Group(Name=QueueName, Type='Queue');
        insert g;
            
        QueuesObject q = new QueueSObject(QueueID = g.Id, SobjectType = ObjectType);
        insert q;
    }
}