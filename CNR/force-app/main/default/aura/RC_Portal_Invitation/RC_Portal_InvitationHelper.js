({
    getInvitationAction: function(component, event){
        var action = component.get("c.invitationInit");
        action.setCallback(this, function(response) {
            var result = response.getReturnValue();
            var state = response.getState();
            if (state === "SUCCESS") {
                debugger;
                if(result.isLogon == true){
                    component.set("v.data",result.invitations);
                }
                else{
                    this.RedirectToUrl('/s',true);
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    deleteInvitationAction: function(component, row){
        debugger;
        var action = component.get("c.deleteInvitation");
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
        component.set('v.invitation.RC_Email__c','');
        component.set('v.invitation.RC_Reserved__c','');
        component.set('v.invitation.RC_FullName__c','');
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