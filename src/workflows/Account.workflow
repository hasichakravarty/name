<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Bookmaster_New_Account_Request</fullName>
        <ccEmails>dcsbuild@deloitte.com.au</ccEmails>
        <ccEmails>twillmot@deloitte.com.au</ccEmails>
        <ccEmails>sennever@deloitte.com.au</ccEmails>
        <description>Bookmaster New Account Request</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>Internal_Notifications/Bookmaster_Account_Creation_Request</template>
    </alerts>
    <fieldUpdates>
        <fullName>AccountBookstoreRecordType</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Bookstore</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>AccountBookstoreRecordType</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AccountCorporateRecordType</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Corporate</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>AccountCorporateRecordType</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AccountHEDRecordType</fullName>
        <field>RecordTypeId</field>
        <lookupValue>HigherEducation</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>AccountHEDRecordType</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AccountSchoolRecordType</fullName>
        <field>RecordTypeId</field>
        <lookupValue>School</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>AccountSchoolRecordType</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Account_Market_Field_Update</fullName>
        <description>Update Market field - used globally</description>
        <field>Market__c</field>
        <formula>TEXT(CreatedBy.Market__c)</formula>
        <name>Account - Market Field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Account_Owner_Update</fullName>
        <field>OwnerId</field>
        <lookupValue>testdm@pearson112.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Account Owner Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Accountrecordtype</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Organisation</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Accountrecordtype</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateAccountCheckbox</fullName>
        <field>Account_Name_is_Read_only__c</field>
        <literalValue>1</literalValue>
        <name>UpdateAccountCheckbox</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_AccountOwner</fullName>
        <field>OwnerId</field>
        <lookupValue>testdm@pearson112.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Update Account Owner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Account_Name</fullName>
        <field>Name</field>
        <formula>UPPER(Name)</formula>
        <name>Update Account Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>update_Account_owner</fullName>
        <field>OwnerId</field>
        <lookupValue>testdm@pearson112.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>update Account owner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Account - Market Field Update</fullName>
        <actions>
            <name>Account_Market_Field_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update hidden Market field based on account creator. 
Market field use used in sharing settings</description>
        <formula>ISNEW()</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Account Bookmaster request</fullName>
        <actions>
            <name>Bookmaster_New_Account_Request</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>CORE - an email to the bookmaster team to create a new Account in Bookmaster</description>
        <formula>AND(PRIORVALUE(Create_Bookmaster_Account__c) ==FALSE,Create_Bookmaster_Account__c==TRUE)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Account Name in UPPERCASE</fullName>
        <actions>
            <name>Update_Account_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>Organisation,Learner</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>AccountBookstoreRecordType</fullName>
        <actions>
            <name>AccountBookstoreRecordType</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(ISBLANK(PRIORVALUE(External_Account_Number__c)),NOT(ISBLANK(External_Account_Number__c)), ISPICKVAL(Type,&apos;Bookstore&apos;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>AccountCorporateRecordType</fullName>
        <actions>
            <name>AccountCorporateRecordType</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(ISBLANK(PRIORVALUE(External_Account_Number__c)),NOT(ISBLANK(External_Account_Number__c)), ISPICKVAL(Type,&apos;Corporate&apos;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>AccountHEDRecordType</fullName>
        <actions>
            <name>AccountHEDRecordType</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(ISBLANK(PRIORVALUE(External_Account_Number__c)),NOT(ISBLANK(External_Account_Number__c)), ISPICKVAL(Type,&apos;Higher Education&apos;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>AccountSchoolRecordType</fullName>
        <actions>
            <name>AccountSchoolRecordType</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(ISBLANK(PRIORVALUE(External_Account_Number__c)),NOT(ISBLANK(External_Account_Number__c)), ISPICKVAL(Type,&apos;School&apos;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Create Account with organisation record type</fullName>
        <actions>
            <name>Accountrecordtype</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>update_Account_owner</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>and((Request_Account_Creation__c =true),($Setup.Bypass_Settings__c.Disable_Workflow_Rules__c==false))&amp;&amp; (($RecordType.Name==&apos;Organisation&apos;))</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Only 1 Primary Selling Account per Account</fullName>
        <active>false</active>
        <description>This workflow will ensure that there can only be one &apos;Primary Selling Acount&apos; per Account Hierarchy</description>
        <formula>IF( Parent.Primary_Selling_Account_check__c == true, true , false)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Account Owner</fullName>
        <actions>
            <name>Update_AccountOwner</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>update the Account Owner to Pearson Owner</description>
        <formula>AND(  NOT(Owner.Username==&apos;Pearson&apos;),OR( (RecordTypeId ==&apos;012110000004s&apos; ),(RecordTypeId ==&apos;012110000004sL4&apos;)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Account Owner to Pearson</fullName>
        <actions>
            <name>Account_Owner_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.OwnerId</field>
            <operation>notEqual</operation>
            <value>Pearson -</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Organisation,Learner</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>notEqual</operation>
            <value>System Administrator</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>notEqual</operation>
            <value>Pearson Data Administrator</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>UpdateAccountCheckbox</fullName>
        <actions>
            <name>UpdateAccountCheckbox</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>To update account checkbox(account name is read only) after update of contact record so as to make an account object  uneditable via UserInterface directly</description>
        <formula>AND(NOT($Setup.Bypass_Settings__c.Disable_Workflow_Rules__c), NOT(Account_Name_is_Read_only__c),   (RecordType.Name =&apos;Learner&apos;||RecordType.Name =&apos;Organisation&apos;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
