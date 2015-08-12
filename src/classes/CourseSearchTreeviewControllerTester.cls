/*
Name: Steven M. Giangrasso
Date: 08/15/2012
Description: Write a class that tests the methods in the CourseSearchTreeViewController class
*/
@isTest
private class CourseSearchTreeviewControllerTester {
	private static Opportunity opp;
	private static UniversityCourse__c uniCourse;
	private static PearsonCourseStructure__c[] tier1;
	private static PearsonCourseStructure__c[] tier2;
	private static PearsonCourseStructure__c[] tier3;


	/*
	This is the method that tests Attaching a person Course Structure to an Opportunity
	*/
    static testMethod void testAttachToOpportunity() {
    	buildTestData();
		
		//Get the page object and add opening parameters
		PageReference testPage = Page.CourseSearchTreeview; 
		//Page requires an object id (Opportunity or University Course)
		testPage.getParameters().put('Id', opp.id);
		//0 indicates opportunity, 1 indicates Universtity Course	
		testPage.getParameters().put('type', '0');	
		
		//Set the page as the one we'll be using for these tests
        Test.setCurrentPageReference(testPage);
        
        //Instantiate the controller
		CourseSearchTreeviewController controller = new CourseSearchTreeviewController();
		
		
		//start the test
		test.startTest();
		 
		 //Add selected node data
		 
		 //Stimulating someone double-clicking on the tree nodes
		 //Clicking on first node [0] in the tree view
		 controller.CourseId = tier1[0].Id;
		 controller.CourseName = tier1[0].Name;
		 controller.CourseType = tier1[0].Type__c;
		 
		 //Calling the StoreCourseData() after the JQuery is run
		 controller.StoreCourseData();
		 //flag that is used to display the results of your double-click
		 system.assert(controller.CourseDataSelected);
		 //comparison of the Selected Course size, size is the actual value being held on the controller
		 system.assertEquals(1, controller.SelectedCourses.size());
		 
		 
		 //referencing the Visualforce page; when Attach button is clicked, fires the Attach method on the controller
		 Pagereference pr = controller.Attach();
		 /*retrieves the URL of that Attachbutton,
		 use the parent object, opportunity or university, to return back to the parent
		 Pagereference has the getURL method to go back to the object you selected
		 put forward slash and object id to take us to the Opportunity page		 
		 */
		 system.assertEquals('/' + opp.Id, pr.getUrl());
		 
		 
		 //Building an array of the OpportunityPearsonCourseStructures to ensure the attach worked
		 OpportunityPearsonCourseStructure__c[] opcs = [select id 
		 												from OpportunityPearsonCourseStructure__c
		 												where Opportunity__c = :opp.Id
		 												and Pearson_Course_Structure__c = :tier1[0].Id];
		 												
        //Just check that the OpportunityPearsonCourseStructure__c exists,  the CourseSearchHelperTester checks that the correct one is assigned 		
		system.assertEquals(1, opcs.size());
		//terminating the test
		test.stopTest();
    }

	//Identical to method above, but using University instead of Opportunity
    static testMethod void testAttachToUniversity() {
    	buildTestData();
		
		//Get the page object and add opening parameters
		PageReference testPage = Page.CourseSearchTreeview; 
		testPage.getParameters().put('Id', uniCourse.id);	//Page requires an object id (Opportunity or University Course)
		testPage.getParameters().put('type', '1');	//0 indicates opportunity, 1 indicates Universtity Course
		
		//Set the page as the one we'll be using for these tests
        Test.setCurrentPageReference(testPage);
        
        //Instantiate the controller
		CourseSearchTreeviewController controller = new CourseSearchTreeviewController();
		
		test.startTest();
		 
		 //Add selected node data
		 controller.CourseId = tier1[0].Id;
		 controller.CourseName = tier1[0].Name;
		 controller.CourseType = tier1[0].Type__c;
		 
		 controller.StoreCourseData();
		 system.assert(controller.CourseDataSelected);
		 system.assertEquals(1, controller.SelectedCourses.size());
		 
		 Pagereference pr = controller.Attach();
		 system.assertEquals('/' + uniCourse.Id, pr.getUrl());
		 												
		 UniversityCoursePearsonCourseStructure__c[] upcs = [select UniversityCourse__c, PearsonCourseStructure__c
																from UniversityCoursePearsonCourseStructure__c
				 												where UniversityCourse__c = :uniCourse.Id];
		 												
        //Just check that the UniversityCoursePearsonCourseStructure__c exists,  the CourseSearchHelperTester checks that the correct one is assigned 		
		system.assertEquals(1, upcs.size());		
		
		test.stopTest();
    }

	//The user selects 4 items from the treeview and those values are stored in the array 
	//Selects the RemoveSelectedItems button and checks the selected course items and removes those selected courses
	//Tests the cherrypicking of courses
    static testMethod void testRemoveSelectedItems() {
    	buildTestData();
		
		//Get the page object and add opening parameters
		PageReference testPage = Page.CourseSearchTreeview; 
		testPage.getParameters().put('Id', uniCourse.id);	//Page requires an object id (Opportunity or University Course)
		testPage.getParameters().put('type', '1');	//0 indicates opportunity, 1 indicates Universtity Course
		
		//Set the page as the one we'll be using for these tests
        Test.setCurrentPageReference(testPage);
        
        //Instantiate the controller
		CourseSearchTreeviewController controller = new CourseSearchTreeviewController();
		
		test.startTest();
		
		//Tests selecting 2 courses to remove
		 
		 //Add selected node data
		 controller.CourseId = tier1[0].Id;
		 controller.CourseName = tier1[0].Name;
		 controller.CourseType = tier1[0].Type__c;
		 controller.StoreCourseData();
		 
		 //Add selected node data
		 controller.CourseId = tier2[0].Id;
		 controller.CourseName = tier2[0].Name;
		 controller.CourseType = tier2[0].Type__c;
		 controller.StoreCourseData();

		//Remove first item from list
		controller.SelectedCourses[0].isSelected = true;
		controller.RemoveItems();
		
		
		//Comparison of the SelectedCourse sizes and the courses that are being removed by the user
		system.assertEquals(1, controller.SelectedCourses.size());		
		//Comparison to ensure what is left in the list is the 2nd selected item because
		//we selected the first [0]
		system.assertEquals(tier2[0].Id, controller.SelectedCourses[0].PearsonCourseStructure.Id);
		system.assert(controller.CourseDataSelected);

		//Remove remaining item from list
		controller.SelectedCourses[0].isSelected = true;
		
		controller.RemoveItems();
		
		system.assertEquals(0, controller.SelectedCourses.size());		
		//Course Data selected in the controller/vf page is false because there is no data to display
		system.assertEquals(false, controller.CourseDataSelected);
		
		test.stopTest();
    }

	//Someone hits the PearsonCourse from the Universitypage and this is supposed to take them back to the University Course
    static testMethod void testCancelFromUniversity() {
    	//Calls the test data in the TestData class
    	buildTestData();
		
		//Get the page object and add opening parameters
		PageReference testPage = Page.CourseSearchTreeview; 
		testPage.getParameters().put('Id', uniCourse.id);	//Page requires an object id (Opportunity or University Course)
		testPage.getParameters().put('type', '1');	//0 indicates opportunity, 1 indicates Universtity Course
		
		//Set the page as the one we'll be using for these tests
        Test.setCurrentPageReference(testPage);
        
        //Instantiate the controller
		CourseSearchTreeviewController controller = new CourseSearchTreeviewController();
		
		test.startTest();

		Pagereference pr = controller.Cancel();
		//retrieves the URL for the University Course ID
		system.assertEquals('/' + uniCourse.Id, pr.getUrl());
		
		test.stopTest();
    }


	//Someone hits the PearsonCourse from the Opportunity and this is supposed to take them back to the Opportunity
    static testMethod void testCancelFromOpportunity() {
    	//Calls the data in the TestData.cls class
    	buildTestData();
		
		//Get the page object and add opening parameters
		PageReference testPage = Page.CourseSearchTreeview; 
		testPage.getParameters().put('Id', opp.id);	//Page requires an object id (Opportunity or University Course)
		testPage.getParameters().put('type', '0');	//0 indicates opportunity, 1 indicates Universtity Course
		
		//Set the page as the one we'll be using for these tests
        Test.setCurrentPageReference(testPage);
        
        //Instantiate the controller
		CourseSearchTreeviewController controller = new CourseSearchTreeviewController();
		
		test.startTest();

		Pagereference pr = controller.Cancel();
		system.assertEquals('/' + opp.Id, pr.getUrl());
		
		test.stopTest();
    }

    static testMethod void testSwitchToGlobalFromUniversity() {
    	buildTestData();
		
		//Get the page object and add opening parameters
		PageReference testPage = Page.CourseSearchTreeview; 
		testPage.getParameters().put('Id', uniCourse.id);	//Page requires an object id (Opportunity or University Course)
		testPage.getParameters().put('type', '1');	//0 indicates opportunity, 1 indicates Universtity Course
		
		//Set the page as the one we'll be using for these tests
        Test.setCurrentPageReference(testPage);
        
        //Instantiate the controller
		CourseSearchTreeviewController controller = new CourseSearchTreeviewController();
		
		test.startTest();

		Pagereference pr = controller.LoadGlobalSearchPage();
		system.assertEquals('/apex/CourseSearchGlobal?Id=' + uniCourse.Id + '&type=1', pr.getUrl());
		
		test.stopTest();
    }

	//swap from the TreeView search to the Global Search; hitting link to swap
    static testMethod void testSwitchToGlobalFromOpportunity() {
    	buildTestData();
		
		//Get the page object and add opening parameters
		PageReference testPage = Page.CourseSearchTreeview; 
		testPage.getParameters().put('Id', opp.id);	//Page requires an object id (Opportunity or University Course)
		testPage.getParameters().put('type', '0');	//0 indicates opportunity, 1 indicates Universtity Course
		
		//Set the page as the one we'll be using for these tests
        Test.setCurrentPageReference(testPage);
        
        //Instantiate the controller
		CourseSearchTreeviewController controller = new CourseSearchTreeviewController();
		
		test.startTest();

		Pagereference pr = controller.LoadGlobalSearchPage();
		//Checking that the page information returned contains the Opportunity ID, the Type indicator 
		//and that you're being sent to the correct CourseSearchGlobal page
		system.assertEquals('/apex/CourseSearchGlobal?Id=' + opp.Id + '&type=0', pr.getUrl());
		
		test.stopTest();
    }


	//Tests that if there is already a PearsonCourseStructure attached to the Opportunity then we don't create
	//a duplicate
    static testMethod void testAttachToOpportunityWithExistingPCS() {
    	buildTestData();
    	
    	//Add some OpportunityPearsonCourseStructure__c data to the opportunity
    	//add pre-existing piece
    	OpportunityPearsonCourseStructure__c existingPCS = new OpportunityPearsonCourseStructure__c();
    	//attach the existing piece
    	existingPCS.Opportunity__c = opp.Id;
    	existingPCS.Pearson_Course_Structure__c = tier3[0].Id;
    	insert existingPCS;
		
		//Get the page object and add opening parameters
		PageReference testPage = Page.CourseSearchTreeview; 
		testPage.getParameters().put('Id', opp.id);	//Page requires an object id (Opportunity or University Course)
		testPage.getParameters().put('type', '0');	//0 indicates opportunity, 1 indicates Universtity Course
		
		//Set the page as the one we'll be using for these tests
        Test.setCurrentPageReference(testPage);
        
        //Instantiate the controller
		CourseSearchTreeviewController controller = new CourseSearchTreeviewController();
		
		test.startTest();
		 
		 //Add selected node data; this is the new piece added
		 controller.CourseId = tier1[0].Id;
		 controller.CourseName = tier1[0].Name;
		 controller.CourseType = tier1[0].Type__c;
		 controller.StoreCourseData();
		 
		 //This is the existing PearsonCourseStructure created in the existing code above
		 controller.CourseId = tier3[0].Id;
		 controller.CourseName = tier3[0].Name;
		 controller.CourseType = tier3[0].Type__c;
		 controller.StoreCourseData();
		 
		 Pagereference pr = controller.Attach();
		 
		 //after testing data
		 
		 OpportunityPearsonCourseStructure__c[] opcs = [select id 
		 												from OpportunityPearsonCourseStructure__c
		 												where Opportunity__c = :opp.Id];
		 												
        //Just check that the OpportunityPearsonCourseStructure__c exists,  the CourseSearchHelperTester checks that the correct one is assigned 	
		system.assertEquals(2, opcs.size());
		
		test.stopTest();
    }


	//Tests that if there is already a PearsonCourseStructure attached to the Opportunity then we don't create
	//a duplicate
    static testMethod void testAttachToUniversityCourseWithExistingPCS() {
    	buildTestData();
    	
    	//Add some OpportunityPearsonCourseStructure__c data to the university course
    	UniversityCoursePearsonCourseStructure__c existingPCS = new UniversityCoursePearsonCourseStructure__c();
    	existingPCS.UniversityCourse__c = uniCourse.Id;
    	existingPCS.PearsonCourseStructure__c = tier3[0].Id;
    	insert existingPCS;
		
		//Get the page object and add opening parameters
		PageReference testPage = Page.CourseSearchTreeview; 
		testPage.getParameters().put('Id', uniCourse.id);	//Page requires an object id (Opportunity or University Course)
		testPage.getParameters().put('type', '1');	//0 indicates opportunity, 1 indicates Universtity Course
		
		//Set the page as the one we'll be using for these tests
        Test.setCurrentPageReference(testPage);
        
        //Instantiate the controller
		CourseSearchTreeviewController controller = new CourseSearchTreeviewController();
		system.assertEquals(1, controller.ExistingCourses.size());
		
		test.startTest();
		 
		 //Add selected node data
		 controller.CourseId = tier1[0].Id;
		 controller.CourseName = tier1[0].Name;
		 controller.CourseType = tier1[0].Type__c;
		 controller.StoreCourseData();
		 
		 controller.CourseId = tier3[0].Id;
		 controller.CourseName = tier3[0].Name;
		 controller.CourseType = tier3[0].Type__c;
		 controller.StoreCourseData();
		 
		 Pagereference pr = controller.Attach();
		 
		 UniversityCoursePearsonCourseStructure__c[] upcs = [select id 
				 												from UniversityCoursePearsonCourseStructure__c
				 												where UniversityCourse__c = :uniCourse.Id];	
		 												
        //Just check that the UniversityCoursePearsonCourseStructure__c exists,  the CourseSearchHelperTester checks that the correct one is assigned 	
		system.assertEquals(2, upcs.size());
		
		test.stopTest();
    }

	//What happens if you attempt to select the first node twice
    static testMethod void testSelectTheSamePCSTwice() {
    	buildTestData();
		
		//Get the page object and add opening parameters
		PageReference testPage = Page.CourseSearchTreeview; 
		testPage.getParameters().put('Id', uniCourse.id);	//Page requires an object id (Opportunity or University Course)
		testPage.getParameters().put('type', '1');	//0 indicates opportunity, 1 indicates Universtity Course
		
		//Set the page as the one we'll be using for these tests
        Test.setCurrentPageReference(testPage);
        
        //Instantiate the controller
		CourseSearchTreeviewController controller = new CourseSearchTreeviewController();
		
		test.startTest();
		 
		 //Add selected node data
		 controller.CourseId = tier1[0].Id;
		 controller.CourseName = tier1[0].Name;
		 controller.CourseType = tier1[0].Type__c;
		 controller.StoreCourseData();
		 
		 //The information selected courses size is 1
		 system.assertEquals(1, controller.SelectedCourses.size());
		 
		 controller.CourseId = tier1[0].Id;
		 controller.CourseName = tier1[0].Name;
		 controller.CourseType = tier1[0].Type__c;
		 controller.StoreCourseData();
		 
		 //attempting to add it again
		 system.assertEquals(1, controller.SelectedCourses.size());
		
		test.stopTest();
    }
    
    //These last 2 methods are helper methods for the class
    
    private static void buildTestData(){
    	// Delete data from custom setting if it exists and repopulate with values we're expecting
    	delete [select Id from PearsonCourseStructureSearchTypes__c];
    	List<PearsonCourseStructureSearchTypes__c> pcsst = new List<PearsonCourseStructureSearchTypes__c>
    		{	new PearsonCourseStructureSearchTypes__c(name='Discipline', Search_Sort_Order__c=1),
				new PearsonCourseStructureSearchTypes__c(name='Cluster', Search_Sort_Order__c=2),
    		 	new PearsonCourseStructureSearchTypes__c(name='Course', Search_Sort_Order__c=3)
			}; 
    	insert pcsst;
    	
    	//Create an opportunity to work with - needs an account
		Account a = TestData.buildAccount('Test Account');
		insert a;
		
		//add an opportunity to the account
		opp = TestData.buildOpportunity(a.id);
		insert opp;
		
		//add an opportunity to the account
		uniCourse = TestData.buildUniversityCourse(a.id);
		insert uniCourse;
		
		//Create some data to work with...
		tier1 = TestData.buildPearsonCourseStructure(null, 2, 'Discipline', 'DIS');
		insert tier1;
		
		//...and some child objects
		tier2 = TestData.buildPearsonCourseStructure(getIds(tier1), 2, 'Cluster', 'CLUS');
		insert tier2;
		
		tier3 = TestData.buildPearsonCourse(getIds(tier2), 2, 'COUR');
		insert tier3;
    }
    
    /*
     * Takes an array of ANY object and returns an array of ids for them
     */
    static Id[] getIds(Sobject[] items){
    	list<Id> allIds = new list<Id>();
    	
    	for(Sobject item : items){
    		id itemId = (Id)item.get('Id');
    		allIds.add(item.Id);
    	}
    	system.debug('!!!allIds: ' + allIds);
    	
    	return allIds;
    }
}