({
    init : function(component, event, helper) {        
        var action = component.get("c.FairInit");
        action.setCallback(this, function(response) {
            var result = response.getReturnValue();
            var state = response.getState();
            if (state === "SUCCESS") {
                //debugger;
                if(result != null && result.isLogon == true){
                    //console.log(JSON.stringify(result.fairList));
                    component.set("v.fairs",result.fairList);
                    var url = helper.RedirectToUrl("firminfo",false);
                    component.set("v.redirectUrl",url);
                }
                else{
                    window.open(window.location.href.substring(0, window.location.href.indexOf("/s")) + '/s',"_self");
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    selectFair: function(component, event, helper) {
        //debugger;
        var selectedItem = event.currentTarget;
        var fairId = selectedItem.dataset.record;
        var action = component.get("c.saveFair");
        action.setParams({"fairId" : fairId});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state != "SUCCESS") {
                alert("Hata!: selectFair");
            }
        });
        $A.enqueueAction(action);
    }
})