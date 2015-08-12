/*
 *Author: Matt Hime (tquila)
 *Date: 21/8/2012
 *Description:  The controller for the DemoCourseSearchGlobalSearchResult component.  It's used on the DemoCourseSearchGlobal page to display the search results.
 *              These are split by Type__c and each type has it's own CourseSearchGlobalSearchResult.
 *
 *              The displayed data can be queried by the page to determine what the user has selected
 *
 *INPUTS:   InboundResults (Apttus_Config2__ClassificationHierarchy__c[]) - data to be displayed in the pageBlockTable
 *          Title (string) - the value displayed as the header of the pageBlock
 *
 *OUTPUTS:  Results(list<PearsonCourseStructureSelection>) - InboundResults as a 'selectable' set of records
 *          Count (integer) - number of records,  displayed in the header of the pageBlock
 *          ShowResults (boolean) - flag based on Count used by the rendered attribute of the pageBlock. False when there's no data
 */
 
public with sharing class DemoCourseSearchGlobalSearchResultCntrlr extends ComponentControllerBase{
    
    public class PearsonCourseStructureSelection{
        public boolean isSelected {get; set;}
        public Apttus_Config2__ClassificationHierarchy__c PearsonCourseStructure {get; set;}
        
        public PearsonCourseStructureSelection(Apttus_Config2__ClassificationHierarchy__c course){
            isSelected = false;
            PearsonCourseStructure = course;
        }
    }
    
    
    public list<PearsonCourseStructureSelection> Results {get; private set;}
    public integer Count {get; private set;}
    public boolean ShowResults {get; private set;}
    
    public string Title {get; set;}
    
    /*
     *InboundResults are converted to Results to allow the user to select the values we're receiving
     *
     *The results data is refreshed any time the page is updated,  this means that selected data can be overwritten accidentally
     *To prevent this,  the data is only refreshed if the InboundResults do not match the current results
     */
    public Apttus_Config2__ClassificationHierarchy__c[] InboundResults {
        get; 

        set{
            //Loop through the curent result set and gather all the Apttus_Config2__ClassificationHierarchy__c data
            list<Apttus_Config2__ClassificationHierarchy__c> currentResults = new list<Apttus_Config2__ClassificationHierarchy__c>();
            if(Results != null){
                for(PearsonCourseStructureSelection pcss : Results){
                    currentResults.add(pcss.PearsonCourseStructure);
                }
            }
            else{
                //If this is the first time through and there is no current data,  just create an empty set of results
                Results = new list<PearsonCourseStructureSelection>();
            }
            
            //If we have a new set of results,  reload the data
            if(currentResults != value){
                Results = new list<PearsonCourseStructureSelection>();
                
                if(value != null){
                
                    for(Apttus_Config2__ClassificationHierarchy__c pcs : value){
                        Results.add(new PearsonCourseStructureSelection(pcs));
                    }
                    
                }
            }
                
            Count =  Results.size();
            
            if(Results.size() > 0){
                ShowResults = true;
            }
            else{
                ShowResults = false;
            }
        }
    }

}