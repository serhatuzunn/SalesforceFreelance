public class RC_ExtensionHelper {
    @auraEnabled
    public static string checkResponse()
    {
        Callable extension = (Callable) Type.forName('RC_Extension').newInstance();
        return  (String)extension.call('GetCorporateCurrency', null);        
    }
    
    public static string getToken()
    {
        String ClientId = '';
        String ClientSecret = '';
        String ClientUser = '';
        String ClientPass = '';
        List<RC_CommunitySettings__c> settings = RC_CommunitySettings__c.getAll().values();
        if(settings!= null && settings.size() > 0)
        {
            for(RC_CommunitySettings__c sett : settings)
            {
                if(sett.Name == 'CommunityService')
                {
                    ClientId = sett.Id__c;
                    ClientSecret = sett.Secret__c;
                    ClientUser = sett.Username__c;
                    //TODO ZCK: ip range aralığında bulununca security token null geldiğinden hatalı şifre ile login olmaya çalışıyor. nullcheck yapılmalı.
                    //Coveraga bozulabilir, kontrollü bir şekilde düzenleme yapılmalı. 
                    ClientPass = sett.Password__c + sett.Security_Token__c;
                }
            }
        }       
        
        string parameters = '';
        parameters += 'grant_type=password&';
        parameters += 'client_id=' +ClientId+ '&';
        parameters += 'client_secret='+ClientSecret+ '&';
        parameters += 'username='+ClientUser+ '&';
        parameters += 'password='+ClientPass;        
        
        string endpoint = URL.getOrgDomainUrl().toExternalForm() + '/services/oauth2/token?'+parameters;
        system.debug('endpoint:'+endpoint);
        
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');        
        req.setEndpoint(endpoint);        
        Http httpReq = new Http();
        HttpResponse resp = httpReq.send(req);
        
        String response = resp.getBody();
        system.debug('response:'+response);
        Map<String,object> untypedResult =  (Map<String,object>)JSON.deserializeUntyped(response);
        String token = untypedResult.get('token_type') + ' ' + untypedResult.get('access_token');
        system.debug('token:'+token);
        return token;
    }
    
    public static string CallRequest(String action, Map<String,Object> args)
    {
        RC_CommunityRequest comRequest = new RC_CommunityRequest();
        comRequest.ActionName =action;
        comRequest.Parameters = args;
        
        String token = getToken();
        HttpRequest req = new HttpRequest();
        req.setTimeout(120000);
        req.setMethod('POST');        
        req.setBody(JSON.serialize(comRequest));
        String endpoint = URL.getOrgDomainUrl().toExternalForm() + '/services/apexrest/RC_CommunityWorks';
        req.setEndpoint(endpoint);
        req.setHeader('authorization',token);
        req.setHeader('Content-Type','application/json');
        Http httpReq = new Http();
        HttpResponse resp = httpReq.send(req);
        
        String response = resp.getBody();   
        
        return  response;
    }
}