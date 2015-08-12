<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Delete_Mailing_Address</fullName>
        <field>MailingCountry</field>
        <name>Delete Mailing Address</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PS_Reset_SkipDeDupe</fullName>
        <field>skipdedupe__c</field>
        <literalValue>0</literalValue>
        <name>PS Reset SkipDeDupe</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UncheckIsleadConvertedContact</fullName>
        <description>To uncheck the isleadConvertedContact on contact update</description>
        <field>isleadConvertedContact__c</field>
        <literalValue>0</literalValue>
        <name>UncheckIsleadConvertedContact</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Contact_Owner</fullName>
        <description>On creation, the Contact Owner field will be overwritten to &apos;Pearson&apos; user.</description>
        <field>OwnerId</field>
        <lookupValue>srinivasarao.kolisetty@pearson.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Update Contact Owner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Delete address</fullName>
        <actions>
            <name>Delete_Mailing_Address</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISBLANK(Text(Preferred_Address__c))</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Overwrite Contact Owner</fullName>
        <actions>
            <name>Update_Contact_Owner</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>On creation, the Contact Owner field will be overwritten to &apos;Pearson&apos; user.</description>
        <formula>and(( Owner.FirstName!=&apos;Pearson&apos;|| Owner.LastName !=&apos;Pearson&apos;),( ( $Setup.Bypass_Settings__c.Disable_Workflow_Rules__c =false&amp;&amp; $RecordType.Name!=$Label.ANZ_Record_Type)))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>PS External Contact Interaction Actions</fullName>
        <actions>
            <name>PS_Reset_SkipDeDupe</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.skipdedupe__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>This rule execute actions related to external system manipulation of contacts</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>UncheckIsleadConvertedContact</fullName>
        <actions>
            <name>UncheckIsleadConvertedContact</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>To uncheck the isleadConvertedContact field after contact update</description>
        <formula>AND(isleadConvertedContact__c == true,OR(  ISCHANGED( Role__c),ISCHANGED( Role_Detail__c  )))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>UpdateAccountThroughContact</fullName>
        <active>false</active>
        <formula>OR( ISCHANGED( FirstName ) , ISCHANGED(LastName))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
