({
    
    init : function(component, event, helper) {
        
		helper.setBusy(component,true);
        var recordId=component.get("v.recordId");
        var action=component.get("c.getInit");

        action.setCallback(this,function(response){
            var result = response.getReturnValue();
            var state = response.getState();
            if(state == "SUCCESS"){
        		component.set("v.initWrapper.Fair.mainFairList",result.Fair.mainFairList);
                component.set("v.initWrapper.Fair.allFairList",result.Fair.allFairList);
                component.set("v.initWrapper.TypeList",result.TypeList);
                component.set("v.initWrapper.DataTypeList",result.DataTypeList);
                component.set("v.isVisibleExcelTab",result.isAdmin);
                
                helper.setBusy(component,false);
            }
            else{
               helper.showMessageToast('Hata .!','Error');
               helper.setBusy(component,false);
            }
        })
        $A.enqueueAction(action);
    },
    
    Aktar : function(component, event, helper) {
        var recordId=component.get("v.recordId");
        var action=component.get("c.getInit");
        action.setParams({"recordId" :recordId});
        action.setCallback(this,function(response){
            var result = response.getReturnValue();
            var state = response.getState();
            if(state == "SUCCESS"){
                
            }
            else{
                
            }
        })
        $A.enqueueAction(action);
    },
    
    fairOnChange : function(component, event, helper) {
        
        var recordId=component.get("v.recordId");
        var action=component.get("c.getInit");
        action.setParams({"recordId" :recordId});
        action.setCallback(this,function(response){
            var result = response.getReturnValue();
            var state = response.getState();
            if(state == "SUCCESS"){
                
            }
            else{
                
            }
        })
        $A.enqueueAction(action);
    },
    
    mainFairOnChange : function (component,event,helper){
        helper.setBusy(component,true);
        var selectedMainFair = component.get("v.selectedMainFair");
        var recordId=component.get("v.recordId");        
        
        if(selectedMainFair == ''){
            component.set("v.initWrapper.Fair.subFairList",'');
            helper.setBusy(component,false);
        }else{
            var action=component.get("c.getSubFairList");
            action.setParams({"selectedMainFair" :selectedMainFair});
            action.setCallback(this,function(response){
                var result = response.getReturnValue();
                var state = response.getState();
                if(state == "SUCCESS"){
                    if(result.subFairList.length > 0){
                        component.set("v.initWrapper.Fair.subFairList",result.subFairList);
                        component.set("v.isDisabledSubFairPicklist",false);
                    }else{
                        component.set("v.isDisabledSubFairPicklist",true)
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
    
    openModel: function(component, event, helper) {
        
            var accounts = [];
            var getAllId = component.find("Cbx");
            if(!Array.isArray(getAllId)){
                if (getAllId.get("v.checked") == true) {
                    accounts.push(getAllId.get("v.value"));
                }
            }else{
                for (var i = 0; i < getAllId.length; i++) {
                    if (getAllId[i].get("v.checked") == true) {
                        accounts.push(getAllId[i].get("v.value"));
                    }
                }
            }
        if(accounts.length > 0){
            component.set("v.isModalOpen", true);
            
            var action=component.get("c.getChildFairs");
            action.setCallback(this,function(response){
                var result = response.getReturnValue();
                var state = response.getState();
                if(state == "SUCCESS"){
                    component.set("v.initWrapper.Fair.childFairList",result.childFairList);
                    helper.setBusy(component,false);
                }
                else{
                    helper.setBusy(component,false);
                }
            })
            $A.enqueueAction(action);            
        }else{
            helper.showMessageToast('Firma Seçiniz .!','Error');
        }
        
        
       
        
    },
    
    closeModel: function(component, event, helper) {
        // Set isModalOpen attribute to false  
        component.set("v.isModalOpen", false);
    },
    
    tabSelected: function(component,event,helper) {
        component.set("v.isVisibleTable",false);
        component.set("v.tableDatas",'');
        
        if(component.get("v.selectedTab") == '1'){ component.set("v.isVisibleLinkTextTrue",false); }
        
        if(component.get("v.selectedTab") == '2'){
            component.set("v.isVisibleLinkTextTrue",false);
            var action=component.get("c.getSectorPickList");
            action.setCallback(this,function(response){
                var result = response.getReturnValue();
                var state = response.getState();
                if(state == "SUCCESS"){
                    if(result.sectorList.length > 0){
                        component.set("v.initWrapper.Sector.sectorList",result.sectorList);
                        
                    }else{
                        component.set("v.initWrapper.Sector.sectorList",'');
                    }
                    helper.setBusy(component,false);
                }
                else{
                    helper.showMessageToast('Hata .!','Error');
                    helper.setBusy(component,false);
                }
            })
            $A.enqueueAction(action);            
            
            component.set("v.initWrapper.ProductGroupList",'');
            component.set("v.initWrapper.Sector.subSectorList",'');
            component.set("v.isDisabledSubSectorPicklist",true);
            component.set("v.isDisabledProductGroupPicklist",true);
            component.set("v.selectedMainFair",'');
            component.set("v.selectedSubFair",'');
        }
        
        if(component.get("v.selectedTab") == '3'){ component.set("v.isVisibleLinkText",false); }
        

    },
    
    listByTab1 : function (component,event,helper){
        helper.setBusy(component,true);
        var selectedMainFair = component.get("v.selectedMainFair");
        var selectedSubFair = component.get("v.selectedSubFair");
        var currentPage = component.get("v.currentPage");
        
        if(selectedMainFair !=null && selectedMainFair != "" && selectedMainFair != undefined){
            var action=component.get("c.listByFairParticipation");
            action.setParams({"selectedMainFair" : selectedMainFair,
                              "selectedSubFair"  : selectedSubFair,
                              "currentPage"      : 0                           
                             });
            action.setCallback(this,function(response){
                var result = response.getReturnValue();
                var state = response.getState();
                if(state == "SUCCESS"){
                    if(result.accountList.length > 0){
                        component.set("v.isVisibleTable",true);
                        component.set("v.tableDatas",result.accountList);
                        component.set("v.pageSize",				 result.pageSize);                
                        component.set("v.recCount",				 result.recCount);
                        component.set("v.currentPage",			 result.currentPage);                
                        component.set("v.pageNumber",			 result.pageNumber);                
                        component.set("v.totalPage",			 result.totalPage);   
                        
                        
                        console.log("result :" , JSON.stringify(result));
                        helper.setBusy(component,false);
                    }else{
                        component.set("v.tableDatas",'');
                        component.set("v.isVisibleTable",false);
                        helper.showMessageToast('Firma Bulunamadı .!','Error');
                        helper.setBusy(component,false);
                    }
                }
                else{
                    component.set("v.isVisibleTable",false);
                    helper.showMessageToast('Hata .!','Error');
                    helper.setBusy(component,false);
                }
            })
            $A.enqueueAction(action);
        }else{
             helper.showMessageToast('Seçim Yapınız .!','Error');
             helper.setBusy(component,false);
        }
    },
    
    listByTab2 : function (component,event,helper){
        helper.setBusy(component,true);
        
        var currentPage = component.get("v.currentPage");
        var selectedMainSector    = component.get("v.selectedMainSector");
        var selectedSubSector 	  = component.get("v.selectedSubSector");
        var selectedProductGroup  = component.get("v.selectedProductGroup");
        var selectedPills 		  = component.get("v.selectedPills");
        var selectedTypeTab2      = component.get("v.selectedTypeTab2");	
        
        
        if(selectedTypeTab2 != null && selectedTypeTab2 != undefined && selectedTypeTab2 != ''){
            var action=component.get("c.listByFairSector");
            action.setParams({"selectedPills" :selectedPills,
                              "selectedTypeTab2" :selectedTypeTab2,
                              "currentPage":0});
            action.setCallback(this,function(response){
                var result = response.getReturnValue();
                var state = response.getState();
                if(state == "SUCCESS"){
                    if(result.accountList.length > 0){
                        component.set("v.isVisibleTable",true);
                        component.set("v.tableDatas",result.accountList);
                        component.set("v.pageSize",				 result.pageSize);                
                        component.set("v.recCount",				 result.recCount);
                        component.set("v.currentPage",			 result.currentPage);                
                        component.set("v.pageNumber",			 result.pageNumber);                
                        component.set("v.totalPage",			 result.totalPage);   
                        
                        helper.setBusy(component,false);
                    }else{
                        component.set("v.tableDatas",'');
                        component.set("v.isVisibleTable",false);
                        helper.showMessageToast('Firma Bulunamadı .!','Error');
                        helper.setBusy(component,false);
                    }
                }
                else{
                    component.set("v.isVisibleTable",false);
                    helper.showMessageToast('Hata .!','Error');
                    helper.setBusy(component,false);
                }
            })
            $A.enqueueAction(action);
        }else{
            helper.showMessageToast('Tip Seçiniz .!','Error');
             helper.setBusy(component,false);
        }
        
        
    },
    
    listByTab3 : function (component,event,helper){
        helper.setBusy(component,true);
        var selectedFair = component.get("v.selectedFair");
        var selectedTypeTab3 = component.get("v.selectedTypeTab3");
        
        
        if(selectedFair != null && selectedFair != "" && selectedFair != undefined){
            if(selectedTypeTab3 != null && selectedTypeTab3 != undefined && selectedTypeTab3 != ''){
                var action=component.get("c.listByFair");
                action.setParams({"selectedFair" :selectedFair,
                                  "selectedTypeTab3" : selectedTypeTab3,
                                 "currentPage":0});
                action.setCallback(this,function(response){
                    var result = response.getReturnValue();
                    var state = response.getState();
                    if(state == "SUCCESS"){
                        if(result.accountList.length > 0){
                            component.set("v.isVisibleTable",true);
                            component.set("v.tableDatas",result.accountList);
                            component.set("v.pageSize",				 result.pageSize);                
                            component.set("v.recCount",				 result.recCount);
                            component.set("v.currentPage",			 result.currentPage);                
                            component.set("v.pageNumber",			 result.pageNumber);                
                            component.set("v.totalPage",			 result.totalPage);   
                            
                            helper.setBusy(component,false);
                        }else{
                            component.set("v.tableDatas",'');
                            component.set("v.isVisibleTable",false);
                            helper.showMessageToast('Firma Bulunamadı .!','Error');
                            helper.setBusy(component,false);
                        }
                    }
                    else{
                        component.set("v.isVisibleTable",false);
                        helper.showMessageToast('Hata .!','Error');
                        helper.setBusy(component,false);
                    }
                })
                $A.enqueueAction(action);
            }else{
                helper.showMessageToast('Tip Seçiniz .!','Error');
                helper.setBusy(component,false);
            }
        } else{
            helper.showMessageToast('Fuar Seçimi Yapınız .!','Error');
            helper.setBusy(component,false);
        }
        
        
    },
    
    mainSectorOnChange : function(component,event,helper){
        helper.setBusy(component,true);
        var selectedMainSector = component.get("v.selectedMainSector");
        var recordId=component.get("v.recordId");        
        
        if(selectedMainSector == ''){
            component.set("v.initWrapper.Sector.subSectorList",'');
            component.set("v.initWrapper.ProductGroupList",'');
            helper.setBusy(component,false);
        }else{
            var action=component.get("c.getSubSectorList");
            action.setParams({"selectedMainSector" :selectedMainSector});
            action.setCallback(this,function(response){
                var result = response.getReturnValue();
                var state = response.getState();
                if(state == "SUCCESS"){
                    if(result.subSectorList.length > 0){
                        component.set("v.initWrapper.Sector.subSectorList",result.subSectorList);
                        component.set("v.initWrapper.ProductGroupList",'');
                        component.set("v.selectedSubSector",'');
                        component.set("v.selectedProductGroup",'');
                        component.set("v.isDisabledSubSectorPicklist",false);
                    }else{
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
        }else{
            var action=component.get("c.getProductGroupList");
            action.setParams({"selectedSubSector" :selectedSubSector});
            action.setCallback(this,function(response){
                var result = response.getReturnValue();
                var state = response.getState();
                if(state == "SUCCESS"){
                    if(result.length > 0){
                        component.set("v.selectedProductGroup",'');
                        component.set("v.initWrapper.ProductGroupList",result);
                        component.set("v.isDisabledProductGroupPicklist",false);
                    }else{
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
        cmp.set('v.pills', pills);
    },
    
    AddPill : function (component,event,helper){
        
        var selectedMainSector    = component.get("v.selectedMainSector");
        var selectedSubSector 	  = component.get("v.selectedSubSector");
        var selectedProductGroup  = component.get("v.selectedProductGroup");
        var selectedPills 		  = component.get("v.selectedPills");
        var pills 				  = component.get("v.pills");
        
        var pillLabel ='';
        var searchSet = '';
        var searchParam = '';
        if(selectedProductGroup != undefined && selectedProductGroup != null && selectedProductGroup != ''){
            
            selectedPills.push(selectedProductGroup);
            searchSet = 'v.initWrapper.ProductGroupList';
            searchParam = selectedProductGroup;
            pillLabel = helper.getPillLabel(component,event,helper,searchSet,searchParam);
            pills.push({type: 'icon', id:selectedProductGroup , label: pillLabel, iconName: 'standard:account'});
            component.set("v.pills",pills);
            
        }else if(selectedSubSector != undefined && selectedSubSector != null && selectedSubSector != ''){
            
            selectedPills.push(selectedSubSector);
            searchSet = 'v.initWrapper.Sector.subSectorList';
            searchParam = selectedSubSector;
            pillLabel = helper.getPillLabel(component,event,helper,searchSet,searchParam);
            pills.push({type: 'icon', id:selectedSubSector , label: pillLabel, iconName: 'standard:account'});
            component.set("v.pills",pills);
            
        }else if(selectedMainSector != undefined && selectedMainSector != null && selectedMainSector != ''){
            
            selectedPills.push(selectedMainSector);
            searchSet = 'v.initWrapper.Sector.sectorList';
            searchParam = selectedMainSector;
            pillLabel = helper.getPillLabel(component,event,helper,searchSet,searchParam);
            pills.push({type: 'icon', id:selectedMainSector , label: pillLabel, iconName: 'standard:account'});
            component.set("v.pills",pills);
            
        }else{
            helper.showMessageToast('Seçim Yapınız .!','Error');
        }
        
        
    },
    
    checkAllCheckboxesDesktop : function(component, event, helper) {
        
        var checkboxAllValue = component.find("cbxAll").get("v.checked");
        if(checkboxAllValue){
            var checkboxes = component.find("Cbx");
            for (var i = 0; i < checkboxes.length; i++){
                checkboxes[i].set("v.checked",true);
                component.set("v.selectedExcelRowCount",checkboxes.length);
            }
             component.set("v.isCheckedDesktop",true);
        }
        else{
            var checkboxes = component.find("Cbx");
            for (var i = 0; i < checkboxes.length; i++){
                checkboxes[i].set("v.checked",false);
            }
             component.set("v.isCheckedDesktop",false);
        }
    },
    checkAllCheckboxesMobile : function(component, event, helper) {
        
        var checkboxAllValue = component.find("cbxAllMobile").get("v.checked");
        if(checkboxAllValue){
            var checkboxes = component.find("Cbx");
            for (var i = 0; i < checkboxes.length; i++){
                checkboxes[i].set("v.checked",true);
                component.set("v.selectedExcelRowCount",checkboxes.length);
            }
            component.set("v.isCheckedMobile",true);
        }
        else{
            var checkboxes = component.find("Cbx");
            for (var i = 0; i < checkboxes.length; i++){
                checkboxes[i].set("v.checked",false);
            }
             component.set("v.isCheckedMobile",false);
        }
    },
    
    addSelectedItems : function(component,event,helper){
        var isValidSelect = component.find('PopupSelect').get("v.validity").valid;
        var cpm = component.find('popUpText');
        var isValidText = component.find('popUpText').get("v.validity").valid;
        var isValidDataType = component.find('PopupSelectType').get("v.validity").valid;
        
        if(isValidSelect && isValidText && isValidDataType){
            
            var accounts = [];
            var getAllId = component.find("Cbx");
            var popTag = component.get("v.PopupTag");
            var selectedFairPop = component.get("v.selectedPopupFair");
            var selectedPopupDataType = component.get("v.selectedPopupDataType");
            
            if(!Array.isArray(getAllId)){
                if (getAllId.get("v.checked") == true) {
                    accounts.push(getAllId.get("v.value"));
                }
            }else{
                for (var i = 0; i < getAllId.length; i++) {
                    if (getAllId[i].get("v.checked") == true) {
                        accounts.push(getAllId[i].get("v.value"));
                    }
                }
            }
            
            helper.addAccounts(component, event, helper, accounts,selectedFairPop,popTag,selectedPopupDataType);
        }else{
            helper.showMessageToast('Tüm Alanları Doldurunuz .!','Error');
        }
        
    },
    
    first : function(component,event,helper){
        
        if(component.get("v.selectedTab") == '1'){
            helper.list1(component,event,helper);
        }
        if(component.get("v.selectedTab") == '2'){
            helper.list2(component,event,helper);
        }
        if(component.get("v.selectedTab") == '3'){
            helper.list3(component,event,helper);
        }
        
    },
    
    next : function(component,event,helper){
        if(component.get("v.selectedTab") == '1'){
            helper.Next1(component,event,helper);
        }
        if(component.get("v.selectedTab") == '2'){
            helper.Next2(component,event,helper);
        }
        if(component.get("v.selectedTab") == '3'){
            helper.Next3(component,event,helper);
        }
    },
    
    prev : function(component,event,helper){
        if(component.get("v.selectedTab") == '1'){
            helper.Prev1(component,event,helper);
        }
        if(component.get("v.selectedTab") == '2'){
            helper.Prev2(component,event,helper);
        }
        if(component.get("v.selectedTab") == '3'){
            helper.Prev3(component,event,helper);
        }
    },
    
    last : function(component,event,helper){
     
        if(component.get("v.selectedTab") == '1'){
            helper.Last1(component,event,helper);
        }
        if(component.get("v.selectedTab") == '2'){
            helper.Last2(component,event,helper);
        }
        if(component.get("v.selectedTab") == '3'){
            helper.Last3(component,event,helper);
        }
        
    },
    
    /*---------------------------------Excel---------------------------------*/
    excelImport: function(component, event, helper) {
        if (component.find("excelUploadButton").get("v.files").length > 0) {

            helper.uploadHelper(component, event,helper);

        } else {
            helper.showMessage(component, "error","Please Select A File.");
        }
    },
    
    removeFiles: function(component, event, helper) {
        component.find('excelUploadButton').set('v.files', []);
        component.set("v.fileName", "");
        component.set("v.isExistFile",false);
        component.set("v.isUploaded",false);
        component.set("v.tableDatas",'');
        component.set("v.isVisibleTable",false);
    },	
    
    SaveExcel : function(component, event, helper){
        helper.setBusy(component,true);
        var excelResult =  component.get("v.excel");
        var action=component.get("c.saveExcel");
        action.setParams({"excel" : excelResult});
        action.setCallback(this, function(response) {
            var state = response.getState();
            var result=response.getReturnValue();
            console.log("result" , JSON.stringify(result));
            if(state == "SUCCESS"){
                if(result.length > 0){
                    component.set("v.isVisibleTable",true);
                    component.set("v.isVisibleLinkTextTrue",false);
                    component.set("v.tableDatas",result);
                    helper.setBusy(component,false);
                }else{
                    component.set("v.isVisibleLinkTextTrue",false);
                    component.set("v.tableDatas",'');
                    component.set("v.isVisibleTable",false);
                    helper.showMessageToast('Firma Bulunamadı .!','Error');
                    helper.setBusy(component,false);
                }
            }
            else{
                component.set("v.isVisibleTable",false);
                helper.showMessageToast('Hata .!','Error');
                helper.setBusy(component,false);
            }
        });
        $A.enqueueAction(action);
    },
})