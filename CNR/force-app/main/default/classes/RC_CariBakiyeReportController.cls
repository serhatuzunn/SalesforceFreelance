public without sharing class RC_CariBakiyeReportController {
    public class initWrapper{
        @AuraEnabled
        public string bakiye {get;set;}
        @AuraEnabled
        public string cariref {get;set;}
        @AuraEnabled
        public string kodu {get;set;}
        @AuraEnabled
        public string masrafmerkezi {get;set;}
        @AuraEnabled
        public string odemeplani {get;set;}
        @AuraEnabled
        public string projekodu {get;set;}
        @AuraEnabled
        public string risklimit {get;set;}
        @AuraEnabled
        public string sehir {get;set;}
        @AuraEnabled
        public string unvani {get;set;}
        @AuraEnabled
        public string cekdurumu {get;set;}
    }
    @AuraEnabled
    public static List<initWrapper> Init(Id pageID){
        try{
            String firmno = '301';
            String periodno = '01';
            List<initWrapper> initWrapper = new List<initWrapper>();  
            String sObjName = pageID.getSObjectType().getDescribe().getName();
            system.debug('sObjName'+sObjName);
            if(sObjName == 'Account'){
                Account carikod =[SELECT Id, RC_LogoKey__c FROM Account WHERE Id =: pageID];
                if(carikod != null){
                    if(!String.isBlank(carikod.RC_LogoKey__c)){
                        List<LogoGetCariBakiyeJSONParser> result = LogoGetCariBakiyeIntegrator.getCariBakiye(carikod.RC_LogoKey__c, firmno, periodno);
                        initWrapper = (List<initWrapper>)JSON.deserialize(JSON.serialize(result),List<initWrapper>.class);
                    }
                }
            }
            if(sObjName == 'Opportunity'){
                Opportunity opp =[SELECT Id, AccountId FROM Opportunity WHERE Id =: pageID];
                if(opp != null){
                    Account carikod =[SELECT Id, RC_LogoKey__c FROM Account WHERE Id =: opp.AccountId];
                    if(carikod != null){
                        if(!String.isBlank(carikod.RC_LogoKey__c)){
                            List<LogoGetCariBakiyeJSONParser> result = LogoGetCariBakiyeIntegrator.getCariBakiye(carikod.RC_LogoKey__c, firmno, periodno);
                            initWrapper = (List<initWrapper>)JSON.deserialize(JSON.serialize(result),List<initWrapper>.class);
                        }
                    }
                }
            }
            return initWrapper; 
        }
        catch(Exception ex){
            system.debug('RC_CariBakiyeReport Init exception:'+ex.getMessage());
            return null; 
        }
    }
}