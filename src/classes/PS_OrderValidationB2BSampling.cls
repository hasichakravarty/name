/************************************************************************************************************
    * Apex Interface Name : PS_OrderValidationB2BSampling
    * Version             : 1.0 
    * Created Date        : 10 Jul 2015
    * Function            : Implementation of PS_OrderValidationInterface for B2B Sampling Orders
    * Modification Log    :
    * Developer                   Date                    Description
    * -----------------------------------------------------------------------------------------------------------
    * Davi Borges              10/Jul/2015            Initial version
    -------------------------------------------------------------------------------------------------------------
    ************************************************************************************************************/

    public class PS_OrderValidationB2BSampling implements PS_OrderValidationInterface {

     private Map<String,Order> inOrders;
     private Map<Id, Order> oldOrders;
     private User contextUser;

      /*************************************************************************************************************
      * @Name        : initialize
      * @Description : used to initiliaze the class
      * 
      * @Todo        : 
      * @Input       : inOrders: list of order to be validated
                       inOldOrders: old version of the order 
                       contextUser: user as context for the validation process    
      * @Output      : N/A
      *************************************************************************************************************/
        public void initialize(Map<String,Order> inOrders, Map<Id, Order> oldOrders, User contextUser)
        {
            this.inOrders = inOrders;
            this.oldOrders = oldOrders;
            this.contextUser = contextUser;
        }

      /*************************************************************************************************************
      * @Name        : validateInsert
      * @Description : determines if the order can be inserted
      * 
      * @Todo        : 
      * @Input       : exceptions: instance of map that will receive the exeption. The error should not be added 
                       to the order to allow this interface to be used outside the tigger context.
      * @Output      : true if there is no error, false if there is error.
      *************************************************************************************************************/
        public Boolean validateInsert(Map<String,List<String>> exceptions)
        {
            
          return true;

        }


      /*************************************************************************************************************
      * @Name        : validateUpdate
      * @Description : determines if the order can be updated
      * 
      * @Todo        : 
      * @Input       : exceptions: instance of map that will receive the exeption. The error should not be added 
                       to the order to allow this interface to be used outside the tigger context.
      * @Output      : true if there is no error, false if there is error.
      *************************************************************************************************************/
     
        public Boolean validateUpdate(Map<String,List<String>> exceptions)
        {
            
            //filter order with status 

            Map<String,Order> inOrdersToProces = new Map<String,Order>();

            for(String ordKey : inOrders.keySet())
            {
                Order ord = inOrders.get(ordKey);

                if(!((ord.status == 'New' && oldOrders.get(ord.Id).status == 'New') || 
                    (ord.status != 'New' && oldOrders.get(ord.Id).status == 'New')))
                {
                    inOrdersToProces.put(ordKey,ord);
                }
            }

            if(inOrdersToProces.isEmpty()){
            
                return true;

            }


            Boolean userHasPermission = (PS_Util.hasUserPermissionSet(contextUser.Id, 'Pearson Sample Order Approver') || 
                                            PS_Util.hasUserPermissionSet(contextUser.Id, 'Pearson Backend Order Creation'));
        
            System.debug('User Bypass:' + userHasPermission);

            //validation for other user that don't have te permission
            for(String ordKey : inOrdersToProces.keySet()){
                
                List<String> errors = validateUpdateSingleOrder(inOrders.get(ordKey), oldOrders.get(inOrders.get(ordKey).Id), userHasPermission);

                if(! errors.isEmpty()){

                    exceptions.put(ordKey,errors);
                }
            }


            return exceptions.isEmpty();
        }


        private List<String> validateUpdateSingleOrder(Order updatedOrder, Order oldOrder, Boolean userBypass)
        {
            List<String> errors =  new List<String>();

            if(updatedOrder.status =='New' && oldOrder.status !='New')
            {
                errors.add(Label.PS_Order_Status_New);
            }

            if(userBypass)
            {
                return errors;
            }
            

            if(updatedOrder.AccountId != oldOrder.AccountId)
            {
                errors.add(Label.PS_Order_Account);
                
            }

            if(updatedOrder.Status != oldOrder.Status)
            {
                errors.add(Label.PS_Order_Status);
            }

            if(updatedOrder.EffectiveDate != oldOrder.EffectiveDate)
            {
                errors.add(Label.PS_Order_EffectiveDate);
            }

            if(updatedOrder.Opportunityid != oldOrder.Opportunityid)
            {
                errors.add(Label.PS_Order_Opportunity);
            }

            if(updatedOrder.Type != oldOrder.Type)
            {
                errors.add(Label.PS_Order_Type);
            }
          
            if((updatedOrder.ShippingCountryCode != oldOrder.ShippingCountryCode)||(updatedOrder.ShippingStreet != oldOrder.ShippingStreet)||(updatedOrder.ShippingCity != oldOrder.ShippingCity)||(updatedOrder.ShippingStateCode != oldOrder.ShippingStateCode)||(updatedOrder.ShippingPostalCode != oldOrder.ShippingPostalCode))
            {
                errors.add(Label.PS_Order_Address);
            }
            
            if(updatedOrder.Order_Notes__c  != oldOrder.Order_Notes__c )
            {
                errors.add(Label.PS_Order_Notes);
            }
            
            if(updatedOrder.Shipping_Instructions__c   != oldOrder.Shipping_Instructions__c  )
            {
                errors.add(Label.PS_Order_ShippingInst);
            }
            
            

            return errors;
        }

        
      /*************************************************************************************************************
      * @Name        : validateDelete
      * @Description : determines if the order can be deleted
      * 
      * @Todo        : 
      * @Input       : exceptions: instance of map that will receive the exeption. The error should not be added 
                       to the order to allow this interface to be used outside the tigger context.
      * @Output      : true if there is no error, false if there is error.
      *************************************************************************************************************/
      
        public Boolean validateDelete(Map<String,List<String>> exceptions)
        {
            return true;
        }

    }