public class PS_OrderUpdate implements PS_OrderUpdateInterface 
{
  private List<OrderItem> orderItemsUpdated;
  
  private Map<Id, Order> orderMap;
 
 /*************************************************************************************************************
  * @Name        : initialize
  * @Description : used to initilize the class 
  * 
  * @Todo        : 
  * @Input       : inOrderItems: list of order to be validated
                   inOldOrderItem: old version of the order 
                   userContext: user as context for the validation process    
  * @Output      : N/A
  *************************************************************************************************************/
  public void initialize(List<OrderItem> inOrderItemsUpdated)
  {
    this.orderItemsUpdated = inOrderItemsUpdated;
          
    getOrderInfo();
  }
 
  public void updateOrders()
  {    
    List <Order> ordersToUpdate = new List<Order>();
    
    if(orderMap.isEmpty())
    {
      return;
    }

    for(String ordKey : orderMap.keySet())
    {
      Order ord = orderMap.get(ordKey);  
      Integer numCancelled = 0;
      Integer numComplete = 0;
   
      for(OrderItem oi : ord.OrderItems)
      {
      	if(oi.status__c != null)
      	{
          if(!oi.status__c.equals(System.Label.Processed) &&
             !oi.status__c.equals(System.Label.Cancelled) &&
             !oi.status__c.equals(System.Label.Shipped))
          {
            // break as there are OrderItems still awaiting an update with a status which means the order item is complete;
            break;              
          }
          if(oi.status__c.equals(System.Label.Cancelled))
          {
            ++numCancelled;            
          }
          else
          {
            ++numComplete;
          }
      	}          
      }
      // if all of the order items are cancelled set the order status to cancelled
      if(numCancelled == ord.OrderItems.size())
      {
        ord.status = System.Label.Cancelled;
        ordersToUpdate.add(ord);
      }
      else if(numCancelled + numComplete == ord.OrderItems.size())
      {
        ord.status = System.Label.Filled;
        ordersToUpdate.add(ord);
      }       
    }
    
    if(ordersToUpdate != null && ordersToUpdate.size() > 0)
    {
      update ordersToUpdate;
    }  
  }  
  
  private void getOrderInfo()
  {
    if(orderMap == null)
    {
      orderMap = new Map<Id, Order>();
    }
    
    Set <Id> orderIds = new Set<Id>(); 
      
    for(OrderItem oi : orderItemsUpdated)
    {
      if(!orderIds.contains(oi.OrderId))
      {
        orderIds.add(oi.OrderId);
      }
    }  
    
    List<Order> orders = new  List<Order>();     
      
    if(!orderIds.isEmpty())
    {
      orders = [SELECT o.Status, (SELECT Status__c FROM OrderItems) FROM Order o WHERE Id IN :orderIds];
    }
      
    if(!orders.isEmpty())
    {
      orderMap.putAll(new Map<Id, Order>(orders));
    }     
  }        
}