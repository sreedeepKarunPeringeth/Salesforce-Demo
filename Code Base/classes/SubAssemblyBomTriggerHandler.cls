public class SubAssemblyBomTriggerHandler {
    
    public static void onAfterInsert(List<SubAssemblyBOM__c> newSubAssemblyBom) {
        SubAssemblyBOMService.updateMaterialPriceOnInsert(newSubAssemblyBom);
        
    }
    
    public static void onAfterUpdate(List<SubAssemblyBOM__c> OldSubAssemblyBom,List<SubAssemblyBOM__c> newSubAssemblyBom) {  
        SubAssemblyBOMService.updateMaterialPriceOnUpdate(OldSubAssemblyBom, newSubAssemblyBom);
    }
    
    public static void onAfterDelete(List<SubAssemblyBOM__c> delSubAssemblyBom) { 
        SubAssemblyBOMService.UpdateMaterialPriceOnDelete(delSubAssemblyBom);
        
    }   
}