/************************************************************************************************************
* Apex Interface Name : PS_OrderValidationFactory
* Version             : 1.0 
* Created Date        : 10 Jul 2015
* Function            : Class responsible to have the logic that will be used to determine what implementation of 
*                       PS_OrderValidationInterface should be called.
* Modification Log    :
* Developer                   Date                    Description
* -----------------------------------------------------------------------------------------------------------
* Davi Borges              10/Jul/2015            Initial version
-------------------------------------------------------------------------------------------------------------
************************************************************************************************************/

public class PS_OrderValidationFactory {
	
	
	public static List<PS_OrderValidationInterface> CreateValidations(Map<String,Order> orders,Map<Id,Order> oldOrders, User contextUser )
	{

		//At this point R2 all order are North America Sampling Orders

		List<PS_OrderValidationInterface> validatons = new List<PS_OrderValidationInterface>();

		PS_OrderValidationB2BSampling validation = new PS_OrderValidationB2BSampling();

		validation.initialize(orders, oldOrders, contextUser);

		validatons.add(validation);

		return validatons;

	}


}