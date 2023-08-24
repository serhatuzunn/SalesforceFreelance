({
    init : function(component, event, helper) {
        debugger;
        var action = component.get('c.initAgreement');
        action.setCallback(this,function(response){
            var result = response.getReturnValue();
            var state = response.getState();
            if (state === "SUCCESS") {
                debugger;
                if(result == null || result.isLogon == false){
                    helper.RedirectToUrl("/s",true);
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    approve : function(component, event, helper) {
        debugger;
        var action = component.get('c.approveAgreement');
        action.setCallback(this,function(response){
            var result = response.getReturnValue();
            var state = response.getState();
            if (state === "SUCCESS") {
                if(result == null || result.isLogon == false){
                    helper.RedirectToUrl("/s",true);
                }
                else{
                    helper.RedirectToUrl("/s/fair",true);
                }
            }
        });
        $A.enqueueAction(action);
        
    }
})