({
    doInit : function(component, event, helper) {
        alert('test');
        
        var actionName = 'c.checkResponse';
        var action = component.get(actionName);
        //action.setParams({"recordId" :recordId });
        action.setCallback(this, function(response){
            if(response.getState() == "SUCCESS")
            {
                console.log(response.getReturnValue());
            }            
        });
        $A.enqueueAction(action);
    }
})