({
    showMessage : function(component,type,message) {
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
    },
    
    RedirectToUrl : function(pagename,iswindowopen) {
        //debugger;
        var url = window.location.search.substring(1);              
        if(url == ""){  
            if(iswindowopen){
                window.open(window.location.href.substring(0, window.location.href.indexOf("/s")) + pagename,"_self");
            }
            else{
                var newurl=window.location.href.substring(0, window.location.href.indexOf("/s")) + '/s/' + pagename;
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
    }
})