<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>CTI_Registration_Payment_Confirmation</fullName>
        <description>CTI Registration Payment Confirmation</description>
        <protected>false</protected>
        <recipients>
            <field>Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CTIMGI_Email_Templates/CTI_Registration_Payment_Confirmation</template>
    </alerts>
    <alerts>
        <fullName>CTI_Request_to_speak_to_Sponsor</fullName>
        <description>CTI Request to speak to Sponsor</description>
        <protected>false</protected>
        <recipients>
            <field>Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CTIMGI_Email_Templates/CTI_Request_to_speak_Sponsor</template>
    </alerts>
    <alerts>
        <fullName>CTI_Student_Enrolment_Confirmation</fullName>
        <description>CTI Student Enrolment Confirmation</description>
        <protected>false</protected>
        <recipients>
            <field>Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CTIMGI_Email_Templates/CTI_Enrolment_Confirmation</template>
    </alerts>
    <alerts>
        <fullName>CTI_Student_Registration_Confirmation</fullName>
        <description>CTI Student Registration Confirmation</description>
        <protected>false</protected>
        <recipients>
            <field>Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CTIMGI_Email_Templates/CTI_Registration_Confirmation</template>
    </alerts>
    <alerts>
        <fullName>Confirmation_of_Interview_Attendance</fullName>
        <description>Confirmation of Interview Attendance</description>
        <protected>false</protected>
        <recipients>
            <field>Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CTIMGI_Email_Templates/CTI_Interview_Confirmation</template>
    </alerts>
    <alerts>
        <fullName>MGI_Confirmation_of_Interview_Attendance_Email</fullName>
        <description>MGI Confirmation of Interview Attendance Email</description>
        <protected>false</protected>
        <recipients>
            <field>Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CTIMGI_Email_Templates/MGI_Midrand_Interview_Confirmation</template>
    </alerts>
    <alerts>
        <fullName>MGI_Registration_Payment_Confirmation</fullName>
        <description>MGI Registration Payment Confirmation</description>
        <protected>false</protected>
        <recipients>
            <field>Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CTIMGI_Email_Templates/MGI_Registration_Payment_Confirmation</template>
    </alerts>
    <alerts>
        <fullName>MGI_Request_to_speak_to_Sponsor</fullName>
        <description>MGI Request to speak to Sponsor</description>
        <protected>false</protected>
        <recipients>
            <field>Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CTIMGI_Email_Templates/MGI_Request_to_speak_to_Sponsor</template>
    </alerts>
    <alerts>
        <fullName>MGI_Student_Enrolment_Confirmation</fullName>
        <description>MGI Student Enrolment Confirmation</description>
        <protected>false</protected>
        <recipients>
            <field>Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CTIMGI_Email_Templates/MGI_Enrolment_Confirmation</template>
    </alerts>
    <alerts>
        <fullName>MGI_Student_Registration_Confirmation</fullName>
        <description>MGI Student Registration Confirmation</description>
        <protected>false</protected>
        <recipients>
            <field>Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CTIMGI_Email_Templates/MGI_Registration_Confirmation</template>
    </alerts>
    <rules>
        <fullName>CTI Confirmation of Interview Attendance Email</fullName>
        <actions>
            <name>Confirmation_of_Interview_Attendance</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Outbound_Notification__c.Method__c</field>
            <operation>equals</operation>
            <value>Email</value>
        </criteriaItems>
        <criteriaItems>
            <field>Outbound_Notification__c.Type__c</field>
            <operation>equals</operation>
            <value>Confirmation</value>
        </criteriaItems>
        <criteriaItems>
            <field>Outbound_Notification__c.Event__c</field>
            <operation>equals</operation>
            <value>Interview Attendance,Interview Attendance with Sponsor</value>
        </criteriaItems>
        <criteriaItems>
            <field>Outbound_Notification__c.Preferred_Campus__c</field>
            <operation>notEqual</operation>
            <value>Midrand</value>
        </criteriaItems>
        <description>CTI Confirmation of Interview Attendance Email</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>CTI Enrolment Confirmation Email</fullName>
        <actions>
            <name>CTI_Student_Enrolment_Confirmation</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Outbound_Notification__c.Method__c</field>
            <operation>equals</operation>
            <value>Email</value>
        </criteriaItems>
        <criteriaItems>
            <field>Outbound_Notification__c.Type__c</field>
            <operation>equals</operation>
            <value>Confirmation</value>
        </criteriaItems>
        <criteriaItems>
            <field>Outbound_Notification__c.Event__c</field>
            <operation>equals</operation>
            <value>Student Enrolment</value>
        </criteriaItems>
        <criteriaItems>
            <field>Outbound_Notification__c.Campus__c</field>
            <operation>notEqual</operation>
            <value>MGI Midrand Campus</value>
        </criteriaItems>
        <description>CTI Enrolment Confirmation Email</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>CTI Registration Confirmation Email</fullName>
        <actions>
            <name>CTI_Student_Registration_Confirmation</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Outbound_Notification__c.Method__c</field>
            <operation>equals</operation>
            <value>Email</value>
        </criteriaItems>
        <criteriaItems>
            <field>Outbound_Notification__c.Type__c</field>
            <operation>equals</operation>
            <value>Confirmation</value>
        </criteriaItems>
        <criteriaItems>
            <field>Outbound_Notification__c.Event__c</field>
            <operation>equals</operation>
            <value>Student Registration</value>
        </criteriaItems>
        <criteriaItems>
            <field>Outbound_Notification__c.Campus__c</field>
            <operation>notEqual</operation>
            <value>MGI Midrand Campus</value>
        </criteriaItems>
        <description>CTI Registration Confirmation Email</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>CTI Registration Payment Confirmation Email</fullName>
        <actions>
            <name>CTI_Registration_Payment_Confirmation</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Outbound_Notification__c.Method__c</field>
            <operation>equals</operation>
            <value>Email</value>
        </criteriaItems>
        <criteriaItems>
            <field>Outbound_Notification__c.Type__c</field>
            <operation>equals</operation>
            <value>Confirmation</value>
        </criteriaItems>
        <criteriaItems>
            <field>Outbound_Notification__c.Event__c</field>
            <operation>equals</operation>
            <value>Payment Registration</value>
        </criteriaItems>
        <criteriaItems>
            <field>Outbound_Notification__c.Campus__c</field>
            <operation>notEqual</operation>
            <value>MGI Midrand Campus</value>
        </criteriaItems>
        <description>CTI Registration Payment Confirmation Email</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>CTI Request to speak to Sponsor Email</fullName>
        <actions>
            <name>CTI_Request_to_speak_to_Sponsor</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Outbound_Notification__c.Method__c</field>
            <operation>equals</operation>
            <value>Email</value>
        </criteriaItems>
        <criteriaItems>
            <field>Outbound_Notification__c.Type__c</field>
            <operation>equals</operation>
            <value>Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Outbound_Notification__c.Event__c</field>
            <operation>equals</operation>
            <value>Speak to Sponsor</value>
        </criteriaItems>
        <criteriaItems>
            <field>Outbound_Notification__c.Preferred_Campus__c</field>
            <operation>notEqual</operation>
            <value>Midrand</value>
        </criteriaItems>
        <description>CTI Request to speak to Sponsor Email</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>MGI Confirmation of Interview Attendance Email</fullName>
        <actions>
            <name>MGI_Confirmation_of_Interview_Attendance_Email</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Outbound_Notification__c.Method__c</field>
            <operation>equals</operation>
            <value>Email</value>
        </criteriaItems>
        <criteriaItems>
            <field>Outbound_Notification__c.Type__c</field>
            <operation>equals</operation>
            <value>Confirmation</value>
        </criteriaItems>
        <criteriaItems>
            <field>Outbound_Notification__c.Event__c</field>
            <operation>equals</operation>
            <value>Interview Attendance</value>
        </criteriaItems>
        <criteriaItems>
            <field>Outbound_Notification__c.Preferred_Campus__c</field>
            <operation>equals</operation>
            <value>Midrand</value>
        </criteriaItems>
        <description>MGI Confirmation of Interview Attendance Email</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>MGI Enrolment Confirmation Email</fullName>
        <actions>
            <name>MGI_Student_Enrolment_Confirmation</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Outbound_Notification__c.Method__c</field>
            <operation>equals</operation>
            <value>Email</value>
        </criteriaItems>
        <criteriaItems>
            <field>Outbound_Notification__c.Type__c</field>
            <operation>equals</operation>
            <value>Confirmation</value>
        </criteriaItems>
        <criteriaItems>
            <field>Outbound_Notification__c.Event__c</field>
            <operation>equals</operation>
            <value>Student Enrolment</value>
        </criteriaItems>
        <criteriaItems>
            <field>Outbound_Notification__c.Campus__c</field>
            <operation>equals</operation>
            <value>MGI Midrand Campus</value>
        </criteriaItems>
        <description>MGI Enrolment Confirmation Email</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>MGI Registration Confirmation Email</fullName>
        <actions>
            <name>MGI_Student_Registration_Confirmation</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Outbound_Notification__c.Method__c</field>
            <operation>equals</operation>
            <value>Email</value>
        </criteriaItems>
        <criteriaItems>
            <field>Outbound_Notification__c.Type__c</field>
            <operation>equals</operation>
            <value>Confirmation</value>
        </criteriaItems>
        <criteriaItems>
            <field>Outbound_Notification__c.Event__c</field>
            <operation>equals</operation>
            <value>Student Registration</value>
        </criteriaItems>
        <criteriaItems>
            <field>Outbound_Notification__c.Campus__c</field>
            <operation>equals</operation>
            <value>MGI Midrand Campus</value>
        </criteriaItems>
        <description>MGI Registration Confirmation Email</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>MGI Registration Payment Confirmation Email</fullName>
        <actions>
            <name>MGI_Registration_Payment_Confirmation</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Outbound_Notification__c.Method__c</field>
            <operation>equals</operation>
            <value>Email</value>
        </criteriaItems>
        <criteriaItems>
            <field>Outbound_Notification__c.Type__c</field>
            <operation>equals</operation>
            <value>Confirmation</value>
        </criteriaItems>
        <criteriaItems>
            <field>Outbound_Notification__c.Event__c</field>
            <operation>equals</operation>
            <value>Payment Registration</value>
        </criteriaItems>
        <criteriaItems>
            <field>Outbound_Notification__c.Campus__c</field>
            <operation>equals</operation>
            <value>MGI Midrand Campus</value>
        </criteriaItems>
        <description>MGI Registration Payment Confirmation Email</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>MGI Request to speak to Sponsor Email</fullName>
        <actions>
            <name>MGI_Request_to_speak_to_Sponsor</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Outbound_Notification__c.Method__c</field>
            <operation>equals</operation>
            <value>Email</value>
        </criteriaItems>
        <criteriaItems>
            <field>Outbound_Notification__c.Type__c</field>
            <operation>equals</operation>
            <value>Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Outbound_Notification__c.Event__c</field>
            <operation>equals</operation>
            <value>Speak to Sponsor</value>
        </criteriaItems>
        <criteriaItems>
            <field>Outbound_Notification__c.Preferred_Campus__c</field>
            <operation>equals</operation>
            <value>Midrand</value>
        </criteriaItems>
        <description>MGI Request to speak to Sponsor Email</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
