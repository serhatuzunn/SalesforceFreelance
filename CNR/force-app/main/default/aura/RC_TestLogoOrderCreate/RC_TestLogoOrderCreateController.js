({
	init : function(component, event, helper) {
        debugger;
		 var action = component.get("c.Create");
        action.setCallback(this, function(response) {
            debugger;
            var state = response.getState();
            var result = response.getReturnValue();
            if (state === "SUCCESS") {
                debugger;
                alert('FisNo:' + result);
            }
            else{
                alert("Hata");
            }
        });
        $A.enqueueAction(action);
	}
})