({
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
    },
    
    getEmployeeAction: function(component, event){
        var action = component.get("c.StandContactsInit");
        action.setCallback(this, function(response) {
            var result = response.getReturnValue();
            var state = response.getState();
            console.log('result: ' + JSON.stringify(result));
            console.log('state: ' + state);
            if (state === "SUCCESS") {
                debugger;
                if(result.isLogon == true){
                    component.set("v.data",result.contacts);
                    component.set("v.opportunity",result.opportunity);
                    component.set("v.standDesignCompanyList", result.StandDesignCompanyList);
                    console.log(result.contacts);
                    
                    var atch = result.attachment; 
                    
                    var attachments = component.get("v.attachments");
                    attachments = [];
                    attachments.push({"Name": atch.Name,  "Body": atch.Description, Id:atch.Id});
                    component.set("v.attachments",attachments);
                    component.set("v.isExistFile",true);
                    
                    var attch = component.get("v.attachments");
                    if(attch != null && attch.length> 0)
                    {
                        component.set('v.imageMini', "data:image/png;base64, " + attch[0].Body);
                    }
                }
                else{
                    this.RedirectToUrl("/s",true);
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    deleteEmployeeAction: function(component, row){
        debugger;
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
        debugger;
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
    }     
})