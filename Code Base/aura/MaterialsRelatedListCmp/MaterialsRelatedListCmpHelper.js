({
	helperMethod : function(component,event) {
        
        var action = component.get("c.fetchBOMDetails");
        action.setParams({materialId:component.get("v.recordId")});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state=="SUCCESS"){
                var responseValue = response.getReturnValue();
                var counter = 0;
                for( var i  in responseValue) {
                    counter+= responseValue[i].bomList.length;
                }
                component.set("v.bomDetails",responseValue);
                component.set("v.bomTotalCount",counter);
            }
        });
        $A.enqueueAction(action);
	}
})