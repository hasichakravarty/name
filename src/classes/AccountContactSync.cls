/*******************************************************************************************************************
* Apex Class Name  : AccountContactSync
* Version          : 1.0 
* Created Date     : 19 March 2015
* Function         : Class for sync AccountContact custom object data with the standard AccountContactRole object
* Modification Log :
*
* Developer                   Date                    Description
* ------------------------------------------------------------------------------------------------------------------
*                      19/03/2015              Created Initial Version of AccountContactSync Class
*******************************************************************************************************************/
public without sharing class AccountContactSync
{

    /*************************************************************************************************************
    * Name        : GetAccountContactRoleRecords
    * Description : Get the corresponding AccountContactRole standard object records based on AccountContact custom object records
    * Input       : TargetRecords - AccountContact custom object records
    * Output      : AccountContactRole standard object records
    *************************************************************************************************************/
    public Map<ID,AccountContactRole> GetAccountContactRoleRecords(List<AccountContact__c> TargetRecords)
    {
        // Get the Ids of the synchorinzed AccountContactRole records
        List<ID> SyncIds = new List<ID>();
        
        for(AccountContact__c TargetRecord :TargetRecords){
            SyncIds.add(TargetRecord.Synchronized_Account_Contact_Role__c);
        } 
        
        // Get the synchorinzed AccountContactRole records
        List<AccountContactRole> listSyncAccountContactRoleRecords = [SELECT Id, AccountId, ContactId, Role, IsPrimary, IsDeleted FROM AccountContactRole WHERE Id IN:SyncIds ALL ROWS];
        
        Map<ID,AccountContactRole> mapSyncAccountContactRoleRecords = new Map<ID,AccountContactRole>(listSyncAccountContactRoleRecords );
            
        return mapSyncAccountContactRoleRecords;
    }
    
    /*************************************************************************************************************
    * Name        : SetAsNotPrimary
    * Description : Set the AccountContact custom records as not primary
    * Input       : TargetRecords - AccountContact custom object records
    * Output      : 
    *************************************************************************************************************/
    public void SetAsNotPrimary(List<AccountContact__c> TargetRecords)
    {
       List<AccountContact__c> RecordsToUpdate = new List<AccountContact__c>();
       
       for(AccountContact__c accCon :TargetRecords)
       {
           AccountContact__c accConNotPrimary = accCon;
           accConNotPrimary.Primary__c = false;
           RecordsToUpdate.add(accConNotPrimary);
       }
       
       if(RecordsToUpdate.size()>0)
       {
           update RecordsToUpdate;
       }
    }

    /*************************************************************************************************************
    * Name        : CheckMultipleAccountContactPrimaries
    * Description : Check if the list contains more that one record for the same account is set as primary
    * Input       : TargetRecords - AccountContact custom object records
    * Output      : 
    *************************************************************************************************************/
    public void CheckMultipleAccountContactPrimaries(List<AccountContact__c> TargetRecords)
    {
        
        //Group the AccountContact records set as primary by Account
        Map<ID, List<AccountContact__c>> mapTargetRecordsPrimaryMarkedByAccount = new Map<ID, List<AccountContact__c>>();
        
        for(AccountContact__c accCon :TargetRecords)
        {
            if(accCon.Primary__c)
            {
                if(mapTargetRecordsPrimaryMarkedByAccount.containsKey(accCon.Account__c))
                {
                    List<AccountContact__c> tempListAccCon = new List<AccountContact__c>(mapTargetRecordsPrimaryMarkedByAccount.get(accCon.Account__c));
                    tempListAccCon.add(accCon);
                    mapTargetRecordsPrimaryMarkedByAccount.put(accCon.Account__c,tempListAccCon);
                }
                else{
                
                    List<AccountContact__c> newListAccCon = new List<AccountContact__c>();
                    newListAccCon.add(accCon);
                    mapTargetRecordsPrimaryMarkedByAccount.put(accCon.Account__c,newListAccCon);
                }
            }
        }
        
        //Check if there are multiple AccountContact records set as primary for the same account
        List<ID> ListAccountIDs = new List<ID>(mapTargetRecordsPrimaryMarkedByAccount.keySet());
        
        for(ID accId :ListAccountIDs)
        {
            if(mapTargetRecordsPrimaryMarkedByAccount.get(accId).size()>1)
            {
                for(AccountContact__c accConWithError :mapTargetRecordsPrimaryMarkedByAccount.get(accId))
                {
                    accConWithError.addError('More than one contact is set as primary');
                }
            }
        }
        
    }
    /*************************************************************************************************************
    * Name        : InsertAccountContactRoleRecords
    * Description : Insert a record on the AccountContactRole standard object per each AccountContact custom object record with sync information
    * Input       : NewRecords - AccountContact custom object records
    * Output      : 
    *************************************************************************************************************/
    public void InsertAccountContactRoleRecords(List<AccountContact__c> NewRecords)
    {
        System.debug('NewRecords----'+NewRecords);
        List<AccountContactRole> SyncRecords = new List<AccountContactRole>();
        
        List<AccountContact__c> OriginalRecords = [SELECT Id, Contact__c, Account__c, AccountRole__c, Primary__c FROM AccountContact__c WHERE Id IN:NewRecords];
        system.debug('OriginalRecords---->'+OriginalRecords);
        Map<ID,AccountContact__c> mapOriginalRecords = new Map<ID,AccountContact__c>(OriginalRecords);
        
        List<AccountContact__c> OriginalRecordsToUpdate = new List<AccountContact__c>();
        
        List<ID> NewPrimaryRecordsAccountIds = new List<ID>();
  
        //Loop the AccountContact new records
        for(AccountContact__c NewRecord :NewRecords)
        {
            //Add the primary AccountContact Account information to the collection of Account Ids
            if(NewRecord.Primary__c)
            {    
                NewPrimaryRecordsAccountIds.add(NewRecord.Account__c);
            }
            
            //Create a AccountContactRole record instance 
            AccountContactRole NewAccountContactRole = new AccountContactRole(AccountId = NewRecord.Account__c, ContactId = NewRecord.Contact__c, Role = NewRecord.AccountRole__c, IsPrimary = NewRecord.Primary__c);
            
            //Add the AccountContactRole record to the collection of records to insert
            SyncRecords.add(NewAccountContactRole);
            
            //Add the AccountContact record to the collection of records to update
            OriginalRecordsToUpdate.add(mapOriginalRecords.get(NewRecord.Id));
            
        }
        
        //For the primary AccountContact records update the existing records to not primary
        List<AccountContact__c> ExistingPrimaryRecords = [SELECT Id, Account__c, Contact__c, AccountRole__c, Primary__c FROM AccountContact__c WHERE Id NOT IN:NewRecords AND Account__c IN:NewPrimaryRecordsAccountIds AND Primary__c = true];
        
        if(ExistingPrimaryRecords.size()>0)
        {
            SetAsNotPrimary(ExistingPrimaryRecords);
        }
        
        //Insert synchorized AccountContactRole records
        if(SyncRecords.size()>0)
        {
            insert SyncRecords;
        }

        //Update AccountContact records
        
        for(Integer i=0; i<SyncRecords.size(); i++)
        {
            AccountContact__c OriginalRecordToUpdate = new AccountContact__c();
            
            OriginalRecordToUpdate = OriginalRecordsToUpdate.get(i);
            
            OriginalRecordToUpdate.Synchronized_Account_Contact_Role__c = SyncRecords.get(i).Id;
            
            OriginalRecordsToUpdate.set(i,OriginalRecordToUpdate);
        }
        
        if(OriginalRecordsToUpdate.size()>0)
        {
            update OriginalRecordsToUpdate;
        }
    }

    /*************************************************************************************************************
    * Name        : UpdateAccountContactRoleRecords
    * Description : Update the records on the AccountContactRole standard object to be sync with the AccountContact custom object records
    * Input       : UpdatedRecords - AccountContact custom object records
    * Output      : 
    *************************************************************************************************************/
    public void UpdateAccountContactRoleRecords(List<AccountContact__c> UpdatedRecords)
    {
        List<AccountContactRole> SyncRecordsToUpdate = new List<AccountContactRole>();
        
        List<ID> UpdatedPrimaryRecordsAccountIds = new List<ID>();
    
        //Get the synchronized AccountContactRole records
        Map<ID,AccountContactRole> SyncRecords = GetAccountContactRoleRecords(UpdatedRecords);
    
        //Loop the AccountContact updated records
        for(AccountContact__c UpdatedRecord :UpdatedRecords)
        {
            //Add the primary AccountContact Account information to the collection of Account Ids
            if(UpdatedRecord.Primary__c)
            {    
                UpdatedPrimaryRecordsAccountIds.add(UpdatedRecord.Account__c);
            }
            
            //Set the information with the corresponding AccountContactRole record
            AccountContactRole SyncRecordToUpdate = new AccountContactRole();
            
            SyncRecordToUpdate = SyncRecords.get(UpdatedRecord.Synchronized_Account_Contact_Role__c);
            
            if(SyncRecordToUpdate != null){
                SyncRecordToUpdate.ContactId = UpdatedRecord.Contact__c;
                SyncRecordToUpdate.Role = UpdatedRecord.AccountRole__c;
                SyncRecordToUpdate.IsPrimary= UpdatedRecord.Primary__c;
                
                SyncRecordsToUpdate.add(SyncRecordToUpdate);
            }
            
        }
        
        //For the primary AccountContact records update the existing records to not primary
        List<AccountContact__c> ExistingPrimaryRecords = [SELECT Id, Account__c, Contact__c, AccountRole__c, Primary__c FROM AccountContact__c WHERE Id NOT IN:UpdatedRecords AND Account__c IN:UpdatedPrimaryRecordsAccountIds AND Primary__c = true];
        
        if(ExistingPrimaryRecords.size()>0)
        {
            SetAsNotPrimary(ExistingPrimaryRecords);
        }
        
        //Update the AccountContactRole record
        if(SyncRecordsToUpdate.size()>0)
        {
            update SyncRecordsToUpdate;
        }
    }
    
    /*************************************************************************************************************
    * Name        : DeleteAccountContactRoleRecords
    * Description : Delete the records on the AccountContactRole standard object to be sync with the AccountContact custom object records
    * Input       : DeletedRecords - AccountContact custom object records
    * Output      : 
    *************************************************************************************************************/
    public void DeleteAccountContactRoleRecords(List<AccountContact__c> DeletedRecords)
    {
        List<AccountContactRole> SyncRecordsToDelete = new List<AccountContactRole>();
        
        //Get the synchronized AccountContactRole records
        Map<ID,AccountContactRole> SyncRecords = GetAccountContactRoleRecords(DeletedRecords);
        
        SyncRecordsToDelete = SyncRecords.values();
        
        //Delete the AccountContactRole records
        if(SyncRecordsToDelete.size()>0)
        {
            delete SyncRecordsToDelete;
        }
    }
    
    /*************************************************************************************************************
    * Name        : UndeleteAccountContactRoleRecords
    * Description : Recreates the records on the AccountContactRole standard object to be sync with the AccountContact custom object records
    * Input       : UndeletedRecords- AccountContact custom object records
    * Output      : 
    *************************************************************************************************************/
    public void UndeleteAccountContactRoleRecords(List<AccountContact__c> UndeletedRecords)
    {
        system.debug('inside undeleteAccount---'+UndeletedRecords);
        //Recreate the AccountContactRole records and updates the AccountContact undeleted records with the new reference
        InsertAccountContactRoleRecords(UndeletedRecords);
    }
}