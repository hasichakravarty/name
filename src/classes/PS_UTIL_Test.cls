@isTest(seealldata = true)
private class PS_UTIL_Test{

	private static testMethod void recordTypeTest() {
	    
	   Map<String, Map<String,ID>> mapRecordType=  PS_Util.fetchAllRecordType();
	   
	   Map<String,ID> accountRecordMap  = mapRecordType.get('Account');
	   List<String> recNameLst = new List<String>();
	   
	   for(String recName :accountRecordMap.keySet()) {
	       recNameLst.add(recName);
	       
	   }
	   Id accountRecordId = PS_Util.fetchRecordTypeByName(Account.SObjectType , recNameLst[0]);
	   
	   List<User> usrLst = TestDataFactory.createUser(Userinfo.getProfileId());
	   insert usrLst;
	   
	   List<PermissionSet> permLst = [SELECT Id FROM PermissionSet WHERE Name = 'Pearson_Backend_Order_Creation'];
       PermissionSetAssignment psa = new PermissionSetAssignment();
       psa.AssigneeId = usrLst[1].Id;
       psa.PermissionSetId = permLst[0].Id;
       insert psa;
	   
	    
	   
	   Test.startTest();
	        Order ordWithoutError = new Order();
	        try{
    	        System.runas(usrLst[1]){    
    	             ordWithoutError =  TestDataFactory.returnorder();
    	             ordWithoutError.status = 'Open';
    	             update ordWithoutError;
    	             OrderItem itemObj = [Select id,quantity,unitprice,status__c,StatusReason__c from OrderItem where Orderid =:ordWithoutError.id];
    	             itemObj.unitPrice = 50;
    	             update itemObj;
    	             
    	             delete itemObj;
    	             
    	             delete ordWithoutError;
    	        }
	        }
	        catch(Exception ex){
	            System.debug(ex);
	         }
	         
	         
	         
	   Test.stopTest();
	    
	   
	    

	}
	
	private static testMethod void orderItemUpdateTest() {
	    List<User> usrLst = TestDataFactory.createUser(Userinfo.getProfileId());
	   insert usrLst;
	   
	   List<PermissionSet> permLst = [SELECT Id FROM PermissionSet WHERE Name = 'Pearson_Backend_Order_Creation'];
       PermissionSetAssignment psa = new PermissionSetAssignment();
       psa.AssigneeId = usrLst[1].Id;
       psa.PermissionSetId = permLst[0].Id;
       insert psa;
	   
	    
	   
	   Test.startTest();
	   
	    Order ordWithoutError = new Order();
	        //try{
    	        System.runas(usrLst[1]){    
    	             ordWithoutError =  TestDataFactory.returnorder();
    	             
    	        }
	      /*  }
	        catch(Exception ex){
	            System.debug(ex);
	         }
	         */
	         
	         
	         
	         
	        try{
    	        System.runas(usrLst[0]){

    	             OrderItem itemObj = [Select id,quantity,unitprice,status__c,StatusReason__c from OrderItem where Orderid =:ordWithoutError.id];
    	             itemObj.unitPrice = 50;
    	             itemObj.quantity = 50;
    	             itemObj.status__c = 'Testing122345';
    	             itemObj.StatusReason__c = 'Testing 555555';
    	             update itemObj;
    	             delete itemObj;

    	        }
	        }
	        catch(Exception ex){
	            Boolean expectedExceptionThrown =  ex.getMessage().contains('You do not have permission') ? true : false;
                System.AssertEquals(expectedExceptionThrown, true);
	         }
	        
	         
	         
	
	   Test.stopTest();

	   
	}
	
		private static testMethod void orderItemDeleteTest() {
	    List<User> usrLst = TestDataFactory.createUser(Userinfo.getProfileId());
	   insert usrLst;
	   
	   List<PermissionSet> permLst = [SELECT Id FROM PermissionSet WHERE Name = 'Pearson_Backend_Order_Creation'];
       PermissionSetAssignment psa = new PermissionSetAssignment();
       psa.AssigneeId = usrLst[1].Id;
       psa.PermissionSetId = permLst[0].Id;
       insert psa;
	   
	    
	   
	   Test.startTest();
	   
	    Order ordWithoutError = new Order();
	        try{
    	        System.runas(usrLst[1]){    
    	             ordWithoutError =  TestDataFactory.returnorder();
    	             
    	        }
	       }
	        catch(Exception ex){
	            System.debug(ex);
	         }
	         
	         
	         
	         
	         
	        try{
    	        System.runas(usrLst[0]){
    
    	             OrderItem itemObj = [Select id,quantity,unitprice,status__c,StatusReason__c from OrderItem where Orderid =:ordWithoutError.id];
    	            
    	            delete itemObj;

    	        }
	        }
	        catch(Exception ex){
	            Boolean expectedExceptionThrown =  ex.getMessage().contains('delete') ? true : false;
                System.AssertEquals(expectedExceptionThrown, true);
	         }
	        
	         
	         
	
	   Test.stopTest();

	   
	}
	
		private static testMethod void createOrderTest() {
	    List<User> usrLst = TestDataFactory.createUser(Userinfo.getProfileId());
	   insert usrLst;
	   
	   List<PermissionSet> permLst = [SELECT Id FROM PermissionSet WHERE Name = 'Pearson_Backend_Order_Creation'];
       PermissionSetAssignment psa = new PermissionSetAssignment();
       psa.AssigneeId = usrLst[1].Id;
       psa.PermissionSetId = permLst[0].Id;
       insert psa;
	   
	    
	   
	   Test.startTest();
	   
	    Order ordWithoutError = new Order();
	       
	         
	        try{
    	        System.runas(usrLst[1]){
    	             ordWithoutError =  TestDataFactory.returnorder();

    	        }
	        }
	        catch(Exception ex){
	            Boolean expectedExceptionThrown =  ex.getMessage().contains('Validation') ? true : false;
                //System.AssertEquals(expectedExceptionThrown, true);
	         }
	         
	         System.debug('ordWithoutError-------->'+ordWithoutError);
	         
	         try{
    	        System.runas(usrLst[0]){
    	            ordWithoutError.status = 'New';
    	             ordWithoutError.AccountId = null;
    	             ordWithoutError.EffectiveDate = system.today()+30;
    	             update ordWithoutError;

    	        }
	        }
	        catch(Exception ex){
	            Boolean expectedExceptionThrown =  ex.getMessage().contains('Validation') ? true : false;
                //System.AssertEquals(expectedExceptionThrown, true);
	         }
	        
	         
	         
	
	   Test.stopTest();

	   
	}


}