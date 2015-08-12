/************************************************************************************************************
* Apex Interface Name : PS_OrderItemValidationInterface
* Version             : 1.0 
* Created Date        : 13 Jul 2015
* Function            : interfaces that hold the logic for validate basic order Item operation
* Modification Log    :
* Developer                   Date                    Description
* -----------------------------------------------------------------------------------------------------------
* Leonard Victor             13/Jul/2015            Initial version
-------------------------------------------------------------------------------------------------------------
************************************************************************************************************/


public interface PS_OrderItemValidationInterface {

  
/*************************************************************************************************************
  * @Name        : initialize
  * @Description : used to initiliaze the class
  * 
  * @Todo        : 
  * @Input       : inOrderItems: list of order to be validated
                   inOldOrderItem: old version of the order 
                   userContext: user as context for the validation process    
  * @Output      : N/A
  *************************************************************************************************************/
    void initialize(Map<String,OrderItem> inOrderItems, Map<Id, OrderItem> inOldOrderItem,User userContext);


/*************************************************************************************************************
  * @Name        : validateInsert
  * @Description : determines if the order can be inserted
  * 
  * @Todo        : 
  * @Input       : exceptions: instance of map that will receive the exeption. The error should not be added 
                   to the order item to allow this interface to be used outside the tigger context.
  * @Output      : true if there is no error, false if there is error.
  *************************************************************************************************************/
    Boolean validateInsert(Map<String,List<String>> exceptions);


 /*************************************************************************************************************
  * @Name        : validateUpdate
  * @Description : determines if the order can be updated
  * 
  * @Todo        : 
  * @Input       : exceptions: instance of map that will receive the exeption. The error should not be added 
                   to the order item to allow this interface to be used outside the tigger context.
  * @Output      : true if there is no error, false if there is error.
  *************************************************************************************************************/
 
  Boolean validateUpdate(Map<String,List<String>> exceptions);

  
 /*************************************************************************************************************
  * @Name        : validateDelete
  * @Description : determines if the order can be deleted
  * 
  * @Todo        : 
  * @Input       : exceptions: instance of map that will receive the exeption. The error should not be added 
                   to the order item to allow this interface to be used outside the tigger context.
  * @Output      : true if there is no error, false if there is error.
  *************************************************************************************************************/
  
  Boolean validateDelete(Map<String,List<String>> exceptions);
}