({
    init : function(component, event, helper) {
        var action = component.get("c.BadgePrintInit");
        action.setCallback(this, function(response) {
            var result = response.getReturnValue();
            var state = response.getState();
            if (state === "SUCCESS") {
                //debugger;
                if(result.isLogon == true){                    
                    component.set("v.data",result.badges);
                    //window.print();
                }
                else{
                    this.RedirectToUrl("/s",true);
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    handlePrint : function(component)
    {
       window.print();
    }
})