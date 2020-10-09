public class BomInsertService {
    
    
    /**check bom duplicate before inserting a bom record **/
    
    public  static void preventDuplicateBomOnInsert(List<BOM__c> newBom) {   
        for(BOM__c bom : newBom) {
            if(bom.ProductID__c !=null && bom.Part_Detail_ID__c != null && bom.MakeSupplier__c  != null) {
                bom.MaterialPartName__c=  bom.MakeSupplier__c + '-'  +  bom.Part_Detail_ID__c  + '-' + bom.ProductID__c;
            } 
        }   
    }
    
    /**check bom duplicate before updating a bom record **/
    public static void preventDuplicateBomOnUpdate(List<BOM__c> newBom) {
        
        for (BOM__c bom: newBom) {
 			//if(bom.ProductID__c !=null && bom.Part_Detail_ID__c != null && bom.MakeSupplier__c  != null) {
               bom.MaterialPartName__c    =  bom.MakeSupplier__c + '-'  +  bom.Part_Detail_ID__c + '-' + bom.ProductID__c;
            //} 
        }      
    }
}