<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>UpdateSubAssemblyName</fullName>
        <field>UniqueName__c</field>
        <formula>Name</formula>
        <name>UpdateSubAssemblyName</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Sub Assembly Name unifying</fullName>
        <actions>
            <name>UpdateSubAssemblyName</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>To make the name field of sub assembly unique</description>
        <formula>TRUE</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
