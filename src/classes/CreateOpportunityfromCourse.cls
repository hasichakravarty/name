public class CreateOpportunityfromCourse {
    
    public ID courseId;
    public String command;
    public Id oppId;
    public Opportunity Oppty_new;
    public List<OpportunityContactRole> Opptycontact_new;
    public OpportunityUniversityCourse__c new_OpportunityUniversityCourse;
    public UniversityCourse__c UnivCourse;
    public Selling_Period__c Fall_Season;
    public Selling_Period__c Spring_Season;
    public Date today_date;
    public Date Fall_start_date;
    public Date Fall_end_date;
    public Date Spring_start_date;
    public Date Spring_end_date;

    //Constructor
    public CreateOpportunityfromCourse(){
        courseId =  ApexPages.currentPage().getParameters().get('id');
        System.debug('course Id  :'+courseId);
        oppId =  ApexPages.currentPage().getParameters().get('opptyid');
        System.debug('oppId  :'+oppId);
        command = ApexPages.currentPage().getParameters().get('command');
        System.debug('comand  :'+command);
        if(courseId == null && command == null) {  
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: No course Id ');
                        ApexPages.addMessage(myMsg);
        } else {

            }
     }

    public PageReference onLoad_CourseOpptyEdit(){
        if(command == 'Opportunitycreate'){
           String redirectURL = createOppty();
           if(redirectURL != null){
               PageReference pg = new PageReference(redirectURL);
               pg.setRedirect(true);
               return pg;
           }
        }
        
        if(command =='DeleteOpportunity'){
            String redirectURL = DeleteOppty();
            if(redirectURL != null){
                PageReference pg = new PageReference(redirectURL);
                pg.setRedirect(true);
                return pg;
            }
        }
        
        if(command == 'CreateOpportunityUniversityCourse'){
            String redirectURL = CreateOpportunityUniversityCourse();
            if(redirectURL != null){
                PageReference pg = new PageReference(redirectURL);
                pg.setRedirect(true);
                return pg;
            }
        }
        
        if(command == 'CreatePearsonCourse'){
            String redirectURL = CreatePearsonCourse();
            if(redirectURL != null){
                PageReference pg = new PageReference(redirectURL);
                pg.setRedirect(true);
                return pg;
            }
        }
        
        return null;
    }
    
    public String createOppty(){
    system.debug('courseId-------->'+courseId);
        UniversityCourse__c UnivCourse = [select Id, Name,  Account__c, Fall_Enrollment__c, Spring_Enrollment__c, Winter_Enrollment__c, Summer_Enrollment__c, Adoption_Type__c
                                          from UniversityCourse__c where Id =:courseId ];
        List<UniversityCourseContact__c>  UniversityCourseContact = [select Id, Contact__c, Contact_Role__c from UniversityCourseContact__c where UniversityCourse__c =:courseId and Active__c = true];
        system.debug('contacts :'+ UniversityCourseContact);
        if(UnivCourse != Null){
            Oppty_new = new Opportunity();
            Oppty_new.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('B2B').getRecordTypeId();
            Oppty_new.Name = UnivCourse.Name;
            Oppty_new.AccountId = UnivCourse.Account__c;
            Oppty_new.StageName = Label.TA_Pending_Stage;
            Oppty_new.Amount = 0;
            Oppty_new.Fall__c = UnivCourse.Fall_Enrollment__c;
            Oppty_new.Spring__c = UnivCourse.Spring_Enrollment__c;
            Oppty_new.Winter__c = UnivCourse.Winter_Enrollment__c;
            Oppty_new.Summer__c = UnivCourse.Summer_Enrollment__c;
            Oppty_new.Adoption_Type__c = UnivCourse.Adoption_Type__c;
            Oppty_new.Market2__c = 'US';
            
             //if(today_date >= Fall_start_date && today_date <= Fall_end_date){
                    //Oppty_new.CloseDate = Date.newInstance(2015, 10, 15);
                /*if(system.Date.today().month() == 12){
                    Oppty_new.CloseDate = Date.newInstance (system.Date.today().year()+1, 10, 15);
                }else if (system.Date.today().month() >=1 && system.Date.today().month() <= 5){
                    Oppty_new.CloseDate = Date.newInstance (system.Date.today().year(), 10, 15);
                }else if (system.Date.today().month() >= 6 && system.Date.today().month() <= 11){
                    Oppty_new.CloseDate = Date.newInstance (system.Date.today().year()+1, 4, 15);
                //}else if(today_date >= Spring_start_date && today_date <= Spring_end_date){
                    //Oppty_new.CloseDate = Date.newInstance(2015, 4, 15);
                } else {
                    //Oppty_new.CloseDate = system.today();
                }*/
                
            if(system.Date.today().month() == 12 || (system.Date.today().month() >=1 && system.Date.today().month() <= 5)){
                if(system.Date.today().month() == 12){
                Oppty_new.Selling_Period__c = string.valueof(system.Date.today().year()+1)+' - Fall';
                 Oppty_new.CloseDate = Date.newInstance (system.Date.today().year(), 4, 15);
                }else{
                 Oppty_new.Selling_Period__c = string.valueof(system.Date.today().year())+' - Fall';
                 Oppty_new.CloseDate = Date.newInstance (system.Date.today().year(), 4, 15);
                }
            
            }else if(system.Date.today().month() >= 6 && system.Date.today().month() <= 11){
                Oppty_new.Selling_Period__c = string.valueof(system.Date.today().year()+1)+' - Spring';
                Oppty_new.CloseDate = Date.newInstance (system.Date.today().year(), 10, 15);
            }
            Oppty_new.Selling_Year__c = string.valueof(system.Date.today().year());
            Oppty_new.Type = null;

            
            Fall_Season = Selling_Period__c.getValues(string.valueof(system.Date.today().year())+' - Fall');
            Spring_Season = Selling_Period__c.getValues(string.valueof(system.Date.today().year())+' - Spring');
            
            if(Fall_Season != null && Spring_Season != null){
                today_date = system.Date.today();
                Fall_start_date = Fall_Season.Start_Date__c;
                Fall_end_date = Fall_Season.End_Date__c;
                Spring_start_date = Spring_Season.Start_Date__c;
                Spring_end_date = Spring_Season.End_Date__c;
                system.debug('Fall_start_date  :'+ Fall_start_date);
                system.debug('Fall_end_date  :'+Fall_end_date);
                system.debug('Spring_start_date  :'+ Spring_start_date);
                system.debug('Spring_end_date :'+Spring_end_date);
                
                String AssetfieldsList = Utils_allfields.getCreatableFieldsList('Asset');
                String soql = 'Select '+ AssetfieldsList  +', Product2.Publisher__c, Product2.Next_Edition__c, Product2.Relevance_Value__c, Product2.Competitor_Product__c, Product2.Next_Edition__r.Relevance_Value__c' +' from Asset where Course__c =: courseId AND Status__c = \'Active\' and Primary__c = true ORDER BY Product2.Copyright_Year__c Limit 1';
                system.debug('Asset query :'+soql);
                List<Asset> product_in_use = Database.query(soql);
                system.debug(' product_in_use  :'+product_in_use);
                if(product_in_use != null && !product_in_use.isEmpty()){
                    Oppty_new.StageName = Label.TA_Qualified_Stage;
                    
                    for(Asset eachPUI : product_in_use){
                        system.debug('eachPUI.Product2.Competitor_Product__c :'+eachPUI.Product2.Competitor_Product__c );
                        system.debug('eachPUI.Product2.Next_Edition__c :'+eachPUI.Product2.Next_Edition__c);
                        system.debug('eachPUI.Product2.Next_Edition__r.Relevance_Value__c :'+eachPUI.Product2.Next_Edition__r.Relevance_Value__c);
                        
                      // Opportunity Type Rollover
                      if(!eachPUI.Product2.Competitor_Product__c && eachPUI.Product2.Next_Edition__c != null && eachPUI.Product2.Next_Edition__r.Relevance_Value__c == 10){
                          Oppty_new.Type = Label.TA_Rollover_Type;
                          Oppty_new.StageName = Label.TA_Qualified_Stage;
                      }else if(!eachPUI.Product2.Competitor_Product__c && (( eachPUI.Product2.Next_Edition__c != null && eachPUI.Product2.Next_Edition__r.Relevance_Value__c != 10) || eachPUI.Product2.Next_Edition__c == null)){
                                Oppty_new.Type = Label.TA_Existing_Business_Type;
                                Oppty_new.StageName = Label.TA_Qualified_Stage;
                      } else if(eachPUI.Product2.Competitor_Product__c){
                                Oppty_new.Type = Label.TA_Takeaway_Type;
                                Oppty_new.StageName = Label.TA_Pending_Stage;
                      }
                    }
                }else{
                    //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'No assets or primary asset'));
                    //return null;
                    Oppty_new.Type = Label.TA_Takeaway_Type;
                    Oppty_new.StageName = Label.TA_Pending_Stage;
                }
                
               
            }
            try{
                system.debug('Oppty_new.stage :'+Oppty_new.StageName);
                insert Oppty_new;
                if(UniversityCourseContact != null && !UniversityCourseContact.isEmpty()){
                    Opptycontact_new = new List<OpportunityContactRole>();
                    for(UniversityCourseContact__c eachUnivcoursecontact :UniversityCourseContact){
                        OpportunityContactRole tempopptycontractRole = new OpportunityContactRole();
                        tempopptycontractRole.ContactId = eachUnivcoursecontact.Contact__c;
                        tempopptycontractRole.OpportunityId = Oppty_new.Id;
                        tempopptycontractRole.Role = 'Non-Participant';
                        Opptycontact_new.add(tempopptycontractRole);
                    }
                    system.debug('contract role :'+Opptycontact_new);
                    
                    if(Opptycontact_new != null && !Opptycontact_new.isEmpty()){
                        insert Opptycontact_new;
                    }
                }
                /*List<Asset> Opp_product_in_Use = new Opp_product_in_Use();
                if(product_in_use != null && !product_in_use.isEmpty()){
                    for(Asset eachPUI : product_in_use){
                        Asset Temp_product_in_use = new Asset();
                        Temp_product_in_use =  eachPUI.clone(false, true);
                       Temp_product_in_use.Course__c = null;
                    }
                    
                }*/
            }catch(Exception ex){
                system.debug('Exception Message---'+ ex.getMessage());
                Throw ex;
                return null;
            }
            
            String DeleteURL = '%2Fapex%2FCreateOpportunityfromCourse%3Fopptyid%3D'+Oppty_new.Id+'%26id%3D'+courseId+'%26command%3DDeleteOpportunity';
            String saveURL = '%2Fapex%2FCreateOpportunityfromCourse%3Fopptyid%3D'+Oppty_new.Id+'%26id%3D'+courseId+'%26command%3DCreateOpportunityUniversityCourse';
            String redirectURL = '/'+Oppty_new.Id+'/e?cancelURL='+DeleteURL+'&saveURL='+saveURL;
            return redirectURL;
            //https://c.cs18.visual.force.com/apex/CreateOpportunityfromCourse?opptyid=00611000009Pc6uAAC&id=a0F11000005ZXMOEA4&command=CreateOpportunityUniversityCourse&newid=00611000009Pc6u
            //String redirectURL =  Quote_create();
            //return redirectURL;
        }
        return null;
    }
    
    public String DeleteOppty(){
        system.debug(' in Delete oppty ');
        if(oppId != null && courseid != null){
            Opportunity oppty = new Opportunity(Id= oppId);
            try{
                delete oppty;
                return '/'+courseid;
            }catch(Exception ex){
                system.debug('Exception Message---'+ ex.getMessage());
                return null;
            }
        }
        return null;
    }
    
    public String CreateOpportunityUniversityCourse(){
        if(courseId != null && oppId != null) {
            UnivCourse = [select Id, Name,  Account__c, Fall_Enrollment__c, Spring_Enrollment__c, Winter_Enrollment__c, Summer_Enrollment__c, Adoption_Type__c
                                          from UniversityCourse__c where Id =:courseId ];
             Oppty_new = [select Id, Name from  Opportunity where Id =:oppId];
             
             new_OpportunityUniversityCourse =  new OpportunityUniversityCourse__c();
             new_OpportunityUniversityCourse.Opportunity__c = oppId;
             new_OpportunityUniversityCourse.UniversityCourse__c = courseId;
             new_OpportunityUniversityCourse.Close_Date__c = system.Date.today().addMonths(1);
             new_OpportunityUniversityCourse.Opportunity_University_Course_Amount__c = 0;
             new_OpportunityUniversityCourse.Account__c = UnivCourse.Account__c;
             new_OpportunityUniversityCourse.Opportunity_Name__c = Oppty_new.Name;
             new_OpportunityUniversityCourse.Fall__c = UnivCourse.Fall_Enrollment__c;
             new_OpportunityUniversityCourse.Spring__c = UnivCourse.Spring_Enrollment__c;
             new_OpportunityUniversityCourse.Summer__c = UnivCourse.Summer_Enrollment__c;
             new_OpportunityUniversityCourse.Winter__c = UnivCourse.Winter_Enrollment__c;
             new_OpportunityUniversityCourse.stage__c = 'Pending';
             new_OpportunityUniversityCourse.Adoption_Type__c = UnivCourse.Adoption_Type__c;
            
             try{
                insert new_OpportunityUniversityCourse;
                system.debug('insert success id'+new_OpportunityUniversityCourse.id);
                // create Pearson Course Equivalent 
                String returnURL = '/apex/CreateOpportunityfromCourse?opptyid='+oppId+'&id='+courseId+'&command=CreatePearsonCourse';
                return returnURL;
             }catch(Exception ex){
                    system.debug('Exception Message---'+ ex.getMessage());
                    return null;
                }
      }
        return null;
    }
    
    public String CreatePearsonCourse(){
        List<Pearson_Course_Equivalent__c> person_course = [select Id, Active__c, Course__c, Pearson_Course_Code__c, Primary__c from Pearson_Course_Equivalent__c where Course__c =:courseId];
        List<Opportunity_Pearson_Course_Code__c> oppty_Pearson_Course_Codes = new List<Opportunity_Pearson_Course_Code__c>();
        if(person_course != null && !person_course.isEmpty()){
            for(Pearson_Course_Equivalent__c eachperson_course : person_course){
                Opportunity_Pearson_Course_Code__c temp_oppty_Pearson_Course_Codes = new Opportunity_Pearson_Course_Code__c();
                temp_oppty_Pearson_Course_Codes.Opportunity__c = oppId;
                temp_oppty_Pearson_Course_Codes.Pearson_Course_Code_Name__c = eachperson_course.Pearson_Course_Code__c;
                temp_oppty_Pearson_Course_Codes.Primary__c = eachperson_course.Primary__c;
                oppty_Pearson_Course_Codes.add(temp_oppty_Pearson_Course_Codes);
            }
            
        }else {
            return '/'+oppId;
        }
        if(oppty_Pearson_Course_Codes != null && !oppty_Pearson_Course_Codes.isEmpty()){
            try{
                insert oppty_Pearson_Course_Codes;
                system.debug('insert success id'+oppty_Pearson_Course_Codes);
                return '/'+oppId;
            }catch(Exception ex){
                    system.debug('Exception Message---'+ ex.getMessage());
                    return '/'+oppId;
                }
        }
        return '/'+oppId;
    }
    
}