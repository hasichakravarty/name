/*
 *Author: Matt Hime (tquila)
 *Date: 21/8/2012
 *Description:	Small test class to test the CourseSearchGlobalSearchResult component.  The component controller accepts an array (possibly empty)
 *				of PearsonCourseStructure__c objects and returns the count and a flag (ShowResults) indicating if there's data to display.
 *
 *				Data displayed can be selected and therefore has an isSelected flag which can be queried.
 */
 
@isTest
private class CourseSearchGSRControllerTester {


	/*
	 *The component accepts an array and returns the count and a flag indicating data found
	 */
    static testMethod void testFeedPopulatedDataToComponent() {
		PearsonCourseStructure__c[] tier1 = TestData.buildPearsonCourseStructure(null, 10, 'Discipline', 'DIS');
		
		CourseSearchGlobalSearchResultController controller = new CourseSearchGlobalSearchResultController();
		
		Test.startTest();
		
		system.assertEquals(null, controller.ShowResults);
		
		controller.InboundResults = tier1;
		system.assertEquals(true, controller.ShowResults);
		system.assertEquals(10, controller.Count);
		
		Test.stopTest();
    }

	/*
	 *The component should be able to accept an empty array and hide itself from displaying on the page
	 */
    static testMethod void testFeedUnPopulatedDataToComponent() {
		PearsonCourseStructure__c[] tier1 = new PearsonCourseStructure__c[]{};
		
		CourseSearchGlobalSearchResultController controller = new CourseSearchGlobalSearchResultController();
		
		Test.startTest();
		
		system.assertEquals(null, controller.ShowResults);
		
		controller.InboundResults = tier1;
		system.assertEquals(false, controller.ShowResults);
		system.assertEquals(0, controller.Count);
		
		Test.stopTest();
    }

	/*
	 *Users can tick displayed items for selection,  each item must be ticked individually in order to be selected
	 */
    static testMethod void testSelectData() {
		PearsonCourseStructure__c[] tier1 = TestData.buildPearsonCourseStructure(null, 2, 'Discipline', 'DIS');
		
		CourseSearchGlobalSearchResultController controller = new CourseSearchGlobalSearchResultController();
		
		Test.startTest();
		
		controller.InboundResults = tier1;
		
		controller.Results[0].isSelected = true;
		system.assertEquals(true, controller.Results[0].isSelected);
		system.assertEquals(false, controller.Results[1].isSelected);
		
		Test.stopTest();
    }
    
}