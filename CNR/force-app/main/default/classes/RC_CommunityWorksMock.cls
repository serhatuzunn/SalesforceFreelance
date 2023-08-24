global class RC_CommunityWorksMock implements HttpCalloutMock{
    global HTTPResponse respond(HTTPRequest req) {
        HTTPResponse retVal = null;
        String endpoint = req.getEndpoint();
        if(endpoint.endsWith('RC_CommunityWorks'))
        {
            string bodyString = req.getBody();
            Map<String,Object>  reqMap = (Map<String,Object>)JSON.deserializeUntyped(bodyString);        
            String action =  (String)reqMap.get('ActionName');
            Map<String,Object> parameters =  (Map<String,Object>)reqMap.get('Parameters');
            
            Callable extension = (Callable) Type.forName('RC_Extension').newInstance();
            Object callValue = extension.call(action, parameters);
            
            retVal = new HTTPResponse();
            retVal.setBody(JSON.serialize(callValue));           
        }
        else if(endpoint.contains('ices/oauth2/token')) //token almak için atılan requestte kullanılır.
        {
            retVal = new HTTPResponse();
            Map<String,object> untypedMap =  new Map<String,object>();
            untypedMap.put('token_type','asd');
            untypedMap.put('access_token','qwe'); 
            retval.setBody(json.serialize(untypedMap));
        }
        else if(endpoint.contains('CnrExpo/Customer/Add/1'))
        {
            retVal = new HTTPResponse();
            List<AddCustomerParser> parserList = new List<AddCustomerParser>();
            AddCustomerParser parserItem = new AddCustomerParser();
            parserItem.ActiveFlg = false;
            parserItem.Address1 = 'adsr';
            parserItem.Address2 = 'adr2';
            //parserItem.BirthDate = '';
            parserItem.CityId = 3;
            parserItem.CountryId = 1;
            parserItem.CompanyTypeId = 1;
            parserItem.IsForeign = false;
            parserItem.SurName = 'zck';
            
            parserList.add(parserItem);
            retVal.setBody(Json.serialize(parserList));
        }
        else if(endpoint.contains('/FairCardLicense/Get'))
        {
            retVal = new HTTPResponse();
            List<GetFairCardLicenseParser> parserList = new List<GetFairCardLicenseParser>();
            GetFairCardLicenseParser parserItem = new GetFairCardLicenseParser();
            //parserItem.CityOther = '1';
            parserList.add(parserItem);
            retVal.setBody(Json.serialize(parserList));
        }
        else if(endpoint.contains('/Barcode/Get'))
        {
            retVal = new HTTPResponse();
            List<GetBarcodeParser> parserList = new List<GetBarcodeParser>();
            GetBarcodeParser parser = new GetBarcodeParser();
            parser.Barcode = '123456';
            parserList.add(parser);
            retVal.setBody(Json.serialize(parserList));
        }
        else if(endpoint.contains('/Barcode/Add/1'))
        {
            retVal = new HTTPResponse();
            List<AddBarcodeParser> parserList = new List<AddBarcodeParser>();
            AddBarcodeParser parser = new AddBarcodeParser();
            parser.TableName = '1';
            parser.FairId = 1;
            parser.CustomerId  = 1;
            parser.CustomerTypeId  =1;
            parser.CardId = 1;
            parser.ChannelId = 1;
            parser.SeriId = 1;
            parser.FairDoorId = 1;
            parser.FairHallId = 1;
            parser.SeriNo = '';
            parser.Barcode = '123';
            parser.Receipt = '123';
            parser.PnrCode = '321';
            parser.PromotionCode = '123';
            parser.IsPrinted = false;
            parser.ActiveFlg = false;
            parser.BarcodeId = 123456;
            parser.WebId = 1;
            parser.TermId = 1;
            parserList.add(parser);
            retVal.setBody(Json.serialize(parserList));
        }
        return retVal;
    }
}