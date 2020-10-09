trigger AssembliedBOMTrigger on AssembliedBOM__c (after insert,after update,after delete) {

    if(Trigger.isInsert)  {
        if(Trigger.isAfter) {
            AssembliedBOMTriggerHandler.onAfterInsert(Trigger.new);
        }
    }
    else if(Trigger.isUpdate) {
        if(Trigger.isAfter) {
            AssembliedBOMTriggerHandler.onAfterUpdate(Trigger.old,Trigger.new);
        }
    }
    else if(Trigger.isDelete) {
        AssembliedBOMTriggerHandler.onAfterDelete(Trigger.old);
    }
}