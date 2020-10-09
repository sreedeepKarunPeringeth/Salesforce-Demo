({
	doInit : function(component,event,helper){
        
        helper.helperMethod(component,event)
   },
    
    selectBOMRecord : function(component,event,helper) {
        
        $A.createComponent(
            'c:SelectBOM',
            {'subAssemblyID':component.get('v.recordId')
            },
             function(content, status, errorMessage) {
           		if(status === 'SUCCESS') {
                    component.find('selectBomModal').set('v.body',content);
       			}
       		}
        );
    }
})