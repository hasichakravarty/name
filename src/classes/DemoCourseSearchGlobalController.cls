/*
 *Author: Matt Hime (tquila)
 *Date: 21/8/2012
 *Description:  The controller for the DemoCourseSearchGlobal page which allows users to specify search parameters to trawl through 
 *              Apttus_Config2__ClassificationHierarchy__c data.  Results are displayed in DemoCourseSearchGlobalSearchResult components.
 *
 *              Users can attach selected items to the University Course or Opportunity they navigated from
 */
 
//A class extends another class using the keyword extends. A class can only extend one other class, but it can implement more than one interface. 
//Use the with sharing keywords when declaring a class to enforce the sharing rules that apply to the current user
public with sharing class DemoCourseSearchGlobalController extends PageControllerBase{
    private List<Id> catList = new List<Id>();
    //I've used a map to hold the results because it's an easy way to store the data as it gets generated
    private map<string, list<Apttus_Config2__ClassificationHierarchy__c>> ResultSets { get; set; }
    
    //If a new type comes along,  you'll need to add a new component to the form and add a new one of these variables below
    public list<Apttus_Config2__ClassificationHierarchy__c> DisciplineSearchResults {get{return ResultSets.get('Discipline');} private set;}
    public list<Apttus_Config2__ClassificationHierarchy__c> ClusterSearchResults {get{return ResultSets.get('Cluster');}  private set;}
    public list<Apttus_Config2__ClassificationHierarchy__c> CourseSearchResults {get{return ResultSets.get('Course');}  private set;}

    public class searchResults {
        public String ResultType { get; set; }
        public list<Apttus_Config2__ClassificationHierarchy__c> resultSet { get; set; }
        
        public searchResults(String type, list<Apttus_Config2__ClassificationHierarchy__c> results)
        {
            this.ResultType = type;
            this.resultSet = results;
        }
    }

    public list<searchResults> allResults { get; set; }

    //The helper class for the search pages,  does things like build junction objects from data selected,  etc..
    private DemoCourseSearchHelper helper;

    //These variables are hidden fields on the form that are populated when the user double clicks the treeview 
    public string CourseCode {get; set;}
    public string CourseName {get; set;}
    public string CourseType {get; set;}
    
    //The Course Type dropdown on the page has it's values dynamically assigned to future-proof the code against new types
    public list<SelectOption> PearsonCourseStructureTypes {get; private set;}
    
    //If an error is thrown, ShowUserMessage is set to TRUE and the message is put into UserMessage and a friendly title in UserMessageTitle
    public boolean ShowUserMessage {get; private set;}
    public string UserMessageTitle {get; private set;}
    public string UserMessage {get; private set;}
    
    //If no data is returned from the search,  this flag hides the results panel
    public boolean ShowResults {get; private set;}
    //Added to display error message on click of attach button
    public boolean pearsonCourseCodeError{get;set;}
    //From the helper class,  display existing courses on screen
    public list<Apttus_Config2__ClassificationHierarchy__c> ExistingCourses{
        get {
            return helper.ExistingCourses;
        }
        
        private set;
    }
    
    //Sets the title of the return link to that of Opportunity or University course depending on what object this search originated from
    public string ReturnLinkTitle{
        get{
            string returnValue = 'Return to ';
            
            if(helper.OwnerRecordType == 0){
                returnValue += 'Opportunity';
            }
            else if(helper.OwnerRecordType == 1){
                returnValue += 'University Course';
            }
            else{
                returnValue += 'UNKNOWN';
            }
            
            return returnValue;
        }
        private set;
    }
    
    
    /*
     *The constructor loads up the helper class, populates the Course Type drop down and initialises module level variables
     */
    public DemoCourseSearchGlobalController(){
        //Instantiate the helper - it requires the Id and type values from the URL
        helper = new DemoCourseSearchHelper((Id)ApexPages.currentPage().getParameters().get('Id'), integer.valueOf(ApexPages.currentPage().getParameters().get('type')));
        
        //populate the Course Type drop down data
        loadPearsonCourseStructureTypes();
        
        //Initialise all the important variables
        resetResults();
        
        //Don't start of with null search terms
        CourseCode = '';
        CourseName = '';
        pearsonCourseCodeError=false;
    }
    
    
    
    //added by pooja 13 march 2015
    public Map<String, ComponentControllerBase> getSearchResultComponentControllerMap(){
        return getComponentControllerMap();
    }
    
    
    public PageReference SearchCourses(){
        //Initialise existing data
        resetResults();
                
        //Clean the search terms
        CourseCode = AutoCorrectSearchTerm(CourseCode);
        CourseName = AutoCorrectSearchTerm(CourseName);
        
        //Make sure that we have enough to make a search
        if(CourseCode.replace('*', '').length() < 2 && CourseName.replace('*', '').length() < 2){
            ShowUserMessage = true;
            UserMessageTitle = Label.short_search_term;
            UserMessage = Label.short_course_code;
        }
        else{
            //Search...
            getResults();
        }

        return null;
    }
        
    /*
     *Removes unwanted / reserved characters from the string passed to it and returns a cleansed version of it.
     */
    private string AutoCorrectSearchTerm(string searchTerm){
        
        //User can enter anything EXCEPT
        //Percentage sign - we're going to use that
        string revisedSearchTerm = searchTerm.replace('%', '');
        
        //Double quotes
        revisedSearchTerm = revisedSearchTerm.replace('"', '');
        
        //Single quote
        revisedSearchTerm = revisedSearchTerm.replace('\'', '');
        
        //Backslash (oblique?)
        revisedSearchTerm = revisedSearchTerm.replace('\\', '');
        
        //Asterisks are wild cards,  but,  they can only appear at the beginning and end of the search term
        if(revisedSearchTerm.contains('*')){
                
            //Replace * at beginning and end with something we know the string does not contain (a %-sign)
            if(revisedSearchTerm.startsWith('*')){
                revisedSearchTerm = '%' + revisedSearchTerm.substring(1);
            }
    
                //If the last character in the search term is a * replace it with a %
            if(revisedSearchTerm.endsWith('*')){
                revisedSearchTerm = revisedSearchTerm.substring(0, revisedSearchTerm.lastIndexOf('*')) + '%';
            }
            
            //Replace all asterisks
            revisedSearchTerm = revisedSearchTerm.replace('*', '');
            
            //Replace any temporary asterisk holders with asterisks
            revisedSearchTerm = revisedSearchTerm.replace('%', '*');
        }
        system.debug('***revisedSearchTerm: ' + revisedSearchTerm);
        
        return revisedSearchTerm;
    }
    
    /*
     *Clear down all the old search data / error messages in preparation for the new search
     */
    private void resetResults(){
        ResultSets = new map<string, list<Apttus_Config2__ClassificationHierarchy__c>>();
        
        ShowResults = false;
        
        ShowUserMessage = false;
        UserMessageTitle = '';
        UserMessage = '';
    }
    // Added by Pooja on 16 Mar'15 | Rd- 225 (IDC Task: 45)
    // To get logged in user's pricelist and from that to get associted Categary from PriceList Category object.
    // used to Query data from Category Hierarchy associated with Logged in user's Pricelist.
    //Category and Price list are associated via PriceList Category object. 
    private void getUserDetails(){
        Id userid = UserInfo.getUserId();
        system.debug('userid----->'+userid);
        //User priceListName = [select Price_List__c from User where id =: userid];
        //System.debug('priceListName--->'+priceListName);
        List<Apttus_Config2__PriceListCategory__c> plcList = [select Apttus_Config2__HierarchyId__c from Apttus_Config2__PriceListCategory__c where Apttus_Config2__HierarchyId__c != null AND Apttus_Config2__PriceListId__r.Name =: [select Price_List__c from User where id =: userid].Price_List__c];
        system.debug('plcList---->'+plcList);
        Id catrec;
        for(Apttus_Config2__PriceListCategory__c plc : plcList){
            catrec = plc.Apttus_Config2__HierarchyId__c;
            catList.add(catrec);
        }
        system.Debug('category---'+catList);
    }
    private void getResults(){
/*
        This SOQL is what we're trying to emulate here with the 3 lines in the midddle as optional:
                
        Select p.Type__c, p.Pearson_Course_Structure_Name__c, p.Pearson_Course_Structure_Code__c, p.Name, p.Discipline__c, p.Cluster__c 
        From Apttus_Config2__ClassificationHierarchy__c p
        where Active_Indicator__c = true
        
        and Pearson_Course_Structure_Code__c like '%BM0%'
        and Type__c = 'Course'
        and Pearson_Course_Structure_Name__c like 'Corporate%'
        
        order by Type__c, Name
*/
        getUserDetails();
        string SOQL = 'select Type__c, Apttus_Config2__Label__c, Pearson_Course_Structure_Code__c, Name, Discipline__c, Cluster__c';
        SOQL += ' From Apttus_Config2__ClassificationHierarchy__c';
       // SOQL += ' where Active_Indicator__c = true';
       // SOQL += ' and Region__c = \'US\'';
        SOQL += ' where Region__c = \'US\'';       
        SOQL += ' and Apttus_Config2__HierarchyId__c in: catList';
        //If no search term has been specified for Course Code,  don't include it in the SOQL
        if(CourseCode.length() > 0){
            SOQL += ' and Pearson_Course_structure_Code__c' + applyWildcards(CourseCode);
        }
        
        //If no search term has been specified for Course Name,  don't include it in the SOQL
        if(CourseName.length() > 0){
            SOQL += ' and (Apttus_Config2__Label__c' + applyWildcards(CourseName) + 
                 ' or Name' + applyWildcards(CourseName) + ')';
        }

        PearsonCourseStructureSearchTypes__c pcstruc = PearsonCourseStructureSearchTypes__c.getInstance('Course');
        CourseType = pcstruc.Name;
        system.debug('pcstruc--'+pcstruc +' ;'+CourseType);
        
        // If type is not specified, reference PearsonCourseStructureSearchTypes__c to ensure we are not showing types we should not be
        /*if(CourseType == 'All'){
            Set<String> displayCourseTypes = PearsonCourseStructureSearchTypes__c.getAll().keySet();
            system.debug('displayCourseTypes---->'+displayCourseTypes);
            SOQL += ' and Type__c in: displayCourseTypes';
        } else {*/
            SOQL += ' and Type__c = \'' + CourseType + '\'';
        //}

        SOQL += ' order by Type__c, Name';  
        system.debug('***SOQL: ' + SOQL);
        
        try{
            /*
             *Run the search and then check the result.  Possible outcomes are
             * 1. No data returned - in which case,  flash up amessage to let the user know we got nothing
             * 2. Too much data returned - if it's more than 1000 rows,  this process will crash.  Get the user to refine their search
             * 3. Goldilocks! (the 3rd bowl of porridge was just right...)  We've got a result,  process it
             */
            Apttus_Config2__ClassificationHierarchy__c[] results = database.Query(SOQL);
                system.debug('***getResults.results: ' + results);
            
            if(results.size() == 0){
                ShowUserMessage = true;
                UserMessageTitle = Label.no_result;
                UserMessage = Label.no_pearson_course_found;
            }
            else if(results.size() >= 1000){
                ShowUserMessage = true;
                UserMessageTitle = Label.many_results;
                UserMessage = Label.large_no_of_results;
            }
            else{
                /*
                 *Loop through the results set and split the data by type.  Use the map pattern here as it makes it nice and easy to tell
                 *when we're transitioning between types
                 */
                for(Apttus_Config2__ClassificationHierarchy__c pcs : results){
                    
                    list<Apttus_Config2__ClassificationHierarchy__c> resultsByType = ResultSets.get(pcs.Type__c);
                    if(resultsByType == null){
                        resultsByType = new list<Apttus_Config2__ClassificationHierarchy__c>(); 
                    }
                    
                    resultsByType.add(pcs);
                    ResultSets.put(pcs.Type__c, resultsByType);
                }
                system.debug('***ResultSets: ' + ResultSets);
                
                // now we have grouped all results, push them into a list of lists, sorted by the type specified on the custom setting
                allResults = new list<searchResults>();
                for (PearsonCourseStructureSearchTypes__c resultType : [Select Name 
                                                                        from PearsonCourseStructureSearchTypes__c 
                                                                        order by Search_Sort_Order__c])
                {
                    // ensure we are not showing an empty list on the page
                    if (ResultSets.containsKey(resultType.Name))
                    {
                        allResults.add(new searchResults(resultType.Name, ResultSets.get(resultType.Name)));
                    }
                    
                }
                
                ShowResults = true;
            }
        }
        catch(Exception ex){
            ShowUserMessage = true;
            UserMessageTitle = 'Fatal Error';
            UserMessage = 'An unexpected error has occured,  please try again.';
        }  
    }
    
    /*
     *If the search term contains a wildcard (*),  doctor the SOQL to use like (rather than =)
     *and replace the * with the SOQL wildcard (%)
     */
    private string applyWildcards(string searchTerm){
        string wildcardOutput;
        
        if(searchTerm.contains('*')){
            wildcardOutput = ' like \'';
            
            if(searchTerm.startsWith('*')){
                wildcardOutput += '%';
            }
            
            wildcardOutput += searchTerm;
            
            
            if(searchTerm.endsWith('*')){
                wildcardOutput += '%';
            }
            
            wildcardOutput += '\'';
        }
        else{
            wildcardOutput = ' = \'' + searchTerm + '\'';
        }
        
        return wildcardOutput.replace('*', '');
    }
    
    /*
     *Select distinct Type__c values from Apttus_Config2__ClassificationHierarchy__c and use them to create SelectOptions for the Course Type dropdown
     */
    private void loadPearsonCourseStructureTypes(){
        PearsonCourseStructureTypes = new list<SelectOption>();
        
        //Have All as the first option
        PearsonCourseStructureTypes.add(new SelectOption('All', 'All'));
        
        /*
         *There's no SELECT DISTINCT phrase available in SOQL,  so,  select Type__c from Apttus_Config2__ClassificationHierarchy__c and group by it
         *This does not return Apttus_Config2__ClassificationHierarchy__c objects,  but,  AggregateResult objects.
         
        for(AggregateResult course : [select Type__c From Apttus_Config2__ClassificationHierarchy__c group by Type__c order by Type__c]){
            string courseType = string.valueOf(course.get('Type__c'));
            PearsonCourseStructureTypes.add(new SelectOption(courseType, courseType));
        }
        */
        
        List<SelectOption> otherTypes = new list<SelectOption>();
        // Rather than looking at all types that we have stored in the database, we should only supply values that we are exposing via the custom setting
        for (String pcsst : PearsonCourseStructureSearchTypes__c.getAll().keySet())
        {
            otherTypes.add(new SelectOption(pcsst,pcsst));
        }
        
        otherTypes.sort();
        PearsonCourseStructureTypes.addAll(otherTypes);
        
        //Set the selected value to all
        CourseType = 'All';
    }

    /*
     *Each custom search result component represents a type.  So,  loop through the types to get the type name - this is the key for 
     *the corresponding component - and use it to get the search results for that type.  Interrogate the results to see which have been selected
     *Store the selections and pass them to the Attach method on the helper class.
     */
    public PageReference Attach(){
        //hold the selected data
        list<Apttus_Config2__ClassificationHierarchy__c> selectedPCS = new list<Apttus_Config2__ClassificationHierarchy__c>();

        //loop through each type
        for(SelectOption so : PearsonCourseStructureTypes){
            //Ignore 'All' as it's not really a type
            if(so.getValue() != 'All'){
                
                
                //added by pooja 13 march 2015
                System.debug('All maps: ' + getComponentControllerMap());

                if(getComponentControllerMap().keyset().contains(so.getValue())){ 
                    system.debug('Cming--');
                    DemoCourseSearchGlobalSearchResultCntrlr componentCtrlr = (DemoCourseSearchGlobalSearchResultCntrlr) getComponentControllerMap().get(so.getValue()); 
                    
                    //loop through the results 
                    for(DemoCourseSearchGlobalSearchResultCntrlr.PearsonCourseStructureSelection pcss : componentCtrlr.Results){
                    
                        system.debug('***Attach.pcss: ' + pcss); 
                        
                        //If the item has been selected by the user, store it. 
                        if(pcss.isSelected){ 
                            system.debug('inner if--');
                            selectedPCS.add(pcss.PearsonCourseStructure); 
                            } 
                        } 
                    } 
                    


                //added end here
                
                
            }
        }
        system.debug('***Attach.selectedPCS: ' + selectedPCS);

        Pagereference pr;

        try{
            if(selectedPCS!=null && selectedPCS.size()>0){
            //build junction objects for everything selected
            pr = helper.Attach(selectedPCS);
            
                 }
                else{
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Select Atleast one Course Code.'));
                 pearsonCourseCodeError=true;
                 }
        }
        catch (Exception ex){
       //Fatal error!  DO SOMETHING!
       throw(ex);        }

        return pr;
    }
    
    /*
     *Return to the page from which the search process was called
     */
    public PageReference ReturnToCaller(){
        return helper.ReturnToCaller();
    }
    
}