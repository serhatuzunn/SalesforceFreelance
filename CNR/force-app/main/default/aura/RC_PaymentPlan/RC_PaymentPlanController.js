({
    doInit:function(component,event,helper){
        //alert(screen.width + 'x' + screen.height);
        helper.doInitHelper(component,event,helper);
    },
    addNewRow: function(component, event, helper) {
        helper.createObjectData(component, event);
    },
    removeDeletedRow: function(component, event, helper) {
        var index = event.getParam("indexVar");
        var AllRowsList = component.get("v.paymentPlanList");
        AllRowsList.splice(index, 1);
        component.set("v.paymentPlanList", AllRowsList);
    },
    cashPayment: function(component, event, helper) {
        component.set("v.cashActive",false);
        component.set("v.instActive",true);
        var paymentPlanList=component.get("v.paymentPlanList");
        if(paymentPlanList.length>0)
            paymentPlanList=paymentPlanList[0];
        paymentPlanList.RC_Payment_Amount__c=component.get("v.initWrapper.opportunity.RC_Final_Total__c");
        component.set("v.cashPayment",true);
        var dateCalc = new Date();
        dateCalc.setDate(dateCalc.getDate() + 7);
        var avgMatDate = $A.localizationService.formatDate(dateCalc, "YYYY-MM-DD");
        console.log("date:" + avgMatDate);
        paymentPlanList.RC_Payment_Date__c=avgMatDate;
        component.set("v.paymentPlanList", paymentPlanList);
        component.set("v.calculated",false);
        
        
    },
    instPayment: function(component, event, helper) {
        component.set("v.cashActive",true);
        component.set("v.instActive",false);
        component.set("v.cashPayment",false);
        component.set("v.calculated",false);
        helper.doInitHelper(component,event,helper);
    },
    Save: function(component, event, helper) {
        component.set("v.isModalOpen", false);
        helper.setBusy(component,true);
        console.log('compavg' + component.get("v.AvgPayDate"));
        if (helper.validateRequired(component, event)) {
            helper.calculate(component,event,helper);
            window.setTimeout(
                $A.getCallback(function() {
                    if(component.get("v.hasCalculateTrue")){
                        var action = component.get("c.SavePaymentPlan");
                        action.setParams({
                            "paymentPlanStringify" : JSON.stringify(component.get("v.paymentPlanList")),
                            "recordId" : component.get("v.recordId"),
                            "avgPaymentDate" : component.get("v.diffDate"),
                            "fixedPayment" :component.get("v.initWrapper.fixedPayWrapper"),
                            "avgD": component.get("v.AvgPayDate")
                        }); 
                        action.setCallback(this, function(response) {

                            var state = response.getState();
                            if (state === "SUCCESS") {
                                
                                var result=response.getReturnValue();
                                console.log('result', result);
                                if(result==true){
                                    helper.setBusy(component,false);
                                    helper.showMessageToast('Ödeme Planı oluşturuldu','Success');
                                    component.set("v.dateError",false); 
                                    component.set("v.calculated",false);
                                    window.setTimeout(
                                        $A.getCallback(function() {
                                            location.reload();
                                        }), 2000
                                    );
                                    
                                }
                                else{

                                    helper.showMessageToast('Ödeme Planı oluşturulurken hata alındı','Error');  
                                }
                            }
                        });
                        // enqueue the server side action  
                        $A.enqueueAction(action);

                        helper.setBusy(component,false);
                    }
                    else{
                        helper.setBusy(component,false);
                        helper.showMessageToast('Lütfen oluşturduğunuz ödeme planınızı kontrol ediniz.','Error');
                    }
                }), 3000
            );
            
            
        }
    },
    CheckSave: function(component,event,helper){
        var action = component.get("c.SaveChecks");
        action.setParams({
            "paymentPlanStringify" : JSON.stringify(component.get("v.paymentPlanList")),
            "recordId" : component.get("v.recordId")
        }); 
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                console.log("result:" + JSON.stringify(result));
                if(result){
                    helper.showMessageToast('Çek bilgileri güncellendi','Success');
                    window.setTimeout(
                        $A.getCallback(function() {
                            location.reload();
                        }), 2000
                    );
                }
                else{
                    helper.showMessageToast('Çek bilgileri güncellenirken hata oluştu.','Error'); 
                }
            }
            
        });
        $A.enqueueAction(action); 
    },
    calculate: function(component,event, helper) {
        helper.calculate(component,event,helper);
    },
    openModel: function(component, event, helper) {
        // Set isModalOpen attribute to true
        component.set("v.isModalOpen", true);
    },
    
    closeModel: function(component, event, helper) {
        // Set isModalOpen attribute to false  
        component.set("v.isModalOpen", false);
        component.set("v.isAdvancePaymentValid", false);
    }
    
})