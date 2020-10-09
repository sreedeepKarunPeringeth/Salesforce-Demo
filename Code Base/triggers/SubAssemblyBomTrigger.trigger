trigger SubAssemblyBomTrigger on SubAssemblyBOM__c (after insert,after update,after delete) {
    
    if(Trigger.isInsert)  {
        
        if(Trigger.isAfter) {
            SubAssemblyBomTriggerHandler.onAfterInsert(Trigger.new);
        }
    }
    else if(Trigger.isUpdate) {
        
        if(Trigger.isAfter) {
            SubAssemblyBomTriggerHandler.onAfterUpdate(Trigger.old,Trigger.new);
            
        }
    }
    
    else if(Trigger.isDelete) {
        SubAssemblyBomTriggerHandler.onAfterDelete(Trigger.old);
    }
    
    
}