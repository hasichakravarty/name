/*******************************************************************************************************************
* Apex Class Name  : AccountContactSyncTestClass
* Version          : 1.0 
* Created Date     : 19 March 2015
* Function         : Test Class of the AccountContactSync Class
* Modification Log :
*
* Developer                   Date                    Description
* ------------------------------------------------------------------------------------------------------------------
*                         19/03/2015              Created Initial Version of AccountContactSyncTestClass
*******************************************************************************************************************/
@isTest 
private class AccountContactSyncTestClass
{

    /*************************************************************************************************************
    * Name        : VerifyValidationToAvoidInsertMultiplePrimaryContacts
    * Description : Verify the validation to avoid the insert of multiple primary contacts related with an account         
    * Input       : 
    * Output      : 
    *************************************************************************************************************/
    static testMethod void VerifyValidationToAvoidInsertMultiplePrimaryContacts()
    {
        //Get available roles
        List<String> AvailableRoles = GetAvailableRoles();
            
        //Generate Accounts
        List<Account> GeneratedAccounts = GenerateTestAccounts(6);
           
        //Generate Contacts
        List<Contact> GerenatedNonPrimaryContacts = GenerateTestContacts(100, GeneratedAccounts.get(0));
        List<Contact> GerenatedPrimaryContacts = GenerateTestContacts(10, GeneratedAccounts.get(0));
            
        //List of Accounts to include in the AccountContact generation
        List<Account> AccountsToInclude = new List<Account>();
        AccountsToInclude.add(GeneratedAccounts.get(1));
        AccountsToInclude.add(GeneratedAccounts.get(2));
        AccountsToInclude.add(GeneratedAccounts.get(3));
        AccountsToInclude.add(GeneratedAccounts.get(4));
        AccountsToInclude.add(GeneratedAccounts.get(5));
           
        //Insert AccountContacts
        List<AccountContact__c> AccountContactNonPrimaryToInsert = InitializeTestAccountContactRecord(GerenatedNonPrimaryContacts , AccountsToInclude, AvailableRoles.get(0),false);
        List<AccountContact__c> AccountContactPrimaryToInsert = InitializeTestAccountContactRecord(GerenatedPrimaryContacts , AccountsToInclude, AvailableRoles.get(0),true);
     
        List<AccountContact__c> AccountContactToInsert =  new List<AccountContact__c>();
        AccountContactToInsert.addAll(AccountContactNonPrimaryToInsert);
        AccountContactToInsert.addAll(AccountContactPrimaryToInsert);
           
           
        test.startTest();
        
        try
        {
            if(AccountContactToInsert.size()>0)
            {
                insert AccountContactToInsert;
                System.Assert(false, 'Check multiple primary contact validation did not work');
            }
        }
        catch(Exception e)
        {
            System.Assert(e.getMessage().contains('More than one contact is set as primary'));
        }  
        
        test.stopTest(); 
                     
    }

    /*************************************************************************************************************
    * Name        : VerifyValidationToAvoidUpdateMultiplePrimaryContacts
    * Description : Verify the validation to avoid the insert of multiple primary contacts related with an account 
    * Input       : 
    * Output      : 
    *************************************************************************************************************/
    static testMethod void VerifyValidationToAvoidUpdateMultiplePrimaryContacts()
    {
            //Get available roles
            List<String> AvailableRoles = GetAvailableRoles();
            
            //Generate Accounts
            List<Account> GeneratedAccounts = GenerateTestAccounts(6);
            
            //Generate Contacts
            List<Contact> GerenatedNonPrimaryContacts = GenerateTestContacts(100, GeneratedAccounts.get(0));
            List<Contact> GerenatedNonPrimaryContactsToUpdate = GenerateTestContacts(10, GeneratedAccounts.get(0));
            
            //List of Accounts to include in the AccountContact generation
            List<Account> AccountsToInclude = new List<Account>();
            AccountsToInclude.add(GeneratedAccounts.get(1));
            AccountsToInclude.add(GeneratedAccounts.get(2));
            AccountsToInclude.add(GeneratedAccounts.get(3));
            AccountsToInclude.add(GeneratedAccounts.get(4));
            AccountsToInclude.add(GeneratedAccounts.get(5));
            
            //Insert AccountContacts
            List<AccountContact__c> AccountContactNonPrimaryToInsert = InitializeTestAccountContactRecord(GerenatedNonPrimaryContacts , AccountsToInclude, AvailableRoles.get(0),false);
            List<AccountContact__c> AccountContactNonPrimaryToInsertToUpdate = InitializeTestAccountContactRecord(GerenatedNonPrimaryContactsToUpdate , AccountsToInclude, AvailableRoles.get(0),false);
            
            test.startTest();
            
            try
            {
                if(AccountContactNonPrimaryToInsert .size()>0)
                {
                    insert AccountContactNonPrimaryToInsert ;
                }
                
                if(AccountContactNonPrimaryToInsertToUpdate .size()>0)
                {
                    insert AccountContactNonPrimaryToInsertToUpdate ;
                }
                
                // Update the AccountContact records
                List<AccountContact__c> AccountContactRecordsInserted = [SELECT Id, Account__c, Contact__c, AccountRole__c, Synchronized_Account_Contact_Role__c FROM AccountContact__c WHERE Id IN:AccountContactNonPrimaryToInsertToUpdate ];
                
                List<AccountContact__c> AccountContactRecordsToUpdate = new List<AccountContact__c>();
                
                for(AccountContact__c accCon :AccountContactRecordsInserted)
                {
                    accCon.Primary__c = true;
                    AccountContactRecordsToUpdate.add(accCon);
                }
        
                if(AccountContactRecordsToUpdate.size()>0)
                {
                    update AccountContactRecordsToUpdate;
                    System.Assert(false, 'Check multiple primary contact validation did not work');
                }
                
            }
            catch(Exception e)
            {
            System.Assert(e.getMessage().contains('More than one contact is set as primary'));
            }
            
            test.stopTest();
    }

    /*************************************************************************************************************
    * Name        : VerifySyncInsertAccountContact
    * Description : Verify the synchronization between AccountContact custom object and the AccountContactRole standard object
    *                when AccountContact records are inserted
    * Input       : 
    * Output      : 
    *************************************************************************************************************/
    static testMethod void VerifySyncInsertAccountContact()
    {
        //Get available roles
        List<String> AvailableRoles = GetAvailableRoles();
        
        //Generate Accounts
        List<Account> GeneratedAccounts = GenerateTestAccounts(3);
        
        //Generate Contacts
        List<Contact> GerenatedContacts = GenerateTestContacts(198, GeneratedAccounts.get(0));
        List<Contact> FirstlyGerenatedPrimaryContacts = GenerateTestContacts(1, GeneratedAccounts.get(0));
        List<Contact> SecondlyGerenatedPrimaryContacts = GenerateTestContacts(1, GeneratedAccounts.get(0));
        
        //List of Accounts to include in the AccountContact generation
        List<Account> AccountsToInclude = new List<Account>();
        AccountsToInclude.add(GeneratedAccounts.get(1));
        AccountsToInclude.add(GeneratedAccounts.get(2));
        
        //Insert AccountContacts
        List<AccountContact__c> AccountContactToInsert = InitializeTestAccountContactRecord(GerenatedContacts, AccountsToInclude, AvailableRoles.get(0),false);
        List<AccountContact__c> FirstPrimaryAccountContactToInsert = InitializeTestAccountContactRecord(FirstlyGerenatedPrimaryContacts, AccountsToInclude, AvailableRoles.get(0),true);
        List<AccountContact__c> SecondAccountContactToInsert = InitializeTestAccountContactRecord(SecondlyGerenatedPrimaryContacts , AccountsToInclude, AvailableRoles.get(0),true);
        
        test.startTest();

        if(AccountContactToInsert.size()>0)
        {
            insert AccountContactToInsert;
        }
        if(FirstPrimaryAccountContactToInsert.size()>0)
        {
            insert FirstPrimaryAccountContactToInsert;
        }
        if(SecondAccountContactToInsert .size()>0)
        {
            insert SecondAccountContactToInsert;
        }
        
        
        
        // Assert that the synchronized AccountContactRole records have been created
        List<AccountContactRole> ExistingAccountContactRole = [SELECT Id, AccountId, ContactId, Role, IsPrimary FROM AccountContactRole];
        
        Map<ID,AccountContactRole> mapExistingAccountContactRole = new Map<ID,AccountContactRole>(ExistingAccountContactRole);
        
        List<AccountContact__c> AccountContactRecordsInserted = [SELECT Id, Account__c, Contact__c, AccountRole__c, Synchronized_Account_Contact_Role__c, Primary__c FROM AccountContact__c WHERE Id IN:AccountContactToInsert];
        
        for(AccountContact__c accCon :AccountContactRecordsInserted )
        {
            System.assert(mapExistingAccountContactRole.containsKey(accCon.Synchronized_Account_Contact_Role__c));
            System.assertEquals(accCon.Account__c,mapExistingAccountContactRole.get(accCon.Synchronized_Account_Contact_Role__c).AccountId);
            System.assertEquals(accCon.Contact__c,mapExistingAccountContactRole.get(accCon.Synchronized_Account_Contact_Role__c).ContactId);
            System.assertEquals(accCon.AccountRole__c,mapExistingAccountContactRole.get(accCon.Synchronized_Account_Contact_Role__c).Role);
            System.assertEquals(mapExistingAccountContactRole.get(accCon.Synchronized_Account_Contact_Role__c).IsPrimary,false);
        }
        
        
        List<AccountContact__c> FirstPrimaryAccountContactRecordsInserted = [SELECT Id, Account__c, Contact__c, AccountRole__c, Synchronized_Account_Contact_Role__c, Primary__c FROM AccountContact__c WHERE Id IN:FirstPrimaryAccountContactToInsert];
        
        for(AccountContact__c accCon :FirstPrimaryAccountContactRecordsInserted)
        {
            System.assert(mapExistingAccountContactRole.containsKey(accCon.Synchronized_Account_Contact_Role__c));
            System.assertEquals(accCon.Account__c,mapExistingAccountContactRole.get(accCon.Synchronized_Account_Contact_Role__c).AccountId);
            System.assertEquals(accCon.Contact__c,mapExistingAccountContactRole.get(accCon.Synchronized_Account_Contact_Role__c).ContactId);
            System.assertEquals(accCon.AccountRole__c,mapExistingAccountContactRole.get(accCon.Synchronized_Account_Contact_Role__c).Role);
            System.assertEquals(mapExistingAccountContactRole.get(accCon.Synchronized_Account_Contact_Role__c).IsPrimary,false);
        }
        
        List<AccountContact__c> SecondPrimaryAccountContactRecordsInserted = [SELECT Id, Account__c, Contact__c, AccountRole__c, Synchronized_Account_Contact_Role__c, Primary__c FROM AccountContact__c WHERE Id IN:SecondAccountContactToInsert];
        
        for(AccountContact__c accCon :SecondPrimaryAccountContactRecordsInserted )
        {
            System.assert(mapExistingAccountContactRole.containsKey(accCon.Synchronized_Account_Contact_Role__c));
            System.assertEquals(accCon.Account__c,mapExistingAccountContactRole.get(accCon.Synchronized_Account_Contact_Role__c).AccountId);
            System.assertEquals(accCon.Contact__c,mapExistingAccountContactRole.get(accCon.Synchronized_Account_Contact_Role__c).ContactId);
            System.assertEquals(accCon.AccountRole__c,mapExistingAccountContactRole.get(accCon.Synchronized_Account_Contact_Role__c).Role);
            System.assertEquals(mapExistingAccountContactRole.get(accCon.Synchronized_Account_Contact_Role__c).IsPrimary,true);
        }
        
        test.stopTest();
    }
    
    /*************************************************************************************************************
    * Name        : VerifySyncUpdateAccountContact
    * Description : Verify the synchronization between AccountContact custom object and the AccountContactRole standard object
    *                when AccountContact records are updated
    * Input       : 
    * Output      : 
    *************************************************************************************************************/
    static testMethod void VerifySyncUpdateAccountContact()
    {
        //Get available roles
        List<String> AvailableRoles = GetAvailableRoles();
        
        //Generate Accounts
        List<Account> GeneratedAccounts = GenerateTestAccounts(6);
        
        //Generate Contacts
        List<Contact> FirstGerenatedNonPrimaryContacts = GenerateTestContacts(100, GeneratedAccounts.get(0));
        List<Contact> SecondGerenatedNonPrimaryContacts = GenerateTestContacts(1, GeneratedAccounts.get(0));
        List<Contact> GerenatedPrimaryContacts = GenerateTestContacts(1, GeneratedAccounts.get(0));
        
        //List of Accounts to include in the AccountContact generation
        List<Account> AccountsToInclude = new List<Account>();
        AccountsToInclude.add(GeneratedAccounts.get(1));
        AccountsToInclude.add(GeneratedAccounts.get(2));
        AccountsToInclude.add(GeneratedAccounts.get(3));
        AccountsToInclude.add(GeneratedAccounts.get(4));
        AccountsToInclude.add(GeneratedAccounts.get(5));
        
        //Insert AccountContacts
        List<AccountContact__c> FirstNonPrimaryAccountContactToInsert = InitializeTestAccountContactRecord(FirstGerenatedNonPrimaryContacts , AccountsToInclude, AvailableRoles.get(0),false);
        List<AccountContact__c> SecondNonPrimaryAccountContactToInsert = InitializeTestAccountContactRecord(SecondGerenatedNonPrimaryContacts , AccountsToInclude, AvailableRoles.get(0),false);
        List<AccountContact__c> PrimaryAccountContactToInsert = InitializeTestAccountContactRecord(GerenatedPrimaryContacts, AccountsToInclude, AvailableRoles.get(0),true);
        
        test.startTest();

        if(FirstNonPrimaryAccountContactToInsert.size()>0)
        {
            insert FirstNonPrimaryAccountContactToInsert ;
        }
        
        if(SecondNonPrimaryAccountContactToInsert.size()>0)
        {
            insert SecondNonPrimaryAccountContactToInsert ;
        }
        
        if(PrimaryAccountContactToInsert.size()>0)
        {
            insert PrimaryAccountContactToInsert ;
        }
        
        // Update the AccountContact records
        List<AccountContact__c> AccountContactRecordsInsertedGroup1 = [SELECT Id, Account__c, Contact__c, AccountRole__c, Synchronized_Account_Contact_Role__c FROM AccountContact__c WHERE Id IN:FirstNonPrimaryAccountContactToInsert OR Id IN:PrimaryAccountContactToInsert];
        
        List<AccountContact__c> AccountContactRecordsToUpdateRole = new List<AccountContact__c>();
        
        for(AccountContact__c accCon :AccountContactRecordsInsertedGroup1)
        {
            accCon.AccountRole__c = AvailableRoles.get(1);
            AccountContactRecordsToUpdateRole.add(accCon);
        }

        List<AccountContact__c> AccountContactRecordsInsertedGroup2 = [SELECT Id, Account__c, Contact__c, AccountRole__c, Synchronized_Account_Contact_Role__c FROM AccountContact__c WHERE Id IN:SecondNonPrimaryAccountContactToInsert];
        
        List<AccountContact__c> AccountContactRecordsToUpdatePrimary = new List<AccountContact__c>();
        
        for(AccountContact__c accCon :AccountContactRecordsInsertedGroup2)
        {
            accCon.Primary__c = true;
            AccountContactRecordsToUpdatePrimary.add(accCon);
        }


        if(AccountContactRecordsToUpdateRole.size()>0)
        {
            update AccountContactRecordsToUpdateRole;
        }
        
        if(AccountContactRecordsToUpdatePrimary.size()>0)
        {
            update AccountContactRecordsToUpdatePrimary;
        }
        
        
        
        // Assert that the synchronized AccountContactRole records have been updated
        List<AccountContactRole> ExistingAccountContactRole = [SELECT Id, AccountId, ContactId, Role, IsPrimary FROM AccountContactRole];
        
        Map<ID,AccountContactRole> mapExistingAccountContactRole = new Map<ID,AccountContactRole>(ExistingAccountContactRole);
        
        List<AccountContact__c> AccountContactRecordsUpdatedRole = [SELECT Id, Account__c, Contact__c, AccountRole__c, Synchronized_Account_Contact_Role__c, Primary__c FROM AccountContact__c WHERE Id IN:AccountContactRecordsToUpdateRole];
        
        for(AccountContact__c accConUpdated :AccountContactRecordsUpdatedRole)
        {
            System.assertEquals(AvailableRoles.get(1),mapExistingAccountContactRole.get(accConUpdated.Synchronized_Account_Contact_Role__c).Role);
            System.assertEquals(false,mapExistingAccountContactRole.get(accConUpdated.Synchronized_Account_Contact_Role__c).IsPrimary);
        }
        
        List<AccountContact__c> AccountContactRecordsUpdatedPrimary = [SELECT Id, Account__c, Contact__c, AccountRole__c, Synchronized_Account_Contact_Role__c, Primary__c FROM AccountContact__c WHERE Id IN:AccountContactRecordsToUpdatePrimary];
        
        for(AccountContact__c accConUpdated :AccountContactRecordsUpdatedPrimary)
        {
            System.assertEquals(true,mapExistingAccountContactRole.get(accConUpdated.Synchronized_Account_Contact_Role__c).IsPrimary);
        }
        
        test.stopTest();
    }
    
    /*************************************************************************************************************
    * Name        : VerifySyncDeleteAccountContact
    * Description : Verify the synchronization between AccountContact custom object and the AccountContactRole standard object
    *                when AccountContact records are deleted
    * Input       : 
    * Output      : 
    *************************************************************************************************************/
    static testMethod void VerifySyncDeleteAccountContact()
    {
        //Get available roles
        List<String> AvailableRoles = GetAvailableRoles();
        
        //Generate Accounts
        List<Account> GeneratedAccounts = GenerateTestAccounts(2);
        
        //Generate Contacts
        List<Contact> GerenatedContacts = GenerateTestContacts(200, GeneratedAccounts.get(0));
        
        //List of Accounts to include in the AccountContact generation
        List<Account> AccountsToInclude = new List<Account>();
        AccountsToInclude.add(GeneratedAccounts.get(1));
        
        //Insert AccountContacts
        List<AccountContact__c> AccountContactToInsert = InitializeTestAccountContactRecord(GerenatedContacts, AccountsToInclude, AvailableRoles.get(0),false);
        
        test.startTest();

        if(AccountContactToInsert.size()>0)
        {
            insert AccountContactToInsert;
        }
        
        // Delete the AccountContact records
        List<AccountContact__c> AccountContactRecordsInserted = [SELECT Id, Account__c, Contact__c, AccountRole__c, Synchronized_Account_Contact_Role__c FROM AccountContact__c WHERE Id IN:AccountContactToInsert];
 
        List<AccountContact__c> AccountContactRecordsToDelete = new List<AccountContact__c>();
        
        AccountContactRecordsToDelete.addAll(AccountContactRecordsInserted);

        if(AccountContactRecordsToDelete.size()>0)
        {
            delete AccountContactRecordsToDelete;
        }
        
        
        
        // Assert that the synchronized AccountContactRole records have been deleted
        List<AccountContactRole> ExistingAccountContactRole = [SELECT Id, AccountId, ContactId, Role, isDeleted FROM AccountContactRole ALL ROWS];
        
        Map<ID,AccountContactRole> mapExistingAccountContactRole = new Map<ID,AccountContactRole>(ExistingAccountContactRole);
        
        List<AccountContact__c> AccountContactRecordsDeleted = [SELECT Id, Account__c, Contact__c, AccountRole__c, Synchronized_Account_Contact_Role__c FROM AccountContact__c WHERE Id IN:AccountContactRecordsToDelete ALL ROWS];
        
        for(AccountContact__c accConDeleted :AccountContactRecordsDeleted)
        {
            System.assertEquals(true,mapExistingAccountContactRole.get(accConDeleted.Synchronized_Account_Contact_Role__c).isDeleted);
        }
        test.stopTest();
     }
    
    /*************************************************************************************************************
    * Name        : VerifySyncUnDeleteAccountContact
    * Description : Verify the synchronization between AccountContact custom object and the AccountContactRole standard object
    *                when AccountContact records are undeleted
    * Input       : 
    * Output      : 
    *************************************************************************************************************/
    static testMethod void VerifySyncUnDeleteAccountContact()
    {
        //Get available roles
        List<String> AvailableRoles = GetAvailableRoles();
        
        //Generate Accounts
        List<Account> GeneratedAccounts = GenerateTestAccounts(2);
        
        //Generate Contacts
        List<Contact> GerenatedContacts = GenerateTestContacts(200, GeneratedAccounts.get(0));
        
        //List of Accounts to include in the AccountContact generation
        List<Account> AccountsToInclude = new List<Account>();
        AccountsToInclude.add(GeneratedAccounts.get(1));
        
        //Insert AccountContacts
        List<AccountContact__c> AccountContactToInsert = InitializeTestAccountContactRecord(GerenatedContacts, AccountsToInclude, AvailableRoles.get(0),false);
        
        test.startTest();

        if(AccountContactToInsert.size()>0)
        {
            insert AccountContactToInsert;
        }
        
        // Delete the AccountContact records
        List<AccountContact__c> AccountContactRecordsInserted = [SELECT Id, Account__c, Contact__c, AccountRole__c, Synchronized_Account_Contact_Role__c FROM AccountContact__c WHERE Id IN:AccountContactToInsert];
 
        List<AccountContact__c> AccountContactRecordsToDelete = new List<AccountContact__c>();
        
        AccountContactRecordsToDelete.addAll(AccountContactRecordsInserted);

        if(AccountContactRecordsToDelete.size()>0)
        {
            delete AccountContactRecordsToDelete;
        }
          
        // Undelete the AccountContact records
        
        List<AccountContact__c> AccountContactRecordsToUndelete = new List<AccountContact__c>();
        
        AccountContactRecordsToUndelete.addAll(AccountContactRecordsToDelete);
        
        if(AccountContactRecordsToUndelete.size()>0)
        {
            undelete AccountContactRecordsToUndelete;
        }
        
        test.stopTest();
        
        // Assert that the synchronized AccountContactRole records have been re-created
        List<AccountContactRole> ExistingAccountContactRole = [SELECT Id, AccountId, ContactId, Role, isDeleted FROM AccountContactRole];
        
        Map<ID,AccountContactRole> mapExistingAccountContactRole = new Map<ID,AccountContactRole>(ExistingAccountContactRole);
        
        List<AccountContact__c> AccountContactRecordsUndeleted = [SELECT Id, Account__c, Contact__c, AccountRole__c, Synchronized_Account_Contact_Role__c FROM AccountContact__c WHERE Id IN:AccountContactRecordsToUndelete];
        
        for(AccountContact__c accCon :AccountContactRecordsUndeleted )
        {
            System.assert(mapExistingAccountContactRole.containsKey(accCon.Synchronized_Account_Contact_Role__c));
            System.assertEquals(accCon.Account__c,mapExistingAccountContactRole.get(accCon.Synchronized_Account_Contact_Role__c).AccountId);
            System.assertEquals(accCon.Contact__c,mapExistingAccountContactRole.get(accCon.Synchronized_Account_Contact_Role__c).ContactId);
            System.assertEquals(accCon.AccountRole__c,mapExistingAccountContactRole.get(accCon.Synchronized_Account_Contact_Role__c).Role);
        }
     }
    
    /*************************************************************************************************************
    * Name        : GetAvailableRoles
    * Description : Retrieve the list of values from the Role picklist on the AccountContact custom object
    * Input       : 
    * Output      : List of Strings with the values of the picklist
    *************************************************************************************************************/
    public static List<String> GetAvailableRoles()
    {
        List<String> RoleOptions = new List<String>();
            
        Schema.DescribeFieldResult fieldResult = AccountContact__c.AccountRole__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            
        for( Schema.PicklistEntry f : ple)
        {
                RoleOptions.add(f.getValue());
        }    
           
        return RoleOptions;
    }
    
    /*************************************************************************************************************
    * Name        : GenerateTestAccounts
    * Description : Generate Account records
    * Input       : NumOfAccounts - Number of account records to generate
    * Output      : List of the Account records generated
    *************************************************************************************************************/
    public static List<Account> GenerateTestAccounts(Integer NumOfAccounts)
    {
        List<Account> AccountsToInsert = new List<Account>();
        
        for(Integer i=0; i<NumOfAccounts; i++)
        {
            Account AccountToInsert = new Account(Name = 'Account' + (i+1));
            
            AccountsToInsert.add(AccountToInsert);
        }
        
        if(AccountsToInsert.size()>0)
        {
            insert AccountsToInsert;
        }
        return AccountsToInsert;
    }
    
    /*************************************************************************************************************
    * Name        : GenerateTestContacts
    * Description : Generate Contact records
    * Input       : NumOfContacts - Number of contact records to generate
    *               theContactAccount - The Account record to be the primary contact account
    * Output      : List of the Contact records generated
    *************************************************************************************************************/
    public static List<Contact> GenerateTestContacts(Integer NumOfContacts, Account theContactAccount)
    {
        List<Contact> ContactsToInsert = new List<Contact>();
        for(Integer i=0; i<NumOfContacts; i++)
        {
            Contact ContactToInsert = new Contact(FirstName = GenerateRandomString(15) , LastName = GenerateRandomString(15), AccountId = theContactAccount.Id, Email = GenerateRandomString(15) + '@test.com.demo', MobilePhone = '1111111'+i);
            
            ContactsToInsert.add(ContactToInsert);
        }
        
        if(ContactsToInsert.size()>0)
        {
            insert ContactsToInsert;
        }
        
        return ContactsToInsert;
    }
    
    /*************************************************************************************************************
    * Name        : InitializeTestAccountContactRecord
    * Description : Initializates AccountContact custom object records
    * Input       : listContacts - List of Contact records
    *               listAccounts - List of Account records
    *               Role - Role value
    * Output      : List of the AccountContact records initializated
    *************************************************************************************************************/
    public static List<AccountContact__c> InitializeTestAccountContactRecord(List<Contact> listContacts, List<Account> listAccounts, String Role, Boolean IsPrimaryFlag)
    {
        List<AccountContact__c> AccountContactsToSet = new List<AccountContact__c>();
        
        for(Account acc :listAccounts)
        {      
            for(Contact con :listContacts)
            {
                AccountContact__c AccCon = new  AccountContact__c(Account__c = acc.Id, Contact__c = con.Id, AccountRole__c = Role, Primary__c = IsPrimaryFlag);
                
                AccountContactsToSet.add(AccCon);
            }
        }
        
        return AccountContactsToSet;
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
}