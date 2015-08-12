/*
	*Name: Steven M. Giangrasso & Matt Hime
	*Date: 08/22/2012
	*Description: Course Search Helper Tester created to cover the CourseSearchHelper class
*/

@isTest()
//with sharing used to enforce sharing rules: http://www.salesforce.com/us/developer/docs/apexcode/Content/apex_classes_keywords_sharing.htm
public with sharing class CourseSearchHelperTester
{
	private static Opportunity opp;
	private static UniversityCourse__c uniCourse;
	private static PearsonCourseStructure__c[] tier1;
	private static PearsonCourseStructure__c[] tier2;
	private static PearsonCourseStructure__c[] tier3;
	
	//Test Method used to test the relationship between the UniversityCoursePearsonCourseStructure object (Universities) and the Course Search Helper class
	static testMethod void testUniversityTypeDesigntion()
	{
		buildTestData();
	
		//Add some OpportunityPearsonCourseStructure__c data to the university course
		UniversityCoursePearsonCourseStructure__c existingPCS = new UniversityCoursePearsonCourseStructure__c();
		existingPCS.UniversityCourse__c = uniCourse.Id;
			existingPCS.PearsonCourseStructure__c = tier3[0].Id;
		insert existingPCS;
			
			//Instantiate the CourseSearchHelper controller
			CourseSearchHelper helper = new CourseSearchHelper(uniCourse.Id, 1);
		system.assertEquals(1, helper.ExistingCourses.size());
		system.assertEquals(tier3[0].Id, helper.ExistingCourses[0].Id);
		
		//Check the owner Id and type variables
		system.assertEquals(uniCourse.Id, helper.OwnerRecordId);
		system.assertEquals(1, helper.OwnerRecordType);
	}
	
	//Test Method used to test the relationship between the OpportunityPearsonCourseStructure object (Opportunities) and the Course Search Helper class
	static testMethod void testOpportunityTypeDesigntion()
	{
		buildTestData();
		
		//Add some OpportunityPearsonCourseStructure__c data to the opportunity
		OpportunityPearsonCourseStructure__c existingPCS = new OpportunityPearsonCourseStructure__c();
		existingPCS.Opportunity__c = opp.Id;
		existingPCS.Pearson_Course_Structure__c = tier3[0].Id;
		insert existingPCS;
			
			//Instantiate the CourseSearchHelper controller
			CourseSearchHelper helper = new CourseSearchHelper(opp.Id, 0);
		system.assertEquals(1, helper.ExistingCourses.size());
		system.assertEquals(tier3[0].Id, helper.ExistingCourses[0].Id);
		
		//Check the owner Id and type variables
		system.assertEquals(opp.Id, helper.OwnerRecordId);
		system.assertEquals(0, helper.OwnerRecordType);
	}
	
	//testMethod used to throw an error for an invalid type
	static testMethod void testInvalidTypeDesigntion()
	{
		buildTestData();
	
		//Add some OpportunityPearsonCourseStructure__c data to the opportunity
		OpportunityPearsonCourseStructure__c existingPCS = new OpportunityPearsonCourseStructure__c();
		existingPCS.Opportunity__c = opp.Id;
		existingPCS.Pearson_Course_Structure__c = tier3[0].Id;
		insert existingPCS;
			
			//used to test an Invalid Type is inserted into the CourseSearchHelper class
			CourseSearchHelper helper = new CourseSearchHelper(opp.Id, 9);  //INVALID TYPE,  9
		system.assertEquals(0, helper.ExistingCourses.size());
	}
	
	
	//test method used to attach a new OpportunityPearsonCourseStructure record to the CourseSearchHelper
	static testMethod void testAttachToOpportunity()
	{
		buildTestData();

		//Instantiate the CourseSearchHelper controller
		CourseSearchHelper helper = new CourseSearchHelper(opp.Id, 0);
		
		test.startTest();
		
		list<PearsonCourseStructure__c> selection = new list<PearsonCourseStructure__c>();
		
		PearsonCourseStructure__c pcs = new PearsonCourseStructure__c(id = tier1[0].Id);
		pcs.Name = tier1[0].Name;
		pcs.Type__c = tier1[0].Type__c;
		selection.add(pcs);
		
		pcs = new PearsonCourseStructure__c(id = tier2[1].Id);
		pcs.Name = tier2[1].Name;
		pcs.Type__c = tier2[1].Type__c;
		selection.add(pcs);
		
		pcs = new PearsonCourseStructure__c(id = tier3[2].Id);
		pcs.Name = tier3[2].Name;
		pcs.Type__c = tier3[2].Type__c;
		selection.add(pcs);
		
		helper.Attach(selection);

		//The courses have been selected in ascending Id order,  so,  if we order that way we can easily assert the results		 
		OpportunityPearsonCourseStructure__c[] opcs = [select id, Opportunity__c, Pearson_Course_Structure__c
		 												from OpportunityPearsonCourseStructure__c
		 												where Opportunity__c = :opp.Id
		 												order by Pearson_Course_Structure__c];		
		system.assertEquals(3, opcs.size());
		system.assertEquals(tier1[0].Id, opcs[0].Pearson_Course_Structure__c);
		system.assertEquals(tier2[1].Id, opcs[1].Pearson_Course_Structure__c);
		system.assertEquals(tier3[2].Id, opcs[2].Pearson_Course_Structure__c);
		
		test.stopTest();
	}
	
	//test Method used to attach an Opportunity to an existing Pearson Course Structure
	static testMethod void testAttachToOpportunityWithExistingPCS()
	{
		buildTestData();
		
		//Add some OpportunityPearsonCourseStructure__c data to the opportunity
		OpportunityPearsonCourseStructure__c existingPCS = new OpportunityPearsonCourseStructure__c();
		existingPCS.Opportunity__c = opp.Id;
		existingPCS.Pearson_Course_Structure__c = tier1[0].Id;
		insert existingPCS;
	
		//Instantiate the CourseSearchHelper controller
		CourseSearchHelper helper = new CourseSearchHelper(opp.Id, 0);
		
		test.startTest();
		
		//Create a Collection of the PearsonCourseStructures and store them in the selection object
		list<PearsonCourseStructure__c> selection = new list<PearsonCourseStructure__c>();
		
		PearsonCourseStructure__c pcs = new PearsonCourseStructure__c(id = tier1[1].Id);
		pcs.Name = tier1[1].Name;
		pcs.Type__c = tier1[1].Type__c;
		selection.add(pcs);
		
		pcs = new PearsonCourseStructure__c(id = tier2[1].Id);
		pcs.Name = tier2[1].Name;
		pcs.Type__c = tier2[1].Type__c;
		selection.add(pcs);
		
		pcs = new PearsonCourseStructure__c(id = tier3[2].Id);
		pcs.Name = tier3[2].Name;
		pcs.Type__c = tier3[2].Type__c;
		selection.add(pcs);
		
		
		//Call the Attach method from the CourseSearchHelper
		helper.Attach(selection);
		 
		//The courses have been selected in ascending Id order,  so,  if we order that way we can easily assert the results
		OpportunityPearsonCourseStructure__c[] opcs = [select id, Opportunity__c, Pearson_Course_Structure__c
		 												from OpportunityPearsonCourseStructure__c
		 												where Opportunity__c = :opp.Id
		 												order by Pearson_Course_Structure__c];		
		system.assertEquals(4, opcs.size());
		system.assertEquals(tier1[0].Id, opcs[0].Pearson_Course_Structure__c);
		system.assertEquals(tier1[1].Id, opcs[1].Pearson_Course_Structure__c);
		system.assertEquals(tier2[1].Id, opcs[2].Pearson_Course_Structure__c);
		system.assertEquals(tier3[2].Id, opcs[3].Pearson_Course_Structure__c);
		
		test.stopTest();
	}
	
	
	//test Method created to attach a University Course / UCPCS record to the Course Search Helper
	static testMethod void testAttachToUniversity()
	{
		buildTestData();

		//Instantiate the controller
		CourseSearchHelper helper = new CourseSearchHelper(uniCourse.Id, 1);
		
		test.startTest();
		
		list<PearsonCourseStructure__c> selection = new list<PearsonCourseStructure__c>();
		
		PearsonCourseStructure__c pcs = new PearsonCourseStructure__c(id = tier1[0].Id);
		pcs.Name = tier1[0].Name;
		pcs.Type__c = tier1[0].Type__c;
		selection.add(pcs);
		
		pcs = new PearsonCourseStructure__c(id = tier2[1].Id);
		pcs.Name = tier2[1].Name;
		pcs.Type__c = tier2[1].Type__c;
		selection.add(pcs);
		
		pcs = new PearsonCourseStructure__c(id = tier3[2].Id);
		pcs.Name = tier3[2].Name;
		pcs.Type__c = tier3[2].Type__c;
		selection.add(pcs);
		
		helper.Attach(selection);
		
		//The courses have been selected in ascending Id order,  so,  if we order that way we can easily assert the results
		UniversityCoursePearsonCourseStructure__c[] upcs = [select id, UniversityCourse__c, PearsonCourseStructure__c
		 												from UniversityCoursePearsonCourseStructure__c
		 												where UniversityCourse__c = :uniCourse.Id
		 												order by PearsonCourseStructure__c];		
		system.assertEquals(3, upcs.size());
		system.assertEquals(tier1[0].Id, upcs[0].PearsonCourseStructure__c);
		system.assertEquals(tier2[1].Id, upcs[1].PearsonCourseStructure__c);
		system.assertEquals(tier3[2].Id, upcs[2].PearsonCourseStructure__c);
		
		test.stopTest();
	}
	
	
	//test Method used to attach existing Universities / UCPCS records to the CourseSearchHelper object
	static testMethod void testAttachToUniversityWithExistingPCS()
	{
		buildTestData();
		
		//Add some OpportunityPearsonCourseStructure__c data to the university course
		UniversityCoursePearsonCourseStructure__c existingPCS = new UniversityCoursePearsonCourseStructure__c();
		existingPCS.UniversityCourse__c = uniCourse.Id;
			existingPCS.PearsonCourseStructure__c = tier1[0].Id;
		insert existingPCS;
	
		//Instantiate the CourseSearchHelper controller
		CourseSearchHelper helper = new CourseSearchHelper(uniCourse.Id, 1);
		
		test.startTest();
		
		list<PearsonCourseStructure__c> selection = new list<PearsonCourseStructure__c>();
		
		//Instantiate the PearsonCourseStructure object
		PearsonCourseStructure__c pcs = new PearsonCourseStructure__c(id = tier1[1].Id);
		pcs.Name = tier1[1].Name;
		pcs.Type__c = tier1[1].Type__c;
		selection.add(pcs);
		
		pcs = new PearsonCourseStructure__c(id = tier2[1].Id);
		pcs.Name = tier2[1].Name;
		pcs.Type__c = tier2[1].Type__c;
		selection.add(pcs);
		
		pcs = new PearsonCourseStructure__c(id = tier3[2].Id);
		pcs.Name = tier3[2].Name;
		pcs.Type__c = tier3[2].Type__c;
		selection.add(pcs);
		
		helper.Attach(selection);
		
		//The courses have been selected in ascending Id order,  so,  if we order that way we can easily assert the results
		UniversityCoursePearsonCourseStructure__c[] upcs = [select id, UniversityCourse__c, PearsonCourseStructure__c
		 												from UniversityCoursePearsonCourseStructure__c
		 												where UniversityCourse__c = :uniCourse.Id
		 												order by PearsonCourseStructure__c];		
		system.assertEquals(4, upcs.size());
		system.assertEquals(tier1[0].Id, upcs[0].PearsonCourseStructure__c);
		system.assertEquals(tier1[1].Id, upcs[1].PearsonCourseStructure__c);
		system.assertEquals(tier2[1].Id, upcs[2].PearsonCourseStructure__c);
		system.assertEquals(tier3[2].Id, upcs[3].PearsonCourseStructure__c);
		
		test.stopTest();
	}
	
	/*
	 *The user should not be able to add the same PearsonCourseStructure__c to an Opportunity or University Course twice
	 *So,  create a Univerity Course and add a PCS object to it via a UniversityCoursePearsonCourseStructure__c junction object
	 *Then use the page to attempt to add the same PCS object again and assert that the number of junction objects has not changed
	 */
	static testMethod void testAttachTheSamePCSTwice()
	{
		buildTestData2();
	
		//Add some OpportunityPearsonCourseStructure__c data to the university course
		UniversityCoursePearsonCourseStructure__c existingPCS = new UniversityCoursePearsonCourseStructure__c();
		existingPCS.UniversityCourse__c = uniCourse.Id;
			existingPCS.PearsonCourseStructure__c = tier1[0].Id;
		insert existingPCS;
	
		//Instantiate the CourseSearchHelper controller
		CourseSearchHelper helper = new CourseSearchHelper(uniCourse.Id, 1);
		
		test.startTest();
		
		list<PearsonCourseStructure__c> selection = new list<PearsonCourseStructure__c>();
		
		//Attempt to attach again
		PearsonCourseStructure__c pcs = new PearsonCourseStructure__c(id = tier1[0].Id);
		pcs.Name = tier1[0].Name;
		pcs.Type__c = tier1[0].Type__c;
		selection.add(pcs);
		
		helper.Attach(selection);
		
		//The courses have been selected in ascending Id order,  so,  if we order that way we can easily assert the results
		UniversityCoursePearsonCourseStructure__c[] upcs = [select id, UniversityCourse__c, PearsonCourseStructure__c
		 												from UniversityCoursePearsonCourseStructure__c
		 												where UniversityCourse__c = :uniCourse.Id
		 												order by PearsonCourseStructure__c];		
		system.assertEquals(1, upcs.size());
		system.assertEquals(tier1[0].Id, upcs[0].PearsonCourseStructure__c);
		
		test.stopTest();
	}
	
	//private method used to buildtestData into the Controller
	private static void buildTestData()
	{
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
	
	//private method used to buildtestData into the Controller
	private static void buildTestData2()
	{
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
	static Id[] getIds(Sobject[] items)
	{
		list<Id> allIds = new list<Id>();
		
		for(Sobject item : items)
		{
			id itemId = (Id)item.get('Id');
			allIds.add(item.Id);
		}
		system.debug('!!!allIds: ' + allIds);
		
		return allIds;
	}
}