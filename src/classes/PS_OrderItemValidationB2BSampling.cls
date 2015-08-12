/************************************************************************************************************
* Apex Interface Name : PS_OrderItemValidationB2BSampling
* Version             : 1.0 
* Created Date        : 13 Jul 2015
* Function            : interfaces that hold the logic for validate basic order Item operation
* Modification Log    :
* Developer                   Date                    Description
* -----------------------------------------------------------------------------------------------------------
* Leonard Victor             13/Jul/2015            Initial version
-------------------------------------------------------------------------------------------------------------
************************************************************************************************************/

public class PS_OrderItemValidationB2BSampling implements PS_OrderItemValidationInterface{

 private Map<String,OrderItem> inOrderItems;
 private Map<Id, OrderItem> oldOrderItems;
 private User contextUser;
 
 public static Map<Id, Order> orderMap;

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
    public void initialize(Map<String,OrderItem> inOrderItem, Map<Id, OrderItem> oldOrderItem, User contextUser)
    {
      this.inOrderItems = inOrderItem;
      this.oldOrderItems = oldOrderItem;
      this.contextUser = contextUser;
      
      getOrderInfo(this.inOrderItems.values());
    }

/*************************************************************************************************************
  * @Name        : validateInsert
  * @Description : determines if the order can be inserted
  * 
  * @Todo        : 
  * @Input       : exceptions: instance of map that will receive the exeption. The error should not be added 
                   to the order item to allow this interface to be used outside the tigger context.
  * @Output      : true if there is no error, false if there is error.
  *************************************************************************************************************/
    public Boolean validateInsert(Map<String,List<String>> exceptions)
    {

        
      Map<String,OrderItem> inOrderItemsToProces = new Map<String,OrderItem>();
      
      

      for(String ordItemKey : inOrderItems.keySet()){
          
        OrderItem ord = inOrderItems.get(ordItemKey);
        inOrderItemsToProces.put(ordItemKey,ord);
      }

      if(inOrderItemsToProces.isEmpty()){
    
        return true;

      }

      Boolean userHasPermission = (PS_Util.hasUserPermissionSet(contextUser.Id, 'Pearson Sample Order Approver') || 
                    PS_Util.hasUserPermissionSet(contextUser.Id, 'Pearson Backend Order Creation'));
  
      System.debug('User Bypass:' + userHasPermission);

      //validation for other user that don't have te permission
      for(String ordKey : inOrderItemsToProces.keySet()){
          
        Order itemOrder = orderMap.get(inOrderItemsToProces.get(ordKey).OrderId);  
          
        if(!userHasPermission && itemOrder.Status != 'New' && ! itemOrder.isTemporary__c){
                    inOrderItemsToProces.get(ordKey).unitPrice.adderror(Label.PS_Order_Item_Create);
        }
      }
       
      return exceptions.isEmpty();
    }


 /*************************************************************************************************************
  * @Name        : validateUpdate
  * @Description : determines if the order can be updated
  * 
  * @Todo        : 
  * @Input       : exceptions: instance of map that will receive the exeption. The error should not be added 
                   to the order item to allow this interface to be used outside the tigger context.
  * @Output      : true if there is no error, false if there is error.
  *************************************************************************************************************/
 
  public Boolean validateUpdate(Map<String,List<String>> exceptions)
  {
    
    //filter order with status 

    Map<String,OrderItem> inOrderItemsToProces = new Map<String,OrderItem>();

   for(String ordItemKey : inOrderItems.keySet())
    {
      OrderItem ord = inOrderItems.get(ordItemKey);

      
        inOrderItemsToProces.put(ordItemKey,ord);
    }

    if(inOrderItemsToProces.isEmpty()){
    
      return true;

    }


    Boolean userHasPermission = (PS_Util.hasUserPermissionSet(contextUser.Id, 'Pearson Sample Order Approver') || 
                    PS_Util.hasUserPermissionSet(contextUser.Id, 'Pearson Backend Order Creation'));
  
    System.debug('User Bypass:' + userHasPermission);

    //validation for other user that don't have te permission
    for(String ordKey : inOrderItemsToProces.keySet()){
        
        
      Order itemOrder = orderMap.get(inOrderItemsToProces.get(ordKey).OrderId);  
      
      List<String> errors = validateUpdateSingleOrder(inOrderItems.get(ordKey), oldOrderItems.get(inOrderItems.get(ordKey).Id), itemOrder, userHasPermission);

      if(! errors.isEmpty()){

        exceptions.put(ordKey,errors);
      }
    }


    return exceptions.isEmpty();
  }


  private List<String> validateUpdateSingleOrder(OrderItem updatedOrderItem, OrderItem oldOrderItem, Order itemOrder, Boolean userBypass)
  {
    
    List<String> errors =  new List<String>();


    if(userBypass || itemOrder.Status == 'New' || itemOrder.isTemporary__c)
    {
      return errors;
    }
    

    if(updatedOrderItem.Quantity != oldOrderItem.Quantity)
    {
      errors.add(Label.PS_OrderItem_Quantity);
      
    }

     if(updatedOrderItem.UnitPrice != oldOrderItem.UnitPrice)
    {
      errors.add(Label.PS_OrderItem_UnitPrice);
      
    }

    if(updatedOrderItem.Status__c != oldOrderItem.Status__c)
    {
      errors.add(Label.PS_OrderItem_Status);
    }

    if(updatedOrderItem.StatusReason__c != oldOrderItem.StatusReason__c)
    {
      errors.add(Label.PS_OrderItem_StatusReason);
    }
    
      if(updatedOrderItem.Shipping_Method__c != oldOrderItem.Shipping_Method__c)
    {
      errors.add(Label.PS_OrderItem_Shipping);
    }
    
    
    

    
    if(!userBypass && errors.isEmpty() && updatedOrderItem.id==null){
        errors.add(Label.PS_Order_Item_Create);

    }

    return errors;
  }

  
 /*************************************************************************************************************
  * @Name        : validateDelete
  * @Description : determines if the order can be deleted
  * 
  * @Todo        : 
  * @Input       : exceptions: instance of map that will receive the exeption. The error should not be added 
                   to the order item to allow this interface to be used outside the tigger context.
  * @Output      : true if there is no error, false if there is error.
  *************************************************************************************************************/
  
  public Boolean validateDelete(Map<String,List<String>> exceptions)
  {
     Map<String,OrderItem> inOrderItemsToProces = new Map<String,OrderItem>();

   for(String ordItemKey : oldOrderItems.keySet())
    {
      OrderItem ord = oldOrderItems.get(ordItemKey);

      
        inOrderItemsToProces.put(ordItemKey,ord);
    }

    if(inOrderItemsToProces.isEmpty()){
    
      return true;

    }


    Boolean userHasPermission = (PS_Util.hasUserPermissionSet(contextUser.Id, 'Pearson Sample Order Approver') || 
                    PS_Util.hasUserPermissionSet(contextUser.Id, 'Pearson Backend Order Creation'));
  
    System.debug('User Bypass:' + userHasPermission);

    //validation for other user that don't have te permission
    for(String ordKey : oldOrderItems.keySet()){
      
      List<String> errors = new List<String>();
      
      Order itemOrder = orderMap.get(inOrderItemsToProces.get(ordKey).OrderId);  
      
      if(! userHasPermission && ! itemOrder.isTemporary__c)
      {
          errors.add(Label.PS_OrderItem_Delete);
      }

      if(! errors.isEmpty()){

        exceptions.put(ordKey,errors);
      }
    }


    return exceptions.isEmpty();
  }
  
  private void getOrderInfo(List<OrderItem> items)
  {
      if(orderMap == null)
      {
          orderMap = new Map<Id, Order>();
      }
      
      Set<Id> orderIdsToQuery = new Set<Id>();
      
      for(OrderItem item : items)
      {
          if( ! orderMap.containsKey(Item.OrderId))
          {
             orderIdsToQuery.add(Item.OrderId);
          }
      }
      
      List<Order> orders = new  List<Order>();
      
      if( ! orderIdsToQuery.isEmpty())
      {
           orders = [SELECT Id, Status, isTemporary__c FROM Order WHERE Id in :orderIdsToQuery];
      }
      
      if( ! orders.isEmpty())
      {
          
          orderMap.putAll(new Map<Id, Order>(orders));
      }
      
  }
  
  

}