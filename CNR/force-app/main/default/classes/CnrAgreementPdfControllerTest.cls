@isTest
public class CnrAgreementPdfControllerTest {
	@isTest
    public static void unitTest(){
        
        User usr = [SELECT Id,RC_Sales_Organisation__c, ProfileId FROM USER WHERE Id =: System.UserInfo.getUserId()];
        usr.RC_Sales_Organisation__c = 'Domestic';
        Database.SaveResult srUsr = Database.update(usr);
        
        Account act = new Account();
        act.Name = 'Test Act ZCK';
        act.RC_LogoKey__c = '00001';           
        act.Type = 'CNR Company';
        act.RC_Portal_Country__c = '1';
        Database.SaveResult sract = Database.Insert(act);
        
        Account act2 = new Account();
        act2.Name = 'Test Act ZCK 2';
        act2.RC_LogoKey__c = '00002';           
        act2.Type = 'CNR Company';
        act2.RC_Portal_Country__c = '1';
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
        
        Product2 testProduct = new Product2();
        testProduct.Name = '12-150 m2 Alan';
        testProduct.ProductCode = '12150A';
        testProduct.Family = 'Area';
        testProduct.CurrencyIsoCode =  'USD';
        testProduct.RC_Min_m2__c = 12.00;
        testProduct.RC_Max_m2__c = 150.00;
        Database.SaveResult srprod = Database.insert(testProduct);
        
        RC_Fair__c Mainfair = new RC_Fair__c();
        Mainfair.RC_Manager__c = srUsr.getId();
        Mainfair.Foreign_General_Manager__c = srU.getId();
        Mainfair.Status__c = 'Draft';
        Mainfair.RC_Overseas_Bonus__c = 10.0;
        Mainfair.RC_Bonus_Percentage__c = 10.0;
        Mainfair.RC_Stamp_Duty__c = '50';
        Mainfair.RC_Stamp_Duty_Percentage__c = 5.0;
        Mainfair.RC_Short_Name__c = 'TST';
        Mainfair.RC_CNR_Firm__c = sract.getId();
        Mainfair.RC_Country__c = 'Turkey';
        Mainfair.RC_Start_Date__c = Date.today();
        Mainfair.RC_End_Date__c = Date.today().addDays(1);
        //Mainfair.RC_Advance_Payment__c = 2;
        Database.SaveResult srMainFair = Database.Insert(Mainfair);
        
        Mainfair.Status__c = 'Approved';
        Database.SaveResult UpdateResultMainFair = Database.Update(Mainfair);
        
        ContentVersion contentVersionInsert = new ContentVersion(
            Title = 'Test',
            PathOnClient = 'Test.jpg',
            VersionData = Blob.valueOf('Test Content Data'),
            IsMajorVersion = true
        );
        insert contentVersionInsert;
        
        ContentVersion contentVersionSelect = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id = :contentVersionInsert.Id LIMIT 1];
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        System.assertEquals(documents.size(), 1);
        
        RC_Fair__c fair = new RC_Fair__c();
        fair.RC_Manager__c = srUsr.getId();
        fair.Foreign_General_Manager__c = srU.getId();
        fair.RC_Location__c = 'IST';
        fair.Hall__c = 'Hall 1';
        fair.Status__c = 'Draft';
        fair.RC_TR_Logo_ID__c = documents[0].id;
        fair.RC_Related_Fair__c  = srMainFair.getId();
        fair.RC_Stamp_Duty_Percentage__c = 5;
        fair.RC_Stamp_Duty__c = '100';
        fair.RC_Overseas_Bonus__c = 10.0;
        fair.RC_Bonus_Percentage__c = 10.0;
        fair.RC_Short_Name__c = 'TST';
        fair.RC_CNR_Firm__c = sract.getId();
        fair.RC_Country__c = 'Turkey';
        fair.RC_Start_Date__c = Date.today();
        fair.RC_End_Date__c = Date.today().addDays(1);
        //fair.RC_Advance_Payment__c = 2;
        Database.SaveResult srFair = Database.Insert(fair);
        
        fair.Status__c = 'Approved';
        Database.SaveResult srFairUpdate = Database.Update(fair);

        Contact cnt = new Contact();
        cnt.FirstName = 'ZCK Contact';
        cnt.LastName = 'ZCK Contact';
        cnt.AccountId = sract.getId();
        cnt.RC_Primary__c = true;
        Database.SaveResult srcnt = Database.Insert(cnt);
        
        Opportunity opt = new Opportunity();
        opt.AccountId = sract.getId();
        opt.Pricebook2Id = Test.getStandardPricebookId();
        opt.OwnerId = usr.Id;
        opt.StageName = 'Unassigned';
        opt.Name = 'ZCK Test Opt';
        opt.RC_Sales_Organisation__c = 'Foreign';
        opt.CloseDate = Date.today();
        opt.RC_Fair__c = srFair.getId();
        opt.Amount = 100;
        opt.RC_Subtotal__c = 100;
		opt.RC_Tax_Amount__c = 100;
		opt.RC_Stamp_Duty__c = 100.2;
		opt.RC_Entrance_Fee__c = 100;
        opt.RC_Data_Type__c = 'A';
        Database.SaveResult srOpt = Database.Insert(opt);
        
        Pricebook2 priceBook = new Pricebook2();
        pricebook.Average_Maturity_Date__c = Date.today();
        pricebook.IsActive = true;
        pricebook.Name = 'Test Fiyat Listesi';
        pricebook.RC_Advance_Payment__c = 30;
        pricebook.RC_Fair__c = fair.Id;
        pricebook.RC_Average_Maturity_Days__c = 30;
        pricebook.RC_Country__c = 'Turkey';
        pricebook.RC_Start_Date__c = Date.today().addDays(7);
        pricebook.RC_End_Date__c = Date.today().addDays(30);
        pricebook.RC_Fixed_Payment_Plan__c = true;
        pricebook.RC_Number_of_Installments__c = 5;
        pricebook.RC_Split_Tax__c = true;
        pricebook.CurrencyIsoCode = 'USD';
        insert pricebook;
        
        Pricebook2 pr = [SELECT Id,Name FROM Pricebook2 LIMIT 1];
        
        // Currency ISO Code farklı olan OPT
        Opportunity opt2 = new Opportunity();
        opt2.AccountId = sract2.getId();
        opt2.Pricebook2Id = pr.id;
        opt2.OwnerId = usr.Id;
        opt2.StageName = 'Unassigned';
        opt2.Name = 'ZCK Test Opt2';
        opt2.RC_Sales_Organisation__c = 'Domestic';
        opt2.CloseDate = Date.today();
        opt2.RC_Fair__c = srFair.getId();
        opt2.Amount = 100;
        opt2.RC_Subtotal__c = 100;
		opt2.RC_Tax_Amount__c = 100;
		opt2.RC_Stamp_Duty__c = 100.2;
		opt2.RC_Entrance_Fee__c = 100;
        opt2.CurrencyIsoCode = 'USD';
        opt2.RC_Agreement_Exchange_Rate__c = 0.6;
        opt2.RC_Data_Type__c = 'A';
        Database.SaveResult srOpt2 = Database.Insert(opt2);
        
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
        
        //List<PricebookEntry> pbEntry = [SELECT Id, Product2Id,Pricebook2Id FROM PricebookEntry WHERE Product2Id =:srprod.getId() AND  Pricebook2Id=: opt2.Pricebook2Id LIMIT 1];
        //system.debug('Test pbEntry : ' + pbEntry[0].CurrencyIsoCode);
        
        List<PricebookEntry> pbEntry = new List<PricebookEntry>();  
        
        PricebookEntry pbEntryItem = new PricebookEntry();
        pbEntryItem.Product2Id = srprod.getId();
        pbEntryItem.Pricebook2Id = opt2.Pricebook2Id;
        pbEntryItem.CurrencyIsoCode = 'USD';
        pbEntryItem.UnitPrice = 123;                    
        pbEntryItem.IsActive = true;
        Database.SaveResult srpbEntry = Database.Insert(pbEntryItem);
        if(srpbEntry.isSuccess())
        {
            pbEntry.Add(pbEntryItem);
        }
        
        OpportunityLineItem oli = new OpportunityLineItem();
        oli.Product2Id = testProduct.Id;
        oli.OpportunityId = opt2.Id;
        oli.Quantity = 100;
        oli.PricebookEntryId = pbEntry.get(0).Id;
        oli.TotalPrice = 1000;
        Database.SaveResult sroli = Database.Insert(oli);
        
        OpportunityContactRole role = new OpportunityContactRole();
        role.IsPrimary = true;
        role.Role = 'Business User';
        role.OpportunityId = opt.id;
        role.ContactId = cnt.id;
        Database.SaveResult srRole = Database.Insert(role);
        
        system.debug('opt::' + opt);
        
        test.startTest();
        
        ApexPages.StandardController c = new ApexPages.StandardController(opt);
        ApexPages.StandardController c2 = new ApexPages.StandardController(opt2);
        CnrAgreementPdfController ext = new CnrAgreementPdfController(c);
        CnrAgreementPdfController ext2 = new CnrAgreementPdfController(c2);
       
        ext.savePdf();
        ext.savePdfInternational();
        List<Id> IdList = new List<Id>();
        IdList.add(opt.id);
        RC_AgreementPDF_Invocable.InvokeCreatePDF(IdList);
        
        test.stopTest();
    }
}