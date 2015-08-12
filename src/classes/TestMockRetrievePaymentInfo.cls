@isTest
//Class created to cover the Test code coverage for the controller PaymentInfoRetrival for sending the mock request to the Endpoint URL
global class TestMockRetrievePaymentInfo implements WebServiceMock {
//Method created to do mock request for the endpoint URL 
    public void doInvoke(Object stub, Object request, Map<String, Object> response,
                         String endpoint, String soapAction, String requestName,
                        String responseNS, String responseName, String responseType) {
                        
          if(request instanceof RetrievePaymentInfo.RetrievePaymentInfoSOAP ){
              RetrievePaymentInfo.RetrievePaymentInfoResponse respElement= new  RetrievePaymentInfo.RetrievePaymentInfoResponse();
                List<RetrievePaymentInfo.PaymentInfoItem> lstRespData = new List<RetrievePaymentInfo.PaymentInfoItem>();
                lstRespData[0].TransactionType ='Test';
                lstRespData[0].TransactionReference = 'Debit';
                lstRespData[0].TransactionAmount = 123;
                lstRespData[0].AccountBalance = 12345;
                lstRespData[0].IsRegistrationPayment = false;
                lstRespData[0].IsEarlyBirdPayment = false;
                respElement.Item = lstRespData;
               
               System.debug('**********respElement:'+respElement);
              response.put('response_x', respElement);
          
          }

    }
}