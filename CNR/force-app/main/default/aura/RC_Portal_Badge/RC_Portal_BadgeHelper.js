({
    getBadgesAction: function(component, event){
        //debugger;
        var action = component.get("c.BadgeInit");
        action.setCallback(this, function(response) {
            var result = response.getReturnValue();
            var state = response.getState();
            if (state === "SUCCESS") {
                //debugger;
                console.log('result.badges: ' + result.badges);
                if(result.isLogon == true){
                    component.set("v.data",result.badges);
                     
                }
                else{
                    this.RedirectToUrl(component,"/s",true);
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    deleteBadgeAction: function(component, row){
        debugger;
        var action = component.get("c.deleteBadge");
        action.setParams({"row" :  JSON.stringify(row)});
        action.setCallback(this, function(response) {
            var result = response.getReturnValue();
            var state = response.getState();
            if (state === "SUCCESS") {
                debugger;
                var rows = component.get('v.data');
                var rowIndex = rows.indexOf(row);
                
                rows.splice(rowIndex, 1);
                component.set('v.data', rows);
            }
        });
        $A.enqueueAction(action);
    },
    
    clearInput : function(component){
        component.set('v.badge.RC_FullName__c','');
        component.set('v.badge.RC_Title__c','');
    },
    
    RedirectToUrl : function(component,pagename,iswindowopen){
        component.set("v.spinner", false);
        //debugger;
        var url = window.location.search.substring(1);       
        var newlocation = '_self';
        if(pagename == '/s/printbadge')
        {
            newlocation  = '_blank';
        }
        if(url == ""){
            if(iswindowopen)
            {
                window.open(window.location.href.substring(0, window.location.href.indexOf("/s")) + pagename, newlocation);
            }
            else{
                var newurl=window.location.href.substring(0, window.location.href.indexOf("/s")) + '/s/' + pagename;
                return newurl;
            }
        }
        else{
            var sep="?";
            if(iswindowopen)
            { 
                window.open(window.location.href.substring(0, window.location.href.indexOf("/s")) + pagename + sep + url, newlocation);
            }
            else{
                var newurl=window.location.href.substring(0, window.location.href.indexOf("/s")) + '/s/' + pagename + sep + url;            
                return newurl;
            }
        }
    },
    
    showMessage : function(component,type,message) {
        console.log('toast');
        var toastEvent = $A.get("e.force:showToast");
        if(toastEvent){
            toastEvent.setParams({
                title: "",
                message: message,
                type: type
            });
            toastEvent.fire();
        }
    }
})