public class SubAssemblyBOMService {
    
     /**
     * Method to update the material price when a new SubAssemblyBom is getting inserted.
     * 
     * */
    public  static void updateMaterialPriceOnInsert(List<SubAssemblyBOM__c> newSubAssemblyBom) {
        
        Map<Id,Decimal> materialPriceMap= new Map<Id,Decimal>();
        
        for(SubAssemblyBOM__c bom : newSubAssemblyBom) {
            Decimal price= 0.0;
            if(materialPriceMap.get(bom.Material__c) != null) {
                price+= materialPriceMap.get(bom.Material__c);
            }
            if(bom.SubAssemblyBOMPrice__c != null) {
                price+= bom.SubAssemblyBOMPrice__c;
            }
            materialPriceMap.put(bom.Material__c,price);
        }
        List<Materials__c> materialList = [SELECT  Id,Price__c from Materials__c WHERE id = :materialPriceMap.keySet()];
        
        for (Materials__c material : materialList) {
            if(material.Price__c != null){
                material.Price__c += materialPriceMap.get(material.Id);
            } 
        }
        update materialList; 
        
    }
    
    /**
     * Method to update the material price when SubAssemblyBom is getting updated.
     * 
     * */ 
    public static void updateMaterialPriceOnUpdate(List<SubAssemblyBOM__c> oldSubAssemblyBom,List<SubAssemblyBOM__c> newSubAssemblyBom) {
        
        Map<Id,Decimal> newMaterialPriceMap= new Map<Id,Decimal>();
        Map<Id,Decimal> oldMaterialPriceMap= new Map<Id,Decimal>();
        
        for(SubAssemblyBOM__c bom : newSubAssemblyBom) {
            Decimal price= 0.0;
            if(newMaterialPriceMap.get(bom.Material__c) != null) {
                price+= newMaterialPriceMap.get(bom.Material__c);
            }
            if(bom.SubAssemblyBOMPrice__c != null) {
                price+= bom.SubAssemblyBOMPrice__c;
            }
            newMaterialPriceMap.put(bom.Material__c,price);
        }
        
        for(SubAssemblyBOM__c bom : oldSubAssemblyBom) {
            Decimal price= 0.0;
            if(oldMaterialPriceMap.get(bom.Material__c) != null) {
                price+= oldMaterialPriceMap.get(bom.Material__c);
            }
            if(bom.SubAssemblyBOMPrice__c != null) {
                price+= bom.SubAssemblyBOMPrice__c;
            }
            oldMaterialPriceMap.put(bom.Material__c,price);
        }
        
        List<Materials__c> materialList = [SELECT  Id,Price__c from Materials__c WHERE id = :newMaterialPriceMap.keySet()];
        
        for (Materials__c material : materialList) {
                if(material.Price__c == null ) {
                    material.Price__c = 0;
                }
                if(material.Price__c == 0 || material.Price__c == 0.0) {
                    material.Price__c += newMaterialPriceMap.get(material.Id);
                }
                else {
            		material.Price__c -= oldMaterialPriceMap.get(material.Id);
                	material.Price__c += newMaterialPriceMap.get(material.Id);        
                }
            //material.Price__c += newMaterialPriceMap.get(material.Id);
        }
        update materialList; 
    }
    
    /**
     * Method to update the material price when SubAssemblyBom is getting deleted.
     * 
     * */
    public static void UpdateMaterialPriceOnDelete(List<SubAssemblyBOM__c> delSubAssemblyBom) {
        
        Map<Id,Decimal> materialPriceMap= new Map<Id,Decimal>();
        for(SubAssemblyBOM__c bom : delSubAssemblyBom) {
            Decimal price= 0.0;
            if(materialPriceMap.get(bom.Material__c) != null) {
                price+= materialPriceMap.get(bom.Material__c);
            }
            if(bom.SubAssemblyBOMPrice__c != null) {
                price+= bom.SubAssemblyBOMPrice__c;
            }
            materialPriceMap.put(bom.Material__c,price);
        }
        
        List<Materials__c> materialList = [SELECT  Id,Price__c from Materials__c WHERE id = :materialPriceMap.keySet()];
        
        for (Materials__c material : materialList) {
            if(material.Price__c != null && (material.Price__c != 0 || material.Price__c != 0.0)){
                material.Price__c -= materialPriceMap.get(material.Id);
            } 
        }
        update materialList;  
    }    
}