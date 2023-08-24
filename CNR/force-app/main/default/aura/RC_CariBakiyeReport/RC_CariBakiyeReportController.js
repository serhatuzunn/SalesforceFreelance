({
    init : function(component, event, helper) {
        var recordId=component.get("v.recordId");
        console.log("recordId:" + recordId);
        var action=component.get("c.Init");
        action.setParams({"pageID" :recordId});
        action.setCallback(this,function(response){
            var result = response.getReturnValue();
            var state = response.getState();
            if(state == "SUCCESS"){
                //component.set("v.tableDatas",result);
                if(result!=null)
                {
                    console.log("cekdurumu" + result.length);
                    if(result.length > 0)
                    {
                        if(result[0].cekdurumu != ""){
                            component.set("v.cekdurumu",true);
                        }
                        else{
                            component.set("v.cekdurumu",false); 
                        }
                        component.set("v.isVisible","");
                        
                        if(result[0].bakiye > 0){
                            component.set("v.bakiye","Artı bakiye bulunmaktadır."); 
                        }
                        else{
                            component.set("v.bakiye","Artı bakiye bulunmamaktadır."); 
                        }
                    }
                    else{
                        component.set("v.isVisible","displaynone");
                    }
                }
                else{
                    component.set("v.isVisible","displaynone");
                }
                
            }
            else{
                alert("Data çekilirken hata!");
            }
        })
        $A.enqueueAction(action);
    }
})