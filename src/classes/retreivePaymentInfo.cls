public class retreivePaymentInfo{

    public List<Paymentinfo> listWithDetail {get; set;}

    public String institution {get; set;}
    private String customerId;

     public retreivePaymentInfo()
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

     /*public void setInstitution(String institution) {
            this.selectedInstitution = institution;
     }*/

 
}