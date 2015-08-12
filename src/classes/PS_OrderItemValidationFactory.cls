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

public class PS_OrderItemValidationFactory {
  
  
  public static List<PS_OrderItemValidationInterface> CreateValidations(Map<String,OrderItem> orderItems,Map<Id,OrderItem> oldOrderItems, User contextUser )
  {

    //At this point R2 all order are North America Sampling Orders

    List<PS_OrderItemValidationInterface> validatons = new List<PS_OrderItemValidationInterface>();

    PS_OrderItemValidationB2BSampling validation = new PS_OrderItemValidationB2BSampling();

    validation.initialize(orderItems, oldOrderItems, contextUser);

    validatons.add(validation);

    return validatons;

  }


}