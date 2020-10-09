public  class MaterialService {   
    
    /**
    * Method to update the material price when a new bom is getting inserted.
    * 
    * */
    public  static void updateMaterialPriceOnInsert(List<BOM__c> newBom) {      
        
        Map<Id,Decimal> materialPriceMap= new Map<Id,Decimal>();
        for(Bom__c bom : newBom) {
            Decimal price= 0.0;
            if(materialPriceMap.get(bom.ProductID__c) != null) {
                price+= materialPriceMap.get(bom.ProductID__c);
                
            }
            
            if(bom.BomPrice__c != null) {
                price+= bom.BomPrice__c;
            }
            materialPriceMap.put(bom.ProductID__c,price);
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
    * Method to update the material price when bom is getting updated.
    * 
    * */ 
    public static void updateMaterialPriceOnUpdate(List<BOM__c> oldBom,List<BOM__c> newBom) {   
        
        List<AssembliedBOM__c> assembledBOMIds= [Select id,BOM__c,SubAssembly__c from AssembliedBOM__c where BOM__c in :newBom];
        Set<ID> materialIDs= new Set<ID>();
        Set<ID> subAssemblyIDs= new Set<ID>();
        for(AssembliedBOM__c assBom : assembledBOMIds) {
            if(assBom.SubAssembly__c != null) {
            	subAssemblyIDs.add(assBom.SubAssembly__c);   
            }
        }
        
        for(BOM__c bom : newBom) {
            if(bom.ProductID__c != null) {
            	materialIDs.add(bom.ProductID__c);   
            }
        }
        UpdatePriceInSubAssembly(subAssemblyIDs);
        UpdatePriceInMaterials(materialIDs);
        
        /*Map<Id,Decimal> newMaterialPriceMap= new Map<Id,Decimal>();
        Map<Id,Decimal> oldMaterialPriceMap= new Map<Id,Decimal>();
        for(Bom__c bom : newBom) {
            Decimal price= 0.0;
            if(newMaterialPriceMap.get(bom.ProductID__c) != null) {
                price+= newMaterialPriceMap.get(bom.ProductID__c);
            }
            if(bom.BomPrice__c != null) {
                price+= bom.BomPrice__c;
            }
            newMaterialPriceMap.put(bom.ProductID__c,price);
        }
        
        for(Bom__c bom : oldBom) {
            Decimal price= 0.0;
            if(oldMaterialPriceMap.get(bom.ProductID__c) != null) {
                price+= oldMaterialPriceMap.get(bom.ProductID__c);
            }
            if(bom.BomPrice__c != null) {
                price+= bom.BomPrice__c;
            }
            oldMaterialPriceMap.put(bom.ProductID__c,price);
        }
        List<Materials__c> materialList = [SELECT  Id,Price__c from Materials__c WHERE id = :newMaterialPriceMap.keySet()];
        for (Materials__c material : materialList) {
                if(material.Price__c == null) {
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
        List<AssembliedBOM__c> assembledBOMs= [Select id,BOM__c from AssembliedBOM__c where BOM__c in :newBom];
        update assembledBOMs;
		*/
    }
    
    /**
    * Method to update the material price when bom is getting deleted.
    * 
    * */
    public static void UpdateMaterialPriceOnDelete(List<BOM__c> delBom) {
        
        Map<Id,Decimal> materialPriceMap= new Map<Id,Decimal>();
        for(Bom__c bom : delBom) {
            Decimal price= 0.0;
            if(materialPriceMap.get(bom.ProductID__c) != null) {
                price+= materialPriceMap.get(bom.ProductID__c);
            }
            if(bom.BomPrice__c != null) {
                price+= bom.BomPrice__c;
            }
            materialPriceMap.put(bom.ProductID__c,price);
        }
        
        List<Materials__c> materialList = [SELECT  Id,Price__c from Materials__c WHERE id = :materialPriceMap.keySet()];
        
        for (Materials__c material : materialList) {
            if(material.Price__c != null && (material.Price__c != 0 || material.Price__c != 0.0)){
                material.Price__c -= materialPriceMap.get(material.Id);
            }
        }
        update materialList; 
    }
    
    public static void UpdatePriceInSubAssembly(Set<ID> subAssemblyIDs) {
        
        List<SubAssembly__c> subAssemblyList= [Select id,Price__c,(select id,SubAssemblyPrice__c from Assemblied_BOMs__r) from SubAssembly__c where id in :subAssemblyIDs];
        for(SubAssembly__c subAssembly : subAssemblyList) {
            List<AssembliedBOM__c> assembledBOMs= subAssembly.Assemblied_BOMs__r;
            decimal subAssemblyPrice= 0.0;
            for(AssembliedBOM__c record : assembledBOMs) {
                subAssemblyPrice+= record.SubAssemblyPrice__c;
            }
            subAssembly.Price__c= subAssemblyPrice;
        }
        update subAssemblyList;
    }
    
    public static void UpdatePriceInMaterials(Set<ID> materialIDs) {
        
        List<Materials__c> materialList= [Select id,Price__c,(select id,BomPrice__c from BOM__r),
                                          (Select id,SubAssemblyBOMPrice__c from Components__r) from Materials__c where id in :materialIDs];
        for(Materials__c material : materialList) {
            List<BOM__c> boms= material.BOM__r;
            List<SubAssemblyBOM__c> subAssemblies= material.Components__r;
            decimal bomPrice= 0.0;
            decimal subAssemblyPrice= 0.0;
            for(BOM__c record : boms) {
                bomPrice+= record.BomPrice__c;
            }
            for(SubAssemblyBOM__c record : subAssemblies) {
                subAssemblyPrice+= record.SubAssemblyBOMPrice__c;
            }
            material.Price__c= bomPrice + subAssemblyPrice;
        }
        update materialList;
    }
        
}