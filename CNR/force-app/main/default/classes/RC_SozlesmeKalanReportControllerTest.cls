@isTest
public class RC_SozlesmeKalanReportControllerTest {
    @isTest 
    public static void runTest()
    {
        RC_SozlesmeKalanReportController.initWrapper initwrapper = new RC_SozlesmeKalanReportController.initWrapper();
        initwrapper.sozlesmeNo='';
        initwrapper.kalanTutar='';
        initwrapper.kayitsayisi='';
        
        User usr = [SELECT Id,RC_Sales_Organisation__c FROM USER WHERE Id =: System.UserInfo.getUserId()];
        usr.RC_Sales_Organisation__c = 'Domestic';        
        Database.SaveResult srUsr = Database.update(usr);
        
        Account act = new Account();
        act.Name = 'Test Act ZCK';       
        act.Type='CNR Company';
        Database.SaveResult sract = Database.Insert(act);
        
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
        opt.StageName = 'Advance Payment';
        opt.Name = 'ZCK Test Opt2222';
        opt.RC_Sales_Organisation__c = 'Domestic';
        opt.CloseDate = Date.today();
        opt.RC_Fair__c = srFair.getId();
        opt.Amount = 100;
        opt.RC_Subtotal__c = 100;
        opt.RC_Tax_Amount__c = 100;
        opt.RC_Stamp_Duty__c = 100.2;
        opt.RC_Entrance_Fee__c = 100;   
        opt.RC_Final_Total__c=1;
        Database.SaveResult srOpt = Database.Insert(opt);
        
        system.debug('opt::' + opt);  
        
        Test.StartTest();
        Test.setMock(HttpCalloutMock.class, new LogoGetSozlesmeKalanIntegratorMock());
        RC_SozlesmeKalanReportController.Init(opt.Id);
        
      //  RC_SozlesmeKalanReportController.Init('0068E00000NlNDFQA3');
        Test.stopTest();
    }
}