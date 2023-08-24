({
    
    init : function(component, event, helper) {
        var action = component.get("c.FirmInit");
        action.setCallback(this, function(response) {
            var result = response.getReturnValue();
            var state = response.getState();
            if (state === "SUCCESS") {
                //debugger;
                if(result != null && result.isLogon == true){
                    component.set("v.account", result.account);
                    component.set("v.logoFile", result.attachment);
                    component.set("v.accountProfile", result.AccountTypes);
                    component.set("v.country", result.country);
                    component.set("v.city", result.city);
                    component.set("v.contactPhone", result.contactPhone);
                    console.log('result.AccountTypes: ' + JSON.stringify(result.AccountTypes));
                    console.log('v.account: ' + JSON.stringify(result.account));
                    var country = component.get("v.account.RC_Portal_Country__c");
                    //console.log('Init country: ' + country);
                    
                    if(country == '1'){
                        component.set("v.isCountryTurkey", true);
                    }
                    else{
                        component.set("v.isCountryTurkey", false);
                    }
                }
                else{
                    helper.RedirectToUrl('/s',true);
                }
            }
        });
        $A.enqueueAction(action);
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
                        //Web_FileTypeError
                        return;
                    }
                }
                else
                {
                    //Web_FileTypeError
                    return;
                }
                if ((file.size / 1024) / 1024 > 3) 
                {
                    //Web_FileSizeError
                    return;
                }
                
                fileContents = fileContents.substring(dataStart);  
                attachments.push({"Name": file.name, "ContentType": file.type, "Body": fileContents, "BodyLength": file.size});
                component.set("v.attachments",attachments);
                component.set("v.isExistFile",true);
                //console.log(JSON.stringify(attachments));
                readFile(index+1)
            }
            reader.readAsDataURL(file);
        }
        readFile(0);          
    },
    
    removeFiles: function(component, event, helper) {
        component.set("v.attachments",[]);
        component.set("v.isExistFile",false);
        
    },
    
    approve : function (component, event, helper) {
        /*var allValid = component.find('field').reduce(function (validSoFar, inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && !inputCmp.get('v.validity').valueMissing;
        }, true);
        if (allValid) {
            alert('All form entries look valid. Ready to submit!');
        }
        else{    } */  
        
        var firmName = component.get("v.account.Name");
        var country = component.get("v.account.RC_Portal_Country__c");
        var city = component.get("v.account.RC_City_Info__c");
        //if((country == 'Turkey' || country == 'Türkiye') && city == 0){  
        if(country == 1 && city == 0){    
            helper.showMessage(component, 'error', $A.get("{!$Label.c.RC_PortalEmptyCity}"));
        }
        else{
            if(firmName == null || firmName == ""){
                helper.showMessage(component, 'error', $A.get("{!$Label.c.RC_EmptyFirmNameWarn}"));
            }
            else{
                var account = component.get("v.account");
                var action = component.get("c.FirmApprove");
                var file = component.get("v.attachments");
                account.Phone = account.Phone.replace(" ","");
                action.setParams({"account" :  JSON.stringify(account), "attachmentFile" : JSON.stringify(file)});
                action.setCallback(this, function(response) {
                    
                    var result = response.getReturnValue();
                    var state = response.getState();
                    if (state === "SUCCESS" && result) {
                        helper.RedirectToUrl('/s/companyemployee',true);
                        //window.open(window.location.href.substring(0, window.location.href.indexOf("/s")) + '/s/companyemployee',"_self");
                    }
                });
                $A.enqueueAction(action);
            }
        }
    },
    
    keyCheck : function (component, event, helper) {
        if (isNaN(parseInt(event.key))) {
            if (event.key != '.') {
                event.preventDefault();
                return false;
            }
        }
    },
    
    changeCountry : function (component, event, helper){
        var country = component.get("v.account.RC_Portal_Country__c");
        //console.log('country: ' + country);
        if(country == 1){
            component.set("v.isCountryTurkey", true);
        }
        else{
            component.set("v.isCountryTurkey", false);
        }
    },
    
    changeCity : function(component, event, helper){
        var city = component.get("v.account.RC_City_Info__c");
        //console.log('city: ' + city);
    }
})