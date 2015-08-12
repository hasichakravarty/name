@isTest
public class oneCRMDeletePearsonChoicesBatchTest{
static testMethod void testDeletePearsonChoices()
{
    List<Pearson_Choice__c> listWithPearsonChoice = new List<Pearson_Choice__c>();
    listWithPearsonChoice  = TestDataFactory.returnPearsonChoice();
    Test.StartTest();
    if(listWithPearsonChoice  != null && !listWithPearsonChoice.isEmpty())
    {
        insert listWithPearsonChoice;
    }
    Database.executeBatch(new oneCRMDeletePearsonChoicesBatch(),200);
    
    oneCRMDeletePearsonChoicesBatch pearsonChoiceDelete = new oneCRMDeletePearsonChoicesBatch();
    String sch = '0 0 23 * * ?'; 
    system.schedule('Pearson Choice Delete Test', sch, pearsonChoiceDelete); 
    Test.stopTest(); 
}

}