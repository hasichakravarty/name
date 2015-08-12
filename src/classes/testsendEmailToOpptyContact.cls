@isTest(SeeAllData=true)
private class testsendEmailToOpptyContact
{
    
    //Test the notifications generated when an opp is created from lead conversion
    static testMethod void test1()
    {   
        Profile pr = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        
        User us = new User();
        us.Alias = 'theuser';
        us.Email='theuser@test.com.test';
        us.EmailEncodingKey='UTF-8';
        us.LanguageLocaleKey='en_US';
        us.LocaleSidKey = 'en_ZA';
        us.LastName='TheUser';
        us.ProfileId = pr.Id;
        us.TimeZoneSidKey='Africa/Johannesburg';
        us.UserName='theuser@test.com.test';
        us.Geography__c = 'Growth';
        us.Market__c = 'ZA';
        us.Line_of_Business__c = 'Higher Ed';
        
        
        System.RunAs(us)
        {
            String li = GenerateD2LLead(true, true, true);
            
            Lead l = [SELECT Id FROM Lead WHERE Id = :li];
            
            // Convert the lead
            Database.LeadConvert lc = new Database.LeadConvert();
            lc.setLeadId(l.Id);
            LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
            lc.setConvertedStatus(convertStatus.MasterLabel);
            
            System.debug('ONTC Conversion Status: '+convertStatus.MasterLabel);
            
            if(PS_lead_createContact.processedLead.contains(l.Id))
            {
                PS_lead_createContact.processedLead.remove(l.Id);
            }
                    
            Test.startTest();
            System.debug('ONTC ABOUT TO CONVERT THE LEAD');
            Database.LeadConvertResult lcr = Database.convertLead(lc);
            System.debug('ONTC LEAD CONVERTED');
            
            Test.stopTest();
            
            String errorString = '';
            
            if(!lcr.isSuccess()){
                List<Database.Error> conversionErrorList = lcr.getErrors();
                for(Database.Error er :conversionErrorList)
                {
                    errorString = errorString + ' ' + er.getFields() + ' - '+ er.getMessage();
                }
            }
            
            System.assert(lcr.isSuccess(), errorString);
            
            String OppId = lcr.getOpportunityId();
            String ContId = lcr.getContactId();
            String AccId = lcr.getAccountId();
            
            //Verify the Account
            Account acc = [SELECT Id, RecordType.Name
                          FROM Account
                          WHERE Id = :AccId];
            
            System.assert(acc!= null);
            System.assertEquals('Learner',acc.RecordType.Name);
            
            //Verify the Contact
            Contact con = [SELECT Id, RecordType.Name, AccountId
                           FROM Contact
                           WHERE Id = :ContId];
            
            System.assert(con!= null);
            System.assertEquals('Global Contact',con.RecordType.Name);
            System.assertEquals(AccId,con.AccountId);
            
            //Verify the values of the opportunity
            Opportunity opp = [SELECT Id, Type, Geography__c, Market__c, Line_of_Business__c,
                               RecordType.DeveloperName
                               FROM Opportunity
                               WHERE Id = :OppId LIMIT 1];  
                    
            System.assertEquals('Growth',opp.Geography__c,'The opp do not have the right geography');  
                    
            System.assertEquals('ZA',opp.Market__c,'The opp do not have the right market');  
                    
            System.assertEquals('Higher Ed',opp.Line_of_Business__c,'The opp do not have the right LOB');   
    
            System.assertEquals('D2L',opp.RecordType.DeveloperName,'The opp do not have the right record type');  
            
            //System.assertEquals('New Business',opp.Type,'The opp do not have the right type');  
            
            //Verify the opp contact roles
            List<OpportunityContactRole> OppContactRoleList = [SELECT Id, Role
                                                                FROM OpportunityContactRole
                                                                WHERE OpportunityId = :opp.Id];
        
            //System.assertEquals(2,OppContactRoleList.size(),'The opp do not have the right contact roles');
            
            //Verify the values of outbound notifications
            Integer numOutNot = [SELECT COUNT()
                                FROM Outbound_Notification__c
                                WHERE Opportunity__c = :opp.Id
                                AND Event__c IN ('Interview Attendance With Sponsor','Interview Attendance')]; 
            
            //System.assertEquals(2,numOutNot);
            
        }
    }
    
    
    
    //Test the notifications generated when an opp is created from lead conversion
    static testMethod void test2()
    {
        Profile pr = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        
        User us = new User();
        us.Alias = 'theuser';
        us.Email='theuser@test.com.test';
        us.EmailEncodingKey='UTF-8';
        us.LanguageLocaleKey='en_US';
        us.LocaleSidKey = 'en_ZA';
        us.LastName='TheUser';
        us.ProfileId = pr.Id;
        us.TimeZoneSidKey='Africa/Johannesburg';
        us.UserName='theuser@test.com.test';
        us.Geography__c = 'Growth';
        us.Market__c = 'ZA';
        us.Line_of_Business__c = 'Higher Ed';
        
        
        System.RunAs(us)
        {
            String li = GenerateD2LLead(true, true, false);
            
            Lead l = [SELECT Id FROM Lead WHERE Id = :li];
          
            // Convert the lead
            Database.LeadConvert lc = new Database.LeadConvert();
            lc.setLeadId(l.Id);
            LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
            lc.setConvertedStatus(convertStatus.MasterLabel);
            
            System.debug('ONTC Conversion Status: '+convertStatus.MasterLabel);
            
            if(PS_lead_createContact.processedLead.contains(l.Id))
            {
                PS_lead_createContact.processedLead.remove(l.Id);
            }
            
            Test.startTest();
            System.debug('ONTC ABOUT TO CONVERT THE LEAD');
            Database.LeadConvertResult lcr = Database.convertLead(lc);
            System.debug('ONTC LEAD CONVERTED');
            Test.stopTest();
            
            String errorString = '';
            
            if(!lcr.isSuccess()){
                List<Database.Error> conversionErrorList = lcr.getErrors();
                for(Database.Error er :conversionErrorList)
                {
                    errorString = errorString + ' ' + er.getFields() + ' - '+ er.getMessage();
                }
            }
            
            System.assert(lcr.isSuccess(), errorString);
            
            String OppId = lcr.getOpportunityId();
            String ContId = lcr.getContactId();
            String AccId = lcr.getAccountId();
            
            //Verify the Account
            Account acc = [SELECT Id, RecordType.Name
                          FROM Account
                          WHERE Id = :AccId];
            
            System.assert(acc!= null);
            System.assertEquals('Learner',acc.RecordType.Name);
            
            //Verify the Contact
            Contact con = [SELECT Id, RecordType.Name, AccountId
                           FROM Contact
                           WHERE Id = :ContId];
            
            System.assert(con!= null);
            System.assertEquals('Global Contact',con.RecordType.Name);
            System.assertEquals(AccId,con.AccountId);
            
            //Verify the values of the opportunity
            Opportunity opp = [SELECT Id, Type, Geography__c, Market__c, Line_of_Business__c,
                               RecordType.DeveloperName
                               FROM Opportunity
                               WHERE Id = :OppId LIMIT 1];  
                    
            System.assertEquals('Growth',opp.Geography__c,'The opp do not have the right geography');  
                    
            System.assertEquals('ZA',opp.Market__c,'The opp do not have the right market');  
                    
            System.assertEquals('Higher Ed',opp.Line_of_Business__c,'The opp do not have the right LOB');   
    
            System.assertEquals('D2L',opp.RecordType.DeveloperName,'The opp do not have the right record type');  
            
            //System.assertEquals('New Business',opp.Type,'The opp do not have the right type');  
            
            //Verify the opp contact roles
            List<OpportunityContactRole> OppContactRoleList = [SELECT Id, Role
                                                                FROM OpportunityContactRole
                                                                WHERE OpportunityId = :opp.Id];
        
            //System.assertEquals(2,OppContactRoleList.size(),'The opp do not have the right contact roles');
            
            //Verify the values of outbound notifications
            Integer numOutNot = [SELECT COUNT()
                                FROM Outbound_Notification__c
                                WHERE Opportunity__c = :opp.Id
                                AND Event__c IN ('Speak to Sponsor','Interview Attendance')]; 
            
            //System.assertEquals(2,numOutNot);
        }
    }
    
    /*************************************************************************************************************
    * Name        : GenerateRandomString
    * Description : Generates a random string with a specific lenght
    * Input       : StringLenghtNumber - Lenght of the randon string to generate
    * Output      : Random String value
    *************************************************************************************************************/
    public static String GenerateRandomString(Integer StringLenghtNumber)
    {
        Blob blobKey = crypto.generateAesKey(128);
        String Key = EncodingUtil.convertToHex(blobKey);
        String RandomString = Key.substring(0,StringLenghtNumber);
        
        return RandomString;
    }
    
    public static String GenerateD2LLead(Boolean WithSponsor, Boolean WithIntervewEvent, Boolean EventWithSponsorAttendance)
    {
        Map<String, Schema.SObjectType> sObjectMap = Schema.getGlobalDescribe() ;
        
        //Retrieve the D2L Record Type
        Schema.SObjectType leadob = sObjectMap.get('Lead') ; 
        Schema.DescribeSObjectResult leadSchema = leadob.getDescribe() ;
        Map<String,Schema.RecordTypeInfo> LeadrecordTypeInfo = leadSchema.getRecordTypeInfosByName(); 
        String D2LLeadRecordTypeId = LeadrecordTypeInfo.get('D2L').getRecordTypeId();
        
        //Retrieve record type of an Organisation account  
        Schema.SObjectType accob = sObjectMap.get('Account') ; 
        Schema.DescribeSObjectResult AccSchema = accob.getDescribe() ;
        Map<String,Schema.RecordTypeInfo> AccrecordTypeInfo = AccSchema.getRecordTypeInfosByName(); 
        String OrgAccRecordTypeId = AccrecordTypeInfo.get('Organisation').getRecordTypeId();                                

        //Create a School organisation account
        Account schoolacc = new Account();
        schoolacc.Name = GenerateRandomString(15);
        schoolacc.Organisation_Type__c = 'School';
        schoolacc.Type__c = 'Other';
        schoolacc.Geography__c = 'Growth';
        schoolacc.Line_of_Business__c= 'Schools';
        schoolacc.Market__c = 'ZA';
        schoolacc.RecordTypeId = OrgAccRecordTypeId;
        schoolacc.ShippingCountry = 'South Africa';
        schoolacc.ShippingState = 'Limpopo';
        schoolacc.ShippingCity = GenerateRandomString(10);
        schoolacc.ShippingStreet = GenerateRandomString(10);
        schoolacc.ShippingPostalCode = GenerateRandomString(5);
        schoolacc.Phone = '+934534623445';
        schoolacc.Email__c = GenerateRandomString(15)+'@test.com.test';
        schoolacc.Academic_Achievement__c = 'Other';
        
        insert schoolacc;
        
        //Lead
        Lead l = new Lead();
        l.FirstName = GenerateRandomString(15);
        l.LastName = GenerateRandomString(15);
        l.Company = '-';
        l.Geography__c = 'Growth';
        l.Market__c = 'ZA';
        l.Line_of_Business__c = 'Higher Ed';
        l.RecordTypeId = D2LLeadRecordTypeId;
        l.Preferred_Contact_Method__c = 'Email';
        l.Email =  GenerateRandomString(15)+'@test.com.test';
        l.Country = 'South Africa';
        l.City = GenerateRandomString(10);
        l.Street = GenerateRandomString(10);
        l.PostalCode = GenerateRandomString(5);
        l.Status = 'Qualified';
        l.LeadSource = 'Walk-In';
        l.Interview_Attendance__c = true;
        l.Country_of_Origin__c  = 'South Africa';
        l.Institution_Organisation__c = schoolacc.Id;
        l.Preferred_Campus__c = 'Cape Town';
        l.international_student__c = 'No';
        
        if(WithSponsor)
        {
            l.Sponsor_Type__c = 'Parent';
            l.Sponsor_Sponsor__c = GenerateRandomString(15);
            l.Sponsor_Name__c = GenerateRandomString(15) ;
            l.Sponsor_Preferred_Method_of_Contact__c = 'Email';
            l.Sponsor_Email__c = GenerateRandomString(15) +'@test.com.test';
            l.Sponsor_Address_Street__c = GenerateRandomString(10);
            l.Sponsor_Address_City__c = GenerateRandomString(10);
            l.Sponsor_Address_ZIP_Postal_Code__c = GenerateRandomString(5);
            l.Sponsor_Address_Country__c = 'South Africa';
        }
        else
        {
            l.Sponsor_Type__c = 'Self';
        }
        
        Database.DMLOptions dmo = new Database.DMLOptions();
        dmo.assignmentRuleHeader.useDefaultRule = false;
        l.setOptions(dmo);
        
        //Create the lead
        
        System.debug('ONTC ABOUT TO INSERT THE LEAD');
        
        insert l;
        
        System.debug('ONTC LEAD HAS BEEN INSERTED');
        
        if(WithIntervewEvent)
        {
            //Retrieve record type of an Interview Event   
            Schema.SObjectType eventob = sObjectMap.get('Event') ; 
            Schema.DescribeSObjectResult EventSchema = eventob.getDescribe() ;
            Map<String,Schema.RecordTypeInfo> EventrecordTypeInfo = EventSchema.getRecordTypeInfosByName(); 
            String InterviewRecordTypeId = EventrecordTypeInfo.get('Interview').getRecordTypeId(); 
        
            //Generate an interview event for the lead without Sponsor
            Event e = new Event();
            e.WhoId = l.Id;
            e.Subject = 'Meeting';
            e.Location = 'Location 1';
            e.Status__c = 'Completed';
            e.Type__c = 'Virtual Meeting';
            e.subject__c = 'Lead Interview';
            e.RecordTypeId = InterviewRecordTypeId;
            e.DurationInMinutes = 20;
            e.ActivityDateTime = System.now();
            e.Outcome__c = 'Interested';
            
            if(WithSponsor && EventWithSponsorAttendance)
            {
                e.Sponsor_Attended__c = true;
            }
                
            insert e;
        }
        
        return l.Id;
    }
}