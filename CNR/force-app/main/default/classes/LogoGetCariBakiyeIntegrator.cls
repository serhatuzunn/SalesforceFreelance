public class LogoGetCariBakiyeIntegrator {
    public static List<LogoGetCariBakiyeJSONParser> getCariBakiye(string cariKodu,string firmNr,string periodNR){  
        try{
            List<LogoGetCariBakiyeJSONParser> parseResult = new List<LogoGetCariBakiyeJSONParser>();
            
            String url = 'Cari/GetCariBakiye' + '?_cariKodu=' + cariKodu + '&_firmNR=' + firmNR + '&_periodNR=' + periodNR ;
            
            HttpRequest request = new HttpRequest();
            request.setEndpoint('callout:Logo' + '/' + url);
            request.setMethod('GET');
              request.setHeader('Content-Type','application/json');
            request.setTimeout(120000);        
            Http http = new Http();    
            
            HttpResponse response = http.send(request);
            system.debug(response.getBody());  
            if(response.getStatusCode() == 200){
                parseResult = LogoGetCariBakiyeJSONParser.parse(response.getBody());             
            }
            else RC_Logger.LOG_INFO('Logo hata kodu döndü. Request = '+request, 'Response Code = '+response.getStatusCode() + ' Response Message = '+response.getBody(), 'LogoGetCariBakiyeIntegrator', 'getCariBakiye', 'RC_CariBakiyeReport');
            
            return parseResult;
        }
        catch(Exception ex)
        {
            RC_Logger.LOG_EXCEPTION(ex.getMessage(), 'Logo entegrasyonu hata!', ex.getStackTraceString(), 'LogoGetCariBakiyeIntegrator', 'getCariBakiye', 'RC_CariBakiyeReport');
            return null;
        }
    }
}