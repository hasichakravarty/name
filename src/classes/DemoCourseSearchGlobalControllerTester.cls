@isTest
private class DemoCourseSearchGlobalControllerTester {
    private static Opportunity opp;
    private static UniversityCourse__c uniCourse;
    private static Apttus_Config2__ClassificationHierarchy__c[] tier1;
    private static Apttus_Config2__ClassificationHierarchy__c[] tier2;
    private static Apttus_Config2__ClassificationHierarchy__c[] tier3;
    

  //Allows the user to enter any information in the search term fields, has to be at least 2 characters
  //Asteric at the beginnning and the end
    static testMethod void testSearchTermCleansing() {
      //buildTestData method created in the bottom of the class below; the parameter takes in a boolean value
        buildTestData(false);
        
        //Get the page object and add opening parameters
        PageReference testPage = Page.DemoCourseSearchGlobal; 
        testPage.getParameters().put('Id', opp.id); //Page requires an object id (Opportunity or University Course)
        testPage.getParameters().put('type', '0');  //0 indicates opportunity, 1 indicates Universtity Course
        
        //Set the page as the one we'll be using for these tests
        Test.setCurrentPageReference(testPage);
        
        //Instantiate the controller
        DemoCourseSearchGlobalController pageController = getController();
        
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
        //system.assertEquals('Search term is too Short', pageController.UserMessageTitle);
        //system.assertEquals('Course Code or Course Name search must contain at least 2 characters.', pageController.UserMessage);
        
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
        PageReference testPage = Page.DemoCourseSearchGlobal; 
        testPage.getParameters().put('Id', opp.id); //Page requires an object id (Opportunity or University Course)
        testPage.getParameters().put('type', '0');  //0 indicates opportunity, 1 indicates Universtity Course
        
        //Set the page as the one we'll be using for these tests
        Test.setCurrentPageReference(testPage);
        
        //Instantiate the controller
        DemoCourseSearchGlobalController pageController = getController();
        
        test.startTest();
        
        pageController.CourseCode = 'XXX*';
        pageController.SearchCourses();
        
        //system.assertEquals(true, pageController.ShowResults);

        test.stopTest();
    }

  /*Tests the SearchResults, pulls back all the rows expected
  it builds 2 disciplines and each discipline has 2 Clusters and then those 2 Clusters have 2 course each
  8 total*/
    static testMethod void testSearchOnCourseName() {
        buildTestData(false);
        
        //Get the page object and add opening parameters
        PageReference testPage = Page.DemoCourseSearchGlobal; 
        testPage.getParameters().put('Id', uniCourse.id); //Page requires an object id (Opportunity or University Course)
        testPage.getParameters().put('type', '1');  //0 indicates opportunity, 1 indicates Universtity Course
        
        //Set the page as the one we'll be using for these tests
        Test.setCurrentPageReference(testPage);
        
        //Instantiate the controller
        DemoCourseSearchGlobalController pageController = new DemoCourseSearchGlobalController();
        
        test.startTest();
        system.debug('!!!tier3: ' + tier3);
        pageController.CourseName = 'CO*';
        pageController.SearchCourses();
        
        //system.assertEquals(true, pageController.ShowResults);

        test.stopTest();
    }

  /*
  runs a search and takes the first result from that search and attaches it to the Opportunity
  */
   /* static testMethod void testAttachToOpportunity() {
        buildTestData(false);
        
        //Get the page object and add opening parameters
        PageReference testPage = Page.DemoCourseSearchGlobal; 
        testPage.getParameters().put('Id', opp.id); //Page requires an object id (Opportunity or University Course)
        testPage.getParameters().put('type', '0');  //0 indicates opportunity, 1 indicates Universtity Course
        
        //Set the page as the one we'll be using for these tests
        Test.setCurrentPageReference(testPage);
        
        //Instantiate the controller
        DemoCourseSearchGlobalController pageController = getController();
        
        test.startTest();
        
        pageController.CourseCode = 'XXX*';
        pageController.SearchCourses();
        
        //We've found some data,  so,  populate the appropriate item
        ((DemoCourseSearchGlobalSearchResultCntrlr)(pageController.getSearchResultComponentControllerMap().get('Course'))).InboundResults = pageController.CourseSearchResults;
        
        //Select some data to attach
        system.debug('--->>'+((DemoCourseSearchGlobalSearchResultCntrlr)(pageController.getSearchResultComponentControllerMap().get('Course'))).Results[0]);
        system.debug('!!!!-----'+((DemoCourseSearchGlobalSearchResultCntrlr)(pageController.getSearchResultComponentControllerMap().get('Course'))));        
        ((DemoCourseSearchGlobalSearchResultCntrlr)(pageController.getSearchResultComponentControllerMap().get('Course'))).Results[0].isSelected = true;
        PageReference pr = pageController.Attach();
        //system.assertEquals('/' + opp.Id, pr.getUrl());
         
        Opportunity_Pearson_Course_Code__c[] opcs = [select id, Pearson_Course_Code_Name__c
                                                        from Opportunity_Pearson_Course_Code__c
                                                        where Opportunity__c = :opp.Id];        
        
        //Just check that the OpportunityPearsonCourseStructure__c exists,  the CourseSearchHelperTester checks that the correct one is assigned
        //system.assertEquals(1, opcs.size());
       // DemoCourseSearchHelper demo = new DemoCourseSearchHelper (opp.Id,2);
       // list<Apttus_Config2__ClassificationHierarchy__c> li =  demo.getExistingCourses();
        
        test.stopTest();
    }*/

  /*
  runs a search and takes the first result from that search and attaches it to the UniversityCourse
  */
    static testMethod void testAttachToUniversityCourse() {
        test.startTest();
        buildTestData(false);
        
     
        List<Apttus_Config2__ClassificationHierarchy__c> pceList = [select name,Pearson_Course_Structure_Code__c from Apttus_Config2__ClassificationHierarchy__c];
        system.Debug('pcelist-----'+pceList);
        //Get the page object and add opening parameters
        PageReference testPage = Page.DemoCourseSearchGlobal; 
        testPage.getParameters().put('Id', uniCourse.id);   //Page requires an object id (Opportunity or University Course)
        testPage.getParameters().put('type', '1');  //0 indicates opportunity, 1 indicates Universtity Course
        
        //Set the page as the one we'll be using for these tests
        Test.setCurrentPageReference(testPage);
        
        //Instantiate the controller
        DemoCourseSearchGlobalController pageController = getController();
        
        
       
        pageController.CourseCode = 'XXX*';
        pageController.SearchCourses();
        
        //We've found some data,  so,  populate the appropriate item
        ((DemoCourseSearchGlobalSearchResultCntrlr)(pageController.getSearchResultComponentControllerMap().get('Course'))).InboundResults = pageController.CourseSearchResults;
        
        //Select some data to attach
        ((DemoCourseSearchGlobalSearchResultCntrlr)(pageController.getSearchResultComponentControllerMap().get('Course'))).Results[0].isSelected = true;
        PageReference pr = pageController.Attach();
       // system.assertEquals('/' + uniCourse.Id, pr.getUrl());
         
        Pearson_Course_Equivalent__c [] upcs = [select Course__c, Pearson_Course_Code__c 
                                                        from Pearson_Course_Equivalent__c
                                                        where Course__c = :uniCourse.Id];  
                                                        
        //Just check that the UniversityCoursePearsonCourseStructure__c exists,  the CourseSearchHelperTester checks that the correct one is assigned
        //system.assertEquals(1, upcs.size());
    
        test.stopTest();
    }

  //Tests that something useful is displayed, if there is no data found the error messages in this class will be displayed
    static testMethod void testNoDataFound() {
        buildTestData(false);
        
        //Get the page object and add opening parameters
        PageReference testPage = Page.DemoCourseSearchGlobal; 
        testPage.getParameters().put('Id', uniCourse.id);
        testPage.getParameters().put('type', '1');
        
        //Set the page as the one we'll be using for these tests
        Test.setCurrentPageReference(testPage);
        
        //Instantiate the controller
        DemoCourseSearchGlobalController pageController = getController();
        
        test.startTest();
        
        pageController.CourseCode = 'YXX*';
        pageController.SearchCourses();
        
        system.assertEquals(false, pageController.ShowResults);
        
        system.assert(pageController.ShowUserMessage);
        //system.assertEquals('No Results Found', pageController.UserMessageTitle);
        //system.assertEquals('No Pearson Course Structures were found for the search criteria you entered, please try again.', pageController.UserMessage);
    
        test.stopTest();
    }

  
  

//Tests that when the user hits the Cancel button, nothing is added and takes them back to the Opportunity
    static testMethod void testCancelFromOpportunity() {
        buildTestData(false);
        
        //Get the page object and add opening parameters
        PageReference testPage = Page.DemoCourseSearchGlobal; 
        testPage.getParameters().put('Id', opp.id);
        testPage.getParameters().put('type', '0');
        
        //Set the page as the one we'll be using for these tests
        Test.setCurrentPageReference(testPage);
        
        //Instantiate the controller
        DemoCourseSearchGlobalController pageController = getController();
        
        Pagereference pr = pageController.ReturnToCaller();
        //system.assertEquals('/' + opp.Id, pr.getUrl());
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
        DemoCourseSearchGlobalController pageController = getController();
        
        Pagereference pr = pageController.ReturnToCaller();
        //system.assertEquals('/' + uniCourse.Id, pr.getUrl());
        
    }

  /*
  Attaching PearsonCourse to a UniversityCourse that is already on the Opportunity
  this prevents us from creating a duplicate
  */
    /*static testMethod void testAttachToOpportunityWithExistingPCS() {
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
        //system.assertEquals('/' + opp.Id, pr.getUrl());
         
        OpportunityPearsonCourseStructure__c[] opcs = [select id, Pearson_Course_Structure__c
                                                        from OpportunityPearsonCourseStructure__c
                                                        where Opportunity__c = :opp.Id
                                                        order by id];  
                                                        
        //Just check that the OpportunityPearsonCourseStructure__c exists,  the CourseSearchHelperTester checks that the correct one is assigned
        system.assertEquals(2, opcs.size());
    
        test.stopTest();
    }*/

  /*
  Attaching PearsonCourse to a UniversityCourse that is already on the University Course
  this prevents us from creating a duplicate
  */
    /*static testMethod void testAttachToUniversityCourseWithExistingPCS() {
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
    }*/

  /*
  This piece ensures we don't add duplicate PearsonCourseStructures to an Opportunity or a University Course
  */
   /* static testMethod void testCannotAttachTheSamePCSTwice() {
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
  */
  private static DemoCourseSearchGlobalController getController(){
        DemoCourseSearchGlobalController pageController = new DemoCourseSearchGlobalController();
        
        for(SelectOption so : pageController.PearsonCourseStructureTypes){
          if(so.getValue() != 'All'){
            pageController.setComponentControllerMap(so.getValue(), getSearchResultComponent(pageController, so.getValue(), null, so.getValue() + 's'));
          }
        }
        String stri = pageController.ReturnLinkTitle;
        return pageController;
  }
   
  private static DemoCourseSearchGlobalSearchResultCntrlr getSearchResultComponent(PageControllerBase pageController, string key, Apttus_Config2__ClassificationHierarchy__c[] inboundData, string resultsTitle){
      DemoCourseSearchGlobalSearchResultCntrlr controller = new DemoCourseSearchGlobalSearchResultCntrlr();
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
        {  new PearsonCourseStructureSearchTypes__c(name='Discipline', Search_Sort_Order__c=1),
        new PearsonCourseStructureSearchTypes__c(name='Cluster', Search_Sort_Order__c=2),
           new PearsonCourseStructureSearchTypes__c(name='Course', Search_Sort_Order__c=3)
      }; 
      insert pcsst;
        
        //Create an opportunity to work with - needs an account
        Account a = TestData.buildAccount('Test Account');
        a.Geography__c = 'North America';
        a.Region__c = 'United States';
        a.Line_of_Business__c ='Schools';
        a.Market__c = 'US';
        insert a;
        
        //add an opportunity to the account
        opp = TestData.buildOpportunity(a.id);
        insert opp;
        
        //add an opportunity to the account
        uniCourse = TestData.buildUniversityCourse(a.id);
        insert uniCourse;
        
        //Apttus_Config2__ClassificationHierarchy__c clh = new Apttus_Config2__ClassificationHierarchy__c(Name = 'Testdata1', Label_c = 'TestData1');
        
        String pric = [select Price_List__c from User where id =:UserInfo.getUserId()].Price_List__c;
        system.debug('--pricelist---'+pric);
        Apttus_Config2__PriceList__c pl = new Apttus_Config2__PriceList__c(Name = pric);
        insert pl;
        system.debug('--pl--'+pl +'--user--'+UserInfo.getUserId());
        //Create some data to work with...
        tier1 = TestData.buildClassificationHier(null, quantity, 'Discipline', 'DIS');
        insert tier1;
        system.debug('!!!tier1: ' + tier1.size());
        
        //...and some child objects
        
        tier2 = TestData.buildClassificationHier(getIds(tier1), quantity, 'Cluster', 'CLUS');
        insert tier2;
        system.debug('!!!tier2: ' + tier2.size());
               
        tier3 = TestData.buildPearsonCourseHier(getIds(tier2), quantity, 'COUR');
        insert tier3;
        system.debug('!!!tier3: ' + tier3.size());
        
        Apttus_Config2__PriceListCategory__c plc = new Apttus_Config2__PriceListCategory__c(Apttus_Config2__HierarchyId__c = tier3[0].Apttus_Config2__HierarchyId__c,Apttus_Config2__PriceListId__c = pl.id,Apttus_Config2__Sequence__c = 1);
        system.debug('Category-----'+TestData.buildCategories().Id + '---'+pl.id);
        insert plc;
        
        Pearson_Course_Equivalent__c pce = new Pearson_Course_Equivalent__c(Course__c = uniCourse.Id, Pearson_Course_Code__c=tier3[1].id, Active__c = true);
        insert pce;
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