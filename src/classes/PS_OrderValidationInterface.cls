/************************************************************************************************************
* Apex Interface Name : PS_OrderValidationInterface
* Version             : 1.0 
* Created Date        : 10 Jul 2015
* Function            : interfaces that hold the logic for validate basic order operation
* Modification Log    :
* Developer                   Date                    Description
* -----------------------------------------------------------------------------------------------------------
* Davi Borges              10/Jul/2015            Initial version
-------------------------------------------------------------------------------------------------------------
************************************************************************************************************/


public interface PS_OrderValidationInterface {

	
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
    void initialize(Map<String,Order> inOrders, Map<Id, Order> inOldOrders,User userContext);


/*************************************************************************************************************
  * @Name        : validateInsert
  * @Description : determines if the order can be inserted
  * 
  * @Todo        : 
  * @Input       : exceptions: instance of map that will receive the exeption. The error should not be added 
  				   to the order to allow this interface to be used outside the tigger context.
  * @Output      : true if there is no error, false if there is error.
  *************************************************************************************************************/
    Boolean validateInsert(Map<String,List<String>> exceptions);


 /*************************************************************************************************************
  * @Name        : validateUpdate
  * @Description : determines if the order can be updated
  * 
  * @Todo        : 
  * @Input       : exceptions: instance of map that will receive the exeption. The error should not be added 
  				   to the order to allow this interface to be used outside the tigger context.
  * @Output      : true if there is no error, false if there is error.
  *************************************************************************************************************/
 
	Boolean validateUpdate(Map<String,List<String>> exceptions);

	
 /*************************************************************************************************************
  * @Name        : validateDelete
  * @Description : determines if the order can be deleted
  * 
  * @Todo        : 
  * @Input       : exceptions: instance of map that will receive the exeption. The error should not be added 
  				   to the order to allow this interface to be used outside the tigger context.
  * @Output      : true if there is no error, false if there is error.
  *************************************************************************************************************/
  
	Boolean validateDelete(Map<String,List<String>> exceptions);
}