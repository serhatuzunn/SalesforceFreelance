@isTest
public class RC_PriceBookTriggerTest {    
    public static testmethod void runPriceBookTriggerTest()
    {
        Test.startTest();
        RC_TestClassUtils.createTestDatas();
        //[SELECT Id FROM RC_Fair__c WHERE ]
        Pricebook2 pb = new Pricebook2();
        pb.RC_Start_Date__c = System.now();
        pb.RC_End_Date__c = System.now();
        pb.Name  ='Test PB';
        pb.Average_Maturity_Date__c = Date.today();
        pb.IsActive = true;
        Database.SaveResult srPb = Database.insert(pb);
        test.stopTest();
    }
}