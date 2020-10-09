({
    
    handleError : function(component, event, helper) {
        console.log('handleError');
        var errorMessage = event.getParam("message");
        component.find('notifLib').showToast({
            "title": "Error in Sub Assembly Creation!",
            "message": "Sub Assembly already exist",
            "variant": "error"
        });
    },
    handleSubmit : function(component, event, helper) {
        console.log('handleSubmit');
        
    },
   handleSuccess : function(component, event, helper) {
        
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "type" : "success",
            "message": "Sub Assembly created successfully!"
        });
        toastEvent.fire();
        var param = event.getParams();
        var subAssemblyID = param.response.id;
        var appEvent = $A.get("e.c:passSubAssemblyID");
        appEvent.setParams({
            "subAssemblyID":subAssemblyID,
        });
        appEvent.fire();
        
        component.destroy();
    },
    
    closeModal : function(component, event, helper) {
        component.destroy();
    },
    
    checkForSupplier : function(component, event, helper) {
        
        console.log('notRMGSupplied: '+component.get('v.notRMGSupplied'));
        console.log('supplierID: '+component.find('supplierID').get('v.value'));
        console.log('customLabel: '+$A.get('$Label.c.RMGSupplierRecordID'));
        if (component.find('supplierID').get('v.value') == $A.get('$Label.c.RMGSupplierRecordID')) {
            component.set('v.notRMGSupplied',false);
        }
        else {
            component.set('v.notRMGSupplied',true);
        }
    }
})