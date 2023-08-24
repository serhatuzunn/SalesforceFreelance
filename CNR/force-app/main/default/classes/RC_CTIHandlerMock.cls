public class RC_CTIHandlerMock implements HttpCalloutMock{
    public HttpResponse respond(HttpRequest req)
    {
        HttpResponse resp = new HttpResponse();
        resp.setStatus('SUCCESS');
        
        return resp;
    }
}