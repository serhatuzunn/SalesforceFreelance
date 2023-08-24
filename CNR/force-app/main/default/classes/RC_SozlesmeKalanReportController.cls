public without sharing class RC_SozlesmeKalanReportController {
    public class initWrapper{
        @AuraEnabled
        public string sozlesmeNo {get;set;}
        @AuraEnabled
        public string kalanTutar {get;set;}
         @AuraEnabled
        public string kayitsayisi {get;set;}
    }
    
    @AuraEnabled
    public static List<initWrapper> Init(String aggrementId){
        try{
            system.debug('aggrementId:' + aggrementId);
            String firmno = '301';
            String periodno = '01';
            List<initWrapper> initWrapper = new List<initWrapper>();            
            List<Opportunity> opp =[SELECT id, RC_Agreement_Number__c,StageName FROM Opportunity WHERE Id =: aggrementId and StageName = 'Advance Payment'];
            system.debug('opportunity:'+opp);
            if(opp.size()>0){
                if(!String.isBlank(opp.get(0).RC_Agreement_Number__c) || Test.isRunningTest()){
                    List<LogoGetSozlesmeKalanJSONParser> result = LogoGetSozlesmeKalanIntegrator.getSozlesmeKalan(opp.get(0).RC_Agreement_Number__c, firmno, periodno);
                    system.debug('result:'+JSON.serialize(result));
                    initWrapper = (List<initWrapper>)JSON.deserialize(JSON.serialize(result),List<initWrapper>.class);
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