<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Move_Prior_Status</fullName>
        <field>Status__c</field>
        <literalValue>Special Pricing Coordinator</literalValue>
        <name>Move Prior Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Move_to_Additional_Approver</fullName>
        <field>Status__c</field>
        <literalValue>Additional Departments Review</literalValue>
        <name>Move to Additional Approver</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Recalled_Status</fullName>
        <description>Update status field to &quot;recalled&quot; when the approval is recalled</description>
        <field>Status__c</field>
        <literalValue>Recalled</literalValue>
        <name>Recalled Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Assigned_to_Special</fullName>
        <field>Status__c</field>
        <literalValue>Assigned to special pricing team</literalValue>
        <name>Status- Assigned to Special</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_GM_review</fullName>
        <description>Status changed to General Manager review</description>
        <field>Status__c</field>
        <literalValue>General Manager Review</literalValue>
        <name>Status- GM review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Rejected</fullName>
        <description>The status of request turns to &apos;Rejected&apos;</description>
        <field>Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Status Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_approved</fullName>
        <description>Status updated to approved</description>
        <field>Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Status- approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_change_GM_approved</fullName>
        <field>Status__c</field>
        <literalValue>GM approved/ validating data</literalValue>
        <name>Status change- GM approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_change_GM_review</fullName>
        <description>The status of approval request moves to General Manager Review</description>
        <field>Status__c</field>
        <literalValue>General Manager Review</literalValue>
        <name>Status change- GM review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_change_Special_pricing</fullName>
        <field>Status__c</field>
        <literalValue>Special Pricing Coordinator</literalValue>
        <name>Status change- Special pricing</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_change_Under_review</fullName>
        <field>Status__c</field>
        <literalValue>Under review</literalValue>
        <name>Status change- Under review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_completed</fullName>
        <field>Status__c</field>
        <literalValue>Completed</literalValue>
        <name>Status- completed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_under_review</fullName>
        <description>Status change to under review</description>
        <field>Status__c</field>
        <literalValue>Under review</literalValue>
        <name>Status- under review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Owner_to_Special_Pricing_Coord</fullName>
        <field>OwnerId</field>
        <lookupValue>Special_Pricing_Team</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Update Owner to Special Pricing Coord</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
</Workflow>
