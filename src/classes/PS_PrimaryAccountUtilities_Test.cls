@isTest
private class PS_PrimaryAccountUtilities_Test {

	private static testMethod void test() {
	    List<User> usrLst = TestDataFactory.createUser(Userinfo.getProfileId());
        insert usrLst;
         System.runas(usrLst[0]){
        Test.startTest();
	    List<Contact> contLst = TestDataFactory.createContact(5);
	    insert contLst;
	    
	    List<AccountContact__c> acccContLSt = TestDataFactory.createAccountContact(1,contLst[0].accountid , contLst[0].id);
	    insert acccContLSt;
	    

	    
	    List<Contact> contactLSt = new List<Contact>();

	    for(Contact contObj : contLst){
	            Contact contTempObj = new Contact();
	            contTempObj.id = contObj.id;
	            contTempObj.Role_Detail__c = 'Mother';
	            contTempObj.Role__c = 'Parent';
	            contactLSt.add(contTempObj);
	        
	    }
	    if(!contactLSt.isEmpty()){
	        checkRecurssion.run = true;
	            update contactLSt;
	    }
	    
	    List<AccountContact__c> accUpdatLst = new List<AccountContact__c>();
	    for(AccountContact__c accRoleeObj : acccContLSt){
	            AccountContact__c accObj = new AccountContact__c();
	            accObj.id = accRoleeObj.id;
	            accRoleeObj.Role_Detail__c = 'Professor';
	            accRoleeObj.AccountRole__c = 'Government';
	            accUpdatLst.add(accRoleeObj);
	        
	    }
	    if(!accUpdatLst.isEmpty()){
	        checkRecurssion.run = true;
	           update accUpdatLst;
	    }
	    Test.stopTest();
         }

	}

}