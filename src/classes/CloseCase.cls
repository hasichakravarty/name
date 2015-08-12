public with sharing class CloseCase {
    
    public static void cannotCloseCase(List<Case> caseList){
        
        Map<id,Case> case_IdMap = new Map<Id,Case>();
        List<Action__c> actions = new List<Action__c> ();
        for(Case c : caseList){
            if(c.Status == 'Closed')
            	case_IdMap.put(c.id,c);
        }
        
        actions = [SELECT Case__r.id,status__c FROM Action__c
                                    WHERE case__r.id IN :case_IdMap.keySet()];
        system.debug('####################Actions :'+actions);
        
        for(Action__c act : actions){
            if(!(act.Status__c == 'Completed')){
                system.debug('#####################cant close case, NonCompleted action');
                case_IdMap.get(act.Case__r.id).addError(System.Label.ErrorMsgCloseCase);
            }
        }
    }

}