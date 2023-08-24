@isTest
global class LogoGetCariBakiyeIntegratorMock implements HttpCalloutMock{
    global HTTPResponse respond(HTTPRequest req){
        HttpResponse res = new HttpResponse();
        
        res.setHeader('Content-Type','application/json');
        res.setBody('[{"cariref":297077,"kodu":"1870","unvani":"KANDİLLİ MOBİLYA DEK. İNŞ. SAN. VE TİC. LTD. ŞTİ.","sehir":"","odemeplani":"","masrafmerkezi":"","projekodu":"","bakiye":0,"risklimit":0,"cekdurumu":""}]');
        res.setStatusCode(200);
        return res;
    }
}