public class OpptyUtils {
    
    static Map<String,Id> recordTypeIds =null;
    
    public static List<Opportunity> getOpportunitybypassRecordType(String recordType,List<Opportunity> triggeredOpportunitys){
        
        List<Opportunity> opptyList = new List<opportunity>();
        Schema.DescribeSObjectResult describeSobjectResult = Schema.SObjectType.Opportunity; 
        Map<Id,Schema.RecordTypeInfo> recordTypeMap = describeSobjectResult.getRecordTypeInfosById();
        
        if(triggeredOpportunitys != null)
            for(Opportunity a : triggeredOpportunitys){
                if(a.RecordTypeId!=null){
                    system.debug('##############recordTypeMap.get(a.RecordTypeId).getName() : '+recordTypeMap.get(a.RecordTypeId).getName());
                    if(!recordType.contains(recordTypeMap.get(a.RecordTypeId).getName()))
                       { opptyList .add(a);}
                }
            } 
        
        return opptyList ;
    }
    
     public static List<Opportunity> getOpportunityByRecordType(String recordType,List<Opportunity> triggeredOpportunitys){
     	
     		List<Opportunity> output = new List<Opportunity>();
     		
     		for(Opportunity o : triggeredOpportunitys)
     		{
     			if(o.RecordTypeId == getRecordTypeId(recordType))
     			{
     				output.add(o);
     			}
     		}
     		  		
     		return output;
     	
     }
     

    public static Id getRecordTypeId(String recordTypeName)
    {
        if(recordTypeIds == null)
        {
            recordTypeIds = new Map<String,Id>();       
        }
        
        if(!recordTypeIds.containsKey(recordTypeName))
        {
	          recordTypeIds.put(recordTypeName, Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId()) ; 
        }
            
        return recordTypeIds.get(recordTypeName);     
    }
    
    
    public static List<Opportunity> getLeadConvertedOpp(List<Opportunity> input)
    {
    		List<Opportunity> output = new List<Opportunity>();
    		
    		for(Opportunity o : input)
    		{
    			if(o.isConvertedFromLead__c) 
    			{
    				output.add(o);
    			}
    		}
    		
    		return output;
    }
    
    public static List<Opportunity> getLeadNonConvertedOpp(List<Opportunity> input)
    {
    		List<Opportunity> output = new List<Opportunity>();
    		
    		for(Opportunity o : input)
    		{
    			if(!o.isConvertedFromLead__c) output.add(o);
    		}
    		
    		return output;
    }
    
}