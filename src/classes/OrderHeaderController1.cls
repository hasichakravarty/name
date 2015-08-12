public class OrderHeaderController1{
    //declaration of public varaibles
    public id oppid{get;set;}
    public id opppriaccid{get;set;}
    public account opppriacc {get;set;}
    public list<contact> listofcontactaddress{get;set;}
    
    public Map<Id,Contact> targetContacts;

    public list<contact> listofcontactaddresstotal{
         get{
            if(targetContacts !=null) {return targetContacts.values();}
            return null;
         }

        set;
    }


    public opportunity opp{get;set;}
    public account RelatedAccount {get;set;}
    public List<SelectOption> shippingmethod{get;set;} 
    public string shipmethod{get;set;}
    public ID accid{get;set;}
    public id orderid{get;set;}
    public order sampleorder{get;set;}
    public list<orderitem> samplelineitems{get;set;}

    public list<ordercontacts> ordercontactlist{get;set;}
    public list<ordercontacts> ordercontactlisttotal{
        get{
            if(mapOrderContacts !=null) {return mapOrderContacts.values();}
            return null;
         }
        set;}
    public Map<Id,ordercontacts> mapOrderContacts;
    
    public list<OrderLineItemList> OrderLineItemcoll{get;set;}
    public string address{get;set;}
    public list<Addressfields> contactaddressfields{
        get{
            if(contactaddress !=null) {return contactaddress.values();}
            return null;
        }
        set;
    }

    Map<id,Addressfields> contactaddress;

    public contact contactaddresses{get;set;}
    public string mailingstreet{get;set;}
    public string mailingcity{get;set;}
    public string mailingcountry{get;set;}
    public string mailingstate{get;set;}
    public string mailingpostalcode{get;set;}
    public string selectedmailingstreet{get;set;}
    public string selectedmailingcity{get;set;}
    public string selectedmailingstate{get;set;}
    public string selectedmailingcountry{get;set;}
    public string selectedmailingpostalcode{get;set;}
    public string selectedaddress{get;set;}
    public boolean displaypopup{get;set;}
    public ID conid{get;set;}
    public ID removeconid{get;set;}
    public Integer CountTotalRecords{get;set;}
    public String QueryString {get;set;}
    public Integer OffsetSize {get;set;}
    private Integer QueryLimit = 20; 
    public Integer pageNumber{get;set;} 
    public Integer totalPages{get;set;}
    public boolean disablePrevious{get;set;} 
    public boolean disableNext{get;set;}
    public ID removeprodid{get;set;}
    
    map<id,contact> contactlist;
    public string warehouseinstruction{get;set;}
    
    List<SelectOption> options {get;set;}
    List<id> deletedcons = new list<id>();
    public list<OpportunityContactRole> oppcontactroles{get;set;}
    public list<id> contactids{get;set;}
    public string addressline1{get;set;}
    public string addressline2{get;set;}
    public string addressline3{get;set;}
    public string addressline4{get;set;}
    public string ordernotes{get;set;}
    public string addresslinecopy{get;set;}
    public boolean flag{get;set;}
   //public list<duplicateitems> duplicateitemlist{get;set;}
    //Getter Setter for Display duplciate product
    public boolean duplicateCheckDone{get; set;}
    public String currentProduct{get; set;}
    public Map<Id,List<DuplicateList>> mapProdDopWrap{get; set;}
    public Set<Id> deletedContact = new Set<Id>();


    //Address Seelction

    public Map<Id,Ordercontacts> mapAddressFieldWrap {get; set;}
    public boolean fromOnclick {get; set;}


 /**
         * Description : Constructor
         * @param NA
         * @return NA
         * @throws NA
         **/
    public  OrderHeaderController1()//constructor
    {
        AccountandContactdetials();  
    }
    
     /**
         * Description : Constructor details
         * @param NA
         * @return NA
         * @throws NA
         **/
    public void AccountandContactdetials(){
        duplicateCheckDone = true;
        OffsetSize=0;
        system.debug('$$$$$$Detials'+oppid+opp+accid+opppriacc+RelatedAccount+listofcontactaddress);                            
        oppid=ApexPages.currentPage().getParameters().get('oppid');
        orderid=ApexPages.currentPage().getParameters().get('orderid');
        opp=[select id,Primary_Selling_Account__c from opportunity where id =:oppid limit 1];
        accid=[select id,accountid from opportunity where id =:oppid limit 1].accountid;
        if(opp.Primary_Selling_Account__c != null){system.debug('Id$$$$'+opp.Primary_Selling_Account__c);
                                                   opppriacc=[select id,name from account where name = :opp.Primary_Selling_Account__c limit 1 ]; }       
        RelatedAccount=[select id,name,BillingStreet, BillingCity, BillingState, BillingPostalCode,BillingCountry from account where id =:accid limit 1];       
        oppcontactroles =  [select contactid,Role from OpportunityContactRole where OpportunityId=:oppid];
        
        system.debug('$$$$$$$$'+oppcontactroles);
        contactidlist();
        system.debug('Contactids'+contactids);
        
        targetContacts = new Map<Id,Contact>([SELECT Id, name,Preferred_Address__c,accountid,Role__c,email,Do_Not_Send_Samples__c,
            MailingCity,MailingState,MailingCountry,MailingPostalCode,MailingStreet,
            OtherStreet,OtherCity,OtherState,OtherCountry,OtherPostalCode,
            account.shippingstreet,account.shippingcity,account.shippingstate,account.shippingcountry,account.shippingpostalcode
              FROM Contact where id in :contactids ]) ;
        

        CountTotalRecords = listofcontactaddresstotal.size();
        getlistofcontactaddress();
        sampleorder=[select id,Cancel_After_Date__c,Do_Not_Ship_Before_Date__c,Shipping_Instructions__c from order where id=:orderid limit 1]; 
        samplelineitems=[select id,Shipped_Product__c,OrderedQuantity__c,Digital_Product_System_Added__c,Quantity from orderitem where orderid =:orderid ];
        system.debug('Items$$$'+samplelineitems);
        getordercontactlist();
        mapProdDopWrap = new Map<Id,List<DuplicateList>>();
        getOrderLineItemcoll();
        checkForDuplicate();
        displaypopup= false;
        address='Account';
        disablePrevious = false;
        mailingstreet='';
        mailingcity='';
        mailingcountry='';
        mailingstate='';
        mailingpostalcode='';
        disableNext =((CountTotalRecords>20)?true:false);
        totalordercontactlist();
        addressline1='';
        addressline2='';
        addressline3='';
        addressline4='';
        ordernotes='';
        system.debug('$$$$$$$$$$$Update'+ordercontactlisttotal);   
        gettingcontactaddress();  
        //Address issue
        mapAddressFieldWrap = new Map<Id,Ordercontacts>();


    }  
    
     /**
         * Description : Generates the list of contacte to display in the contact list
         * @param NA
         * @return NA
         * @throws NA
         **/
    public void getlistofcontactaddress()
    {
        
        if(OffsetSize>0)
        {
            system.debug('deletedid'+deletedcons);
            listofcontactaddress= [select name,Preferred_Address__c,Role__c,MailingAddress,OtherAddress,email,Do_Not_Send_Samples__c,MailingCity,MailingState,MailingCountry,MailingPostalCode,MailingStreet,OtherStreet,OtherCity,OtherState,OtherCountry,OtherPostalCode,account.shippingstreet,account.shippingcity,account.shippingstate,account.shippingcountry,account.shippingpostalcode  from contact where id not in :deletedcons and id in :contactids order by name limit :QueryLimit offset:offsetsize ] ;
        }
        else
        {
            listofcontactaddress= [select name,Preferred_Address__c,Role__c,MailingAddress,OtherAddress,email,Do_Not_Send_Samples__c,MailingCity,MailingState,MailingCountry,MailingPostalCode,MailingStreet,OtherStreet,OtherCity,OtherState,OtherCountry,OtherPostalCode,account.shippingstreet,account.shippingcity,account.shippingstate,account.shippingcountry,account.shippingpostalcode  from contact where id not in :deletedcons and id in :contactids order by name limit :QueryLimit ] ;
        }
        system.debug('%%%%%%%%list'+listofcontactaddress+OffsetSize);
    } 
    
     /**
         * Description : Gets the ids of the contact records
         * @param NA
         * @return NA
         * @throws NA
         **/
    public void   contactidlist(){
        contactids= new list<id>();
        for(OpportunityContactRole oppids:oppcontactroles)
        {contactids.add(oppids.contactid);}
    }  
    
     /**
         * Description : Generates the list of option for the Shipping options
         * @param NA
         * @return NA
         * @throws NA
         **/
    public List<SelectOption> getoptions() // select list for delivery method
    { 
        
        options = new List<SelectOption>();     
        Schema.DescribeFieldResult fieldResult = OrderItem.Shipping_Method__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();

        for( Schema.PicklistEntry f : ple)
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        system.debug('options'+options);     
        return options;       
    }
    
     /**
         * Description : creating wrapper class record for contact address
         * @param NA
         * @return NA
         * @throws NA
         **/
    public void gettingcontactaddress()
    {
        
        if( contactaddress ==null){ 
            contactaddress = new Map<id,addressfields> ();
        } 
        
        for(contact con:listofcontactaddresstotal)
        {
            contactaddress.put(con.Id, new addressfields(con));
        } 
        
        system.debug('Map of Contact Address'+contactaddress) ;    
    }
    
    /**
         * Description : method used to store the updated address type and contact address
         * @param NA
         * @return NA
         * @throws NA
         **/
    public  void setselectedaddress1()       
    {
        system.debug('from add line--->'+fromOnclick);
    
        if(!fromOnclick)
             displaypopup = false;   

        for(Ordercontacts orderContObj : ordercontactlist){
            if(orderContObj.selectedValue == 'Other'){
                orderContObj.address = 'Contact Other';
                orderContObj.isCustom = false;
                orderContObj.isContMailing = false;
                orderContObj.isContOther = true;
                orderContObj.isAccountPhysical = false;
                orderContObj.selected = System.Label.Contact_Other;
                orderContObj.street=orderContObj.con.OtherStreet;
                orderContObj.city=orderContObj.con.OtherCity;
                orderContObj.state=orderContObj.con.OtherState; 
                orderContObj.country=orderContObj.con.OtherCountry; 
                orderContObj.postalcode=orderContObj.con.OtherPostalCode; 

            }
            else if(orderContObj.selectedValue == 'Mailing'){
                orderContObj.address = 'Contact Mailing';
                orderContObj.isCustom = false;
                orderContObj.isContMailing = true;
                orderContObj.isContOther = false;
                orderContObj.isAccountPhysical = false;
                orderContObj.selected = System.Label.ContactMailing;
                orderContObj.street=orderContObj.con.MailingStreet;
                orderContObj.city=orderContObj.con.MailingCity;
                orderContObj.state=orderContObj.con.MailingState; 
                orderContObj.country=orderContObj.con.MailingCountry; 
                orderContObj.postalcode=orderContObj.con.MailingPostalCode;

            }
            else if(orderContObj.selectedValue == 'Account'){
                System.debug('orderContObj------------>'+orderContObj);
                orderContObj.address = 'Account';
                orderContObj.isCustom = false;
                orderContObj.isContMailing = false;
                orderContObj.isContOther = false;
                orderContObj.isAccountPhysical = true;
                orderContObj.selected = 'Account';
                orderContObj.street=orderContObj.con.account.ShippingStreet;
                orderContObj.city=orderContObj.con.account.ShippingCity;
                orderContObj.state=orderContObj.con.account.ShippingState; 
                orderContObj.country=orderContObj.con.account.ShippingCountry; 
                orderContObj.postalcode=orderContObj.con.account.ShippingPostalCode; 
            }
            else if(orderContObj.selectedValue == 'Custom'){
                orderContObj.address = 'Custom';
                orderContObj.isCustom = true;
                orderContObj.isContMailing = false;
                orderContObj.isContOther = false;
                orderContObj.isAccountPhysical = false;
                orderContObj.selected = 'Custom';

            }
            mapAddressFieldWrap.put(orderContObj.con.id ,orderContObj );

        
        }
        system.debug('mapAddressFieldWrap------->'+mapAddressFieldWrap);
    
    }
    
    /**
         * Description : method used for the Cancel Button of the Address Override
         * @param NA
         * @return NA
         * @throws NA
         **/
    public  void hideselectedaddress()  {
        
        displaypopup = false;   
        
    }                       
    
     /**
         * Description : used to create contact list for each display
         * @param NA
         * @return NA
         * @throws NA
         **/
    public void getordercontactlist(){
        if(ordercontactlist == null){ordercontactlist = new list<ordercontacts> ();}
        ordercontactlist.clear();
        system.debug('$$$$$$$$$$4List'+ordercontactlist);
        for(contact con: listofcontactaddress)
        {ordercontactlist.add(new ordercontacts(con,sampleorder,oppid));}
    }  
    
     /**
         * Description : used to create list of all contacts
         * @param NA
         * @return NA
         * @throws NA
         **/
    public void totalordercontactlist(){ 
       
        mapOrderContacts = new Map<Id,ordercontacts>();

        for(contact con: listofcontactaddresstotal){
            mapOrderContacts.put(con.Id, new ordercontacts(con,sampleorder,oppid));
        }
    }   
    
    /**
         * Description : used to update contact list 
         * @param NA
         * @return NA
         * @throws NA
         **/
    public void updatetotalordercontactlist()
    {
        system.debug('EntererdUpdate');           
        for(ordercontacts temp:ordercontactlisttotal)
        {for(ordercontacts temp1:ordercontactlist)
        {
            if(temp1.con.id == temp.con.id)
            {  
                if((temp.futureshipdate !=temp1.futureshipdate))
                { temp.futureshipdate = temp1.futureshipdate;
                 system.debug('$$$$$$$$$$1');}
                if((temp.canceldate !=temp1.canceldate))
                {temp.canceldate = temp1.canceldate;
                 system.debug('$$$$$$$$$$2');}
                if((temp.shippinginstructions !=temp1.shippinginstructions ))
                {temp.shippinginstructions = temp1.shippinginstructions; 
                 system.debug('$$$$$$$$$$3');}
                temp1.address=temp.address;   
            }                                     
        }
        } 
        system.debug('$$$$$$$$$$$Local'+ordercontactlist);                                          
        system.debug('$$$$$$$$$$$Update'+ordercontactlisttotal);                       
        
    }
    
    /**
         * Description : used to update contact list 
         * @param NA
         * @return NA
         * @throws NA
         **/
    public void updatedtotalordercontactlist()
    {
        system.debug('EntererdUpdate1');           
        for(ordercontacts temp:ordercontactlist)
        {for(ordercontacts temp1:ordercontactlisttotal)
        {
            if(temp1.con.id == temp.con.id)
            {  
                if((temp.futureshipdate !=temp1.futureshipdate)&&(temp1.futureshipdate !=null))
                { temp.futureshipdate = temp1.futureshipdate;
                 system.debug('$$$$$$$$$$1');}
                if((temp.canceldate !=temp1.canceldate)&&(temp1.canceldate !=null))
                {temp.canceldate = temp1.canceldate;
                 system.debug('$$$$$$$$$$2');}
                if((temp.shippinginstructions !=temp1.shippinginstructions )&&(temp1.shippinginstructions !=null))
                {temp.shippinginstructions = temp1.shippinginstructions; 
                 system.debug('$$$$$$$$$$3');}
                temp.address=temp1.address;   
                
            }                                     
        }
        } 
        system.debug('$$$$$$$$$$$Local'+ordercontactlist);                                          
        system.debug('$$$$$$$$$$$Update'+ordercontactlisttotal);                       
        
    }         
     /**
         * Description :  used to form orderitem 
         * @param NA
         * @return NA
         * @throws NA
         **/
    public void getOrderLineItemcoll(){
        if(OrderLineItemcoll == null){
            OrderLineItemcoll = new list<OrderLineItemList> (); 
        }
        for(orderitem temp: samplelineitems)
        {OrderLineItemcoll.add(new OrderLineItemList(temp,listofcontactaddress));}       
    }
    
    /**
    * Description : used to select address for the 'Address OverRide' commandlink
    * @param  inderectly uses contactid, which is passed with information about the contact.
    * @return indirectly returns contactaddress, which is contact record . Also inderectly returns the displaypopup
    * @throws NA
    **/
    public void initiateaddressselction()
    {
        System.debug('mapAddressFieldWrap--------->'+mapAddressFieldWrap);
        system.debug('initiateaddressselction-->'+conid+displaypopup+contactaddress);
        //contactaddresses = [select name,Role__c,MailingAddress,OtherAddress,email,Do_Not_Send_Samples__c,MailingCity,MailingState,MailingCountry,MailingPostalCode,MailingStreet,OtherStreet,OtherCity,OtherState,OtherCountry,OtherPostalCode,account.shippingstreet,account.shippingcity,account.shippingstate,account.shippingcountry,account.shippingpostalcode  from contact where id=:conid limit 1] ;
        
        contactaddresses = targetContacts.get(conid);

        //displayppup controls the presentation of the 
        displaypopup = true;
        system.debug('initiateaddressselction-->'+conid+displaypopup);

        
    }
    
   /**
         * Description : used to update address type to contact mailing
         * @param NA
         * @return NA
         * @throws NA
         **/
    public void updateaddressmailing(id conid)
    {
        system.debug('conid'+conid);
        for(integer i=0;i<ordercontactlisttotal.size();i++){
            ordercontacts sample=ordercontactlisttotal[i];
            if(sample.con.id == conid)
            {
                sample.address='Contact Mailing';
                
            }
        }
        for(integer i=0;i<ordercontactlist.size();i++){
            ordercontacts sample=ordercontactlist[i];
            if(sample.con.id == conid)
            {
                sample.address='Contact Mailing';
                
            }
        }
        system.debug('%%%%%%%'+ordercontactlisttotal);
    }
    
     /**
         * Description : used to update address type to contact other
         * @param NA
         * @return NA
         * @throws NA
         **/
    public void updateaddresstype(id conid)
    {
        system.debug('conid'+conid);
        for(integer i=0;i<ordercontactlisttotal.size();i++){
            ordercontacts sample=ordercontactlisttotal[i];
            if(sample.con.id == conid)
            {
                sample.address='Contact Other';
                
            }
        }
        for(integer i=0;i<ordercontactlist.size();i++){
            ordercontacts sample=ordercontactlist[i];
            if(sample.con.id == conid)
            {
                sample.address='Contact Other';
                
            }
        }
        system.debug('%%%%%%%'+ordercontactlisttotal);
    }
    
      /**
         * Description : used to update address type to custom
         * @param NA
         * @return NA
         * @throws NA
         **/ 
    public void updateaddresstypecustom(id conid)
    {
        system.debug('conid'+conid);
        ordercontacts sample;
        for(integer i=0;i<ordercontactlisttotal.size();i++){
            sample=ordercontactlisttotal[i];
            if(sample.con.id == conid)
            {
                sample.address='Custom';
                
            }
        }
        for(integer i=0;i<ordercontactlist.size();i++){
            sample=ordercontactlist[i];
            if(sample.con.id == conid)
            {
                sample.address='Custom';
                
            }
        }
        system.debug('%%%%%%%'+ordercontactlisttotal);
    }
    
    /**
         * Description : used to update address type to Account
         * @param NA
         * @return NA
         * @throws NA
         **/ 
    public void updateaddresstypeAccount(id conid)
    {
        system.debug('conid'+conid);
        ordercontacts sample;
        for(integer i=0;i<ordercontactlisttotal.size();i++){
             sample=ordercontactlisttotal[i];
            if(sample.con.id == conid)
            {
                sample.address='Account';
                
            }
        }
        
        for(integer i=0;i<ordercontactlist.size();i++){
            sample=ordercontactlist[i];
            if(sample.con.id == conid)
            {
                sample.address='Account';
                
            }
        }
        system.debug('%%%%%%%'+ordercontactlisttotal);
    }
    
    /**
         * Description : used to remove selected contacts 
         * @param NA
         * @return NA
         * @throws NA
         **/ 
    public void removecontact()
    {
        system.debug('removedid'+removeconid);
        for(integer i=0;i<ordercontactlist.size();i++){
            ordercontacts sample=ordercontactlist[i];
            if(sample.con.id == removeconid)
            {
                ordercontactlist.remove(i);
                deletedcons.add(removeconid);
                deletedContact.add(removeconid);
                
            }
            for(integer j=0;j<listofcontactaddresstotal.size();j++){
                contact samplecon=listofcontactaddresstotal[j];
                system.debug('remove'+samplecon.id + removeconid);
                if(samplecon.id == removeconid)
                {
                    listofcontactaddresstotal.remove(j);
                }
                system.debug('%%%%%%%'+ordercontactlist+listofcontactaddresstotal);
            }
            if(ordercontactlist.isEmpty()){ 
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'No contacts to delete'));
            }
        } 
    }  
    
    /**
         * Description : used to remove selected product 
         * @param NA
         * @return NA
         * @throws NA
         **/ 
    public void removeproduct()
    {
        for(integer i=0;i<OrderLineItemcoll.size();i++){
            OrderLineItemList sample=OrderLineItemcoll[i];
            if(sample.productdetials.id == removeprodid)
            {
                OrderLineItemcoll.remove(i);
            }
            if(OrderLineItemcoll.isEmpty()){ 
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'No products to delete'));
            }
        } 
    }  
    
     /**
         * Description : used to generate orders for approval process
         * @param NA
         * @return NA
         * @throws NA
         **/ 
    public PageReference initiateapproval()
    {
        //Map of Contact and Product for Duplicate
        Map<Id,Set<Id>> mapContactProd = new Map<Id,Set<Id>>();
        
        try{
            system.debug('Res'+OrderLineItemcoll+ordernotes);
            
            for( OrderLineItemList temp:OrderLineItemcoll) 
            {
                if(temp.restriction == 'R' && (String.isempty(ordernotes))){ 
                    
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'You have requested a restricted product.  Please provide an explanation in the Order Notes field as to why the restricted product is needed.'));
                    return null;
                }
                if(temp.Quantity > 100 ){ 
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'You cannot enter a quantity greater than 100 for the sample order Line item '+ temp.productdetials.name));
                    return null;  
                }   
            }  
            if(listofcontactaddresstotal.size() == 0 ){ 
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'There is no Contact associated with this order.'));
                    return null;  
                }  
            string type; 
            updatetotalordercontactlist(); 
            list<order> orderlistforapproval= new list<order>();
            list<orderitem> orderlineaddition = new list<orderitem> ();
            ID pricebookid =  [select id from Pricebook2 where name = 'Standard Price Book' limit 1].id;  
            contact cont;
            id conid; 
            System.debug('mapProdDopWrap------->'+listofcontactaddresstotal);
            for(contact con:listofcontactaddresstotal) 
            {  
                 if(!deletedContact.contains(con.id)){

                         //Dup Loigc
                        boolean createOrder = false;
                        Set<Id> dupContactIDSet = new Set<Id>();

                        for(OrderLineItemList prodLst:OrderLineItemcoll){
                                if(mapProdDopWrap.containsKey(prodLst.productdetials.id)){

                                    for(DuplicateList dupObj :mapProdDopWrap.get(prodLst.productdetials.id) ){
                                         if(dupObj.optionChoosed=='Yes' && dupObj.contactId==con.id){
                                            createOrder = true;
                                         }
                                         dupContactIDSet.add(dupObj.contactId);
                                    }
                                }
                                else{
                                    createOrder = true;
                                }
                        }
                        if(!dupContactIDSet.contains(con.id)){
                            createOrder = true;
                        }
                    //end of Dup Loigc
                    
                     if(createOrder)
                        orderlistforapproval.add(new order(Accountid=RelatedAccount.id,ShipToContactid=con.id,Opportunityid=oppid,EffectiveDate=system.today(),status=System.Label.Order_Initial_Status_Value,Pricebook2Id=pricebookid,CurrencyIsoCode = userinfo.getDefaultCurrency(),type=System.Label.Order_Type));
                }
            } 
            
            for(order updateorder:orderlistforapproval) 
            {  
              //cont = [select id from contact where id =:updateorder.ShipToContactid limit 1 ]; 

              
              Id idContact = updateorder.ShipToContactid;
                                      System.debug('mapAddressFieldWrap.get(idContact)------>'+mapAddressFieldWrap.get(idContact));

              if(mapAddressFieldWrap.containsKey(idContact)){
                
                  if(mapAddressFieldWrap.get(idContact).selectedValue!='Custom'){
                      System.debug('inside if--------->');
                      updateorder.ShippingStreet= mapAddressFieldWrap.get(idContact).street;
                      updateorder.ShippingCity=mapAddressFieldWrap.get(idContact).city;
                      updateorder.ShippingCountry=mapAddressFieldWrap.get(idContact).country;
                      updateorder.ShippingState=mapAddressFieldWrap.get(idContact).state;
                      updateorder.ShippingPostalCode=mapAddressFieldWrap.get(idContact).postalcode;
                      updateorder.Order_Address_Type__c=mapAddressFieldWrap.get(idContact).selected;
                  }
                   else if(mapAddressFieldWrap.get(idContact).selectedValue=='Custom'){
                      String street = mapAddressFieldWrap.get(idContact).addressline1 + '\r\n' + mapAddressFieldWrap.get(idContact).addressline2 + '\r\n' + mapAddressFieldWrap.get(idContact).addressline3 + '\r\n' + mapAddressFieldWrap.get(idContact).addressline4;
                      updateorder.ShippingStreet= street;
                      updateorder.ShippingCity=mapAddressFieldWrap.get(idContact).mailingcity;
                      updateorder.ShippingCountry=mapAddressFieldWrap.get(idContact).mailingcountry;
                      updateorder.ShippingState=mapAddressFieldWrap.get(idContact).mailingstate;
                      updateorder.ShippingPostalCode=mapAddressFieldWrap.get(idContact).mailingpostalcode;
                      updateorder.Order_Address_Type__c=mapAddressFieldWrap.get(idContact).selected;
                  }


              }
              else{

                    updateorder.ShippingStreet= contactaddress.get(idContact).street;
                    updateorder.ShippingCity=contactaddress.get(idContact).city;
                    updateorder.ShippingCountry=contactaddress.get(idContact).country;
                    updateorder.ShippingState=contactaddress.get(idContact).state;
                    updateorder.ShippingPostalCode=contactaddress.get(idContact).postalcode;
                    updateorder.Order_Address_Type__c=contactaddress.get(idContact).selected;

              }

              ordercontacts temp = mapOrderContacts.get(idContact);
           
              system.debug('$$$$$$$$Date'+temp.canceldate+temp.futureshipdate+temp.shippinginstructions);
              
              updateorder.Cancel_After_Date__c = temp.canceldate;
                     
              if(temp.futureshipdate < System.today()){
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,'Future Date should be greater than today.'));
                 return null;  
              }
              
              updateorder.Do_Not_Ship_Before_Date__c = temp.futureshipdate;
                     
              if(temp.shippinginstructions == ''){
                updateorder.Shipping_Instructions__c = warehouseinstruction;
                updateorder.Packing_Instructions__c = warehouseinstruction;
              }else{
                updateorder.Shipping_Instructions__c = temp.shippinginstructions ; 
                updateorder.Packing_Instructions__c = temp.shippinginstructions; 
              }   
            
            }   
            
            Database.insert(orderlistforapproval);
            system.debug('orders$$$$$'+orderlistforapproval);
            list<id> productidlist = new list<id>();
            for( OrderLineItemList temp:OrderLineItemcoll) 
            {
                productidlist.add(temp.productdetials.id);
            }
            // displayduplicate();
            List<PriceBookEntry> lstPrceBook = [SELECT Id, Product2Id, Product2.Id, CurrencyIsoCode, Product2.Name,unitprice FROM PriceBookEntry WHERE (Product2Id in:productidlist)  AND CurrencyIsoCode =: userinfo.getDefaultCurrency() AND Pricebook2.Name = 'Standard Price Book' ];
            map<id,id> prcbkmap = new map<id,id>();
            map<id,decimal> prcmap = new map<id,decimal>();
            Orderitem temp1;
            
            for(id prodid:productidlist){
                for(PriceBookEntry temp:lstPrceBook){
                  if(temp.Product2Id == prodid){
                     prcmap.put(prodid,temp.UnitPrice);
                     prcbkmap.put(prodid,temp.id);
                  }
                }
            }
            
            system.debug('#######3'+orderlistforapproval) ;
            
            for(order updateorder:orderlistforapproval) 
            {
                                Set<Id> dupContactIDSet = new Set<Id>();

                
                for(OrderLineItemList temp:OrderLineItemcoll) 
                {   
                    //Dup Loigc
                        boolean createItem = false;
                        if(mapProdDopWrap.containsKey(temp.productdetials.id)){
                            for(DuplicateList dupObj :mapProdDopWrap.get(temp.productdetials.id) ){
                                if((dupObj.optionChoosed=='Yes' && dupObj.contactId==updateorder.ShipToContactid))
                                    createItem = true;
                                dupContactIDSet.add(dupObj.contactId);
                            }
                        }
                        else{
                            createItem = true;
                        }
                        if(!dupContactIDSet.contains(updateorder.ShipToContactid)){
                            createItem = true;
                        }
    
                  //End of Dup Loigc  
                        if(createItem){
                    temp1 = new OrderItem();
                    temp1.orderid=updateorder.id;
                    temp1.Shipped_Product__c = temp.productdetials.id;
                    temp1.Quantity = temp.Quantity; 
                    temp1.pricebookentryid= prcbkmap.get(temp.productdetials.id);
                    temp1.unitprice =prcmap.get(temp.productdetials.id);
                    temp1.Shipping_Method__c=temp.shippingmethod;
                    orderlineaddition.add(temp1);
        }
                }
                
            }
            
            Database.insert(orderlineaddition);
            
            
            for(order updateorder:orderlistforapproval) 
            {
                updateorder.Status ='Pending Approval';     
            }  
            
            Database.update(orderlistforapproval);
            
            // update orderlistforapproval;
            system.debug('%%%%%%%%5updatedorders%%%%%%%%'+orderlistforapproval);
            Database.delete(sampleorder); 
            PageReference redirectPage = new PageReference('/'+oppID);
            redirectPage.setRedirect(true);
            return redirectPage;
            
        }catch(exception e){system.debug('Error'+e);return null;}
        
        
    }
   
   /* public void displayduplicate(){//used to display list of duplicate and select those which should be added
        
        map<id,list<order>> contactordermap= new map<id,list<order>>();
        map<id,list<orderitem>> contactorderitemmap = new map<id,list<orderitem>>();
        map<id,set<id>> contactproductmap = new map<id,set<id>>();
        list<order> orderlist = new list<order>();
        list<orderitem> orderitemlist = new list<orderitem>();
        list<id> orderidlist = new list<id>();
        set<id>  prodids ;
        set<id> productidlist = new set<id>();
        for( OrderLineItemList temp:OrderLineItemcoll) 
        {
            productidlist.add(temp.productdetials.id);
        }
        for(contact con:listofcontactaddresstotal)
        {     
            contactordermap.put(con.id,[select id from  order where contact__c = :con.id limit 1]); 
        }
        system.debug('Ordercontactlist$$$$$$$$$$$'+contactordermap);
        for(contact con:listofcontactaddresstotal)
        {  
            orderlist = contactordermap.get(con.id); 
            for(order ord:orderlist){orderidlist.add(ord.id);}   
            contactorderitemmap.put(con.id,[select id,Shipped_Product__c from  orderitem where orderid in :orderidlist]); 
        }
        system.debug('contactorderitemmap$$$$$$$$$$$'+contactorderitemmap);    
        for(contact con:listofcontactaddresstotal)
        {  
            orderitemlist = contactorderitemmap.get(con.id);
            prodids = new set<id>();
            for(orderitem ord:orderitemlist){if(productidlist.contains(ord.Shipped_Product__c)){prodids.add(ord.Shipped_Product__c);}}   
            contactproductmap.put(con.id,prodids); 
        }
        system.debug('contactproductmap$$$$$$$$$$$'+contactproductmap); 
        for(contact con:listofcontactaddresstotal)
        {  
            prodids = new set<id>();
            prodids= contactproductmap.get(con.id);
            for(id prodid:prodids){duplicateitemlist.add(new duplicateitems(con.id,prodid));}
        }
        system.debug('duplicateitemlist$$$$$$$$$$$'+duplicateitemlist);      
        
    }*/
    
    
     /**
         * Description : used to disable the Previous Link 
         * @param NA
         * @return NA
         * @throws NA
         **/ 
    public void getDisablePrevious(){
        if(OffsetSize>0){
            disablePrevious=true;
        }else 
        {disablePrevious=false;}
    }  
    
    /**
         * Description : used to disable the Next Link 
         * @param NA
         * @return NA
         * @throws NA
         **/
    public void getDisableNext() {
        if ((OffsetSize + QueryLimit < countTotalRecords)&&(CountTotalRecords>20)){
            disableNext = true;
        }else 
        {disableNext = false;}
    }     
    
    /**
         * Description : used to Set the Next Link 
         * @param NA
         * @return Pagereference
         * @throws NA
         **/
    public PageReference Next() {
        updatetotalordercontactlist();
        OffsetSize += QueryLimit;
        getDisablePrevious();
        getDisableNext();
        getlistofcontactaddress();
        getordercontactlist();
        getPageNumber();
        getTotalPages();
        System.debug('inside next....'+OffsetSize);
        return null;
    }  
    
    /**
         * Description : used to Set the Previous Link 
         * @param NA
         * @return Pagereference
         * @throws NA
         **/
    public PageReference Previous() {
        updatetotalordercontactlist();
        if(offsetsize-QueryLimit>=0)
        {OffsetSize -= QueryLimit;}
        getDisablePrevious();
        getDisableNext();
        getlistofcontactaddress();
        getordercontactlist();
        updatedtotalordercontactlist();
        getPageNumber();
        getTotalPages();
        System.debug('inside Previous....'+OffsetSize);
        return null;
    }
    
    /**
         * Description : used to get the no of Page 
         * @param NA
         * @return Integers
         * @throws NA
         **/
    public Integer getPageNumber() {
        System.debug('OffsetSize/QueryLimit'+OffsetSize/QueryLimit);
        pageNumber=OffsetSize/QueryLimit + 1;
        return pageNumber;
    }
    
    /**
         * Description : used to get the no of Pages 
         * @param NA
         * @return Integers
         * @throws NA
         **/
    public Integer getTotalPages() {
        if (math.mod(CountTotalRecords, QueryLimit) > 0) {
            totalPages=CountTotalRecords/QueryLimit + 1;
            return totalPages;
        }else{
            totalPages=(CountTotalRecords/QueryLimit);
            return totalPages;
        }
    }
    //Dup Logic
     public void duplicateProcess() {

            Set<Id> dupSet = new Set<Id>();
            if(currentProduct!=null && !mapProdDopWrap.containsKey(currentProduct)){
            List<Order> orderLst = [Select id,(Select id,Shipped_Product__c from OrderItems where Status__c!='Cancelled' and Shipped_Product__c=:currentProduct),ShipToContactid,ShipToContact.name from Order where ShipToContactid in:listofcontactaddresstotal];
             for(Order orderObj : orderLst){
                            system.debug('dupSet----->'+dupSet);

                    for(OrderItem itemsObj : orderObj.OrderItems){
                        

                        if(dupSet.contains(orderObj.ShipToContactid))
                            break;
                        if(!deletedContact.contains(orderObj.ShipToContactid)){
                            if(!mapProdDopWrap.containsKey(itemsObj.Shipped_Product__c)){
                                List<DuplicateList> tempDupList = new List<DuplicateList>();
                                tempDupList.add(new DuplicateList(orderObj.ShipToContact.name,orderObj.ShipToContactid,itemsObj.Shipped_Product__c));
                                mapProdDopWrap.put(itemsObj.Shipped_Product__c, tempDupList);
                            }
                            else{
                                mapProdDopWrap.get(itemsObj.Shipped_Product__c).add(new DuplicateList(orderObj.ShipToContact.name,orderObj.ShipToContactid,itemsObj.Shipped_Product__c));

                            }
                            dupSet.add(orderObj.ShipToContactid);
                        }
                    }
            }

        }


         
           for(OrderLineItemList orderLstObj : OrderLineItemcoll){
               if(mapProdDopWrap.containsKey(orderLstObj.productdetials.id)){
                   for(DuplicateList dupWrap:mapProdDopWrap.get(orderLstObj.productdetials.id)){
                            if(orderLstObj.productdetials.id==dupWrap.prod2ID){
                                 orderLstObj.showDuplicatePop = true;
                            }
                            
                   }
               }
                
        }
                    System.debug('mapProdDopWrap---->'+mapProdDopWrap);

        
    }


     public void hidePopup() {
           // dispDuplicate = false;

           for(OrderLineItemList orderLstObj : OrderLineItemcoll){
              if(mapProdDopWrap.containsKey(orderLstObj.productdetials.id)){
                   for(DuplicateList dupWrap:mapProdDopWrap.get(orderLstObj.productdetials.id)){
                            if(orderLstObj.productdetials.id==dupWrap.prod2ID){
                                 orderLstObj.showDuplicatePop = false;
                            }
                            if(orderLstObj.productdetials.id==dupWrap.prod2ID && dupWrap.optionChoosed!=null){
                                 orderLstObj.hasDuplicate = false;
                                 orderLstObj.isProdProcessed = true;
                            }
                            else if(orderLstObj.productdetials.id!=dupWrap.prod2ID  && !orderLstObj.isProdProcessed){
                                orderLstObj.hasDuplicate = true;
                            }

                   }
           }
                
        }
        
        System.debug('mapProdDopWrap1111---->'+mapProdDopWrap);

        checkForDuplicate();
        
    }

     public void cancelPopup() {
           
           for(OrderLineItemList orderLstObj : OrderLineItemcoll){
              if(mapProdDopWrap.containsKey(orderLstObj.productdetials.id)){
                   for(DuplicateList dupWrap:mapProdDopWrap.get(orderLstObj.productdetials.id)){
                            if(orderLstObj.productdetials.id==dupWrap.prod2ID){
                                 orderLstObj.showDuplicatePop = false;
                            }
                   }
           }
                
        } 
        
                    System.debug('mapProdDopWrap22222---->'+mapProdDopWrap);
    }

    /*@Method <This method gets invoked from constructor>
    @param No Parameters Required
    @return  - <No Return>
    @throws exception - <No Exception>
    */
    public void checkForDuplicate(){
        Integer totalCount = 0;
        for(OrderLineItemList orderLstObj : OrderLineItemcoll){
            if(orderLstObj.hasDuplicate){
                duplicateCheckDone = false;
                totalCount++;
            }
            else if(totalCount==0 && !orderLstObj.hasDuplicate){
                duplicateCheckDone = true;
            }

                
        }

                            System.debug('mapProdDopWrap3333--->'+mapProdDopWrap);
     
    }
    //End of checkForDuplicate
    //End of Dup logic
    
    /**
         * Description : wrapper class for the contact table
         * @param NA
         * @return NA
         * @throws NA
         **/
    public class Ordercontacts{
        
        public Contact con{get;set;}
        public Order sampleorder{get;set;}
        public String email {
            get{
                if(con.email == null){
                    return 'Please update email on contact record';
                }
                return email=con.email;
            }

            set;
        }
        public String shippinginstructions{get;set;}
        public Date futureshipdate{get;set;}
        public Date canceldate{get;set;}
        public String address{get;set;}
        public String contactrole {get;set;}
                //Address Issue


         public id contactid{get;set;}
        
        public string selected{get;set;}
        
        public string line1{get;set;}
        public string line2{get;set;}
        public string line3{get;set;}
        public string line4{get;set;}
        public string street{
            get{
                if(selected == 'Custom')
                {
                    return line1 + '\r\n' + line2 + '\r\n' + line3 + '\r\n' + line4;
                }
                return street;
            }
            set;
        }

        public string city{get;set;} 
        public string state{get;set;}
        public string country{get;set;}
        public string postalcode{get;set;}
        public boolean isCustom {get; set;}
        public boolean isContMailing {get; set;}
        public boolean isContOther {get; set;}
        public boolean isAccountPhysical {get; set;}


        public string addressline1 {get; set;}
        public string addressline2 {get; set;}
        public string addressline3 {get; set;}
        public string addressline4 {get; set;} 
        public string mailingcity {get; set;}
        public string mailingstate {get; set;}
        public string mailingcountry {get; set;}
        public string mailingpostalcode {get; set;}
        public String selectedValue {get; set;}





                //Address Issue


        
        public Ordercontacts(contact tempcon,order temporder,id oppid)
        {
            con=tempcon;
            sampleorder=temporder;
            shippinginstructions='';

            if(con.Preferred_Address__c== System.Label.ContactMailing)
            {
                address='Mailing Address';
            }
            else if(con.Preferred_Address__c== System.Label.Contact_Other)
            {
                address='Other Address';
            }  
            else if(con.Preferred_Address__c=='None'|| con.Preferred_Address__c == null || con.Preferred_Address__c == '')    
            {   
                address='Account';
            }    
            
            contactrole=[select Role from OpportunityContactRole where OpportunityId=:oppid and contactid =:con.id limit 1].role;



            isCustom = false;
            isContMailing = false;
            isContOther = false;
            isAccountPhysical = false;
            addressline1 = '';
            addressline2 = '';
            addressline3 = '';
            addressline4 = '';
            mailingcity = '';
            mailingstate = '';
            mailingcountry = '';
            mailingpostalcode = '';
            selectedValue ='' ;



        this.contactid=con.id;
            
            if(con.Preferred_Address__c== System.Label.ContactMailing)
            {
                street=con.Mailingstreet;
                city=con.Mailingcity;
                state=con.Mailingstate;
                country=con.Mailingcountry;         
                postalcode=con.Mailingpostalcode;
                selected='Contact Mailing';
                
            }
            else if(con.Preferred_Address__c == System.Label.Contact_Other)
            {
                street=con.Otherstreet;
                city=con.Othercity;
                state=con.Otherstate;
                country=con.Othercountry;         
                postalcode=con.Otherpostalcode;
                selected='Contact Other';
            }  
            else if( con.Preferred_Address__c == null || con.Preferred_Address__c == '' || con.Preferred_Address__c =='None')    
            {   
                street=con.account.shippingstreet;
                city=con.account.shippingcity;
                state=con.account.shippingstate;
                country=con.account.shippingcountry;         
                postalcode=con.account.shippingpostalcode;
                selected='Account';
            }    





        }
    }  
    
    public void processAddress(){
        system.debug('!ordercontactlist---------->'+ordercontactlist);
    }

    public class DuplicateList{//wrapper class for the product table
        public String contName{get;set;}
        public Id contactId{get;set;}
        public String prod2ID{get; set;}
        public String optionChoosed{get; set;}
        public List<SelectOption> listOptions{get; set;}



        public DuplicateList(String contactName , Id conId , Id productID){
            listOptions = new List<SelectOption>();
            listOptions.add(new SelectOption('Yes','Yes'));
            listOptions.add(new SelectOption('No','No'));
            optionChoosed = 'No';
         
            contName = contactName;
            contactId = conId;
            prod2ID = productID;

        }

    }        
    /**
         * Description : wrapper class for the product table
         * @param NA
         * @return NA
         * @throws NA
         **/
    public class OrderLineItemList{
        public integer Quantity{get;set;}
        public string restriction{get;set;}
        public string shippingmethod{get;set;} 
        public boolean freecopysub{get;set;}                 
        public product2 productdetials{get;set;}
        public boolean dgprod{get;set;}
        public orderitem tempprod{get;set;}                   
        public boolean hasDuplicate{get;set;}
        public boolean showDuplicatePop{get;set;}
        public boolean isProdProcessed{get;set;}



        public OrderLineItemList(orderitem selectedProduct , List<Contact> listofcontactaddress){
            hasDuplicate = false;
            showDuplicatePop = false;
            isProdProcessed = true;
            productdetials=[select id,name,Author__c,ISBN__c,Status__c,Sampling_Restriction__c,Free_Copy_Substitute__c from product2 where id =:selectedProduct.Shipped_Product__c limit 1];  
            tempprod=selectedProduct;
            Quantity=integer.valueOf(selectedProduct.Quantity);                 
            restriction=productdetials.Sampling_Restriction__c;
            freecopysub= (( productdetials.Free_Copy_Substitute__c != null ) ? false : true );
            shippingmethod='Ground';
            dgprod= selectedProduct.Digital_Product_System_Added__c;
            
            List<OrderItem> orderItemLst = [Select id,Shipped_Product__c from OrderItem where Orderid in (Select id from Order where ShipToContactid in:listofcontactaddress) and Status__c!='Cancelled' and Shipped_Product__c=:productdetials.id];
            if(orderItemLst.size()>0){
                    hasDuplicate = true;
            }
    
        }
    }
    
    /**
         * Description : wrapper class used to store the address of the contact
         * @param NA
         * @return NA
         * @throws NA
         **/
    public class Addressfields{
        
        public id contactid{get;set;}
        
        public string selected{get;set;}
        
        public string line1{get;set;}
        public string line2{get;set;}
        public string line3{get;set;}
        public string line4{get;set;}
        public string street{
            get{
                if(selected == 'Custom')
                {
                    return line1 + '\r\n' + line2 + '\r\n' + line3 + '\r\n' + line4;
                }
                return street;
            }
            set;
        }

        public string city{get;set;} 
        public string state{get;set;}
        public string country{get;set;}
        public string postalcode{get;set;}

        public Addressfields(Contact con){
               
            this.contactid=con.id;
            
            if(con.Preferred_Address__c== System.Label.ContactMailing)
            {
                street=con.Mailingstreet;
                city=con.Mailingcity;
                state=con.Mailingstate;
                country=con.Mailingcountry;         
                postalcode=con.Mailingpostalcode;
                selected='Contact Mailing';
            }
            else if(con.Preferred_Address__c == System.Label.Contact_Other)
            {
                street=con.Otherstreet;
                city=con.Othercity;
                state=con.Otherstate;
                country=con.Othercountry;         
                postalcode=con.Otherpostalcode;
                selected='Contact Other';
            }  
            else if( con.Preferred_Address__c == null || con.Preferred_Address__c == '' || con.Preferred_Address__c =='None')    
            {   
                street=con.account.shippingstreet;
                city=con.account.shippingcity;
                state=con.account.shippingstate;
                country=con.account.shippingcountry;         
                postalcode=con.account.shippingpostalcode;
                selected='Account';
            }    
        }
    }
    
    
    
   /* public class duplicateitems {//wrapper class to display list of duplicate items
        
        public boolean selected{get;set;}
        public contact con{get;set;}
        public account acc{get;set;}
        public product2 prod{get;set;}
        public duplicateitems(id conid,id prodid)
        {
            selected=false;
            con = [select name,accountid from contact where id =:conid limit 1 ];
            acc = [select name from account where id =:con.accountid limit 1];
            prod =[select name from product2 where id =:prodid limit 1]; 
        }
    }  */
     

}