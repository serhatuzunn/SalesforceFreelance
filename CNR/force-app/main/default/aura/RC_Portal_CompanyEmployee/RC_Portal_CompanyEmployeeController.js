({
    init: function (component, event, helper) {
		//RC_Portal_Delete
        var actions = [
            { label: $A.get("$Label.c.RC_Portal_Delete"), name: 'delete' }
        ];
        
        component.set('v.columns', [
            {label: $A.get("$Label.c.RC_PortalComponyEmployee_Name") + ' ' + $A.get("$Label.c.RC_PortalComponyEmployee_Surname"), fieldName: 'Name', type: 'text'},
            {label: $A.get("$Label.c.RC_PortalComponyEmployee_TitleF"), fieldName: 'Title', type: 'text'},
            {label: $A.get("$Label.c.RC_PortalFirm_Email"), fieldName: 'Email', type: 'text'},
            {label: $A.get("$Label.c.RC_PortalFirm_Phone"), fieldName: 'Phone', type: 'text'},
            { type: 'action', typeAttributes: { rowActions: actions } }
        ]);
        
        helper.getEmployeeAction(component, event);
    },
    
    handleRowAction: function (component, event, helper) {
        //debugger;
        var action = event.getParam('action');
        var row = event.getParam('row');
        switch (action.name) {
            case 'delete':
                helper.deleteEmployeeAction(component, row);
                break;
        }
    },
    
    addContactAction: function (component, event, helper) {
        //debugger;
        var firstName = component.get("v.contact.FirstName");
        var lastName = component.get("v.contact.LastName");
        var title = component.get("v.contact.Title");
        var email = component.get("v.contact.Email");
        var phone = component.get("v.contact.MobilePhone");
        //console.log("firstName, lastName, title, email, phone: " + firstName + ', ' + lastName + ', ' + title + ', ' + email + ', ' + phone);
        
        if(firstName == undefined || lastName == undefined || title == undefined || email == undefined || phone == undefined || firstName == "" || lastName == "" || title == "" || email == "" || phone == ""){
            console.log("alanlar boş");
            helper.showMessage(component, 'error', $A.get("{!$Label.c.RC_CompanyEmpRequiredFields}"));
        }
        else{
            var contact = component.get("v.contact");
            var action = component.get("c.addContact");
            action.setParams({"contact" :  JSON.stringify(contact)});
            //console.log(JSON.stringify(contact));
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    helper.getEmployeeAction(component, event);
                    helper.clearInput(component);
                }
                else{
                    alert("Hata");
                }
            });
            $A.enqueueAction(action);
        }
    },
    
    approve : function (component, event, helper) {
       // window.open(window.location.href.substring(0, window.location.href.indexOf("/s")) + '/s/catalogue',"_self");
        helper.RedirectToUrl('/s/catalogue',true);
    },
    
    turnBack : function (component, event, helper) {
        //window.open(window.location.href.substring(0, window.location.href.indexOf("/s")) + '/s/firminfo',"_self");
        helper.RedirectToUrl('/s/firminfo',true);
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