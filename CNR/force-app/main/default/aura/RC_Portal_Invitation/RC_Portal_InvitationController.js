({
    init: function (component, event, helper) {
        debugger;
        var actions = [
            { label: $A.get("$Label.c.RC_Portal_Delete"), name: 'delete' }
        ];
        
        component.set('v.columns', [
            {label: $A.get("$Label.c.RC_PortalComponyEmployee_Name") + ' ' + $A.get("$Label.c.RC_PortalComponyEmployee_Surname"), fieldName: 'RC_FullName__c', type: 'text',fixedWidth: 200,},
            {label: $A.get("$Label.c.RC_PortalFirm_Email"), fieldName: 'RC_Email__c', type: 'text',fixedWidth: 200},
            {label: $A.get("$Label.c.RC_PortalInvitation_InvitationCount"), fieldName: 'RC_Reserved__c', type: 'text',fixedWidth: 200},
            { type: 'action', typeAttributes: { rowActions: actions } }
        ]);
        
        helper.getInvitationAction(component, event);
    },
    
    handleRowAction: function (component, event, helper) {
        debugger;
        var action = event.getParam('action');
        var row = event.getParam('row');
        switch (action.name) {
            case 'delete':
                helper.deleteInvitationAction(component, row);
                break;
        }
    },
    
    addInvitationAction: function (component, event, helper) {
        debugger;
        var invitation = component.get("v.invitation");
        var action = component.get("c.InsertInvitation");
        action.setParams({"Invitation" :  JSON.stringify(invitation)});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                helper.getInvitationAction(component, event);
                helper.clearInput(component);
            }
            else{
                alert("Hata");
            }
        });
        $A.enqueueAction(action);
    },
    
    approve : function (component, event, helper) {
        helper.RedirectToUrl('/s/thanks',true);
    },
    
    turnBack : function (component, event, helper) {
        helper.RedirectToUrl('/s/badges',true);         
    },
    
    keyCheck : function (component, event, helper) {
        if (isNaN(parseInt(event.key))) {
            if (event.key != '.') {
                event.preventDefault();
                return false;
            }
        }
    }
})