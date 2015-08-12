trigger TestTrigger1 on TestObject1__c (after insert) {
TestObject2__c obj = new TestObject2__c();
 obj.Name ='Test Name';  
    insert obj;
}