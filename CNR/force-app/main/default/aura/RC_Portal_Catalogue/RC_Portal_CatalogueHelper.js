({
    setBusy : function (component, state){
        component.set("v.loading", state); 
    },
    
    cataloguePreview : function (component,accountName,contactName,BillAddress,Email,Phone,contactPhone,FirmInfoTR,FirmInfoEN) {
        //debugger;
        //var vfMethod=component.get("v.VfPageMethod");
        //vfMethod(accountName,contactName,Type,Address,Email,Phone,Fax,FirmInfoTR,FirmInfoEN, function(){});
        //this.getMessageFromComp(component,accountName,contactName,Type,BillAddress,Email,Phone,Fax,FirmInfoTR,FirmInfoEN);
        this.getMessageFromComp(component,accountName,contactName,BillAddress,Email,Phone,contactPhone,FirmInfoTR,FirmInfoEN);
    },
    
    getPillLabel : function (component,event,helper,searchSet,searchParam){
        //debugger;
        var liste = component.get(searchSet);
        for(var i = 0 ; i < liste.length  ; i++){
            if(searchParam == liste[i].value){
                return liste[i].label;
            }
        }
    }, 
    
    getMessageFromComp : function (component,accountName,contactName,Address,Email,Phone,contactPhone,FirmInfoTR,FirmInfoEN){
       
        this.openModel();
        var accountNameElement = document.getElementById('accountName');
        accountNameElement.innerText = accountName;
        
        var attch = component.get("v.attachments");
        if(attch != null && attch.length> 0)
        {
            var imgItem = document.getElementById('imgLogo');
            imgItem.src = "data:image/png;base64, " + attch[0].Body;
        }
        
        var contactNameElement = document.getElementById('contactName');
        contactNameElement.innerText = " : " + contactName;
        
        //var TypeElement = document.getElementById('Type');
        //TypeElement.innerText = " : " + Type;
        
        var AddressElement = document.getElementById('Address');
        AddressElement.innerText = " : " + Address;
        
        var EmailElement = document.getElementById('Email');
        EmailElement.innerText = " : " + Email;
        
        var PhoneElement = document.getElementById('Phone');
        PhoneElement.innerText = " : " + Phone;
        
        var FaxElement = document.getElementById('Fax');
        FaxElement.innerText = " : " + contactPhone;
        
        var FirmInfoTRElement = document.getElementById('FirmInfoTR');
        FirmInfoTRElement.innerText = FirmInfoTR;
        
        var FirmInfoENElement = document.getElementById('FirmInfoEN');
        FirmInfoENElement.innerText = FirmInfoEN;
        
        var brands = component.get("v.brands");
        var pills = component.get("v.pills");
        var brandsElement = document.getElementById('brandsList');
        brandsElement.innerText = "";
        for(var i=0; i<brands.length; i++){
            brandsElement.innerText += ", " + brands[i].label;
        }
        brandsElement.innerText = brandsElement.innerText.substring(2, brandsElement.innerText.length);
        brandsElement.innerText = " : " + brandsElement.innerText;
        
        var pillsElement = document.getElementById('pillList');
        pillsElement.innerText = "";
        for(var i=0; i<pills.length; i++){
            pillsElement.innerText += ", " + pills[i].label;
        }
        pillsElement.innerText = pillsElement.innerText.substring(2, pillsElement.innerText.length);
        pillsElement.innerText = " : " + pillsElement.innerText;
    },
    
    openModel : function() {
        //debugger;
        var modal = document.getElementById('modal');
        var modaloverlay = document.getElementById('modaloverlay');
        modal.style.display = 'block';
        modaloverlay.style.display = 'block';
    },
    
    closeModal : function() {
        var modal = document.getElementById('modal');
        var modaloverlay = document.getElementById('modaloverlay');
        modal.style.display='none';
        modaloverlay.style.display='none';
    },    
    
    RedirectToUrl : function(pagename,iswindowopen) {
        //debugger;
        var url = window.location.search.substring(1);              
        if(url == ""){  
            if(iswindowopen){
                window.open(window.location.href.substring(0, window.location.href.indexOf("/s")) + pagename,"_self");
            }
            else{
                var newurl = window.location.href.substring(0, window.location.href.indexOf("/s")) + '/s/' + pagename;
                return newurl;
            }
        }
        else{
            var sep="?";
            if(iswindowopen)
            {
                window.open(window.location.href.substring(0, window.location.href.indexOf("/s")) + pagename + sep + url,"_self");
            }
            else{
                var newurl=window.location.href.substring(0, window.location.href.indexOf("/s")) + '/s/' + pagename + sep + url;            
                return newurl;
            }
        }
    },
    
    showMessageToast : function(component,type,message) {
        //console.log('toast');
        var toastEvent = $A.get("e.force:showToast");
        if(toastEvent){
            toastEvent.setParams({
                title: "",
                message: message,
                type: type
            });
            toastEvent.fire();
        }
    }
})