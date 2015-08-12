<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>InstallDate_as_CreatedDate</fullName>
        <description>Set Install Date as Created Date when creating Product In Use</description>
        <field>InstallDate</field>
        <formula>CreatedDate</formula>
        <name>InstallDate as CreatedDate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Product_Author_Update</fullName>
        <description>Update Asset Author to the name of the linked product</description>
        <field>Product_Author__c</field>
        <formula>Product2.Author__c</formula>
        <name>Product Author Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Product_Copyright_Year</fullName>
        <description>Update Asset Copyright Year to the name of the linked product</description>
        <field>Copyright_Year__c</field>
        <formula>Product2.Copyright_Year__c</formula>
        <name>Product Copyright Year</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Product_Edition_Update</fullName>
        <description>Update Asset Edition to the name of the linked product</description>
        <field>Product_Edition__c</field>
        <formula>Product2.Edition__c</formula>
        <name>Product Edition Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Product_ISBN_10</fullName>
        <description>Populates the ISBN 10 field on an Asset</description>
        <field>ISBN_10__c</field>
        <formula>Product2.SBN__c</formula>
        <name>Product ISBN 10</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Product_ISBN_Update</fullName>
        <description>Update Asset ISBN to the name of the linked product</description>
        <field>Product_ISBN__c</field>
        <formula>Product2.ISBN__c</formula>
        <name>Product ISBN Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Product_Name_Update</fullName>
        <description>Update Asset Name to the name of the linked product</description>
        <field>Name</field>
        <formula>Product2.Name</formula>
        <name>Product Name Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Competitor_Product_toTRUE</fullName>
        <description>Updates the Competitor Asset field to True based on the Competitor Product</description>
        <field>IsCompetitorProduct</field>
        <literalValue>1</literalValue>
        <name>Set Competitor Product toTRUE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Competitor_Product_to_FALSE</fullName>
        <description>Sets the Competitor Product Flag to False if the Competitor Product is not populated on a Product</description>
        <field>IsCompetitorProduct</field>
        <literalValue>0</literalValue>
        <name>Set Competitor Product to FALSE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdatePublisherToPearson</fullName>
        <description>Update the publisher picklist field to &quot;Pearson&quot;</description>
        <field>Publisher__c</field>
        <literalValue>Pearson</literalValue>
        <name>UpdatePublisherToPearson</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Competitive_Status</fullName>
        <description>Updates the Competitive Status based on the value of the Product Competitive Edition Status Field</description>
        <field>Competitive_Status__c</field>
        <formula>Product2.Competitor_Edition_Status__c</formula>
        <name>Update Competitive Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_the_Cancelled_Date</fullName>
        <description>Update the date when status is cancelled</description>
        <field>Cancelled_dateTime__c</field>
        <formula>NOW()</formula>
        <name>Update the Cancelled Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Capture the Asset status w</fullName>
        <actions>
            <name>Update_the_Cancelled_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Asset.Status</field>
            <operation>equals</operation>
            <value>Cancelled</value>
        </criteriaItems>
        <description>Capture the Cancelled date and time when status is cancelled.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Product In Use - Install Date field</fullName>
        <actions>
            <name>InstallDate_as_CreatedDate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Asset.InstallDate</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Update Install date field as Created Date when creating a new product in use</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Publisher for non competitor Product in User</fullName>
        <actions>
            <name>UpdatePublisherToPearson</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Asset.IsCompetitorProduct</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Update Publisher to pearson if product in use is not checked</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Competitor Product to FALSE</fullName>
        <actions>
            <name>Set_Competitor_Product_to_FALSE</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>If a product in use is linked to a Competitor product, Update Competitor Asset to FALSE</description>
        <formula>AND (      NOT(ISBLANK(Product2.Id)),     Product2.Competitor_Product__c = FALSE,      RecordType.Name  = &quot;US HE Record Type&quot; )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Competitor Product to TRUE</fullName>
        <actions>
            <name>Set_Competitor_Product_toTRUE</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>If a product in use is linked to a Competitor product, Update Competitor Asset to True</description>
        <formula>AND (  NOT(ISBLANK(Product2.Id)),     Product2.Competitor_Product__c = TRUE,      RecordType.Name = &quot;US HE Record Type&quot; )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Product Details</fullName>
        <actions>
            <name>Product_Author_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Product_Copyright_Year</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Product_Edition_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Product_ISBN_10</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Product_ISBN_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Product_Name_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Competitive_Status</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>If a product in use is linked to an actual product, overwrite the product name with the name from the product record</description>
        <formula>NOT(ISBLANK(Product2.Id))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
