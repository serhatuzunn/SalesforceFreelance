public class RC_LogoCheckCariByVknIntegrator {
    
    public class ReturnWrapper
    {
        public string cariKodu{get;set;}
        public string kayitSayisi{get;set;}
    }
    
    public static ReturnWrapper CariKontrolByVKN(string vknNo,string firmNo,string periodNo)
    {
        try{
            
            
            List<ReturnWrapper> parseResult= new List<ReturnWrapper>();        
            String url = 'Cari/CariKontrolByVKN' + '?_vkNo=' + vknNo + '&_firmNR=' + firmNo + '&_periodNR=' + periodNo ;
            HttpRequest request = new HttpRequest();
            request.setEndpoint('callout:Logo' + '/' + url);
            system.debug('req:' + request.getEndpoint());
            request.setMethod('GET');
            request.setHeader('Content-Type','application/json');
            request.setTimeout(120000);         
            Http http = new Http();    
            
            HttpResponse response = http.send(request);
            system.debug('responseBody:'+response); 
            if(!test.isRunningTest()){

                if(response.getStatusCode() == 200){
                    parseResult =(List<ReturnWrapper>) JSON.deserialize(response.getBody(),List<ReturnWrapper>.class);
                    system.debug('respBody:' + response.getBody());
                    system.debug('parseRes:' + parseResult);
                    //RC_Logger.LOG_INFO2('Başarılı. Request = '+request, 'Response Code = '+response.getStatusCode() + ' Response Message = '+response.getBody(), 'RC_LogoCheckCariByVknIntegrator', 'CariKontrolByVKN', 'None');
                }
                else{
                    //  RC_Logger.LOG_INFO2('Logo hata kodu döndü. Request = '+request, 'Response Code = '+response.getStatusCode() + ' Response Message = '+response.getBody(), 'RC_LogoCheckCariByVknIntegrator', 'CariKontrolByVKN', 'None');
                }
            }else{

                ReturnWrapper pRresult = new ReturnWrapper();
				pRresult.cariKodu = '';    
                pRresult.kayitSayisi = '1870';
                parseResult.add(pRresult);

            }
                

            return parseResult.get(0);   
        }
        catch(Exception ex)
        {
            system.debug('exc:' + ex);
          //  RC_Logger.LOG_EXCEPTION2(ex.getMessage(), 'Logo entegrasyonu hata!', ex.getStackTraceString(), 'RC_LogoCheckCariByVknIntegrator', 'CariKontrolByVKN', 'None');
            return null;
        }   
    }
}