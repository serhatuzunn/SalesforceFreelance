global class LogoCreateOrderMock implements HttpCalloutMock{
    
    global HTTPResponse respond(HTTPRequest req){
        HttpResponse res = new HttpResponse(); 
        
        res.setHeader('Content-Type','application/json'); 
        res.setHeader('Accept', 'application/json');
        res.setBody('{"status":"1","error":{"aciklama":""},"fisNo":"12978cbc-42a7-484e-9fc5-e745c702d3ff"}');
        
        return res;
    }
}