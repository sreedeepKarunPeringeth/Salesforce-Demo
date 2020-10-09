({
	helperMethod : function(component,event) {
        var action = component.get("c.fetchBOMInSubAssembly");
        action.setParams({subAssemblyID:component.get("v.recordId")});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state=="SUCCESS"){
                var responseValue = response.getReturnValue();
                var counter = 0;
                for( var i  in responseValue) {
                    counter+= responseValue[i].bomList.length;
                }
                component.set("v.subAssemblyName",responseValue[0].subAssemblyName);
                component.set("v.bomDetails",responseValue);
                component.set("v.bomTotalCount",counter);
                component.set("v.isRMGSupplied",responseValue[0].isRMGSupplied);
            }
        });
        $A.enqueueAction(action);
	}
})