@isTest
public class BomTriggerHandlerTest {
    @testSetup
    static void setup() {
        List<Materials__c> materialList = new List<Materials__c>();        
        for (integer i = 1;i  <5;i++) {
            materialList.add(new Materials__c(RMG_Product_Code__c='TestMaterial'+i,Product_Type__c='Position Transmitter'));
        }
        insert materialList;

        Part_Detail__c partDetailTest = new Part_Detail__c(Category__c='Consumables~C',MeasurementUnit__c = 'nos',Sub_Category__c= ' '	,Parameter_Value_1__c  ='Test~t'	,Parameter_Value_2__c = 'Test2~t2');
        
     /*   List <Account> AccountList= new List<Account>();
        for (integer i= 1;i<2;i++) {
            Account Testaccount = new Account(Name = 'TestAccount' + i,RecordTypeId = '0120T0000000LiXQAU');
                
                }*/
        
        
        List<BOM__c> bomList = new List<BOM__c>();    
        BOM__c bom1 = new BOM__c(UnitPrice__c= 20,QuantityUnit__c= 2,ProductID__c=materialList[0].id );
        BOM__c bom2 = new BOM__c(UnitPrice__c= 20,QuantityUnit__c= 2,ProductID__c=materialList[1].id );
        BOM__c bom3 = new BOM__c(UnitPrice__c= 20,QuantityUnit__c= 2,ProductID__c=materialList[2].id );
        BOM__c bom4 = new BOM__c(UnitPrice__c= 0,QuantityUnit__c= 2,ProductID__c=materialList[0].id );
        
        //test data for unique id change.
        BOM__c bom5 = new BOM__c(ProductID__c=materialList[3].id,Part_Detail_ID__c	= partDetailTest.id);
        
        bomList.add(bom1);
        bomList.add(bom2);
        bomList.add(bom3);
        bomList.add(bom4);
        bomList.add(bom5);
        
        
        insert bomList; 
        
    
        
        
        BOM__c bom2update = [Select id,UnitPrice__c,QuantityUnit__c from BOM__C where ProductID__c= :materialList[1].id];
        bom2update.UnitPrice__c  = 50;
        bom2update.QuantityUnit__c = 3;
        update bom2update;
        
        BOM__c bom3delete = [Select id from BOM__c where ProductID__c= :materialList[2].id];
        delete bom3delete;
        
        
        BOM__c bom6 = new BOM__c(ProductID__c=materialList[3].id,Part_Detail_ID__c	= partDetailTest.id);
        
        insert bom6;
        
    }
    
    public testmethod static void testOnAfterInsert() {
        
        Test.startTest();
        Materials__c TestMaterial1   = [Select id,Price__c from Materials__c where RMG_Product_Code__c='TestMaterial1'];
        System.assertEquals(TestMaterial1.Price__c,40);
        Test.stopTest();
        
    }
    
    public testmethod static void testOnAfterUpdate() {
        Test.startTest();
        Materials__c TestMaterial2   = [Select id,Price__c from Materials__c where RMG_Product_Code__c='TestMaterial2'];
        System.assertEquals(TestMaterial2.Price__c,150);
        Test.stopTest();
        
    }
    
    public testmethod static void testOnAfterDelete()  {
        Test.startTest();
        Materials__c TestMaterial3   = [Select id,Price__c from Materials__c where RMG_Product_Code__c='TestMaterial3'];
        System.assertEquals(TestMaterial3.Price__c,0);
        Test.stopTest();
    }
    
   /* public testmethod static void testonBeforeDelete() {
        Test.startTest();
    }        */

}