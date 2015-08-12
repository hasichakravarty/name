/*
Name: Steven M. Giangrasso
Date: 08/15/2012
Description: Write a class that tests the methods in the CourseSearchGlobalController class
*/
@isTest
private class CourseSearchGlobalControllerTester {
    private static Opportunity opp;
    private static UniversityCourse__c uniCourse;
    private static PearsonCourseStructure__c[] tier1;
    private static PearsonCourseStructure__c[] tier2;
    private static PearsonCourseStructure__c[] tier3;
    

	//Allows the user to enter any information in the search term fields, has to be at least 2 characters
	//Asteric at the beginnning and the end
    static testMethod void testSearchTermCleansing() {
    	//buildTestData method created in the bottom of the class below; the parameter takes in a boolean value
        buildTestData(false);
        
        //Get the page object and add opening parameters
        PageReference testPage = Page.CourseSearchGlobal; 
        testPage.getParameters().put('Id', opp.id); //Page requires an object id (Opportunity or University Course)
        testPage.getParameters().put('type', '0');  //0 indicates opportunity, 1 indicates Universtity Course
        
        //Set the page as the one we'll be using for these tests
        Test.setCurrentPageReference(testPage);
        
        //Instantiate the controller
        CourseSearchGlobalController pageController = getController();
        
        test.startTest();
        
        //invalid characters are removed to leave a clean string
        pageController.CourseCode = '*123"456\\789*';
        pageController.CourseName = '\'123*456%789';
        
        pageController.SearchCourses();
        system.assertEquals('*123456789*', pageController.CourseCode);
        system.assertEquals('123456789', pageController.CourseName);
        
        //invalid characters are removed to leave a string that is too short
        pageController.CourseCode = '*%\'*';
        pageController.CourseName = '';
        
        pageController.SearchCourses();
        system.assert(pageController.ShowUserMessage);
        system.assertEquals('Search term too Short', pageController.UserMessageTitle);
        system.assertEquals('Course Code or Course Name search must contain at least 2 characters.', pageController.UserMessage);
        
        test.stopTest();
    }

	/*
	Each Course has its own PCC Code
	When we search this time around it returns 8 again
	this time we look at Course Code instead of Course Name
	*/
    static testMethod void testSearchOnCourseCode() {
        buildTestData(false);
        
        //Get the page object and add opening parameters
        PageReference testPage = Page.CourseSearchGlobal; 
        testPage.getParameters().put('Id', opp.id); //Page requires an object id (Opportunity or University Course)
        testPage.getParameters().put('type', '0');  //0 indicates opportunity, 1 indicates Universtity Course
        
        //Set the page as the one we'll be using for these tests
        Test.setCurrentPageReference(testPage);
        
        //Instantiate the controller
        CourseSearchGlobalController pageController = getController();
        
        test.startTest();
        
        pageController.CourseCode = 'XXX*';
        pageController.SearchCourses();
        
        system.assertEquals(true, pageController.ShowResults);

        test.stopTest();
    }

	/*Tests the SearchResults, pulls back all the rows expected
	it builds 2 disciplines and each discipline has 2 Clusters and then those 2 Clusters have 2 course each
	8 total*/
    static testMethod void testSearchOnCourseName() {
        buildTestData(false);
        
        //Get the page object and add opening parameters
        PageReference testPage = Page.CourseSearchGlobal; 
        testPage.getParameters().put('Id', opp.id); //Page requires an object id (Opportunity or University Course)
        testPage.getParameters().put('type', '0');  //0 indicates opportunity, 1 indicates Universtity Course
        
        //Set the page as the one we'll be using for these tests
        Test.setCurrentPageReference(testPage);
        
        //Instantiate the controller
        CourseSearchGlobalController pageController = new CourseSearchGlobalController();
        
        test.startTest();
        system.debug('!!!tier3: ' + tier3);
        pageController.CourseName = 'CO*';
        pageController.SearchCourses();
        
        system.assertEquals(true, pageController.ShowResults);

        test.stopTest();
    }

	/*
	runs a search and takes the first result from that search and attaches it to the Opportunity
	*/
    static testMethod void testAttachToOpportunity() {
        buildTestData(false);
        
        //Get the page object and add opening parameters
        PageReference testPage = Page.CourseSearchGlobal; 
        testPage.getParameters().put('Id', opp.id); //Page requires an object id (Opportunity or University Course)
        testPage.getParameters().put('type', '0');  //0 indicates opportunity, 1 indicates Universtity Course
        
        //Set the page as the one we'll be using for these tests
        Test.setCurrentPageReference(testPage);
        
        //Instantiate the controller
        CourseSearchGlobalController pageController = getController();
        
        test.startTest();
        
        pageController.CourseCode = 'XXX*';
        pageController.SearchCourses();
        
        //We've found some data,  so,  populate the appropriate item
        pageController.getSearchResultComponentController('Course').InboundResults = pageController.CourseSearchResults;
        
        //Select some data to attach
        pageController.getSearchResultComponentController('Course').Results[0].isSelected = true;
        PageReference pr = pageController.Attach();
        system.assertEquals('/' + opp.Id, pr.getUrl());
         
        OpportunityPearsonCourseStructure__c[] opcs = [select id, Pearson_Course_Structure__c
                                                        from OpportunityPearsonCourseStructure__c
                                                        where Opportunity__c = :opp.Id];        
        
        //Just check that the OpportunityPearsonCourseStructure__c exists,  the CourseSearchHelperTester checks that the correct one is assigned
        system.assertEquals(1, opcs.size());
        
        test.stopTest();
    }

	/*
	runs a search and takes the first result from that search and attaches it to the UniversityCourse
	*/
    static testMethod void testAttachToUniversityCourse() {
        buildTestData(false);
        
        //Get the page object and add opening parameters
        PageReference testPage = Page.CourseSearchGlobal; 
        testPage.getParameters().put('Id', uniCourse.id);   //Page requires an object id (Opportunity or University Course)
        testPage.getParameters().put('type', '1');  //0 indicates opportunity, 1 indicates Universtity Course
        
        //Set the page as the one we'll be using for these tests
        Test.setCurrentPageReference(testPage);
        
        //Instantiate the controller
        CourseSearchGlobalController pageController = getController();
        
        test.startTest();
        
        pageController.CourseCode = 'XXX*';
        pageController.SearchCourses();
        
        //We've found some data,  so,  populate the appropriate item
        pageController.getSearchResultComponentController('Course').InboundResults = pageController.CourseSearchResults;
        
        //Select some data to attach
        pageController.getSearchResultComponentController('Course').Results[0].isSelected = true;
        PageReference pr = pageController.Attach();
        system.assertEquals('/' + uniCourse.Id, pr.getUrl());
         
        UniversityCoursePearsonCourseStructure__c[] upcs = [select UniversityCourse__c, PearsonCourseStructure__c 
                                                        from UniversityCoursePearsonCourseStructure__c
                                                        where UniversityCourse__c = :uniCourse.Id];  
                                                        
        //Just check that the UniversityCoursePearsonCourseStructure__c exists,  the CourseSearchHelperTester checks that the correct one is assigned
        system.assertEquals(1, upcs.size());
    
        test.stopTest();
    }

	//Tests that something useful is displayed, if there is no data found the error messages in this class will be displayed
    static testMethod void testNoDataFound() {
        buildTestData(false);
        
        //Get the page object and add opening parameters
        PageReference testPage = Page.CourseSearchGlobal; 
        testPage.getParameters().put('Id', uniCourse.id);
        testPage.getParameters().put('type', '1');
        
        //Set the page as the one we'll be using for these tests
        Test.setCurrentPageReference(testPage);
        
        //Instantiate the controller
        CourseSearchGlobalController pageController = getController();
        
        test.startTest();
        
        pageController.CourseCode = 'YXX*';
        pageController.SearchCourses();
        
        system.assertEquals(false, pageController.ShowResults);
        
        system.assert(pageController.ShowUserMessage);
        system.assertEquals('No Results Found', pageController.UserMessageTitle);
        system.assertEquals('No Pearson Course Structures were found for the search criteria you entered, please try again.', pageController.UserMessage);
    
        test.stopTest();
    }

	//Test that more than 1,000 records is not added to the TreeView
    static testMethod void testTooMuchDataFound() {
    	//Method used below
        buildTestData(true);
        
        //Get the page object and add opening parameters
        PageReference testPage = Page.CourseSearchGlobal; 
        testPage.getParameters().put('Id', uniCourse.id);
        testPage.getParameters().put('type', '1');
        
        //Set the page as the one we'll be using for these tests
        Test.setCurrentPageReference(testPage);
        
        //Instantiate the controller
        CourseSearchGlobalController pageController = getController();
        
        test.startTest();
        
        pageController.CourseCode = 'XXX*';
        pageController.SearchCourses();
        
        //We've found some data,  so,  populate the appropriate item
        pageController.getSearchResultComponentController('Course').InboundResults = pageController.CourseSearchResults;
        
        system.assertEquals(false, pageController.ShowResults);
        
        system.assert(pageController.ShowUserMessage);
        system.assertEquals('Too Many Results', pageController.UserMessageTitle);
        system.assertEquals('Your search returned more than 1000 rows of data.  Please refine the search criteria and try again.', pageController.UserMessage);
    
        test.stopTest();
    }

	//Switch from Opportunity to the GoToTreeView
    static testMethod void testGoToTreeviewFromOpportunity() {
        buildTestData(false);
        
        //Get the page object and add opening parameters
        PageReference testPage = Page.CourseSearchGlobal; 
        testPage.getParameters().put('Id', opp.id);
        testPage.getParameters().put('type', '0');
        
        //Set the page as the one we'll be using for these tests
        Test.setCurrentPageReference(testPage);
        
        //Instantiate the controller
        CourseSearchGlobalController pageController = getController();
        
        Pagereference pr = pageController.LoadTreeviewSearchPage();
        system.assertEquals('/apex/CourseSearchTreeview?Id=' + opp.Id + '&type=0', pr.getUrl());
    }

	//Instead of going to the GlobalSearch from Treeview, you are going to TreeView from GlobalSearch
    static testMethod void testGoToTreeviewFromUniCourse() {
        buildTestData(false);
        
        //Get the page object and add opening parameters
        PageReference testPage = Page.CourseSearchGlobal; 
        testPage.getParameters().put('Id', uniCourse.id);
        testPage.getParameters().put('type', '1');
        
        //Set the page as the one we'll be using for these tests
        Test.setCurrentPageReference(testPage);
        
        //Instantiate the controller
        CourseSearchGlobalController pageController = getController();
        
        Pagereference pr = pageController.LoadTreeviewSearchPage();
        system.assertEquals('/apex/CourseSearchTreeview?Id=' + uniCourse.Id + '&type=1', pr.getUrl());
    }

//Tests that when the user hits the Cancel button, nothing is added and takes them back to the Opportunity
    static testMethod void testCancelFromOpportunity() {
        buildTestData(false);
        
        //Get the page object and add opening parameters
        PageReference testPage = Page.CourseSearchGlobal; 
        testPage.getParameters().put('Id', opp.id);
        testPage.getParameters().put('type', '0');
        
        //Set the page as the one we'll be using for these tests
        Test.setCurrentPageReference(testPage);
        
        //Instantiate the controller
        CourseSearchGlobalController pageController = getController();
        
        Pagereference pr = pageController.ReturnToCaller();
        system.assertEquals('/' + opp.Id, pr.getUrl());
    }

	//Tests that when the user hits the Cancel button, nothing is added and takes them back to the University Course
    static testMethod void testCancelFromUniCourse() {
        buildTestData(false);
        
        //Get the page object and add opening parameters
        PageReference testPage = Page.CourseSearchGlobal; 
        testPage.getParameters().put('Id', uniCourse.id);
        testPage.getParameters().put('type', '1');
        
        //Set the page as the one we'll be using for these tests
        Test.setCurrentPageReference(testPage);
        
        //Instantiate the controller
        CourseSearchGlobalController pageController = getController();
        
        Pagereference pr = pageController.ReturnToCaller();
        system.assertEquals('/' + uniCourse.Id, pr.getUrl());
        
    }

	/*
	Attaching PearsonCourse to a UniversityCourse that is already on the Opportunity
	this prevents us from creating a duplicate
	*/
    static testMethod void testAttachToOpportunityWithExistingPCS() {
        buildTestData(false);
    	
    	//Add some OpportunityPearsonCourseStructure__c data to the opportunity
    	OpportunityPearsonCourseStructure__c existingPCS = new OpportunityPearsonCourseStructure__c();
    	existingPCS.Opportunity__c = opp.Id;
    	existingPCS.Pearson_Course_Structure__c = tier3[0].Id;
    	insert existingPCS;
        
        //Get the page object and add opening parameters
        PageReference testPage = Page.CourseSearchGlobal; 
        testPage.getParameters().put('Id', opp.id); //Page requires an object id (Opportunity or University Course)
        testPage.getParameters().put('type', '0');  //0 indicates opportunity, 1 indicates Universtity Course
        
        //Set the page as the one we'll be using for these tests
        Test.setCurrentPageReference(testPage);
        
        //Instantiate the controller
        CourseSearchGlobalController pageController = getController();
        
        test.startTest();
        
        pageController.CourseCode = 'XXX*';
        pageController.SearchCourses();
        
        //We've found some data,  so,  populate the appropriate item
        pageController.getSearchResultComponentController('Course').InboundResults = pageController.CourseSearchResults;
        
        //Select some data to attach
        pageController.getSearchResultComponentController('Course').Results[1].isSelected = true;
        PageReference pr = pageController.Attach();
        system.assertEquals('/' + opp.Id, pr.getUrl());
         
        OpportunityPearsonCourseStructure__c[] opcs = [select id, Pearson_Course_Structure__c
                                                        from OpportunityPearsonCourseStructure__c
                                                        where Opportunity__c = :opp.Id
                                                        order by id];  
                                                        
        //Just check that the OpportunityPearsonCourseStructure__c exists,  the CourseSearchHelperTester checks that the correct one is assigned
        system.assertEquals(2, opcs.size());
    
        test.stopTest();
    }

	/*
	Attaching PearsonCourse to a UniversityCourse that is already on the University Course
	this prevents us from creating a duplicate
	*/
    static testMethod void testAttachToUniversityCourseWithExistingPCS() {
        buildTestData(false);
    	
    	//Add some OpportunityPearsonCourseStructure__c data to the university course
    	UniversityCoursePearsonCourseStructure__c existingPCS = new UniversityCoursePearsonCourseStructure__c();
    	existingPCS.UniversityCourse__c = uniCourse.Id;
    	existingPCS.PearsonCourseStructure__c = tier3[0].Id;
    	insert existingPCS;
        
        //Get the page object and add opening parameters
        PageReference testPage = Page.CourseSearchGlobal; 
        testPage.getParameters().put('Id', uniCourse.id);   //Page requires an object id (Opportunity or University Course)
        testPage.getParameters().put('type', '1');  //0 indicates opportunity, 1 indicates Universtity Course
        
        //Set the page as the one we'll be using for these tests
        Test.setCurrentPageReference(testPage);
        
        //Instantiate the controller
        CourseSearchGlobalController pageController = getController();
		system.assertEquals(1, pageController.ExistingCourses.size());
        
        test.startTest();
        
        pageController.CourseCode = 'XXX*';
        pageController.SearchCourses();
        
        //We've found some data,  so,  populate the appropriate item
        pageController.getSearchResultComponentController('Course').InboundResults = pageController.CourseSearchResults;
        
        //Select some data to attach
        pageController.getSearchResultComponentController('Course').Results[1].isSelected = true;
        PageReference pr = pageController.Attach();
        system.assertEquals('/' + uniCourse.Id, pr.getUrl());
         
        UniversityCoursePearsonCourseStructure__c[] upcs = [select UniversityCourse__c, PearsonCourseStructure__c 
                                                        from UniversityCoursePearsonCourseStructure__c
                                                        where UniversityCourse__c = :uniCourse.Id
                                                        order by id];
                                                        
        //Just check that the UniversityCoursePearsonCourseStructure__c exists,  the CourseSearchHelperTester checks that the correct one is assigned   
        system.assertEquals(2, upcs.size());
    
        test.stopTest();
    }

	/*
	This piece ensures we don't add duplicate PearsonCourseStructures to an Opportunity or a University Course
	*/
    static testMethod void testCannotAttachTheSamePCSTwice() {
        buildTestData(false);
    	
    	//Add some OpportunityPearsonCourseStructure__c data to the university course
    	UniversityCoursePearsonCourseStructure__c existingPCS = new UniversityCoursePearsonCourseStructure__c();
    	existingPCS.UniversityCourse__c = uniCourse.Id;
    	existingPCS.PearsonCourseStructure__c = tier3[0].Id;
    	insert existingPCS;
        
        //Get the page object and add opening parameters
        PageReference testPage = Page.CourseSearchGlobal; 
        testPage.getParameters().put('Id', uniCourse.id);   //Page requires an object id (Opportunity or University Course)
        testPage.getParameters().put('type', '1');  //0 indicates opportunity, 1 indicates Universtity Course
        
        //Set the page as the one we'll be using for these tests
        Test.setCurrentPageReference(testPage);
        
        //Instantiate the controller
        CourseSearchGlobalController pageController = getController();
        
        test.startTest();
        
        pageController.CourseCode = 'XXX*';
        pageController.SearchCourses();
        
        //We've found some data,  so,  populate the appropriate item
        pageController.getSearchResultComponentController('Course').InboundResults = pageController.CourseSearchResults;
        
        //Select some data to attach
        pageController.getSearchResultComponentController('Course').Results[0].isSelected = true;
        //pageController.Courses[0].isSelected = true;
        PageReference pr = pageController.Attach();
        system.assertEquals('/' + uniCourse.Id, pr.getUrl());
         
        UniversityCoursePearsonCourseStructure__c[] upcs = [select UniversityCourse__c, PearsonCourseStructure__c 
                                                        from UniversityCoursePearsonCourseStructure__c
                                                        where UniversityCourse__c = :uniCourse.Id
                                                        order by id];     
        system.assertEquals(1, upcs.size());
    
        test.stopTest();
    }
	
	private static CourseSearchGlobalController getController(){
        CourseSearchGlobalController pageController = new CourseSearchGlobalController();
        
        for(SelectOption so : pageController.PearsonCourseStructureTypes){
        	if(so.getValue() != 'All'){
        		pageController.setComponentControllerMap(so.getValue(), getSearchResultComponent(pageController, so.getValue(), null, so.getValue() + 's'));
        	}
        }
        
        return pageController;
	}
 	
	private static CourseSearchGlobalSearchResultController getSearchResultComponent(PageControllerBase pageController, string key, PearsonCourseStructure__c[] inboundData, string resultsTitle){
	    CourseSearchGlobalSearchResultController controller = new CourseSearchGlobalSearchResultController();
	    controller.key = key;
	    controller.pageController = pageController;
	    controller.InboundResults = inboundData;
	    controller.title = resultsTitle;
	
	    return controller;
	}

//These last 2 methods are helper methods for the class
    private static void buildTestData(boolean massiveData){
        integer quantity;
        //tests if this is more than 1,000 rows
        if(massiveData){
            quantity = 11; //11x11x11=1331 rows of data (okay,  not massive massive,  but, pretty big!)
        }
        else{
            quantity = 2;
        }
        system.debug('!!!buildTestData.quantity: ' + quantity);
        
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
        tier1 = TestData.buildPearsonCourseStructure(null, quantity, 'Discipline', 'DIS');
        insert tier1;
        system.debug('!!!tier1: ' + tier1.size());
        
        //...and some child objects
        tier2 = TestData.buildPearsonCourseStructure(getIds(tier1), quantity, 'Cluster', 'CLUS');
        insert tier2;
        system.debug('!!!tier2: ' + tier2.size());
        
        tier3 = TestData.buildPearsonCourse(getIds(tier2), quantity, 'COUR');
        insert tier3;
        system.debug('!!!tier3: ' + tier3.size());
    }
    
    /*
     * Takes an array of ANY object and returns an array of ids for them
     */
    private static Id[] getIds(Sobject[] items){
        list<Id> allIds = new list<Id>();
        
        for(Sobject item : items){
            id itemId = (Id)item.get('Id');
            allIds.add(item.Id);
        }
        
        return allIds;
    }
}