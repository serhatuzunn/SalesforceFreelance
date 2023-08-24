@isTest
public class RC_ContactTriggerTest {
    public static testmethod void runPriceBookTriggerTest()
    {
        Test.startTest();
        //RC_TestClassUtils.createTestDatas();
        Account acct = new Account();
        acct.Name  ='Test Account';
        Database.SaveResult sracct = Database.insert(acct);
        
        Contact cont = new Contact();
        cont.LastName='test lastname';
        cont.AccountId=acct.Id;        
        Database.SaveResult srcont = Database.insert(cont);
        
        test.stopTest();
    }
}