/* navToRecordController.js */
({	
    init : function(component, event, helper){
        var recordId=component.get("v.recordId");
        var action=component.get("c.findObjectNameFromRecordIdPrefix");
        action.setParams({"recordIdOrPrefix" :recordId});
        action.setCallback(this,function(response){
            var result = response.getReturnValue();
            var state = response.getState();
            if(state == "SUCCESS"){
                if(result == 'Opportunity'){
                    component.set("v.isAgreementPDF", true);
                    component.set("v.isFairPDF", false);
                }
                if(result == 'RC_Fair__c'){
                    component.set("v.isAgreementPDF", false);
                    component.set("v.isFairPDF", true);
                }
            }
        })
        $A.enqueueAction(action);
    },
    
    handlePdfSelection : function(component, event, helper){
        
        var name = event.getSource().get('v.name');
        var label = event.getSource().get('v.label');
        console.log('label: ' , label);
        component.set("v.selectedPdf", name);
        component.set("v.selectedPdfLabel", label);
        debugger;
        if(name.startsWith("Kk")){
            component.set("v.showCheckBoxesKk", true);
            component.set("v.showCheckBoxes", false);
        }else if(name.startsWith("Ks")){
            component.set("v.showCheckBoxes", true);
            component.set("v.showCheckBoxesKk", false);
        }else{
            component.set("v.showCheckBoxes", false);
            component.set("v.showCheckBoxesKk", false);
        }
    },
    
    handleNavigate : function(component, event, helper){
        
        var operation = event.getSource().get('v.name');
        var selectedPdf = component.get("v.selectedPdf");
        
        if(selectedPdf == null || selectedPdf == '' || !selectedPdf){
            helper.showMessage(component, 'error', 'PDF seçiniz!');
            return;
        }
        var recordId = component.get("v.recordId");
        var showImages = component.get("v.showImages");
        var showVats = component.get("v.showVats");
        var projectQuotation = component.get("v.projectQuotation");
        
        var url = "/apex/" + selectedPdf + operation + "?id=" + recordId;
        
        if(selectedPdf.startsWith("Ks")){
            
            url = url + "&showImages=" + showImages + "&showVats=" + showVats;
        }
        if(selectedPdf.startsWith("Ks")){
            
            url = url + "&projectQuotation=" + projectQuotation + "&projectQuotation=" + projectQuotation;
        }
        if(selectedPdf.startsWith("Kk")){
            url = url + "&showImages=" + showImages + "&showVats=" + showVats;
        }
        
        var useNavigate = true;
        try
        {
            var factor = $A.get("$Browser.formFactor");
            if(factor == "TABLET" || factor == "PHONE") 
            {
                useNavigate = false;
            }
        }
        catch(err)
        {
            console.log(err);
        }
        if(useNavigate)
        {
            var urlEvent = $A.get("e.force:navigateToURL");
            urlEvent.setParams({
                "url": url,
                "isredirect": false
            });
            urlEvent.fire();
        }
        else 
        {
            var baseUrl = window.location;
            var redirectUrl = baseUrl.protocol +"//"+ baseUrl.host + url;
            //window.location.href = redirectUrl;
            window.open(redirectUrl, '_blank');
        }
    }
})