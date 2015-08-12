/************************************************************************************************************
* Apex Class Name   : RetrieveOneCRMHandler.cls
* Version           : 1.0 
* Created Date      : 12 May 2015
* Function          : Handler class for RetrieveOneCRM WebService
* Modification Log  :
* Developer                   Date                    Description
* -----------------------------------------------------------------------------------------------------------
* Davi Borges              01/Jul/2015            For RetrieveOrderInfoByIds we now populate the override addres
*                                                 output field using Shipping Address Information
* -----------------------------------------------------------------------------------------------------------                                                 
* Davi Borges              16/Jul/2015            Inclusion of the ERP_Order_Number__c as order item destina
*                                                 tionId and order destinationId
************************************************************************************************************/

public with sharing class RetrieveOneCRMHandler    
{ 
  /*
   * Handle the RetrieveOneCRM request for South Africa
   */	
  public static RetrieveOneCRM.RetrieveOrderResult handleSARetrieveRequest(String opportunityId)
  {
  	RetrieveOneCRM.RetrieveOrderResult result = new RetrieveOneCRM.RetrieveOrderResult();
    result.errorCode = 0;
    result.errorMessage ='';
  	try
  	{
  	  Opportunity opp;

      Account_Correlation__c externalRef;
       
      List<Opportunity> oppList =[SELECT Id,Account.Id, Account.Name, Account.Pearson_Account_Number__c, Account.External_Account_Number__c, 
                                  Qualification_Campus__r.Name, Qualification_Campus__r.Pearson_Campus_Picklist__c, Qualification_Campus__r.Pearson_Institution__c, Conferer__c,
                                  CreatedBy.FirstName, International_Student_Status__c, International_Sponsor__c, Academic_Start_Date__c,
                                  Type, External_Opportunity_Number__c, External_ID__c,Enrolment_Status__c,
                                  Lost_Reason__c, Lost_Reason_Other__c,
                                  Qualification_Code__c,Qualification_Level_Code__c,Qualification__c,
                                  (SELECT Id, IsPrimary, Role, ContactId, Contact.Salutation, Contact.FirstName, Contact.Middle_Name__c, 
                                  Contact.LastName, Contact.Gender__c, Contact.Marital_Status__c, Contact.Birthdate__c, Contact.First_Language__c,
                                  Contact.Ethnic_Origin__c, Contact.National_Identity_Number__c, Contact.Passport_Number__c, Contact.MailingStreet, 
                                  Contact.MailingState, Contact.MailingStateCode,Contact.MailingCountry,Contact.MailingCountryCode, Contact.MailingCity, 
                                  Contact.MailingPostalCode,Contact.OtherStreet, Contact.OtherState, Contact.OtherStateCode,Contact.OtherCountry,
                                  Contact.OtherCountryCode, Contact.OtherCity, Contact.OtherPostalCode,Contact.MobilePhone,Contact.HomePhone,
                                  Contact.Phone, Contact.Fax, Contact.Home_Phone__c, Contact.Email, Contact.Secondary_Email__c, Contact.Year_of_Graduation__c,
                                  Contact.Special_Requirements__c, Contact.LastModifiedDate FROM OpportunityContactRoles), 
                                  (SELECT Id, Quantity ,PricebookEntry.Name, OptionId__c, OptionId__r.Id, OptionId__r.Name,OptionId__r.Module_Code__c, 
                                  Discount_Reference__c, PricebookEntry.Product2.Name,PricebookEntry.Product2.Qualification_Code__c, 
                                  PricebookEntry.Product2.Qualification_Level_Code__c,PricebookEntry.Product2.Qualification_Level_Name__c,
                                  PricebookEntry.Product2.Qualification_Name__c, Amendment_Action__c, Outside_Module__c FROM OpportunityLineItems ORDER BY PricebookEntry.Name DESC, OptionId__c DESC NULLS FIRST, Outside_Module__c  NULLS FIRST ),
                                  (SELECT Course_Fee_Rollup__c,Deposit__c,Payment_Method__c,Payment_Period_In_Month__c,Payment_Type__c,
                                  Scheduled_Monthly_Payments_f__c,Total_Actual_Course_Fee_f__c 
                                  FROM Apttus_Proposal__R00N70000001yUfDEAU__r WHERE Apttus_Proposal__Primary__c = true) 
                                  FROM Opportunity WHERE Id =: opportunityId];


      /* 2 - check if the opportunity query returned a value. If not the service will return ErrorCode =1 and ErrorMessage
       * that “It was not possible to find an opportunity with the associated Id:[<Id provided>”
       */ 
      if(oppList == null || oppList.isEmpty())
      {
        String errorMessageRecordNotFound = 'It was not possible to find an opportunity with the associated Id:[' + opportunityId + ']';
        System.debug(errorMessageRecordNotFound);
        result.errorCode = 1;
        result.errorMessage = errorMessageRecordNotFound;
        throw new RetrieveOneCRM.RetreiveOneCRMException(result.errorCode + '|' + errorMessageRecordNotFound);
      }
      else
      {
        opp = oppList.get(0);

        List<Account_Correlation__c> accountCorrelations = [SELECT External_ID_Name__c,External_ID__c,External_System__c 
                                                            FROM Account_Correlation__c 
                                                            WHERE Account__c =: opp.Account.Id AND External_ID_Name__c = 'eVision Learner Number' LIMIT 1];

        if(accountCorrelations != null && !accountCorrelations.isEmpty())
        {
          externalRef = accountCorrelations.get(0);
        }
      }

      // Mapping process from Opportunity and Account
      INT_Order order = new INT_Order();
      order.sourceId = (opp.External_Opportunity_Number__c != null) ? opp.External_Opportunity_Number__c : opp.Id;
      order.destinationId = opp.External_ID__c;

      //order.orderStatus =''; //-->TODO: Logic for status
      order.internationalStudentStatus = opp.International_Student_Status__c;
      order.internationalSponsor = opp.International_Sponsor__c;
      order.academicStartDate = opp.Academic_Start_Date__c;
      order.enrolmentStatus = opp.Enrolment_Status__c;
      order.enrolmentType = opp.Type;
      order.account = new INT_Account();
      //order.account.sourceId = opp.Account.Id;
      order.account.friendlyUniqueIdentifier = opp.Account.Pearson_Account_Number__c;
      order.account.legacyAccountId = opp.Account.External_Account_Number__c;
      order.account.pearsonOrganisation = new INT_Organisation();
      order.account.pearsonOrganisation.name = opp.Qualification_Campus__r.Pearson_Institution__c;
      order.account.destinationId = (externalRef !=null) ? externalRef.External_ID__c : null;

      /* This piece of the code determines what value should be passed as destinationId. Migrated learner 
       * have a legacy id and this should be passed as value, otherwise we need to pass the friendlyUniqueIdentifier
       * that is generated by Salesforce OneCRM
       */

      if(order.account.legacyAccountId ==null || order.account.legacyAccountId =='')
      { 
        order.account.sourceId = order.account.friendlyUniqueIdentifier;
      }
      else
      {
      	order.account.sourceId = order.account.legacyAccountId;
      }
            
      // Mapping process from Proposal, for SA there is only one primary proposal per opportunity
      if(opp.Apttus_Proposal__R00N70000001yUfDEAU__r.size() >0)
      {
        order.price = new INT_Price();
        order.payment = new INT_Payment();
        Apttus_Proposal__Proposal__c proposal = opp.Apttus_Proposal__R00N70000001yUfDEAU__r.get(0);
        order.payment.method =proposal.Payment_Method__c;
        order.payment.interval = proposal.Payment_Period_In_Month__c;
        order.payment.paymentType =proposal.Payment_Type__c;
        order.payment.deposit = proposal.Deposit__c;
        //order.payment.receiptNo = opp.Registration_Payment_Reference__c;
        //order.payment.earlybirdReceiptNo =opp.Earlybird_Payment_Reference__c;
        order.price.totalMonthlyCost = proposal.Scheduled_Monthly_Payments_f__c;
        order.price.totalCost = proposal.Total_Actual_Course_Fee_f__c;
        order.price.totalUpfrontCost=  proposal.Course_Fee_Rollup__c;
      }

      // Mapping process from Opportunity Contacts 
      order.shipToContact = new INT_Contact(); //--> learner
      order.billToContact = new INT_Contact(); //--> sponsor
      boolean sponsorFound = false;
      for(OpportunityContactRole refrole : opp.OpportunityContactRoles)
      {
        INT_Contact contact = new INT_Contact();
        contact.sourceId = refrole.ContactId;
		contact.title = refrole.Contact.Salutation;
        contact.firstName = refrole.Contact.FirstName;
	    contact.middleName = refrole.Contact.Middle_Name__c;
        contact.lastName = refrole.Contact.LastName;
        contact.gender = refrole.Contact.Gender__c;
        //contact.maidenName = <TODO>:Mapping
        contact.dateOfBirth = refrole.Contact.Birthdate__c;
        contact.governmentId = refrole.Contact.National_Identity_Number__c;
        contact.passportNo = refrole.Contact.Passport_Number__c;
        contact.maritalStatus = refrole.Contact.Marital_Status__c;

        contact.firstLanguage = refrole.Contact.First_Language__c;
        contact.ethnicalOrigin = refrole.Contact.Ethnic_Origin__c;
        contact.yearOfGraduation = refrole.Contact.Year_of_Graduation__c;
        contact.specialRequirements = refrole.Contact.Special_Requirements__c;
        contact.lastModifiedDate = refrole.Contact.LastModifiedDate;
                
        contact.emailAddresses = new INT_EmailAddresses();
        contact.emailAddresses.personal = refrole.Contact.Email;
        contact.emailAddresses.work = refrole.Contact.Secondary_Email__c;

        contact.addresses = new INT_Addresses();

        contact.addresses.postal = new INT_Address();
        contact.addresses.postal.addressLine1  = refrole.Contact.MailingStreet;
        contact.addresses.postal.state = refrole.Contact.MailingState;
        contact.addresses.postal.country = refrole.Contact.MailingCountry;
        contact.addresses.postal.city = refrole.Contact.MailingCity;
        contact.addresses.postal.postalCode = refrole.Contact.MailingPostalCode;

        // the other address of the contact is the home address of the person.          
        contact.addresses.home = new INT_Address();
        contact.addresses.home.addressLine1  = refrole.Contact.OtherStreet;
	    contact.addresses.home.state = refrole.Contact.OtherState;
        contact.addresses.home.country = refrole.Contact.OtherCountry;
        contact.addresses.home.city = refrole.Contact.OtherCity;
        contact.addresses.home.postalCode = refrole.Contact.OtherPostalCode;
 
 
        contact.numbers = new INT_TelephoneNumbers();
        contact.numbers.mobile = new INT_TelephoneNumber();
        contact.numbers.mobile.telephoneNumber =  refrole.Contact.MobilePhone;
        contact.numbers.work = new INT_TelephoneNumber();
        contact.numbers.work.telephoneNumber =  refrole.Contact.Phone;
        contact.numbers.home = new INT_TelephoneNumber();
        contact.numbers.home.telephoneNumber =  refrole.Contact.Home_Phone__c;
        contact.numbers.fax = new INT_TelephoneNumber();
        contact.numbers.fax.telephoneNumber =  refrole.Contact.Fax;

        if(refrole.Role == 'Business User') 
        {
          order.shipToContact = contact;
        }
        if(refrole.Role == 'Primary Sales Contact')
        {
          order.billToContact = contact;
          sponsorFound = true;
        }
      }
            
      // if the sponsor is null set it to the learner
      if(!sponsorFound)
      {
        order.billToContact = order.shipToContact;
      } 

      /* Mapping process from Opportunity Items. he above query guarantees that the first item to be processed is 
       * the qualification order line item 
       */
      
      Id parentItem = null;

      //Code for the qualification, the qualification information will come from the opportunity header

      if(order.lineItems ==null) order.lineItems = new List<INT_LineItem>();
      INT_LineItem int_qal_item = new INT_LineItem();

      int_qal_item.destinationId = opp.External_ID__c;
      int_qal_item.course = new INT_CourseProduct();
      int_qal_item.course.institution = new INT_Institution();
      int_qal_item.course.institution.name = opp.Qualification_Campus__r.Pearson_Institution__c;
      int_qal_item.course.institution.campus = new INT_Campus();
      int_qal_item.course.institution.campus.name = opp.Qualification_Campus__r.Pearson_Campus_Picklist__c;
      int_qal_item.course.enrolmentType = opp.Type;
      int_qal_item.course.enrolmentStatus = opp.Enrolment_Status__c;
        
      INT_Qualification qualification = new INT_Qualification();
      qualification.name = (opp.OpportunityLineItems.size()>0)? opp.OpportunityLineItems[0].PricebookEntry.Product2.Qualification_Name__c : null;
      qualification.code = (opp.OpportunityLineItems.size()>0)? opp.OpportunityLineItems[0].PricebookEntry.Product2.Qualification_Code__c : null;
      if(opp.OpportunityLineItems[0].PricebookEntry.Product2.Qualification_Level_Name__c != null)
      {
        qualification.level = (opp.OpportunityLineItems.size()>0)? String.valueOf(opp.OpportunityLineItems[0].PricebookEntry.Product2.Qualification_Level_Name__c.intValue()) : null;
      }
      qualification.levelCode = (opp.OpportunityLineItems.size()>0)? opp.OpportunityLineItems[0].PricebookEntry.Product2.Qualification_Level_Code__c : null;
      int_qal_item.course.qualification = qualification;

      order.lineItems.add(int_qal_item);  

      for(OpportunityLineItem item : opp.OpportunityLineItems)
      {
        INT_LineItem int_item = new INT_LineItem();
        int_item.destinationId = opp.External_ID__c;
        if(item.OptionId__c ==null)
        {
          parentItem = item.Id;
        }
        else
        {
          int_item.parentLineId = parentItem;
          int_item.module = new INT_ModuleProduct();
          int_item.module.name = item.OptionId__r.Name;
          int_item.module.code = item.OptionId__r.Module_Code__c;
          int_item.status = item.Discount_Reference__c;
          int_item.action  = item.Amendment_Action__c;
          order.lineItems.add(int_item); 
        }
      }

      //  Cancel Application
      if(opp.Lost_Reason_Other__c != null || opp.Lost_Reason__c != null)
      {
        order.cancelEnrolment = new INT_CancelEnrolment();
        order.cancelEnrolment.reason = (opp.Lost_Reason_Other__c != null) ? opp.Lost_Reason_Other__c : opp.Lost_Reason__c;
      }
      result.order = order;

    }
    catch(RetrieveOneCRM.RetreiveOneCRMException rex)
    {
      throw rex;
    }
    catch(Exception ex)
    {
      /*If an error happens we will return -1 as an indication that the response is not successful 
       *response and we had a technical failure
       */
      result.errorCode = -1;
      result.errorMessage = ex.getMessage();
      throw new RetrieveOneCRM.RetreiveOneCRMException(string.valueof(result.errorCode), ex);
    }

     return result;
  }
  
  /*
   * Handle the RetrieveOneCRM request for the United States
   */	
  public static RetrieveOneCRM.RetrieveOrderResult handleUSRetrieveRequest(String orderId)
  {  	
  	return RetrieveOrderInfoByIds(orderId, null);
  }  
  
  public static RetrieveOneCRM.RetrieveOrderResult RetrieveOrderInfoByIds (Id OrderId, Id itemId)
  {
    /*
     * This is the entity that is returned as response. ErrorCode = 0 is an indication of a successful response. 
     * If with the Id provide is not possible to find a record, the service will return ErrorCode =1 and ErrorMessage
     * that “It was not possible to find an order with the associated Id:[<Id provided>”
     */
    RetrieveOneCRM.RetrieveOrderResult result = new RetrieveOneCRM.RetrieveOrderResult();
    result.errorCode =0;
    result.errorMessage ='';
    
    if(String.isBlank(OrderId))
    {
      String errorMessageBlankID = 'A blank order id has been passed as a parameter:[' + OrderId + ']';
      System.debug(errorMessageBlankID);
      result.errorCode = 1;
      result.errorMessage = errorMessageBlankID;
      throw new RetrieveOneCRM.RetreiveOneCRMException(result.errorCode + '|' + errorMessageBlankID);  
    }
    
    try
    {
      System.debug('Provided OrderId =[' + OrderId +']');
      List<Order> orderList = [SELECT o.Status, o.Shipping_Instructions__c, o.Rush_Flag__c, o.Division_ID__c, o.Packing_Instructions__c, 
                                      o.POBox_Indicator__c, o.Override_Schedule_Delivery_Date__c,o.ShippingStateCode,o.ShippingState, o.ShippingPostalCode, 
                                      o.ShippingCountry, o.ShippingCity, o.ShippingStreet,o.Order_Address_Type__c, o.OrderNumber, o.Id, o.Do_Not_Ship_Before_Date__c, 
                                      o.CreatedDate,o.CreatedBy.TimeZoneSidKey, o.Cancel_After_Date__c,   o.Account.Sampling_Account_Number__c, o.Account.Sampling_Sub_Account_Number__c,
                                      o.Account.Name, o.Account.Primary_Selling_Account__c, o.Account.Primary_Selling_Account__r.name, o.Account.ShippingStreet, o.Account.ShippingCity, o.Account.ShippingCountry, 
                                      o.Account.ShippingPostalCode, o.Account.ShippingState, o.Account.ShippingStateCode, o.CompanyAuthorizedById, o.CompanyAuthorizedBy.Charge_Code__c, o.CompanyAuthorizedBy.Email,
                                      o.CompanyAuthorizedBy.Phone, o.CompanyAuthorizedBy.FirstName, o.CompanyAuthorizedBy.LastName, o.ShipToContactId, o.ShipToContact.Email,
                                      o.ShipToContact.Salutation, o.ShipToContact.FirstName, o.ShipToContact.LastName,
                                      (Select Id, TitleStatusOverrideIndicator__c, Target_System__c, ERP_Order_Number__c, RestrictionOverrideIndicator__c, Status__c,  
                                      Shipping_Method__c, Quantity, OrderItemNumber, Item_Number__c, ForceShipIndicator__c, AllowSubstitutesIndicator__c, Shipped_Product__c, Shipped_Product__r.SBN__c, 
                                      Shipped_Product__r.ISBN__c, Shipped_Product__r.Name From OrderItems)   
                                      From Order o WHERE Id =: OrderId]; 
                                   
                                   //RequestShipMethodCode__c, 
                                 
      if(orderList == null || orderList.isEmpty())
      {
        String errorMessageRecordNotFound = 'It was not possible to find an order with the associated Id:[' + OrderId + ']';
        System.debug(errorMessageRecordNotFound);
        result.errorCode = 1;
        result.errorMessage = errorMessageRecordNotFound;
        throw new RetrieveOneCRM.RetreiveOneCRMException(result.errorCode + '|' + errorMessageRecordNotFound);
      }
        
      Order ord = orderList.get(0);
      INT_Order orderINT = new INT_Order();
      if(ord.Account != null)
      {
        orderINT.account = new INT_Account();
        orderINT.account.businessId = ord.Account.Sampling_Account_Number__c;
        orderINT.account.subBusinessId = ord.Account.Sampling_Sub_Account_Number__c;
        orderINT.account.name = ord.Account.Name;
        OrderINT.account.parentAccount = new INT_Account();
        orderINT.account.parentAccount.name = ord.Account.Primary_Selling_Account__r.Name;
        orderINT.account.shippingAddress = new INT_Address();
        orderINT.account.shippingAddress.addressLine1 = ord.Account.ShippingStreet;
        orderINT.account.shippingAddress.city = ord.Account.ShippingCity;
        orderINT.account.shippingAddress.country = ord.Account.ShippingCountry;
        orderINT.account.shippingAddress.postalCode = ord.Account.ShippingPostalCode;
        orderINT.account.shippingAddress.state = ord.Account.ShippingStateCode;
      }  
         
      orderINT.cancelAfterDate = ord.Cancel_After_Date__c;
      orderINT.createdDate = ord.CreatedDate.format('yyyy-MM-dd', ord.CreatedBy.TimeZoneSidKey);
      //orderINT.createdDate = ord.CreatedDate;
      orderINT.doNotShipBeforeDate = ord.Do_Not_Ship_Before_Date__c;
      orderINT.sourceId = ord.Id;
      orderINT.businessId = ord.OrderNumber;
      orderINT.overrideDeliveryAddress = new INT_Address();

      // The override address functionality is popualted with the address is not comming from the account,
      // this is determined base on the value of Order_Address_Type__c. 

      if(ord.Order_Address_Type__c != 'Account'){

        string[] streetlist = (ord.ShippingStreet != null) ? ord.ShippingStreet.split('\r\n') : new string[0];

        orderINT.overrideDeliveryAddress.state = ord.ShippingStateCode;
        orderINT.overrideDeliveryAddress.postalCode = ord.ShippingPostalCode;
        orderINT.overrideDeliveryAddress.addressLine1 = (streetlist.size()>1) ? streetlist[0] : null;
        orderINT.overrideDeliveryAddress.addressLine2 = (streetlist.size()>2) ? streetlist[1] : null;
        orderINT.overrideDeliveryAddress.addressLine3 = (streetlist.size()>3) ? streetlist[2] : null;
        orderINT.overrideDeliveryAddress.addressLine4 = (streetlist.size()>4) ? streetlist[3] : null;
        orderINT.overrideDeliveryAddress.city = ord.ShippingCity;
        orderINT.overrideDeliveryAddress.country = ord.ShippingCountry;
      }

      orderINT.schedDeliveryOverride = ord.Override_Schedule_Delivery_Date__c; 
      orderINT.pOBoxIndicator = ord.POBox_Indicator__c;
      orderINT.rushFlag = ord.Rush_Flag__c;
      orderINT.divisionId = ord.Division_ID__c;
      orderINT.salesrep = new INT_Employee();
      orderINT.salesrep.sourceId = ord.CompanyAuthorizedById;
      orderINT.salesrep.chargeCode = ord.CompanyAuthorizedBy.Charge_Code__c;
      orderINT.salesrep.email = ord.CompanyAuthorizedBy.Email;
      orderINT.salesrep.phone = ord.CompanyAuthorizedBy.Phone;
      orderINT.salesrep.firstName = ord.CompanyAuthorizedBy.FirstName;
      orderINT.salesrep.lastName = ord.CompanyAuthorizedBy.LastName;
      orderINT.shipToContact = new INT_Contact();
      orderINT.shipToContact.sourceId = ord.ShipToContact.Id;
      orderINT.shipToContact.emailAddresses = new INT_EmailAddresses();
      orderINT.shipToContact.emailAddresses.work = ord.ShipToContact.Email;
      orderINT.shipToContact.title = ord.ShipToContact.Salutation;
      orderINT.shipToContact.firstName = ord.ShipToContact.FirstName;
      orderINT.shipToContact.LastName = ord.ShipToContact.LastName;
      
      String abbreviatedname = ord.ShipToContact.LastName + ', ' +ord.ShipToContact.FirstName;
      
      orderINT.shipToContact.abbreviatedname = (abbreviatedname == null || abbreviatedname.length() <= 30)?abbreviatedname : abbreviatedname.substring(0,29);
      
      orderINT.orderStatus = ord.Status;
       
      // order field missing orderINT.destinationId = ord.
      
      if(ord.OrderItems.size() > 0)
      {
         orderINT.lineItems = new List<INT_LineItem>(); 
      }
      
      for(OrderItem oi : ord.OrderItems)
      {
        if(itemId ==null || oi.Id == itemId)
        {
          INT_LineItem lineItemINT = new INT_LineItem();
          
          INT_BookProduct book = new INT_BookProduct();
          
          book.isbn10 = oi.Shipped_Product__r.SBN__c;
          book.isbn13 = oi.Shipped_Product__r.ISBN__c;
          book.name = oi.Shipped_Product__r.Name;
          book.titleStatusOverride = oi.TitleStatusOverrideIndicator__c;
                  
          lineItemINT.book = book;
          
          INT_BookProduct shippedBook = new INT_BookProduct();
          shippedBook.isbn10 = oi.Shipped_Product__r.SBN__c;
          shippedBook.isbn13 = oi.Shipped_Product__r.ISBN__c;
                      
          lineItemINT.shippedBook = shippedBook;        
          
          lineItemINT.quantity = oi.Quantity.intValue();
          lineItemINT.shipMethodCode = oi.Shipping_Method__c;
          //lineItemINT.shipMethodCode = oi.RequestShipMethodCode__c;
          lineItemINT.sourceId = oi.Id;
          lineItemINT.destinationId = oi.ERP_Order_Number__c;
          lineItemINT.itemNumber = String.valueOf(oi.Item_Number__c);
          lineItemINT.status = oi.Status__c;
          lineItemINT.allowSubstitution = oi.AllowSubstitutesIndicator__c;
          lineItemINT.restrictionOverride = oi.RestrictionOverrideIndicator__c;
          lineItemINT.forceShipping = oi.ForceShipIndicator__c;
          lineItemINT.targetSystem = oi.Target_System__c;        
          orderINT.lineItems.add(lineItemINT);
          
          //Davi Borges: 16/07/2015 Especial requirement to fullfil a UOPS requirment
          orderINT.destinationId = oi.ERP_Order_Number__c;
          
        }
      }
       
      orderINT.instructions = new List<INT_Instruction>();   
      if(!String.isBlank(ord.Packing_Instructions__c)) 
      { 
        INT_Instruction packing = new INT_Instruction();
        packing.type = 'Packing';
        packing.message = ord.Packing_Instructions__c;
        orderINT.instructions.add(packing);
      }
      if(!String.isBlank(ord.Shipping_Instructions__c))
      {
        INT_Instruction shipping = new INT_Instruction();
        shipping.type = 'Shipping';
        shipping.message = ord.Shipping_Instructions__c;
        orderINT.instructions.add(shipping);
      } 
      
      result.order = orderINT;
    }
    catch(RetrieveOneCRM.RetreiveOneCRMException rex)
    {
      throw rex;
    }
    catch(Exception ex)
    {
      /*If an error happens we will return -1 as an indication that the response is not successful 
       *response and we had a technical failure
       */
      result.errorCode = -1;
      result.errorMessage = ex.getMessage();
      System.debug('Exception is ' + ex.getMessage());
      throw new RetrieveOneCRM.RetreiveOneCRMException(string.valueof(result.errorCode), ex);
    }

    return result;
  }
  
  public static RetrieveOneCRM.RetrieveAccountResult handleRetrieveAccountByCaseId(String caseId)
  {
  	RetrieveOneCRM.RetrieveAccountResult result = new RetrieveOneCRM.RetrieveAccountResult();
    result.errorCode =0;
    result.errorMessage ='';

    Case refCase;
    Account refAccount;

    try
    {
      System.debug('Provided CaseId =[' + caseId +']');
      List<Case> case_record = [SELECT Id, Type, Account.Id, 
                                Opportunity__r.Id, Opportunity__r.External_Opportunity_Number__c,
                                Opportunity__r.External_ID__c, Opportunity__r.Conferer__c
                                FROM Case WHERE Id =: caseId];

      if(case_record == null || case_record.isEmpty())
      {
        String errorMessageRecordNotFound = 'It was not possible to find an case with the associated Id:[' + caseId + ']';            
        System.debug(errorMessageRecordNotFound);
        result.errorCode = 1;
        result.errorMessage = errorMessageRecordNotFound;
        throw new RetrieveOneCRM.RetreiveOneCRMException(result.errorCode + '|' + errorMessageRecordNotFound);

      }
      else
      {
        refCase = case_record.get(0);
        List<Account> accounts = [SELECT External_Account_Number__c,Pearson_Account_Number__c,  (SELECT Contact__c, Contact__r.Salutation, Contact__r.FirstName, Contact__r.Middle_Name__c, 
                Contact__r.LastName, Contact__r.Gender__c, Contact__r.Marital_Status__c, Contact__r.Birthdate__c, Contact__r.First_Language__c,
                Contact__r.Ethnic_Origin__c, Contact__r.National_Identity_Number__c, Contact__r.Passport_Number__c, Contact__r.MailingStreet, 
                Contact__r.MailingState, Contact__r.MailingStateCode,Contact__r.MailingCountry,Contact__r.MailingCountryCode, Contact__r.MailingCity, 
                Contact__r.MailingPostalCode,Contact__r.OtherStreet, Contact__r.OtherState, Contact__r.OtherStateCode,Contact__r.OtherCountry,
                Contact__r.OtherCountryCode, Contact__r.OtherCity, Contact__r.OtherPostalCode,Contact__r.MobilePhone,Contact__r.HomePhone,
                Contact__r.Phone, Contact__r.Fax, Contact__r.Home_Phone__c, Contact__r.Email, Contact__r.Secondary_Email__c, Contact__r.Year_of_Graduation__c,
                Contact__r.Special_Requirements__c, Contact__r.LastModifiedDate 
                FROM Contacts__r WHERE Financially_Responsible__c = true) 
                FROM Account WHERE Id =: refCase.Account.Id];

        if(accounts != null && !accounts.isEmpty())
        {
          refAccount = accounts.get(0);
        }
        else
        {
          String errorMessageRecordNotFound = 'It was not possible to find an account with the associated Id:[' + refCase.Account.Id + ']';
          System.debug(errorMessageRecordNotFound);
          result.errorCode = 2;
          result.errorMessage = errorMessageRecordNotFound;
          throw new RetrieveOneCRM.RetreiveOneCRMException(result.errorCode + '|' + errorMessageRecordNotFound);
        }


        INT_Account account =  new INT_Account();

        //order.account.sourceId = opp.Account.Id;
        account.friendlyUniqueIdentifier = refAccount.Pearson_Account_Number__c;
        account.legacyAccountId = refAccount.External_Account_Number__c;
        account.pearsonOrganisation = new INT_Organisation();
        account.pearsonOrganisation.name = refCase.Opportunity__r.Conferer__c;
                
        if(account.legacyAccountId ==null || account.legacyAccountId =='')
        { 
          account.sourceId = account.friendlyUniqueIdentifier;
        }
        else
        {
          account.sourceId = account.legacyAccountId;
        }

        for(AccountContact__c refContact : refAccount.Contacts__r)
        {
          INT_Contact contact = new INT_Contact();

          contact.sourceId = refContact.Contact__c;
          contact.title = refContact.Contact__r.Salutation;
          contact.firstName = refContact.Contact__r.FirstName;
          contact.middleName = refContact.Contact__r.Middle_Name__c;
          contact.lastName = refContact.Contact__r.LastName;
          contact.gender = refContact.Contact__r.Gender__c;
          //contact.maidenName = <TODO>:Mapping
          contact.dateOfBirth = refContact.Contact__r.Birthdate__c;
          contact.governmentId = refContact.Contact__r.National_Identity_Number__c;
          contact.passportNo = refContact.Contact__r.Passport_Number__c;
          contact.maritalStatus = refContact.Contact__r.Marital_Status__c;

          contact.firstLanguage = refContact.Contact__r.First_Language__c;
          contact.ethnicalOrigin = refContact.Contact__r.Ethnic_Origin__c;
          contact.yearOfGraduation = refContact.Contact__r.Year_of_Graduation__c;
          contact.specialRequirements = refContact.Contact__r.Special_Requirements__c;
          contact.lastModifiedDate = refContact.Contact__r.LastModifiedDate;
                    
          contact.emailAddresses = new INT_EmailAddresses();
          contact.emailAddresses.personal = refContact.Contact__r.Email;
          contact.emailAddresses.work = refContact.Contact__r.Secondary_Email__c;

          contact.addresses = new INT_Addresses();

          contact.addresses.postal = new INT_Address();
          contact.addresses.postal.addressLine1  = refContact.Contact__r.MailingStreet;
          contact.addresses.postal.state = refContact.Contact__r.MailingState;
          contact.addresses.postal.country = refContact.Contact__r.MailingCountry;
          contact.addresses.postal.city = refContact.Contact__r.MailingCity;
          contact.addresses.postal.postalCode = refContact.Contact__r.MailingPostalCode;

          /* the other address of the contact is the home address of the person.
           */
          contact.addresses.home = new INT_Address();
          contact.addresses.home.addressLine1  = refContact.Contact__r.OtherStreet;
          contact.addresses.home.state = refContact.Contact__r.OtherState;
          contact.addresses.home.country = refContact.Contact__r.OtherCountry;
          contact.addresses.home.city = refContact.Contact__r.OtherCity;
          contact.addresses.home.postalCode = refContact.Contact__r.OtherPostalCode;


          contact.numbers = new INT_TelephoneNumbers();
          contact.numbers.mobile = new INT_TelephoneNumber();
          contact.numbers.mobile.telephoneNumber =  refContact.Contact__r.MobilePhone;
          contact.numbers.work = new INT_TelephoneNumber();
          contact.numbers.work.telephoneNumber =  refContact.Contact__r.Phone;
          contact.numbers.home = new INT_TelephoneNumber();
          contact.numbers.home.telephoneNumber =  refContact.Contact__r.Home_Phone__c;
          account.defaultBillToContact = contact;
        }
        result.account = account;
      }
    }
    catch(RetrieveOneCRM.RetreiveOneCRMException rex)
    {
      throw rex;
    }
    catch(Exception ex)
    {
      /*If an error happens we will return -1 as an indication that the response is not successful 
       *response and we had a technical failure
       */
      result.errorCode = -1;
      result.errorMessage = ex.getMessage();
      throw new RetrieveOneCRM.RetreiveOneCRMException(string.valueof(result.errorCode), ex);
    }
    return result;  
  }  
  
  public static RetrieveOneCRM.RetrieveCaseResult handleRetrieveCaseById(String caseId)
  {
    RetrieveOneCRM.RetrieveCaseResult result = new RetrieveOneCRM.RetrieveCaseResult();
    result.errorCode =0;
    result.errorMessage ='';

    Case refCase;
    Account_Correlation__c externalRef;

    try
    {
      System.debug('Provided CaseId =[' + caseId +']');

      List<Case> case_record = [SELECT Id, Type, Proposed_Campus__c, 
                                Account.Id, Account.Pearson_Account_Number__c,Account.External_Account_Number__c,
                                Reason, Reason_if_Other__c,
                                Products_in_Use__r.Id, Products_in_Use__r.Opportunity__r.Id, Products_in_Use__r.Opportunity__r.External_Opportunity_Number__c,
                                Products_in_Use__r.Opportunity__r.External_ID__c, Products_in_Use__r.Opportunity__r.Conferer__c
                                FROM Case WHERE Id =: caseId];
 
      if(case_record == null || case_record.isEmpty())
      {
        String errorMessageRecordNotFound = 'It was not possible to find an case with the associated Id:[' + caseId + ']';
            
        System.debug(errorMessageRecordNotFound);
        result.errorCode = 1;
        result.errorMessage = errorMessageRecordNotFound;
        throw new RetrieveOneCRM.RetreiveOneCRMException(result.errorCode + '|' + errorMessageRecordNotFound);
      }
      else
      {
        refCase = case_record.get(0);
        List<Account_Correlation__c> accountCorrelations = [SELECT External_ID_Name__c,External_ID__c,External_System__c 
                                                            FROM Account_Correlation__c WHERE Account__c =: refCase.Account.Id AND External_ID_Name__c = 'eVision Learner Number' LIMIT 1];

        if(accountCorrelations != null && !accountCorrelations.isEmpty())
        {
          externalRef = accountCorrelations.get(0);
        }
      }

      result.serviceRequest = new INT_Case();
      result.serviceRequest.sourceId = refCase.Id;
      result.serviceRequest.account = new INT_Account();
      result.serviceRequest.account.destinationId = (externalRef !=null) ? externalRef.External_ID__c : null;
      result.serviceRequest.account.friendlyUniqueIdentifier = refCase.Account.Pearson_Account_Number__c;
      result.serviceRequest.account.legacyAccountId = refCase.Account.External_Account_Number__c;

      if(result.serviceRequest.account.legacyAccountId ==null || result.serviceRequest.account.legacyAccountId =='')
      { 
        result.serviceRequest.account.sourceId = result.serviceRequest.account.friendlyUniqueIdentifier;
      }
      else
      {
        result.serviceRequest.account.sourceId = result.serviceRequest.account.legacyAccountId;
      }

      result.serviceRequest.destinationId = refCase.Products_in_Use__r.Opportunity__r.External_ID__c;
      result.serviceRequest.type = refCase.Type;
      result.serviceRequest.targetInstitution = new INT_Institution();
      result.serviceRequest.targetInstitution.name = refCase.Products_in_Use__r.Opportunity__r.Conferer__c;
      result.serviceRequest.targetInstitution.campus = new INT_Campus();
      result.serviceRequest.targetInstitution.campus.name = refCase.Proposed_Campus__c;

      result.serviceRequest.asset = new INT_Asset();
      result.serviceRequest.asset.sourceId = (refCase.Products_in_Use__r.Opportunity__r.External_Opportunity_Number__c != null) ? refCase.Products_in_Use__r.Opportunity__r.External_Opportunity_Number__c : refCase.Products_in_Use__r.Opportunity__r.Id;
      result.serviceRequest.asset.destinationId =refCase.Products_in_Use__r.Opportunity__r.External_ID__c ;
      result.serviceRequest.asset.course = new INT_CourseProduct();
      result.serviceRequest.asset.course.cancelEnrolment = new INT_CancelEnrolment();

      if(refCase.Reason_if_Other__c != null)
      {
        result.serviceRequest.asset.course.cancelEnrolment = new INT_CancelEnrolment();
        result.serviceRequest.asset.course.cancelEnrolment.reason = refCase.Reason_if_Other__c;
      }
      else if(refCase.Reason != null)
      {
        result.serviceRequest.asset.course.cancelEnrolment = new INT_CancelEnrolment();
        result.serviceRequest.asset.course.cancelEnrolment.reason = refCase.Reason;
      }

      return result;
    }
    catch(RetrieveOneCRM.RetreiveOneCRMException rex)
    {
      throw rex;
    }
    catch(Exception ex)
    {
      /*If an error happens we will return -1 as an indication that the response is not successful 
       *response and we had a technical failure
       */
      result.errorCode = -1;
      result.errorMessage = ex.getMessage();
      throw new RetrieveOneCRM.RetreiveOneCRMException(string.valueof(result.errorCode), ex);
    }

    return result;  	
  }
}