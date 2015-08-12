trigger UpdateStudentId on Lead (Before Insert) {

 for(Lead L:Trigger.new){
   if(L.Pearson_ID_Number__c==null){
   
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

 L.Pearson_ID_Number__c = str;
  }}}