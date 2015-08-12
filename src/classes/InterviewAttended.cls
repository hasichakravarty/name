public class InterviewAttended{ 
  @InvocableMethod
    public static void OpportuntiyId(List<Id> EventId) {
    System.debug('I am inside');   
    if(EventId!=null){
    System.debug(EventId);       
     Set<ID> setWithOpptyID = new Set<ID>();
     List<OpportunityContactRole> ContactRoles = new List<OpportunityContactRole>();
     Messaging.SingleEmailMessage[] MailList = new Messaging.SingleEmailMessage[]{};
     List<Event> Et = new List<Event>();
     Et = [Select id,subject__c,Sponsor_Attended__c,Status__c,whatID from Event where Id IN:EventId];
     System.debug(Et);       
     for(Event eventVal : Et)
     {
         setWithOpptyID.add(eventVal.whatID);
     }    
     if(!setWithOpptyID.isEmpty())
     {        
         ContactRoles = [SELECT Contact.Name,Contact.Email,Role FROM OpportunityContactRole WHERE OpportunityId IN :setWithOpptyID and (Role=:'Primary Sales Contact' Or Role=:'Decision Maker')];
     }
     for(Event eveList : Et)
     {     
     if(eveList.Status__c=='Completed' && eveList.Sponsor_Attended__c==True){
     Set<String> studentEmailIds = new Set<String>();
     Set<String> SponsorEmailIds = new Set<String>();
      
     for(OpportunityContactRole oc:ContactRoles){
      if(oc.contact.Email!=null && oc.Role=='Decision Maker'){
       studentEmailIds.add(oc.contact.Email);}
       else if(oc.contact.Email!=null && oc.Role=='Primary Sales Contact'){
        SponsorEmailIds.add(oc.contact.Email); }
        }
     
     String[] toaddress = new String[]{};
      toaddress.addall(studentEmailIds); 
     String[] toaddress1 = new String[]{};
      toaddress1.addall(SponsorEmailIds);
     
     if(toaddress!=null){
      for(String s:toaddress){
      Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
      String subject = 'Student - Thanks for Attending Interview';
      String Body = '<html><body><FONT face=Calibri size=3><p>Dear Student';
      body+='<br>Thanks for Attending Interview,<br>Thank you,<br> System Administrator</font></body></html>';
      mail.setsubject(subject);
      mail.setHtmlBody(body);
      string[] studenttoaddress = New String[]{s}; 
      mail.setToAddresses(studenttoaddress);
      MailList.add(mail);
       }
      }
     if(toaddress1!=null){
      for(String S:toaddress1){
      Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
      String subject = 'Sponsor - Thanks for Attending Interview';
      String Body = '<html><body><FONT face=Calibri size=3><p>Dear Sponsor';
      body+='<br>Thanks for Attending Interview,<br>Thank you,<br> System Administrator</font></body></html>';
      mail.setsubject(subject);
      mail.setHtmlBody(body);
      string[] sptoaddress = New String[]{s}; 
      mail.setToAddresses(sptoaddress);
      MailList.add(mail);
      }
     }
    }
    }
    for(Event eveLst : Et)
    {    
    if(eveLst.Status__c=='Completed' && eveLst.Sponsor_Attended__c==False){
      Set<String> studentEmailIds = new Set<String>();
     Set<String> SponsorEmailIds = new Set<String>();
     ContactRoles = [SELECT Contact.Name,Contact.Email,Role FROM OpportunityContactRole WHERE OpportunityId IN :setWithOpptyID and (Role=:'Primary Sales Contact' Or Role=:'Decision Maker')]; 
     for(OpportunityContactRole oc:ContactRoles){
      if(oc.contact.Email!=null && oc.Role=='Decision Maker'){
       studentEmailIds.add(oc.contact.Email);}
       else if(oc.contact.Email!=null && oc.Role=='Primary Sales Contact'){
        SponsorEmailIds.add(oc.contact.Email); }
        }
     
     String[] toaddress = new String[]{};
      toaddress.addall(studentEmailIds); 
     String[] toaddress1 = new String[]{};
      toaddress1.addall(SponsorEmailIds);
     
     if(toaddress!=null){
      for(String s:toaddress){
      Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
      String subject = 'Student - Thanks for Attending Interview';
      String Body = '<html><body><FONT face=Calibri size=3><p>Dear Student';
      body+='<br>Thanks for Attending Interview,<br>Thank you,<br> System Administrator</font></body></html>';
      mail.setsubject(subject);
      mail.setHtmlBody(body);
      string[] studenttoaddress = New String[]{s}; 
      mail.setToAddresses(studenttoaddress);
      MailList.add(mail);
       }
      }
     if(toaddress1!=null){
      for(String S:toaddress1){
      Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
      String subject = 'Sponsor - Meeting time to Speak';
      String Body = '<html><body><FONT face=Calibri size=3><p>Dear Sponsor';
      body+='<br>Please let us know the suitable time to Meet Over,<br>Thank you,<br> System Administrator</font></body></html>';
      mail.setsubject(subject);
      mail.setHtmlBody(body);
      string[] sptoaddress = New String[]{s}; 
      mail.setToAddresses(sptoaddress);
      MailList.add(mail);
      }
     }
    }
    }
    System.debug(MailList);       
    if(MailList.size()!=0){               
      try{
       Messaging.sendEmail(MailList);
      }catch(Exception e)
       {  
        system.debug('Error------>'+e);
       } 
     }
   }
  }
 }