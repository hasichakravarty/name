global class RetrieveOneCRM 
{
  @ReadOnly
  webservice static RetrieveOrderResult RetrieveOrderById(String OrderId)
  {
    //Davi Borges: Don't change it to objectId, it will afect the ESB data mapping
    String objectId  = OrderId;
    
    /*
     * This is the entity that is returned as response. ErrorCode = 0 is an indication of a successful response. 
     * If with the Id provide is not possible to find a record, the service will return ErrorCode =1 and ErrorMessage
     * that “It was not possible to find an opportunity with the associated Id:[<Id provided>”
     */
    System.debug('Provided OrderId =[' + objectId +']');
    RetrieveOrderResult result = null;
    if(String.isBlank(objectId))
    {
      result = new RetrieveOrderResult();
      String errorMessage = 'The parameter objectId was empty';
      System.debug(errorMessage);
      result.errorCode = 1;
      result.errorMessage = errorMessage;
      throw new RetreiveOneCRMException(result.errorCode + '|' + errorMessage);
    }
     
    Id objId = objectId;
    String objectAPIName = objId.getSObjectType().getDescribe().getName();
    System.debug('The object type for the id is ' + objectAPIName);
       
    if(objectAPIName.equals('Opportunity'))
    {
      // r1
      result = RetrieveOneCRMHandler.handleSARetrieveRequest(objectId);
    } 
    else if(objectAPIName.equals('Order'))
    {
      // r2
      result = RetrieveOneCRMHandler.handleUSRetrieveRequest(objectId);     
    }
    
    return result;
  }    

  @ReadOnly
  webservice static RetrieveOrderResult RetrieveOrderByOrderLineItemId(String OrderLineItemId)
  {
    if(String.isBlank(orderLineItemId))
    {
      RetrieveOrderResult result = new RetrieveOrderResult();
      String errorMessage = 'The parameter orderLineItemId was empty';
      System.debug(errorMessage);
      result.errorCode = 1;
      result.errorMessage = errorMessage;
      throw new RetreiveOneCRMException(result.errorCode + '|' + errorMessage);
    }
    
    List<OrderItem> ordItem = null;
    try
    {
      ordItem = [SELECT OrderId FROM OrderItem WHERE Id = :orderLineItemId];
      if(ordItem ==null || ordItem.size() ==0) 
      {
        throw new RetreiveOneCRMException('Order Line Item is invalid');
      } 
    }
    catch(Exception ex) 
    {            
      throw new RetreiveOneCRMException('1', ex);
    }

    return RetrieveOneCRMHandler.RetrieveOrderInfoByIds(ordItem[0].OrderId, orderLineItemId);
  }
  
  @ReadOnly
  webservice static RetrieveAccountResult RetrieveAccountByCaseId(String caseId)
  {
    if(String.isBlank(caseId))
    {
      RetrieveOrderResult result = new RetrieveOrderResult();
      String errorMessage = 'The parameter caseId was empty';
      System.debug(errorMessage);
      result.errorCode = 1;
      result.errorMessage = errorMessage;
      throw new RetreiveOneCRMException(result.errorCode + '|' + errorMessage);
    }
    return RetrieveOneCRMHandler.handleRetrieveAccountByCaseId(caseId);
  }

  @ReadOnly
  webservice static RetrieveCaseResult RetrieveCaseById(String caseId)
  {
    if(String.isBlank(caseId))
    {
      RetrieveOrderResult result = new RetrieveOrderResult();
      String errorMessage = 'The parameter caseId was empty';
      System.debug(errorMessage);
      result.errorCode = 1;
      result.errorMessage = errorMessage;
      throw new RetreiveOneCRMException(result.errorCode + '|' + errorMessage);
    }
    return RetrieveOneCRMHandler.handleRetrieveCaseById(caseId);   
  }
 
  global class RetrieveCaseResult
  {
    webService INT_Case serviceRequest;
    webService Integer errorCode;
    webService String errorMessage;
  }

  global class RetrieveAccountResult
  {
    webService INT_Account account;
    webService Integer errorCode;
    webService String errorMessage;
  }

  global class RetrieveOrderResult
  {
    webService INT_Order order;
    webService Integer errorCode;
    webService String errorMessage;
  }

  public class RetreiveOneCRMException extends Exception 
  {
  }
}