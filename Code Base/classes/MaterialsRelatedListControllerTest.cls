@isTest
public class MaterialsRelatedListControllerTest {
    
    @testSetup
    static void setup() {
        
        List<Materials__c> materialList = new List<Materials__c>();
        Materials__c material = new Materials__c(RMG_Product_Code__c='Material1',Product_Type__c='Position Transmitter');
        materialList.add(material);
        insert materialList;
        
        List<Bom__c> bomList = new List<Bom__c>();
        Bom__c bom1 = new Bom__c(QuantityUnit__c=10,ProductID__c=materialList[0].id,Category__c='Electronic Item~E');
        Bom__c bom2 = new Bom__c(QuantityUnit__c=20,ProductID__c=materialList[0].id,Category__c='Electronic Item~E');
        bomList.add(bom1);
        bomList.add(bom2);
        
        insert bomList;    
        
        configMaterial__c configMaterial = new configMaterial__c(subcategory__c='Wire~WR',ParamName1__c='WR Type'); 
        insert configMaterial;
        
        //List<SubAssembly__c> subAssemblyList= new List<SubAssembly__c>();
        SubAssembly__c subAssembly= new SubAssembly__c(SubAssemblyID__c='Test subAssembly',Name='SubAssembly1');
        insert subAssembly;
        
        AssembliedBOM__c assembledBOM= new AssembliedBOM__c(BOM__c=bomList.get(0).Id,SubAssembly__c=subAssembly.Id,SUBQuantity__c=5);
        insert assembledBOM;
        
    }
    
    public static testmethod void testFetchBOMInSubAssembly(){
        Test.startTest();
        SubAssembly__c subAssembly = [Select id from SubAssembly__c where Name='SubAssembly1' Limit 1];
        List<object> result = MaterialsRelatedListController.fetchBOMInSubAssembly(subAssembly.Id);
        system.debug('result: '+ result);
        system.assert(result.size() > 0, 'No material found');
        Test.stopTest();
    }
    
    public static testmethod void testFetchBOMDetails(){
        Test.startTest();
        Materials__c material = [Select id from Materials__c where RMG_Product_Code__c='Material1' Limit 1];
        List<object> result = MaterialsRelatedListController.fetchBOMDetails(material.id);
        system.debug('result: '+ result);
        system.assert(result.size() > 0, 'No material found');
        Test.stopTest();
    }
    
    public static testmethod void testSavePartDetail() {
        Test.startTest();
        Part_Detail__c pd = new Part_Detail__c(Category__c='Electronic Item~E');
        Part_Detail__c result = MaterialsRelatedListController.savePartDetail(pd);
        system.assert(result != null,'part detail not inserted');
        Test.stopTest();
    }
    
    public static testmethod void testSaveBOM() {
        Test.startTest();
        BOM__c pd = new BOM__c(Category__c='Electronic Item~E');
        BOM__c result = MaterialsRelatedListController.saveBOM(pd);
        system.assert(result != null,'BOM not inserted');
        Test.stopTest();
    }
    
    public static testmethod void testFetchParams() {
        Test.startTest();
        List<configMaterial__c> configMaterialRecords = [select id,subCategory__c from configMaterial__c limit 1];
        List<String> result = MaterialsRelatedListController.fetchParams(configMaterialRecords.get(0).subCategory__c);
        system.assert(result.size() > 0,'No records configured in configMaterial object');
        Test.stopTest();
    }
}