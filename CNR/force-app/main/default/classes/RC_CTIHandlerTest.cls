@isTest
public class RC_CTIHandlerTest {
    @isTest    
    public static void RunTest()
    {
        Test.setMock(HttpCalloutMock.class, new RC_CTIHandlerMock());
        Test.startTest();
        String agentId = RC_CTIHandler.getAgentId();
        List<Account> actList = [SELECT Id,Phone, (SELECT Id FROM Contacts) FROM Account];
        for(Account act : actList)
        {
            if(act.Contacts.size() > 0)
            {
                RC_CTIHandler.getphoneNumber(act.Id);
                RC_CTIHandler.getphoneNumber(act.Contacts.get(0).Id);
                RC_CTIHandler.MakePhoneCall(agentId,act.Phone);
            }
        }
        Test.stopTest();
    }
    @testSetup public static void SetupMethod()
    {
        system.debug('SetupMethod started');
        RC_TestClassUtils.createTestDatas();
    }
}