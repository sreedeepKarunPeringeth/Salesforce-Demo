public class BomTriggerHandler {
    
    public static void onAfterInsert(List<BOM__c> newBom) { 
        MaterialService.updateMaterialPriceOnInsert(newbom);
        
    }
    
    public static void onBeforeInsert(List<BOM__c> newBom) { 
          BomInsertService.preventDuplicateBomOnInsert(newBom);
          
    }
    
    public static void onAfterUpdate(List<BOM__c> oldbom,List<BOM__c> newBom) { 
        MaterialService.updateMaterialPriceOnUpdate(oldbom,newbom);   
    }
    
     public static void onBeforeUpdate(List<BOM__c> newBom) { 
			BomInsertService.preventDuplicateBomOnUpdate(newBom);     
    }
    
    
    
    public static void onAfterDelete(List<BOM__c> delbom) {
        MaterialService.UpdateMaterialPriceOnDelete(delbom);  
    }   
    
}