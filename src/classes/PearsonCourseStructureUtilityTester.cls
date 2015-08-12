/*
 *Author: Matt Hime (tquila)
 *Date: 21/8/2012
 *Description: A very simple test class to ensure that the output from the PearsonCourseStructureUtility is correct
 */
 
@isTest
private class PearsonCourseStructureUtilityTester {
	private static PearsonCourseStructure__c[] tier1;
	private static PearsonCourseStructure__c[] tier2;
	private static PearsonCourseStructure__c[] tier3;
	
	
    static testMethod void myUnitTest() {
    	// Delete data from custom setting if it exists and repopulate with values we're expecting
    	delete [select Id from PearsonCourseStructureSearchTypes__c];
    	List<PearsonCourseStructureSearchTypes__c> pcsst = new List<PearsonCourseStructureSearchTypes__c>
    		{	new PearsonCourseStructureSearchTypes__c(name='Discipline', Search_Sort_Order__c=1),
				new PearsonCourseStructureSearchTypes__c(name='Cluster', Search_Sort_Order__c=2),
    		 	new PearsonCourseStructureSearchTypes__c(name='Course', Search_Sort_Order__c=3)
			}; 
    	insert pcsst;
    	
		//Create some data to work with...
		tier1 = TestData.buildPearsonCourseStructure(null, 2, 'Discipline', 'DIS');
		insert tier1;
		
		//...and some child objects
		tier2 = TestData.buildPearsonCourseStructure(getIds(tier1), 2, 'Cluster', 'CLUS');
		insert tier2;
		
		tier3 = TestData.buildPearsonCourse(getIds(tier2), 2, 'COUR');
		insert tier3;
		
		Test.startTest();
		
		//Ready the data
		PearsonCourseStructureUtility.PrepareTreeViewNodeData();
		
		//Convert the data to JSON
        string jsonOutput = PearsonCourseStructureUtility.getTreeJSONData();

		//The JSON data is indented,  so use replaceAll('\\s+','') to get rid of all white space from it
        system.assertEquals(AnticipatedJSON(), jsonOutput.replaceAll('\\s+',''));
		
		Test.stopTest();
    }
    
    private static string AnticipatedJSON(){
		return '[{"title":"DIS0","key":"'+tier1[0].Id+'","unselectable":false,"expand":false,"isFolder":false,"Type":"Discipline","children":[{"title":"CLUS0","key":"'+tier2[0].Id+'","unselectable":false,"expand":false,"isFolder":false,"Type":"Cluster","children":[{"title":"COUR0","key":"'+tier3[0].Id+'","unselectable":false,"expand":false,"isFolder":false,"Type":"Course"},{"title":"COUR1","key":"'+tier3[1].Id+'","unselectable":false,"expand":false,"isFolder":false,"Type":"Course"}]},{"title":"CLUS1","key":"'+tier2[1].Id+'","unselectable":false,"expand":false,"isFolder":false,"Type":"Cluster","children":[{"title":"COUR0","key":"'+tier3[2].Id+'","unselectable":false,"expand":false,"isFolder":false,"Type":"Course"},{"title":"COUR1","key":"'+tier3[3].Id+'","unselectable":false,"expand":false,"isFolder":false,"Type":"Course"}]}]},{"title":"DIS1","key":"'+tier1[1].Id+'","unselectable":false,"expand":false,"isFolder":false,"Type":"Discipline","children":[{"title":"CLUS0","key":"'+tier2[2].Id+'","unselectable":false,"expand":false,"isFolder":false,"Type":"Cluster","children":[{"title":"COUR0","key":"'+tier3[4].Id+'","unselectable":false,"expand":false,"isFolder":false,"Type":"Course"},{"title":"COUR1","key":"'+tier3[5].Id+'","unselectable":false,"expand":false,"isFolder":false,"Type":"Course"}]},{"title":"CLUS1","key":"'+tier2[3].Id+'","unselectable":false,"expand":false,"isFolder":false,"Type":"Cluster","children":[{"title":"COUR0","key":"'+tier3[6].Id+'","unselectable":false,"expand":false,"isFolder":false,"Type":"Course"},{"title":"COUR1","key":"'+tier3[7].Id+'","unselectable":false,"expand":false,"isFolder":false,"Type":"Course"}]}]}]';
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