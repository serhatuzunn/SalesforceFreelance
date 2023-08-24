({
    init : function(component, event, helper) {
        debugger;
        /*if(!window.location.href.includes("portal/useroperations?token="))
            {
            	//
            }*/
        console.log(component.get("v.token"));
        //'568302f9-383b-4dab-336c-26b43c6afb3d'
    },
    
    resetPassword1 : function(component, event, helper) {
        debugger;
        var password = component.get("v.password");
        var repassword = component.get("v.repassword");
        var token = window.location.search.substring(7).split('&')[0]; //component.get("v.token");
        var action=component.get("c.resetPassword")
        action.setParams({ "password" : password, "repassword":repassword, "token":token });
        action.setCallback(this, function(response) {
            var result = response.getReturnValue();
            var state = response.getState();
            if (state === "SUCCESS") {      
                if(result.ResultCode == "1"){
                     helper.RedirectToUrl('/s',true);
                }
                else{
                    alert(result.ResultMessage); 
                }
            }
        });
        $A.enqueueAction(action);
    }
})