({
    init : function(component, event, helper) {
        var Id = component.get("v.childAttribute");
        var action = component.get("c.GetLeftMenu");
        //action.setParams({"fairId" : Id});
        action.setCallback(this, function(response) {
            //debugger;
            var result = response.getReturnValue();
            if(result.isLogon == true){
                //debugger;
                component.set("v.fair", result.fair);
                component.set("v.opportunity", result.opportunity);
                component.set("v.imageLink", result.document);
                //component.set("v.imageLink", 'https://dev-cnrexpo.cs87.force.com' + result.document);
                
            }
            else{
                window.open(window.location.href.substring(0, window.location.href.indexOf("/s")) + '/s',"_self");
            }
        });
        $A.enqueueAction(action);
    }
})