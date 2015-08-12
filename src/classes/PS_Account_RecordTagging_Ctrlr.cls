/* ----------------------------------------------------------------------------------------------------------------------------------------------------------
   Name:            PS_Account_RecordTagging_Ctrlr.cls 
   Description:     On insert/update/ of Account record 
   Date             Version         Author                             Summary of Changes 
   -----------      ----------      -----------------    ---------------------------------------------------------------------------------------------------
  05/2015         1.0               Davi Borges                       Initial Release 
------------------------------------------------------------------------------------------------------------------------------------------------------------ */
public class PS_Account_RecordTagging_Ctrlr
{  
  public static void accountRecordTagging(List<Account> accountUpdateList)
  {

        //List<User> userLst = new List<User>();//Commented for R3

        //Commented for R3 sicne this is not used any more , PS_Utill class is used to get user details
         /*String user_id = UserInfo.getUserId();

         List <User> userdetails = [select Market__c , Line_of_Business__c , Geography__c from User where id =:user_id limit 1];*/
         
         User userRecord = PS_Util.getUserDetail(UserInfo.getUserId());

        // System.debug(userdetails);
       if(userRecord!=null){
           if(userRecord.Market__c != null && userRecord.Line_of_Business__c != null && userRecord.Geography__c != null)
            { 
            for(Account newAcc: accountUpdateList)
            {
                newAcc.Market__c = userRecord.Market__c;
                newAcc.Line_of_Business__c = userRecord.Line_of_Business__c;
                newAcc.Geography__c = userRecord.Geography__c;
            }
                //leadLst.add(newlead);
                
                 //system.debug(newlead);
    
             }
             //Commented for R3 Since there is only blank Elseif
            /* else if(accountUpdateList[0].Market__c != null && accountUpdateList[0].Line_of_Business__c != null && accountUpdateList[0].Geography__c != null )
             {
             }*/
             
             else
             {
                for(Account newAcc: accountUpdateList)
                    newAcc.addError(Label.PS_AccountHandler_Error);
            }
    
             //if(!leadLst.isEmpty())
             //{
                 //update leadLst;
                 
                  //system.debug(leadLst);
            // } 
            
           }          
    }
}