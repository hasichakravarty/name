@isTest (seeAllData=true)
public with sharing class PaymentInfoTestClass 
{
 static testMethod void testMethod1()
 {     
   List<User> usrLst = TestDataFactory.createUser(Userinfo.getProfileId());
   insert usrLst;
   System.runas(usrLst[0])
   {
     Test.startTest();
     PaymentInfo pi = new PaymentInfo();
     pi.trandate = null;
     pi.trantype = null;
     pi.tranamount = null;
     pi.tranbalance = null;
     pi.tranreference = null;
     pi.tranearlybird = null;
     pi.tranregpayment = null;
          
     PaymentInfoProxyClass.getPaymentInfo(null, null);
     Test.stopTest();
    }
  }
}