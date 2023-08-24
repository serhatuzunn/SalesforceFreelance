@isTest
public class RC_LogoCheckCariByVknIntegratorTest {
    @isTest
    public static void unitTest(){
        RC_LogoCheckCariByVknIntegrator.ReturnWrapper wrp = new RC_LogoCheckCariByVknIntegrator.ReturnWrapper();
        wrp.kayitSayisi = '';
        wrp.cariKodu = '';
        
        Test.setMock(HttpCalloutMock.class, new RC_LogoCheckCariByVknIntegratorMock());
        RC_LogoCheckCariByVknIntegrator.CariKontrolByVKN('3131313131','313131','69696969');
    }
    
}