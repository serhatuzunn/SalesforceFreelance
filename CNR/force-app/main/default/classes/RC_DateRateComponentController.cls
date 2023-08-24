public class RC_DateRateComponentController {
    
    @AuraEnabled
    public static List<initWrapper> RC_GetDateRates(){
        List<initWrapper> initList = new List<initWrapper>();
        List<DatedConversionRate> dcrList = new List<DatedConversionRate>();
        
        system.debug('Date 1: ' + system.today());
        system.debug('Date 2: ' + Date.valueOf(system.today()));
        system.debug('Date 3: ' + String.valueOf(system.today()).substring(0, 10));
        
        Date dateValue = Date.valueOf(String.valueOf(system.today()).substring(0, 10));
        system.debug('Date 4: ' + dateValue);
        
        List<DatedConversionRate> dcr = [SELECT Id, IsoCode, StartDate, NextStartDate, ConversionRate FROM DatedConversionRate 
                                             WHERE StartDate=:dateValue ORDER BY StartDate DESC LIMIT 2];
        if(dcr.size() > 0){
            system.debug('FIRST IF');
            dcrList = dcr;
        }
        else{
            system.debug('SECOND IF');
            List<DatedConversionRate> dcrLst = [SELECT Id, IsoCode, StartDate, NextStartDate, ConversionRate FROM DatedConversionRate ORDER BY StartDate DESC LIMIT 2];
            dcrList = dcrLst;
        }
        
        if(dcrList.size() > 0){
            for(DatedConversionRate item:dcrList){
                initWrapper initItem = new initWrapper();
                initItem.conversionRateDate = String.valueOf(item.StartDate.day()) + '.' + String.valueOf(item.StartDate.month()) + '.' + String.valueOf(item.StartDate.year());
                if(item.IsoCode == 'EUR'){
                    Decimal euroRate = 1 / item.ConversionRate;
                    initItem.conversionEuroRate = euroRate.setScale(2);
                    initItem.conversionIsoCode = 'EUR';
                }
                if(item.IsoCode == 'USD'){
                    Decimal dolarRate = 1 / item.ConversionRate;
                    initItem.conversionDolarRate = dolarRate.setScale(2);
                    initItem.conversionIsoCode = 'USD';
                }
                initList.add(initItem);
            }
        }
        
        return initList;
    }
    
    public class initWrapper{
        @AuraEnabled
        public String conversionRateDate {get;set;}
        @AuraEnabled
        public Decimal conversionEuroRate {get;set;}
        @AuraEnabled
        public Decimal conversionDolarRate {get;set;}
        @AuraEnabled
        public String conversionIsoCode {get;set;}
    }
}