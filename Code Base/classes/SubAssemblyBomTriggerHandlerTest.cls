@isTest
public class SubAssemblyBomTriggerHandlerTest {
    @testSetup
    static void setup() {       
        List<Materials__c> materialList = new List<Materials__c>();        
        for (integer i = 0;i  <4;i++) {
            materialList.add(new Materials__c(RMG_Product_Code__c='TestMaterial'+i,Product_Type__c='Position Transmitter'));
        }
        insert materialList;
        
        List<SubAssembly__c> SubAssemblyList = new List<SubAssembly__c>();        
        for (integer i = 0;i  <4;i++) {
            SubAssemblyList.add(new SubAssembly__c(Name  = 'TestSubAssemblyForTesting'+ i ,Price__c = 200));
        }
        insert SubAssemblyList;
        
        List<SubAssemblyBOM__c> SubAssemblyBomList = new List<SubAssemblyBOM__c>(); 
        
        SubAssemblyBOM__c bom0 = new SubAssemblyBOM__c( Sub_Assembly__c = SubAssemblyList[0].id,Sub_Assembly_Quantity__c = 2, Material__c =materialList[0].Id);
        SubAssemblyBOM__c bom1 = new SubAssemblyBOM__c( Sub_Assembly__c= SubAssemblyList[1].id,Sub_Assembly_Quantity__c =3, Material__c = materialList[1].Id);
        SubAssemblyBOM__c bom2 = new SubAssemblyBOM__c( Sub_Assembly__c= SubAssemblyList[2].id,Sub_Assembly_Quantity__c = 4, Material__c = materialList[2].Id);
        SubAssemblyBOM__c bom3 = new SubAssemblyBOM__c( Sub_Assembly__c= SubAssemblyList[3].id,Sub_Assembly_Quantity__c =2, Material__c = materialList[0].Id);  
        
        SubAssemblyBomList.add(bom0);
        SubAssemblyBomList.add(bom1);
        SubAssemblyBomList.add(bom2);
        SubAssemblyBomList.add(bom3);
        
        insert SubAssemblyBomList;
        
        SubAssemblyBOM__c SubAssemblybom2update = [Select Sub_Assembly_Quantity__c from SubAssemblyBOM__c where Material__c= :materialList[1].Id and Sub_Assembly_Quantity__c = 3];
        SubAssemblybom2update.Sub_Assembly_Quantity__c = 10;
        update SubAssemblybom2update;
        
        SubAssemblyBOM__c SubAssemblybom3delete = [Select id from SubAssemblyBOM__c where Material__c= :materialList[2].Id and Sub_Assembly_Quantity__c = 4];
        delete SubAssemblybom3delete;
    }
    
    public testmethod static void testOnAfterInsert() {
        Test.startTest();
        Materials__c TestMaterial   = [Select id,Price__c from Materials__c where RMG_Product_Code__c='TestMaterial0'];
        System.assertEquals(TestMaterial.Price__c,800);
        Test.stopTest();
        
    }
    
    public testmethod static void testOnAfterUpdate() {
        Test.startTest();
        Materials__c TestMaterial2   = [Select id,Price__c from Materials__c where RMG_Product_Code__c='TestMaterial1'];
        System.assertEquals(TestMaterial2.Price__c,2000);
        Test.stopTest();
    }
    public testmethod static void testOnAfterDelete()  {
        Test.startTest();
        Materials__c TestMaterial2   = [Select id,Price__c from Materials__c where RMG_Product_Code__c='TestMaterial2'];
        System.assertEquals(TestMaterial2.Price__c,0);
        Test.stopTest();
    }
}