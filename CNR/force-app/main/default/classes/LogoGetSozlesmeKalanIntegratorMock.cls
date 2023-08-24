@isTest
global class LogoGetSozlesmeKalanIntegratorMock implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req){
        HttpResponse res = new HttpResponse();        
        res.setHeader('Content-Type','application/json');
        res.setBody('[{"sozlesmeNo":null,"kalanTutar":0,"kayitsayisi":0}]');
        res.setStatusCode(200);
        return res;
    }
}