public with sharing class CustomLookupController {
 
    @AuraEnabled
    public static List<RecordsData> fetchRecords(String objectName, String filterField,String filterCategory, String searchString, String value) {
        try {
            List<RecordsData> recordsDataList = new List<RecordsData>();
            String query = 'SELECT Id,Part_Code__c, ' + filterField + ' FROM '+objectName;
            if(String.isNotBlank(value)) {
                query += ' WHERE Id = \''+ value + '\' ';
            } else {
                query += ' WHERE '+filterField+
                		' LIKE ' + '\'%' + String.escapeSingleQuotes(searchString.trim()) + '%\'';
            }
            if(String.isNotBlank(filterCategory)) {
               query += ' AND Category__c = \''+ String.escapeSingleQuotes(filterCategory.trim()) + '\' LIMIT 49999';
            }
            else {
                query += ' LIMIT 49999' ;
            }
	        for(SObject s : Database.query(query)) {
	            recordsDataList.add( new RecordsData((String)s.get(filterField), (String)s.get('id'), ((String)s.get('Part_Code__c'))) );
	        }
            return recordsDataList;
	    } catch (Exception err) {
	    	if ( String.isNotBlank( err.getMessage() ) && err.getMessage().contains( 'error:' ) ) {
                throw new AuraHandledException(err.getMessage().split('error:')[1].split(':')[0] + '.');
            } else {
                throw new AuraHandledException(err.getMessage());
            }
	    }
    }
 
    public class RecordsData {
        @AuraEnabled public String label;
        @AuraEnabled public String value;
        @AuraEnabled public String partCode;
        public RecordsData(String label, String value,String partCode) {
            this.label = label;
            this.value = value;
            this.partCode = partCode;
        }
    }
}