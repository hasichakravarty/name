global class PS_oneCRMProductSelectorPermission{
//public String errorString{get;set;}
//public ID opptyId{get;set;}
//public ID opptyProdId{get;set;}  
webService static String checkPermission(String oppID) 
{
    String errorString = '';
    ID slgUserId = UserInfo.getUserId(); 
    ID opptyId = oppID;
    User slgUser = new User();
    UserRecordAccess oppEditAccess = new UserRecordAccess();
    String spstatus = Label.PS_SpecialPriceStatus;
    List<Special_Price_Request__c> specialPriceRequest = new List<Special_Price_Request__c>();
    slgUser=[select id,price_list__c from User where id =: slgUserId]; 
    System.debug(slgUser.price_list__c);
    if (slgUser.price_list__c == '' || slgUser.price_list__c == null)
    { 
        System.debug(slgUser.price_list__c);
        errorString = 'User is not associated with Price List. Please check with System Administrator.';
    }//end of price list check
    else
    { 
        //To check whether user has edit access to the opportunity
        if(slgUserId != null && opptyId != null)
        {
        oppEditAccess =[Select RecordId, HasEditAccess FROM UserRecordAccess WHERE UserId =: slgUserId And RecordId =: opptyId]; 
        if(oppEditAccess.HasEditAccess == true)
            {
                //to check whether is there any special price request processing for the opportunity
                specialPriceRequest = [Select Id,Status__c from Special_Price_Request__c where Opportunity__c =: opptyId And Status__c != 'Completed' And Status__c != 'Rejected' And Status__c != 'Recalled'];
                SYstem.debug(opptyId);
                if (specialPriceRequest.size() > 0)
                    {
                        errorString = 'A Special Price Request is pending for this Opportunity. Products cannot be edited until the request is completed.';
                    }
                    else
                    {
                        errorString = 'redirectUser';  
                    }
            }//end of conditional check for user access and special price request
           
        else
        {
            errorString = 'You do not have the level of access necessary to perform the operation you requested. Please contact the owner of the record or your administrator if access is necessary.';
        }
        }
     
    }
   return errorString;
}
/*public pageReference checkPermission() 
{
    opptyId  = ApexPages.currentPage().getParameters().get('oppId');
    if(ApexPages.currentPage().getParameters().get('productfamilyid') != null)
    {
        opptyProdId  = ApexPages.currentPage().getParameters().get('productfamilyid');
    }    
    errorString = '';
    ID slgUserId = UserInfo.getUserId(); 
    User slgUser = new User();
    UserRecordAccess oppEditAccess = new UserRecordAccess();
    String spstatus = Label.PS_SpecialPriceStatus;
    List<Special_Price_Request__c> specialPriceRequest = new List<Special_Price_Request__c>();
    slgUser=[select id,price_list__c from User where id =: slgUserId]; 
    System.debug(slgUser.price_list__c);
    if (slgUser.price_list__c == '' || slgUser.price_list__c == null)
    { 
        System.debug(slgUser.price_list__c);
        errorString = 'User is not associated with Price List. Please check with System Administrator.';
    }//end of price list check
    else
    { 
        //To check whether user has edit access to the opportunity
        if(slgUserId != null && opptyId != null)
        {
        oppEditAccess =[Select RecordId, HasEditAccess FROM UserRecordAccess WHERE UserId =: slgUserId And RecordId =: opptyId]; 
        if(oppEditAccess.HasEditAccess == true)
            {
                //to check whether is there any special price request processing for the opportunity
                specialPriceRequest = [Select Id,Status__c from Special_Price_Request__c where Opportunity__c =: opptyId And Status__c != 'Completed' And Status__c != 'Rejected' And Status__c != 'Recalled'];
                SYstem.debug(opptyId);
                if (specialPriceRequest.size() > 0)
                    {
                        errorString = 'A Special Price Request is pending for this Opportunity. Products cannot be edited until the request is completed.';
                    }
                    else
                    {
                        errorString = 'redirectUser';  
                    }
            }//end of conditional check for user access and special price request
           
        else
        {
            errorString = 'You do not have the level of access necessary to perform the operation you requested. Please contact the owner of the record or your administrator if access is necessary.';
        }
        }
     }   
    return null; 
}*/
}