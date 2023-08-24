@isTest(seeAllData=true)
public class RC_TestClassPaymentPlan {
    static public void createTestDatas()
    {
        system.debug(Test.getStandardPricebookId());
        
        String standardCurrency = 'TRY';
        //String standardCurrency = [SELECT Id,CurrencyIsoCode FROM Pricebook2 where Id =: Test.getStandardPricebookId() LIMIT 1].CurrencyIsoCode;
        
        User usr = [SELECT Id,RC_Sales_Organisation__c, ProfileId FROM USER WHERE Id =: System.UserInfo.getUserId()];
        usr.RC_Sales_Organisation__c = 'Domestic';
        Database.SaveResult srUsr = Database.update(usr);
        
        Account act2 = new Account();
        act2.Name = 'Test Act Ayt';
        act2.RC_LogoKey__c = '00001';            
        act2.Type='CNR Company';
        act2.Phone = '05005005050';
        act2.RC_Tax_Number__c = '1247825894';
        Database.SaveResult sract2 = Database.Insert(act2);
        
        User u = new User();
        u.RC_Sales_Organisation__c = 'Foreign';
        u.Username = 'testforeignuser@test.com';
        u.LastName = 'Test Last Name';
        u.Email = 'testforeignuser@test.com';
        u.TimeZoneSidKey = 'Europe/Istanbul';
        u.LocaleSidKey = 'tr_TR';
        u.Alias = 'testusr';
        u.EmailEncodingKey = 'UTF-8';
        u.LanguageLocaleKey = 'tr';
        u.ProfileId = usr.ProfileId;
        Database.SaveResult srU = Database.Insert(u);
        
        RC_Fair__c Mainfair = new RC_Fair__c();
        Mainfair.RC_Manager__c = srUsr.getId();
        Mainfair.Foreign_General_Manager__c = srU.getId();
        Mainfair.RC_Overseas_Bonus__c=10.0;
        Mainfair.RC_Bonus_Percentage__c=10.0;
        Mainfair.RC_Stamp_Duty__c='50';
        Mainfair.RC_Stamp_Duty_Percentage__c=5.0;
        Mainfair.RC_Short_Name__c='TST';
        Mainfair.Type__c = 'New';
        Mainfair.RC_CNR_Firm__c=sract2.getId();
        Mainfair.RC_Location__c = 'IST';
        Mainfair.Hall__c = 'Hall 1';
        Mainfair.RC_Country__c = 'Turkey';
        Mainfair.RC_Start_Date__c = Date.today();
        Mainfair.RC_End_Date__c = Date.today().addDays(1);
        //Mainfair.RC_Advance_Payment__c = 2;
        Database.SaveResult srMainFair = Database.Insert(Mainfair);
        
        Mainfair.Status__c = 'Approved';
        Database.SaveResult srMainFairUpdate = Database.Update(Mainfair);
        
        RC_Fair__c fair = new RC_Fair__c();
        fair.RC_Manager__c = srUsr.getId();
        fair.Foreign_General_Manager__c = srU.getId();
        fair.RC_Location__c = 'IST';
        fair.Hall__c = 'Hall 1';
        fair.Type__c = 'New';
        fair.RC_Start_Date__c = Date.today();
        fair.RC_Related_Fair__c = srMainFair.getId();
        fair.RC_Overseas_Bonus__c = 10.0;
        fair.RC_Bonus_Percentage__c = 10.0;
        fair.RC_Stamp_Duty__c = '50';
        fair.RC_Stamp_Duty_Percentage__c = 5.0;
        fair.RC_Short_Name__c ='TST';
        fair.RC_CNR_Firm__c = sract2.getId();
        fair.RC_Country__c = 'Turkey';
        fair.RC_Start_Date__c = Date.today();
        fair.RC_End_Date__c = Date.today().addDays(1);
        //fair.RC_Tax_Date__c  =Date.newInstance(2020,10,10);
        //fair.RC_Payment_Type__c = 'Cash';
        //fair.RC_Starting_Month__c = '5';
        //fair.RC_Payment_Day__c = '1';
        //fair.RC_Split_Tax__c = true;
        //fair.RC_Number_of_Installments__c = 4;
        //fair.RC_Fixed_Payment_Plan__c = true;
        //fair.RC_Advance_Payment__c = 2;
        Database.SaveResult srFair = Database.Insert(fair);
        
        fair.Status__c = 'Approved';
        Database.SaveResult srFairUpdate = Database.Update(fair);
        
        RC_Fair__c fair2 = new RC_Fair__c();
        fair2.RC_Manager__c = srUsr.getId(); 
        fair2.Foreign_General_Manager__c = srU.getId();
        fair2.RC_Location__c = 'IST';
        fair2.Hall__c = 'Hall 1'; 
        fair2.Type__c = 'New';
        fair2.RC_Related_Fair__c = srMainFair.getId();
        fair2.RC_Overseas_Bonus__c = 10.0;
        fair2.RC_Bonus_Percentage__c = 10.0;
        fair2.RC_Stamp_Duty__c = '50';
        fair2.RC_Stamp_Duty_Percentage__c = 5.0;
        fair2.RC_Short_Name__c = 'TST';
        fair2.RC_CNR_Firm__c = sract2.getId();
        fair2.RC_Country__c = 'Turkey';
        fair2.RC_Start_Date__c = Date.today();
        fair2.RC_End_Date__c = Date.today().addDays(1); 
        //fair2.RC_Advance_Payment__c = 2;
        //fair2.Status__c = 'Approved';
        Database.SaveResult srFair2 = Database.Insert(fair2);
        
        fair2.Status__c = 'Approved';
        Database.SaveResult srFair2Update = Database.Update(fair2);
        
        Product2 testProduct = new Product2();
        testProduct.Name = '12-150 m2 Alan';
        testProduct.ProductCode = '12150A';
        testProduct.Family = 'Area';
        testProduct.CurrencyIsoCode = standardCurrency; //'TRY';
        testProduct.RC_Min_m2__c = 12.00;
        testProduct.RC_Max_m2__c = 150.00;
        Database.SaveResult srprod = Database.insert(testProduct);
        
        system.debug('srprod : ' + srprod.isSuccess());
        
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
            if(srcnt.isSuccess())
            {
                Pricebook2 priceBook = new Pricebook2();
                pricebook.Average_Maturity_Date__c = Date.today();
                pricebook.IsActive = true;
                pricebook.Name='Test Fiyat Listesi';
                pricebook.RC_Advance_Payment__c = 30;
                pricebook.RC_Fair__c = fair.Id;
                pricebook.RC_Average_Maturity_Days__c = 30;
                pricebook.RC_Country__c = 'Turkey';
                pricebook.RC_Start_Date__c = Date.today().addDays(7);
                pricebook.RC_End_Date__c = Date.today().addDays(30);
                pricebook.RC_Fixed_Payment_Plan__c = true;
                pricebook.RC_Number_of_Installments__c = 5;
                pricebook.RC_Split_Tax__c = true;
                pricebook.CurrencyIsoCode = standardCurrency;
                insert pricebook;
                
                Pricebook2 pr = [SELECT Id, Name FROM Pricebook2 LIMIT 1];
                system.debug('pr: '+ pr.Name);
                
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
                opt.CurrencyIsoCode =  standardCurrency;//'TRY';
                opt.RC_Stamp_Duty__c = 10.00;
                opt.RC_Tax_Amount__c = 300.00;
                opt.RC_Entrance_Fee__c = 100.00;                
                opt.RC_Agreement_Advance_Payment__c = 10.00;
                opt.RC_Average_Maturity_Days__c = 5;
                opt.RC_Final_Total__c = 1100.00;
                opt.CloseDate = system.Date.today().addMonths(1);
                opt.RC_LogoKey__c = '';
                opt.RC_Tag__c = 'Tag Test';
                opt.RC_Data_Type__c = 'A';
                opt.Type = 'RC_New';
                opt.RC_Agreement_Date__c = date.newInstance(2020, 1, 1);
                Database.SaveResult srOpt = Database.Insert(opt);
                
                Opportunity opt2 = new Opportunity();
                opt2.AccountId = sract.getId();
                opt2.Pricebook2Id = pr.Id;
                opt2.OwnerId = usr.Id;
                opt2.StageName = 'Potential';
                opt2.Name = 'Second Test Data';
                opt2.RC_Sales_Organisation__c = 'Domestic';
                opt2.CloseDate = Date.today();
                opt2.RC_Fair__c = srFair.getId();
                opt2.RC_Number_of_Installments__c = 5.00;
                opt2.Amount = 1499.99;
                opt2.RC_Stamp_Duty__c = 10.00;
                opt2.RC_LogoKey__c = '';
                opt2.CurrencyIsoCode = standardCurrency;//'TRY';
                opt2.RC_Tax_Amount__c = 300.00;
                opt2.RC_Entrance_Fee__c = 100.00;                
                opt2.RC_Agreement_Advance_Payment__c = 10.00;
                opt2.RC_Average_Maturity_Days__c = 5;
                opt2.RC_Final_Total__c = 1100.00;
                opt2.CloseDate = system.Date.today().addMonths(1);
                opt2.RC_Tag__c ='Tag Test';
                opt2.RC_Data_Type__c ='A';
                opt2.Type = 'RC_Subcontract';
                Database.SaveResult srOpt2 = Database.Insert(opt2);
                
                Opportunity opt3 = new Opportunity();
                opt3.AccountId = sract.getId();
                opt3.Pricebook2Id = pr.Id;
                opt3.OwnerId = usr.Id;
                opt3.StageName = 'Potential';
                opt3.Name = 'Second Test Data';
                opt3.RC_Sales_Organisation__c = 'Domestic';
                opt3.CloseDate = Date.today();
                opt3.RC_Fair__c = srFair2.getId();
                opt3.RC_Number_of_Installments__c = 5.00;
                opt3.Amount = 1499.99;
                opt3.RC_Stamp_Duty__c = 10.00;
                opt3.CurrencyIsoCode = standardCurrency;// 'TRY';
                opt3.RC_Tax_Amount__c = 300.00;
                opt3.RC_Entrance_Fee__c = 100.00;                
                opt3.RC_Agreement_Advance_Payment__c = 10.00;
                opt3.RC_Average_Maturity_Days__c = 5;
                opt3.RC_Final_Total__c = 1100.00;
                opt3.CloseDate = system.Date.today().addMonths(1);
                opt3.RC_Tag__c='Tag Test';
                opt3.RC_LogoKey__c = '';
                opt3.RC_Data_Type__c ='A';
                Database.SaveResult srOpt3 = Database.Insert(opt3);
                
                Opportunity opt4 = new Opportunity();
                opt4.AccountId = sract2.getId();
                opt4.Pricebook2Id = pr.Id;
                opt4.OwnerId = usr.Id;
                opt4.StageName = 'Potential';
                opt4.Name = 'Second Test Data';
                opt4.RC_Sales_Organisation__c = 'Foreign';
                opt4.CloseDate = Date.today();
                opt4.RC_Fair__c = srFair2.getId();
                opt4.RC_Number_of_Installments__c = 5.00;
                opt4.Amount = 1499.99;
                opt4.RC_Stamp_Duty__c = 10.00;
                opt4.RC_LogoKey__c = '';
                opt4.CurrencyIsoCode = standardCurrency;// 'TRY';
                opt4.RC_Tax_Amount__c = 300.00;
                opt4.RC_Entrance_Fee__c = 100.00;                
                opt4.RC_Agreement_Advance_Payment__c = 10.00;
                opt4.RC_Average_Maturity_Days__c = 5;
                opt4.RC_Final_Total__c = 1100.00;
                opt4.CloseDate = system.Date.today().addMonths(1);
                opt4.RC_Tag__c = 'Tag Test';
                opt4.RC_Data_Type__c = 'A';
                Database.SaveResult srOpt4 = Database.Insert(opt4);
                
                List<PricebookEntry> pbEntry = [SELECT Id, Product2Id, Pricebook2Id FROM PricebookEntry WHERE Product2Id =:srprod.getId() AND Pricebook2Id=: opt.Pricebook2Id LIMIT 1];
                if(pbEntry.size() == 0)
                {
                    pbEntry = new List<PricebookEntry>();  
                    
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

                OpportunityLineItem oli = new OpportunityLineItem();
                oli.Product2Id = testProduct.Id;
                oli.OpportunityId = opt.Id;
                oli.Quantity = 100;
                oli.PricebookEntryId = pbEntry.get(0).Id;
                oli.TotalPrice = 1000;
                insert oli;
            }
            else
            {
                system.debug(srcnt.getErrors());
            }
        }
        else
        {
            system.debug(sract.getErrors());
        }
    }
}