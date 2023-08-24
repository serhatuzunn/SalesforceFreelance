@isTest
public class LogoCreateOrderTest {
    
    @testSetup static void prepareData(){
        RC_TestClassUtils.createTestDatas();
    }
    
    static testMethod void unitTest(){
        Test.startTest();
        
        Test.setMock(HttpCalloutMock.class, new LogoCreateOrderMock());
        Id oppId = [SELECT Id FROM Opportunity WHERE Name = 'ZCK Test Opt'].Id;
        //Id oppId2 = [SELECT Id FROM Opportunity WHERE Name = 'SU555'].Id;
        
        LogoCreateOrder.Create(new List<Id>{oppId});
       // LogoCreateOrder.Create(new List<Id>{oppId2});
        
        Test.stopTest();
    }
}