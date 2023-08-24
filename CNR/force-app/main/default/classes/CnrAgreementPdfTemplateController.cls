public class CnrAgreementPdfTemplateController {
    
    ApexPages.StandardController controller;
    public RC_Fair__c f {get;set;}
    public RC_Fair__c fair {get;set;}
    
    public string accountName {get;Set;}
    public string imgSrc {get;set;}
    public Blob imgBlob {get;set;}

    
    public CnrAgreementPdfTemplateController(ApexPages.StandardController c) {
        
        system.debug('record ID:' + c.getRecord());
        controller = c;
        f          = (RC_Fair__c) c.getRecord(); 
        if(f.Id == null){
            return;
        }
        
        fair = [SELECT Id, RC_TR_Logo_ID__c,RC_Agreement_Text_TR__c,RC_Agreement_Rules_TR__c,RC_Agreement_Text_EN__c,RC_Agreement_Rules_EN__c FROM RC_Fair__c WHERE id =: f.id limit 1];
        

        List<RC_Fair__c> cnrFirm = [SELECT RC_CNR_Firm__r.Name FROM RC_Fair__c WHERE id =:fair.id];
        if(cnrFirm.size() > 0 && cnrFirm.get(0).RC_CNR_Firm__r!=null){
            accountName = cnrFirm.get(0).RC_CNR_Firm__r.Name.toLowerCase();
        }
        
        system.debug('accountName : ' + accountName);
        
        
        List<ContentVersion> asdas =  [SELECT Id, VersionData, ContentDocumentId FROM ContentVersion WHERE ContentDocumentId =: fair.RC_TR_Logo_ID__c LIMIT 1];
        if(asdas.size() > 0){
            imgBlob = asdas[0].VersionData;
            imgSrc = '/sfc/servlet.shepherd/version/download/' +asdas[0].id+ '?operationContext=S1';
        }else{
            imgSrc = 'empty';
        }
        
        system.debug('imgSrc' + imgSrc);        
        
        
        
        
        
        
        
        
        
        
       
        
        
        
        
        
        
    }
    
    
}