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
    
    createObjectData: function(component, event) {
        console.log("paymentTypeList:" + JSON.stringify(component.get("v.paymentTypeList")) ); 
        var RowItemList = component.get("v.paymentPlanList");
        RowItemList.push({
            'sobjectType': 'RC_Payment_Plan__c',
            'RC_Payment_Amount__c': '',
            'RC_Payment_Date__c': '',
            'RC_Payment_Type__c':component.get("v.paymentTypeList"),
            'RC_Sales_Person_Check__c' : false,
            'RC_Collector_Check__c' : false,
            'RC_Finance_Check__c' : false
        });
        component.set("v.paymentPlanList", RowItemList);
    },
    validateRequired: function(component, event) {
        var today = new Date();
        var dd = today.getDate();        
        var mm = today.getMonth()+1; 
        var yyyy = today.getFullYear();
        if(dd<10) 
            dd='0'+dd;        
        if(mm<10)
            mm='0'+mm;
        today = yyyy+'-'+mm+'-'+dd;
        
        var isValid = true;
        var validMessage = "";
        var allPaymentRows = component.get("v.paymentPlanList");            
        var calculatedAdvancePayment = component.get("v.initWrapper").calculatedAdvancePaymentAmount;
        var advancePaymentDate = component.get("v.initWrapper").advancePaymentDate;
        
        for (var indexVar = 0; indexVar < allPaymentRows.length; indexVar++) {    
            if (allPaymentRows[indexVar].Amount == '') {
                isValid = false;
                alert('Amount not Blank on Row Number ' + (indexVar + 1));
            }
            if(allPaymentRows[indexVar].RC_Installment__c == 1){
                if(allPaymentRows[indexVar].RC_Payment_Amount__c < calculatedAdvancePayment){
                    isValid = false;
                    validMessage += "<b>&#8226; Peşinat Tutarı " + calculatedAdvancePayment + " den az olamaz.<b><br />";
                }
                
                if((allPaymentRows[indexVar].RC_Payment_Date__c > advancePaymentDate) || (allPaymentRows[indexVar].RC_Payment_Date__c < today)){                    
                    isValid = false;
                    validMessage += "<b>&#8226; Peşinat Tarihi " + advancePaymentDate + " tarihinden sonra, " + today + " tarihinden önce olamaz.<b/><br \>"
                }
            }
        }
        
        var btn=component.find("btnSave");
        if(!isValid){            
            btn.set('v.disabled',true);  
            component.set("v.isAdvancePaymentValid", true);
            component.set("v.advancePaymentValidationMessage", validMessage);
        }           
        else{            
            btn.set('v.disabled',false);             
            component.set("v.isAdvancePaymentValid", false);
            component.set("v.advancePaymentValidationMessage", "");
        }
        
        
        return isValid;
    },
    doInitHelper: function(component, event, helper) {
        var btn=component.find("btnSave");
        btn.set('v.disabled',true);  
        helper.createObjectData(component, event);
        var recordId=component.get("v.recordId");
        var action = component.get("c.getInit");
        action.setParams({"recordId" :recordId });
        action.setCallback(this, function(response){
            var result = response.getReturnValue();
            console.log("result:" + JSON.stringify(result));
            var state = response.getState();
            if(result!=null && state=="SUCCESS"){
                console.log("opp:" + result.opportunity);
                component.set("v.initWrapper",result);
                component.set("v.userProfile",result.userProfile);
                component.set("v.approvalStage",component.get("v.initWrapper.opportunity.StageName"));
                component.set("v.currIsoCode",component.get("v.initWrapper.opportunity.CurrencyIsoCode"));
                console.log("approvalStage" + component.get("v.approvalStage"));
                component.set("v.moneyOrder",result.moneyOrder);
                component.set("v.paymentTypeList",result.paymentTypes);
                if(result.fixedPayWrapper!=null)
                {
                    
                    var usrProfile=component.get("v.userProfile");
                    if(usrProfile=='CNR Collector' || usrProfile=='System Administrator')
                    {
                        component.set("v.fixedPay",false);
                    }
                    else
                    {
                        component.set("v.fixedPay",true);
                    }
                    
                    var btnCashPay1=component.find("btnCashPay1");
                    if(btnCashPay1!=null)
                    {
                        component.set("v.cashDisabled",true);
                    }
                }
                if(result.opportunity.RC_Final_Total__c>0){
                    component.set("v.hasPaymentValue",true);
                    
                    if(result.PaymentPlan.length>0){
                        component.set("v.paymentPlanList",result.PaymentPlan);
                        console.log("result.PaymentPlan.length:" + result.PaymentPlan.length);
                        
                        if(result.PaymentPlan.length==1)
                        {
                            console.log("1 mi ?");
                            component.set("v.cashActive",false);
                            component.set("v.instActive",true);
                        }
                        
                    }
                    else{
                        component.set("v.isEmptyPlan",true);
                    }                    
                }
                else{
                    component.set("v.hasPaymentValue",false);
                }
                
                this.disabledCheck(component,helper);
                
            }
        });
        $A.enqueueAction(action);
    },
    disabledCheck : function(component,helper){
        
        var cshPayment=component.get("v.cashPayment");
        var apprStage=component.get("v.approvalStage");
        var usrProfile=component.get("v.userProfile");
        if(usrProfile=='System Administrator')
        {
            // component.set("v.userProfile","CNR Sales");  
        }
        if(cshPayment)
        {
            console.log('csh');
            component.set("v.disabled",true); 
        }
        else
        {
            
            if(usrProfile=='System Administrator')
            {
                component.set("v.disabled",false);
                component.set("v.disabledDoc",false);
            }
            if(usrProfile=='CNR Sales' || usrProfile=='CNR Group Manager' || usrProfile=='CNR Sales Manager')
            {
                if(apprStage=='Negotiation')
                {
                    component.set("v.disabled",false);
                }
                if(apprStage=='Agreement'  || apprStage=='Advance Payment')
                {
                    component.set("v.disabledDoc",false);
                }
            }
            if(usrProfile=='CNR Collector')
            {
                if(apprStage=='Agreement'  || apprStage=='Advance Payment')
                {
                    component.set("v.disabled",false);
                    component.set("v.disabledDoc",false);
                }
            }
            if(usrProfile=='CNR Finance')
            {
                component.set("v.disabled",true);
                if(apprStage=='Advance Payment' ||apprStage=='Agreement' )
                    component.set("v.disabledDoc",false);
            }
        }
    },
    calculate : function(component,event,helper)
    {
        if (helper.validateRequired(component, event)) {
            var btn=component.find("btnSave");
            btn.set('v.disabled',true); 
            var cmpIcon = component.find('iconWarning');
            $A.util.addClass(cmpIcon, 'showIcon');
            var action = component.get("c.CalculateAvgMaturity");
            console.log("paymentPlanList" + JSON.stringify(component.get("v.paymentPlanList")));
            action.setParams({
                "paymentPlanStringify" : JSON.stringify(component.get("v.paymentPlanList")),
                "recordId" : component.get("v.recordId")
            });
            action.setCallback(this, function(response) {
                var result = response.getReturnValue();
                
                var state = response.getState();
                if (state === "SUCCESS") {
                    if(result.hasError==false){
                        component.set("v.AvgPayDate",result.paymentPlan.RC_Payment_Date__c);
                        var avgMatDate=component.get("v.initWrapper.opportunity.RC_Average_Maturity_Date__c");
                        console.log("avgMatDate1:" + avgMatDate);
                        if(avgMatDate!=null){
                            console.log("avgMatDate2:" + avgMatDate);
                        }
                        else{
                            var dateCalc = new Date();
                            dateCalc.setDate(dateCalc.getDate() + component.get("v.initWrapper.opportunity.RC_Average_Maturity_Days__c"));
                            avgMatDate = $A.localizationService.formatDate(dateCalc, "YYYY-MM-DD");
                            console.log("avgMatDate3:" + avgMatDate);
                        }
                        console.log('avgPayD:' + component.get("v.AvgPayDate"));
                        var startDate = new Date(avgMatDate), 
                            endDate =  new Date(component.get("v.AvgPayDate")),
                            days = (endDate-startDate)/8.64e7;
                        
                        console.log("Date Diff : " + (endDate-startDate));
                        
                        console.log('Math.abs(days) without math : ' + days);
                        console.log('Math.abs(days) : ' + Math.abs(days));
                        //component.set("v.diffDate",	Math.abs(days));
                        component.set("v.diffDate",	days);
                        component.set("v.calculated",true);
                        component.set("v.dateError",false); 
                        console.log("totlPay:", result.totalPayment);
                        console.log("totalInstPayment:", result.paymentPlan.RC_Payment_Amount__c);
                        
                        component.set("v.calcTotalPayment",result.diffPayment);
                        if(result.diffPayment==0)
                        {
                            component.set("v.hasCalculateTrue",true);
                            btn.set('v.disabled',false);
                            
                        }
                        else
                        {
                            var cmpIcon = component.find('iconWarning');
                            $A.util.removeClass(cmpIcon, 'showIcon');
                            btn.set('v.disabled',true);   
                            component.set("v.hasCalculateTrue",false); 
                        }
                        console.log('123456:');
                    }
                    else{
                        console.log('1234567:');
                        component.set("v.dateError",true); 
                        component.set("v.calculated",false);
                        btn.set('v.disabled',true); 
                        component.set("v.hasCalculateTrue",false);
                    }
                    
                    
                }
            });
            $A.enqueueAction(action);
        }
    }
})