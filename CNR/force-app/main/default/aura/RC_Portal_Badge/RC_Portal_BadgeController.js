({
    init: function (component, event, helper) {
        //debugger;
        var actions = [
            { label: $A.get("$Label.c.RC_Portal_Delete"), name: 'delete' }
        ];
        
        component.set('v.columns', [
            {label: $A.get("$Label.c.RC_PortalComponyEmployee_Name") + ' ' + $A.get("$Label.c.RC_PortalComponyEmployee_Surname"), fieldName: 'RC_FullName__c', type: 'text'},
            {label: $A.get("$Label.c.RC_PortalComponyEmployee_TitleF"), fieldName: 'RC_Title__c', type: 'text'},
            { type: 'action', typeAttributes: { rowActions: actions } }
        ]);
        
        helper.getBadgesAction(component, event);
     
    },
    
    handleRowAction: function (component, event, helper) {
        //debugger;
        var action = event.getParam('action');
        var row = event.getParam('row');
        switch (action.name) {
            case 'delete':
                helper.deleteBadgeAction(component, row);
                break;
        }
    },
    
    insertBadgeAction: function (component, event, helper) {
        //debugger;
        var name = component.get("v.badge.RC_FullName__c");
        var title = component.get("v.badge.RC_Title__c");
        if(name == null || title == null || name == "" || title == "" || name == undefined || title == undefined){
            helper.showMessage(component, 'error', $A.get("{!$Label.c.RC_CompanyEmpRequiredFields}"));
        }
        else{
            var badge = component.get("v.badge");
            var action = component.get("c.InsertBadge");
            action.setParams({"Badge" :  JSON.stringify(badge)});
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    helper.getBadgesAction(component, event);
                    helper.clearInput(component);
                }
                else{
                    alert("Hata");
                }
            });
            $A.enqueueAction(action);
        }
    },
    
    printBadge:function (component, event, helper) {
        component.set("v.spinner", true);
        var data = component.get("v.data");
        //var dataSelected = component.get("v.selectedRowsListTemp");
        //debugger;
        console.log('data: ' + JSON.stringify(data));
        var action = component.get("c.getBadges");
        action.setParams({"badges" :  JSON.stringify(data)});
        action.setCallback(this, function(response) {
            var result = response.getReturnValue();
            var state = response.getState();
            if (state === "SUCCESS"){
                if(result.isLogon == true){
                    helper.RedirectToUrl(component,'/s/printbadge',true);
                }
                else{
                    helper.RedirectToUrl(component,"/s",true);
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    approve : function (component, event, helper) {
        helper.RedirectToUrl(component,'/s/invitation',true);
    },
    
    turnBack : function (component, event, helper) {
        helper.RedirectToUrl(component,'/s/standinfo',true);
    },
    
    updateSelected: function (cmp, event) {
        var selectedRows = event.getParam('selectedRows');
        console.log(selectedRows);
        cmp.set('v.selectedRowsListTemp',selectedRows); 
    },
})