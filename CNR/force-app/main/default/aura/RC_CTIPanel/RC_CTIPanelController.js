({ 
    doInit : function(component, event, helper) {
        
        try
        {
            //Her kullanıcının kendi AgentId'si User objesinde tanımlı olmalı, Web servise bu id gönderilecek.
            helper.agentId(component);
        }
        catch(err)
        {
            console.log(err);
        }
    },
    //Sayfa değişikliklerinde yeni id'yi burası işler
    onRecordIdChange : function(component, event, helper) {
        helper.loadPage(component);
    },
    handleClick : function (component, event, helper) {
        helper.showSpinner(component, true);
        component.set('v.callDisabled',true);
        var selectedPhone = component.get("v.selectedPhoneValue");
        var agentId = component.get("v.agentId");        
        if(agentId.length > 0)
        {
            var action = component.get("c.MakePhoneCall");        
            var params = {"AgentId" : agentId, "PhoneNumber" : selectedPhone};
            action.setParams(params);
            action.setCallback(this, function(response){
                var state = response.getState();
                if(state == "SUCCESS")
                {
                   
                    var returnValue = response.getReturnValue();
                    if(returnValue == null || returnValue == '')
                    {
                        helper.showToast($A.get("$Label.c.RC_CTI_Error"),$A.get("$Label.c.RC_CTI_Error"),'error');
                        //component.set('v.agentId', ' is missing, please fill from user settings');
                    }
                    else 
                    {
                         helper.showToast($A.get("$Label.c.RC_CTI_Success"),$A.get("$Label.c.RC_CTI_CallStarted"),'success');
                        //component.set('v.agentId', returnValue);
                    }
                }
                helper.showSpinner(component, false);
                component.set('v.callDisabled',false);                
            });
            $A.enqueueAction(action);
        }
        else
        {
            helper.showToast($A.get("$Label.c.RC_CTI_Error"),$A.get("$Label.c.RC_CTI_AgentIdMissing"),'error');
        }
        
    },
    refreshClick : function (component, event, helper) {
        helper.loadPage(component);
    }
})