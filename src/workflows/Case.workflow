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
        <fullName>Email_to_sponser</fullName>
        <description>Email to sponser</description>
        <protected>false</protected>
        <recipients>
            <field>Account_Financially_Responsible_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CTIMGI_Email_Templates/Mail_to_Sponser</template>
    </alerts>
    <alerts>
        <fullName>Finance_Approval</fullName>
        <description>Finance Approval</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Commission_Manual_Adjustment_Approval_Dispisition</template>
    </alerts>
    <alerts>
        <fullName>Finance_Rejection</fullName>
        <description>Finance Rejection</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Commission_Manual_Adjustment_Approval_Dispisition</template>
    </alerts>
    <alerts>
        <fullName>MailtoStudentSponsor_Request_to_Cancel_the_Enrollment</fullName>
        <description>Mail to StudentSponsor_Request_to_Cancel_the_Enrollment</description>
        <protected>false</protected>
        <recipients>
            <field>Account_Financially_Responsible_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CTIMGI_Email_Templates/Case_Student_Change_Campus_notification_SAMPLE</template>
    </alerts>
    <alerts>
        <fullName>MailtoStudent_Request_to_Cancel_the_Enrollment</fullName>
        <description>MailtoStudent_Request_to_Cancel_the_Enrollment</description>
        <protected>false</protected>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CTIMGI_Email_Templates/Case_Student_Change_Campus_notification_SAMPLE</template>
    </alerts>
    <alerts>
        <fullName>Manager_Approved</fullName>
        <description>Manager Approved</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Commission_Manual_Adjustment_Approval_Dispisition</template>
    </alerts>
    <alerts>
        <fullName>Manager_rejection</fullName>
        <description>Manager rejection</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Commission_Manual_Adjustment_Approval_Dispisition</template>
    </alerts>
    <alerts>
        <fullName>Request_Approval_Mail</fullName>
        <description>A mail will be sent to the student once the campus change request has been approved</description>
        <protected>false</protected>
        <recipients>
            <field>Account_Primary_Contact_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <recipient>abhinav.f.srivastava@accenture.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Change_Request</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_to_Sponser</fullName>
        <description>Send Email to Sponser</description>
        <protected>false</protected>
        <recipients>
            <field>Account_Financially_Responsible_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>CTIMGI_Email_Templates/Mail_to_Sponser</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_to_Sponsor</fullName>
        <description>Send Email to Sponsor</description>
        <protected>false</protected>
        <recipients>
            <field>Account_Financially_Responsible_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CTIMGI_Email_Templates/Mail_to_Sponsor</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_to_Sponsor_Cancellation_Request_Confirmation</fullName>
        <description>Send Email to Sponsor - Cancellation Request Confirmation</description>
        <protected>false</protected>
        <recipients>
            <field>Account_Financially_Responsible_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CTIMGI_Email_Templates/Mail_to_Sponsor_Cancellation_Confirmation</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_to_Sponsor_Cancellation_Request_Notification</fullName>
        <description>Send Email to Sponsor - Cancellation Request Notification</description>
        <protected>false</protected>
        <recipients>
            <field>Account_Financially_Responsible_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CTIMGI_Email_Templates/Mail_to_Sponsor_Cancellation_Request</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_to_Student_Sponser</fullName>
        <description>Send Email to Student</description>
        <protected>false</protected>
        <recipients>
            <field>Account_Primary_Contact_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CTIMGI_Email_Templates/Mail_to_Student</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_to_Student_Sponsor</fullName>
        <description>Send Email to Student</description>
        <protected>false</protected>
        <recipients>
            <field>Account_Primary_Contact_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CTIMGI_Email_Templates/Mail_to_Student</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_to_Student_Sponsor_Cancellation_Request_Confirmation</fullName>
        <description>Send Email to Student - Cancellation Request Confirmation</description>
        <protected>false</protected>
        <recipients>
            <field>Account_Primary_Contact_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CTIMGI_Email_Templates/Mail_to_Student_Cancellation_Confirmation</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_to_Student_Sponsor_Cancellation_Request_Notification</fullName>
        <description>Send Email to Student - Cancellation Request Notification</description>
        <protected>false</protected>
        <recipients>
            <field>Account_Primary_Contact_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CTIMGI_Email_Templates/Mail_to_Student_Cancellation_Request</template>
    </alerts>
    <alerts>
        <fullName>Student_Request_to_Cancel_the_Enrollment_1</fullName>
        <description>Student Request to Cancel the Enrollment</description>
        <protected>false</protected>
        <recipients>
            <field>Account_Financially_Responsible_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CTIMGI_Email_Templates/Case_Student_Change_Campus_notification_SAMPLE</template>
    </alerts>
    <alerts>
        <fullName>Student_approval_notification</fullName>
        <description>An email will be sent to the student once the campus change request has been approved</description>
        <protected>false</protected>
        <recipients>
            <field>Account_Primary_Contact_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CTIMGI_Email_Templates/Change_Campus_Approval_mail</template>
    </alerts>
    <fieldUpdates>
        <fullName>Advance_Approval_Status</fullName>
        <description>Advances the approval status from &quot;In Review&quot; to &quot;RM-Approved&quot;</description>
        <field>Status</field>
        <literalValue>RM - Approved</literalValue>
        <name>Advance Approval Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Advance_Case_Status</fullName>
        <description>Updates status of case upon submission to In Review</description>
        <field>Status</field>
        <literalValue>In Review</literalValue>
        <name>Advance Case Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Advance_Case_Status2</fullName>
        <description>Upon initial submission at the RM level of a territory realignment request the case status should be set to &quot;In Review&quot;</description>
        <field>Status</field>
        <literalValue>In Review</literalValue>
        <name>Advance Case Status 2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Reason_to_approved</fullName>
        <description>moved the case reason upon approval and close to Approve and Executed</description>
        <field>Reason</field>
        <literalValue>Approved</literalValue>
        <name>Case Reason to approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Reason_to_declined</fullName>
        <description>Move the case reason upon to decline when rejected</description>
        <field>Reason</field>
        <literalValue>Declined</literalValue>
        <name>Case Reason to declined</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Closed_with_Approval</fullName>
        <description>Closes record when approved</description>
        <field>Status</field>
        <literalValue>Close – Approved</literalValue>
        <name>Closed with Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Closed_with_Rejection</fullName>
        <description>Closes the record upon finance rejection</description>
        <field>Status</field>
        <literalValue>Close – Declined</literalValue>
        <name>Closed with Rejection</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Complete_Subject_Line_Finance_Workflow</fullName>
        <field>Subject</field>
        <formula>Account.Name &amp; &quot;-&quot; &amp; TEXT ( Adjustment_Type__c )&amp; &quot;-&quot; &amp; Sales_Rep_Name__r.LastName</formula>
        <name>Complete Subject Line Finance Workflow</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Final_Approval_Status</fullName>
        <description>Advances the approval status from &quot;In Review&quot; to &quot;Closed - GM Approved&quot;</description>
        <field>Status</field>
        <literalValue>GM - Approved</literalValue>
        <name>Final Approval Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>GM_Approval_Pending</fullName>
        <field>Status</field>
        <literalValue>Awaiting General Manager Approval</literalValue>
        <name>GM Approval Pending</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Market_2_Update</fullName>
        <field>Market2__c</field>
        <literalValue>US</literalValue>
        <name>Market 2 Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Rejection_Approval_Status</fullName>
        <description>Advances the approval status from &quot;In Review&quot; to &quot;Closed - Rejected&quot;</description>
        <field>Status</field>
        <literalValue>Close - Declined</literalValue>
        <name>Rejection Approval Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Rejection_Approval_Status2</fullName>
        <description>Advances the approval status from &quot;RM - Approved&quot; to &quot;Closed - Declined&quot;</description>
        <field>Status</field>
        <literalValue>Close - Declined</literalValue>
        <name>Rejection Approval Status2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SponsorMail_Update</fullName>
        <field>Account_Financially_Responsible_Email__c</field>
        <formula>Account.Email__c</formula>
        <name>SponsorMail Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_back_to_New</fullName>
        <field>Status</field>
        <literalValue>New</literalValue>
        <name>Status back to New</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_to_GM_Approval</fullName>
        <description>Status update to &apos;Awaiting General Manager Approval&apos;</description>
        <field>Status</field>
        <literalValue>Awaiting General Manager Approval</literalValue>
        <name>Status to GM Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_to_Submission_for_Appeal</fullName>
        <field>Status</field>
        <literalValue>Submitted for Appeal</literalValue>
        <name>Status to Submission for Appeal</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_to_manager</fullName>
        <description>move the status field to Manager Approvel</description>
        <field>Status</field>
        <literalValue>Awaiting Mgmt Approval</literalValue>
        <name>Status to manager</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Submission_Status</fullName>
        <description>This sets a territory realignment case submitted for approval&apos;s status to &quot;In Review&quot;</description>
        <field>Status</field>
        <literalValue>In Review</literalValue>
        <name>Submission Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Account_Primary_Contact_Email</fullName>
        <description>Update Account Primary Contact Email from contact&apos;s primary/secondary email</description>
        <field>Account_Primary_Contact_Email__c</field>
        <formula>IF(Contact.Email!=NULL, Contact.Email , Contact.Secondary_Email__c)</formula>
        <name>Update Account Primary Contact Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_status_to_Transfer_Approved</fullName>
        <description>Once final approve is done. Change the status to Transfer Approved.</description>
        <field>Status</field>
        <literalValue>Transfer Approved</literalValue>
        <name>Update status to Transfer Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_the_status_when_rejected</fullName>
        <description>Update the status when the record is rejected</description>
        <field>Status</field>
        <literalValue>Transfer Rejected</literalValue>
        <name>Update the status when rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>move_to_Finance</fullName>
        <description>updates the status field to show &apos;Finance Approval&apos; stage</description>
        <field>Status</field>
        <literalValue>Awaiting Business Office Approval</literalValue>
        <name>move to Finance</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>once_the_case_is_recalled</fullName>
        <description>once the case is recalled change the status from submitted for approval to New</description>
        <field>Status</field>
        <literalValue>New</literalValue>
        <name>once the case is recalled</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>once_the_case_submitted_for_approval</fullName>
        <description>once the case submitted for approval change the status from New to submitted for approval</description>
        <field>Status</field>
        <literalValue>Submitted For Approval</literalValue>
        <name>once the case submitted for approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>update_case_to_Transfer_Approved</fullName>
        <description>update the record once approved by the propesed campus director</description>
        <field>Status</field>
        <literalValue>Transfer Approved</literalValue>
        <name>update case to Transfer Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Change Student Qualification for the UnEnrolled Student</fullName>
        <actions>
            <name>Change_Student_Qualification_from_Active_to_inactive</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <description>Request to change the Student Qualification held on the Asset object associated to the Student Account for the case from ‘Active’ to  ‘inactive’.</description>
        <formula>if(RecordType.Name==&apos;Cancellation Request&apos;,true,false)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Finance Workflow Subject Create</fullName>
        <actions>
            <name>Complete_Subject_Line_Finance_Workflow</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Finance Workflow</value>
        </criteriaItems>
        <description>Concatenates subject line upon creation (save) of a Finance adjustment request</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Market 2 Update</fullName>
        <actions>
            <name>Market_2_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>User.Market__c</field>
            <operation>equals</operation>
            <value>US</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Populate student email from Contact</fullName>
        <actions>
            <name>Update_Account_Primary_Contact_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Account Primary Contact Email is populated with primary email or secondary email from contact.</description>
        <formula>AND(OR(NOT( ISNULL(Contact.Email)),NOT(ISNULL( Contact.Secondary_Email__c ))),OR($RecordType.Name=$Label.Cancellation_Request_Record_type,$RecordType.Name=$Label.Change_Request_Record_Type,$RecordType.Name=$Label.Loan_Bursary_Request))&amp;&amp; NOT( $Setup.Bypass_Settings__c.Disable_Workflow_Rules__c &amp;&amp; $RecordType.Name!=$Label.ANZ_Record_Type )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Send Email to Student%2FSponser</fullName>
        <actions>
            <name>Send_Email_to_Sponser</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Send_Email_to_Student_Sponser</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Once the cancellation case request is created trigger a mail to student/sponser.</description>
        <formula>ISPICKVAL(Type,&apos;Cancelation Request&apos; )&amp;&amp; NOT( $Setup.Bypass_Settings__c.Disable_Workflow_Rules__c &amp;&amp; $RecordType.Name!=$Label.ANZ_Record_Type )</formula>
        <triggerType>onCreateOnly</triggerType>
        <workflowTimeTriggers>
            <offsetFromField>Case.CreatedDate</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Send Email to Student%2FSponsor to notify about Cancellation Approval</fullName>
        <actions>
            <name>Send_Email_to_Sponsor_Cancellation_Request_Confirmation</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Send_Email_to_Student_Sponsor_Cancellation_Request_Confirmation</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>This workflow is used to notify the student and sponsor that the cancellation request has been approved and closed</description>
        <formula>(RecordType.DeveloperName == &apos;Cancellation_Request&apos;) &amp;&amp; ISPICKVAL(Status, &apos;Closed&apos;) &amp;&amp; NOT($Setup.Bypass_Settings__c.Disable_Workflow_Rules__c)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Send Email to Student%2FSponsor to notify about Cancellation Request</fullName>
        <actions>
            <name>Send_Email_to_Sponsor_Cancellation_Request_Notification</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Send_Email_to_Student_Sponsor_Cancellation_Request_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Once the cancellation case request is created trigger a mail to student/sponsor.</description>
        <formula>$RecordType.DeveloperName == &apos;Cancellation_Request&apos; &amp;&amp; NOT( $Setup.Bypass_Settings__c.Disable_Workflow_Rules__c)</formula>
        <triggerType>onCreateOnly</triggerType>
        <workflowTimeTriggers>
            <offsetFromField>Case.CreatedDate</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Send mail on Cancellation Request</fullName>
        <actions>
            <name>SponsorMail_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>NOT( OR(ISNULL(Account.Email__c), ISNULL( Contact.Email ) ))</formula>
        <triggerType>onCreateOnly</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>MailtoStudentSponsor_Request_to_Cancel_the_Enrollment</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>MailtoStudent_Request_to_Cancel_the_Enrollment</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Case.CreatedDate</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Student Notification</fullName>
        <actions>
            <name>Request_Approval_Mail</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Transfer Approved</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Change Request</value>
        </criteriaItems>
        <description>An email will be sent to the student once the campus change request has been approved.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Student%27s campus in Navision</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Change Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Type</field>
            <operation>equals</operation>
            <value>Change Campus</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Completed</value>
        </criteriaItems>
        <description>An update to eVision from Salesforce occurs when a students sponsor is updated in Salesforce.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Student_campus_change_in_Navision</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Change Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Type</field>
            <operation>equals</operation>
            <value>Change Campus</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Completed</value>
        </criteriaItems>
        <description>An update to eVision from Salesforce occurs when a students sponsor is updated in Salesforce.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <tasks>
        <fullName>Change_Sponsor_details_on_active_Student_Account_opportunities_to_new_sponsor</fullName>
        <assignedTo>m.rao.kotankari@accenture.com</assignedTo>
        <assignedToType>user</assignedToType>
        <description>Change Sponsor details on active Student Account opportunities to new sponsor</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Case.CreatedDate</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Change Sponsor details on active Student Account opportunities to new sponsor</subject>
    </tasks>
    <tasks>
        <fullName>Change_Student_Qualification_from_Active_to_inactive</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>1</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Case.CreatedDate</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Change Student Qualification from ‘Active’ to  ‘inactive’</subject>
    </tasks>
    <tasks>
        <fullName>Change_primary_Sponsor_details_on_the_Account_team</fullName>
        <assignedTo>m.rao.kotankari@accenture.com</assignedTo>
        <assignedToType>user</assignedToType>
        <description>Change primary Sponsor details on the Account team</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Case.CreatedDate</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Change primary Sponsor details on the Account team</subject>
    </tasks>
    <tasks>
        <fullName>Change_sponsor_details_on_the_Student_contract</fullName>
        <assignedTo>m.rao.kotankari@accenture.com</assignedTo>
        <assignedToType>user</assignedToType>
        <description>Change sponsor details on the Student contract</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Case.CreatedDate</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Change sponsor details on the Student contract</subject>
    </tasks>
    <tasks>
        <fullName>Issue_the_Student_with_a_deed_of_surety</fullName>
        <assignedTo>m.rao.kotankari@accenture.com</assignedTo>
        <assignedToType>user</assignedToType>
        <description>Issue the Student with a deed of surety,on case creation for sponsor change.</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Case.CreatedDate</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Issue the Student with a deed of surety</subject>
    </tasks>
</Workflow>
