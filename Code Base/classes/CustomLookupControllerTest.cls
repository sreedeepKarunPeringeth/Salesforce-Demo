@isTest
public class CustomLookupControllerTest {

     @testSetup
    static void setup() {
        Part_Detail__c pd = new Part_Detail__c(Category__c='Electronic Item~E');
        insert pd;
    }
    public static testmethod void testFetchRecordsWithoutValue() {
        Test.startTest();
        List<object> result = CustomLookupController.fetchRecords('Part_Detail__c','Category__c',null,'Item','');
        system.assert(result != null,'No result for the search');
        Test.stopTest();
    }
    
    public static testmethod void testFetchRecordsWithValue() {
        Test.startTest();
        Part_Detail__c pd = new Part_Detail__c(Category__c='Mechanical Item~M');
        insert pd;
        List<object> result = CustomLookupController.fetchRecords('Part_Detail__c','Category__c',null,'Mech',pd.Id);
        system.assert(result != null,'No result for the search');
        Test.stopTest();
    }
}