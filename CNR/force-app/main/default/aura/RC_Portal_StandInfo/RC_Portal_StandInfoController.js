({
    init : function(component, event, helper) {
      
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
       
        var action = event.getParam('action');
        var row = event.getParam('row');
        switch (action.name) {
            case 'delete':
                helper.deleteEmployeeAction(component, row);
                break;
        }
    },
    
    addContactAction: function (component, event, helper) {
      
        var staffName = component.get("v.contact.FirstName");
        var staffSurname = component.get("v.contact.LastName");
        var staffTitle = component.get("v.contact.Title");
        var staffEmail = component.get("v.contact.Email");
        var staffPhone = component.get("v.contact.MobilePhone");
        
        if(staffName == null || staffSurname == null || staffTitle == null || staffEmail == null || staffPhone == null || staffName == "" || staffSurname == "" || staffTitle == "" || staffEmail == "" || staffPhone == ""){
            helper.showMessage(component, 'error', $A.get("{!$Label.c.RC_CompanyEmpRequiredFields}"))
        }
        else{
            var contact = component.get("v.contact");
            component.set("v.contact.ContactType","STAND");
            var action = component.get("c.addContact");
            action.setParams({"contact" :  JSON.stringify(contact)});
            console.log(JSON.stringify(contact));
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
    
    handleFilesChange: function (component, event,helper) {
        
        var uploadedFiles = event.getSource().get("v.files");
        var attachments = component.get("v.attachments");
        var acceptList = component.get("v.accept");
        var reader = new FileReader();  
        function readFile(index){
            if( index >= uploadedFiles.length ) return;
            var file = uploadedFiles[index];
            reader.onloadend = function(e) {  
                var fileContents = reader.result;
                var base64Mark = 'base64,';
                var dataStart = fileContents.indexOf(base64Mark) + base64Mark.length;
                var splitted = file.name.split("."); 
                
                if(splitted.length > 1)
                {
                    var uploadedExtension = splitted[splitted.length-1];
                    var invalidType = true;
                    for(var k = 0;k<acceptList.length;k++)
                    {
                        if(acceptList[k] == "."+uploadedExtension.toLowerCase())
                        {
                            invalidType = false;
                            break;
                        }
                    }
                    if(invalidType) 
                    {
                        //helper.showMessage(component, "error","Yanlış formatta bir dosya yüklediniz.");
                        alert($A.get("$Label.c.RC_PortalDocWrongFormat"));
                        return;
                    }
                }
                else
                {
                    helper.showMessage(component, "error", $A.get("$Label.c.RC_PortalDocTryAgain"));
                    return;
                }
                if ((file.size / 1024) / 1024 > 10) 
                {
                    helper.showMessage(component, "error", $A.get("$Label.c.RC_PortalDocumentWarning"));
                    return;
                }
                
                fileContents = fileContents.substring(dataStart);  
                attachments.push({"Name": file.name, "ContentType": file.type, "Body": fileContents, "BodyLength": file.size});
                component.set("v.attachments",attachments);
                component.set("v.isExistFile",true);
                console.log(JSON.stringify(attachments));
                readFile(index+1);
                var attch = component.get("v.attachments");
                if(attch != null && attch.length> 0)
                {
                    console.log('attch: ' + attch);
                    var imgItemMini = document.getElementById('imgMini');
                    console.log('imgItemMini: ' + imgItemMini);
                    imgItemMini.src = "data:image/png;base64, " + attch[0].Body;
                }
            }
            reader.readAsDataURL(file);
        }
        readFile(0);  
    },
    
    approve : function (component, event, helper) {
        var selectedDesingCompany = component.get("v.selectedStandDesignCompany");
        /*if(selectedDesingCompany == "" || selectedDesingCompany == null || selectedDesingCompany == 0){
            helper.showMessage(component, 'error', $A.get("{!$Label.c.RC_CompanyEmpRequiredFields}"))
        }
        else{*/
            var account = component.get("v.account");
            var action = component.get("c.StandApprove");
            var files = component.get("v.attachments");
            action.setParams({"selectedDesingCompany" :  selectedDesingCompany, "attachmentFiles" : JSON.stringify(files)});
            action.setCallback(this, function(response) {
                var result = response.getReturnValue();
                var state = response.getState();
                if (state === "SUCCESS") {
                    if(result){
                        helper.RedirectToUrl('/s/badges',true);
                    }else{
                        alert("Bir Hata Oluştu");
                    }
                }
            });
            $A.enqueueAction(action);
        //}
    },
    
    removeFiles: function(component, event, helper) {
        component.set("v.attachments",[]);
        component.set("v.isExistFile",false);
    },	
    
    turnBack : function (component, event, helper) {
        helper.RedirectToUrl('/s/catalogue',true);
    },
    
    keyCheck : function (component, event, helper) {
        if (isNaN(parseInt(event.key))) {
            if (event.key != '.') {
                event.preventDefault();
                return false;
            }
        }
    },
    
    changeStandDesign : function (component, event, helper){
        var standDesign = component.get('v.selectedStandDesignCompany');
        console.log('standDesign: ' + standDesign);
    }
})