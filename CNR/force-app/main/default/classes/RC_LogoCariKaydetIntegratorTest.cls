@isTest
public class RC_LogoCariKaydetIntegratorTest {
    @isTest
    public static void unitTest(){
        
        RC_LogoCariKaydetIntegrator.CariKaydetWrapper wrp = new RC_LogoCariKaydetIntegrator.CariKaydetWrapper();
        
        wrp.FirmaNo	 			= ''; 
        wrp.Kodu		 		= '';	   
        wrp.Tanimi	   	 		= '';
        wrp.Ili		   	 		= '';
        wrp.Ilcesi       	 	= '';
        wrp.Telefonu     	 	= '';
        wrp.VergiNo      	 	= '';
        wrp.VergiDairesi 	 	= '';
        wrp.Adresi       	 	= '';
        wrp.MailAdresi   	 	= '';
        
        Test.setMock(HttpCalloutMock.class, new RC_LogoCariKaydetIntegratorMock());
        RC_LogoCariKaydetIntegrator.CariKaydet(wrp);
        
        
    }
}