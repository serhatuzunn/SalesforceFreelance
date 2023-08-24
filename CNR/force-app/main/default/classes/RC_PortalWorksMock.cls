global class RC_PortalWorksMock implements WebServiceMock{
    global void doInvoke(
        Object stub,
        Object request,
        Map<String, Object> response,
        String endpoint,
        String soapAction,
        String requestName,
        String responseNS,
        String responseName,
        String responseType) {
            system.debug(soapAction);
            system.debug(json.serialize(request));
            if(soapAction.contains('Get_fuar_userByID'))
            {
                CnrServicesWSDL.Get_fuar_userByIDResponse_element response_x = new CnrServicesWSDL.Get_fuar_userByIDResponse_element();                
                
                CnrServicesWSDL.fuar_user fuarUser = new CnrServicesWSDL.fuar_user();
                fuarUser.KULLANICI = 'KULLANICI';
                fuarUser.web_id = '123'; 
                response_x.Get_fuar_userByIDResult = fuarUser; 
                response.put('response_x', response_x); 
            } 
            else if(soapAction.contains('GenerateCode'))
            {
                CnrServicesWSDL.GenerateCodeResponse_element response_x2 = new CnrServicesWSDL.GenerateCodeResponse_element();
                response_x2.GenerateCodeResult  ='ANILZCK';
                response.put('response_x', response_x2); 
            }
            else if(soapAction.contains('Insertbilet_pro'))
            {
                CnrServicesWSDL.Insertbilet_proResponse_element response_x3 = new CnrServicesWSDL.Insertbilet_proResponse_element();
                response_x3.Insertbilet_proResult = 23;
                response.put('response_x', response_x3); 
            }
            else if(soapAction.contains('Getbilet_proByID'))
            {
                CnrServicesWSDL.Getbilet_proByIDResponse_element response_x4 = new  CnrServicesWSDL.Getbilet_proByIDResponse_element();
                CnrServicesWSDL.bilet_pro biletPro = new CnrServicesWSDL.bilet_pro();
                biletPro.DURUM = 1;
                biletPro.ID = 11;
                biletPro.KOD = '11';
                biletPro.web_id = '1';
                biletPro.mail = 'zck@zck.com';
                response_x4.Getbilet_proByIDResult = biletPro;
                response.put('response_x', response_x4); 
            }
            
            
        }
}