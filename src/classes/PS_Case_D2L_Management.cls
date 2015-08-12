/* ----------------------------------------------------------------------------------------------------------------------------------------------------------
   Name:            PS_Case_D2L_Management
   Description:     Method used for management of D2L Cases
   Date             Version         Author                             Summary of Changes 
   -----------      ----------      -----------------    ---------------------------------------------------------------------------------------------------
  05/2015         1.0               Davi Borges                       Initial Release 
------------------------------------------------------------------------------------------------------------------------------------------------------------ */
public without sharing class PS_Case_D2L_Management {
	
	
	//method is used to assign the case account to new sponsor contacts that
	public static void assignAccountToNewSponsor(List<Case> cases)
	{
	
		//Map<Id,Id> contactAccout = new Map<Id,Id>();

		List<Contact> contacts = new List<Contact>();
		
		for(Case c: cases)
		{
			if(c.Sponsor_name__c !=null)
			{
				If(c.Sponsor_name__r.AccountId ==null) 
				{
					System.debug('PS: Contact Without AccountId');
					//contactAccout.put(c.Sponsor_name__c,c.AccountId);

					contacts.add( new Contact (id = c.Sponsor_name__c, AccountId =c.AccountId ));				
				}		
			}
		}

		if(contacts.size() >0 ) update contacts;

		/*if(!contactAccout.isEmpty())
		{
			List<Contact> contacts = [SELECT ID, AccountId FROM Contact WHERE Id =: contactAccout.keySet()];

			for(Contact co: contacts)
			{
				co.AccountId = contactAccout.get(co.Id);
			}

			update contacts;
		}*/

	}

}