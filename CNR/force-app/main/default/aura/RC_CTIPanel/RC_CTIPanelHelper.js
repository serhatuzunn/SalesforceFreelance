({
    agentId : function(component) {
        var action = component.get("c.getAgentId");
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state == "SUCCESS")
            {
                var returnValue = response.getReturnValue();
                if(returnValue == null)
                {
                    component.set('v.agentId', '');
                }
                else 
                {
                    component.set('v.agentId', returnValue);
                    
                }                
            }
            
            if(component.get('v.agentId') == '')
            {
                component.set('v.callDisabled', true);                            
            }
        });
        $A.enqueueAction(action);
    },
    loadPhoneNumber : function(component) {
        var action = component.get("c.getphoneNumber");
        var recordId = component.get("v.recordId");
        if(recordId != null)
        {
            this.showSpinner(component, true);
            action.setParams({"recordId" : recordId });
            action.setCallback(this, function(response){
                var state = response.getState();
                if(state == "SUCCESS")
                {
                    var returnValue = response.getReturnValue();
                    console.log(returnValue);
                    if(returnValue == null)
                    {
                        //component.set('v.agentId', ' is missing, please fill from user settings');
                        throw $A.get("$Label.c.RC_CTI_PhoneNotFound");//"Phone not found";
                    }
                    else 
                    {
                        if(returnValue.length > 0)
                        {
                            component.set('v.phones',returnValue);                        
                            component.set('v.selectedPhoneValue',returnValue[0].value);
                        }
                        else
                        {
                            this.clearPage(component);
                        }
                    }
                }
                else if(state == "ERROR")
                {
                    console.log(response.getError());
                }
                this.showSpinner(component, false);
            });
            $A.enqueueAction(action);
        }
    },
    clearPage : function(component){
        component.set("v.selectedPhoneValue","");
        component.set("v.phones",null);
    },
    loadPage : function(component){
        
        var hasError = false;
        try
        {
            var recordId = component.get('v.recordId');
            if(recordId != null && recordId.length > 0)
            {
                this.loadPhoneNumber(component);
            }
            else
            {
                hasError = true;
            }
        }
        catch(err)
        {
            console.log(err);
            hasError = true;
        }
        if(hasError)
        {
            this.clearPage(component);
        }
        
    },
    showToast : function(title, message,type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "mode": "sticky",
            "title": title,
            "message": message,
            "type" : type
        });
        toastEvent.fire();
    },
    showSpinner: function(component, isOpen) {
        component.set("v.spinner", isOpen); 
    },
})