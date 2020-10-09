<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Calculate_Part_Code</fullName>
        <field>Part_Code__c</field>
        <formula>RIGHT(TEXT(Category__c),(LEN(TEXT(Category__c))-FIND(&quot;~&quot;,TEXT(Category__c))))+&apos;-&apos;+
RIGHT(TEXT(Sub_Category__c),(LEN(TEXT(Sub_Category__c))-FIND(&quot;~&quot;,TEXT(Sub_Category__c))))+&apos;-&apos;+
IF(NOT(ISBLANK(Parameter_Value_1__c)) , RIGHT(Parameter_Value_1__c,(LEN(Parameter_Value_1__c)-FIND(&quot;~&quot;,Parameter_Value_1__c))),&apos;&apos;)+
IF(NOT(ISBLANK(Parameter_Value_2__c)) , RIGHT(Parameter_Value_2__c,(LEN(Parameter_Value_2__c)-FIND(&quot;~&quot;,Parameter_Value_2__c))),&apos;&apos;)+
IF(NOT(ISBLANK(Parameter_Value_3__c)) , RIGHT(Parameter_Value_3__c,(LEN(Parameter_Value_3__c)-FIND(&quot;~&quot;,Parameter_Value_3__c))),&apos;&apos;)+
IF(NOT(ISBLANK(Parameter_Value_4__c)) , RIGHT(Parameter_Value_4__c,(LEN(Parameter_Value_4__c)-FIND(&quot;~&quot;,Parameter_Value_4__c))),&apos;&apos;)+
IF(NOT(ISBLANK(Parameter_Value_5__c)) , RIGHT(Parameter_Value_5__c,(LEN(Parameter_Value_5__c)-FIND(&quot;~&quot;,Parameter_Value_5__c))),&apos;&apos;)+
IF(NOT(ISBLANK(Parameter_Value_6__c)) , RIGHT(Parameter_Value_6__c,(LEN(Parameter_Value_6__c)-FIND(&quot;~&quot;,Parameter_Value_6__c))),&apos;&apos;)+
IF(NOT(ISBLANK(Parameter_Value_7__c)) , RIGHT(Parameter_Value_7__c,(LEN(Parameter_Value_7__c)-FIND(&quot;~&quot;,Parameter_Value_7__c))),&apos;&apos;)+
IF(NOT(ISBLANK(Parameter_Value_8__c)) , RIGHT(Parameter_Value_8__c,(LEN(Parameter_Value_8__c)-FIND(&quot;~&quot;,Parameter_Value_8__c))),&apos;&apos;)</formula>
        <name>Calculate Part Code</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Populate Part Code</fullName>
        <actions>
            <name>Calculate_Part_Code</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>TRUE</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
