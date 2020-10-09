/*
* Class to populate the custom BOM Related List for Material Object
*/
public class MaterialsRelatedListController {
    
    /*
* Wrapper class to send back the BOM data to component.
*/
    public class BOMDetailsWrapper {
        
        @auraEnabled
        public String categoryType;
        
        @auraEnabled
        public String catDisplayName;
        
        @auraEnabled
        public List<Bom__c> bomList;
        
        @auraEnabled
        public String ownerName;
        
        @auraEnabled
        public String parentName;
        
        @auraEnabled
        public String recordURL;
        
        @auraEnabled
        public List<String> subCategoryList;
        
        @auraEnabled
        public List<SubAssemblyBOM__c> subAssemblyBOMList;
        
        @auraEnabled
        public integer valueCount;
        
        @auraEnabled
        public String subAssemblyName;
        
        @auraEnabled
        public boolean isRMGSupplied;
        
        public BOMDetailsWrapper(String categoryType,List<Bom__c> bomList,List<String> subCategoryList,List<SubAssemblyBOM__c> subAssemblyBOMList) {
            this.categoryType = categoryType;
            this.bomList = bomList;
            this.subCategoryList = subCategoryList;
            if(categoryType.contains('~')) {
                this.catDisplayName = categoryType.substring(0, categoryType.indexOf('~'));
            }
            else {
                this.catDisplayName = categoryType;
            }
            this.subAssemblyBOMList= subAssemblyBOMList;
        }
        
    }
    
    
    /*
* Method that fetch the BOM details for the passed Material
*/
    @auraEnabled
    public static List<BOMDetailsWrapper> fetchBOMDetails(String materialId){
        
        //Map<String,Object> responseValue = new Map<String,Object>();
        List<BOMDetailsWrapper> wrapperList = populateValues(materialId,null);
        wrapperList= populateSubAssemblies(materialId,wrapperList);
        return wrapperList;
    }
    
    /*
*	Helper method to populate the sub assembly values
*/
    public static List<BOMDetailsWrapper> populateSubAssemblies(String materialId,List<BOMDetailsWrapper> wrapperList) {
        
        //List<SubAssembly__c> subAssemblyList = new List<SubAssembly__c>();
        //List<ID> subAssemblyIDs = new List<ID>();
        List<SubAssemblyBOM__c> subAssemblyBOMList = new List<SubAssemblyBOM__c>();
        List<Materials__c> materialList = [Select ID,Name,
                                           (Select ID,Name,Sub_Assembly_Quantity__c,Sub_Assembly__c,
                                            SubAssemblyName__c,SubAssemblyID__c,SupplierName__c,SubAssemblyBOMPrice__c from Components__r order by Name ),
                                           owner.Name from Materials__c where id = :materialId];
        if(materialList != null && materialList.size() > 0) {
            subAssemblyBOMList = materialList.get(0).Components__r;
            for(SubAssemblyBOM__c subAssemblyBOM: subAssemblyBOMList) {
                subAssemblyBOM.SubAssemblyURL__c= '/lightning/r/SubAssembly__c/'+subAssemblyBOM.Sub_Assembly__c+'/view';
            }
        }
        
        BOMDetailsWrapper wrapper= new BOMDetailsWrapper('Sub Assembly~SA',new List<Bom__c>(),null,subAssemblyBOMList);
        wrapper.valueCount= subAssemblyBOMList.size();
        wrapperList.add(wrapper);
        return wrapperList;
    }
    
    /*
*	Helper method to populate the values in wrapper class
*/
    public static List<BOMDetailsWrapper> populateValues(String materialId,String subAssemblyId) {
        
        Map<String,List<bom__c>> catMapping = new Map<String,List<bom__c>>();
        List<String> categoryPickListValues = getPickListValuesIntoList();
        List<BOMDetailsWrapper> wrapperList = new List<BOMDetailsWrapper>();
        Map<Id,String> bomSubAssembly= new Map<Id,String>();
        boolean isRMGSupplied= false;
        
        // get the dependent picklist values and assign here.
        Map<String, List<String>> dependentPickListValues = MaterialsRelatedListHelper.getDependentPicklistValues(Part_Detail__c.Sub_Category__c);
        
        for(String category:categoryPickListValues) {
            wrapperList.add(new BOMDetailsWrapper(category,new List<bom__c>(),dependentPickListValues.get(category),null));
            catMapping.put(category,new List<bom__c>());
        }
        
        List<Materials__c> materialList = new List<Materials__c>();
        List<bom__c> bomList = new List<bom__c>();
        SubAssembly__c parentSubAssembly= new SubAssembly__c();
        Map<Id,Decimal> bomSubQuantityMap= new Map<Id,Decimal>();
        Map<Id,Decimal> bomSubQuantityPriceMap= new Map<Id,Decimal>();
        if(String.isNotEmpty(materialId)) {
        	materialList = [Select ID,Name,(select ID,Category__c,Name,ProductID__c,Sub_Category__c,Part_Detail_ID__c,Part_Detail_ID__r.Name,
                                            MeasurementUnit__c,Part_Code__c,Part_Description__c,QuantityUnit__c,FinishedProductName__c,PartDetailName__c,
                                            Total_Quantity__c,Assembly_Quantity__c,Assembly_Price__c,BomPrice__c from bom__r order by Name ),owner.Name from Materials__c where id = :materialId];
        }
        else if(String.isNotEmpty(subAssemblyId)) {
            List<AssembliedBOM__c> assemblyBOMList= [Select id,BOM__c,SUBQuantity__c,SubAssemblyPrice__c from AssembliedBOM__c where SubAssembly__c= :subAssemblyId];
            List<Id> bomIds= new List<Id>();
            for(AssembliedBOM__c record : assemblyBOMList) {
                bomIds.add(record.BOM__c);
                bomSubQuantityMap.put(record.BOM__c,record.SUBQuantity__c);
                bomSubQuantityPriceMap.put(record.BOM__c,record.SubAssemblyPrice__c);
            }
            bomList = [Select ID,owner.name,Category__c,Name,ProductID__c,Sub_Category__c,Part_Detail_ID__c,Part_Detail_ID__r.Name,
                       MeasurementUnit__c,Part_Code__c,Part_Description__c,QuantityUnit__c,FinishedProductName__c,PartDetailName__c from bom__c where id in:bomIds order by Name];
            parentSubAssembly= [Select id,name,owner.Name,Make_Supplier__c
                                from SubAssembly__c where id= :subAssemblyId];
            if(parentSubAssembly.Make_Supplier__c == System.Label.RMGSupplierRecordID) {
                isRMGSupplied= true;
            }
        }
        if(materialList != null && materialList.size() > 0) {
            bomList = materialList.get(0).bom__r;
        }
        if(String.isEmpty(subAssemblyId)) {
            //bomSubAssembly= fetchBOMSubAssembliesRelation(materialId);
            bomList= fetchBOMsfromSubAssembly(materialId,bomList,bomSubQuantityMap,bomSubQuantityPriceMap);
            bomSubAssembly= fetchBOMSubAssembliesRelation(bomList);
        }
        for(bom__c bom: bomList) {
            bom.BomURL__c= '/lightning/r/BOM__c/'+bom.id+'/view';
            bom.PartDetailURL__c= '/lightning/r/Part_Detail__c/'+bom.Part_Detail_ID__c+'/view';
 			bom.RelatedSubAssemblies__c= bomSubAssembly.get(bom.Id);
            bom.Assembly_Quantity__c= (bomSubQuantityMap.get(bom.Id) == null)?0.0:bomSubQuantityMap.get(bom.Id);
            if(String.isNotEmpty(materialId) && (bom.ProductID__c == materialId)) {
                decimal subAssemblyPrice= (bomSubQuantityPriceMap.get(bom.Id) == null)?0.0:bomSubQuantityPriceMap.get(bom.Id);
            	bom.Assembly_Price__c= subAssemblyPrice + bom.BomPrice__c;
            }
            else {
            	bom.Assembly_Price__c= (bomSubQuantityPriceMap.get(bom.Id) == null)?0.0:bomSubQuantityPriceMap.get(bom.Id);
            }
            bom.Total_Quantity__c= (bom.QuantityUnit__c == null)?bom.Assembly_Quantity__c :bom.QuantityUnit__c + bom.Assembly_Quantity__c;
            if(catMapping.get(bom.Category__c) != null) {
            	catMapping.get(bom.Category__c).add(bom);
            }
        }
        for(BOMDetailsWrapper bom: wrapperList) {
            bom.bomList= catMapping.get(bom.categoryType);
            bom.valueCount= bom.bomList.size();
            if(materialList != null && materialList.size() > 0) {
                bom.ownerName= materialList.get(0).owner.Name;
                bom.parentName= materialList.get(0).name;
            } 
            else {
                bom.ownerName= parentSubAssembly.owner.Name;
                //bom.parentName= parentSubAssembly.Material__r.Name;
                bom.subAssemblyName= parentSubAssembly.Name;
                bom.isRMGSupplied= isRMGSupplied;
            }
        }
                
        return wrapperList;
    }
    
    public static List<BOM__c> fetchBOMsfromSubAssembly(String materialId,List<BOM__c> bomLists,Map<Id,Decimal> bomSubQuantityMap,
                                                       Map<Id,Decimal> bomSubQuantityPriceMap) {
    
        List<BOM__c> uniqueBOMs= new List<BOM__c>();
        List<Id> subAssemblyIds= new List<Id>();
        List<Id> bomIds= new List<Id>();
        //Map<Id,Decimal> bomQuantityInAssembly= new Map<Id,Decimal>();
        List<SubAssemblyBOM__c> subAssemblyBOMs= [select id,Sub_Assembly__c,Sub_Assembly_Quantity__c from SubAssemblyBOM__c
                                                  where Material__c=:materialId];
        for(SubAssemblyBOM__c subAssemblyBOM : subAssemblyBOMs) {
            subAssemblyIds.add(subAssemblyBOM.Sub_Assembly__c);
        }
        List<AssembliedBOM__c> assebmliedBOMs= [Select id,BOM__c,SUBQuantity__c,SubAssemblyPrice__c from AssembliedBOM__c where SubAssembly__c in :subAssemblyIds];
        for(AssembliedBOM__c assebmliedBOM : assebmliedBOMs) {
            bomIds.add(assebmliedBOM.BOM__c);
            if(bomSubQuantityMap.get(assebmliedBOM.BOM__c) != null) {
                bomSubQuantityMap.put(assebmliedBOM.BOM__c,(bomSubQuantityMap.get(assebmliedBOM.BOM__c)+assebmliedBOM.SUBQuantity__c));
            }
            else {
        		bomSubQuantityMap.put(assebmliedBOM.BOM__c,assebmliedBOM.SUBQuantity__c);        
            }
            if(bomSubQuantityPriceMap.get(assebmliedBOM.BOM__c) != null) {
                bomSubQuantityPriceMap.put(assebmliedBOM.BOM__c,(bomSubQuantityPriceMap.get(assebmliedBOM.BOM__c)+assebmliedBOM.SubAssemblyPrice__c));
            }
            else {
        		bomSubQuantityPriceMap.put(assebmliedBOM.BOM__c,assebmliedBOM.SubAssemblyPrice__c);        
            }
        }
        List<Bom__c> boms= [select ID,Category__c,Name,ProductID__c,Sub_Category__c,Part_Detail_ID__c,Part_Detail_ID__r.Name,
                            MeasurementUnit__c,Part_Code__c,Part_Description__c,QuantityUnit__c,FinishedProductName__c,PartDetailName__c,
                            Total_Quantity__c,Assembly_Quantity__c,bomPrice__c from bom__c where id in :bomIds];
        List<Id> genBOMIds= new List<Id>();
        for(Bom__c record: bomLists) {
            genBOMIds.add(record.Id);
        }
        for(bom__c record:boms) {
            if(genBOMIds.contains(record.Id)) {
                continue;
            }
            bomLists.add(record);
        }
        system.debug('in method: '+bomSubQuantityMap);
        return bomLists;
    }
    
    public static Map<Id,String> fetchBOMSubAssembliesRelation(List<Bom__c> bomList ) {//String materialId) {
        
        Map<Id,String> returnValue= new Map<Id,String>();
        //List<Bom__c> bomList= [Select id from Bom__c where ProductID__c = :materialId];
        List<Id> bomIds= new List<Id>();
        for(Bom__c bom:bomList) {
           bomIds.add(bom.Id); 
        }
        List<AssembliedBOM__c> assembliedBOMs= [Select id,BOM__c,SubAssembly__c,SubAssembly__r.Name,SubAssemblyPrice__c 
                                                from AssembliedBOM__c where BOM__c in :bomIds];
        for(AssembliedBOM__c record : assembliedBOMs) {
            String subAssemblyNames= (returnValue.get(record.BOM__c) != null)?returnValue.get(record.BOM__c):'';
            subAssemblyNames= (subAssemblyNames=='')?record.SubAssembly__r.Name:subAssemblyNames+ ';' + record.SubAssembly__r.Name;
            returnValue.put(record.BOM__c,subAssemblyNames); 
        }
        
        return returnValue;
    }
    /*
* Method to populate the pickList values for the Category field in Bom object
**/
    public static List<String> getPickListValuesIntoList(){
        List<String> pickListValuesList= new List<String>();
        Schema.DescribeFieldResult fieldResult = Bom__c.Category__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            pickListValuesList.add(pickListVal.getLabel());
        }     
        return pickListValuesList;
    }
    
    @auraEnabled
    public static List<String> fetchParams(String subCategory) {
        
        List<String> paramNames = new List<String>();
        List<ConfigMaterial__c> configRecords= [Select ParamName1__c,ParamName2__c,ParamName3__c,ParamName4__c,
                                                ParamName5__c,ParamName6__c,ParamName7__c,ParamName8__c from ConfigMaterial__c where SubCategory__c= :subCategory];
        for(ConfigMaterial__c conf: configRecords) {
            paramNames.add(conf.ParamName1__c);
            paramNames.add(conf.ParamName2__c);
            paramNames.add(conf.ParamName3__c);
            paramNames.add(conf.ParamName4__c);
            paramNames.add(conf.ParamName5__c);
            paramNames.add(conf.ParamName6__c);
            paramNames.add(conf.ParamName7__c);
            paramNames.add(conf.ParamName8__c);
        }
        return paramNames;
    }
    
    @auraEnabled
    public static BOM__c saveBOM(BOM__c newBom){
        
        insert newBom;
        newBom = [Select Id,Name From BOM__c Where Id =:newBom.Id];
        return newBom;
    }
    
    @auraEnabled
    public static Part_Detail__c savePartDetail(Part_Detail__c newPartDetail){
        try {
            insert newPartDetail;
        } catch (Exception e) {
            String errorMessage = e.getMessage();
            if(errorMessage.contains('~')) {
                errorMessage= 'Please follow the format <paramDesc>~<paramCode> Eg: Fixed~F, while filling parameter values';
            }
            else if(errorMessage.contains('DUPLICATE_VALUE') && errorMessage.contains('Part_Code__c')) {
                errorMessage= 'Part Detail already exist. Please select this from the lookup in previous modal';
            }
            throw new AuraHandledException(errorMessage);  
        }
        newPartDetail = [Select Id,Name,Part_Code__c From Part_Detail__c Where Id =:newPartDetail.Id];
        return newPartDetail;
    }
    
    @auraEnabled
    public static List<BOMDetailsWrapper> fetchBOMInSubAssembly(String subAssemblyID) {
        
        Map<String,Object> responseValue = new Map<String,Object>();
        List<BOMDetailsWrapper> wrapperList = populateValues(null,subAssemblyID);
        return wrapperList;
        
    }
    
    @auraEnabled
    public static SubAssembly__c saveSubAssembly(SubAssembly__c newSubAssembly) {
        
        insert newSubAssembly;
        
        SubAssembly__c newSub= [Select id,name from SubAssembly__c where id = :newSubAssembly.Id limit 1];
        return newSub;
    }
    
}