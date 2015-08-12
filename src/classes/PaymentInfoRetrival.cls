public class PaymentInfoRetrival{

    public List<Paymentinfo> listWithDetail {get; set;}

    public String institution {get; set;}
    private String customerId;

     public PaymentInfoRetrival()
     {
         customerId = ApexPages.currentPage().getParameters().get('customerid');
     }

     public List<SelectOption> getInstitutions() {
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('CTI','CTI'));
            options.add(new SelectOption('MGI','MGI'));
         
            return options;
     }
     
     public PageReference search() {
            listWithDetail = PaymentInfoProxyClass.getPaymentInfo(customerId, institution);
            System.debug('listWithDetail -->'+listWithDetail);            
          return null;
     }
     
      public void retreiveinfo()
  {
  
        
             RetrievePaymentInfo  inforetrieve = new RetrievePaymentInfo ();
             RetrievePaymentInfo.Header_element headerelement =  new  RetrievePaymentInfo.Header_element();
             RetrievePaymentInfo.RetrievePaymentInfoRequest  request = new RetrievePaymentInfo.RetrievePaymentInfoRequest ();
             list< RetrievePaymentInfo.PaymentInfoItem>  paylist = new list< RetrievePaymentInfo.PaymentInfoItem>();
             RetrievePaymentInfo.RetrievePaymentInfoSOAP   response = new RetrievePaymentInfo.RetrievePaymentInfoSOAP ();
            
             headerelement.BusinessGeography='Growth';
             headerelement.Market='US';
             headerelement.AccountType='College'; 
             headerelement.OrganisationName='Pearson';  
          
             request.header = headerelement;    
             request.AccountNo = 'AccountNumber';
             
             response.clientCertName_x  ='SelfSignedCert_27Feb2015_033452';
            // response.clientCertPasswd_x = 'SelfSignedCert_27Feb2015_033452';
             response.timeout_x = 120000;
            
             if(!Test.isRunningTest()){ 
                 paylist = response.RetrievePaymentInfo(request.header,request.AccountNo );
             }
             system.debug('$$$$$$$$$$$$Response'+paylist);
         
  }
  

     /*public void setInstitution(String institution) {
            this.selectedInstitution = institution;
     }*/

 
}