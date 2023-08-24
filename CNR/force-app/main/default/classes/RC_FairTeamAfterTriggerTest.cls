@IsTest
public class RC_FairTeamAfterTriggerTest {
    @testSetup 
    public static void setupData()
    {
        RC_TestClassUtils.createTestDatas();
    }
    
    public static testmethod void test() {
        Test.startTest();
        RC_Fair__c fairItem = [SELECT Id FROM RC_Fair__c LIMIT 1];
        
        RC_Fair_Team__c ft = new RC_Fair_Team__c();
        ft.RC_Fair__c = fairItem.Id;//fair.Id;
        ft.RC_Sales_Organisation__c = 'Domestic';
        ft.RC_User_Name__c = System.UserInfo.getUserId(); //usr.Id;
        ft.General_Manager__c = 'General Manager';
        insert ft;
        
        RC_Fair_Team__c ft2 = new RC_Fair_Team__c();
        ft2.RC_Fair__c = fairItem.Id;//fair.Id;
        ft2.RC_Sales_Organisation__c = 'Domestic';
        ft2.RC_User_Name__c = System.UserInfo.getUserId();//usr2.Id;
        ft2.General_Manager__c = 'Sales';
        insert ft2;
        
        delete ft2;
        
        Test.stopTest();
        /*

string profileName = 'System Administrator';
Profile p = [SELECT Id FROM Profile WHERE Name=:profileName limit 1];
User usr = new User();
usr.FirstName = 'Test';
usr.LastName = 'Test';
usr.User_Code__c = 'test';
usr.Email = 'usrxxx1234@test.com';
usr.Username = 'usrxxx1234@test.com';
usr.CompanyName = 'TEST';
usr.Title = 'title';
usr.Alias = 'alias';
usr.TimeZoneSidKey = 'America/Los_Angeles';
usr.EmailEncodingKey = 'UTF-8';
usr.LanguageLocaleKey = 'en_US';
usr.LocaleSidKey = 'en_US';
usr.ProfileId = p.Id;
insert usr;

User usr2 = new User();
usr2.FirstName = 'Test1';
usr2.LastName = 'Test1';
usr2.User_Code__c = 'test1';
usr2.Email = 'usrxxx12345@test.com';
usr2.Username = 'usrxxx12345@test.com';
usr2.CompanyName = 'TEST';
usr2.Title = 'title';
usr2.Alias = 'alias';
usr2.TimeZoneSidKey = 'America/Los_Angeles';
usr2.EmailEncodingKey = 'UTF-8';
usr2.LanguageLocaleKey = 'en_US';
usr2.LocaleSidKey = 'en_US';
usr2.ProfileId = p.Id;
insert usr2;

RC_Fair__c fair = new RC_Fair__c();
fair.Name = 'Test';
fair.RC_Manager__c = usr2.Id;
insert fair;

RC_Fair_Team__c ft = new RC_Fair_Team__c();
ft.RC_Fair__c = fair.Id;
ft.RC_Sales_Organisation__c = 'Domestic';
ft.RC_User_Name__c = usr.Id;
insert ft;

RC_Fair_Team__c ft2 = new RC_Fair_Team__c();
ft2.RC_Fair__c = fair.Id;
ft2.RC_Sales_Organisation__c = 'Domestic';
ft2.RC_User_Name__c = usr2.Id;
insert ft2;

delete ft2;

*/
    }
}