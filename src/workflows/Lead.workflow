<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Lead_Assignment_Notification</fullName>
        <description>Lead Assignment Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Internal_Notifications/Lead_Assignment_Notification</template>
    </alerts>
    <alerts>
        <fullName>Lead_Owner_is_re_assigned</fullName>
        <description>Lead Owner is re-assigned</description>
        <protected>false</protected>
        <recipients>
            <recipient>deploymentuser@pearsoncore.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CTIMGI_Email_Templates/Change_owner_Email_Template_for_Lead</template>
    </alerts>
    <fieldUpdates>
        <fullName>D2L_Record_Type</fullName>
        <description>Updates the record type of the record to D2L</description>
        <field>RecordTypeId</field>
        <lookupValue>D2L</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>D2L Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Owner_to_CTIMG_Student_Support_Services</fullName>
        <field>OwnerId</field>
        <lookupValue>Student_Support_Services</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Owner to CTIMG Student Support Services</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Cancelled_Interview_Field</fullName>
        <field>Cancelled_Interviews__c</field>
        <formula>0</formula>
        <name>Update Cancelled Interviews Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Company_Name</fullName>
        <field>Company</field>
        <formula>FirstName + &quot; &quot; + LastName</formula>
        <name>Update Company Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Date_for_In_Progress_Status</fullName>
        <field>Lead_changed_InProgress__c</field>
        <formula>Today()</formula>
        <name>Update Date for In Progress Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Date_for_Lead_Qualified_status</fullName>
        <field>Lead_changed_Qualified__c</field>
        <formula>Today()</formula>
        <name>Update Date for Lead Qualified status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Date_for_Lead_unqualified_status</fullName>
        <field>Lead_changed_Unqualified__c</field>
        <formula>Today()</formula>
        <name>Update Date for Lead unqualified status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Date_for_Open_status</fullName>
        <field>Lead_changed_Open__c</field>
        <formula>Today()</formula>
        <name>Update Date for Open status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Date_of_Ownership_Change</fullName>
        <field>Date_of_ownership_change__c</field>
        <formula>Today()</formula>
        <name>Update Date of Ownership Change</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_company_Name_in_lead</fullName>
        <description>populate company name with first name + last name.
///RD-00272.</description>
        <field>Company</field>
        <formula>FirstName +&quot; &quot;+LastName</formula>
        <name>Update company Name in lead</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_company_Names</fullName>
        <description>populate company name with first name + last name.
///RD-00272.</description>
        <field>Company</field>
        <formula>FirstName +&quot; &quot;+LastName</formula>
        <name>Update company Name in lead</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_the_Last_Name_Account_field</fullName>
        <description>Update the Last Name - Account field.</description>
        <field>Last_Name_Account__c</field>
        <formula>LastName</formula>
        <name>Update the Last Name - Account field.</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Default value 0 for cancelled Interview Field when a Lead record is created</fullName>
        <actions>
            <name>Update_Cancelled_Interview_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This will set the default value of the Cancelled Interview field to 0 upon Lead creation</description>
        <formula>AND(ISNEW(),  NOT($Setup.Bypass_Settings__c.Disable_Workflow_Rules__c),  $RecordType.Name =&apos;D2L&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Lead Assignment Notification</fullName>
        <actions>
            <name>Lead_Assignment_Notification</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>if a lead has been assigned or reassigned to a representative send an email notification</description>
        <formula>AND(LEFT(CreatedById,3) == &apos;005&apos; ,CreatedById != OwnerId)&amp;&amp; NOT( $Setup.Bypass_Settings__c.Disable_Workflow_Rules__c &amp;&amp; $RecordType.Name!=$Label.ANZ_Record_Type )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Ownership Change</fullName>
        <actions>
            <name>Update_Date_of_Ownership_Change</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(OwnerId)&amp;&amp; NOT( $Setup.Bypass_Settings__c.Disable_Workflow_Rules__c &amp;&amp; $RecordType.Name!=$Label.ANZ_Record_Type )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Record Type and Company Name Update for D2L</fullName>
        <actions>
            <name>D2L_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Owner_to_CTIMG_Student_Support_Services</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Company_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Changes the record type to D2L, Company Name to First Name + Last Name. It also assigns the owner to CTIMGI Student Support Services Leads Queue.</description>
        <formula>AND( ISPICKVAL(Engagement_Type__c,&apos;D2L&apos;),  ISPICKVAL(Market__c,&apos;ZA&apos;), ISPICKVAL(LeadSource ,&apos;Online/Web&apos;))  &amp;&amp;  NOT($Setup.Bypass_Settings__c.Disable_Workflow_Rules__c)  &amp;&amp; $RecordType.Name!=$Label.ANZ_Record_Type</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update Contact School Field</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Lead.OwnerId</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Date that the Lead changed to %27In progress%27 status field to today%27s date when the status is %27In progress%27</fullName>
        <actions>
            <name>Update_Date_for_In_Progress_Status</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND($RecordType.Name =&apos;D2L&apos;,ISPICKVAL(Status,&apos;In Progress&apos;),NOT(ISPICKVAL(PRIORVALUE(Status),&apos;In Progress&apos;)), ISCHANGED(Status)) &amp;&amp; NOT( $Setup.Bypass_Settings__c.Disable_Workflow_Rules__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Date that the Lead changed to %27Open%27 status field to today%27s date when the Lead status is Open</fullName>
        <actions>
            <name>Update_Date_for_Open_status</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>OR(AND(ISNEW(),ISPICKVAL(Status,&apos;Open&apos;),$RecordType.Name =&apos;D2L&apos;),AND($RecordType.Name = &apos;D2L&apos;,ISPICKVAL(Status,&apos;Open&apos;),NOT(ISPICKVAL(PRIORVALUE(Status),&apos;Open&apos;)), ISCHANGED(Status)))&amp;&amp; NOT( $Setup.Bypass_Settings__c.Disable_Workflow_Rules__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Date that the Lead changed to %27Qualified%27 status field to today%27s date when the status is %27Qualified%27</fullName>
        <actions>
            <name>Update_Date_for_Lead_Qualified_status</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(ISPICKVAL(Status,&apos;Qualified&apos;),NOT(ISPICKVAL(PRIORVALUE(Status),&apos;Qualified&apos;)), ISCHANGED(Status)) &amp;&amp; NOT( $Setup.Bypass_Settings__c.Disable_Workflow_Rules__c &amp;&amp; $RecordType.Name!=$Label.ANZ_Record_Type )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Date that the Lead changed to %27Unqualified%27 status field to today%27s date when the status is %27UnQualified%27</fullName>
        <actions>
            <name>Update_Date_for_Lead_unqualified_status</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND($RecordType.Name = &apos;D2L&apos; ,ISPICKVAL(Status,&apos;Unqualified&apos;),NOT(ISPICKVAL(PRIORVALUE(Status),&apos;Unqualified&apos;)), ISCHANGED(Status)) &amp;&amp; NOT( $Setup.Bypass_Settings__c.Disable_Workflow_Rules__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update company Name</fullName>
        <actions>
            <name>Update_company_Name_in_lead</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_company_Names</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>company Name = first Name + Last Name</description>
        <formula>AND($RecordType.Name =&apos;D2L&apos;, NOT(ISBLANK(FirstName)), NOT(ISBLANK(LastName)),   NOT( $Setup.Bypass_Settings__c.Disable_Workflow_Rules__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update the Last Name Field</fullName>
        <actions>
            <name>Update_the_Last_Name_Account_field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Workflow to take the last name on the Lead and automatically update the Last Name-Account field on the lead, which is mapped to the Learner Account on Lead Conversion.</description>
        <formula>AND  (  OR( ISNEW() ,ISCHANGED(LastName)),  NOT($Setup.Bypass_Settings__c.Disable_Workflow_Rules__c),  $RecordType.Name = &apos;D2L&apos;  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>assignment check box</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
            <value>D2L</value>
        </criteriaItems>
        <description>Useing work flow to uncheck assignment rules after creating lead</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
