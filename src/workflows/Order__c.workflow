<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Approval_Status_Update</fullName>
        <field>Status__c</field>
        <literalValue>Need Approval</literalValue>
        <name>Approval Status Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Order_Approved_Record_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Approved_Order</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Order Approved Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Order_Post_Approval</fullName>
        <field>Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Order Post Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <outboundMessages>
        <fullName>Send_Order_ID_to_ESB</fullName>
        <apiVersion>30.0</apiVersion>
        <endpointUrl>https://integrationdev.pearson.com:8444/Adapters/Sales/OrderCapture/SFDC/Orders/OrderNotification/2.0.0</endpointUrl>
        <fields>Id</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>esb@pearsoncore.com</integrationUser>
        <name>Send Order ID to ESB</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>Order Approved Record Type</fullName>
        <actions>
            <name>Order_Approved_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Order__c.Status__c</field>
            <operation>equals</operation>
            <value>Approved</value>
        </criteriaItems>
        <description>When the order status changes from New to Approved, the record type should change to Approved Order in order to make all fields read only for the end user</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Send Order to ESB</fullName>
        <actions>
            <name>Send_Order_ID_to_ESB</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <description>Send Order to ESB</description>
        <formula>AND ( ISPICKVAL(Status__c, &apos;Approved&apos;), LineItemCount__c &gt; 0)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
