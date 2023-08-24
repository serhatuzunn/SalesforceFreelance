@isTest
public class RC_DeleteOpportunityLineItemTriggerTest {    
    public static testmethod void runOppLineItemTriggerTest()
    {
        Test.startTest();
        
        String standardCurrency = 'TRY';    
        User usr = [SELECT Id,RC_Sales_Organisation__c FROM USER WHERE Id =: System.UserInfo.getUserId()];
        usr.RC_Sales_Organisation__c = 'Domestic';
        
        Database.SaveResult srUsr = Database.update(usr);
        
        
        Account act2 = new Account();
        act2.Name = 'Test Act Ayt';
        act2.RC_LogoKey__c = '00001';            
        act2.Type='CNR Company';
        act2.Phone = '05005005050';
        act2.RC_Tax_Number__c = '1247825894';
        Database.SaveResult sract2 = Database.Insert(act2);
        
        
        
        RC_Fair__c Mainfair = new RC_Fair__c();
        Mainfair.RC_Manager__c = srUsr.getId();
        Mainfair.RC_Overseas_Bonus__c=10.0;
        Mainfair.RC_Bonus_Percentage__c=10.0;
        Mainfair.RC_Stamp_Duty__c='50';
        Mainfair.RC_Stamp_Duty_Percentage__c=5.0;
        Mainfair.RC_Short_Name__c='TST';
        Mainfair.Type__c = 'New';
        Mainfair.RC_CNR_Firm__c=sract2.getId();
        Mainfair.RC_Location__c = 'IST';
        Mainfair.Hall__c = 'Hall 1';
        Database.SaveResult srMainFair = Database.Insert(Mainfair);
        Mainfair.Status__c = 'Approved';
        Database.SaveResult srMainFairUpdate = Database.Update(Mainfair);
        
        
        
        
        
        
        RC_Fair__c fair = new RC_Fair__c();
        fair.RC_Manager__c = srUsr.getId(); 
        fair.RC_Location__c = 'IST';
        fair.Hall__c = 'Hall 1';
        fair.Type__c = 'New';
        fair.RC_Start_Date__c = Date.today();
        fair.RC_Related_Fair__c  = srMainFair.getId();
        fair.RC_Overseas_Bonus__c=10.0;
        fair.RC_Bonus_Percentage__c=10.0;
        fair.RC_Stamp_Duty__c='50';
        fair.RC_Stamp_Duty_Percentage__c=5.0;
        fair.RC_Short_Name__c='TST';
        fair.RC_CNR_Firm__c=sract2.getId();
        Database.SaveResult srFair = Database.Insert(fair);
        fair.Status__c = 'Approved';
        Database.SaveResult srFairUpdate = Database.Update(fair);
        
        
        
        
        Account act = new Account();
        act.Name = 'Test Act ZCK';
        act.RC_LogoKey__c = '00002';            
        act.Phone = '05005005053';
        act.RC_Tax_Number__c = '1247845894';
        Database.SaveResult sract = Database.Insert(act);
        if(sract.isSuccess())
        {
            Contact cnt = new Contact();
            cnt.FirstName = 'ZCK Contact';
            cnt.LastName = 'ZCK Contact';
            cnt.AccountId = sract.getId();
            cnt.RC_Primary__c = true;
            cnt.MobilePhone = '05005005051';
            cnt.Phone = '05005005052';
            Database.SaveResult srcnt = Database.Insert(cnt);
        }
        
        Product2 testProduct = new Product2();
        testProduct.Name = '12-150 m2 Alan';
        testProduct.ProductCode = '12150A';
        testProduct.Family = 'Area';
        testProduct.CurrencyIsoCode =  standardCurrency; //'TRY';
        testProduct.RC_Min_m2__c = 12.00;
        testProduct.RC_Max_m2__c = 150.00;
        
        
        
        Database.SaveResult srprod = Database.insert(testProduct);
        system.debug('srprod : ' + srprod.isSuccess());
        
        Opportunity opt = new Opportunity();
        opt.AccountId = sract.getId();
        opt.Pricebook2Id = Test.getStandardPricebookId();
        opt.OwnerId = usr.Id;
        opt.StageName = 'Potential';
        opt.Name = 'ZCK Test Opt';
        opt.RC_Sales_Organisation__c = 'Domestic';
        opt.CloseDate = Date.today();
        opt.RC_Fair__c = srFair.getId();
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
        
        
        insert opt;
        system.debug('opt.Id:' + opt);
        
        List<PricebookEntry> pbEntry = [SELECT Id, Product2Id,Pricebook2Id FROM PricebookEntry WHERE Product2Id =:srprod.getId() AND  Pricebook2Id=: opt.Pricebook2Id LIMIT 1];
        if(pbEntry.size() == 0)
        {
            pbEntry = new    List<PricebookEntry>();  
            
            PricebookEntry pbEntryItem = new PricebookEntry();
            pbEntryItem.Product2Id = srprod.getId();
            pbEntryItem.Pricebook2Id = opt.Pricebook2Id;
            pbEntryItem.CurrencyIsoCode = standardCurrency;
            pbEntryItem.UnitPrice = 123;                    
            pbEntryItem.IsActive = true;
            Database.SaveResult srpbEntry = Database.Insert(pbEntryItem);
            if(srpbEntry.isSuccess())
            {
                pbEntry.Add(pbEntryItem);
            }
            
        }
        system.debug('pbEntry:' + pbEntry);
        OpportunityLineItem oli = new OpportunityLineItem();
        oli.Product2Id = testProduct.Id;
        oli.OpportunityId = opt.Id;
        oli.Quantity = 100;
        oli.PricebookEntryId = pbEntry.get(0).Id;
        oli.RC_Net_Price__c=10;
        oli.UnitPrice=10;
        system.debug('olibefore:' + oli);
        Database.SaveResult sResult=Database.insert(oli);
        system.debug('sResult:' + sResult);
        List<OpportunityLineItem> oppLiItem=[SELECT Id,OpportunityId FROM OpportunityLineItem];
        system.debug('opt:' + oppLiItem);
        
        
        
        List<Opportunity> oppList=[SELECT ID,stagename,HasOpportunityLineItem,RC_Item_Count__c FROM Opportunity];
        system.debug('opp:' + oppList);
        Set<Id> oppIds=new Set<Id>();
        for(Opportunity  op : oppList)
        {
            oppIds.add(op.Id);
        }
        
        
        system.debug('oppIds:' + oppIds);
        
                
                RC_Payment_Plan__c testPaymentPlan1 = new RC_Payment_Plan__c(
            RC_Installment__c = 1,
            RC_Active__c = true,
            RC_Agreement__c = opt.Id,
            RC_Payment_Amount__c = 1000.00,
            RC_Payment_Type__c = 'Cash',
            RC_Sales_Person_Check__c = true,
            RC_Finance_Check__c = true,
            RC_Collector_Check__c = true,
            RC_Payment_Date__c = Date.today().addDays(60)
        );
        
        insert testPaymentPlan1;
        
        RC_Payment_Plan__c testPaymentPlan2 = new RC_Payment_Plan__c(
            RC_Installment__c = 2,
            RC_Active__c = true,
            RC_Agreement__c = opt.Id,
            RC_Payment_Amount__c = 2000.00,
            RC_Payment_Type__c = 'Cash',
            RC_Sales_Person_Check__c = true,
            RC_Finance_Check__c = false,
            RC_Collector_Check__c = false,
            RC_Payment_Date__c = Date.today().addDays(90)
        );
        
        insert testPaymentPlan2;
        system.debug('opt.Id:' + opt.Id);
        List<RC_Payment_Plan__c> payPl=[SELECT Id,RC_Installment__c,RC_Agreement__c FROM RC_Payment_Plan__c];
        system.debug('payPl' + payPl);
        
        List<OpportunityLineItem> oppLineItems=[SELECT Id FROM OpportunityLineItem WHERE OpportunityId=:oppIds];
        system.debug('oppLineItems:' + oppLineItems);

        for(OpportunityLineItem oppItem : oppLineItems)
        {
            delete oppItem;
        }
        test.stopTest();
    }
}