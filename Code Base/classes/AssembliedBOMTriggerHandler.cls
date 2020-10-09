public class AssembliedBOMTriggerHandler {

    public static void onAfterInsert(List<AssembliedBOM__c> assembliedBOMList) {
        AssembliedBOMService.updateSubAssemblyPriceOnInsert(assembliedBOMList);
    }
    
    public static void onAfterUpdate(List<AssembliedBOM__c> oldAssembliedBOMList,List<AssembliedBOM__c> newAssembliedBOMList) {
    
        AssembliedBOMService.updateSubAssemblyPriceOnUpdate(oldAssembliedBOMList,newAssembliedBOMList);        
    }
    
    public static void onAfterDelete(List<AssembliedBOM__c> assembliedBOMList) {
        
        AssembliedBOMService.updateSubAssemblyPriceOnDelete(assembliedBOMList);
    }
}