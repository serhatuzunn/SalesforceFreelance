({
    getEmployeeAction: function(component, event){
        var action = component.get("c.CompanyEmployeeInit");
        action.setCallback(this, function(response) {
            var result = response.getReturnValue();
            var state = response.getState();
            if (state === "SUCCESS") {
                //debugger;
                if(result.isLogon == true){
                    component.set("v.data",result.contacts);
                    console.log(result.contacts);
                }
                else{
                    //window.open(window.location.href.substring(0, window.location.href.indexOf("/s")) + '/s',"_self");
                    this.RedirectToUrl("/s",true);
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    deleteEmployeeAction: function(component, row){
        //debugger;
        var action = component.get("c.deleteEmployee");
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
        component.set('v.contact.FirstName','');
        component.set('v.contact.LastName','');
        component.set('v.contact.Title','');
        component.set('v.contact.Email','');
        component.set('v.contact.MobilePhone','');
    },
    
    RedirectToUrl : function(pagename,iswindowopen) {
        //debugger;
        var url = window.location.search.substring(1);              
        if(url == ""){  
            if(iswindowopen){
                window.open(window.location.href.substring(0, window.location.href.indexOf("/s")) + pagename,"_self");
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
                window.open(window.location.href.substring(0, window.location.href.indexOf("/s")) + pagename + sep + url,"_self");
            }
            else{
                var newurl=window.location.href.substring(0, window.location.href.indexOf("/s")) + '/s/' + pagename + sep + url;            
                return newurl;
            }
        }
    },
    
    showMessage : function(component,type,message) {
        //console.log('toast');
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