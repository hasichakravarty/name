/*
Name: Steven M. Giangrasso & Matt Hime
Date: 08/20/2012
Description: This controller class provides the ability to search through the Course TreeView

*/

/*with Sharing used to enforce Roles hierarchy
Use the with sharing keywords when declaring a class to enforce the sharing rules that apply to the current user.
http://www.salesforce.com/us/developer/docs/apexcode/Content/apex_classes_keywords_sharing.htm
*/
public with sharing class CourseSearchTreeviewController {
        private CourseSearchHelper helper;
                
    public class Course {
        //variable used to track whether the course is selected or not
            public boolean isSelected {get; set;}
            public PearsonCourseStructure__c PearsonCourseStructure {get; set;}
    }
    public list<Course> SelectedCourses {get; set;}
    private set<Id> SelectedCourseIds;
    
    public boolean CourseDataSelected {get; private set;}
    
    public list<PearsonCourseStructure__c> ExistingCourses{
            get{
                return helper.ExistingCourses;
            }
            
            private set;
    }
    
    public string TreeViewData {get; private set;}
    
    public string CourseName {get; set;}
    public string CourseId {get; set;}
    public string CourseType {get; set;}
    
    
    public CourseSearchTreeviewController(){
        /*The helper class contains any methods that can be utilised by either CourseSearh pages,  e.g creating junction objects for selected courses,
         *returning the user to the object from which the search was launched,  etc..
         */
        helper = new CourseSearchHelper((Id)ApexPages.currentPage().getParameters().get('Id'), integer.valueOf(ApexPages.currentPage().getParameters().get('type')));

        /*
         *This is the tool that creates the JSON data for the treeview.
         *Creates a hierarchical view of the flat PearsonCourseStructure__c data and then converts it to JSON for consumption
         */
        PearsonCourseStructureUtility.PrepareTreeViewNodeData();
        TreeViewData = PearsonCourseStructureUtility.getTreeJSONData();
        system.debug('***TreeViewData: ' + TreeViewData);
        
        //Create a list of Courses
        SelectedCourses = new list<Course>();
        SelectedCourseIds = new set<Id>();
        CourseDataSelected = false;
    }
    
    public Pagereference LoadGlobalSearchPage(){
        /*helper OwnerRecordId and OwnerRecordType are stored as properties of the helper class when it is instantiated - they're available in the URL
         *and are passed to the constructor method.  They're retrieved here to allow us to provide the correct URL details to the
         *treeview page.
         */
        return new Pagereference('/apex/CourseSearchGlobal?Id=' + helper.OwnerRecordId + '&type=' + helper.OwnerRecordType);
    }
    
    //Attach methods written for the Attach button in the Visualforce page
    public PageReference Attach(){
        
        //Create a list of PearsonCourseStructure objects
        list<PearsonCourseStructure__c> selectedPCS = new list<PearsonCourseStructure__c>();
        
        //enhanced For Loop to loop through each of the SelectedCourses for each Course
        for(Course c : selectedCourses){
                
                //For those Courses selected, add the Pearson Course Structure that the user selected
                SelectedPCS.add(c.PearsonCourseStructure);
        }
        
        Pagereference pr;
        try{
                pr = helper.Attach(selectedPCS);
        }
        catch (Exception ex){
                //Fatal error!  DO SOMETHING!
        }
        
        return pr;
    }
    
    public PageReference Cancel(){
        return helper.ReturnToCaller();
    }
    
    public PageReference RemoveItems(){
        
        set<Id> newSelectedIdsList = new set<Id>();        
        
        list<course> newCourseList = new list<Course>();
        
        //Enhanced For Loop to remove the courses that are not selected
        for(Course item : SelectedCourses){
            if(!item.isSelected){
                newSelectedIdsList.add(item.PearsonCourseStructure.Id);
                newCourseList.add(item);
            }
        }
        
        SelectedCourseIds = newSelectedIdsList;
        SelectedCourses = newCourseList;
        
        
        //If there are no courses selected don't show any courses in the Pearson Course Structure
        if(SelectedCourses.size() == 0){
            CourseDataSelected = false;
        }
        
        return null;
    }
    
    /*
     *Method uses data from hidden variables on the page (these are populated by double clicking a node - see the DynaTree jquery)
     *to check we hav not already selected this node and if not use it to create a display object (Course) and add that to the 
     *list of alredy selected courses (selected by the double click process NOT already existing courses) 
     */
    public pageReference StoreCourseData(){
        try{
                //Check we've not already selected this
            if(!SelectedCourseIds.contains(CourseId)){
                
                //Create a display object
                Course c = new Course();
                c.isSelected = false;
                
                //populate the data
                PearsonCourseStructure__c pcs = new PearsonCourseStructure__c(id = CourseId);
                pcs.Name = CourseName;
                pcs.Type__c = CourseType;
                
                c.PearsonCourseStructure = pcs;
                
                //Add to displayed list and already selected set
                SelectedCourses.add(c);
                SelectedCourseIds.add(CourseId);
                
                //Indicate that data has been selected and the data can be displayed
                CourseDataSelected = true;
            }
        }
        catch(Exception ex){
            //supress errors...
        }
        
        return null;
    }

}