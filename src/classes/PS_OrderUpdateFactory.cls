/************************************************************************************************************
* Apex Interface Name : PS_OrderUpdateFactory
* Version             : 1.0 
* Created Date        : 20 Jul 2015
* Function            : Implementation of PS_OrderUpdateInterface for Orders
* Modification Log    :
* Developer                   Date                    Description
* -----------------------------------------------------------------------------------------------------------
* Accenture                   20/Jul/2015            Initial version
-------------------------------------------------------------------------------------------------------------
************************************************************************************************************/
public with sharing class PS_OrderUpdateFactory 
{
  public static List<PS_OrderUpdateInterface> createOrderUpdates(List<OrderItem> orderItemsUpdated)
  {
    List<PS_OrderUpdateInterface> updates = new List<PS_OrderUpdateInterface>();

    PS_OrderUpdateInterface u = new PS_OrderUpdate(); 

    u.initialize(orderItemsUpdated);

    updates.add(u);

    return updates;
  }
}