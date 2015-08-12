<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Authored_Product_Edition</fullName>
        <field>Edition__c</field>
        <formula>Product__r.Edition__c</formula>
        <name>Authored Product Edition</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Authored_Product_Title</fullName>
        <description>CORE - Authored Product Title update</description>
        <field>Title__c</field>
        <formula>Product__r.Full_Title__c</formula>
        <name>Authored Product Title</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Pearson_Author_update</fullName>
        <field>Pearson_Author__c</field>
        <literalValue>1</literalValue>
        <name>Pearson Author update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Contact__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Product_uncheck</fullName>
        <field>Pearson_Author__c</field>
        <literalValue>0</literalValue>
        <name>Product uncheck</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Contact__c</targetObject>
    </fieldUpdates>
    <rules>
        <fullName>Authored Product Field Update</fullName>
        <actions>
            <name>Authored_Product_Edition</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Authored_Product_Title</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>CORE - when a product is selected the product fields on the Authored Product record will be auto filled correctly</description>
        <formula>NOT(ISBLANK(Product__c) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Pearson Author update</fullName>
        <actions>
            <name>Pearson_Author_update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>AuthoredProducts__c.Relationship__c</field>
            <operation>equals</operation>
            <value>Pearson Author</value>
        </criteriaItems>
        <description>If the Author is selected as a Pearson Author in the related list, then the Perason Author field on Contact will be checked to true.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Pearson Author update uncheck</fullName>
        <actions>
            <name>Product_uncheck</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>AuthoredProducts__c.Relationship__c</field>
            <operation>notEqual</operation>
            <value>Pearson Author</value>
        </criteriaItems>
        <description>If the Author is changed from Pearson Author in the related list, then the Pearson Author field on Contact will be unchecked.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
