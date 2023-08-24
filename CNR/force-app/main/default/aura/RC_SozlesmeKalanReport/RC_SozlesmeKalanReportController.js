({
    init : function(component, event, helper) {
        debugger;
        var PG_ID = component.get("v.recordId");
        var action=component.get("c.Init");
        action.setParams({"aggrementId" :PG_ID});
        action.setCallback(this,function(response){
            var result = response.getReturnValue();
            var state = response.getState();
            if(state == "SUCCESS"){
                console.log("result:" + result.length);
                if(result.length > 0)
                {
                    if(result[0].kayitsayisi > 0){
                        component.set("v.data", result[0]);
                        component.set("v.isVisible", "");
                    }                    
                }
            }
            else{
                alert("Data çekilirken hata!");
            }
        })
        $A.enqueueAction(action);
    }
})