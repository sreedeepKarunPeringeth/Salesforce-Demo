<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>UniqueFieldUpdate</fullName>
        <description>updating unique field</description>
        <field>MaterialPartName__c</field>
        <formula>ProductID__c + Part_Detail_ID__c</formula>
        <name>Unique Field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
</Workflow>
