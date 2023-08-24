public class LogoGetSozlesmeKalanIntegrator {
    public static List<LogoGetSozlesmeKalanJSONParser> getSozlesmeKalan(string sozlesmeNr,string firmNr,string periodNr){  
        try{
            List<LogoGetSozlesmeKalanJSONParser> parseResult = new List<LogoGetSozlesmeKalanJSONParser>();
            
            String url = 'Cari/GetSozlesmeKalan' + '?_sozlesmeNo=' + sozlesmeNr + '&_firmNR=' + firmNr + '&_periodNR=' + periodNr ;
            
            HttpRequest request = new HttpRequest();
            request.setEndpoint('callout:Logo' + '/' + url);
            request.setMethod('GET');
            request.setHeader('Content-Type','application/json');
            request.setTimeout(120000);        
            Http http = new Http();    
            //if(!test.isRunningTest()){
            HttpResponse response = http.send(request);
            system.debug(response.getBody()); 
            if(response.getStatusCode() == 200){
                parseResult = LogoGetSozlesmeKalanJSONParser.parse(response.getBody());
                system.debug('parseResult:'+parseResult);              
            }
            else RC_Logger.LOG_INFO('Logo hata kodu döndü. Request = '+request, 'Response Code = '+response.getStatusCode() + ' Response Message = '+response.getBody(), 'LogoGetSozlesmeKalanIntegrator', 'getSozlesmeKalan', 'RC_SozlesmeKalanReport');
            //}
            return parseResult;
        }
        catch(Exception ex)
        {
            RC_Logger.LOG_EXCEPTION(ex.getMessage(), 'Logo entegrasyonu hata!', ex.getStackTraceString(), 'LogoGetSozlesmeKalanIntegrator', 'getSozlesmeKalan', 'RC_SozlesmeKalanReport');
            return null;
        }
    }
}