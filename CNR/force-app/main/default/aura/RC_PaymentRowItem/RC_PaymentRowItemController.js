({
    doInit: function(component, event, helper) {
        var action = component.get("c.getPaymentType");
        var moneyOrder=component.get("v.moneyOrder");
        
        var cshPayment=component.get("v.cashPayment");
        var fixedPay=component.get("v.fixedPayValue");
        console.log("fixedPay:" + fixedPay);
        var apprStage=component.get("v.approvalStage");
        var usrProfile=component.get("v.userProfile");
        
        component.set("v.currentPPIValue", component.get("v.paymentPlanInstance.RC_Payment_Amount__c"));
        
        if(cshPayment)
        {
            component.set("v.disabled",true); 
        }
        else
        {
            if(usrProfile=='System Administrator'){
                //component.set("v.userProfile","CNR Collector"); 
                //usrProfile="CNR Collector";
                component.set("v.disabled",false);
                component.set("v.disabledCheckBox",false);
                component.set("v.checkDisabledSales",false);
                component.set("v.checkDisabledFinance",false);
                component.set("v.checkDisabledCollector",false);
            }
            if(usrProfile=='CNR Sales' || usrProfile=='CNR Sales Manager' || usrProfile=='CNR Group Manager')
            {
                component.set("v.checkDisabledFinance",true);
                component.set("v.checkDisabledCollector",true);
                component.set("v.checkDisabledSales",false);
                if(apprStage=='Negotiation')
                {
                    component.set("v.disabled",false);
                }
                if(apprStage=='Agreement'  || apprStage=='Advance Payment')
                {
                    component.set("v.disabledCheckBox",false);
                }
                
            }
            if(usrProfile=='CNR Collector')
            {
                component.set("v.checkDisabledSales",true);
                component.set("v.checkDisabledFinance",true);
                component.set("v.checkDisabledCollector",false);
                if(apprStage=='Agreement' || apprStage=='Advance Payment')
                {
                    component.set("v.disabled",false);
                    component.set("v.disabledCheckBox",false);
                }
                
            }
            if(usrProfile=='CNR Finance')
            {
                component.set("v.checkDisabledSales",true);
                component.set("v.checkDisabledFinance",false);
                component.set("v.checkDisabledCollector",true);
                if(apprStage=='Agreement' || apprStage=='Advance Payment')
                {
                    var chkBox = component.find("cbxAllCollector");
                    var chkBoxValue=chkBox.get("v.checked");
                    if(chkBoxValue)
                        component.set("v.disabledCheckBox",false);
                }
                
            }
            
        }
        //Sabit ödeme planı ise alanlar disabled olur
        if(fixedPay)
        {
            console.log("sadasd");
            component.set("v.disabled",true); 
        }
        
        
        action.setParams({"moneyOrder" : moneyOrder });
        action.setCallback(this, function(response){
            var result = response.getReturnValue();
            console.log("result:" + JSON.stringify(result));
            var state = response.getState();
            if(result!=null && state=="SUCCESS"){
                console.log("opp:" + result.opportunity);
                component.set("v.paymentTypeList",result);
            }
        });
        $A.enqueueAction(action);
    },
    AddNewRow : function(component, event, helper){
        // fire the AddNewRowEvt Lightning Event 
        component.getEvent("AddRowEvt").fire();     
    },
    
    removeRow : function(component, event, helper){
        // fire the DeleteRowEvt Lightning Event and pass the deleted Row Index to Event parameter/attribute
        component.getEvent("DeleteRowEvt").setParams({"indexVar" : component.get("v.rowIndex") }).fire();
    }, 
    checkAllCheckboxesSales : function(component, event, helper) {
        var chkBox = component.find("cbxAllSales");
        var chkBoxValue=chkBox.get("v.checked");
        chkBox.set("v.value",chkBoxValue);        
    },
    checkAllCheckboxesCollector : function(component, event, helper) {
        var chkBox = component.find("cbxAllCollector");
        var chkBoxValue=chkBox.get("v.checked");
        chkBox.set("v.value",chkBoxValue);        
    },
    checkAllCheckboxesFinance : function(component, event, helper) {
        var chkBox = component.find("cbxAllFinance");
        var chkBoxValue=chkBox.get("v.checked");
        chkBox.set("v.value",chkBoxValue);       
    },
    onTestclick : function(component, event, helper) {
        debugger;
    }
    
    
})