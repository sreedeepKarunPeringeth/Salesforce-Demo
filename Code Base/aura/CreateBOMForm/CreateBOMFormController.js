({    
    closeModal : function(component, event, helper) {
        component.destroy();
    },
    
    saveBom : function(component, event, helper) {
        document.getElementsByClassName("duplicateBomError")[0].style.display= "none";  
        document.getElementsByClassName("errorBOM")[0].style.display= "none";
        var action = component.get("c.saveBOM");
        var bomToInsert = component.get("v.bomInstance");
        bomToInsert.Category__c = component.get("v.categoryType");
        bomToInsert.ProductID__c = component.get("v.parentId");
        bomToInsert.MakeSupplier__c = component.find("supplierId").get("v.value");
        bomToInsert.UnitPrice__c = component.find("UnitPriceId").get("v.value");
        if(component.get("v.subAssembly") != null || component.get("v.subAssembly") != '') {
            bomToInsert.SubAssembly__c = component.get("v.subAssembly");
        }
        
        //var measurementUnit= component.find("measurementUnitId").get("v.value");
        //bomToInsert.MeasurementUnit__c= measurementUnit;
        
        if(!bomToInsert.Part_Detail_ID__c) {
            document.getElementsByClassName("errorBOM")[0].style.display= "block";
            return -1;
        }
        action.setParams({newBom:bomToInsert});
        action.setCallback(this, function(response) {
            var state = response.getState();
            var result = response.getReturnValue();
            let errors = response.getError();
            
            
            // Display the message
            if(state=="SUCCESS") {
                
                component.destroy();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "type" : "success",
                    "message": "BOM ("+result.Name+") created successfully!"
                });
                toastEvent.fire();
                var appEvent = $A.get("e.c:refreshRelatedList");
                appEvent.fire();
                
                
            }
            // Retrieve the error message sent by the server
            
            else  {
                document.getElementsByClassName("duplicateBomError")[0].style.display= "block";
                
            }
            
        });
        $A.enqueueAction(action);
    },
    createPartDetail : function(component, event, helper) {
        
        document.getElementsByClassName("errorBOM")[0].style.display= "none";
        $A.createComponent(
            'c:CreatePartDetail',
            {'categoryType':component.get('v.categoryType'),
             'categoryDisplayName':component.get('v.categoryDisplayName'),
             'ownerName': component.get('v.ownerName'),
             'subCategoryList':component.get('v.subCategoryList')
            },
            function(content, status, errorMessage) {
                if(status === 'SUCCESS') {
                    component.find('partDetailModal').set('v.body',content);
                }
            }
        );
    }
})