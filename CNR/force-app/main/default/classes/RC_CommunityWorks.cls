//Do not change this function
@RestResource(urlMapping='/RC_CommunityWorks')
global without sharing class RC_CommunityWorks {
    @HttpPost
    global static String CallRequest()
    {
        system.debug('requestStarted');
        String bodyString = RestContext.request.requestBody.toString();
        system.debug(bodyString);
        Map<String,Object>  req = (Map<String,Object>)JSON.deserializeUntyped(bodyString);        
        String action =  (String)req.get('ActionName');
        Map<String,Object> parameters =  (Map<String,Object>)req.get('Parameters');
        Callable extension = (Callable) Type.forName('RC_Extension').newInstance();
        Object callValue = extension.call(action, parameters);
        
        return JSON.serialize(callValue);
    }
}