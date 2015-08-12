/*
    *Name: Steven M. Giangrasso & Matt Hime (tquila)
    *Description: This class is created to cover the shared functionality of the CourseSearchGlobalController and CourseSearchTreeviewController
    *-Refactoring both classes to share common methods
    *Date: 8/21/2012

*/
//with sharing used to enforce the sharing rules that apply to the current user: http://www.salesforce.com/us/developer/docs/apexcode/Content/apex_classes_keywords_sharing.htm
public with sharing class DemoCourseSearchHelper {
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
    private map<Id, Apttus_Config2__ClassificationHierarchy__c> ExistingCourseData { get; set; }

    //The Sf id of the record that called the search page
    public string OwnerRecordId {get; private set;}
    
    //The type of record that called the search page
    public integer OwnerRecordType {get; private set;}
    public list<Apttus_Config2__ClassificationHierarchy__c> ExistingCourses{
        get {
            return ExistingCourseData.values();
        }
        
        private set;
    }

    /*
     *The constructor casts the incoming OwnerRecordType to a value of ObjectType
     *it also grabs the data for any PearsonCourseStructures already associated with
     *the OwnerRecordId bu searching the junction objects 
     *Opportunity_Pearson_Course_Code__c and UniversityCoursePearsonCourseStructure__c
     */
    public DemoCourseSearchHelper(Id Owner, integer OwnerType){

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
        ExistingCourseData = new map<Id, Apttus_Config2__ClassificationHierarchy__c>();
        
        //If the Type is equal to an Opportunity, insert a OpportunityPearsonCourseStructure with a put method into the ExistingCourseData
        //Added Pearson_Course_Code_Name__r.Pearson_Course_Structure_Code__c to Query below to display in DemoCourseSearchGlobal VF Page.by Kyama
        if(Type == ObjectType.OPPORTUNITY){
            for(Opportunity_Pearson_Course_Code__c item: [select Pearson_Course_Code_Name__c, Pearson_Course_Code_Name__r.Name, Pearson_Course_Code_Name__r.Type__c,Pearson_Course_Code_Name__r.Pearson_Course_Structure_Code__c
                                                                from Opportunity_Pearson_Course_Code__c 
                                                                where Opportunity__c = :OwnerRecordId]){
                
                ExistingCourseData.put(item.Pearson_Course_Code_Name__c, createPearsonCourseStructure(item.Pearson_Course_Code_Name__c, item.Pearson_Course_Code_Name__r.Name, item.Pearson_Course_Code_Name__r.Type__c,item.Pearson_Course_Code_Name__r.Pearson_Course_Structure_Code__c));
            }
        }
        //If the Type is equal to an University Course, insert a OpportunityPearsonCourseStructure with a put method into the ExistingCourseData
        //Added Pearson_Course_Code__r.Pearson_Course_Structure_Code__c  to Query below to display in DemoCourseSearchGlobal VF Page.by Kyama

        else if(Type == ObjectType.UNIVERSITY_COURSE){
            for(Pearson_Course_Equivalent__c item: [select Pearson_Course_Code__c, Pearson_Course_Code__r.Name, Pearson_Course_Code__r.Type__c,Pearson_Course_Code__r.Pearson_Course_Structure_Code__c 
                                                                    from Pearson_Course_Equivalent__c 
                                                                    where Course__c = :OwnerRecordId]){
                
                ExistingCourseData.put(item.Pearson_Course_Code__c, createPearsonCourseStructure(item.Pearson_Course_Code__c, item.Pearson_Course_Code__r.Name, item.Pearson_Course_Code__r.Type__c,item.Pearson_Course_Code__r.Pearson_Course_Structure_Code__c));
            }
        }
    }
    
    /*
     *Creates Apttus_Config2__ClassificationHierarchy__c object from the parameters passed to it
     *Used by getExistingCourses to convert junction objects into Apttus_Config2__ClassificationHierarchy__c objects
     *for display purposes 
     *Added pcs.Pearson_Course_Structure_Code__c = PearsonCourseCode by kyama
     */
    private Apttus_Config2__ClassificationHierarchy__c createPearsonCourseStructure(Id pcsId, string Name, string Type, string PearsonCourseCode){
        Apttus_Config2__ClassificationHierarchy__c pcs = new Apttus_Config2__ClassificationHierarchy__c(Id = pcsId);
        pcs.Name = Name;
        pcs.Type__c = Type;
        pcs.Pearson_Course_Structure_Code__c=PearsonCourseCode;
        return pcs;
    }
    
    /*
     *Takes an array of Apttus_Config2__ClassificationHierarchy__c objects and creates junction objects to attach them to
     *the Opportunity or University Course record that called the search page
     */
    public PageReference Attach(Apttus_Config2__ClassificationHierarchy__c[] selectedPCS){
        
        list<Sobject> newItems = new list<Sobject>();
        
        Apttus_Config2__ClassificationHierarchy__c[] deDupedCourses = removeDuplicates(selectedPCS);
        
        if(Type == ObjectType.OPPORTUNITY){
            for(Apttus_Config2__ClassificationHierarchy__c pcs: deDupedCourses){
                Opportunity_Pearson_Course_Code__c opcs = new Opportunity_Pearson_Course_Code__c();
                opcs.Opportunity__c = OwnerRecordId;
                opcs.Pearson_Course_Code_Name__c = pcs.Id;
                
                newItems.add(opcs);
            }
        }
        else if(Type == ObjectType.UNIVERSITY_COURSE){
            integer count = 0;
            Boolean check = true;
            // Pooja |Querying record with Primary checkbox checked from Pearson Course Equivalent object associated to Course id 'OwnerRecordId'.
            List<Pearson_Course_Equivalent__c> pceList = [select id, name from Pearson_Course_Equivalent__c where Course__c =: OwnerRecordId and Primary__c =: check];
            system.debug('pceList---'+pceList);
            for(Apttus_Config2__ClassificationHierarchy__c pcs: deDupedCourses){
                Pearson_Course_Equivalent__c ucpcs = new Pearson_Course_Equivalent__c();
               // Pooja |setting Primary checkbox to true when there is no Primary checked record already exist on Pearson_Course_Equivalent__c related list on Course.
               // Pooja |Only one record should be Primary checked so imcrementing Count with one
               if(pceList.isEmpty() && count == 0){
                        ucpcs.Primary__c = true;
                        count = 1;
                }
                ucpcs.Course__c = OwnerRecordId;
                ucpcs.Pearson_Course_Code__c = pcs.Id;
                ucpcs.Active__c = true;
                newItems.add(ucpcs);
            }
        }
        
        //The collection will be empty if an invalid type was passed to the helper
        if(!newItems.isEmpty()){
            try{
                insert newItems;
            }
            catch(Exception ex){
                throw(ex);
            }
        }
        
        return ReturnToCaller();
    }
    
    /*
     *Users can easily select duplicate Apttus_Config2__ClassificationHierarchy__c objects,  so,  before creating junction
     *objects,  iterate through the array of chosen items and interrogate the ExistingCoursesData keySet
     *to see if the item has already been used before
     */
    private Apttus_Config2__ClassificationHierarchy__c[] removeDuplicates(Apttus_Config2__ClassificationHierarchy__c[] selectedPCS){
        list<Apttus_Config2__ClassificationHierarchy__c> deDupedCourses = new list<Apttus_Config2__ClassificationHierarchy__c>();
        
        for(Apttus_Config2__ClassificationHierarchy__c pcs: selectedPCS){
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