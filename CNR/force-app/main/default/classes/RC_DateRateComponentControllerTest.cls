@isTest
public class RC_DateRateComponentControllerTest {

    @isTest
    static void unitTest(){
        DatedConversionRate dcr = [SELECT Id, ConversionRate, IsoCode, StartDate, NextStartDate FROM DatedConversionRate WHERE IsoCode = 'EUR' LIMIT 1];
        DatedConversionRate dcr1 = [SELECT Id, ConversionRate, IsoCode, StartDate, NextStartDate FROM DatedConversionRate WHERE IsoCode = 'USD' LIMIT 1];
        
        Test.startTest();
        RC_DateRateComponentController.RC_GetDateRates();
        Test.stopTest();
    }
}