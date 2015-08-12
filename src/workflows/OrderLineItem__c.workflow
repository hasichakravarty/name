<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>CopyProductActive</fullName>
        <field>Is_Active_Product__c</field>
        <literalValue>1</literalValue>
        <name>CopyProductActive</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CopyProductInactive</fullName>
        <field>Is_Active_Product__c</field>
        <literalValue>0</literalValue>
        <name>CopyProductInactive</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Queue_approver_line</fullName>
        <description>Queue approver approves line item</description>
        <field>Status__c</field>
        <formula>&quot;Order in Progres&quot;</formula>
        <name>Queue approver line</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Queue_approver_reje</fullName>
        <description>Queue approver rejects the line item</description>
        <field>Status__c</field>
        <formula>&quot;Rejected&quot;</formula>
        <name>Queue approver reje</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>approval</fullName>
        <field>Status__c</field>
        <formula>&quot;Needs Product Approval&quot;</formula>
        <name>approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Copy Product Active</fullName>
        <actions>
            <name>CopyProductActive</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(NOT(ISNULL(Product__c)), Product__r.IsActive == true)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Copy Product InActive</fullName>
        <actions>
            <name>CopyProductInactive</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISBLANK(Product__c)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
