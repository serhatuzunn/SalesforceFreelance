({
    init : function(component, event, helper) {
        //debugger;
        var redirecturl = helper.RedirectToUrl("sikcasorulansorular",false);
        component.set("v.redirectUrl", redirecturl);
    },
    
    loginClick : function (component, event, helper) {
        var email = component.get("v.email");
        var password = component.get("v.password");
        //debugger;
        if(email != '' && password != '' ){
            var action=component.get("c.Login")
            action.setParams({ "email" : email,"password": password});
            action.setCallback(this, function(response) {
                var result = response.getReturnValue();
                var state = response.getState();
                if (state === "SUCCESS") {
                    if(result.ResultCode == "1"){
                        //debugger;
                        if(result.IsAgree == true){
                            helper.RedirectToUrl("/s/fair",true);
                        }
                        else{
                            helper.RedirectToUrl("/s/agreement",true);
                        }
                    }
                    else{
                        component.set("v.loginresult",result.ResultMessage);
                        //alert(result.ResultMessage); 
                    }
                }
            });
            $A.enqueueAction(action);} 
    },
    resetPasswordRequest : function (component, event, helper) {
        //debugger;
        var visible = component.get("v.visible");
        if(visible){
            component.set("v.visible",false);
        }
        else{
            component.set("v.visible",true);
        }
    },
    resetPassword : function (component, event, helper) {
        //debugger;
        var email = component.get("v.email");
        var action=component.get("c.resetPasswordMail")
        var lang = window.location.search.substring(1);
        action.setParams({ "email" : email, "lang":lang});
        action.setCallback(this, function(response) {
            var result = response.getReturnValue();
            var state = response.getState();
            if (state === "SUCCESS") { 
                if(result.ResultCode == "1"){
                    //debugger;
                    //window.open(window.location.href.substring(0, window.location.href.indexOf("/s")) + '/s/',"_self");
                    helper.RedirectToUrl("/s/",true);
                }
                else{
                    //alert(result.ResultMessage); 
                    component.set("v.result",result.ResultMessage);
                }
            }
        });
        $A.enqueueAction(action);
    }
})