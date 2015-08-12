public class ExceptionFramework{
    public static void LogException(String InterfaceName,String ClassName,String ClassMethod,String ErrMsg,String userlogin,String sId){
            PS_ExceptionLogger__c errlogger=new PS_ExceptionLogger__c();
            errlogger.InterfaceName__c=InterfaceName;
            errlogger.ApexClassName__c=ClassName;
            errlogger.CallingMethod__c=ClassMethod;
            errlogger.ExceptionMessage__c=ErrMsg;
            errlogger.UserLogin__c=userlogin; 
            errlogger.recordid__c=sId;           
            insert errlogger;
    } 
}