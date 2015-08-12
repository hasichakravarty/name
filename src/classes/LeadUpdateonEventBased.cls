Public class LeadUpdateonEventBased{

  public static void LeadfieldUpdate(List<Id> LeadIds){ 
  
   List<Lead> LeadList = new List<Lead>();
   List<Lead> LeadListToUpdate = new List<Lead>();
   
     if(LeadIds.size()>0){
       LeadList = [Select id,Cancelled_Interviews__c from Lead where Id IN:LeadIds];
     }
     
    if(LeadList.size()>0){
      for(Lead L:LeadList){
        Lead L1 = new Lead();
        L1.Id = L.Id;
         L1.Cancelled_Interviews__c = L.Cancelled_Interviews__c+1;         
        LeadListToUpdate.Add(L1);
      }
    }
    
     

    Update LeadListToUpdate;
  }
   
public static void LeadfieldUpdateDecrement(List<Id> LeadIds){ 
  
   List<Lead> LeadList = new List<Lead>();
   List<Lead> LeadListToUpdate = new List<Lead>();
   
     if(LeadIds.size()>0){
       LeadList = [Select id,Cancelled_Interviews__c from Lead where Id IN:LeadIds];
     }
     
    if(LeadList.size()>0){
      for(Lead L:LeadList){
        Lead L1 = new Lead();
         if(L.Cancelled_Interviews__c > 0){ 
            L1.Id = L.Id;
            L1.Cancelled_Interviews__c = L.Cancelled_Interviews__c-1;   
            LeadListToUpdate.Add(L1);
          }  
      }
    }
    
    Update LeadListToUpdate;
  }
   

}