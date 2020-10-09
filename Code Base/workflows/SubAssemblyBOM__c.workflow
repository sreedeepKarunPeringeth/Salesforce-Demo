<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>CreateSubAssemblyBOMName</fullName>
        <field>SubAssemblyBOMUniqueName__c</field>
        <formula>Material__r.Name +&apos;_&apos;+ Sub_Assembly__r.Name</formula>
        <name>CreateSubAssemblyBOMName</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateSubAssemblyBOMName</fullName>
        <field>Name</field>
        <formula>Material__r.Name +&apos;_&apos;+ Sub_Assembly__r.Name</formula>
        <name>UpdateSubAssemblyBOMName</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Sub Assembly BOM Name unifying</fullName>
        <actions>
            <name>CreateSubAssemblyBOMName</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>UpdateSubAssemblyBOMName</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>To make the junction object name unifying</description>
        <formula>TRUE</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
