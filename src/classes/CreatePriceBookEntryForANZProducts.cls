/*=======================================================================================+
|  HISTORY                                                                               |
|                                                                                        |
|  DATE            DEVELOPER        DESCRIPTION                                          |
|  ====            =========        ===========                                          |
|  06/03/2015      Alper Oztovi     This Batch Class is used to create Pricebook entries |
|                                   for new products added to Product2 table.            |
|                                   Pricebook entries are only added to products         |
|                                   where market__c = null or market__c == 'AU'          |
|                                   These products are added to ANZ specific custom      |
|                                   pricebook with standard price.                       |
+=======================================================================================*/
/* to run this bach from a specific date.
string Runfrom = Datetime.newInstance(2015,05, 29).format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
CreatePriceBookEntryForANZProducts pbeANZ = new CreatePriceBookEntryForANZProducts(Runfrom);
database.executebatch(pbeANZ);
*/

global class CreatePriceBookEntryForANZProducts implements Database.Batchable<sobject>, Database.Stateful{
    
    public string pricebookQuery; 
    public string pricebookEntryQuery; 
    static string targetPricebookId;
    public AsyncApexJob BatchPrevRun;
    Public string BatchCompletedDate;
    Static Id standardPriceBook;
    Public string Runfromdate;

    list<Product2> productList = new List<Product2>();
    
    list<PricebookEntry> EntryList = new List<PricebookEntry>();
    
    Map<String,Id> MapPriceBookId = new Map<String,Id>();

    global CreatePriceBookEntryForANZProducts(string Runfrom){ 
         
       // get pricebook Name and id into a Map
       list<Pricebook2> pricebookList = database.query('select Id, Name from pricebook2');
        for(Pricebook2 eachpricebook:pricebookList){
            MapPriceBookId.put(eachpricebook.Name, eachpricebook.Id);
        }
        
        if(Test.isRunningtest() && MapPriceBookId.get('Standard Price Book') == null){
            system.debug('std book :'+Test.getStandardPricebookId());
            MapPriceBookId.put('Standard Price Book',Test.getStandardPricebookId());
        }
        
        if(MapPriceBookId.get('Standard Price Book') != null){
            standardPriceBook = MapPriceBookId.get('Standard Price Book');
        }
        
        system.debug('standardPriceBook  :'+standardPriceBook );
       // set the batch start time and Batch Previous Run 
       if(Runfrom != null && Runfrom !=''){
            Runfromdate = Runfrom;
            system.debug('Run from date provided :'+ Runfromdate);
       }else{
           try{
            BatchPrevRun = [SELECT Id, ApexClass.Name, CompletedDate, CreatedDate 
                            FROM AsyncApexJob 
                            WHERE ApexClass.Name = 'CreatePriceBookEntryForANZProducts' AND Status = 'Completed' AND JobType = 'BatchApex'
                            ORDER BY CreatedDate DESC Limit 1];
        }catch (System.QueryException e) {
            System.debug('No Record of Previous Batch Run');
            // in this case run for all
         }
       }
        
       
        //Query used to retrieve the Pricebook Id for ANZ Price Book
        
        
        //Query for of standard price book to identify recently created entries
        if(Runfromdate != null && Runfromdate != ''){
            pricebookEntryQuery = 'select id, product2id, product2.market__c, product2.Line_of_Business__c, product2.Competitor_Product__c, pricebook2.name, unitprice, CurrencyISOCode from pricebookentry '+
                                          'where pricebook2Id = \''+ standardPriceBook +'\' '+
                                          'AND (product2.market__c = \'AU\' or product2.market__c = null or product2.market__c = \'US\') '+
                                          'AND (CurrencyISOCode = \'NZD\' or CurrencyISOCode = \'AUD\' or CurrencyISOCode = \'USD\') '+
                                          'AND createddate >= '+ Runfromdate +' AND product2.Competitor_Product__c = false';
        }else  if(BatchPrevRun != null){
                BatchCompletedDate = BatchPrevRun.CompletedDate.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
                system.debug(' batch last completion date :'+BatchCompletedDate);
    
                    pricebookEntryQuery = 'select id, product2id, product2.market__c, product2.Line_of_Business__c, product2.Competitor_Product__c, pricebook2.name, unitprice, CurrencyISOCode from pricebookentry '+
                                              'where pricebook2Id =\''+ standardPriceBook +'\' '+
                                              'AND (product2.market__c = \'AU\' or product2.market__c = null or product2.market__c = \'US\') '+
                                              'AND (CurrencyISOCode = \'NZD\' or CurrencyISOCode = \'AUD\' or CurrencyISOCode = \'USD\') '+
                                              'AND createddate >= '+ BatchCompletedDate+' AND product2.Competitor_Product__c = false';
            }else{
                // check for all Price book Entries.
                pricebookEntryQuery = 'select id, product2id, product2.market__c, product2.Line_of_Business__c, product2.Competitor_Product__c, pricebook2.name, unitprice, CurrencyISOCode from pricebookentry '+
                                          'where pricebook2Id = \''+ standardPriceBook +'\' '+
                                          'AND (product2.market__c = \'AU\' or product2.market__c = null or product2.market__c = \'US\') '+
                                          'AND (CurrencyISOCode = \'NZD\' or CurrencyISOCode = \'AUD\' or CurrencyISOCode = \'USD\') AND product2.Competitor_Product__c = false';
            }
        
        system.debug('pricebookEntryQuery :'+pricebookEntryQuery);
        
    }
        // Start Method
    global Database.QueryLocator start(Database.BatchableContext BC){

        return Database.getQueryLocator(pricebookEntryQuery);
    }
      
      // Execute Logic
    global void execute(Database.BatchableContext BC, List<sobject>scope){
        // Logic to be Executed batch wise
        system.debug('scope size :'+ scope.size());

        List<PricebookEntry> pricebookEntries = (List<PricebookEntry>)scope;

        Set<String> existingProductsKeysforANZpricebook = getListExistingProducts(pricebookEntries, 'ANZ Price Book');
        
        set<String> existingroductsKeysforNAHEOrderPricebook = getListExistingProducts(pricebookEntries, 'NA Higher Ed Order Price Book');

         System.debug('pricebookEntries-->Length:' + existingProductsKeysforANZpricebook.size());

        list<PricebookEntry> pbe = new List<PricebookEntry>();
        
        if(scope.size()>0 ){
            
            for(integer i=0; i<scope.size(); i++)
            {
                
                System.debug('pricebookEntries-->product:' + pricebookEntries[i].Product2id + ' target!');

                if( (pricebookEntries[i].product2.market__c == 'AU' || pricebookEntries[i].product2.market__c == null) && 
                     (pricebookEntries[i].CurrencyISOCode == 'NZD' || pricebookEntries[i].CurrencyISOCode == 'AUD') && 
                     MapPriceBookId.get('ANZ Price Book') != null &&
                     ! containPriceBookEntryKey(pricebookEntries[i], existingProductsKeysforANZpricebook))
                {
                    System.debug('ANZ pricebookEntries-->product:' + pricebookEntries[i].Product2id + ' will be inserted!');
                    
                    PricebookEntry NewPbe = new PricebookEntry();
                    newPbe.isactive = true;
                    NewPbe.pricebook2id = MapPriceBookId.get('ANZ Price Book');
                    NewPbe.product2id = pricebookEntries[i].Product2id ;         
                    NewPbe.UseStandardPrice = true;
                    NewPbe.UnitPrice = pricebookEntries[i].UnitPrice ;
                    NewPbe.CurrencyISOCode = pricebookEntries[i].CurrencyISOCode;
                    pbe.add(newPbe);
                    
                }else if(pricebookEntries[i].product2.market__c == 'US' &&
                         pricebookEntries[i].product2.Line_of_Business__c == 'Higher Ed' &&
                         !pricebookEntries[i].product2.Competitor_Product__c &&
                         pricebookEntries[i].CurrencyISOCode == 'USD' &&
                          MapPriceBookId.get('NA Higher Ed Order Price Book') != null &&
                         !containPriceBookEntryKey(pricebookEntries[i],existingroductsKeysforNAHEOrderPricebook)){
                             
                            System.debug('NAHEOrder pricebookEntries-->product:' + pricebookEntries[i].Product2id + ' will be inserted!');
                    
                            PricebookEntry NewPbe = new PricebookEntry();
                            newPbe.isactive = true;
                            NewPbe.pricebook2id =  MapPriceBookId.get('NA Higher Ed Order Price Book');
                            NewPbe.product2id = pricebookEntries[i].Product2id ;         
                            NewPbe.UseStandardPrice = true;
                            NewPbe.UnitPrice = pricebookEntries[i].UnitPrice ;
                            NewPbe.CurrencyISOCode = pricebookEntries[i].CurrencyISOCode;
                            pbe.add(newPbe);
                         }
                
            }
            
            if(pbe.size() > 0)
            {
                insert pbe;
            }
        }   
     
    }
     
    global void finish(Database.BatchableContext BC){
    try{
            
     
      DateTime n = datetime.now().addHours(12);
      String cron = '';
      cron += n.second();
      cron += ' ' + n.minute();
      cron += ' ' + n.hour();
      cron += ' ' + n.day();
      cron += ' ' + n.month();
      cron += ' ' + '?';
      cron += ' ' + n.year();
      String jobName = 'Batch Job To Create Price Book Entry for ANZ and Higher Ed - ' + n.format('MM-dd-yyyy-hh:mm:ss');
      scheduledCreatepbeForANZProducts nextBatch = new scheduledCreatepbeForANZProducts();
      Id scheduledJobID = System.schedule(jobName,cron,nextBatch);
    }catch(exception e){
        system.debug('Exception scheduling');
    }
    }

    static Set<Id> getListProductId(List<PricebookEntry> input)
    {
        Set<Id> output = new  Set<Id>();

        for (PricebookEntry pricebookEntry : input)
        {
            output.add(pricebookEntry.product2id);
        }

        return output;

    }

    static Set<String> getListExistingProducts(List<PricebookEntry> input, String priceBookName)
    {
        Set<String> output = new  Set<String>();
        List<Pricebookentry> pricebookList;
        if(priceBookName == 'ANZ Price Book'){
             pricebookList = [SELECT product2id, product2.market__c, pricebook2.name, unitprice, 
                              CurrencyISOCode FROM pricebookentry WHERE pricebook2.name =: priceBookName
                              AND (CurrencyISOCode = 'NZD' or CurrencyISOCode = 'AUD') 
                              AND Product2Id IN:getListProductId(input)];
        }else if(priceBookName == 'NA Higher Ed Order Price Book'){
            pricebookList = [SELECT product2id, product2.market__c, pricebook2.name, unitprice, 
                              CurrencyISOCode FROM pricebookentry WHERE pricebook2.name =: priceBookName
                              AND (CurrencyISOCode = 'USD') 
                              AND Product2Id IN:getListProductId(input)];
        }
        

        for (PricebookEntry pricebookEntry : pricebookList)
        {
            output.add(getPriceBookEntryKey(pricebookEntry));
        }

        return output;

    }

    static Boolean containPriceBookEntryKey(PricebookEntry input, Set<String> target)
    {

        return target.contains(getPriceBookEntryKey(input));

    }

    static String getPriceBookEntryKey(PricebookEntry input)
    {
        return  input.Product2id + '-' + input.CurrencyISOCode;
    } 


    
   /* static Id getPriceBookId(String priceBookName)
    {
        
        if(targetPricebookId != null) 
        {
            return targetPricebookId;
        }
          
        list<Pricebook2> pricebookList = database.query('select id from pricebook2 where name = \'' + priceBookName +'\' limit 1');
        
        if(pricebookList.size() >0)
        {
            targetPricebookId = pricebookList.get(0).Id;
           
        }

        return targetPricebookId;
      
    }*/

}