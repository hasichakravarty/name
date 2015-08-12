/*******************************************************************************************************************
* Apex Class Name   : RelationshipUtils.cls
* Version           : 1.0 
* Created Date      : 14 MARCH 2014
* Function          : Utility Class for Relationship Object
* Modification Log  :
* Developer                   Date                    Description
* ------------------------------------------------------------------------------------------------------------------
* Mitch Hunt                  14/03/2014              Created Initial Version of Utility Class
* Mitch Hunt                  20/03/2014              Fixed deleteRecords to work with Batch Deletion.
*******************************************************************************************************************/

public with sharing class RelationshipUtils
{
    // Clone Record
    // 
    // 
    public void cloneRecords(Relationship__c[] lstRelationships)
    {
        list<Relationship__c>   lstRelationshipstoInsert    = new list<Relationship__c>();
        list<Relationship__c>   lstRelationshipstoUpdate    = new list<Relationship__c>();
        map<ID,ID>              mapIDtoCloneID              = new map<ID,ID>();
        
        for(Relationship__c sRelationship : lstRelationships)
        {
            // If this is the first record being created, clone the record
            if(sRelationship.RelationshipClone__c == null)
            {
                lstRelationshipstoInsert.add(new Relationship__c
                                            (   Account__c              = sRelationship.Related_To__c, 
                                                Related_To__c           = sRelationship.Account__c,
                                                Active__c               = sRelationship.Active__c,
                                                Type__c                 = sRelationship.Type__c,
                                                Other_Type__c           = sRelationship.Other_Type__c,
                                                RelationshipClone__c    = sRelationship.Id
                                            )
                                            );
            }
            
            // If this is the clone record being created update the original record with the correct Id
            if(sRelationship.RelationshipClone__c != null)
            {
                mapIDtoCloneID.put(sRelationship.RelationshipClone__c, sRelationship.Id);
            }
        }
        
        insert lstRelationshipstoInsert;
        
        for(Relationship__c sRelationship : [SELECT Id, Influence_Type__c FROM Relationship__c WHERE Id IN : mapIDtoCloneID.keyset()])
        {
            sRelationship.RelationshipClone__c  = mapIDtoCloneID.get(sRelationship.Id);
            /*Insert Logic for clone, not requested but available
            String inverseInfluence;
            if(sRelationship.Influence_Type__c == 'Influences'){inverseInfluence = 'Influenced By';}
            else if(sRelationship.Influence_Type__c == 'Influenced By'){inverseInfluence = 'Influences';}
            else if(sRelationship.Influence_Type__c == 'Purchases For'){inverseInfluence = 'Purchases Through';}
            else if(sRelationship.Influence_Type__c == 'Purchases Through'){inverseInfluence = 'Purchases For';}*/
            lstRelationshipstoUpdate.add(sRelationship);
        }
        
        update lstRelationshipstoUpdate;
    }
    
    // Update Record
    // 
    // 
    public void updateRecords(Relationship__c[] lstOldRelationships, map<ID, Relationship__c> mapIDRelationship)
    {
        if(GlobalUtils.m_RelationshipUpdateTriggerFired == null || GlobalUtils.m_RelationshipUpdateTriggerFired == false)
        {
            GlobalUtils.m_RelationshipUpdateTriggerFired = true;
        }
        else if(GlobalUtils.m_RelationshipUpdateTriggerFired == true)
        {
            return;
        }
        
        list<Relationship__c>       lstRelationshipstoUpdate        = new list<Relationship__c>();
        
        for(Relationship__c sOldRelationship : lstOldRelationships)
        {
            Relationship__c sRelationship = mapIDRelationship.get(sOldRelationship.Id);
            String inverseInfluence;
            if(sRelationship.Influence_Type__c == 'Influences'){inverseInfluence = 'Influenced By';}
            else if(sRelationship.Influence_Type__c == 'Influenced By'){inverseInfluence = 'Influences';}
            else if(sRelationship.Influence_Type__c == 'Purchases For'){inverseInfluence = 'Purchases Through';}
            else if(sRelationship.Influence_Type__c == 'Purchases Through'){inverseInfluence = 'Purchases For';}



            lstRelationshipstoUpdate.add(new Relationship__c
                                        (   Id                      = sRelationship.RelationshipClone__c,
                                            Account__c              = sRelationship.Related_To__c, 
                                            Related_To__c           = sRelationship.Account__c,
                                            Active__c               = sRelationship.Active__c,
                                            Type__c                 = sRelationship.Type__c,
                                            Other_Type__c           = sRelationship.Other_Type__c,
                                            Influence_Type__c       = inverseInfluence
                                        )
                                        );
                                        
            system.debug('lstRelationshipstoUpdate:::' + lstRelationshipstoUpdate);
        }
        
        update lstRelationshipstoUpdate;
        
        GlobalUtils.m_RelationshipUpdateTriggerFired = false;
    }
    
    
    // Delete Records
    // 
    // 
    public void deleteRecords(Relationship__c[] lstDeletedRelationships)
    {
        if(GlobalUtils.m_RelationshipDeleteTriggerFired == null || GlobalUtils.m_RelationshipDeleteTriggerFired == false)
        {
            GlobalUtils.m_RelationshipDeleteTriggerFired = true;
        }
        else if(GlobalUtils.m_RelationshipDeleteTriggerFired == true)
        {
            return;
        }
        
        set<ID>                     setRelationshipstoDelete        = new set<ID>();
        set<ID>                     setRelationshipsSFDCtoDelete    = new set<ID>();
        list<Relationship__c>       lstRelationshipstoDelete        = new list<Relationship__c>();
        
        // Push into a set so that if we are batch deleting we do not get duplicate values
        for(Relationship__c sRelationship : lstDeletedRelationships)
        {
            setRelationshipstoDelete.add(sRelationship.RelationshipClone__c);
            setRelationshipsSFDCtoDelete.add(sRelationship.ID);
        }
        
        // Now that we have a set of all of the Relationships to delete, check if they are in the original delete list
        // that salesforce is going to perform, if they are not push all the ids into a list so that we can perform DML operation.
        for(ID sRelationshipID : setRelationshipstoDelete)
        {
            if(setRelationshipsSFDCtoDelete.contains(sRelationshipID) == false)
            {
                lstRelationshipstoDelete.add(new Relationship__c
                                            (   Id                      = sRelationshipID
                                            )
                                            );
            }
        }
        
        system.debug('lstRelationshipstoDelete:::' + lstRelationshipstoDelete);
        
        delete lstRelationshipstoDelete;
        
        GlobalUtils.m_RelationshipDeleteTriggerFired = false;
    }
    
}