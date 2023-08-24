({
    init : function(component, event, helper) {
        //debugger;
        var redirecturl = helper.RedirectToUrl("sikcasorulansorular",false);
        component.set("v.redirectUrl", redirecturl);
        
        var redirectFairUrl = helper.RedirectToUrl("fair",false);
        component.set("v.redirectFairUrl", redirectFairUrl);
        
        var redirectLogoutUrl = helper.RedirectToUrl("",false);
        component.set("v.redirectLogoutUrl", redirectLogoutUrl);
    }
})