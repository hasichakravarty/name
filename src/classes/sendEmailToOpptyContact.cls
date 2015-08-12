public class sendEmailToOpptyContact{ 

    public static void OppOutboundNotification(List<Opportunity> NewOpptList, Map<Id,sObject> OldOppMap, Boolean IsUpdate) {
    
        System.debug('ENTERING THE CLASS');
    	Date EarlyBirdDateFromCustSetting;
        
        //Retrieve the information from the custom setting
        List<Quote_Settings__c> CustSettList = [SELECT Early_Bird__c, Id ,Name
                                                FROM Quote_Settings__c 
                                                WHERE Name = 'System Properties'];
        
         if(! CustSettList.isEmpty())
        {
           EarlyBirdDateFromCustSetting = CustSettList.get(0).Early_Bird__c;
        }
        
        //Retrieve the opportunities information        
        List<Opportunity> OpportunityList = [SELECT Id,Name, AccountId, Primary_Contact__c, Geography__c, Market__c, Type 
                                            , Student_Registered__c, Enrolment_Status__c, isConvertedFromLead__c, StageName
                                            ,Line_of_Business__c, RecordType.DeveloperName, Registration_Payment_Reference__c, Preferred_Campus__c 
                                            FROM Opportunity 
                                            WHERE Id IN :NewOpptList];
                                            
        List<Account> CITCampusAccountsList = [SELECT Id, Pearson_Campus_Picklist__c, Phone, Fax, Bank_Account_Number__c
                                                FROM Account
                                                WHERE Pearson_Account_Number__c = 'Campus'
                                                AND Pearson_Campus__c = true
                                                AND Pearson_Institution__c = 'CTI'];
                                                
        Map<String,Account> CampusAccountMap = new Map<String,Account>();
        
        for(Account acc :CITCampusAccountsList)
        {
            CampusAccountMap.put(acc.Pearson_Campus_Picklist__c,acc);
        }
        
        
        if(OpportunityList.size()>0)
        {                                   
        
            //Get the contracts of the opportunities accounts
            List<Id> AccountIdsList = new List<Id>();
            
            for(Opportunity opp :OpportunityList)
            {
                AccountIdsList.add(opp.AccountId);
            }
            List<Contract> AccountContractsList = [SELECT Id, AccountId, Opportunity__c
                                                    FROM Contract
                                                    WHERE AccountId IN :AccountIdsList];
            
            Map<Id,List<Contract>> AccountContractsMap = new Map<Id,List<Contract>> ();
            
            for(Contract contr :AccountContractsList)
            {
                if(AccountContractsMap.containsKey(contr.AccountId))
                {
                    AccountContractsMap.get(contr.AccountId).add(contr);
                }
                else
                {
                    List<Contract> tempLst = new List<Contract>();
                    tempLst.add(contr);
                    AccountContractsMap.put(contr.AccountId,tempLst);
                }
            }
                                                
            //Get the contact roles per opportunities
            List<OpportunityContactRole> OppContactRolesList = [SELECT ContactId, Contact.Name, Contact.Firstname, Contact.lastname, Contact.Email, Role, OpportunityId  
                                                                FROM OpportunityContactRole 
                                                                WHERE OpportunityId IN :OpportunityList 
                                                                AND (Role ='Business User' OR Role = 'Primary Sales Contact')];    
                                                                
            Map<Id,List<OpportunityContactRole>> MapOpptyContactRoles = new Map<Id,List<OpportunityContactRole>>();
            
            for(OpportunityContactRole ocr :OppContactRolesList){
     
                if(MapOpptyContactRoles.containsKey(ocr.OpportunityId))
                    MapOpptyContactRoles.get(ocr.OpportunityId).add(ocr);
                else{
                    List<OpportunityContactRole> tempLst = new List<OpportunityContactRole>();
                    tempLst.add(ocr);
                    MapOpptyContactRoles.put(ocr.OpportunityId,tempLst);
                }
      
            }
            
            //Get the Lead Interviews with no sponsor attendance for the opportunities
            List<Event> OppEventList = [SELECT Id, WhatId, Sponsor_Attended__c 
                                        FROM Event
                                        WHERE WhatId IN :OpportunityList 
                                        AND subject__c = 'Lead Interview'
                                        AND Status__c = 'Completed'];
            
            Map<Id,List<Event>> MapOppEventsNoSponsor = new Map<Id,List<Event>>();
            
            Map<Id,List<Event>> MapOppEventsWithSponsor = new Map<Id,List<Event>>();
            
            for(Event oppev :OppEventList){
                if(oppev.Sponsor_Attended__c == true)
                {
                    if(MapOppEventsWithSponsor.containsKey(oppev.WhatId))
                        MapOppEventsWithSponsor.get(oppev.WhatId).add(oppev);
                    else{
                        List<Event> tempLst = new List<Event>();
                        tempLst.add(oppev);
                        MapOppEventsWithSponsor.put(oppev.WhatId,tempLst);
                    }
                }
                else
                {
                    if(MapOppEventsNoSponsor.containsKey(oppev.WhatId))
                        MapOppEventsNoSponsor.get(oppev.WhatId).add(oppev);
                    else{
                        List<Event> tempLst = new List<Event>();
                        tempLst.add(oppev);
                        MapOppEventsNoSponsor.put(oppev.WhatId,tempLst);
                    }
                }
            }
            
            List<Outbound_Notification__c> OutbNotToCreate = new List<Outbound_Notification__c>();
            
            for(Opportunity opp :OpportunityList)
            {
                Opportunity oldopp = (OldOppMap !=null)?(Opportunity)OldOppMap.get(opp.Id):null;
                
                System.debug('ENTERING THE CLASS WITH OPP: '+opp.Id);
                //Determinte the event that triggers the notification
                List<String> EventsList = new List<String>();
                String EventName = '';
                
                if(opp.RecordType.DeveloperName == 'D2L' && opp.Geography__c == 'Growth' && opp.Market__c == 'ZA' && opp.Line_of_Business__c == 'Higher Ed')
                {
                    System.debug('STUDENT REGISTER FLAG: ' +opp.Student_Registered__c);
                    System.debug('HAS CONTRACT?: '+AccountContractsMap.containsKey(opp.AccountId));
                    System.debug('THE OPP TYPE: '+ opp.Type);
                    System.debug('IS CONVERTED FROM LEAD: '+ opp.isConvertedFromLead__c);
                    System.debug('IS AND UPDATE: '+IsUpdate );
                    System.debug('EVENT WHIT NO SPONSOR?: '+ MapOppEventsNoSponsor.containsKey(opp.Id));
                    System.debug('EVENT WHIT WITH SPONSOR?: '+ MapOppEventsWithSponsor.containsKey(opp.Id));
                    System.debug('THE OPP PREFERRED CAMPUS: ' + opp.Preferred_Campus__c);
                
                    if(IsUpdate && opp.Type == 'New Business' && oldopp.Registration_Payment_Reference__c == NULL && (opp.Registration_Payment_Reference__c != NULL && opp.Registration_Payment_Reference__c != '') && (!AccountContractsMap.containsKey(opp.AccountId)))
                    {
                        EventName = 'Payment Registration';
                        EventsList.add(EventName);
                    }
                    else if(IsUpdate && opp.Type == 'New Business' && oldopp.StageName != 'Negotiation' && opp.StageName == 'Negotiation' && (!AccountContractsMap.containsKey(opp.AccountId)))
                    {
                        EventName = 'Student Registration';
                        EventsList.add(EventName);
                    }
                    else if(IsUpdate && (opp.Type == 'New Business' || opp.Type == 'Returning Business') && opp.Enrolment_Status__c == 'Enrolled' && oldopp.Enrolment_Status__c != 'Enrolled')
                    {
                        EventName = 'Student Enrolment';
                        EventsList.add(EventName);
                    }
                    else if(IsUpdate == false && opp.Type == 'New Business' && opp.isConvertedFromLead__c == true)
                    {
                        if(MapOppEventsNoSponsor.containsKey(opp.Id))
                        {
                            EventName = 'Speak to Sponsor';
                            EventsList.add(EventName);
                        }
                        else if(MapOppEventsWithSponsor.containsKey(opp.Id))
                        {
                            EventName = 'Interview Attendance With Sponsor';
                            EventsList.add(EventName);
                        }
                        
                        EventName = 'Interview Attendance';
                        EventsList.add(EventName);
                    }
                }
                
                System.debug('ENTERING THE CLASS WITH EVENT: '+ EventsList);
                
                for(String ev :EventsList)
                {
                    System.debug('ENTERING THE LOOP OF EVENTS WITH EVENT: '+ev);
                    // Define the outbound notifications to be created    
                    if( MapOpptyContactRoles.containsKey(opp.Id) && ((ev == 'Payment Registration')
                        || (ev == 'Student Registration')
                        || (ev == 'Student Enrolment')))
                    {
                        for(OpportunityContactRole conrol :MapOpptyContactRoles.get(opp.Id))
                        {           
                            if(conrol.Role == 'Business User')
                            {
                                Outbound_Notification__c outnot = new Outbound_Notification__c();
                                outnot.Account__c = opp.AccountId;
                                outnot.Contact__c = conrol.ContactId;
                                outnot.Current_Date__c = System.Today();
                                outnot.Early_Bird_Date__c = EarlyBirdDateFromCustSetting;
                                outnot.Event__c = ev;
                                outnot.Method__c = 'Email';
                                outnot.Opportunity__c = opp.Id;
                                outnot.Type__c = 'Confirmation';
                                outnot.Type_of_Contact__c = 'Primary Contact';
                                
                                if(CampusAccountMap.containsKey(opp.Preferred_Campus__c)){
                                    outnot.Preferred_Campus_Fax__c = CampusAccountMap.get(opp.Preferred_Campus__c).Fax;
                                    outnot.Preferred_Campus_Phone__c = CampusAccountMap.get(opp.Preferred_Campus__c).Phone;
                                    outnot.Preferred_Campus_Bank_Account_Number__c = CampusAccountMap.get(opp.Preferred_Campus__c).Bank_Account_Number__c ;
                                }
                                
                                OutbNotToCreate.add(outnot);
                            }
                            else if(conrol.Role == 'Primary Sales Contact')
                            {
                                Outbound_Notification__c outnot = new Outbound_Notification__c();
                                outnot.Account__c = opp.AccountId;
                                outnot.Contact__c = conrol.ContactId;
                                outnot.Current_Date__c = System.Today();
                                outnot.Early_Bird_Date__c = EarlyBirdDateFromCustSetting;
                                outnot.Event__c = ev;
                                outnot.Method__c = 'Email';
                                outnot.Opportunity__c = opp.Id;
                                outnot.Type__c = 'Confirmation';
                                outnot.Type_of_Contact__c = 'Sponsor';
                                
                                if(CampusAccountMap.containsKey(opp.Preferred_Campus__c)){
                                    outnot.Preferred_Campus_Fax__c = CampusAccountMap.get(opp.Preferred_Campus__c).Fax;
                                    outnot.Preferred_Campus_Phone__c = CampusAccountMap.get(opp.Preferred_Campus__c).Phone;
                                    outnot.Preferred_Campus_Bank_Account_Number__c = CampusAccountMap.get(opp.Preferred_Campus__c).Bank_Account_Number__c ;
                                }
                                
                                OutbNotToCreate.add(outnot);
                            }
                        }
                    }
                    else if(MapOpptyContactRoles.containsKey(opp.Id) && (ev == 'Speak to Sponsor' || ev == 'Interview Attendance'))
                    {
                        for(OpportunityContactRole conrol :MapOpptyContactRoles.get(opp.Id))
                        {           
                            if(conrol.Role == 'Business User')
                            {
                                Outbound_Notification__c outnot = new Outbound_Notification__c();
                                outnot.Account__c = opp.AccountId;
                                outnot.Contact__c = conrol.ContactId;
                                outnot.Current_Date__c = System.Today();
                                outnot.Early_Bird_Date__c = EarlyBirdDateFromCustSetting;
                                outnot.Event__c = ev;
                                outnot.Method__c = 'Email';
                                outnot.Opportunity__c = opp.Id;
                                if(ev == 'Speak to Sponsor')
                                {
                                    outnot.Type__c = 'Request';
                                }
                                else
                                {
                                    outnot.Type__c = 'Confirmation';
                                }
                                outnot.Type_of_Contact__c = 'Primary Contact';
                                
                                if(CampusAccountMap.containsKey(opp.Preferred_Campus__c)){
                                    outnot.Preferred_Campus_Fax__c = CampusAccountMap.get(opp.Preferred_Campus__c).Fax;
                                    outnot.Preferred_Campus_Phone__c = CampusAccountMap.get(opp.Preferred_Campus__c).Phone;
                                    outnot.Preferred_Campus_Bank_Account_Number__c = CampusAccountMap.get(opp.Preferred_Campus__c).Bank_Account_Number__c ;
                                }
                                
                                OutbNotToCreate.add(outnot);
                            }
                        }
                    }
                    else if(MapOpptyContactRoles.containsKey(opp.Id) && (ev == 'Interview Attendance With Sponsor'))
                    {
                        for(OpportunityContactRole conrol :MapOpptyContactRoles.get(opp.Id))
                        {           
                            if(conrol.Role == 'Primary Sales Contact')
                            {
                                Outbound_Notification__c outnot = new Outbound_Notification__c();
                                outnot.Account__c = opp.AccountId;
                                outnot.Contact__c = conrol.ContactId;
                                outnot.Current_Date__c = System.Today();
                                outnot.Early_Bird_Date__c = EarlyBirdDateFromCustSetting;
                                outnot.Event__c = ev;
                                outnot.Method__c = 'Email';
                                outnot.Opportunity__c = opp.Id;
                                outnot.Type__c = 'Confirmation';
                                outnot.Type_of_Contact__c = 'Sponsor';
                                
                                if(CampusAccountMap.containsKey(opp.Preferred_Campus__c)){
                                    outnot.Preferred_Campus_Fax__c = CampusAccountMap.get(opp.Preferred_Campus__c).Fax;
                                    outnot.Preferred_Campus_Phone__c = CampusAccountMap.get(opp.Preferred_Campus__c).Phone;
                                    outnot.Preferred_Campus_Bank_Account_Number__c = CampusAccountMap.get(opp.Preferred_Campus__c).Bank_Account_Number__c ;
                                }
                                
                                OutbNotToCreate.add(outnot);
                            }
                        }
                    }
                }             
            }
            
            // Create Outbound Notifications
            if(OutbNotToCreate.size()>0){
                insert OutbNotToCreate;
            }
        }
    }
}