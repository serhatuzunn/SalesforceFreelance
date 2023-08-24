@isTest
public class RC_LogoCheckCariByPhoneIntegratorTest{
    @isTest
    public static void unitTest(){
        
        RC_LogoCheckCariByPhoneIntegrator.ReturnWrapper wrp = new RC_LogoCheckCariByPhoneIntegrator.ReturnWrapper();
        wrp.kayitSayisi = '';
        wrp.cariKodu = '';
        
        Test.setMock(HttpCalloutMock.class, new RC_LogoCheckCariByPhoneIntegratorMock());
        RC_LogoCheckCariByPhoneIntegrator.CariKontrolByPhone('3131313131','313131','69696969');
    }
    
}