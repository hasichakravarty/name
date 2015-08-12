@isTest
public class TestscheduledCreatepbeForANZProducts{
	static testMethod void myUnitTest() {
       
      Id standardPB = Test.getStandardPricebookId();
      
      /*PriceBook2 pbSTD = new PriceBook2(Name='Standard Price Book', isActive=true);
      insert pbSTD;*/
      system.debug('standardPB :'+standardPB);
      PriceBook2 pbANZ = new PriceBook2(Name='ANZ Price Book', isActive=true, CurrencyISOCode = 'NZD');
      insert pbANZ;
      
      PriceBook2 pbUS = new PriceBook2(Name='NA Higher Ed Order Price Book', isActive=true, CurrencyISOCode = 'USD');
      insert pbUS;
      
      system.debug(' pricebook ANZ :'+ pbANZ);
      system.debug(' pricebook US:'+ pbUs);
      
      Product2 pAZ = new Product2(Name='Test Product ANZ', Market__c='AU', isActive = true);
  	  insert pAZ;
  	  
  	  Product2 pUS = new Product2(Name='Test Product US', Market__c = 'US', Line_of_Business__c = 'Higher Ed', Competitor_Product__c = false, isActive = true);
  	  insert pUs;
  	  
  	  system.debug('Product :'+ pAZ);
  	  system.debug('Product :'+ pUS);
  	  test.startTest();
  	  PricebookEntry pbeStdANZ = new PricebookEntry(CurrencyIsoCode = 'AUD', Pricebook2Id = standardPB, Product2Id = pAZ.Id, IsActive = true, UnitPrice = 10 );
  	  insert pbeStdANZ;
  	  
  	  PricebookEntry pbeStdUS = new PricebookEntry(CurrencyIsoCode = 'USD', Pricebook2Id = standardPB, Product2Id = pUS.Id, IsActive = true, UnitPrice = 20 );
  	  insert pbeStdUS;
	  
	  system.debug('PBE standard ANZ :'+pbeStdANZ);
	  system.debug('PBE standard US :'+pbeStdUS);
 		  
      scheduledCreatepbeForANZProducts sc = new scheduledCreatepbeForANZProducts();
 		
      String schedule = '0 0 23 * * ?';
 		  system.schedule('Daily Schedule' , schedule, sc);
 		  
 	  Product2 pAZ1 = new Product2(Name='Test Product ANZ', isActive = true);
  	  insert pAZ1;
  	  
  	  Product2 pUS1 = new Product2(Name='Test Product US', Market__c = 'US', Line_of_Business__c = 'Higher Ed', Competitor_Product__c = false, isActive = true);
  	  insert pUs1;
  	  
  	  PricebookEntry pbeStdANZ1 = new PricebookEntry(CurrencyIsoCode = 'NZD', Pricebook2Id = standardPB, Product2Id = pAZ1.Id, IsActive = true, UnitPrice = 10 );
  	  insert pbeStdANZ1;
  	  
  	  PricebookEntry pbeStdUS1 = new PricebookEntry(CurrencyIsoCode = 'USD', Pricebook2Id = standardPB, Product2Id = pUS1.Id, IsActive = true, UnitPrice = 20 );
  	  insert pbeStdUS1;
  	  
      string Runfrom = datetime.now().format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
 	  CreatePriceBookEntryForANZProducts pbeANZ = new CreatePriceBookEntryForANZProducts(Runfrom);
 	  id batchProcessID = database.executebatch(pbeANZ,200);
      
      test.stopTest();
	}
}