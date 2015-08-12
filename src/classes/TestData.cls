/*
 *Author: Matt Hime (tquila)
 *Date: 21/8/2012
 *Description:  Data creation class for use by any and all test methods
 *              Add new methods to create objects as required.
 */
 
 public with sharing class TestData {
    
    /*
     *Build an account with just enough data to save to the db
     */
    public static Account buildAccount(string accountName){
        Account a = new Account();
        a.Name = accountName;
        a.BillingCity = 'The Big Smoke';
        a.BillingCountry = 'Australia';
        a.BillingPostalCode = 'VA23454';
        a.Type = 'University';
        return a;
    }
    
    /*
     *Build an opportunity with just enough data to save to the db
     */
    public static Opportunity buildOpportunity(Id accId){
        Opportunity o = new Opportunity();
        o.Name = 'Test Opp';
        o.AccountId = accId;
        o.StageName = 'Identification';
        o.CloseDate = date.today().addDays(1);
        return o;
    }
    
    /*
     *Build an University Course with just enough data to save to the db
     */
    public static UniversityCourse__c buildUniversityCourse(Id accId){
        UniversityCourse__c u = new UniversityCourse__c();
        u.Account__c = accId;
        
        return u;
    }
    
    /*
     *Build PearsonCourseStructure__c objects
     *parentIds can be null, in which case,  these are top tier items
     *to create,  we need to know what kind of PCS is being requested - courseType
     *itemName is just a useful identifier provided by the user as part of the object Name
     */
    public static PearsonCourseStructure__c[] buildPearsonCourseStructure(Id[] parentIds, integer howMany, string courseType, string itemName){
        //Get the record type based upon the type specified by the user
        //string recordTypeLikeName = '%' + courseType + '%';
        
        //RecordType[] rt = [select Id, Name
        //                    from RecordType
        //                    where SobjectType = 'PearsonCourseStructure__c'
        //                    and Name like :recordTypeLikeName];
        //Make sure this has returned just one record
        //system.assertEquals(1, rt.size(), 'Problem finding PearsonCourseStructure__c recordtype for ' + courseType);
        
        list<PearsonCourseStructure__c> courses = new list<PearsonCourseStructure__c>();
        
        //If these items are top of the heap,  we don't need to add parent ids
        if(parentIds == null){
            for(integer i = 0 ; i < howMany ; i++){
                //courses.add(buildSinglePearsonCourseStructure(null, itemName, courseType, rt[0].Id, i));
                courses.add(buildSinglePearsonCourseStructure(null, itemName, courseType, i));
            }
        }
        else{
            //If they're child items,  loop though each parent and add the id to the item as it's created
            for(Id parent : parentIds){
                for(integer i = 0 ; i < howMany ; i++){
                    //courses.add(buildSinglePearsonCourseStructure(parent, itemName, courseType, rt[0].Id, i));
                    courses.add(buildSinglePearsonCourseStructure(parent, itemName, courseType, i));
                }
            }
        }
        
        return courses;
    }
    
    /*
     *A course has a couple of extra items of data,  so,  call the generic PCS builder first and then add to it
     */
    public static PearsonCourseStructure__c[] buildPearsonCourse(Id[] parentIds, integer howMany, string itemName){
        PearsonCourseStructure__c[] courses = buildPearsonCourseStructure(parentIds, howMany, 'Course', itemName);
        
        integer i = 0;
        for(PearsonCourseStructure__c item : courses){
            item.Pearson_Course_Structure_Name__c = item.Name;
            item.Pearson_Course_Structure_Code__c = 'XXX' + datetime.now().millisecond() + i++;
        }
        
        return courses;
    }
    
    /*
     *Build a SINGLE generic PearsonCourseStructure__c object
     */
    //private static PearsonCourseStructure__c buildSinglePearsonCourseStructure(Id parentId, string itemName, string courseType, Id recordType, integer itemCount){
     private static PearsonCourseStructure__c buildSinglePearsonCourseStructure(Id parentId, string itemName, string courseType, integer itemCount){
        
        PearsonCourseStructure__c pcs = new PearsonCourseStructure__c();
        pcs.Active_Indicator__c = true;
        pcs.Type__c = courseType;
        //pcs.RecordTypeId = recordType;
        pcs.Name = itemName + string.valueOf(itemCount);
        pcs.Parent_Pearson_Course_Structure__c = parentId;
        
        return pcs;
    }
    
    
    public static Apttus_Config2__ClassificationName__c buildCategories(){
        
        Apttus_Config2__ClassificationName__c cat = new Apttus_Config2__ClassificationName__c(Name = 'TestCat', Apttus_Config2__HierarchyLabel__c = 'TestCat', Apttus_Config2__Active__c = true);
        insert cat;
        return cat;
    }
    
    private static Apttus_Config2__ClassificationHierarchy__c buildSingleClassificationHierarchy(Id parentId, string itemName, string courseType, integer itemCount){
        
        Apttus_Config2__ClassificationHierarchy__c pcs = new Apttus_Config2__ClassificationHierarchy__c();
        //pcs.Active_Indicator__c = true;
        pcs.Type__c = courseType;
        //pcs.RecordTypeId = recordType;
        pcs.Name = itemName + string.valueOf(itemCount);
        pcs.Apttus_Config2__AncestorId__c = parentId;
        pcs.Apttus_Config2__Label__c = itemName + string.valueOf(itemCount);
        pcs.Apttus_Config2__HierarchyId__c = buildCategories().Id;
        pcs.Region__c = 'US';
        return pcs;
    }
    public static Apttus_Config2__ClassificationHierarchy__c[] buildClassificationHier(Id[] parentIds, integer howMany, string courseType, string itemName){
        //Get the record type based upon the type specified by the user
        //string recordTypeLikeName = '%' + courseType + '%';
        
        //RecordType[] rt = [select Id, Name
        //                    from RecordType
        //                    where SobjectType = 'PearsonCourseStructure__c'
        //                    and Name like :recordTypeLikeName];
        //Make sure this has returned just one record
        //system.assertEquals(1, rt.size(), 'Problem finding PearsonCourseStructure__c recordtype for ' + courseType);
        
        list<Apttus_Config2__ClassificationHierarchy__c> courses = new list<Apttus_Config2__ClassificationHierarchy__c>();
        
        //If these items are top of the heap,  we don't need to add parent ids
        if(parentIds == null){
            for(integer i = 0 ; i < howMany ; i++){
                //courses.add(buildSinglePearsonCourseStructure(null, itemName, courseType, rt[0].Id, i));
                courses.add(buildSingleClassificationHierarchy(null, itemName, courseType, i));
            }
        }
        else{
            //If they're child items,  loop though each parent and add the id to the item as it's created
            for(Id parent : parentIds){
                for(integer i = 0 ; i < howMany ; i++){
                    //courses.add(buildSinglePearsonCourseStructure(parent, itemName, courseType, rt[0].Id, i));
                    courses.add(buildSingleClassificationHierarchy(parent, itemName, courseType, i));
                }
            }
        }
        
        return courses;
    }
    
    public static Apttus_Config2__ClassificationHierarchy__c[] buildPearsonCourseHier(Id[] parentIds, integer howMany, string itemName){
        Apttus_Config2__ClassificationHierarchy__c[] courses = buildClassificationHier(parentIds, howMany, 'Course', itemName);
        
        integer i = 0;
        for(Apttus_Config2__ClassificationHierarchy__c item : courses){
            item.Pearson_Course_Structure_Name__c = item.Name;
            item.Pearson_Course_Structure_Code__c = 'XXX' + datetime.now().millisecond() + i++;
        }
        
        return courses;
    }
}