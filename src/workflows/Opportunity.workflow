<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Amount_update_from_lead_amount</fullName>
        <description>Used to update the oppty amount from lead conversion. So that the oppty amount = the lead amount (on create only)</description>
        <field>Amount</field>
        <formula>Lead_Amount__c</formula>
        <name>Amount update from lead amount</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Loan_update</fullName>
        <field>Institution_Approved__c</field>
        <formula>&quot;Approved&quot;</formula>
        <name>Loan update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_At_Risk_Reason_Field_Clear</fullName>
        <description>CORE - Clears the text in At Risk/Postponed Reason field.</description>
        <field>At_Risk_Postponed_Reason__c</field>
        <name>Opportunity At Risk Reason Field Clear</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_Legacy_Re_engagement</fullName>
        <description>CORE - updates the legacy re engagement date with the recorded  re engagement date</description>
        <field>Legacy_Engagement_Date__c</field>
        <formula>Re_engagement_Date__c</formula>
        <name>Opportunity Legacy Re-engagement</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_Re_engagement_clear</fullName>
        <description>CORE - clears the re engagement date after workflow has fired to create the re engagement task.</description>
        <field>Re_engagement_Date__c</field>
        <name>Opportunity Re-engagement clear</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RD_166_Update</fullName>
        <field>Academic_Vetting_Status__c</field>
        <literalValue>Pre-Vetted</literalValue>
        <name>RD-166 Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Received_signed_conract_field_update</fullName>
        <description>Received_Signed_Registration_Contract__c field update to true</description>
        <field>Received_Signed_Registration_Contract__c</field>
        <literalValue>1</literalValue>
        <name>Received signed conract field update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Registration_Payment_Reference</fullName>
        <description>Updates the Registration Payment Reference on a Returning Opportunity</description>
        <field>Registration_Payment_Reference__c</field>
        <formula>TEXT(234243)</formula>
        <name>Registration Payment Reference</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Enrolment_Status</fullName>
        <description>Set enrolment status to &apos;Enrolled&apos;</description>
        <field>Enrolment_Status__c</field>
        <literalValue>Enrolled</literalValue>
        <name>Set Enrolment Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>StudentRegistraionCTIMGI</fullName>
        <field>Student_Registered__c</field>
        <literalValue>1</literalValue>
        <name>StudentRegistraionCTIMGI</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>StudentRegistraionCTIMGIoppstage</fullName>
        <field>StageName</field>
        <literalValue>Negotiation</literalValue>
        <name>StudentRegistraionCTIMGIoppstage</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Student_Registered_Checkbox</fullName>
        <description>Updates the Student Registered Checkbox whenever the Registration Payment Reference and Student Registration Contract Signed and Received Checkbox is checked</description>
        <field>Student_Registered__c</field>
        <literalValue>1</literalValue>
        <name>Student Registered Checkbox</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Student_registered_field_update</fullName>
        <field>Student_Registered__c</field>
        <literalValue>1</literalValue>
        <name>Student registered field update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Test_00153</fullName>
        <field>Student_Registered__c</field>
        <literalValue>1</literalValue>
        <name>Test_00153</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Enrolment_Status_to_Enrolled_AS</fullName>
        <field>Enrolment_Status__c</field>
        <literalValue>Enrolled</literalValue>
        <name>Enrolment Status to &apos;Enrolled&apos; -00176</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>student_registered_check_box_to_true</fullName>
        <field>Student_Registered__c</field>
        <literalValue>1</literalValue>
        <name>student registered check box to true</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>update_Academic_Vetting_Statu</fullName>
        <description>On Academic Vetting Status = Approved AND Opportunity Stage not = Closed Won.</description>
        <field>Academic_Vetting_Status__c</field>
        <literalValue>Pre-Vetted</literalValue>
        <name>update Academic Vetting Statu</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>update_the_Enrollment_status</fullName>
        <description>Workflow is required to update the Enrolment status---625</description>
        <field>Enrolment_Status__c</field>
        <literalValue>Pre-enrolled</literalValue>
        <name>update the Enrollment status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Check for student registered%3F RD_00153</fullName>
        <actions>
            <name>Test_00153</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>student_registered_check_box_to_true</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>When the sales stage moves from &apos;Proposal/Quote&apos; to &apos;Negotiation&apos; and &apos;Student Registered is = FALSE&apos;, a workflow must fire to check the &apos;Student Registered&apos; checkbox.</description>
        <formula>AND(  OR( ISPICKVAL(PRIORVALUE(StageName),&quot;Needs Analysis&quot;), ISPICKVAL(PRIORVALUE(StageName),&quot;Solutioning&quot;), ISPICKVAL(PRIORVALUE(StageName),&quot;Quote/Proposal&quot;) ),  ISPICKVAL(StageName ,&quot;Negotiation&quot;), Student_Registered__c == False )  &amp;&amp; NOT( $Setup.Bypass_Settings__c.Disable_Workflow_Rules__c &amp;&amp; $RecordType.Name!=$Label.ANZ_Opportunity_Record_Type )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Lead Amount equals Oppty Amount</fullName>
        <actions>
            <name>Amount_update_from_lead_amount</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Used on conversion of lead. Lead amount updates Oppty Amount.</description>
        <formula>ISNULL(Lead_Amount__c) &amp;&amp; NOT( $Setup.Bypass_Settings__c.Disable_Workflow_Rules__c &amp;&amp; $RecordType.Name!=$Label.ANZ_Opportunity_Record_Type ) &amp;&amp;  isConvertedFromLead__c</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Loan Status</fullName>
        <actions>
            <name>Loan_update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISPICKVAL(Loan_Status__c, &apos;Approved&apos;)&amp;&amp; NOT( $Setup.Bypass_Settings__c.Disable_Workflow_Rules__c &amp;&amp; $RecordType.Name!=$Label.ANZ_Opportunity_Record_Type )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity - Re-engagement task</fullName>
        <actions>
            <name>Opportunity_Re_engagement</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Legacy_Engagement_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>CORE - creates a task to alert the opportunity owner when to re engage with a renewal/cloned opportunity</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity On Schedule At Risk Reason Update</fullName>
        <actions>
            <name>Opportunity_At_Risk_Reason_Field_Clear</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>CORE - When oppty status is changed to On Schedule, this workflow clears the &apos;At Risk / Postponed Reason&apos;</description>
        <formula>ISPICKVAL(Status__c, &quot;On Schedule&quot;)&amp;&amp; NOT( $Setup.Bypass_Settings__c.Disable_Workflow_Rules__c &amp;&amp; $RecordType.Name!=$Label.ANZ_Opportunity_Record_Type )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity postponed Re-engagement</fullName>
        <actions>
            <name>Re_engage_on_Opportunity_Opportunity_Name</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <description>CORE - When an oppty status equals &apos;Postponed&apos; a new task will be created based on the Re-engagement Date of the opportunity.</description>
        <formula>ISPICKVAL(Status__c, &quot;Postponed&quot; )&amp;&amp; NOT( $Setup.Bypass_Settings__c.Disable_Workflow_Rules__c &amp;&amp; $RecordType.Name!=$Label.ANZ_Opportunity_Record_Type )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>PS_D2L_Opportunity_Pre-Enrollment</fullName>
        <actions>
            <name>update_the_Enrollment_status</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Workflow Rule Fired when a D2L Opportunity reaches the Pre-Enrollment Stage

Opportunity Type = Returning Business
International student = No
Academic Vetting = Vetted - Approved

Action:

Update Enrolment Status to Pre-enrolled</description>
        <formula>AND($RecordType.Name=&apos;D2L&apos;,  AND(ISPICKVAL(Type, &apos;Returning Business&apos;), ISPICKVAL(International_Student_Status__c, &apos;No&apos;) ,ISPICKVAL(Academic_Vetting_Status__c, &apos;Vetted - Approved&apos;), ISCHANGED(Academic_Vetting_Status__c) ) )&amp;&amp; NOT( $Setup.Bypass_Settings__c.Disable_Workflow_Rules__c  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>RD-166</fullName>
        <actions>
            <name>RD_166_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>AND( ISPICKVAL(Academic_Vetting_Status__c, &quot;Vetted - Approved&quot;) , !ISPICKVAL( StageName,&quot;Closed&quot;), ISCHANGED( Lead_Product__c ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Enrolment Status</fullName>
        <actions>
            <name>Set_Enrolment_Status</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Set enrolment status to &apos;Enrolled&apos; when stage is closed</description>
        <formula>AND(  ISPICKVAL(StageName, &apos;Closed&apos;)  )&amp;&amp; NOT( $Setup.Bypass_Settings__c.Disable_Workflow_Rules__c &amp;&amp; $RecordType.Name!=$Label.ANZ_Opportunity_Record_Type )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>StudentRegistraionCTIMGI</fullName>
        <actions>
            <name>StudentRegistraionCTIMGI</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>StudentRegistraionCTIMGIoppstage</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Registration_Payment_Reference__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Received_Signed_Registration_Contract__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>D2L</value>
        </criteriaItems>
        <description>A student can only register once for CTIMGI. The system needs to enforce registration on the Student&apos;s first Opporunity with CTIMIG.-RD-00153</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Academic Vetting Status field to Pre-Vetted</fullName>
        <actions>
            <name>update_Academic_Vetting_Statu</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>If Opportunuty Products change when Academic Vetting Status = Approved AND Opportunity Stage not = Closed Won, a trigger needs to fire using flow to reset the Academic Vetting Status field to Pre-Vetted.</description>
        <formula>OR( AND(ISPICKVAL(Academic_Vetting_Status__c, &apos;Vetted - Approved&apos;) ),  AND( ISPICKVAL(StageName, &apos;Closed&apos;)  ))&amp;&amp; NOT( $Setup.Bypass_Settings__c.Disable_Workflow_Rules__c &amp;&amp; $RecordType.Name!=$Label.ANZ_Opportunity_Record_Type )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update LOB</fullName>
        <active>false</active>
        <criteriaItems>
            <field>User.Market__c</field>
            <operation>equals</operation>
            <value>North America</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>UpdateEnrolmentstatusasper RD-00176</fullName>
        <actions>
            <name>Update_Enrolment_Status_to_Enrolled_AS</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Criteria:
- Opportunity Status = Closed Won
- Type = New Business or Existing Business

Action:
Update Enrolment Status to &apos;Enrolled&apos;</description>
        <formula>AND(OR($RecordType.Name=&apos;D2L&apos;,$RecordType.Name=&apos;B2B&apos;), OR( AND( ISNEW(),ISPICKVAL(StageName, &apos;Closed Won&apos;) ),  AND( ISPICKVAL(Type, &apos;New Business&apos;),  AND ( ISPICKVAL(Type, &apos;Existing Business&apos;) ) )))&amp;&amp; NOT( $Setup.Bypass_Settings__c.Disable_Workflow_Rules__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Updating the Student registerd and Received_Signed_Registration_Contract%5F%5Fc fields</fullName>
        <actions>
            <name>Received_signed_conract_field_update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Registration_Payment_Reference</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Student_registered_field_update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(OR($RecordType.Name=&apos;D2L&apos;,$RecordType.Name=&apos;B2B&apos;), OR( AND(  ISPICKVAL(Type, &apos;Returning Business&apos;)  )))&amp;&amp; NOT( $Setup.Bypass_Settings__c.Disable_Workflow_Rules__c  )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Updating the Student registerd checkbox field</fullName>
        <actions>
            <name>Student_Registered_Checkbox</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND($RecordType.Name==$Label.D2L_Opportunity_Record_Type, ISPICKVAL(Type, &apos;New Business&apos;),  NOT(ISNULL( Registration_Payment_Reference__c)),  ISPICKVAL( StageName , &quot;Negotiation&quot;),  Received_Signed_Registration_Contract__c == true ) &amp;&amp; NOT( $Setup.Bypass_Settings__c.Disable_Workflow_Rules__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Workflow is required to update the Enrolment Status as per  625</fullName>
        <actions>
            <name>update_the_Enrollment_status</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Workflow is required to update the Enrolment Status</description>
        <formula>OR(  AND(  ISNEW(),ISPICKVAL(Type, &apos;Existing Business&apos;)  ),  AND(  ISPICKVAL(Type, &apos;Returning Business&apos;),  AND (  ISPICKVAL(International_Student_Status__c, &apos;False&apos;)  ), AND(ISPICKVAL(Academic_Vetting_Status__c, &apos;Vetted - Approved&apos;)  ) ))&amp;&amp; NOT( $Setup.Bypass_Settings__c.Disable_Workflow_Rules__c &amp;&amp; $RecordType.Name!=$Label.ANZ_Opportunity_Record_Type )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <tasks>
        <fullName>Opportunity_Re_engagement</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Opportunity.Legacy_Engagement_Date__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Open</status>
        <subject>Opportunity Re-engagement</subject>
    </tasks>
    <tasks>
        <fullName>Re_engage_on_Opportunity_Opportunity_Name</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Opportunity.Re_engagement_Date__c</offsetFromField>
        <priority>High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Re-engage Postponed Opportunity</subject>
    </tasks>
</Workflow>
