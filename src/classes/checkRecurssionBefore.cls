public class checkRecurssionBefore {
    
    static Set<String> executedTriggerName = new Set<String>();

    public static boolean runOnce(String triggerName, String operation){
    
	    if(executedTriggerName.contains(triggerName+operation))
	    {
	    	System.debug('Recursion detected for Before + [' + operation + '] +trigger: ' + triggerName);
	    	return false;
	    }else
	    {
	    	System.debug('First execution of Before:  + [' + operation + '] +trigger: ' + triggerName);
	    	executedTriggerName.add(triggerName+operation);
	    	return true;
	    }
  
	}

}