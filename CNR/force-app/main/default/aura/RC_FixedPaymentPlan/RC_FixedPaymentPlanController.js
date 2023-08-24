({
    doInit : function(component, event, helper) {
        component.set("v.loading",true);
        var action=component.get("c.Init");
        var recordId=component.get("v.recordId");
        action.setParams({
            "recordId" : recordId 
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result=response.getReturnValue();
                console.log(result);
                component.set("v.paymentPlanList",result.payList);
                component.set("v.paymentTypes" , result.paymentTypes);
                component.set("v.loading",false);  
                if(result.agreementStatus)
                {
                    component.set("v.disabled",true);
                    component.set("v.loading",false);
                    helper.showMessageToast("Bu fiyat listesi kullanılarak oluşturulmuş sözleşme mevcuttur,sabit ödeme planı değerleri değiştirilemez.","Error");
                }
                
            }
        });
        $A.enqueueAction(action);  
    },
    SaveFixedPayment : function(component,event,helper)
    {
        var allValid = component.find('fieldId').reduce(function (validSoFar, inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && !inputCmp.get('v.validity').valueMissing;
        }, true);
        if(allValid)
        {
            component.set("v.loading",true);
            
            
            var action=component.get("c.Save");
            var recordId=component.get("v.recordId");
            action.setParams({
                "recordId" : recordId,
                "paymValues" : component.get("v.paymentPlanList")
            });
            action.setCallback(this, function(response) {
                
                var state = response.getState();
                if (state === "SUCCESS") {
                    var result=response.getReturnValue();
                    console.log(result);
                    if(result.returnStatus)
                    {
                        component.set("v.loading",false);
                        helper.showMessageToast("Sabit Ödeme Planı Başarı ile Kaydedilmiştir.","Success")
                    }
                    else{
                        component.set("v.loading",false);
                        if(result.returnMessage!='' && result.returnMessage!=null)
                            helper.showMessageToast(result.returnMessage,"Error");  
                        else
                            helper.showMessageToast("Sabit Ödeme Planı Kaydedilirken Hata Oluştu.","Error");
                    }
                    
                }
            });
            $A.enqueueAction(action);  
        }
        else{
            
            helper.showMessageToast("Lütfen zorunlu alanları doldurunuz.","Error");
        }
        
    }
})