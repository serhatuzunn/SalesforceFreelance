@isTest
public class RC_CreateOpportunityQueueableTest {
    @testsetup static void prepareData(){                

        
    }
    static testMethod void aggWithoutPlan(){
        Test.startTest();
        
        List<Opportunity> oppList=new List<Opportunity>();
        
        
        Account act = new Account();
        act.Name = 'Test Act ZCK';
        act.RC_LogoKey__c = '00002';            
        
        Database.SaveResult sract = Database.Insert(act);
        
        Account act2 = new Account();
        act2.Name = 'Test Act Ayt';
        act2.RC_LogoKey__c = '00001';            
        act2.Type='CNR Company';
        Database.SaveResult sract2 = Database.Insert(act2);
        
        User usr = [SELECT Id,RC_Sales_Organisation__c FROM USER WHERE Id =: System.UserInfo.getUserId()];
        usr.RC_Sales_Organisation__c = 'Domestic';
        
        Database.SaveResult srUsr = Database.update(usr);
        
        
        RC_Fair__c Mainfair = new RC_Fair__c();
        //Mainfair.RC_Advance_Payment__c = 2;
        Mainfair.RC_Manager__c = srUsr.getId();
        Mainfair.Status__c = 'Approved';
        Mainfair.RC_Overseas_Bonus__c=10.0;
        Mainfair.RC_Bonus_Percentage__c=10.0;
        Mainfair.RC_Stamp_Duty__c='50';
        Mainfair.RC_Stamp_Duty_Percentage__c=5.0;
        Mainfair.RC_Short_Name__c='TST';
        Mainfair.RC_CNR_Firm__c=sract2.getId();
        Database.SaveResult srMainFair = Database.Insert(Mainfair);
        
        
        RC_Fair__c fair = new RC_Fair__c();
        //fair.RC_Advance_Payment__c = 2;
        fair.RC_Manager__c = srUsr.getId();
        fair.RC_Location__c = 'IST';
        fair.Hall__c = 'Hall 1';
        fair.Status__c = 'Approved';
        fair.RC_Start_Date__c = Date.today();
        fair.RC_Related_Fair__c  = srMainFair.getId();
        fair.RC_Overseas_Bonus__c=10.0;
        fair.RC_Bonus_Percentage__c=10.0;
        fair.RC_Stamp_Duty__c='50';
        fair.RC_Stamp_Duty_Percentage__c=5.0;
        fair.RC_Short_Name__c='TST';
        fair.RC_CNR_Firm__c=sract2.getId();
        //fair.RC_Tax_Date__c=Date.newInstance(2020,10,10);
        //fair.RC_Payment_Type__c='Cash';
        //fair.RC_Starting_Month__c='5';
        //fair.RC_Payment_Day__c='1';
        //fair.RC_Split_Tax__c=true;
        //fair.RC_Number_of_Installments__c = 4;
        //fair.RC_Fixed_Payment_Plan__c=true;
        Database.SaveResult srFair = Database.Insert(fair);
        
        Opportunity opt = new Opportunity();
        opt.AccountId = sract.getId();
        opt.Pricebook2Id = Test.getStandardPricebookId();
        opt.OwnerId = usr.Id;
        opt.StageName = 'Unassigned';
        opt.Name = 'ZCK Test Opt';
        opt.RC_Sales_Organisation__c = 'Domestic';
        opt.CloseDate = Date.today();
        opt.RC_Fair__c = srFair.getId();
        opt.RC_Number_of_Installments__c = 5.00;
        opt.Amount = 1499.99;
        opt.CurrencyIsoCode =  'TRY';
        opt.RC_Stamp_Duty__c = 10.00;
        opt.RC_Tax_Amount__c = 300.00;
        opt.RC_Entrance_Fee__c = 100.00;                
        opt.RC_Agreement_Advance_Payment__c = 10.00;
        opt.RC_Average_Maturity_Days__c = 5;
        opt.RC_Final_Total__c = 1100.00;
        opt.CloseDate		= system.Date.today().addMonths(1);
        opt.RC_Tag__c='Tag Test';
        opt.RC_Data_Type__c='A';
        opt.RC_Agreement_Date__c=date.newInstance(2020, 1, 1);
        
        oppList.add(opt);
        System.enqueueJob(new RC_CreateOpportunityQueueable(oppList));
        
        
        Test.stopTest();
    }
}