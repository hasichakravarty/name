<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Course_Catalog_Code_Name</fullName>
        <field>Name</field>
        <formula>Catalog_Code__c + &quot; &quot;+ &quot;-&quot; + &quot; &quot; + Course_Name__c</formula>
        <name>Course/Catalog Code Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Course_Name_Update</fullName>
        <description>update Course Name to Catalog Code - Course Name</description>
        <field>Name</field>
        <formula>Catalog_Code__c &amp; &apos; - &apos;&amp;  Course_Name__c</formula>
        <name>Course Name Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Course%2FCatalog Name</fullName>
        <actions>
            <name>Course_Catalog_Code_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Updates the Course/Catalog Name to a Concatentation of Course Name and Catalog Code</description>
        <formula>AND(       RecordType.Name = &quot;Course Record Type&quot;,      OR(          ISNEW(),          ISCHANGED( Catalog_Code__c),          ISCHANGED( Course_Name__c )        ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Course Details</fullName>
        <actions>
            <name>Course_Name_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>NOT( ISBLANK( Id ) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
