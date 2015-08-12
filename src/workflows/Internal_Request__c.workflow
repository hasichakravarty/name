<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>After_Approval_Notification_sent_to_Territory_Admin</fullName>
        <description>After Approval Notification sent to Territory Admin</description>
        <protected>false</protected>
        <recipients>
            <recipient>NA_Sales_Admins</recipient>
            <type>role</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Territory_Internal_Requests_Approval_Notification_Template</template>
    </alerts>
    <alerts>
        <fullName>Business_Office_Approval</fullName>
        <description>Business Office Approval</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Commission_Manual_Adjustment_Approval_Dispisition2</template>
    </alerts>
    <alerts>
        <fullName>Business_Office_Rejection</fullName>
        <description>Business Office Rejection</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Commission_Manual_Adjustment_Approval_Dispisition2</template>
    </alerts>
    <alerts>
        <fullName>Manager_Approved</fullName>
        <description>Manager Approved</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Commission_Manual_Adjustment_Approval_Dispisition2</template>
    </alerts>
    <alerts>
        <fullName>Manager_Rejection</fullName>
        <description>Manager Rejection</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Commission_Manual_Adjustment_Approval_Dispisition2</template>
    </alerts>
    <fieldUpdates>
        <fullName>Advance_Approval_Status</fullName>
        <description>Advances the approval status from &quot;In Review&quot; to &quot;RM-Approved&quot;</description>
        <field>Status__c</field>
        <literalValue>RM - Approved</literalValue>
        <name>Advance Approval Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Closed_with_Approval</fullName>
        <description>Closes record when approved</description>
        <field>Status__c</field>
        <literalValue>Close - Approved</literalValue>
        <name>Closed with Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Closed_with_Rejection</fullName>
        <description>Closes the record upon Business Office rejection</description>
        <field>Status__c</field>
        <literalValue>Close - Declined</literalValue>
        <name>Closed with Rejection</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Complete_Subject_Line_Finance_Workflow</fullName>
        <field>Subject__c</field>
        <formula>Account_Name__r.Name  &amp; &quot;-&quot; &amp; TEXT ( Adjustment_Type__c )&amp; &quot;-&quot; &amp;   Sales_Person_Name__r.LastName</formula>
        <name>Complete Subject Line Finance Workflow</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Date_Time_Closed</fullName>
        <description>Updates the Date/Time Closed field on Finance Workflow records any time the status = Close - Approved, or Close - Declined</description>
        <field>Date_Time_Closed__c</field>
        <name>Date/Time Closed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Final_Approval_Status</fullName>
        <description>Advances the approval status from &quot;In Review&quot; to &quot;Closed - GM Approved&quot;</description>
        <field>Status__c</field>
        <literalValue>GM - Approved</literalValue>
        <name>Final Approval Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Owner_Role</fullName>
        <field>Owner_Role__c</field>
        <formula>Owner:User.UserRole.Name</formula>
        <name>Owner Role</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Owner_Update</fullName>
        <description>Updates the Owner field to the Sales Rep associated to the record</description>
        <field>Sales_Person_Name__c</field>
        <name>Owner Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Rejection_Approval_Status</fullName>
        <description>Advances the approval status from &quot;In Review&quot; to &quot;Closed - Rejected&quot;</description>
        <field>Status__c</field>
        <literalValue>Close - Declined</literalValue>
        <name>Rejection Approval Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Rejection_Approval_Status2</fullName>
        <description>Advances the approval status from &quot;RM - Approved&quot; to &quot;Closed - Declined&quot;</description>
        <field>Status__c</field>
        <literalValue>Close - Declined</literalValue>
        <name>Rejection Approval Status2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Update</fullName>
        <description>Updates the status to Rejected</description>
        <field>Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Status Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_back_to_New</fullName>
        <field>Status__c</field>
        <literalValue>New</literalValue>
        <name>Status back to New</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_to_GM_Approval</fullName>
        <description>Status update to &apos;Awaiting General Manager Approval&apos;</description>
        <field>Status__c</field>
        <literalValue>Awaiting General Manager Approval</literalValue>
        <name>Status to GM Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_to_Submission_for_Appeal</fullName>
        <field>Status__c</field>
        <literalValue>Submitted for Appeal</literalValue>
        <name>Status to Submission for Appeal</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_to_manager</fullName>
        <description>move the status field to Manager Approval</description>
        <field>Status__c</field>
        <literalValue>Awaiting Mgmt Approval</literalValue>
        <name>Status to manager</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Submission_Status</fullName>
        <description>This sets a territory realignment case submitted for approval&apos;s status to &quot;In Review&quot;</description>
        <field>Status__c</field>
        <literalValue>In Review</literalValue>
        <name>Submission Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Owner_Role</fullName>
        <field>Submitter_Territory_Text__c</field>
        <formula>Owner:User.UserRole.Name</formula>
        <name>Update Owner Role</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>move_to_Business_Office</fullName>
        <description>updates the status field to show &apos;Business Office&apos; stage</description>
        <field>Status__c</field>
        <literalValue>Awaiting Business Office Approval</literalValue>
        <name>move to Business Office</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Date%2FTime Closed</fullName>
        <actions>
            <name>Date_Time_Closed</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Internal_Request__c.Status__c</field>
            <operation>equals</operation>
            <value>Close - Approved,Close - Declined</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Finance Workflow Subject Create 2</fullName>
        <actions>
            <name>Complete_Subject_Line_Finance_Workflow</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Internal_Request__c.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Internal_Request__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Finance Workflow</value>
        </criteriaItems>
        <description>Concatenates subject line upon creation (save) of a Finance adjustment request</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Owner Role</fullName>
        <actions>
            <name>Owner_Role</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Internal_Request__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Finance Workflow</value>
        </criteriaItems>
        <description>Updates the Owner Role field with the user&apos;s role</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Rejected</fullName>
        <actions>
            <name>Status_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Internal_Request__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Finance Workflow</value>
        </criteriaItems>
        <criteriaItems>
            <field>Internal_Request__c.Rejected__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Internal_Request__c.Status__c</field>
            <operation>equals</operation>
            <value>New</value>
        </criteriaItems>
        <description>The RM and GM can review the reps request and indicate Rejected instead of submitting.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Submitter%27s Territory Update</fullName>
        <actions>
            <name>Update_Owner_Role</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Internal_Request__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Finance Workflow</value>
        </criteriaItems>
        <description>Updates the Submitter&apos;s territory field with their territory</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Owner</fullName>
        <active>false</active>
        <booleanFilter>1</booleanFilter>
        <criteriaItems>
            <field>Internal_Request__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Finance Workflow</value>
        </criteriaItems>
        <description>Updates the Owner field with the Sales Rep User name</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
