<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Concatenate_semester_and_type_fields</fullName>
        <description>Concatenate semester and type product fields</description>
        <field>Apttus_Semester_Type__c</field>
        <formula>TEXT(Semester__c)&amp;BR()&amp; 
&quot;Type: &quot;&amp;TEXT(Module_Type__c)&amp;BR()</formula>
        <name>Concatenate semester and type fields</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Concatenate Semester and Type</fullName>
        <actions>
            <name>Concatenate_semester_and_type_fields</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>if(AND(len(Text(Semester__c))=0,len(Text(Module_Type__c))=0),false,true)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
