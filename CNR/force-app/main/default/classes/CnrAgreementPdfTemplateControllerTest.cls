@IsTest
public class CnrAgreementPdfTemplateControllerTest {
    	@isTest
    public static void unitTest(){
        
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
        
        
        Account act2 = new Account();
        act2.Name = 'Test Act Ayt';
        act2.RC_LogoKey__c = '00001';           
        act2.Type='CNR Company';
        Database.SaveResult sract2 = Database.Insert(act2);
        
        RC_Fair__c fair = new RC_Fair__c();

        fair.RC_Manager__c = srUsr.getId();
        fair.RC_Location__c = 'IST';
        fair.Hall__c = 'Hall 1';
        fair.Status__c = 'Draft';
        fair.RC_TR_Logo_ID__c = documents[0].id;



        
        fair.RC_Overseas_Bonus__c=10.0;
        fair.RC_Bonus_Percentage__c=10.0;
        fair.RC_Stamp_Duty__c='50';
        fair.RC_Stamp_Duty_Percentage__c=5.0;
        fair.RC_Short_Name__c='TST';
        fair.RC_CNR_Firm__c=sract2.getId();
        
        
        Database.SaveResult srFair = Database.Insert(fair);
        fair.Status__c = 'Approved';
         Database.SaveResult srFair2 = Database.Update(fair);
        

        ApexPages.StandardController c = new ApexPages.StandardController(fair);
        CnrAgreementPdfTemplateController ext = new CnrAgreementPdfTemplateController(c);





    }
}