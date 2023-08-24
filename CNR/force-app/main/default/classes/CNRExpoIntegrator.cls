public class CNRExpoIntegrator {
    public static List<AddCustomerParser> AddCustomerRequest(String requestBody){     
        try{
            List<AddCustomerParser> parseResult;
            HttpRequest request = new HttpRequest();
            request.setEndpoint('callout:CnrExpo' + '/Customer/Add/1');
            request.setHeader('Content-Type', 'application/json');
            request.setMethod('POST');
            request.setBody(requestBody);
            request.setTimeout(120000);  
            system.debug('request:'+request+'requestBody:'+requestBody); 
            Http http = new Http();                
            HttpResponse response = http.send(request);
            system.debug('responseBody:'+response.getBody()); 
            parseResult = AddCustomerParser.parse(response.getBody());
            /*if(!test.isRunningTest()){
if(response.getStatusCode() == 200){
parseResult = AddCustomerParser.parse(response.getBody());
//RC_Logger.LOG_INFO('Başarılı. Request = '+request, 'Response Code = '+response.getStatusCode() + ' Response Message = '+response.getBody(), 'CNRExpoIntegrator', 'CNRExpoAddCustomerRequest', 'RC_Portal_Badge');
}
else{
//RC_Logger.LOG_INFO('Servis hata kodu döndü. Request = '+request, 'Response Code = '+response.getStatusCode() + ' Response Message = '+response.getBody(), 'CNRExpoIntegrator', 'CNRExpoAddCustomerRequest', 'RC_Portal_Badge');
}
}
else{
parseResult = AddCustomerParser.parse(response.getBody());
}*/
            return parseResult;   
        }
        catch(Exception ex)
        {
            //RC_Logger.LOG_EXCEPTION(ex.getMessage(), 'Entegrasyon hata aldı!', ex.getStackTraceString(), 'CNRExpoIntegrator', 'CNRExpoAddCustomerRequest', 'RC_Portal_Badge');
            return null;
        }
    }
    
    public static List<GetFairCardLicenseParser> GetFairCardLicenseRequest(String url){     
        try{
            List<GetFairCardLicenseParser> parseResult;
            HttpRequest request = new HttpRequest();
            request.setEndpoint('callout:CnrExpo' + '/FairCardLicense/Get' + url);
            request.setHeader('Content-Type', 'application/json');
            request.setMethod('GET');
            request.setTimeout(120000);  
            system.debug('request:'+request); 
            Http http = new Http();                
            HttpResponse response = http.send(request);
            system.debug('responseBody:'+response.getBody()); 
            parseResult = GetFairCardLicenseParser.parse(response.getBody());
            /* if(!test.isRunningTest()){
if(response.getStatusCode() == 200){
parseResult = GetFairCardLicenseParser.parse(response.getBody());
//RC_Logger.LOG_INFO('Başarılı. Request = '+request, 'Response Code = '+response.getStatusCode() + ' Response Message = '+response.getBody(), 'CNRExpoIntegrator', 'GetFairCardLicenseRequest', 'RC_Portal_Badge');
}
else{
//RC_Logger.LOG_INFO('Servis hata kodu döndü. Request = '+request, 'Response Code = '+response.getStatusCode() + ' Response Message = '+response.getBody(), 'CNRExpoIntegrator', 'GetFairCardLicenseRequest', 'RC_Portal_Badge');
}
}
else{
parseResult = GetFairCardLicenseParser.parse(response.getBody());
}*/
            return parseResult;   
        }
        catch(Exception ex)
        {
            //RC_Logger.LOG_EXCEPTION(ex.getMessage(), 'Entegrasyon hata aldı!', ex.getStackTraceString(), 'CNRExpoIntegrator', 'GetFairCardLicenseRequest', 'RC_Portal_Badge');
            return null;
        }
    }
    
    public static List<GetBarcodeParser> GetBarcodeRequest(String url){     
        try{
            List<GetBarcodeParser> parseResult;
            HttpRequest request = new HttpRequest();
            request.setEndpoint('callout:CnrExpo' + '/Barcode/Get' + url);
            request.setHeader('Content-Type', 'application/json');
            request.setMethod('GET');
            request.setTimeout(120000);  
            system.debug('request:'+request); 
            Http http = new Http();                
            HttpResponse response = http.send(request);
            system.debug('responseBody:'+response.getBody()); 
            //parseResult = GetBarcodeParser.parse(response.getBody());
            parseResult = (List<GetBarcodeParser>)JSON.deserialize(response.getBody(),List<GetBarcodeParser>.class);
            /*
            if(!test.isRunningTest()){
                if(response.getStatusCode() == 200){
                    parseResult = GetBarcodeParser.parse(response.getBody());
                    //RC_Logger.LOG_INFO('Başarılı. Request = '+request, 'Response Code = '+response.getStatusCode() + ' Response Message = '+response.getBody(), 'CNRExpoIntegrator', 'GetBarcodeRequest', 'RC_Portal_Badge');
                }
                else{
                    //RC_Logger.LOG_INFO('Servis hata kodu döndü. Request = '+request, 'Response Code = '+response.getStatusCode() + ' Response Message = '+response.getBody(), 'CNRExpoIntegrator', 'GetBarcodeRequest', 'RC_Portal_Badge');
                }
            }
            else{
                parseResult = GetBarcodeParser.parse(response.getBody());
            }
*/
            return parseResult;   
        }
        catch(Exception ex)
        {
            //RC_Logger.LOG_EXCEPTION(ex.getMessage(), 'Entegrasyon hata aldı!', ex.getStackTraceString(), 'CNRExpoIntegrator', 'GetBarcodeRequest', 'RC_Portal_Badge');
            return null;
        }
    }
    
    public static List<AddBarcodeParser> AddBarcodeRequest(String requestBody){     
        try{
            List<AddBarcodeParser> parseResult;
            HttpRequest request = new HttpRequest();
            request.setEndpoint('callout:CnrExpo' + '/Barcode/Add/1');
            request.setHeader('Content-Type', 'application/json');
            request.setMethod('POST');
            request.setBody(requestBody);
            request.setTimeout(120000);  
            system.debug('request:'+request); 
            Http http = new Http();                
            HttpResponse response = http.send(request);
            system.debug('responseBody:'+response.getBody()); 
            parseResult = (List<AddBarcodeParser>)JSON.deserialize(response.getBody(), List<AddBarcodeParser>.class);
            /*
            if(!test.isRunningTest()){
                if(response.getStatusCode() == 200){
                    system.debug('parseResult:'+parseResult + 'response.getBody:'+response.getBody());
                    //parseResult = AddBarcodeParser.parse(response.getBody());
                    parseResult = (List<AddBarcodeParser>)JSON.deserialize(response.getBody(), List<AddBarcodeParser>.class);
                    system.debug('parseResultasd:'+parseResult);
                    //RC_Logger.LOG_INFO('Başarılı. Request = '+request, 'Response Code = '+response.getStatusCode() + ' Response Message = '+response.getBody(), 'CNRExpoIntegrator', 'AddBarcodeRequest', 'RC_Portal_Badge');
                }
                else{
                    //RC_Logger.LOG_INFO('Servis hata kodu döndü. Request = '+request, 'Response Code = '+response.getStatusCode() + ' Response Message = '+response.getBody(), 'CNRExpoIntegrator', 'AddBarcodeRequest', 'RC_Portal_Badge');
                }
            }
            else{
                parseResult = AddBarcodeParser.parse(response.getBody());
            }*/
            system.debug('parseResult:'+parseResult);
            return parseResult;               
        }
        catch(Exception ex)
        {
            system.debug(ex.getMessage());
            system.debug(ex.getStackTraceString());
            //RC_Logger.LOG_EXCEPTION(ex.getMessage(), 'Entegrasyon hata aldı!', ex.getStackTraceString(), 'CNRExpoIntegrator', 'AddBarcodeRequest', 'RC_Portal_Badge');
            return null;
        }
    }
}