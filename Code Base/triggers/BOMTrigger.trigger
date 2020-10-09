trigger BOMTrigger on BOM__c (after insert,after update,after delete,before insert,before update) {
    
    if(Trigger.isInsert) {
        
        if(Trigger.isBefore) {
            BomTriggerHandler.onBeforeInsert(Trigger.new);   
        }
        
        else {
            BomTriggerHandler.onAfterInsert(Trigger.new);
            
        }
    } 
    else if(Trigger.isUpdate) {
        
        if (Trigger.isBefore) {
            BomTriggerHandler.onBeforeUpdate(Trigger.new);
        }
        
        else {
            BomTriggerHandler.onAfterUpdate(Trigger.old,Trigger.new);
            
        }
    }
    
    else if(Trigger.isDelete) {
        BomTriggerHandler.onAfterDelete(Trigger.old);
    }
}