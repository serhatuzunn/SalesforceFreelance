@isTest
public class RC_CariBakiyeReportControllerTest {
    @isTest 
    public static void runTest()
    {
        Test.StartTest();
        Test.setMock(HttpCalloutMock.class, new LogoGetCariBakiyeIntegratorMock());
        Account actt =[SELECT id FROM Account WHERE RC_LogoKey__c =: '144' LIMIT 1];        
        RC_CariBakiyeReportController.Init(actt.Id); 
        Test.stopTest();
        // RC_CariBakiyeReportController.Init('0068E00000NlNDFQA3');
    }
     @isTest 
    public static void runTest2()
    {
        Test.StartTest();
        Test.setMock(HttpCalloutMock.class, new LogoGetCariBakiyeIntegratorMock());
        Opportunity opp =[SELECT id FROM Opportunity WHERE Name=: 'ZCK Test Opt' LIMIT 1];
        RC_CariBakiyeReportController.Init(opp.Id);
        Test.stopTest();
        // RC_CariBakiyeReportController.Init('0068E00000NlNDFQA3');
    }
    
    @testsetup static void prepareData(){           
        RC_CariBakiyeReportController.initWrapper initwrapper = new RC_CariBakiyeReportController.initWrapper();
        initwrapper.bakiye='';
        initwrapper.cariref='';
        initwrapper.cekdurumu='';
        initwrapper.kodu='';
        initwrapper.masrafmerkezi='';
        initwrapper.odemeplani='';
        initwrapper.projekodu='';
        initwrapper.risklimit='';
        initwrapper.sehir='';
        initwrapper.unvani='';
        
        Account actt = new Account();
        actt.Name='TestAccount';
        actt.RC_LogoKey__c='144';
        insert actt;
        
        
        Account act = new Account();
        act.Name='TestAccount2';
        act.RC_LogoKey__c='1870';
        act.Type='CNR Company';
        insert act;
        
        User usr = [SELECT Id,RC_Sales_Organisation__c FROM USER WHERE Id =: System.UserInfo.getUserId()];
        usr.RC_Sales_Organisation__c = 'Domestic';        
        Database.SaveResult srUsr = Database.update(usr);
        
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
        
        RC_Fair__c Mainfair = new RC_Fair__c();
        //Mainfair.RC_Advance_Payment__c = 2;
        Mainfair.RC_Manager__c = srUsr.getId();
        Mainfair.RC_Short_Name__c='test';
        Mainfair.RC_CNR_Firm__c=act.Id;
        Mainfair.RC_Bonus_Percentage__c=0.0;
        Mainfair.RC_Overseas_Bonus__c=0.0;
        Mainfair.RC_Stamp_Duty__c='100';
        Mainfair.RC_Stamp_Duty_Percentage__c=0.0;
        Mainfair.Status__c = 'In Approval';
        Database.SaveResult srMainFair = Database.Insert(Mainfair);
        
        RC_Fair__c fair = new RC_Fair__c();
        fair.RC_Short_Name__c='test';
        fair.RC_CNR_Firm__c=act.Id;
        fair.RC_Bonus_Percentage__c=0.0;
        fair.RC_Overseas_Bonus__c=0.0;
        fair.RC_Manager__c = srUsr.getId();
        fair.RC_Location__c = 'IST';
        fair.Hall__c = 'Hall 1';
        fair.Status__c = 'In Approval';
        fair.RC_TR_Logo_ID__c = documents[0].id;
        fair.RC_Related_Fair__c  = srMainFair.getId();
        fair.RC_Stamp_Duty_Percentage__c = 5;
        fair.RC_Stamp_Duty__c = '100';
        Database.SaveResult srFair = Database.Insert(fair);
        
        fair.Status__c = 'Approved';
        Database.SaveResult srFairUpdate = Database.Update(fair);
        
        
        Opportunity opt = new Opportunity();
        opt.AccountId = act.Id;
        opt.Pricebook2Id = Test.getStandardPricebookId();
        opt.OwnerId = usr.Id;
        opt.StageName = 'Advance Payment';
        opt.Name = 'ZCK Test Opt';
        opt.RC_Sales_Organisation__c = 'Domestic';
        opt.CloseDate = Date.today();
        opt.RC_Fair__c = srFair.getId();
        opt.Amount = 100;
        opt.RC_Subtotal__c = 100;
        opt.RC_Tax_Amount__c = 100;
        opt.RC_Stamp_Duty__c = 100.2;
        opt.RC_Entrance_Fee__c = 100;        
        Database.SaveResult srOpt = Database.Insert(opt);
    }
}