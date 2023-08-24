({
    setBusy : function(component, state){
        component.set("v.loading", state); 
    },
    
    showMessageToast : function(message,type) {
        
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            message: message,
            type: type,
            duration : 10
        });
        toastEvent.fire();
    },
    
    getPillLabel : function (component,event,helper,searchSet,searchParam){
        var liste = component.get(searchSet);
        for(var i = 0 ; i < liste.length  ; i++){
            if(searchParam == liste[i].value){
                return liste[i].label;
            }
        }
    },
    
    addAccounts: function(component, event, helper, accounts,selectedFairPop,popTag,selectedPopupDataType) {
        
        
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
        this.setBusy(component,true);
        var action = component.get('c.createOpportunity');
        
        action.setParams({
            "accounts": accounts,
            "selectedFairPop": selectedFairPop,
            "popUpTag" 		: popTag,
            "selectedPopupDataType" :selectedPopupDataType
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var result = response.getReturnValue();
            
            if (state === "SUCCESS") {
                if (result.state != false) {
                    //this.showMessageToast('Aktarım Başarılı','Success');
                    //this.setBusy(component,false);
                    this.checkJobStatus(component, result.jobIDList);
                    
                } else {
                    this.showMessageToast(result.errMsg,'Error');
                    this.setBusy(component, false);
                }
            }
            else{
                this.showMessageToast('Bir Hata Oluştu .!','Error');
                this.setBusy(component,false);
            }
        });
        $A.enqueueAction(action);
    },
    
    checkJobStatus : function(component, jobIDList){
        var action = component.get('c.isOpportunityCreated');
        console.log('Job ID List : ' + jobIDList);
        action.setParams({
            "jobIDList" : jobIDList
        });
        
        action.setCallback(this, function(response){
            var state  = response.getState();
            var result = response.getReturnValue();
            if(state === 'SUCCESS'){
                if(result.isCompleted === 0){
                    this.setBusy(component, false);
                    this.showMessageToast(result.message.replace(' | ', '\n'), 'Error');
                    
                    component.set("v.isVisibleTable",false);
                    component.set("v.isVisibleLinkTextFailed",true);
                    component.set("v.isModalOpen",false);
                }
                if(result.isCompleted === 1){   
                    this.setBusy(component, false);
                    this.showMessageToast(result.message, 'Success');
                    
                    component.set("v.isVisibleTable",false);
                    component.set("v.isVisibleLinkTextTrue",true);
                    component.set("v.isModalOpen",false);
                }
                if(result.isCompleted === 2){
                    this.checkJobStatus(component, jobIDList);
                    
                    component.set("v.isVisibleTable",false);
                    component.set("v.isModalOpen",false);
                }
                if(result.isCompleted === 3){
                    this.setBusy(component, false);
                    this.showMessageToast(result.message.replace(' | ', '\n'), 'Error');
                    
                    component.set("v.isVisibleTable",false);
                    component.set("v.isVisibleLinkTextFailed",true);
                    component.set("v.isVisibleLinkTextSuccess",true);
                    component.set("v.isModalOpen",false);
                }
            }
            else{
                this.showMessageToast('Bir Hata Oluştu .!','Error');
                this.setBusy(component,false);
            }
        });
        
        $A.enqueueAction(action);
    },
    
    list1  : function (component,event,helper){
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
    
    list2  : function (component,event,helper){
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
    
    list3  : function (component,event,helper){
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
    
    Next1 : function (component,event,helper){
        var selectedMainFair = component.get("v.selectedMainFair");
        var selectedSubFair = component.get("v.selectedSubFair");
        var currentPage = component.get("v.currentPage");
        
        var pageSize = component.get("v.pageSize");
        currentPage += pageSize;
        var pageNumber = component.get("v.pageNumber");    
        var totalPage = component.get("v.totalPage"); 
        if(component.get("v.pageNumber") < component.get("v.totalPage")){
            
            if(selectedMainFair !=null && selectedMainFair != "" && selectedMainFair != undefined){
                helper.setBusy(component,true);
                
                var action=component.get("c.listByFairParticipation");
                action.setParams({"selectedMainFair" : selectedMainFair,
                                  "selectedSubFair"  : selectedSubFair,
                                  "currentPage"      : currentPage                          
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
                            component.set("v.pageNumber",			(pageNumber + 1));                
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
        }
    },
    
    Next2 : function (component,event,helper){
        
        var currentPage = component.get("v.currentPage");
        var selectedMainSector    = component.get("v.selectedMainSector");
        var selectedSubSector 	  = component.get("v.selectedSubSector");
        var selectedProductGroup  = component.get("v.selectedProductGroup");
        var selectedPills 		  = component.get("v.selectedPills");
        var selectedTypeTab2      = component.get("v.selectedTypeTab2");	
        var pageSize = component.get("v.pageSize");
        
        currentPage += pageSize;
        var pageNumber = component.get("v.pageNumber");  
        var totalPage = component.get("v.totalPage");  
        
        if(component.get("v.pageNumber") < component.get("v.totalPage")){
            
            if(selectedTypeTab2 != null && selectedTypeTab2 != undefined && selectedTypeTab2 != ''){
                var action=component.get("c.listByFairSector");
                action.setParams({"selectedPills" :selectedPills,
                                  "selectedTypeTab2" :selectedTypeTab2,
                                  "currentPage":currentPage});
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
                            component.set("v.pageNumber",			 (pageNumber + 1));                 
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
            
        }
        
        
    },
    
    Next3 : function (component,event,helper){
        var currentPage = component.get("v.currentPage");
        var pageSize = component.get("v.pageSize");
        currentPage += pageSize;
        var pageNumber = component.get("v.pageNumber");    
        if(component.get("v.pageNumber") < component.get("v.totalPage")){
            
            helper.setBusy(component,true);
            var selectedFair = component.get("v.selectedFair");
            var selectedTypeTab3 = component.get("v.selectedTypeTab3");
            
            
            if(selectedFair != null && selectedFair != "" && selectedFair != undefined){
                if(selectedTypeTab3 != null && selectedTypeTab3 != undefined && selectedTypeTab3 != ''){
                    var action=component.get("c.listByFair");
                    action.setParams({"selectedFair" :selectedFair,
                                      "selectedTypeTab3" : selectedTypeTab3,
                                      "currentPage":currentPage});
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
                                component.set("v.pageNumber",			 (pageNumber + 1));                 
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
        }
        
    },
    
    Prev1 : function (component,event,helper){
        var currentPage = component.get("v.currentPage");
        var pageSize = component.get("v.pageSize");
        var pageNumber = component.get("v.pageNumber"); 
        var selectedMainFair = component.get("v.selectedMainFair");
        var selectedSubFair = component.get("v.selectedSubFair");
        
        currentPage -= pageSize;
        if(currentPage >= 0){
            
            
            if(selectedMainFair !=null && selectedMainFair != "" && selectedMainFair != undefined){
                helper.setBusy(component,true);
                
                var action=component.get("c.listByFairParticipation");
                action.setParams({"selectedMainFair" : selectedMainFair,
                                  "selectedSubFair"  : selectedSubFair,
                                  "currentPage"      : currentPage                          
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
                            component.set("v.pageNumber",			(pageNumber - 1));                
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
            
            
        }
    },
    
    Prev2 : function (component,event,helper){
        var currentPage = component.get("v.currentPage");
        var pageSize = component.get("v.pageSize");
        var pageNumber = component.get("v.pageNumber"); 
        var selectedMainSector    = component.get("v.selectedMainSector");
        var selectedSubSector 	  = component.get("v.selectedSubSector");
        var selectedProductGroup  = component.get("v.selectedProductGroup");
        var selectedPills 		  = component.get("v.selectedPills");
        var selectedTypeTab2      = component.get("v.selectedTypeTab2");	
        
        
        
        currentPage -= pageSize;
        if(currentPage >= 0){
            
            if(selectedTypeTab2 != null && selectedTypeTab2 != undefined && selectedTypeTab2 != ''){
                var action=component.get("c.listByFairSector");
                action.setParams({"selectedPills" :selectedPills,
                                  "selectedTypeTab2" :selectedTypeTab2,
                                  "currentPage":currentPage});
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
                            component.set("v.pageNumber",			 (pageNumber -1));                 
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
            
        }
        
        
    },
    
    Prev3 : function (component,event,helper){
        
        var currentPage = component.get("v.currentPage");
        var pageSize = component.get("v.pageSize");
        var pageNumber = component.get("v.pageNumber");    
        
        currentPage -= pageSize;
        if(currentPage >= 0){
            
            helper.setBusy(component,true);
            var selectedFair = component.get("v.selectedFair");
            var selectedTypeTab3 = component.get("v.selectedTypeTab3");
            
            
            if(selectedFair != null && selectedFair != "" && selectedFair != undefined){
                if(selectedTypeTab3 != null && selectedTypeTab3 != undefined && selectedTypeTab3 != ''){
                    var action=component.get("c.listByFair");
                    action.setParams({"selectedFair" :selectedFair,
                                      "selectedTypeTab3" : selectedTypeTab3,
                                      "currentPage":currentPage});
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
                                component.set("v.pageNumber",			 (pageNumber - 1));                 
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
            
        }
    },
    
    Last1 : function(component,event,helper){
        if(component.get("v.pageNumber") != component.get("v.totalPage")){
            helper.setBusy(component,true);
            var pagenumber = component.get("v.pageNumber");
            var totalpage = component.get("v.totalPage");
            var pageSize = component.get("v.pageSize");
            var countRec = component.get("v.recCount");
            var selectedMainFair = component.get("v.selectedMainFair");
            var selectedSubFair = component.get("v.selectedSubFair");
            
            if(selectedMainFair !=null && selectedMainFair != "" && selectedMainFair != undefined){
                
                
                var action=component.get("c.listByFairParticipation");
                action.setParams({"selectedMainFair" : selectedMainFair,
                                  "selectedSubFair"  : selectedSubFair,
                                  "currentPage"      : pageSize * (component.get("v.totalPage")-1)
                                 });
                action.setCallback(this,function(response){
                    var result = response.getReturnValue();
                    var state = response.getState();
                    if(state == "SUCCESS"){
                        if(result.accountList.length > 0){
                            component.set("v.isVisibleTable",true);
                            component.set("v.tableDatas",result.accountList);
                            
                            var pageNumber = component.get("v.pageNumber");
                            
                            component.set("v.currentPage",result.currentPage);
                            component.set("v.pageNumber",result.totalPage);
                            component.set("v.totalPage",result.totalPage);
                            
                            
                            
                            
                            
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
            
        }
    },
    
    Last2 : function(component,event,helper){
        if(component.get("v.pageNumber") != component.get("v.totalPage")){
            helper.setBusy(component,true);
            
            
            var pageSize = component.get("v.pageSize");
            var countRec = component.get("v.recCount");
            
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
                                  "currentPage":pageSize * (component.get("v.totalPage")-1)});
                action.setCallback(this,function(response){
                    var result = response.getReturnValue();
                    var state = response.getState();
                    if(state == "SUCCESS"){
                        if(result.accountList.length > 0){
                            component.set("v.isVisibleTable",true);
                            component.set("v.tableDatas",result.accountList);
                            
                            component.set("v.currentPage",result.currentPage);
                            component.set("v.pageNumber",result.totalPage);
                            component.set("v.totalPage",result.totalPage);
                            
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
            
        }
    },
    
    Last3 : function(component,event,helper){
        
        if(component.get("v.pageNumber") != component.get("v.totalPage")){
            helper.setBusy(component,true);
            
            var pageSize = component.get("v.pageSize");
            var countRec = component.get("v.recCount");
            var currentPage = component.get("v.currentPage");
            
            var selectedFair = component.get("v.selectedFair");
            var selectedTypeTab3 = component.get("v.selectedTypeTab3");
            
            
            if(selectedFair != null && selectedFair != "" && selectedFair != undefined){
                if(selectedTypeTab3 != null && selectedTypeTab3 != undefined && selectedTypeTab3 != ''){
                    var action=component.get("c.listByFair");
                    action.setParams({"selectedFair" :selectedFair,
                                      "selectedTypeTab3" : selectedTypeTab3,
                                      "currentPage":pageSize * (component.get("v.totalPage")-1)});
                    action.setCallback(this,function(response){
                        var result = response.getReturnValue();
                        var state = response.getState();
                        if(state == "SUCCESS"){
                            if(result.accountList.length > 0){
                                component.set("v.isVisibleTable",true);
                                component.set("v.tableDatas",result.accountList);
                                component.set("v.currentPage",result.currentPage);
                                component.set("v.pageNumber",result.totalPage);
                                component.set("v.totalPage",result.totalPage);
                                
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
            
        }
        
    },
    
    
    
    /*---------------------------------Excel---------------------------------*/
    
    MAX_FILE_SIZE: 3000000, //Max file size 4.5 MB 
    
    uploadHelper: function(component, event,helper) {
        helper.setBusy(component,true);
        // get the selected files using aura:id [return array of files]
        var fileInput = component.find("excelUploadButton").get("v.files");
        // get the first file using array index[0]  
        var file = fileInput[0];
        var fileName = file.name;
        var self = this;
        // check the selected file size, if select file size greter then MAX_FILE_SIZE,
        // then show a alert msg to user,hide the loading spinner and return from function  
        if (file.size > self.MAX_FILE_SIZE) {
            helper.showMessage(component, "error","Dosya 3MB boyuntundan büyük olamaz.");
            helper.setBusy(component,false);
            return;
        }
        
        // create a FileReader object 
        var objFileReader = new FileReader();
        // set onload function of FileReader object   
        objFileReader.onload = $A.getCallback(function() {
            var acceptList = component.get("v.acceptList");
            var fileContents = objFileReader.result;
            var base64 = 'base64,';
            var dataStart = fileContents.indexOf(base64) + base64.length;
            var splitted = file.name.split("."); 
            
            fileContents = fileContents.substring(dataStart);
            
            if(splitted.length > 1){
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
                    helper.showMessage(component, "error","Yanlış formatta bir dosya yüklediniz.");
                    component.set("v.isUploaded",false);
                    component.set("v.isExistFile",false);
                    helper.setBusy(component,false);
                    return;
                }
            }else{
                helper.showMessage(component, "error","HATA. ");
                component.set("v.isUploaded",false);
                component.set("v.isExistFile",false);
                helper.setBusy(component,false);
                return;
            }
            console.log("BASE64 :::" , fileContents);
            var action=component.get("c.getExcelData")
            action.setParams({"base64String" : fileContents});
            action.setCallback(this, function(response) {
                var state = response.getState();
                var result=response.getReturnValue();
                console.log("result" , JSON.stringify(result));
                if (result.State) {
                    if(result!=null && result!=''){
                        if(!result.sectorError){
                            component.set("v.isUploaded",true);
                            component.set("v.isExistFile",true);
                            component.set("v.fileName",fileName);
                            component.set("v.excel",result);
                            helper.showMessage(component, "success","Dosya Başarıyla Yüklendi.");
                            component.set("v.isVisibleDupliceTable",false);
                            component.set("v.tableDatas",'');
                            component.set("v.isVisibleTable",false);
                            component.set("v.isVisibleLinkTextTrue",false);
                        }else{
                            helper.showMessage(component, "error",result.ErrorMsg);
                        }
                    }
                }else{
                    component.set("v.tableDatas",'');
                    component.set("v.isVisibleTable",false);
                    component.set("v.isVisibleLinkText",false);
                    if(result.excelData.length > 0 && result.isDuplice){
                        component.set("v.isVisibleDupliceTable",true);
                        component.set("v.tableDupliceDatas",result.excelData);
                    }
                    
                    helper.showMessage(component, "error",result.ErrorMsg);
                    console.log("result" , JSON.stringify(result.excelData));
                    
                    
                }
                helper.setBusy(component,false);
            });
            $A.enqueueAction(action); 
            
        });
        
        objFileReader.readAsDataURL(file);
        
    },
    
    showMessage: function (component, type, message) {
        console.log('toast');
        var toastEvent = $A.get("e.force:showToast");
        if (toastEvent) {
            toastEvent.setParams({
                title: "",
                message: message,
                type: type
            });
            toastEvent.fire();
        }
    },
})