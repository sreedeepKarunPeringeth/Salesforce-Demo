public class AssembliedBOMService {
    
    /**
    * Method to update the material price when a new SubAssemblyBom is getting inserted.
    * 
    * */
    public  static void updateSubAssemblyPriceOnInsert(List<AssembliedBOM__c> assembliedBOMList) {
        
        Map<Id,Decimal> subAssemblyPriceMap = new Map<Id,Decimal>();
        
        for(AssembliedBOM__c assembliedBOM : assembliedBOMList) {
            Decimal price= 0.0;
            if(subAssemblyPriceMap.get(assembliedBOM.SubAssembly__c) != null) {
                price+= subAssemblyPriceMap.get(assembliedBOM.SubAssembly__c);
            }
            if(assembliedBOM.SubAssemblyPrice__c != null) {
                price+= assembliedBOM.SubAssemblyPrice__c;
            }
            subAssemblyPriceMap.put(assembliedBOM.SubAssembly__c,price);
        }
        
        List<SubAssembly__c> subAssemblyList= [Select id,Price__c from SubAssembly__c where id in :subAssemblyPriceMap.keyset()];
        
        for(SubAssembly__c subAssembly : subAssemblyList) {
            subAssembly.Price__c+= subAssemblyPriceMap.get(subAssembly.Id);
        }
        update subAssemblyList;
    }
    
    /**
    * Method to update the material price when SubAssemblyBom is getting updated.
    * 
    * */ 
    public static void updateSubAssemblyPriceOnUpdate(List<AssembliedBOM__c> oldAssembliedBOMList,List<AssembliedBOM__c> newAssembliedBOMList) {
        
        Map<Id,Decimal> newMaterialPriceMap= new Map<Id,Decimal>();
        Map<Id,Decimal> oldMaterialPriceMap= new Map<Id,Decimal>();
        
        for(AssembliedBOM__c bom : newAssembliedBOMList) {
            Decimal price= 0.0;
            if(newMaterialPriceMap.get(bom.SubAssembly__c) != null) {
                price+= newMaterialPriceMap.get(bom.SubAssembly__c);
            }
            if(bom.SubAssemblyPrice__c != null) {
                price+= bom.SubAssemblyPrice__c;
            }
            system.debug('new: '+price);
            newMaterialPriceMap.put(bom.SubAssembly__c,price);
        }
        
        for(AssembliedBOM__c bom : oldAssembliedBOMList) {
            Decimal price= 0.0;
            if(oldMaterialPriceMap.get(bom.SubAssembly__c) != null) {
                price+= oldMaterialPriceMap.get(bom.SubAssembly__c);
            }
            if(bom.SubAssemblyPrice__c != null) {
                price+= bom.SubAssemblyPrice__c;
            }
            system.debug('old: '+price);
            oldMaterialPriceMap.put(bom.SubAssembly__c,price);
        }
        
        List<SubAssembly__c> subAssemblyList= [Select id,Price__c from SubAssembly__c where id in :newMaterialPriceMap.keyset()];
        system.debug('subAssemblyList: '+subAssemblyList);
        for (SubAssembly__c subAssembly : subAssemblyList) {
                if(subAssembly.Price__c == null) {
                    subAssembly.Price__c = 0;
                }
                if(subAssembly.Price__c == 0 || subAssembly.Price__c == 0.0) {
                	subAssembly.Price__c += newMaterialPriceMap.get(subAssembly.Id);
                }
                else {
                	subAssembly.Price__c -= oldMaterialPriceMap.get(subAssembly.Id);
                	subAssembly.Price__c += newMaterialPriceMap.get(subAssembly.Id);    
                }
            //subAssembly.Price__c += newMaterialPriceMap.get(subAssembly.Id);
        }
        update subAssemblyList; 
    }
    
    /**
    * Method to update the material price when SubAssemblyBom is getting deleted.
    * 
    * */
    public static void UpdateSubAssemblyPriceOnDelete(List<AssembliedBOM__c> delAssemblyBom) {
        
        Map<Id,Decimal> materialPriceMap= new Map<Id,Decimal>();
        for(AssembliedBOM__c bom : delAssemblyBom) {
            Decimal price= 0.0;
            if(materialPriceMap.get(bom.SubAssembly__c) != null) {
                price+= materialPriceMap.get(bom.SubAssembly__c);
            }
            if(bom.SubAssemblyPrice__c != null) {
                price+= bom.SubAssemblyPrice__c;
            }
            materialPriceMap.put(bom.SubAssembly__c,price);
        }
        
        List<SubAssembly__c> subAssemblyList= [Select id,Price__c from SubAssembly__c where id in :materialPriceMap.keySet()];
        
        for (SubAssembly__c subAssembly : subAssemblyList) {
            if(subAssembly.Price__c != null && (subAssembly.Price__c != 0 || subAssembly.Price__c != 0.0)){
                subAssembly.Price__c -= materialPriceMap.get(subAssembly.Id);
            } 
        }
        update subAssemblyList;  
    }    
}