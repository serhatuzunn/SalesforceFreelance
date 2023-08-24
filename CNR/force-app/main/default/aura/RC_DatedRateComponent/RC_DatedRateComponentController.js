({
    init : function(component, event, helper){
        var action = component.get("c.RC_GetDateRates");
        action.setCallback(this,function(response){
            var result = response.getReturnValue();
            var state = response.getState();
            console.log("result: " + JSON.stringify(result));
            if(state == "SUCCESS"){
                for(var i=0; i<result.length; i++){
                    component.set("v.rateDate", result[i].conversionRateDate);
                    if(result[i].conversionIsoCode == 'USD'){
                        component.set("v.dolarRate", result[i].conversionDolarRate);
                    }
                    if(result[i].conversionIsoCode == 'EUR'){
                        component.set("v.euroRate", result[i].conversionEuroRate);
                    }
                }
            }
            else{
                console.log("HATA");
            }
        })
        $A.enqueueAction(action);
    }
})