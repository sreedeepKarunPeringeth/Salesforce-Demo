({
	closeModal : function(component, event, helper) {
		
        component.destroy();
	},
    
    handleSubmit : function(component, event, helper) {
		
        event.preventDefault(); // stop form submission
        var eventFields = event.getParam("fields");
        eventFields["AssembliedBOMID__c"] = component.get("v.bomID") +'-'+ eventFields["SubAssembly__c"];
        eventFields["BOM__c"]= component.get("v.bomID");
        component.find('assembliedBOMForm').submit(eventFields);
	},
    
    handleError : function (component,event,helper) {
        console.log(event.getParam("message"));
        if(component.get("v.bomID")) {
          component.find('notifLib').showToast({
                "title": "Error while selecting BOMs!",
                "message": "The selected BOM is already a part of the sub assembly.",
                "variant": "error"
        	});         
        }
        else {
     		component.find('notifLib').showToast({
                "title": "Error while selecting BOMs!",
                "message": "BOM is a mandatory field.",
                "variant": "error"
        	});       
        }
        
    },
    
    handleSuccess : function(component, event, helper) {
    	component.destroy();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "type" : "success",
                    "message": "BOM selected successfully!"
                });
                toastEvent.fire();
                var appEvent = $A.get("e.c:refreshRelatedList");
                console.log('bfr firing: '+appEvent);
                appEvent.fire();
    }
})