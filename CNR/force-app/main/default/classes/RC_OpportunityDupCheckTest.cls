@isTest
public class RC_OpportunityDupCheckTest {
    
    @testSetup 
    public static void setupData()
    {
        RC_TestClassUtils.createTestDatas();
    }
    
    public static testmethod void test(){
        //👀 ZİLAYDA WAS HERE 👀 (Thank You ZCK) 
        Test.startTest();
        
        RC_Fair__c subfair = [SELECT Id FROM RC_Fair__c WHERE RC_Related_Fair__c != null LIMIT 1];
        
        Account acc = [SELECT Id FROM Account LIMIT 1];
        
        User usr = [SELECT Id,RC_Sales_Organisation__c FROM USER WHERE Id =: System.UserInfo.getUserId()];
        usr.RC_Sales_Organisation__c = 'Domestic';
        
        Database.SaveResult srUsr = Database.update(usr);
        
        String standardCurrency = 'TRY';
        
        Opportunity opt = new Opportunity();
        opt.AccountId = acc.Id;
        opt.Pricebook2Id = Test.getStandardPricebookId();
        opt.OwnerId = usr.Id;
        opt.StageName = 'Unassigned';
        opt.Name = 'ZCK Test Opt';
        opt.RC_Sales_Organisation__c = 'Domestic';
        opt.CloseDate = Date.today();
        opt.RC_Fair__c = subfair.Id;
        opt.RC_Number_of_Installments__c = 5.00;
        opt.Amount = 1499.99;
        opt.CurrencyIsoCode =  standardCurrency;//'TRY';
        opt.RC_Stamp_Duty__c = 10.00;
        opt.RC_Tax_Amount__c = 300.00;
        opt.RC_Entrance_Fee__c = 100.00;                
        opt.RC_Agreement_Advance_Payment__c = 10.00;
        opt.RC_Average_Maturity_Days__c = 5;
        opt.RC_Final_Total__c = 1100.00;
        opt.CloseDate		= system.Date.today().addMonths(1);
        opt.RC_Tag__c='Tag Test';
        opt.RC_Data_Type__c='A';
        opt.Type = 'RC_New';
        opt.RC_Agreement_Date__c=date.newInstance(2020, 1, 1);
        
        Database.SaveResult srOpt = Database.Insert(opt);
        system.debug(srOpt);
    }
    
}