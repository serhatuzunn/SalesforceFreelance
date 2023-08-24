//RC_CTIHandlerTest
//RC_CTIHandlerMock
public without sharing class RC_CTIHandler {
    public static String Param_CTIStatusEndpointSetting = 'CTI_GetParams';
    public static String Param_CTIStatusMakeCallSetting = 'CTI_StartCall';
    @AuraEnabled
    public static String getAgentId(){
        String retVal = '';
        String UserId =  UserInfo.getUserId();
        retVal = [SELECT RC_Agent_Id__c FROM User WHERE Id =: userId LIMIT 1].RC_Agent_Id__c;
        return retVal;
    }
    @AuraEnabled
    public static List<Map<string,string>> getphoneNumber(String recordId){
        List<Map<string,string>> retVal = new List<Map<string,string>>();
        if(recordId != null)
        {
            String objectName = ObjectName(recordId);
            system.debug(objectName);
            if(objectName == 'Account')
            {
                Map<string,string> mapItem = new Map<string,string>();
                Account act = [SELECT Name,Phone,(Select MobilePhone,Phone,Name FROM Contacts) FROM Account Where Id =: recordId LIMIT 1];
                retVal.addAll(getPhonesFromAccount(act));
                
                if(act.Contacts.size() > 0)
                {
                    for(Contact cnt : act.Contacts)
                    {
                        retVal.AddAll(getPhonesFromContact(cnt));
                    }
                }                
            }
            else if(objectName == 'Contact')
            {                
                Contact cnt = [SELECT Name,Phone,MobilePhone,AccountId,Account.Phone, Account.Name FROM Contact Where Id =: recordId LIMIT 1];
                retVal.addall(getPhonesFromContact(cnt));               
                
                if(cnt.AccountId != null && String.isNotBlank(cnt.Account.Phone))
                {
                    retVal.addall(getPhonesFromAccount(cnt.Account));
                }
            }
            else if(objectName == 'Opportunity')
            {
                Opportunity opt = [SELECT Id,AccountId,Account.Name,Account.Phone,(SELECT ContactId,Contact.Phone,Contact.MobilePhone,Contact.Name FROM OpportunityContactRoles) FROM Opportunity WHERE Id =: recordId LIMIT 1];
                if(opt.AccountId != null)
                {
                    retVal.addAll(getPhonesFromAccount(opt.Account));
                }
                if(opt.OpportunityContactRoles.size() > 0)
                {
                    for(OpportunityContactRole cnt : opt.OpportunityContactRoles)
                    {
                        retVal.AddAll(getPhonesFromContact(cnt.Contact));
                    }
                }
            }
        }
        system.debug(retVal);
        return retVal;
    }
    @AuraEnabled
    public static string getAgentStatus(String AgentId){
        string retVal= 'Available';
        String endpoint = getSettingsValue(Param_CTIStatusEndpointSetting) + AgentId;
        String methodType = 'GET';
        
        Map<String,Object> getHttpResult = SendHttpRequest(endpoint, methodType,'');
        if(getHttpResult != null)
        {
            
        }
        return retVal;
    }
    @AuraEnabled
    public static String MakePhoneCall(String AgentId,String PhoneNumber){
        system.debug('AgentId ' + AgentId);
        system.debug('PhoneNumber ' + PhoneNumber);
        String retVal = '';
        String agentStatus = getAgentStatus(AgentId);
        String endpoint = getSettingsValue(Param_CTIStatusMakeCallSetting) + PhoneNumber +'/'+ AgentId;
        String methodType = 'GET';
        
        Map<String,Object> getHttpResult = SendHttpRequest(endpoint, methodType,'');
        if(getHttpResult != null)
        {
            
        }
        return retVal;
    }
    private static String ObjectName(String recordId){
        String retVal = '';
        if(recordId == null)
            retVal = null;
        String objectAPIName = '';
        String keyPrefix = recordId.substring(0,3);
        for( Schema.SObjectType obj : Schema.getGlobalDescribe().Values() ){
            String prefix = obj.getDescribe().getKeyPrefix();
            if(prefix == keyPrefix){
                objectAPIName = obj.getDescribe().getName();
                retVal = objectAPIName;
                break;
            }
        }
        return retVal;        
    }
    private static Map<String,String> getMapItem(String label, String value){
        Map<string,string> mapItem = new Map<string,string>();
        mapItem.put('label', label);
        mapItem.put('value', value);
        return mapItem;
    }
    private static List<Map<String,String>> getPhonesFromContact(Contact cnt){
        List<Map<String,String>> retVal = new List<Map<String,String>>();
        if(String.isNotBlank(cnt.Phone))
        {
            retVal.add(getMapItem(cnt.Name + ' (P-' + cnt.Phone +')', cnt.Phone));
        }
        if(String.isNotBlank(cnt.MobilePhone))
        {
            retVal.add(getMapItem(cnt.Name + ' (M-'  +  cnt.MobilePhone+')',cnt.MobilePhone));
        }
        return retVal;
    }
    private static List<Map<String,String>> getPhonesFromAccount(Account act){
        List<Map<String,String>> retVal = new List<Map<String,String>>();
        if(String.isNotBlank(act.Phone))
        {
            retVal.add(getMapItem(act.Name + ' (P-' + act.Phone+')',  act.Phone));
        }
        return retVal;
    }    
    private static Map<String,Object> SendHttpRequest(string endpoint,string methodType,string jsonBody){
        Map<String,Object> retVal = null;
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod(methodType);
        req.setTimeout(120000);
        if(String.isNotBlank(jsonBody))
        {
            req.setBody(jsonBody);
        }
        Http http = new Http();
        HTTPResponse res = http.send(req);
        if(res.getStatus() == 'OK')
        {
            retVal = (Map<String,Object>)JSON.deserializeUntyped(res.getBody());
        }
        System.debug(res.getStatus());
        System.debug(res.getBody());
        return retVal;
    }
    private static String getSettingsValue(String settingsParam){
        String retVal = '';
        RC_CTISettings__c mc = RC_CTISettings__c.getValues(settingsParam);
        if(mc != null)
        {
            retVal = mc.EndpointURL__c;
        }
        return retVal;
    }
}