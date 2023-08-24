({
    init : function(component, event, helper) {
        component.set("v.initWrapper.account.RC_Firm_Info_TR__c", "");
        component.set("v.initWrapper.account.RC_Firm_Info_EN__c", "");
        //debugger;
        var action=component.get("c.CatalogueInit");
        action.setCallback(this,function(response){
            var result = response.getReturnValue();
            var state = response.getState();
            if(state == "SUCCESS"){
                //debugger;
                if(result != null && result.isLogon == true){
                    component.set("v.initWrapper.account", result.account);
                    component.set("v.initWrapper.contactList", result.contactList);
                    if(result.contactPhone == undefined){
                        component.set("v.contactPhone", "-");
                    }
                    else{
                        component.set("v.contactPhone", result.contactPhone);
                    }
                    
                    var atch = result.attachment; 
                    
                    var attachments = component.get("v.attachments");
                    attachments = [];
                    attachments.push({"Name": atch.Name, "Body": atch.Description, Id:atch.Id});
                    component.set("v.attachments", attachments);
                    component.set("v.isExistFile", true);
                    
                    var attch = component.get("v.attachments");
                    if(attch != null && attch.length> 0)
                    {
                        component.set('v.imageMini', "data:image/png;base64, " + attch[0].Body);
                        /*setTimeout(function(){
                            var imgItemMini = document.getElementById('imgMini');
                            console.log('imgItemMini: ' + imgItemMini);
                            imgItemMini.src = "data:image/png;base64, " + attch[0].Body; }, 3000);
                        */
                    }
                    
                    var LContact = result.contactList;
                    LContact.forEach(function(item){ 
                        if(item.selected != ""){
                            component.set("v.selectedContact", item.value);
                            component.set("v.selectedCompanyRep", item.value);
                        }
                    });
                    if(result.Sector.sectorList.length > 0){
                        component.set("v.initWrapper.Sector.sectorList",result.Sector.sectorList);
                        console.log('result.Sector.sectorList: ' + JSON.stringify(result.Sector.sectorList));
                        console.log('result.Sector.subSectorList: ' + JSON.stringify(result.Sector.subSectorList));
                        console.log('result.ProductGroupList: ' + JSON.stringify(result.Sector.subSectorLis));
                        var selectedSector = result.relatedSectors;
                        if(selectedSector != undefined && selectedSector != null && selectedSector != ''){
                            var pills = component.get("v.pills");
                            selectedSector.forEach(function(item){ 
                                //debugger;
                                if(item.RC_Product_Group__c != undefined && item.RC_Product_Group__c != null && item.RC_Product_Group__c != ''){
                                    pills.push({type: 'icon', id: item.RC_Product_Group__c, label: item.RC_Product_Group__r.Name, iconName: 'standard:account'});
                                }
                                
                            });
                            component.set("v.pills", pills);
                            component.set("v.visible", true);
                        }
                    }
                    else{
                        component.set("v.initWrapper.Sector.sectorList",'');
                    }
                    
                    console.log('result.account.RC_Brand__c: ' + result.account.RC_Brand__c);
                    if(result.account.RC_Brand__c.length > 0){
                        var brandArray = result.account.RC_Brand__c.split(',');
                        console.log('brandArray: ' + brandArray);
                        var brandsPill = component.get("v.brands");
                        brandArray.forEach(function(item){
                            console.log('item: ' + item);
                            //for(var i=0; i<brandArray.length; i++){
                            brandsPill.push({type: 'icon', id: item, label: item, iconName: 'standard:account'});
                            //brandsPill.push({type: 'icon', id: brandArray[i], label: brandArray[i], iconName: 'standard:account'});
                            //}
                        });
                        component.set("v.brands", brandsPill);
                        component.set("v.visibleBrand", true);
                    }
                    helper.setBusy(component,false);
                }
                else{
                    //window.open(window.location.href.substring(0, window.location.href.indexOf("/s")) + '/s',"_self");
                    helper.RedirectToUrl('/s',true);
                }
            }
            else{
                helper.showMessageToast(component, 'Error', 'Hata .!');
                helper.setBusy(component,false);
            }
        })
        $A.enqueueAction(action);            
    },
    
    AddBrand : function(component, event, helper) {
        debugger;
        var brand = component.get("v.brand");
        var brands = component.get("v.brands");
        var selectedCompanyRep = component.get("v.selectedCompanyRep");
        debugger;
        if(brand != undefined && brand != null && brand != '' && selectedCompanyRep != 0){
            brands.push({type: 'icon', id:brand , label: brand, iconName: 'standard:account'});
            component.set("v.brands", brands);
            component.set("v.brand",'');
            component.set("v.visibleBrand",true);
        }
        else{
            helper.showMessageToast(component, 'error', $A.get("{!$Label.c.RC_CompanyEmpRequiredFields}"));
        }
        console.log("v.brands: " + component.get("v.brands"));
    },
    
    RemoveBrand: function (cmp, event) {     
        debugger;
        var id = event.getParam("item");
        var selectedbrands = cmp.get('v.brands');
        var index = event.getParam("index");
        selectedbrands.splice(index,1);
        if(selectedbrands.length > 0){
            cmp.set("v.brands", selectedbrands);
        }
        else{
            cmp.set("v.visibleBrand", false);
        }
        console.log("selectedbrands: " + JSON.stringify(selectedbrands));
        console.log("v.brands: " + JSON.stringify(cmp.get("v.brands")));
    },
    
    changeCompanyRep : function(component,event,helper){
        console.log('selectedCompanyRep: ' + component.get("v.selectedCompanyRep"));
    },
    
    mainSectorOnChange : function(component,event,helper){
        helper.setBusy(component,true);
        var selectedMainSector = component.get("v.selectedMainSector");
        var recordId = component.get("v.recordId");        
        
        if(selectedMainSector == 0){
            component.set("v.initWrapper.Sector.subSectorList", 0);
            component.set("v.initWrapper.ProductGroupList", 0);
            helper.setBusy(component,false);
        }
        else{
            var action = component.get("c.getSubSectorList");
            action.setParams({"selectedMainSector" : selectedMainSector});
            action.setCallback(this,function(response){
                var result = response.getReturnValue();
                var state = response.getState();
                if(state == "SUCCESS"){
                    if(result.subSectorList.length > 0){
                        component.set("v.initWrapper.Sector.subSectorList", result.subSectorList);
                        component.set("v.initWrapper.ProductGroupList", 0);
                        component.set("v.selectedSubSector", 0);
                        component.set("v.selectedProductGroup", 0);
                        component.set("v.isDisabledSubSectorPicklist",false);
                    }
                    else{
                        component.set("v.selectedSubSector", 0);
                        component.set("v.isDisabledSubSectorPicklist",true);
                        helper.setBusy(component,false);
                    }
                    helper.setBusy(component,false);
                }
                else{
                    helper.setBusy(component,false);
                }
            })
            $A.enqueueAction(action);
        }
    },
    
    subSectorOnChange : function(component,event,helper){
        helper.setBusy(component,true);
        var selectedSubSector = component.get("v.selectedSubSector");
        var recordId=component.get("v.recordId");        
        
        if(selectedSubSector == ''){
            component.set("v.initWrapper.ProductGroupList",'');
            helper.setBusy(component,false);
        }
        else{
            var action=component.get("c.getProductGroupList");
            action.setParams({"selectedSubSector" :selectedSubSector});
            action.setCallback(this,function(response){
                var result = response.getReturnValue();
                var state = response.getState();
                if(state == "SUCCESS"){
                    //debugger;
                    if(result.length > 0){
                        component.set("v.selectedProductGroup", 0);
                        component.set("v.initWrapper.ProductGroupList",result);
                        component.set("v.isDisabledProductGroupPicklist",false);
                    }
                    else{
                        component.set("v.selectedProductGroup", 0);
                        component.set("v.isDisabledProductGroupPicklist",true);
                        helper.setBusy(component,false);
                    }
                    helper.setBusy(component,false);
                }
                else{
                    helper.setBusy(component,false);
                }
            })
            $A.enqueueAction(action);
        }
    },
    
    pillRemove: function (cmp, event) {
        var id = event.getParam("item").id;
        var selectedPills = cmp.get('v.selectedPills');
        var index = event.getParam("index");
        selectedPills.splice(index, 1);
        cmp.set('v.selectedPills', selectedPills);
        
        var pills = cmp.get('v.pills');
        pills.splice(index,1);
        if(pills.length > 0) cmp.set('v.pills', pills); else cmp.set("v.visible",false);
    },
    
    AddPill : function (component,event,helper){
        debugger;
        var selectedMainSector = component.get("v.selectedMainSector");
        var selectedSubSector = component.get("v.selectedSubSector");
        var selectedProductGroup = component.get("v.selectedProductGroup");
        var selectedPills = component.get("v.selectedPills");
        var addedPills = component.get("v.addedPills");
        var pills = component.get("v.pills");
        
        var pillLabel ='';
        var searchSet = '';
        var searchParam = '';
        
        if(selectedProductGroup != undefined && selectedProductGroup != null && selectedProductGroup != ''){
            addedPills.push({ProductGroup : selectedProductGroup, SubSector : selectedSubSector, MainSector : selectedMainSector, Type : 'Interested' });
            selectedPills.push(selectedProductGroup);
            searchSet = 'v.initWrapper.ProductGroupList';
            searchParam = selectedProductGroup;
            pillLabel = helper.getPillLabel(component,event,helper,searchSet,searchParam);
            pills.push({type: 'icon', id:selectedProductGroup , label: pillLabel, iconName: 'standard:account'});
            component.set("v.pills",pills);
            component.set("v.visible",true);
        }
        else if(selectedSubSector != undefined && selectedSubSector != null && selectedSubSector != ''){
            addedPills.push({ProductGroup : '', SubSector : selectedSubSector, MainSector : selectedMainSector, Type : 'Interested' });
            selectedPills.push(selectedSubSector);
            searchSet = 'v.initWrapper.Sector.subSectorList';
            searchParam = selectedSubSector;
            pillLabel = helper.getPillLabel(component,event,helper,searchSet,searchParam);
            pills.push({type: 'icon', id:selectedSubSector , label: pillLabel, iconName: 'standard:account'});
            component.set("v.pills",pills);
            component.set("v.visible",true);
        }
            else if(selectedMainSector != undefined && selectedMainSector != null && selectedMainSector != ''){
                addedPills.push({ProductGroup : '', SubSector : '', MainSector : selectedMainSector, Type : 'Interested' });
                selectedPills.push(selectedMainSector);
                searchSet = 'v.initWrapper.Sector.sectorList';
                searchParam = selectedMainSector;
                pillLabel = helper.getPillLabel(component,event,helper,searchSet,searchParam);
                pills.push({type: 'icon', id:selectedMainSector , label: pillLabel, iconName: 'standard:account'});
                component.set("v.pills",pills);
                component.set("v.visible",true);
            }
                else{
                    helper.showMessageToast(component, 'Error', 'Seçim Yapınız .!');
                }
    },
    
    handleFilesChange: function (component, event,helper) {
        debugger;
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
                attachments = [];
                attachments.push({"Name": file.name, "ContentType": file.type, "Body": fileContents, "BodyLength": file.size});
                component.set("v.attachments",attachments);
                component.set("v.isExistFile",true);
                //console.log(JSON.stringify(attachments));
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
    
    removeFiles: function(component, event, helper) {
        component.set("v.attachments",[]);
        component.set("v.isExistFile",false);        
    },
    
    preview : function (component,event,helper){
        var Name = component.get("v.initWrapper.account.Name");
        //var Type = component.get("v.initWrapper.account.Type");
        var Address = component.get("v.initWrapper.account.BillingAddress");
        console.log('Address: ' + Address);
        console.log('Address.street: ' + Address.street);
        console.log('Address.city: ' + Address.city);
        console.log('Address.state: ' + Address.state);
        console.log('Address.postalCode: ' + Address.postalCode);
        console.log('Address.country: ' + Address.country);
        var BillAddress = Address.street +' '+ Address.city +' '+ Address.state +' '+ Address.postalCode +' '+ Address.country;
        var Email = component.get("v.initWrapper.account.RC_Email__c");
        var Phone = component.get("v.initWrapper.account.Phone");
        var contactPhone = component.get("v.contactPhone");
        var brands = component.get("v.brands");
        var pills = component.get("v.pills");
        //var Fax = component.get("v.initWrapper.account.Fax");
        var FirmInfoTR = component.get("v.initWrapper.account.RC_Firm_Info_TR__c");
        var FirmInfoEN = component.get("v.initWrapper.account.RC_Firm_Info_EN__c");
        //debugger;
        var selectedContact = component.get("v.selectedCompanyRep");
        var Contact = "";
        if(selectedContact != null && selectedContact != ''){
            var searchSet = 'v.initWrapper.contactList';
            var searchParam = selectedContact;
            Contact = helper.getPillLabel(component,event,helper,searchSet,searchParam);
        }
        //helper.cataloguePreview(component,Name,Contact,Type,BillAddress,Email,Phone,Fax,FirmInfoTR,FirmInfoEN);
        helper.cataloguePreview(component,Name,Contact,BillAddress,Email,Phone,contactPhone,FirmInfoTR,FirmInfoEN);
    },
    
    closeModal : function (component,event,helper){
        helper.closeModal();
    },
    
    approve : function (component,event,helper){
        debugger;
        var firmInfoTR = component.get("v.initWrapper.account.RC_Firm_Info_TR__c");
        var firmInfoEN = component.get("v.initWrapper.account.RC_Firm_Info_EN__c");
        console.log('firmInfoTR: ' + firmInfoTR);
        console.log('firmInfoEN: ' + firmInfoEN);
        if(firmInfoTR == null || firmInfoEN == null || firmInfoTR == undefined || firmInfoEN == undefined || firmInfoTR == "" || firmInfoEN == ""){
            helper.showMessageToast(component, 'error', $A.get("{!$Label.c.RC_FirmInfoWarming}"))
        }
        else{
            var brands = component.get("v.brands");
            var sectors = component.get("v.addedPills");
            var account = component.get("v.initWrapper.account");    
            var contact = component.get("v.selectedCompanyRep");
            var action = component.get("c.CatalogueApprove");
            var file = component.get("v.attachments");
            var str = JSON.stringify(sectors);
            var atchJSON = "";
            if(file.length > 0)
            {
                if(file[0].Id == undefined)
                {
            		atchJSON = JSON.stringify(file);
                }
            }
            console.log("approve brands: " + JSON.stringify(brands));
            action.setParams({"attachmentFile" : atchJSON, "brands" :  JSON.stringify(brands), "account" :  JSON.stringify(account), 
                              "sectors" :  JSON.stringify(sectors), "contact" : contact });
            action.setCallback(this, function(response) {
                debugger;
                var result = response.getReturnValue();
                var state = response.getState();
                if (state === "SUCCESS") {
                    //window.open(window.location.href.substring(0, window.location.href.indexOf("/s")) + '/s/standinfo',"_self");
                    helper.RedirectToUrl('/s/standinfo',true);
                }
            });
            $A.enqueueAction(action);
        }
    },
    
    turnBack : function (component, event, helper) {
        //window.open(window.location.href.substring(0, window.location.href.indexOf("/s")) + '/s/companyemployee',"_self");
        helper.RedirectToUrl('/s/companyemployee',true);
    }
})