trigger Opportunity on Opportunity (after delete, after insert, after undelete, after update, before delete, before insert, before update)
{
        
      Schema.DescribeSObjectResult d = Schema.SObjectType.Opportunity; 
      Map<Id,Schema.RecordTypeInfo> rtMapById = d.getRecordTypeInfosById();
      OpportunityTriggerHandler Handler = new OpportunityTriggerHandler(Trigger.isExecuting, Trigger.size);
    
    
      List<Id> opptyIds = new List<Id>(); 
      // Before Insert Logic
      //
      if(Trigger.isInsert && Trigger.isBefore && checkRecurssionBefore.runOnce('Opportunity','Insert'))
      {
          //TODO - DAVI - Bypass to only execute code to ANZ Record TYpes
          Handler.OnBeforeInsert(Trigger.new);
      }
      // After Insert Logic
      //
      else if(Trigger.isInsert && Trigger.isAfter && checkRecurssionAfter.runOnce('Opportunity','Insert'))
      {
        
           //TODO - DAVI - Bypass to only execute code to ANZ Record TYpes
          Handler.OnAfterInsert(Trigger.new);
       
        
          //@TODO - DAVI - Move code to trigger PS_Opportunity.
          List<Opportunity> oppNew = new List<Opportunity>();
          for (Opportunity o : Trigger.new)
            {
              if(!rtMapById.isEmpty() && o.RecordTypeId != null){
                if(rtMapById.get(o.RecordTypeId).getName().equals('D2L')){
                  oppNew.add(o);
                  //Handler.copyFieldsOnOpportuity(Trigger.new);
                }
                }
          }
          
            Handler.copyFieldsOnOpportuity(oppNew);
          /////////////////////////////////////////////////////
      }
    // Before Update Logic
    
      else if(Trigger.isUpdate && Trigger.isBefore && checkRecurssionBefore.runOnce('Opportunity','Update'))   
      {
          system.debug('im inside Before Update Logic');
          Handler.OnBeforeUpdate(Trigger.old, Trigger.new, Trigger.newMap);
       }
    
      // After Update Logic
      //
      else if(Trigger.isUpdate && Trigger.isAfter && checkRecurssionAfter.runOnce('Opportunity','Update'))
      {
          //ps_CreateAssetbasedStudentRegistration.CreateAsset(trigger.oldMap,trigger.new);
        
          //TODO - Davi - Bypass to only execute code to ANZ Record TYpes
          //Handler.OnAfterUpdate(Trigger.old, Trigger.new, Trigger.newMap);
          List<Opportunity> oppNew = new List<Opportunity>();
          for (Opportunity o : Trigger.new)
            {
            system.debug('o.RecordTypeId-->'+o.RecordTypeId +'------->>><<'+Trigger.oldMap.get(o.Id).Student_Registered__c);
            if(!rtMapById.isEmpty() && o.RecordTypeId != null)
              {
              if(rtMapById.get(o.RecordTypeId).getName().equals('D2L'))
                  {
                oppNew.add(o);
                   }
              }
          }
          Handler.createContract(oppNew);
                     
      }
      // Before Delete Logic
      //
      else if(Trigger.isDelete && Trigger.isBefore)
      {
          Handler.OnBeforeDelete(Trigger.old, Trigger.oldMap);
      }
      // After Delete Logic
      //
      else if(Trigger.isDelete && Trigger.isAfter)
      {
          Handler.OnAfterDelete(Trigger.old, Trigger.oldMap);
      }
    
      // After Undelete Logic
      //
      else if(Trigger.isUnDelete)
      {
          Handler.OnUndelete(Trigger.new); 
      }
    
  
    
      // After Update and After Insert Logic || RD: 145 || Done by Pooja
      if((Trigger.isUpdate || Trigger.isInsert) && Trigger.isAfter){
       
      }
}