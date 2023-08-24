@isTest
global class RC_LogoCheckCariByPhoneIntegratorMock implements HttpCalloutMock{
    global HTTPResponse respond(HTTPRequest req){
        HttpResponse res = new HttpResponse();
        
        res.setHeader('Content-Type','application/json');
        res.setBody('[{"cariKodu":297077,"kayitsayisi":"1870"}]');
        res.setStatusCode(200);
        return res;
    }
}