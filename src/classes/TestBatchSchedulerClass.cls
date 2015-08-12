@isTest(SeeAllData=TRUE)
public class TestBatchSchedulerClass{
public static testMethod void testMethodSample()
{
Test.StartTest();
PotentialTargetOpportunityCreationBatch b = new PotentialTargetOpportunityCreationBatch();
    list<Generate_Potential_Target__c> Queryq = new list<Generate_Potential_Target__c>();
    Queryq =[SELECT Account__c, Action__c, Author__c,Summer__c,Winter__c,Adoption_Type__c, Catalog_Code_Course_Name__c, Copyright_Year__c, Course__r.Mass_Sampling__c,Course__r.Summer_Enrollment__c,Course__r.Winter_Enrollment__c,Course__r.name, Fall__c, Fall_Frontlist__c,  Next_Edition__c,Next_Edition_Currency__c, Opportunity_Type__c, Primary_Selling_Account__c, Product__c,Product__r.CurrencyIsoCode , Product_In_Use__c, Product_In_Use_Publisher__c, Publisher__c, Id, Spring__c, Spring_Frontlist__c, Status__c,createdby.id FROM Generate_Potential_Target__c where Action__c =  'Create'  and Status__c =  'In Progress' and Processed__c = false];
    b.start(null);
    b.execute(null,Queryq);
    b.finish(null);    
database.executebatch(b);
Test.stopTest();
}
}