/************************************************************************************************************
* Apex Interface Name : PS_OrderUpdateInterface
* Version             : 1.0 
* Created Date        : 20 Jul 2015
* Function            : interfaces that hold the logic for order updates
* Modification Log    :
* Developer                   Date                    Description
* -----------------------------------------------------------------------------------------------------------
* Leonard Victor             20/Jul/2015            Initial version
-------------------------------------------------------------------------------------------------------------
************************************************************************************************************/
public interface PS_OrderUpdateInterface 
{
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
    void initialize(List<OrderItem> orderItemsUpdated);


/*************************************************************************************************************
  * @Name        : updateOrders
  * @Description : updates the order status * 
  * @Todo        : 
  * @Output      : true if there is no error, false if there is error.
  *************************************************************************************************************/
    void updateOrders();
}