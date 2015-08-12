<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <outboundMessages>
        <fullName>Integration_Request</fullName>
        <apiVersion>33.0</apiVersion>
        <endpointUrl>https://integrationdev.pearson.com:8444/Adapters/SI/SFDC/Notifications/IntegrationRequest/v1</endpointUrl>
        <fields>CreatedDate</fields>
        <fields>Direction__c</fields>
        <fields>Event__c</fields>
        <fields>Geo__c</fields>
        <fields>Id</fields>
        <fields>LoB__c</fields>
        <fields>Market__c</fields>
        <fields>Name</fields>
        <fields>Object_Id__c</fields>
        <fields>Object_Name__c</fields>
        <fields>Status__c</fields>
        <fields>Sub_Event__c</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>esb@pearsoncore.com</integrationUser>
        <name>Integration Request</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>Submit Outbound Integration Request</fullName>
        <actions>
            <name>Integration_Request</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <description>Send Integration Request Outbound Message when the outbound Integration Request has been submitted</description>
        <formula>OR(AND( ISPICKVAL( Direction__c ,&apos;Outbound&apos;) , ISCHANGED(Status__c), ISPICKVAL(Status__c,&apos;Ready For Submission&apos;)), AND( ISNEW(),ISPICKVAL(Status__c,&apos;Ready For Submission&apos;)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
