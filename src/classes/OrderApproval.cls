public class OrderApproval{
    
    private static User currentUrser;
    private Map <Id,Order> newOrders;
    private Map <Id,Order> oldOrders;
    
    private List<OrderItem> orderItems;
    
    public OrderApproval(Map <Id,Order>newOrders,  Map <Id,Order> oldOrders)
    {
        this.newOrders = newOrders;
        this.oldOrders = oldOrders;
        
        orderItems = [select id,orderid,OrderItemNumber,status__C, Order.Id  from orderitem where orderid  in :newOrders.keySet() Order By OrderId , OrderItemNumber];
        system.debug('$$$$$$$$'+orderItems);
    }
    
    public User retrieveCurrentUser()
    {
        if(currentUrser !=null)
        {
            return currentUrser;
        }
        
         currentUrser = [Select id,Name,Manager.id,Sample_Approval__c,Order_Approver__r.id, Order_Approver__r.Name from user where id=:Userinfo.getuserid()];
         
         return currentUrser;       
    }
    
    private Boolean statusChangedTo(Id newOrderId, String status)
    {
        return (statusChanged(newOrderId) && newOrders.get(newOrderId).Status == status);
    }
    
    private Boolean statusChanged(Id newOrderId)
    {
        return (newOrders.get(newOrderId).Status != oldOrders.get(newOrderId).Status);
    }
    
    private Boolean statusChangedFrom(Id newOrderId,String status)
    {
        return (statusChanged(newOrderId) && oldOrders.get(newOrderId).Status == status);
    }
    
    
    public void submitOrder(){
        
        User u = retrieveCurrentUser();
        
        List <Order> orderLSt = newOrders.values();
        
        for(Order  orderObj : orderLSt)
        {
            Order oldOrder = oldOrders.get(orderObj.Id);
            
            if(statusChangedFrom(orderObj.Id, 'New'))
            {
                if(u.Sample_Approval__c)
                {
                    orderObj.status= 'Pending Approval';
                                        
                }else
                {
                     orderObj.status= 'Open';
                }
            }
                   
        }  
    }

    public void submitApprovalChatterPost()
    {
        List<FeedItem> posts = new List<FeedItem>();

        User u = retrieveCurrentUser();

        List <Order> orderLSt = newOrders.values();

        for(Order  orderObj : orderLSt)
        {
            Order oldOrder = oldOrders.get(orderObj.Id);
            
            if(statusChangedFrom(orderObj.Id, 'New'))
            {
                if(u.Sample_Approval__c)
                {
                    posts.add(chattermessage(orderObj));                                       
                }
            }      
        }

        if(posts.size() > 0)
        {
            insert posts;
        }  


    }
        
    public FeedItem chattermessage(Order orderObj)
    {
                                           
        User u = retrieveCurrentUser();
        
        String msg;
                                
        FeedItem post = new FeedItem();
        post.ParentId = u.Order_Approver__r.id; 
        String str = URL.getSalesforceBaseUrl().toExternalForm() + '/' + orderObj.id ;
        msg = 'Dear '+ u.Order_Approver__r.Name+', \n Order ' +orderObj.OrderNumber+'  has been submitted for approval by User  '+u.name + '.Please navigate to the order ('+str+'),remove any order products that are not required and set the Order Status to Open or Cancelled';
        msg += '\n \n Please contact your administrator if you have any questions.';
        msg += '\n \n Thanks,\n \n Pearson OneCRM Admin ';
        post.Body = msg;
        post.CreatedDate = System.now();
        system.Debug('Post feed---'+post);
        
        return post;
                                       
    }
    
    public void updatelorderlineitemstatus()//method used to update the Order Line Item Status
    {    
        List<OrderItem> submittedItems = new  List<OrderItem>();
       
        for(orderitem item:orderItems)
        {    
            if(statusChangedTo(item.Order.Id, 'Open'))
            {
                item.status__c = 'Entered';
                submittedItems.add(item);
                
            }   
        }
        
        if(submittedItems.size()>0) 
        {
            defineItemNumbers(submittedItems);
        } 
        
    } 
    
    private void defineItemNumbers(List<OrderItem> items)
    {   
        Id orderId=null;
        
        Integer i = 0;
        
        for(OrderItem item: items)
        {
            if(orderId ==null || orderId != item.OrderId )
            {
                orderId = item.OrderId;
                i =0;
            }
            
            item.Item_Number__c= ++i;
        }
    }
       
   
    public void saveOrderItems()
    {
        update orderItems;
    }
      
    
    
}