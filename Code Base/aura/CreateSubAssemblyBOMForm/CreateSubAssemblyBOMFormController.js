({
	createSubAssemblyRecord : function(component,event,helper) {
       $A.createComponent(
            'c:CreateSubAssemblyForm',
            {'parentId':component.get('v.parentId'),
             'parentName':component.get('v.parentName'),
             'ownerName': component.get('v.ownerName')
            },
             function(content, status, errorMessage) {
           		if(status === 'SUCCESS') {
                    component.find('createSubAssebmlyModal').set('v.body',content);
       			}
       		}
        );
    },
    closeModal : function(component, event, helper) {
        component.destroy();
    },
    handleError : function (component,event,helper) {
        console.log(event.getParam("message"));
        component.find('notifLib').showToast({
            "title": "Error in Adding Sub Assembly!",
            "message": "Selected Sub Assembly is already part of the material.",
            "variant": "error"
        });
    },
    handleSuccess : function (component,event,helper) {
        var appEvent = $A.get("e.c:refreshRelatedList");
		appEvent.fire();
        component.destroy();
    },
    populateSubAssemblyID : function (component,event,helper) {
        var subAssemblyID = event.getParam("subAssemblyID");
        component.find("subAssemblyLookUpID").set("v.value",subAssemblyID);
    }
})