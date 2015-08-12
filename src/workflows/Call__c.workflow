<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Call_Set_End_Time_if_empty</fullName>
        <field>Call_End_Time__c</field>
        <formula>Call_Start_Time__c + 0.04167</formula>
        <name>Call Set End Time if empty</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Call Set End Time if empty</fullName>
        <actions>
            <name>Call_Set_End_Time_if_empty</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Set the end time 1 hour after the start time when end time is empty</description>
        <formula>OR (ISNULL( Call_End_Time__c) , ISBLANK(Call_End_Time__c) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
