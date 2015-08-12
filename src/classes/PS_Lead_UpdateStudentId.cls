/* ----------------------------------------------------------------------------------------------------------------------------------------------------------
   Name:            PS_Lead_UpdateStudentId 
   Description:     On insert creation of PearsonID On Lead record 
   Date             Version         Author                             Summary of Changes 
   -----------      ----------      -----------------    ---------------------------------------------------------------------------------------------------
  04/2015         1.0            Karthik.A.S                      Initial Release 
------------------------------------------------------------------------------------------------------------------------------------------------------------ */


Public class PS_Lead_UpdateStudentId
{
  public static void beforelead(list<lead>acList){
 
    system.debug('@@@@ lead'+acList);
    Set<id> LeadId = new Set<id>();
    List<id> LeadIds = new List<id>();
    List<Lead> leadvalues = new List<Lead>();
    list <Lead> LeadstoUpdate = new List<Lead>();

    system.debug('############entered generatePearsonID');
      for(Lead l : acList) {
        LeadIds.add(l.id);
      }
      
      if(LeadIds.size()>0){
        leadvalues= [select id,Pearson_ID_Number__c from lead where id in:LeadIds];
      }

    for(lead k:leadvalues){
      if(k.Pearson_ID_Number__c==null){
        final String chars = '123456789BCDFGHJKLMNPQRSTVWXYZ'; 
        String randStr = '';
        while (randStr.length() < 8) {
          Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), 30);
          randStr += chars.substring(idx, idx+1);
        }  
     
        final String chars2 = '123456789';
        String randStr2 = '';
        while (randStr2.length() < 1) {
          Integer idx2 = Math.mod(Math.abs(Crypto.getRandomInteger()), 9);
          randStr2 += chars2.substring(idx2, idx2+1);
        }
        string str = randstr+randStr2;
 
        system.debug('str'+str); 

        k.Pearson_ID_Number__c = str;

        LeadstoUpdate.add(k);
      }
    }
    
    if(LeadstoUpdate.size()>0){
      system.debug('###################updating');
      update LeadstoUpdate;
    }
  }
}