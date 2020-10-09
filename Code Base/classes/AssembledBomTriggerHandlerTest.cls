@isTest
public class AssembledBomTriggerHandlerTest {
    @testSetup
    static void setup() {
        /* creating bom and subassembly record for test*/
        List<BOM__c> bomList = new List<BOM__c>();   
        List<SubAssembly__c> subAssemblyList = new List<SubAssembly__c>();
        
        
        for (integer i  = 0;i<4;i++){
            bomList.add(new BOM__c(UnitPrice__c= 20,QuantityUnit__c= 2));
        }
        
        for (integer i  = 0;i<4;i++){
            subAssemblyList.add(new SubAssembly__c(Name = 'TestSubAssembly'+i));
        }
        insert bomList;
        insert subAssemblyList;
        
        /*assemblied bom records for testimng*/
        List<AssembliedBOM__c> assembliedBomList = new List<AssembliedBOM__c>();
        
        AssembliedBOM__c assembliedBom0 = new AssembliedBOM__c(Name = 'Assembliedbom1', SubAssembly__c=subAssemblyList[0].id, BOM__c=bomList[0].id, SUBQuantity__c = 1);
        AssembliedBOM__c assembliedBom1= new AssembliedBOM__c(Name = 'Assembliedbom2', SubAssembly__c=subAssemblyList[1].id,BOM__c=bomList[1].id, SUBQuantity__c = 2);
        AssembliedBOM__c assembliedBom2= new AssembliedBOM__c(Name = 'Assembliedbom3', SubAssembly__c=subAssemblyList[2].id, BOM__c=bomList[2].id,SUBQuantity__c = 3);
        
        assembliedBomList.add(assembliedBom0);
        assembliedBomList.add(assembliedBom1);
        assembliedBomList.add(assembliedBom2);
        
        insert assembliedBomList;
        
        /*updating a record*/
        AssembliedBOM__c AssembliedBom2Update = [Select id,SUBQuantity__c from AssembliedBOM__c where SubAssembly__c= :subAssemblyList[1].id];
        AssembliedBom2Update.SUBQuantity__c = 3;
        update AssembliedBom2Update;
        /*deleting a record*/
        AssembliedBOM__c AssembliedBom3Delete = [Select id from AssembliedBOM__c where SubAssembly__c= :subAssemblyList[2].id];
        delete AssembliedBom3Delete;
        
    }
    public testmethod static void testOnAfterInsert() {
        
        Test.startTest();
        SubAssembly__c TestSubAssembly0   = [Select id,Price__c from SubAssembly__c where Name='TestSubAssembly0'];
        System.assertEquals(TestSubAssembly0.Price__c,20);
        Test.stopTest();
        
    }
    public testmethod static void testOnAfterUpdate() {
        Test.startTest();
        SubAssembly__c TestSubAssembly1   = [Select id,Price__c from SubAssembly__c where Name='TestSubAssembly1'];
        System.assertEquals(TestSubAssembly1.Price__c,60);
        Test.stopTest();
        
    }
    
    public testmethod static void testOnAfterDelete()  {
        Test.startTest();
        SubAssembly__c TestSubAssembly2   = [Select id,Price__c from SubAssembly__c where Name='TestSubAssembly2'];
        System.assertEquals(TestSubAssembly2.Price__c,0);
        Test.stopTest();
    }
    
}