public class RC_LogoCariKaydetIntegrator {
    
    public class CariKaydetWrapper
    {
        public string FirmaNo	   {get;set;}
        public string Kodu		   {get;set;}
        public string Tanimi	   {get;set;}
        public string Ili		   {get;set;}
        public string Ilcesi       {get;set;}
        public string Telefonu     {get;set;}
        public string VergiNo      {get;set;}
        public string VergiDairesi {get;set;}
        public string Adresi       {get;set;}
        public string MailAdresi   {get;set;}
    }
    
    public static boolean CariKaydet(CariKaydetWrapper cariKaydetRequest)
    {
        try{
            string requestBody=JSON.serialize(cariKaydetRequest);
            
            string parseResult;        
            String url = 'Cari/CariKaydet';
            system.debug('requestBody:' + requestBody);
            HttpRequest request = new HttpRequest();
            request.setEndpoint('callout:Logo' + '/' + url);
            request.setHeader('Content-Type', 'application/json');
            request.setMethod('POST');
            request.setBody(requestBody);
            request.setTimeout(120000);        
            Http http = new Http();    
            
            HttpResponse response = http.send(request);
            system.debug('responseBodyCreate:'+response.getBody()); 
          
                if(response.getStatusCode() == 200){
                    parseResult = response.getBody();
                   // RC_Logger.LOG_INFO2('Başarılı. Request = '+request, 'Response Code = '+response.getStatusCode() + ' Response Message = '+response.getBody(), 'RC_LogoCariKaydetIntegrator', 'LogoCariKaydetRequest', 'None');
                }
                else{
                   // RC_Logger.LOG_INFO2('Logo hata kodu döndü. Request = '+request, 'Response Code = '+response.getStatusCode() + ' Response Message = '+response.getBody(), 'RC_LogoCariKaydetIntegrator', 'LogoCariKaydetRequest', 'None');
                }
			system.debug('pp:' + '-' + parseResult + '-');
            return parseResult=='"OK"' ? true : false;   
        }
        catch(Exception ex)
        {
            system.debug('createCari:' + ex);
          //  RC_Logger.LOG_EXCEPTION2(ex.getMessage(), 'Logo entegrasyonu hata!', ex.getStackTraceString(), 'RC_LogoCariKaydetIntegrator', 'LogoCariKaydetRequest', 'None');
            return false;
        }   
    }
}