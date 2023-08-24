public class LogoCreateOrderIntegrator {
    
    public class LogoCreateOrderClass {
        public List<LogoBilgileriClass> LogoBilgileri {get;set;} 
        public String FisNo {get;set;} 
        public string Tarih {get;set;} 
        public String OzelKod {get;set;} 
        public String ProjeKodu {get;set;} 
        public String YetkiKod {get;set;} 
        public String DokumanIzlemeNo {get;set;} 
        public String AmbarKodu {get;set;}     
        public String OdemePlaniKodu {get;set;} 
        public String IsyeriKodu {get;set;} 
        public String BolumKodu {get;set;} 
        public String SatisElemaniKodu {get;set;} 
        public String SiparisAciklamasi {get;set;} 
        public String DovizTuru {get;set;} 
        public String DovizKuru {get;set;} 
        public String KDVDahil {get;set;} 
        public String KDV {get;set;} 
        public CariBilgisiClass CariBilgisi {get;set;} 
        public List<SiparisSatirlariClass> SiparisSatirlari {get;set;}
    }
    
    
    public class LogoBilgileriClass {
        public String FirmaNo {get;set;} 
        public String DonemNo {get;set;} 
        public String KullaniciAdi {get;set;} 
        public String Sifre {get;set;} 
    }
    
    public class CariBilgisiClass {
        public String Kodu {get;set;} 
        public String Tanimi {get;set;} 
        public String Adresi {get;set;}
    }
    
    public class SiparisSatirlariClass {
        public String SatirTipi {get;set;} 
        public UrunClass Urun {get;set;} 
        public String Miktar {get;set;} 
        public string BirimFiyat {get;set;} 
        public String SatirAciklama {get;set;} 
        public String ProjeKodu {get;set;} 
        public String MasrafMerkeziKodu {get;set;}
        public String KDVDahil {get;set;} 
        public String KDVOran {get;set;} 
    }
    
    public class UrunClass{
        public String Kodu {get;set;} 
        public String Aciklamasi {get;set;} 
        public String Birim {get;set;} 
    }
    
    public static LogoCreateOrderJsonParser LogoCreateOrderRequest(String requestBody){     
        try{
            LogoCreateOrderJsonParser parseResult;        
            String url = 'Siparis/SiparisKayit';
            system.debug('requestBody:' + requestBody);
            HttpRequest request = new HttpRequest();
            request.setEndpoint('callout:Logo' + '/' + url);
            request.setHeader('Content-Type', 'application/json');
            request.setMethod('POST');
            request.setBody(requestBody);
            request.setTimeout(120000);        
            Http http = new Http();    
            system.debug('CreateOrderLogo: ' + request.getBody());
            HttpResponse response = http.send(request);
            system.debug('CreateOrderResponse:'+response.getBody()); 
            if(!test.isRunningTest()){
                if(response.getStatusCode() == 200){
                    parseResult = LogoCreateOrderJsonParser.parse(response.getBody());
                    RC_Logger.LOG_INFO2('Başarılı. Request = '+request, 'Response Code = '+response.getStatusCode() + ' Response Message = '+response.getBody(), 'LogoCreateOrderIntegrator', 'LogoCreateOrderRequest', 'None');
                }
                else{
                    RC_Logger.LOG_INFO2('Logo hata kodu döndü. Request = '+request, 'Response Code = '+response.getStatusCode() + ' Response Message = '+response.getBody(), 'LogoCreateOrderIntegrator', 'LogoCreateOrderRequest', 'None');
                }
            }
            else{
                parseResult = LogoCreateOrderJsonParser.parse(response.getBody());
            }
            return parseResult;   
        }
        catch(Exception ex)
        {
            RC_Logger.LOG_EXCEPTION2(ex.getMessage(), 'Logo entegrasyonu hata!', ex.getStackTraceString(), 'LogoCreateOrderIntegrator', 'LogoCreateOrderRequest', 'None');
            return null;
        }
    }
    
    public static LogoCreateOrderJsonParser LogoCreateOrder(String AccountLogoKey, String AccountName, String AgreementNumber,string aggreementName, Datetime AgreementDate, String SalesOrganisation, 
                                                            String UserLogoKey, String CurrencyIsoCode, String FairLogoKey, OpportunityLineItem[] opLineItem,Id aggId,decimal stampDuty){
                                                                LogoCreateOrderClass order = new LogoCreateOrderClass();
                                                                order.LogoBilgileri =GetLogoBilgileri();
                                                                order.FisNo=AgreementNumber; 
                                                                order.Tarih=formatDate(AgreementDate.date());
                                                                order.OzelKod='';
                                                                order.ProjeKodu=FairLogoKey;
                                                                order.YetkiKod=SalesOrganisation=='Foreign' ? '50 0040' : '50 0030';
                                                                order.DokumanIzlemeNo=AgreementNumber;
                                                                order.AmbarKodu='00';
                                                                order.OdemePlaniKodu='';
                                                                order.IsyeriKodu='0';
                                                                order.BolumKodu='0';
                                                                order.SatisElemaniKodu=UserLogoKey!=null ? UserLogoKey : '' ;
                                                                order.SiparisAciklamasi=aggreementName;
                                                                order.DovizTuru=CurrencyIsoCode=='TRY' ? 'TL' : CurrencyIsoCode;
                                                                order.DovizKuru=CurrencyIsoCode=='TRY' ? 'TL' : string.valueOf(1/GetDovizKur(CurrencyIsoCode,AgreementDate.date()));
                                                                order.KDVDahil='true';
                                                                order.KDV='18';
                                                                order.CariBilgisi=GetCariBilgisi(AccountLogoKey,AccountName);
                                                                system.debug('stampDuty:'+stampDuty);
                                                                order.SiparisSatirlari=GetSiparisSatirlari(opLineItem,FairLogoKey,aggId,stampDuty);
                                                                String requestBody = JSON.serialize(order);
                                                                return LogoCreateOrderRequest(requestBody);
                                                            }
    
    public static List<LogoBilgileriClass> GetLogoBilgileri(){
        List<LogoBilgileriClass> logoBilgiList = new List<LogoBilgileriClass>();
        LogoBilgileriClass logoBilgi = new LogoBilgileriClass();
        logoBilgi.FirmaNo='002';
        logoBilgi.DonemNo='01';
        logoBilgi.KullaniciAdi='LOGO';
        logoBilgi.Sifre='LOGO';        
        logoBilgiList.add(logoBilgi);
        system.debug('logoBilgiList:' + logoBilgiList);
        return logoBilgiList;
    } 
    
    public static Decimal GetDovizKur(string currName,Date aggrementDateTime){
        
        List<DatedConversionRate> rate = [SELECT Id,ConversionRate FROM DatedConversionRate WHERE IsoCode =: currName AND (StartDate <= :aggrementDateTime and NextStartDate >= :aggrementDateTime)];
        system.debug('rate:' + rate);
        if(rate.size()>0)
        {
            return rate[0].ConversionRate; 
        }
        else{
            return 1; 
        }
    }
    
    public static CariBilgisiClass GetCariBilgisi(String AccountLogoKey, String AccountName){
        CariBilgisiClass cariBilgi = new CariBilgisiClass();
        cariBilgi.Kodu=AccountLogoKey;
        cariBilgi.Tanimi=AccountName;
        cariBilgi.Adresi='';
        system.debug('cariBilgi:' + cariBilgi);
        return cariBilgi;
    }    
    
    public static List<SiparisSatirlariClass> GetSiparisSatirlari(OpportunityLineItem[] opLineItem, String FairLogoKey,Id aggId,decimal stampDuty){
        Opportunity agg=[SELECT ID,RC_Sales_Organisation__c FROM Opportunity WHERE Id=:aggId LIMIT 1];
        List<SiparisSatirlariClass> siparisList = new List<SiparisSatirlariClass>();
        Map<String,SiparisSatirlariClass> productMap = new Map<String,SiparisSatirlariClass>();
        Set<String> productIdSet = new Set<String>();
        Set<SiparisSatirlariClass> siparisSet = new Set<SiparisSatirlariClass>();
        for(OpportunityLineItem opLI : opLineItem){
            SiparisSatirlariClass siparis = new SiparisSatirlariClass();
            siparis.SatirTipi='4'; 
            siparis.Miktar=string.valueOf(opLI.Quantity);
            siparis.BirimFiyat=string.valueOf(opLI.RC_Net_Price__c);
            siparis.SatirAciklama='';
            siparis.ProjeKodu=FairLogoKey!=null ? FairLogoKey : '';
            siparis.MasrafMerkeziKodu='';
            siparis.KDVOran='18';
            siparis.KDVDahil='true';
            productMap.put(opLI.Product2Id,siparis);
            siparisSet.add(siparis);
            productIdSet.add(opLI.Product2Id);
        }
        
        Product2[] products = [SELECT Id,RC_Logo_Key__c,Name FROM Product2 WHERE Id=: productIdSet];  
        if(products.Size() > 0){
            for(Product2 product : products){
                SiparisSatirlariClass siparis = productMap.get(product.Id);
                if(product != null){                
                    UrunClass urun = new UrunClass();
                    urun.Kodu='600.02.01.001';
                    urun.Aciklamasi=product.Name;
                    urun.Birim='M2';
                    siparis.Urun=urun;
                    siparisList.add(siparis);
                }
                else{
                    siparisList.add(siparis);
                }
            }
        }
        else{
            siparisList.addAll(siparisSet);
        }
        
        
        //Damga Vergisi eklenecek.
        system.debug('stampDuty:' + stampDuty);
        if(stampDuty>0){
            SiparisSatirlariClass siparisDamga = new SiparisSatirlariClass();
            siparisDamga.SatirTipi='4'; 
            siparisDamga.Miktar=string.valueOf(1);
            siparisDamga.BirimFiyat=string.valueOf(stampDuty);
            siparisDamga.SatirAciklama='KATILIM BEDELİ-DAMGA VERGİSİ';
            siparisDamga.ProjeKodu=FairLogoKey!=null ? FairLogoKey : '';
            siparisDamga.MasrafMerkeziKodu='';
            siparisDamga.KDVOran='0';
            siparisDamga.KDVDahil='true';
            siparisSet.add(siparisDamga);
            
            UrunClass urun = new UrunClass();
            urun.Kodu='600.601.220.0023';
            urun.Aciklamasi='KATILIM BEDELİ-DAMGA VERGİSİ';
            urun.Birim='ADET';
            siparisDamga.Urun=urun;
            siparisList.add(siparisDamga);
        }
        system.debug('siparisList:' + siparisList);
        return siparisList;
    }
    
    public static String formatDate(Date d) {
        return d.month() + '.' + d.day() + '.' + d.year();
    }
    
}