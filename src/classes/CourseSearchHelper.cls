/*
	*Name: Steven M. Giangrasso & Matt Hime (tquila)
	*Description: This class is created to cover the shared functionality of the CourseSearchGlobalController and CourseSearchTreeviewController
	*-Refactoring both classes to share common methods
	*Date: 8/21/2012

*/
//with sharing used to enforce the sharing rules that apply to the current user: http://www.salesforce.com/us/developer/docs/apexcode/Content/apex_classes_keywords_sharing.htm
public with sharing class CourseSearchHelper {
	/*
	 *Each visualforce page that uses this class is passed a type value in the URL.
	 *0 indicates that the caller was an Opportunity record
	 *1 indicates that the caller was an University Course record
	 *It's extremely unlikely that an incorrect value will ever get passed through as it's hard coded,  but,
	 *maybe some day another will be added - in which case we need to make sure there's no unexpected behaviour
	 */
    private enum ObjectType {OPPORTUNITY, UNIVERSITY_COURSE, UNKNOWN}
    
    //The incoming OwnerRecordType expressed as ObjectType
    private final ObjectType Type;
    
    //This data is held a map so that we can display the values and search the keySet
    private map<Id, PearsonCourseStructure__c> ExistingCourseData;

	//The Sf id of the record that called the search page
    public string OwnerRecordId {get; private set;}
    
    //The type of record that called the search page
    public integer OwnerRecordType {get; private set;}
	public list<PearsonCourseStructure__c> ExistingCourses{
		get	{
			return ExistingCourseData.values();
		}
		
		private set;
	}

	/*
	 *The constructor casts the incoming OwnerRecordType to a value of ObjectType
	 *it also grabs the data for any PearsonCourseStructures already associated with
	 *the OwnerRecordId bu searching the junction objects 
	 *OpportunityPearsonCourseStructure__c and UniversityCoursePearsonCourseStructure__c
	 */
	public CourseSearchHelper(Id Owner, integer OwnerType){

		//Assign the OwnerRecordID variable to the Owner parameter in the CourseSearchHelper Constructor
        OwnerRecordId = Owner;
        //Assign the OwnerRecordType variable to the OwnerType parameter in the CourseSearchHelper Constructor
        OwnerRecordType = OwnerType;
        
        try{
            Type =  ObjectType.values().get(OwnerRecordType);
        }
        catch(Exception e){
            Type = ObjectType.UNKNOWN;
        }
        system.debug('***Type: ' + Type);
		
		getExistingCourses();
	}
    
    /*
     *This method searches the junction objects to come up with a map of existing records
     *The map values are displayed on screen whilst the keySet is used later for depduping
     */
    private void getExistingCourses(){
        ExistingCourseData = new map<Id, PearsonCourseStructure__c>();
        
        //If the Type is equal to an Opportunity, insert a OpportunityPearsonCourseStructure with a put method into the ExistingCourseData
        if(Type == ObjectType.OPPORTUNITY){
            for(OpportunityPearsonCourseStructure__c item: [select Pearson_Course_Structure__c, Pearson_Course_Structure__r.Name, Pearson_Course_Structure__r.Type__c
	                                                            from OpportunityPearsonCourseStructure__c 
	                                                            where Opportunity__c = :OwnerRecordId]){
                
                ExistingCourseData.put(item.Pearson_Course_Structure__c, createPearsonCourseStructure(item.Pearson_Course_Structure__c, item.Pearson_Course_Structure__r.Name, item.Pearson_Course_Structure__r.Type__c));
            }
        }
        //If the Type is equal to an University Course, insert a OpportunityPearsonCourseStructure with a put method into the ExistingCourseData
        else if(Type == ObjectType.UNIVERSITY_COURSE){
            for(UniversityCoursePearsonCourseStructure__c item: [select PearsonCourseStructure__c, PearsonCourseStructure__r.Name, PearsonCourseStructure__r.Type__c 
	                                                                from UniversityCoursePearsonCourseStructure__c 
	                                                                where UniversityCourse__c = :OwnerRecordId]){
                
                ExistingCourseData.put(item.PearsonCourseStructure__c, createPearsonCourseStructure(item.PearsonCourseStructure__c, item.PearsonCourseStructure__r.Name, item.PearsonCourseStructure__r.Type__c));
            }
        }
    }
    
    /*
     *Creates PearsonCourseStructure__c object from the parameters passed to it
     *Used by getExistingCourses to convert junction objects into PearsonCourseStructure__c objects
     *for display purposes 
     */
    private PearsonCourseStructure__c createPearsonCourseStructure(Id pcsId, string Name, string Type){
    	PearsonCourseStructure__c pcs = new PearsonCourseStructure__c(Id = pcsId);
    	pcs.Name = Name;
    	pcs.Type__c = Type;
    	
    	return pcs;
    }
    
    /*
     *Takes an array of PearsonCourseStructure__c objects and creates junction objects to attach them to
     *the Opportunity or University Course record that called the search page
     */
    public PageReference Attach(PearsonCourseStructure__c[] selectedPCS){
        
        list<Sobject> newItems = new list<Sobject>();
        
        PearsonCourseStructure__c[] deDupedCourses = removeDuplicates(selectedPCS);
        
        if(Type == ObjectType.OPPORTUNITY){
            for(PearsonCourseStructure__c pcs: deDupedCourses){
                OpportunityPearsonCourseStructure__c opcs = new OpportunityPearsonCourseStructure__c();
                opcs.Opportunity__c = OwnerRecordId;
                opcs.Pearson_Course_Structure__c = pcs.Id;
                
                newItems.add(opcs);
            }
        }
        else if(Type == ObjectType.UNIVERSITY_COURSE){
            for(PearsonCourseStructure__c pcs: deDupedCourses){
                UniversityCoursePearsonCourseStructure__c ucpcs = new UniversityCoursePearsonCourseStructure__c();
                ucpcs.UniversityCourse__c = OwnerRecordId;
                ucpcs.PearsonCourseStructure__c = pcs.Id;
                
                newItems.add(ucpcs);
            }
        }
        
        //The collection will be empty if an invalid type was passed to the helper
        if(!newItems.isEmpty()){
            try{
                insert newItems;
            }
            catch(Exception ex){
                return null;
            }
        }
        
        return ReturnToCaller();
    }
    
    /*
     *Users can easily select duplicate PearsonCourseStructure__c objects,  so,  before creating junction
     *objects,  iterate through the array of chosen items and interrogate the ExistingCoursesData keySet
     *to see if the item has already been used before
     */
    private PearsonCourseStructure__c[] removeDuplicates(PearsonCourseStructure__c[] selectedPCS){
        list<PearsonCourseStructure__c> deDupedCourses = new list<PearsonCourseStructure__c>();
        
        for(PearsonCourseStructure__c pcs: selectedPCS){
        	//If the item is NOT in the keySet,  it's okay to use it
            if(!ExistingCourseData.keySet().contains(pcs.Id)){
                deDupedCourses.add(pcs);
            }
        }
        
        return deDupedCourses;
    }
    
    /*
     *Called by each search page whenever they are returning to the opportunity
     *or university course record that called them (i.e. Cancel or Attach methods)
     */
    public PageReference ReturnToCaller(){
        return new PageReference('/' + OwnerRecordId);
    }
}