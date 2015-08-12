<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Copy_User_ID_to_Unique_Field</fullName>
        <description>Ensures that there is only one User Forecast for any given User record, by copying the User Id from the lookup field to a text field that requires uniqueness.</description>
        <field>User_Id_Unique__c</field>
        <formula>User__c</formula>
        <name>Copy User ID to Unique Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Copy User ID to Unique Field</fullName>
        <actions>
            <name>Copy_User_ID_to_Unique_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>UserForecast__c.User__c</field>
            <operation>notContain</operation>
            <value>~</value>
        </criteriaItems>
        <description>Ensures that there is only one User Forecast for any given User record, by copying the User Id from the lookup field to a text field that requires uniqueness.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
