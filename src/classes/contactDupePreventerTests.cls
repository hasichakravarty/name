@isTest // Using isTest annotation
public class contactDupePreventerTests{
	/* AA (Deloitte) - Deactivated as UK Users not onboarded yet
 
 
    static testMethod void testContactDupPreventer() {
        String AcctRecordTypeId;
        String DiscRecordTypeId;
        String ClusterRecordTypeId;
        String OptyRecordTypeId; 
        
        List<RecordType> RecordTypeList = new List<RecordType>([select Id,Name from RecordType]);
        for (RecordType i : RecordTypeList) {
          if (i.Name == 'Bookshop') {
            AcctRecordTypeId = i.Id;
          }
          if (i.Name == '3) Discipline') {
            DiscRecordTypeId = i.Id;
          }
          if (i.Name == '2) Cluster') {
            ClusterRecordTypeId = i.Id;
          }
          if (i.Name == 'New Multi-Component') {
            OptyRecordTypeId = i.Id;
          }                    
        }        
      // First make sure there are no contacts already in the system
      // that have the email addresses used for testing
      Set<String> testEmailAddress = new Set<String>();
      testEmailAddress.add('test1@duptest.com');
      testEmailAddress.add('test2@duptest.com');
      testEmailAddress.add('test3@duptest.com');
      testEmailAddress.add('test4@duptest.com');
      testEmailAddress.add('test5@duptest.com');
      Account testAccount = new Account(Name='Test Account',
          BillingStreet = 'Street1', BillingCity = 'London', BillingPostalCode = 'ABC DEF', BillingCountry = 'UK', Vista_Account_Number__c = 'xyz',RecordTypeId= AcctRecordTypeId);
      Database.SaveResult sr = Database.insert(testAccount,false);
      id testAccountId = sr.getId();
      System.assert([SELECT count() FROM Contact
                     WHERE Email IN :testEmailAddress] == 0);
        
      // Seed the database with some contacts, and make sure they can
      // be bulk inserted successfully.
      Contact contact1 = new Contact(LastName='Test1', AccountId=testAccountId,
                            Email='test1@duptest.com');
      Contact contact2 = new Contact(LastName='Test2', AccountId=testAccountId,
                            Email='test4@duptest.com');
      Contact contact3 = new Contact(LastName='Test3', AccountId=testAccountId,
                            Email='test5@duptest.com');
      Contact[] contacts = new Contact[] {contact1, contact2, contact3};
      insert contacts;
        
      // Now make sure that some of these contacts can be changed and
      // then bulk updated successfully. Note that contact1 is not
      // being changed, but is still being passed to the update
      // call. This should be OK.
      contact2.Email = 'test2@duptest.com';
      contact3.Email = 'test3@duptest.com';
      update contacts;
        
      // Make sure that single row contact duplication prevention works
      // on insert.
      Contact dup1 = new Contact(LastName='Test1Dup',
                           AccountId=testAccountId,
                           Email='test1@duptest.com');
      try {
         insert dup1;
         System.assert(false);
      } catch (DmlException e) {
         System.assert(e.getNumDml() == 1);
         System.assert(e.getDmlIndex(0) == 0);
         System.assert(e.getDmlFields(0).size() == 1);
         //System.assert(e.getDmlFields(0)[0] == 'Email');
         //System.assert(e.getDmlMessage(0).indexOf(
            //'A contact with this email address already exists.') > -1);
      }
        
      // Make sure that single row contact duplication prevention works
      // on update.
      dup1 = new Contact(Id = contact1.Id, LastName='Test1Dup',
                      AccountId=testAccountId,
                      Email='test2@duptest.com');
      try {
         update dup1;
         System.assert(false);
      } catch (DmlException e) {
         System.assert(e.getNumDml() == 1);
         System.assert(e.getDmlIndex(0) == 0);
         System.assert(e.getDmlFields(0).size() == 1);
         //System.assert(e.getDmlFields(0)[0] == 'Email');
         //System.assert(e.getDmlMessage(0).indexOf(
           // 'A contact with this email address already exists.') > -1);
        }
    
      // Make sure that bulk contact duplication prevention works on
      // insert. Note that the first item being inserted is fine,
      // but the second and third items are duplicates. Note also
      // that since at least one record insert fails, the entire
      // transaction will be rolled back.
      dup1 = new Contact(LastName='Test1Dup', AccountId=testAccountId,
                      Email='test4@duptest.com');
      Contact dup2 = new Contact(LastName='Test2Dup',
                          AccountId=testAccountId,
                           Email='test2@duptest.com');
      Contact dup3 = new Contact(LastName='Test3Dup',
                           AccountId=testAccountId,
                           Email='test3@duptest.com');
      Contact[] dups = new Contact[] {dup1, dup2, dup3};
      try {
         insert dups;
         System.assert(false);
      } catch (DmlException e) {
         System.assert(e.getNumDml() == 2);
         System.assert(e.getDmlIndex(0) == 1);
         System.assert(e.getDmlFields(0).size() == 1);
         //System.assert(e.getDmlFields(0)[0] == 'Email');
         //System.assert(e.getDmlMessage(0).indexOf(
           // 'A contact with this email address already exists.') > -1);
         System.assert(e.getDmlIndex(1) == 2);
         System.assert(e.getDmlFields(1).size() == 1);
         //System.assert(e.getDmlFields(1)[0] == 'Email');
         //System.assert(e.getDmlMessage(1).indexOf(
           // 'A contact with this email address already exists.') > -1);
      }
    
      // Make sure that bulk contact duplication prevention works on
      // update. Note that the first item being updated is fine,
      // because the email address is new, and the second item is
      // also fine, but in this case it's because the email
      // address doesn't change. The third case is flagged as an
      // error because it is a duplicate of the email address of the
      // first contact's value in the database, even though that value
      // is changing in this same update call. It would be an
      // interesting exercise to rewrite the trigger to allow this
      // case. Note also that since at least one record update
      // fails, the entire transaction will be rolled back.
      dup1 = new Contact(Id=contact1.Id, Email='test4@duptest.com');
      dup2 = new Contact(Id=contact2.Id, Email='test2@duptest.com');
      dup3 = new Contact(Id=contact3.Id, Email='test1@duptest.com');
      dups = new Contact[] {dup1, dup2, dup3};
      try {
         update dups;
         System.assert(false);
      } catch (DmlException e) {
         System.debug(e.getNumDml());
         System.debug(e.getDmlMessage(0));
         System.assert(e.getNumDml() == 1);
         System.assert(e.getDmlIndex(0) == 2);
         System.assert(e.getDmlFields(0).size() == 1);
         //System.assert(e.getDmlFields(0)[0] == 'Email');
         //System.assert(e.getDmlMessage(0).indexOf(
           // 'A contact with this email address already exists.') > -1);
        }
        
      // Make sure that duplicates in the submission are caught when
      // inserting contacts. Note that this test also catches an
      // attempt to insert a contact where there is an existing
      // duplicate.
      dup1 = new Contact(LastName='Test1Dup', AccountId=testAccountId,
                      Email='test4@duptest.com');
      dup2 = new Contact(LastName='Test2Dup', AccountId=testAccountId,
                      Email='test4@duptest.com');
      dup3 = new Contact(LastName='Test3Dup', AccountId=testAccountId,
                      Email='test3@duptest.com');
      dups = new Contact[] {dup1, dup2, dup3};
      try {
         insert dups;
         System.assert(false);
      } catch (DmlException e) {
         System.assert(e.getNumDml() == 2);
         System.assert(e.getDmlIndex(0) == 1);
         System.assert(e.getDmlFields(0).size() == 1);
         //System.assert(e.getDmlFields(0)[0] == 'Email');
         //System.assert(e.getDmlMessage(0).indexOf(
           // 'Another new contact has the same email address.') > -1);
         System.assert(e.getDmlIndex(1) == 2);
         System.assert(e.getDmlFields(1).size() == 1);
         //System.assert(e.getDmlFields(1)[0] == 'Email');
         //System.assert(e.getDmlMessage(1).indexOf(
           // 'A contact with this email address already exists.') > -1);
      }
        
      // Make sure that duplicates in the submission are caught when
      // updating contacts. Note that this test also catches an attempt
      // to update a contact where there is an existing duplicate.
      dup1 = new Contact(Id=contact1.Id, Email='test4@duptest.com');
      dup2 = new Contact(Id=contact2.Id, Email='test4@duptest.com');
      dup3 = new Contact(Id=contact3.Id, Email='test2@duptest.com');
      dups = new Contact[] {dup1, dup2, dup3};
      try {
         update dups;
         System.assert(false);
      } catch (DmlException e) {
         System.assert(e.getNumDml() == 2);
         System.assert(e.getDmlIndex(0) == 1);
         System.assert(e.getDmlFields(0).size() == 1);
         //System.assert(e.getDmlFields(0)[0] == 'Email');
         //System.assert(e.getDmlMessage(0).indexOf(
           // 'Another new contact has the same email address.') > -1);
         System.assert(e.getDmlIndex(1) == 2);
         System.assert(e.getDmlFields(1).size() == 1);
         //System.assert(e.getDmlFields(1)[0] == 'Email');
         //System.assert(e.getDmlMessage(1).indexOf(
           // 'A contact with this email address already exists.') > -1);
      }
   }
   */
}