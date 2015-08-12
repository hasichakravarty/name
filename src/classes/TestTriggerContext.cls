@isTest
private class TestTriggerContext {
    public static testMethod void myUnitTest() {
        Test.startTest();
        AccountTriggerHandler ath = new AccountTriggerHandler(false,0);
        boolean bIsTriggerContext = ath.bIsTriggerContext;
        boolean bIsVisualforcePageContext = ath.bIsVisualforcePageContext;
        boolean bIsWebServiceContext = ath.bIsWebServiceContext;
        boolean bIsExecuteAnonymousContext = ath.bIsExecuteAnonymousContext;
        
        AccountContactTriggerHandler acth = new AccountContactTriggerHandler(false,0);
        bIsTriggerContext = acth.bIsTriggerContext;
        bIsVisualforcePageContext = acth.bIsVisualforcePageContext;
        bIsWebServiceContext = acth.bIsWebServiceContext;
        bIsExecuteAnonymousContext = acth.bIsExecuteAnonymousContext;
        
        RelatedCourseTriggerHandler rcth = new RelatedCourseTriggerHandler(false,0);
        bIsTriggerContext = rcth.bIsTriggerContext;
        bIsVisualforcePageContext = rcth.bIsVisualforcePageContext;
        bIsWebServiceContext = rcth.bIsWebServiceContext;
        bIsExecuteAnonymousContext = rcth.bIsExecuteAnonymousContext;
        
        RelationshipTriggerHandler rth = new RelationshipTriggerHandler(false,0);
        bIsTriggerContext = rth.bIsTriggerContext;
        bIsVisualforcePageContext = rth.bIsVisualforcePageContext;
        bIsWebServiceContext = rth.bIsWebServiceContext;
        bIsExecuteAnonymousContext = rth.bIsExecuteAnonymousContext;
        
        LeadTriggerHandler lth = new LeadTriggerHandler(false,0);
        bIsTriggerContext = lth.bIsTriggerContext;
        bIsVisualforcePageContext = lth.bIsVisualforcePageContext;
        bIsWebServiceContext = lth.bIsWebServiceContext;
        bIsExecuteAnonymousContext = lth.bIsExecuteAnonymousContext;
        
        CallAttendeeTriggerHandler cath = new CallAttendeeTriggerHandler(false,0);
        bIsTriggerContext = cath.bIsTriggerContext;
        bIsVisualforcePageContext = cath.bIsVisualforcePageContext;
        bIsWebServiceContext = cath.bIsWebServiceContext;
        bIsExecuteAnonymousContext = cath.bIsExecuteAnonymousContext;
        
        ContactTriggerHandler cth = new ContactTriggerHandler(false,0);
        bIsTriggerContext = cth.bIsTriggerContext;
        bIsVisualforcePageContext = cth.bIsVisualforcePageContext;
        bIsWebServiceContext = cth.bIsWebServiceContext;
        bIsExecuteAnonymousContext = cth.bIsExecuteAnonymousContext;
      
        CallTriggerHandler callth = new CallTriggerHandler(false,0);
        bIsTriggerContext = callth.bIsTriggerContext;
        bIsVisualforcePageContext = callth.bIsVisualforcePageContext;
        bIsWebServiceContext = callth.bIsWebServiceContext;
        bIsExecuteAnonymousContext = callth.bIsExecuteAnonymousContext;
        
        EventTriggerHandler eth = new EventTriggerHandler(false,0);
        bIsTriggerContext = eth.bIsTriggerContext;
        bIsVisualforcePageContext = eth.bIsVisualforcePageContext;
        bIsWebServiceContext = eth.bIsWebServiceContext;
        bIsExecuteAnonymousContext = eth.bIsExecuteAnonymousContext;
        
        OrderTriggerHandler oth = new OrderTriggerHandler(false,0);
        bIsTriggerContext = oth.bIsTriggerContext;
        bIsVisualforcePageContext = oth.bIsVisualforcePageContext;
        bIsWebServiceContext = oth.bIsWebServiceContext;
        bIsExecuteAnonymousContext = oth.bIsExecuteAnonymousContext;
        
        OrderLineItemTriggerHandler olith = new OrderLineItemTriggerHandler(false,0);
        bIsTriggerContext = olith.bIsTriggerContext;
        bIsVisualforcePageContext = olith.bIsVisualforcePageContext;
        bIsWebServiceContext = olith.bIsWebServiceContext;
        bIsExecuteAnonymousContext = olith.bIsExecuteAnonymousContext;        
        
        ProductTriggerHandler pth = new ProductTriggerHandler(false,0);
        bIsTriggerContext = pth.bIsTriggerContext;
        bIsVisualforcePageContext = pth.bIsVisualforcePageContext;
        bIsWebServiceContext = pth.bIsWebServiceContext;
        bIsExecuteAnonymousContext = pth.bIsExecuteAnonymousContext;
                  
        OpportunityTriggerHandler oppth = new OpportunityTriggerHandler(false,0);
        bIsTriggerContext = oppth.bIsTriggerContext;
        bIsVisualforcePageContext = oppth.bIsVisualforcePageContext;
        bIsWebServiceContext = oppth.bIsWebServiceContext;
        bIsExecuteAnonymousContext = oppth.bIsExecuteAnonymousContext;
        
        OpportunityLineItemTriggerHandler opplith = new OpportunityLineItemTriggerHandler(false,0);
        bIsTriggerContext = opplith.bIsTriggerContext;
        bIsVisualforcePageContext = opplith.bIsVisualforcePageContext;
        bIsWebServiceContext = opplith.bIsWebServiceContext;
        bIsExecuteAnonymousContext = opplith.bIsExecuteAnonymousContext;
    }
}