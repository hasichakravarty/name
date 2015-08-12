@isTest
public class PS_OrderHeaderControllerTest {  
public static testmethod void processorder(){
		
         id pid=[select id from profile where name='System Administrator'].id;
         User u = new User(Alias = 'standt', Email='standarduser11@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = pid, Sample_Approval__c= true,
            TimeZoneSidKey='America/Los_Angeles', UserName='test12345'+Math.random()+'@gmail.com', Geography__c = 'Growth',Market__c = 'ZA',Line_of_Business__c = 'Higher Ed');
          insert u; 
          User u1 = new User(Alias = 'standt', Email='standarduser11@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = pid, Sample_Approval__c= false,Order_Approver__c= u.id,
            TimeZoneSidKey='America/Los_Angeles', UserName='test1234'+Math.random()+'@gmail.com', Geography__c = 'Growth',Market__c = 'ZA',Line_of_Business__c = 'Higher Ed');
            insert u1;
            list<PermissionSetAssignment> psa = new list<PermissionSetAssignment>();
            list<string> permissionsetnames = new list<string>{'Pearson_Sample_Order_Approver','Pearson_Network_Sampler','Pearson_Backend_Order_Creation','Pearson_Front_End_Sampling'};
            list<permissionset> pertset = [select id from permissionset where name in :permissionsetnames]; 
            for(integer i=0;i< pertset.size();i++ )
            {        psa.add(new PermissionSetAssignment(PermissionSetId = pertset[i].id, AssigneeId=u1.id));  }
            insert psa;
        
           
    system.runas(u1) {
            order sampleorder = TestDataFactory.returnorder();       
            Test.startTest();
            PageReference testPage = new pagereference('/apex/OrderHeaderController');
            testPage.getParameters().put('oppid',sampleorder.Opportunityid);
            testPage.getParameters().put('orderid',sampleorder.id); 
            Test.setCurrentPage(testPage);
            OrderHeaderController orderheader = new OrderHeaderController();
            orderheader.fromOnclick = false;
            orderheader.ordercontactlist[0].selectedValue= 'Other';
            orderheader.setselectedaddress1();
            orderheader.ordercontactlist[0].selectedValue= 'Mailing';
            orderheader.setselectedaddress1();
            orderheader.ordercontactlist[0].selectedValue= 'Account';
            orderheader.setselectedaddress1();
            orderheader.ordercontactlist[0].selectedValue= 'Custom';
            orderheader.setselectedaddress1(); 
            orderheader.conid = sampleorder.ShipToContactid;
            orderheader.ordercontactlisttotal[0].futureshipdate = system.today();
            orderheader.ordercontactlisttotal[0].canceldate = system.today()-1;
            orderheader.ordercontactlisttotal[0].shippinginstructions='Drop at door'; 
            orderheader.getStates();
            List<SelectOption> getoptions = orderheader.getoptions();
            orderheader.conid = sampleorder.ShipToContactid;
            list<orderitem> item = [select Shipped_Product__c from orderitem where orderid = :sampleorder.id];
            orderheader.currentProduct = item[0].Shipped_Product__c;
            orderheader.hidePopup();
            orderheader.duplicateProcess();
            orderheader.createorder = true;
            orderheader.initiateaddressselction(); 
            orderheader.updatedtotalordercontactlist();
            orderheader.updatetotalordercontactlist();
            orderheader.hideselectedaddress();
            orderheader.Next();
            orderheader.Previous();
            orderheader.initiateapproval();
            orderheader.removeconid = sampleorder.ShipToContactid; 
            orderheader.removecontact();
            orderheader.removeprodid=item[0].Shipped_Product__c;
            orderheader.removeproduct();
            orderheader.cancelPopup();
            list<orderitem> itemlist =  new list<orderitem>([select id from orderitem where orderid = :sampleorder.id]);
        	OrderItemTriggerHandler itemtrigger = new OrderItemTriggerHandler();
            itemtrigger.OnAfterInsert(itemlist);
            itemtrigger.OnAfterUpdate(itemlist);
            itemtrigger.OnAfterDelete(itemlist); 
            itemtrigger.OnUnDelete(itemlist);  
            map<id,orderitem> temp = new map<id,orderitem>([select id,status__c,orderid from orderitem]);
            itemtrigger.OnBeforeDelete(temp, temp) ;
            stdOrderTriggerHandler.createListMap([select id,status from order]);
            Test.stopTest();
           
       }
        
    } 
 public static testmethod void processorder2(){
         
         id pid=[select id from profile where name='ACN System Admin Read Only'].id;
         User u = new User(Alias = 'standt', Email='standarduser11@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = pid, Sample_Approval__c= true,
            TimeZoneSidKey='America/Los_Angeles', UserName='test12345'+Math.random()+'@gmail.com', Geography__c = 'Growth',Market__c = 'ZA',Line_of_Business__c = 'Higher Ed');
         	insert u; 
          	User u1 = new User(Alias = 'standt', Email='standarduser11@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = pid, Sample_Approval__c= true,Order_Approver__c= u.id,
            TimeZoneSidKey='America/Los_Angeles', UserName='test1234'+Math.random()+'@gmail.com', Geography__c = 'Growth',Market__c = 'ZA',Line_of_Business__c = 'Higher Ed');
            insert u1;
            list<PermissionSetAssignment> psa = new list<PermissionSetAssignment>();
            list<string> permissionsetnames = new list<string>{'Pearson_Sample_Order_Approver','Pearson_Network_Sampler','Pearson_Backend_Order_Creation','Pearson_Front_End_Sampling'};
            list<permissionset> pertset = [select id from permissionset where name in :permissionsetnames]; 
            for(integer i=0;i< pertset.size();i++ )
            {        psa.add(new PermissionSetAssignment(PermissionSetId = pertset[i].id, AssigneeId=u1.id));  }
            insert psa; 
    system.runas(u1) {
            order sampleorder = TestDataFactory.returnmodifiedorder(); 
            Test.starttest(); 
            list<orderitem> itemlist =  new list<orderitem>([select Shipped_Product__c from orderitem where orderid = :sampleorder.id]);
            system.debug('$$$$$$$$$$$$$$$$$$$$345'+sampleorder+itemlist);
          	PageReference testPage = new pagereference('/apex/OrderHeaderController');
            testPage.getParameters().put('oppid',sampleorder.Opportunityid);
            testPage.getParameters().put('orderid',sampleorder.id); 
            contact con = [SELECT Id, name,Preferred_Address__c,accountid,Role__c,email,Do_Not_Send_Samples__c,	mailingaddress,
            MailingCity,MailingState,MailingCountry,MailingPostalCode,MailingStreet,
            OtherStreet,OtherCity,OtherState,OtherCountry,OtherPostalCode,
            account.shippingstreet,account.shippingcity,account.shippingstate,account.shippingcountry,account.shippingpostalcode
              FROM Contact where id = :sampleorder.ShipToContactid limit 1 ];
            Test.setCurrentPage(testPage);
            OrderHeaderController orderheader = new OrderHeaderController(); 
            orderheader.fromOnclick = false;
            orderheader.ordercontactlist[0].selectedValue= 'Custom';
            orderheader.setselectedaddress1(); 
            orderheader.ordercontactlist[0].selectedValue= 'Other';
            orderheader.setselectedaddress1();
            orderheader.ordercontactlist[0].selectedValue= 'Mailing';
            orderheader.setselectedaddress1();
            orderheader.ordercontactlist[0].selectedValue= 'Account';
            orderheader.setselectedaddress1();
            List<SelectOption> getoptions = orderheader.getoptions();
            orderheader.conid = sampleorder.ShipToContactid;
            orderheader.ordercontactlisttotal[0].futureshipdate = system.today();
            orderheader.ordercontactlisttotal[0].canceldate = system.today()-1;
            orderheader.ordercontactlisttotal[0].shippinginstructions='Drop at door'; 
            orderheader.getStates();
            orderheader.duplicateProcess();
            orderheader.hidePopup();
            orderheader.cancelPopup();
            orderheader.initiateaddressselction(); 
            orderheader.updatedtotalordercontactlist();
            orderheader.ordercontactlisttotal[0].futureshipdate = system.today()+1;
            orderheader.ordercontactlisttotal[0].canceldate = system.today()-2;
             orderheader.ordercontactlisttotal[0].shippinginstructions='Drop at doorstep'; 
            orderheader.updatetotalordercontactlist();
            orderheader.hideselectedaddress();
            orderheader.Next();
            orderheader.Previous();
            orderheader.initiateapproval();
            orderheader.removeconid = sampleorder.ShipToContactid; 
            system.debug('$$$$$$'+con); 
            con.Preferred_Address__c= System.Label.ContactMailing;
            con.MailingCountry= 'India';
            con.MailingState='Kerala';
            update con;
            OrderHeaderController.Addressfields ad1 = new OrderHeaderController.Addressfields(con);
            con.Preferred_Address__c= System.Label.Contact_Other;
            update con;
            OrderHeaderController.Addressfields ad2 = new OrderHeaderController.Addressfields(con);
            con.Preferred_Address__c= System.Label.ContactMailing;
            update con;
            orderheadercontroller.Ordercontacts orc = new orderheadercontroller.Ordercontacts (con,sampleorder,sampleorder.Opportunityid);
            con.Preferred_Address__c= System.Label.Contact_Other;
            update con;
            orderheadercontroller.Ordercontacts orc1 = new orderheadercontroller.Ordercontacts (con,sampleorder,sampleorder.Opportunityid);
            orderheader.removecontact();
            list<orderitem> item =[select id,Shipped_Product__c from orderitem where orderid = :sampleorder.id ]; 
            system.debug('!!!!!!'+item);
            orderheader.removeprodid=itemlist[0].Shipped_Product__c;
            orderheader.removeproduct();
            stdOrderTriggerHandler.createListMap([select id,status from order]);
            Test.stopTest();
        }
     } 
  public static testmethod void overridebutton()
  		{
             Test.starttest(); 
             PageReference testPage = new pagereference('/apex/OrderHeader');
             testPage.getParameters().put('RecordType','AAA');
             testPage.getParameters().put('cancelURL','AAA');
             testPage.getParameters().put('ent','AAA');
             testPage.getParameters().put('_CONFIRMATIONTOKEN','AAA');
             testPage.getParameters().put('save_new_url','AAA');
             testPage.getParameters().put('aid','AAA');
             testPage.getParameters().put('cid','AAA');
             Test.setCurrentPage(testPage);
             ContentVersion conv=new ContentVersion();
             ApexPages.StandardController controller = new ApexPages.StandardController(conv);
             PS_OverideOrderNewButton overrider = new PS_OverideOrderNewButton(controller);
             overrider.OverideOrderNewButton();
              Test.stoptest();  
        }
      
	    }