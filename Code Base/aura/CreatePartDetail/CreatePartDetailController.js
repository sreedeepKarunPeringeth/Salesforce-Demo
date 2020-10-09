({
    closeModal : function(component, event, helper) {
        component.destroy();
    },
    createPartDetail : function(component, event, helper) {
        
        document.getElementsByClassName("serverError")[0].style.display= "none";
        document.getElementsByClassName("errorSubCat")[0].style.display= "none";
        document.getElementsByClassName("errMsgLabel")[0].style.display= "none";
        document.getElementsByClassName("errorUnit")[0].style.display= "none";
        var partDetailToInsert = component.get("v.partDetail");
        partDetailToInsert.Category__c = component.get("v.categoryType");
        //partDetailToInsert.Make_Supplier__c = component.find("supplierId").get("v.value");
        //partDetailToInsert.Price__c = component.find("priceId").get("v.value");
        if(component.find("measurementUnitId") != null && (component.find("measurementUnitId").get("v.value") == null || component.find("measurementUnitId").get("v.value") == '')) {
            console.log('--'+component.find("measurementUnitId").get("v.value"));
            document.getElementsByClassName("errorUnit")[0].style.display= "block";
            return -1;
        }
        partDetailToInsert.MeasurementUnit__c = component.find("measurementUnitId").get("v.value");
        
        var fieldValue = '';
        var constParamValue = 'Parameter_Value_';
        var constPostFix = '__c';
        var formError = false;
        for(var i= 0; i < 8;i++) {
            fieldValue = "v.partDetail."+constParamValue+(i+1)+constPostFix;
            if(component.find("paramValue"+i)) {
                if(!component.find("paramValue"+i).get("v.value")) {
                    document.getElementsByClassName("errMsgLabel")[0].style.display= "block";
                    return -1;
                }
                component.set(fieldValue,component.find("paramValue"+i).get("v.value"));
            }
            else {
                break;
            }
        }
        if((component.find("noSubCatMapping") && partDetailToInsert.Sub_Category__c=='defaultMsg') || !partDetailToInsert.Sub_Category__c || component.find("noSubCatMapping")) {
            document.getElementsByClassName("errorSubCat")[0].style.display= "block";
            return -1;
        }
        var action = component.get("c.savePartDetail");
        action.setParams({newPartDetail:partDetailToInsert});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state=="SUCCESS"){
                
                var partDetail = response.getReturnValue();
                var appEvent = $A.get("e.c:passPartDetailId");
                
                appEvent.setParams({
                    "PartDetailId":partDetail.Id,
                    "partName":partDetail.Name,
                    "partCode":partDetail.Part_Code__c
                });
                appEvent.fire();
                
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "type": "success",
                    "message": "Part Detail ("+ partDetail.Name+ ") created!"
                });
                toastEvent.fire();
                component.destroy();
            }
            else {
                let errors = response.getError();
                let message = 'Unknown error';
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    message = errors[0].message;
                    component.set("v.serverError",message);
                    document.getElementsByClassName("serverError")[0].style.display= "block";
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    fetchParamNames : function(component, event, helper) {
        
        var action = component.get("c.fetchParams");
        var labelNameConst = 'Parameter Name ';
        var labelValueConst = 'Parameter Value ';
        var subCategoryValue = event.getSource().get('v.value');
        document.getElementsByClassName("serverError")[0].style.display= "none";
        document.getElementsByClassName("errorSubCat")[0].style.display= "none";
        document.getElementsByClassName("errMsgLabel")[0].style.display= "none";
        if(subCategoryValue=='') {
            component.set('v.body','');
        }
        else {
            component.set("v.partDetail.Sub_Category__c",subCategoryValue);
            action.setParams({subCategory:subCategoryValue});
            action.setCallback(this, function(response) {
                var state = response.getState();
                var paramList = response.getReturnValue();
                var newComponents = [];
                if(state=="SUCCESS" && (paramList.length > 0) ) {
                    var paramNameList = [];
                    var constParamName = 'Parameter_Name_';
                    
                    var constPostFix = '__c';
                    var fieldName = '';
                    
                    for(var i= 0; i< paramList.length;i++) {
                        fieldName = "v.partDetail."+constParamName+(i+1)+constPostFix;
                        
                        component.set(fieldName,paramList[i]);
                        newComponents.push(["lightning:input", {
                            "label":labelNameConst+(i+1),
                            "class":"slds-size_1-of-2 slds-p-horizontal_small",
                            "value":paramList[i],
                            "disabled": "true",
                        }]);
                        newComponents.push(["lightning:input", {
                            "aura:id":"paramValue"+i,
                            "label":labelValueConst+(i+1),
                            "class":"slds-size_1-of-2 slds-p-horizontal_small",
                            "value":"",
                            "required":"true",
                            "messageWhenValueMissing":"Parameter value should contain symbol (~). Eg: Fixed~F",
                            "messageWhenBadInput":"Parameter value should contain symbol (~). Eg: Fixed~F",
                        }]);
                    }
                    
                    $A.createComponents(newComponents,function(content,status,errorMessage){
                        if(status == 'SUCCESS') {
                            component.set('v.body',content);
                        }
                    });
                }
                else {
                    newComponents.push(["ui:outputText", {
                        "aura:id":"noSubCatMapping",
                        "class":"subCatNotFound slds-size_2-of-2 slds-p-horizontal_small slds-text-color--error",
                        "value":"No match found for the entered sub-category. Please contact the Admin to add the parameters for this sub-category",
                    }]);
                    $A.createComponents(newComponents,function(content,status,errorMessage){
                        if(status == 'SUCCESS') {
                            component.set('v.body',content);
                        }
                    });
                }
            });
            $A.enqueueAction(action);
        }
    },
    
})