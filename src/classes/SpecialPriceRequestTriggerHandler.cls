public with sharing class SpecialPriceRequestTriggerHandler {
 
    private boolean m_isExecuting = false;
    private integer iBatchSize = 0;
 
    public SpecialPriceRequestTriggerHandler(boolean isExecuting, integer iSize){
        m_isExecuting = isExecuting;
        iBatchSize = iSize;
    }
 
    public void OnBeforeInsert(Special_Price_Request__c[] updatedObjects){
        // EXECUTE BEFORE INSERT LOGIC
       
        set<Id> setOppIds = new set<Id>();
        map<id,list<OpportunityTeamMember>> mapOppIdOppteam = new map<Id,list<OpportunityTeamMember>>();// stores Opportunity Id and List of Opp team Members.
        map<id,list<Relationship__c>> mapAccRelation = new map<Id,list<Relationship__c>>();
        Map<Id,Id> mapOppIdOUC = new Map<Id,Id>();
        Map<Id,Id> mapOppSpl= new Map<Id,Id>();
        Map<Id,Opportunity> lstOpp;// = new list<Opportunity>(); // Stores list of opportunity which satisfy the condition of status = 'completed'
        set<Id> setAccountId = new set<Id>();
        system.debug('Before Insert trigger Special Pricing Request');
        for(Special_Price_Request__c objspecial:updatedObjects){
                setOppIds.add(objspecial.Opportunity__c);
                mapOppSpl.put(objspecial.Id,objspecial.Opportunity__c);
        }
       
        if(setOppIds != null && !setOppIds.isEmpty()){
            lstOpp = new Map<Id,Opportunity>([select id,Name ,AccountId,Special_Price_Request_Open__c,(Select UserId, Name, TeamMemberRole, Job_Function__c From OpportunityTeamMembers WHERE Job_Function__c = 'Learning Technology Specialist'),(Select id, Opportunity__c, UniversityCourse__c from OpportunityUniversityCourses__r) from Opportunity WHERE Id IN: setOppIds]);
        //code added for Special_Price_Request_Open__c checkbox
        //List<Opportunity> oppToUpdate= new List<Opportunity>();
            for(Special_Price_Request__c objspecial:updatedObjects){
             if(lstOpp.get(mapOppSpl.get(objspecial.Id)) != null){ 
                 
            Opportunity op =  lstOpp.get(mapOppSpl.get(objspecial.Id));
            system.debug('Opportunity :'+op);
           // oppToUpdate.add(lstOpp.Opportunity__r)
            if(op.Special_Price_Request_Open__c){
                objspecial.addError('A Special Price Request is already open');
            }
            else{
               op.Special_Price_Request_Open__c = true;
            }
           
                setAccountId.add(op.AccountId);
                if(op.OpportunityTeamMembers.size()>0){
                    for(OpportunityTeamMember objteam:op.OpportunityTeamMembers){
                        list<OpportunityTeamMember> tempTeam = new list<OpportunityTeamMember>();
                      if(mapOppIdOppteam.get(op.Id) == null){
                          tempTeam.add(objteam);
                          mapOppIdOppteam.put(op.Id,tempTeam);
                      }else{
                          tempTeam = mapOppIdOppteam.get(op.Id);
                          tempTeam.add(objteam);
                         mapOppIdOppteam.put(op.Id,tempTeam);
                      }
                    }                  
                }
                // Assignee first courses on the opportunity to the special price request.
                if(op.OpportunityUniversityCourses__r.size()>0){
                    for(OpportunityUniversityCourse__c OUC:op.OpportunityUniversityCourses__r){
                        //List<OpportunityUniversityCourse__c> OUCtemp = new List<OpportunityUniversityCourse__c>();
                        if(mapOppIdOUC.get(OUC.Opportunity__c) == null && OUC.UniversityCourse__c != null){
                            mapOppIdOUC.put(OUC.Opportunity__c, OUC.UniversityCourse__c);
                        }
                    }
                }
            }
            }
       /* for(Opportunity op: lstOpp){
           // oppToUpdate.add(lstOpp.Opportunity__r)
            if(op.Special_Price_Request_Open__c= true){
                this.addError('A Special Price Request is already open');
            }
            else{
           op.Special_Price_Request_Open__c= true;
            }
 
       }
*/
           /* for(Opportunity obj:lstOpp){
                setAccountId.add(obj.AccountId);
                if(obj.OpportunityTeamMembers.size()>0){
                    for(OpportunityTeamMember objteam:obj.OpportunityTeamMembers){
                        list<OpportunityTeamMember> tempTeam = new list<OpportunityTeamMember>();
                      if(mapOppIdOppteam.get(obj.Id) == null){
                          tempTeam.add(objteam);
                          mapOppIdOppteam.put(obj.Id,tempTeam);
                      }else{
                          tempTeam = mapOppIdOppteam.get(obj.Id);
                          tempTeam.add(objteam);
                          mapOppIdOppteam.put(obj.Id,tempTeam);
                      }
                    }                  
                }
                // Assignee first courses on the opportunity to the special price request.
                if(obj.OpportunityUniversityCourses__r.size()>0){
                    for(OpportunityUniversityCourse__c OUC:obj.OpportunityUniversityCourses__r){
                        //List<OpportunityUniversityCourse__c> OUCtemp = new List<OpportunityUniversityCourse__c>();
                        if(mapOppIdOUC.get(OUC.Opportunity__c) == null && OUC.UniversityCourse__c != null){
                            mapOppIdOUC.put(OUC.Opportunity__c, OUC.UniversityCourse__c);
                        }
                    }
                }
            }*/
           
            for(Account objAcc:[Select id,Name, (Select Id, Name, Related_To__c,Related_To__r.Name From Relationships__r) From Account WHERE Id IN: setAccountId]){
                if(objacc.Relationships__r.size()>0){
                    for(Relationship__c objr:objacc.Relationships__r){
                        list<Relationship__c> tempRelation = new list<Relationship__c>();
                      if(mapAccRelation.get(objAcc.Id) == null){
                          tempRelation.add(objr);
                          mapAccRelation.put(objAcc.Id,tempRelation);
                      }else{
                          tempRelation = mapAccRelation.get(objAcc.Id);
                          tempRelation.add(objr);
                          mapAccRelation.put(objAcc.Id,tempRelation);
                      }
                    }
                }
            }
           
            
            for(Special_Price_Request__c objspecial:updatedObjects){
                String objAccountNum = '';
                objspecial.Account_Numbers__c = '';
                if(mapOppIdOppteam.containsKey(objspecial.Opportunity__c) && mapOppIdOppteam.get(objspecial.Opportunity__c) != null ){
                    objspecial.LTS_Name__c = mapOppIdOppteam.get(objspecial.Opportunity__c)[0].UserId;
                }
                if(mapAccRelation.containsKey(objspecial.AccountId__c) && mapAccRelation.get(objspecial.AccountId__c) != null){
                    for(Relationship__c objr : mapAccRelation.get(objspecial.AccountId__c)){
                        if(objr.Related_To__r.Name != null){
                            objAccountNum += objr.Related_To__r.Name +'\r\n';
                        }
                    }
                    objspecial.Account_Numbers__c = objAccountNum;
                }
                if(mapOppIdOUC.get(objspecial.Opportunity__c) != null){
                    objspecial.Course__c = mapOppIdOUC.get(objspecial.Opportunity__c);
                }
            }
   
                if(lstOpp != null && !lstOpp.isEmpty()){
                   
                    try{
                        update lstOpp.values();
                    }catch (exception E){
                        System.debug('Erron in updating Opportunity :'+ E );
                    }
                }
        }
    }
 
    public void OnAfterInsert(Special_Price_Request__c[] newObjects){
        // EXECUTE AFTER INSERT LOGIC
        List<Id> oppty_Id = new List<Id>();
        Map<Id,List<OpportunityLineItem>> MapOpptyLineitem = new Map<Id,List<OpportunityLineItem>>();
        List<Special_Price_Products__c> Specialproduct = new List<Special_Price_Products__c>();
        system.debug ('in SpecialPriceRequestTriggerHandler OnAfterInsert method');
        for(Special_Price_Request__c eachspecialprice :newObjects){
            if(eachspecialprice.Opportunity__c != null){
               oppty_Id.add(eachspecialprice.Opportunity__c);
            }
        }
       
        if(oppty_Id != null && !oppty_Id.isEmpty()){
          List<OpportunityLineItem> OpptyLineItem = [Select Id, OpportunityId, OptionId__c, Quantity, UnitPrice, Product2Id, CurrencyIsoCode from OpportunityLineItem where OpportunityId in: oppty_Id];
          if(OpptyLineItem != null && !OpptyLineItem.isEmpty()){
              for(OpportunityLineItem eachopptylineitem :OpptyLineItem){
                  List<OpportunityLineItem> tempopptyline = new List<OpportunityLineItem>();
                  if(MapOpptyLineitem.get(eachopptylineitem.OpportunityId) == null){
                      tempopptyline.add(eachopptylineitem);
                      MapOpptyLineitem.put(eachopptylineitem.OpportunityId,tempopptyline);
                  }else{
                      tempopptyline = MapOpptyLineitem.get(eachopptylineitem.OpportunityId);
                      tempopptyline.add(eachopptylineitem);
                      MapOpptyLineitem.put(eachopptylineitem.OpportunityId,tempopptyline);
                  }
                      
                  }
                for(Special_Price_Request__c eachspecialprice :newObjects){
                    if(eachspecialprice.Opportunity__c != null && MapOpptyLineitem.get(eachspecialprice.Opportunity__c) != null){
                        for(OpportunityLineItem eachopptylineitem :MapOpptyLineitem.get(eachspecialprice.Opportunity__c)){
                            Special_Price_Products__c tempspecialproduct = new Special_Price_Products__c();
                            tempspecialproduct.Special_Price_Request__c = eachspecialprice.Id;
                            tempspecialproduct.Opportunity__c = eachopptylineitem.OpportunityId;
                            tempspecialproduct.Product__c = eachopptylineitem.Product2Id;
                            tempspecialproduct.Quantity__c = eachopptylineitem.Quantity;
                            tempspecialproduct.UnitPrice__c = eachopptylineitem.UnitPrice;
                            tempspecialproduct.CurrencyIsoCode = eachopptylineitem.CurrencyIsoCode;
                            tempspecialproduct.Opportunity_Line_Item__c=eachopptylineitem.Id;
                           
                            
                            Specialproduct.add(tempspecialproduct);
                        }
                       
                        
                    }
                }
               
                if(Specialproduct != null && !Specialproduct.isEmpty()){
                   
                    try{
                        insert Specialproduct;
                    }catch (exception E){
                        System.debug('Erron in inserting Special_Price_Products :'+ E );
                    }
                }
                 
              }
            
              
          }
         
        }
       
    public void OnBeforeUpdate(Special_Price_Request__c[] oldObjects, Special_Price_Request__c[] updatedObjects, map<ID, Special_Price_Request__c> MapObjectMap){
         //BEFORE UPDATE LOGIC
        
                                System.debug('in before update trigger');
                               
                                List<Special_Price_Request__c>updatedRequests= new List<Special_Price_Request__c>();
                                for(Special_Price_Request__c eachspecialprice: updatedObjects){
                                   
                                  if(eachspecialprice.Status__c == 'Completed' && MapObjectMap.get(eachspecialprice.Id).Status__c !='Completed')
                                   updatedRequests.add(eachspecialprice);
                                }
                                if(updatedRequests != null && ! updatedRequests.isEmpty()){
                                    User Usr = new User();
                                    Usr = [SELECT  Id FROM User WHERE Id = : UserInfo.getUserId()];
                                    system.debug('Usr  :'+Usr);
                                                               
                                    Group Queue= [Select Id from Group where type ='Queue' and DeveloperName = 'Special_Pricing_Monitoring_Group' Limit 1];
                                    List<GroupMember> QueueMembers = [Select UserOrGroupId From GroupMember where GroupId =: Queue.Id and UserOrGroupId =: Usr.Id];
                                    system.debug('QueueMembers :'+QueueMembers);
                                   
                                    if(QueueMembers == null || QueueMembers.isEmpty()){
                                        for(Special_Price_Request__c updatePrice: updatedRequests){
                                            system.debug('throwing error');
                                                string errormsg = 'Only a Special Pricing Approver can complete approval request';
                                                updatePrice.addError(errormsg);
                                        }
                                    }
 
                                  
 
                                }
                               
                                
         
         
             
         }
    public void OnAfterUpdate(Special_Price_Request__c[] oldObjects, Special_Price_Request__c[] updatedObjects, map<ID, Special_Price_Request__c> MapObjectMap){
        // AFTER UPDATE LOGIC
        system.debug('in SpecialPriceRequestTriggerHandler OnAfterUpdate method');
        List<Special_Price_Request__c>completedspecialrequest = new List<Special_Price_Request__c>();
        List < Messaging.SingleEmailMessage > mails = new List < Messaging.SingleEmailMessage > (); // list of mail to be send.
        List<Special_Price_Request__c> specialRequests = new List<Special_Price_Request__c>();
        List<string> opptylineitemid = new List<string>();
        Map<Id,Opportunity>Optty;
        Set<Id>OpttyID= New Set<Id>();
        List<Special_Price_Products__c> specialproducts = new List<Special_Price_Products__c>();
        Map<Id,OpportunityLineItem> opptylineitem = new Map<Id,OpportunityLineItem>();
        string baseURL = URL.getSalesforceBaseUrl().toExternalForm();// building Base URL.
        list < string > teamEmail = new list < string > {System.label.SpecialPricingEmail};
       
        
        for(Special_Price_Request__c eachspecialprice :updatedObjects){
            if(eachspecialprice.Status__c == 'Completed' && MapObjectMap.get(eachspecialprice.Id).Status__c !='Completed'||
               eachspecialprice.Status__c == 'Rejected' && MapObjectMap.get(eachspecialprice.Id).Status__c !='Rejected'||
               eachspecialprice.Status__c == 'Recalled' && MapObjectMap.get(eachspecialprice.Id).Status__c !='Recalled'){
                   
               completedspecialrequest.add(eachspecialprice);
               OpttyID.add(eachspecialprice.Opportunity__c);
               specialRequests.add(eachspecialprice);
               if(eachspecialprice.Status__c == 'Completed' && MapObjectMap.get(eachspecialprice.Id).Status__c !='Completed'){
                  /*Email Body */
                   string body = ' A Special Price Request has been approved and is ready for your review.' + '<br/><br/>';
                    body += 'The Request can be viewed at the following link: <br/>' + ' ';
                    body += baseURL + '/' +eachspecialprice.id ;
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.setToAddresses(teamEmail);
                    mail.setSubject('Special Price Request Approved :'+eachspecialprice.Name);
                    mail.setHtmlBody(body);
                    mails.add(mail);
               }
            }
       
        }
        system.debug('completedspecialrequest :'+completedspecialrequest);
        system.debug('OpttyID :'+OpttyID);
       
        if(OpttyID != null && !OpttyID.isEmpty()){
           Optty = new Map <Id, Opportunity> ( [Select Id,Special_Pricing_Approval__c,Special_Price_Request_Open__c From Opportunity where ID in: OpttyID]);
          
           }
           for(Special_Price_Request__c eachspecialprice :specialRequests){
             if (eachspecialprice.Status__c == 'Completed' &&  Optty.get(eachspecialprice.Opportunity__c)!= null){
                 Optty.get(eachspecialprice.Opportunity__c).Special_Price_Request_Open__c = false;
                 Optty.get(eachspecialprice.Opportunity__c).Special_Pricing_Approval__c = true;
                 system.debug('Optty.get(eachspecialprice.Opportunity__c).Special_Price_Request_Open__c :'+Optty.get(eachspecialprice.Opportunity__c).Special_Price_Request_Open__c);
                 system.debug('Optty.get(eachspecialprice.Opportunity__c).Special_Pricing_Approval__c :'+Optty.get(eachspecialprice.Opportunity__c).Special_Pricing_Approval__c);
            }
            else if (eachspecialprice.Status__c== 'Recalled' || eachspecialprice.Status__c== 'Rejected' &&  Optty.get(eachspecialprice.Opportunity__c)!= null){
            Optty.get(eachspecialprice.Opportunity__c).Special_Price_Request_Open__c= false;
            } 
           }
      
        system.debug('mails ---->'+mails);
        if(specialRequests != null && !specialRequests.isEmpty()){
            specialproducts = [Select Id,Requested_Price__c, Approved_Price__c, Opportunity_Line_Item__c From Special_Price_Products__c where Special_Price_Request__c in: specialRequests];
           
        }
        if(specialproducts != null && !specialproducts.isEmpty()){
            for(Special_Price_Products__c eachspecialprice :specialproducts){
                if(eachspecialprice.Approved_Price__c == null )
                    eachspecialprice.Approved_Price__c = eachspecialprice.Requested_Price__c;
                opptylineitemid.add(eachspecialprice.Opportunity_Line_Item__c);
            }
            for(OpportunityLineItem eachopptylineitem : [select id, Discount, UnitPrice  from OpportunityLineItem where Id in:opptylineitemid]){
                opptylineitem.put(eachopptylineitem.Id, eachopptylineitem);
            }
           
            if(opptylineitem != null && !opptylineitem.isEmpty()){
               for(Special_Price_Products__c eachspecialprice :specialproducts){
                    if(opptylineitem.get(eachspecialprice.Opportunity_Line_Item__c) != null){
                        OpportunityLineItem tempopptyline = new OpportunityLineItem();
                        tempopptyline = opptylineitem.get(eachspecialprice.Opportunity_Line_Item__c);
                        system.debug('tempopptyline.UnitPrice :'+tempopptyline.UnitPrice);
                        system.debug('eachspecialprice.Approved_Price__c :'+eachspecialprice.Approved_Price__c);
                        system.debug('eachspecialprice.Requested_Price__c :'+eachspecialprice.Requested_Price__c);
                        if(tempopptyline.UnitPrice != 0.00 && eachspecialprice.Approved_Price__c != null )
                            tempopptyline.Discount = ((tempopptyline.UnitPrice - eachspecialprice.Approved_Price__c) * 100 )/tempopptyline.UnitPrice;
                            system.debug('tempopptyline.Discount  :'+tempopptyline.Discount);
                    }
                }
            }
               try{
                   update specialproducts;
                   update opptylineitem.values();
                  
               } catch (exception E){
               System.debug('Error in updateing Special Price Products :'+ E );
            }
        }
       
        try{
            if(Optty!= null && !Optty.isEmpty()){
                       update Optty.values();
                   }
        }catch (exception E){
               System.debug('Error in updating Opportunity:'+ E );
        }
        list<Messaging.SendEmailResult> results = Messaging.sendEmail(mails);
            system.debug('results --->'+results);
    }
   
        
 
    public boolean IsTriggerContext{
        get{ return m_isExecuting;}
    }
}