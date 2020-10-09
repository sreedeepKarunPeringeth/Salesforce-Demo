({
    createBOMRecord : function(component,event,helper) {
       $A.createComponent(
            'c:CreateBOMForm',
            {'parentId':component.get('v.parentId'),
             'categoryType':component.get('v.categoryType'),
             'categoryDisplayName':component.get('v.categoryDisplayName'),
             'parentName':component.get('v.parentName'),
             'ownerName': component.get('v.ownerName'),
             'subCategoryList':component.get('v.subCategoryList'),
             'subAssembly':component.get('v.subAssembly'),
             'subAssemblyName':component.get('v.subAssemblyName')
            },
             function(content, status, errorMessage) {
           		if(status === 'SUCCESS') {
                    component.find('popModalModal').set('v.body',content);
       			}
       		}
        );
    },
    createSubAssemblyBOMRecord : function(component,event,helper) {
       $A.createComponent(
            'c:CreateSubAssemblyBOMForm',
            {'parentId':component.get('v.parentId'),
             'parentName':component.get('v.parentName'),
             'ownerName': component.get('v.ownerName')
            },
             function(content, status, errorMessage) {
           		if(status === 'SUCCESS') {
                    component.find('subAssemblyBOMModal').set('v.body',content);
       			}
       		}
        );
    },
    createSubAssemblyRecord : function(component,event,helper) {
       $A.createComponent(
            'c:CreateSubAssemblyForm',
            {'parentId':component.get('v.parentId'),
             'parentName':component.get('v.parentName'),
             'ownerName': component.get('v.ownerName')
            },
             function(content, status, errorMessage) {
           		if(status === 'SUCCESS') {
                    component.find('popModalModal').set('v.body',content);
       			}
       		}
        );
    },
	/**createRecord : function(component, event, helper) {
        console.log('in js');
        var parentRecordId = component.get('v.parentId');
        var categoryType = component.get('v.categoryType');
		var createBOMEvent = $A.get("e.force:createRecord");
		createBOMEvent.setParams({
    		"entityApiName": "BOM__c",
    		"defaultFieldValues": {
                "ProductID__c": parentRecordId,
        		'Category__c' : categoryType
    		}
		});
		createBOMEvent.fire();		
	},
    */
    init : function(component,event,helper) {
        
        component.set("v.subAssemblyColumns",[
                {label: 'SubAssembly Name',fieldName:'SubAssemblyURL__c',type:'url',
                 typeAttributes:{label: {fieldName:'SubAssemblyName__c'},target:'_self'}},
                {label: 'SubAssembly ID',fieldName:'SubAssemblyID__c',type:'String'},
                {label: 'Make/Supplier',fieldName:'SupplierName__c',type:'String'},
                {label: 'Quantity',fieldName:'Sub_Assembly_Quantity__c',type:'String'},
            	{label: 'Price',fieldName:'SubAssemblyBOMPrice__c',type:'currency'}
        	]);
        
        if(component.get("v.showCreateButtons")) {
        	
            component.set("v.columns",[
                {label: 'BOM ID No',fieldName:'BomURL__c',type:'url',
                 typeAttributes:{label: {fieldName:'Name'},target:'_self'}},
                {label: 'Sub Assembly',fieldName:'RelatedSubAssemblies__c',type:'String'},
                {label: 'Sub-Category',fieldName:'Sub_Category__c',type:'String'},
                {label: 'Part Detail ID',fieldName:'PartDetailURL__c',type:'url',
                 typeAttributes:{label: {fieldName:'PartDetailName__c'},target:'_self'}},
                {label: 'Part Code',fieldName:'Part_Code__c',type:'String'},
                //{label: 'Part Description',fieldName:'Part_Description__c',type:'String'},
                {label: 'GEN-Quantity',fieldName:'QuantityUnit__c',type:'String'},
                {label: 'SA-Quantity',fieldName:'Assembly_Quantity__c',type:'String'},
                {label: 'Total Quantity',fieldName:'Total_Quantity__c',type:'String'},
                {label: 'Total Price',fieldName:'Assembly_Price__c',type:'currency'},
                {label: 'Measurement Unit',fieldName:'MeasurementUnit__c',type:'String'}
        	]);
              
        }
        else {
            
            component.set("v.columns",[
                {label: 'BOM ID No',fieldName:'BomURL__c',type:'url',
                 typeAttributes:{label: {fieldName:'Name'},target:'_self'}},
                //{label: 'Sub Assembly',fieldName:'RelatedSubAssemblies__c',type:'String'},
                {label: 'Sub-Category',fieldName:'Sub_Category__c',type:'String'},
                {label: 'Part Detail ID',fieldName:'PartDetailURL__c',type:'url',
                 typeAttributes:{label: {fieldName:'PartDetailName__c'},target:'_self'}},
                {label: 'Part Code',fieldName:'Part_Code__c',type:'String'},
                //{label: 'Part Description',fieldName:'Part_Description__c',type:'String'},
                {label: 'Quantity',fieldName:'Assembly_Quantity__c',type:'String'},
                {label: 'Price',fieldName:'Assembly_Price__c',type:'currency'},
                {label: 'Measurement Unit',fieldName:'MeasurementUnit__c',type:'String'}
        	]);
        }
    }
})