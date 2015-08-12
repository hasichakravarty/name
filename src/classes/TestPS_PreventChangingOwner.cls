@isTest
private class TestPS_PreventChangingOwner  //Unit Test class
{   
 static testMethod void myUnitTest()  //test method 
  {
     Test.Starttest(); 
     Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
      User usr = new User(Alias = 'standt',Market__c='ZA',Line_of_Business__c='Schools',Geography__c='Core',Email='standarduser@testorg.com',EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='America/Los_Angeles', UserName='standarduser1234876@testorg.com');
     System.runAs(usr) {
     List<account>AccList = TestDataFactory.createaccount(5,'Learner');
     List<Account> AccList2 = new List<Account>();
     List<Contact>conList = TestDataFactory.createContact(5);
     Map<id,account>OldMap = new Map<id,account>();
     Map<id,Contact>oldMap1 = new Map<id,Contact>();
     List<Account> newAcc = new List<Account>();
     List<Account> AccList1 = new List<Account>();
     insert AccList;
     insert ConList;
     User u1 = [select id from user where name =:'Pearson'] ;
        For(account acc2 :AccList)
           {
           acc2.ownerid = u1.id;
           AccList2.add(acc2);
           }
          Update AccList2;
          User u = [select id from user where name =:'***Enrollment Services'] ;     
          List<RecordType> rt = [SELECT Id, Name FROM RecordType WHERE SobjectType = 'Account' AND Name =:'Learner' LIMIT 1]; 
          for(Integer i=6;i<11;i++){ 
            Account accountRecord = new Account(Name= i+'Test Account' , Phone='+9100000' + i, ShippingCountry = 'India', ShippingCity = 'Bangalore', ShippingStreet = 'BNG' + i, ShippingPostalCode = '560037' +i);   
             if(rt.size() > 0){                //Set the record type of the account   
                accountRecord.RecordTypeId = rt[0].Id;
                System.debug('@@accountRecord.ownerid -->'+accountRecord.ownerid ); 
                newAcc.add(accountRecord);
                               } 
             }
           insert newAcc; 
           For(account acc3 :newAcc)
           {
            acc3.ownerid = u.id;
            AccList1.add(acc3);
           }
           Update AccList1 ;
           for(account acc1 :newAcc)          
           for( Account acc : AccList)
           {
              OldMap.put(acc1.id,acc);
              System.debug('@@@ old account owner--> ' +acc.ownerid);
              System.debug('@@@ new account owner--> ' +acc1.ownerid);
              }
                           
           for( Contact con1 : ConList)
              OldMap1.put(con1.id,con1);

              Test.Stoptest(); 
              system.debug('@@ oldmap value-->'+OldMap+ 'accountList-->'+AccList+ 'OldList-->' +newAcc);
              PS_PreventChangingOwner.PreventChangingAccountOwner(newAcc,oldMap);
              PS_PreventChangingOwner.PreventChangingContactOwner(ConList,oldMap1);       
   }
}

}
/*
 List<Contact> contactList = new List<Contact>();   
                  Account AccountRec = new account(Name='Test Account1', Phone='+9100000' , ShippingCountry = 'India', ShippingCity = 'Bangalore', ShippingState='Karnataka', ShippingStreet = 'BNG', ShippingPostalCode = '560037'); 
                  for(Integer i=6;i<11;i++){ 
                    Contact contactRecord = new Contact(FirstName='TestContactFirstname'+ i, LastName='TestContactLastname' + i,AccountId=AccountRec.Id ,Salutation='MR.', Email='sampleemailaddress' + i + '@email.com',Phone='111222333' + i);                
                    contactRecord.ownerid = u.id;
                    contactList.add(contactRecord);
                        
                        }
                        Insert ContactList ;
*/