global class PaymentInfoProxyClass{
    
   webservice static List<PaymentInfo> getPaymentInfo(String learnerId, String institution)
   {
         RetrievePaymentInfo.PaymentInfoItem[] data;
          //Creating List of Opportunity to avoid Exception           
          List<Opportunity> opptyObj = [Select id,Account.Pearson_Account_Number__c,Account.External_Account_Number__c,recordtype.name,Market__c,Geography__c from Opportunity where id =:learnerId];                    
                    
          List<PaymentInfo> paymentLst = new List<PaymentInfo>();
          //Soap Request  for setting request and getting response  
       if(!Test.isRunningTest()) {       
          RetrievePaymentInfo.RetrievePaymentInfoSOAP  soapobj = new  RetrievePaymentInfo.RetrievePaymentInfoSOAP ();
          soapobj.timeout_x=120000;
          soapobj.clientCertName_x= Label.PS_INT_RetreivePayment_CN;
          RetrievePaymentInfo.Header_element   header = new RetrievePaymentInfo.Header_element();
          //Set values to these fields of Request parament
          header.BusinessGeography  = opptyObj[0].Geography__c;
          header.Market  = opptyObj[0].Market__c;
          header.AccountType  = opptyObj[0].recordtype.name;
          header.OrganisationName  =institution;
          //Passing Header and Account Number to get response
          String accountNo ;
          if(opptyObj[0].Account.External_Account_Number__c!='' || opptyObj[0].Account.External_Account_Number__c!=null)
              accountNo =opptyObj[0].Account.External_Account_Number__c;
          else
              accountNo =opptyObj[0].account.Pearson_Account_Number__c; 
          //if(!Test.isRunningTest()) {  
           data = soapobj.RetrievePaymentInfo(header,accountNo);
          system.debug('data----->'+data);
          }
          //Complete of Soap Request and Response
        
         if(data != null)
         {
           for (RetrievePaymentInfo.PaymentInfoItem responseObj: data) {
                PaymentInfo paymentObj = new PaymentInfo();
                paymentObj.trandate = responseObj.TransactionDate;
                paymentObj.trantype = responseObj.TransactionType;
                paymentObj.tranamount = responseObj.TransactionAmount;
                paymentObj.tranbalance = responseObj.AccountBalance;
                paymentObj.tranreference = responseObj.TransactionReference;
                paymentObj.tranearlybird = responseObj.IsEarlyBirdPayment;
                paymentObj.tranregpayment = responseObj.IsRegistrationPayment;
                paymentLst.add(paymentObj);
           }
         }
         return paymentLst;
   }
}