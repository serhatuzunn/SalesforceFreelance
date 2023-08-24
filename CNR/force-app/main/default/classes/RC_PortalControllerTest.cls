@isTest
public class RC_PortalControllerTest {
    
    @testSetup static void prepareTestData(){
        RC_CommunitySettings__c testSetting = new RC_CommunitySettings__c();
        testSetting.Name = 'CommunityService';
        testSetting.UserName__c = 'esmanur.yenidogan@cnr.dev';
        testSetting.Secret__c = 'B27B41B1CCEBF912EB10A89E02D57A68CF2E6CFA17915F50DFB0F48DF2B9E245';
        testSetting.Id__c = '3MVG954MqIw6FnnNukvfgnM3E27H5NhylvuDTSJ4qx_.oin803upyjy2TFTmrUB4vZpcQzUv1cXOPZKEonIpK';
        testSetting.Security_Token__c = 'YQ8jIfRDiBcd1YfFiCzc0GZZ';
        testSetting.Password__c = 'Ey5829546.';
        
        insert testSetting;
        
        String standardCurrency = 'TRY';
        
        Account testAccount = new Account(
            Name = 'Test Account Name',
            RC_LogoKey__c = '00001',
            Type='CNR Company',
            Phone = '05005005050',
            RC_Tax_Number__c = '1247825894',
            RC_Portal_Country__c = '1'
        );
        
        insert testAccount;
        
        Contact testContact = new Contact(
            FirstName = 'Test Contact First Name',
            LastName = 'Test Contact Last Name',
            RC_Password__c = '123456',
            Email = 'testemail@outlook.com',
            RC_IsAgree__c = true,
            AccountId = testAccount.Id,
            RC_Contact_Type__c = 'STAND',
            MobilePhone = '5384544772'
        );
        
        insert testContact;
        
        RC_Fair__c testMainFair = new RC_Fair__c(
            RC_Manager__c = UserInfo.getUserId(),
            RC_Overseas_Bonus__c = 10.0,
            RC_Bonus_Percentage__c = 10.0,
            RC_Stamp_Duty__c = '50',
            RC_Stamp_Duty_Percentage__c = 5.0,
            RC_Short_Name__c = 'TST',
            Type__c = 'New',
            RC_CNR_Firm__c = testAccount.Id,
            RC_Location__c = 'IST',
            Hall__c = 'Hall 1',
            RC_Portal_Web_Id__c = '123456',
            RC_Portal_User_Id__c = '123'
        );
        
        insert testMainFair;
        
        RC_Fair__c testFair = new RC_Fair__c(
            RC_Manager__c = UserInfo.getUserId(),
            RC_Location__c = 'IST',
            Hall__c = 'Hall 1',
            Type__c = 'New',
            RC_Related_Fair__c = testMainFair.Id,
            RC_Start_Date__c = Date.today(),            
            RC_End_Date__c = Date.today().addMonths(1),
            RC_Overseas_Bonus__c = 10.0,
            RC_Bonus_Percentage__c = 10.0,
            RC_Stamp_Duty__c = '50',
            RC_Stamp_Duty_Percentage__c = 5.0,
            RC_Short_Name__c = 'TST',
            RC_CNR_Firm__c = testAccount.Id,
            RC_Portal_User_Id__c = '123'
        );
        
        insert testFair;
        
        testFair.Status__c = 'Approved';
        
        update testFair;
        
        Opportunity testOpportunity = new Opportunity(
            AccountId = testAccount.Id,
            Pricebook2Id = Test.getStandardPricebookId(),
            OwnerId = UserInfo.getUserId(),
            StageName = 'Unassigned',
            Name = 'Test Opportunity',
            RC_Sales_Organisation__c = 'Domestic',
            RC_Fair__c = testFair.Id,
            RC_Number_of_Installments__c = 5.00,
            Amount = 1499.99,
            CurrencyIsoCode = standardCurrency,
            RC_Stamp_Duty__c = 10.00,
            RC_Tax_Amount__c = 300.00,
            RC_Entrance_Fee__c = 100.00,
            RC_Agreement_Advance_Payment__c = 10.00,
            RC_Average_Maturity_Days__c = 5,
            RC_Final_Total__c = 1100.00,
            CloseDate		= system.Date.today().addMonths(1),
            RC_Tag__c='Tag Test',
            RC_Data_Type__c='A',
            Type = 'RC_New',
            RC_Agreement_Date__c=date.newInstance(2020, 1, 1)
        );
        
        insert testOpportunity;        
        
        RC_Value_Set__c testMainSector = new RC_Value_Set__c(
            Name = 'Test Value Set 1',
            RC_Type__c = 'Sector'
        );
        
        insert testMainSector;
        
        RC_Value_Set__c testSubSector = new RC_Value_Set__c(
            Name = 'Test Value Set 2',
            RC_Type__c = 'Sub Sector',
            RC_Sector__c = testMainSector.Id
        );
        
        insert testSubSector;
        
        RC_Value_Set__c testProductGroupSector = new RC_Value_Set__c(
            Name = 'Test Value Set 3',
            RC_Type__c = 'Product Group',
            RC_Sub_Sector__c = testSubSector.Id
        );
        
        insert testProductGroupSector;
        
        RC_Exhbitor_Badges__c testExhibitorBadges = new RC_Exhbitor_Badges__c(
            RC_FullName__c = 'Test Badge',
            RC_Title__c = 'Test Badge Title',
            Account__c = testAccount.Id
        );
        
        insert testExhibitorBadges;
        
        
        RC_Invitation__c testInvitation = new RC_Invitation__c(
            Account__c = testAccount.Id,
            RC_Reserved__c = '1'
        );
        
        insert testInvitation;
    }
    
    @isTest static void unitTestForLogin(){
        Contact testContact = [SELECT Email, RC_Password__c FROM Contact LIMIT 1];
        
        Test.startTest();
        
        RC_PortalController.LoginResult successLogin = RC_PortalController.Login(testContact.Email, testContact.RC_Password__c);        
        RC_PortalController.LoginResult wrongPasswordLogin = RC_PortalController.Login(testContact.Email, '');        
        RC_PortalController.LoginResult wrongEmailLogin = RC_PortalController.Login('', '');    
        
        Test.stopTest();
    }
    
    @isTest static void unitTestForResetPasswordMail(){
        Test.setMock(HttpCalloutMock.class, new RC_CommunityWorksMock());
        
        Contact testContact = [SELECT Email, RC_Password__c FROM Contact LIMIT 1];
        
        Test.startTest();
        
        RC_PortalController.LoginResult emptyResetResul = RC_PortalController.resetPasswordMail('', 'TR');
        RC_PortalController.LoginResult exceptionResetResult = RC_PortalController.resetPasswordMail(testContact.Email, 'TR');
        
        Test.stopTest();
    }
    
    @isTest static void unitTestForResetPassword(){            
        Test.setMock(HttpCalloutMock.class, new RC_CommunityWorksMock());
        
        Contact testContact = [SELECT Email, RC_Password__c FROM Contact LIMIT 1];
        testContact.RC_TOKEN__c = RC_PortalController.createToken();
        
        update testContact;
        
        Test.startTest();
        
        RC_PortalController.LoginResult emptyTokenResult = RC_PortalController.resetPassword(testContact.RC_Password__c, testContact.RC_Password__c, '');
        RC_PortalController.LoginResult wrongTokenResult = RC_PortalController.resetPassword(testContact.RC_Password__c, testContact.RC_Password__c, testContact.RC_TOKEN__c + 'test');
        RC_PortalController.LoginResult wrongPasswordResult = RC_PortalController.resetPassword('test', testContact.RC_Password__c, testContact.RC_TOKEN__c + 'test');
        RC_PortalController.LoginResult successResult = RC_PortalController.resetPassword(testContact.RC_Password__c, testContact.RC_Password__c, testContact.RC_TOKEN__c);
        
        Test.stopTest();    
    }
    
    @isTest static void unitTestForSendEmail(){         
        Contact testContact = [SELECT Email, RC_Password__c FROM Contact LIMIT 1];
        testContact.RC_TOKEN__c = RC_PortalController.createToken();
        
        update testContact;
        
        Test.startTest();
        
        Boolean successResult = RC_PortalController.SendEmail(testContact.Email, testContact.RC_TOKEN__c, 'tr');
        Boolean failResult = RC_PortalController.SendEmail('', testContact.RC_TOKEN__c, 'tr');
        
        Test.stopTest();
    }
    
    @isTest static void unitTestForSaveFair(){
        RC_Fair__c testFair = [SELECT Id FROM RC_Fair__c LIMIT 1];
        
        Test.startTest();
        
        RC_PortalController.saveFair(testFair.Id);
        
        Test.stopTest();
    }
    
    @isTest static void unitTestForGetLeftMenu(){
        Contact testContact = [SELECT Email, RC_Password__c FROM Contact LIMIT 1];
        RC_Fair__c testFair = [SELECT Id FROM RC_Fair__c WHERE RC_Related_Fair__c != null LIMIT 1];
        
        RC_PortalController.Login(testContact.Email, testContact.RC_Password__c);
        RC_PortalController.saveFair(testFair.Id);
        
        Test.startTest();
        
        RC_PortalController.InitWrapper result = RC_PortalController.GetLeftMenu();
        
        Test.stopTest();
    }
    
    @isTest static void unitTestForFairInit(){
        Test.startTest();
        
        RC_PortalController.InitWrapper failResult = RC_PortalController.FairInit();
        
        Contact testContact = [SELECT Email, RC_Password__c FROM Contact LIMIT 1];
        
        RC_PortalController.Login(testContact.Email, testContact.RC_Password__c);
        
        RC_PortalController.InitWrapper successResult = RC_PortalController.FairInit();
        
        Test.stopTest();
    }
    
    @isTest static void unitTestForFirmInit(){
        Test.startTest();
        
        RC_PortalController.InitWrapper failResult = RC_PortalController.FirmInit();
        
        Contact testContact = [SELECT Email, RC_Password__c FROM Contact LIMIT 1];
        
        RC_PortalController.Login(testContact.Email, testContact.RC_Password__c);
        
        RC_PortalController.InitWrapper successResult = RC_PortalController.FirmInit();
        
        Test.stopTest();
    }
    
    @isTest static void unitTestForFirmApproveSuccess(){
        Test.setMock(HttpCalloutMock.class, new RC_CommunityWorksMock());
        
        Account testAccount = [SELECT Id FROM Account LIMIT 1];
        
        RC_PortalController.AttachmentWrapper testAW = new RC_PortalController.AttachmentWrapper();
        testAW.Name = 'Test File Name';
        testAW.Body = 'Test Body';
        testAW.BodyLength = testAW.Body.length();
        
        Test.startTest();
        
        Boolean successResult = RC_PortalController.FirmApprove(JSON.serialize(testAccount), JSON.serialize(new List<RC_PortalController.AttachmentWrapper>{testAW}));
        
        Test.stopTest();
    }
    
    @isTest static void unitTestForFirmApproveOthers(){
        Test.setMock(HttpCalloutMock.class, new RC_CommunityWorksMock());
        
        Account testAccount = [SELECT Id FROM Account LIMIT 1];
        
        RC_PortalController.AttachmentWrapper testAW = new RC_PortalController.AttachmentWrapper();
        testAW.Name = 'Test File Name';
        testAW.Body = 'Test Body';
        testAW.BodyLength = testAW.Body.length();
        
        Test.startTest();
        
        Boolean accountMissingResult = RC_PortalController.FirmApprove('', '');
        Boolean attachmentMissingResult = RC_PortalController.FirmApprove(JSON.serialize(testAccount), '');
        Boolean failResult = RC_PortalController.FirmApprove('test', '');
        
        Test.stopTest();
    }
    
    @isTest static void unitTestForStandInit(){   
        Test.startTest();
        
        RC_PortalController.InitWrapper exceptionResult = RC_PortalController.StandInit();
        
        Contact testContact = [SELECT Email, RC_Password__c FROM Contact LIMIT 1];
        RC_Fair__c testFair = [SELECT Id FROM RC_Fair__c WHERE RC_Related_Fair__c != null LIMIT 1];
        
        RC_PortalController.Login(testContact.Email, testContact.RC_Password__c);
        RC_PortalController.saveFair(testFair.Id);
        
        RC_PortalController.InitWrapper successResult = RC_PortalController.StandInit();
        
        Test.stopTest();
    }
    
    @isTest static void unitTestForStandApproveOthers(){  
        Contact testContact = [SELECT Email, RC_Password__c FROM Contact LIMIT 1];
        RC_Fair__c testFair = [SELECT Id FROM RC_Fair__c WHERE RC_Related_Fair__c != null LIMIT 1];
        
        Test.startTest();        
        
        Boolean failResult = RC_PortalController.StandApprove('test', '');
        
        RC_PortalController.Login(testContact.Email, testContact.RC_Password__c);
        RC_PortalController.saveFair(testFair.Id);
        
        Boolean accountMissingResult = RC_PortalController.StandApprove('', '');
        Boolean attachmentMissingResult = RC_PortalController.StandApprove('ZCK Design Company', '');
        
        Test.stopTest();
    }
    
    @isTest static void unitTestForStandApproveMissingDesignSuccess(){      
        Test.setMock(HttpCalloutMock.class, new RC_CommunityWorksMock());
        
        Contact testContact = [SELECT Email, RC_Password__c FROM Contact LIMIT 1];
        RC_Fair__c testFair = [SELECT Id FROM RC_Fair__c WHERE RC_Related_Fair__c != null LIMIT 1];
        
        RC_PortalController.Login(testContact.Email, testContact.RC_Password__c);
        RC_PortalController.saveFair(testFair.Id);
        
        RC_PortalController.AttachmentWrapper testAW = new RC_PortalController.AttachmentWrapper();
        testAW.Name = 'Test File Name';
        testAW.Body = 'Test Body';
        testAW.BodyLength = testAW.Body.length();
        
        Test.startTest();
        
        Boolean successResult = RC_PortalController.StandApprove('', JSON.serialize(new List<RC_PortalController.AttachmentWrapper>{testAW}));
        
        Test.stopTest();
    }
    
    @isTest static void unitTestForStandApproveMissingAttachmentSuccess(){      
        Test.setMock(HttpCalloutMock.class, new RC_CommunityWorksMock());
        
        Contact testContact = [SELECT Email, RC_Password__c FROM Contact LIMIT 1];
        RC_Fair__c testFair = [SELECT Id FROM RC_Fair__c WHERE RC_Related_Fair__c != null LIMIT 1];
        
        RC_PortalController.Login(testContact.Email, testContact.RC_Password__c);
        RC_PortalController.saveFair(testFair.Id);
        
        RC_PortalController.AttachmentWrapper testAW = new RC_PortalController.AttachmentWrapper();
        testAW.Name = 'Test File Name';
        testAW.Body = 'Test Body';
        testAW.BodyLength = testAW.Body.length();
        
        Test.startTest();
        
        Boolean successResult = RC_PortalController.StandApprove('ZCK Desing Company', '');
        
        Test.stopTest();
    }
    
    @isTest static void unitTestForStandContactsInit(){
        Contact testContact = [SELECT Id, Email, RC_Password__c FROM Contact LIMIT 1];
        RC_Fair__c testFair = [SELECT Id FROM RC_Fair__c WHERE RC_Related_Fair__c != null LIMIT 1];
        
        Test.startTest();
        
        RC_PortalController.InitWrapper exceptionResult = RC_PortalController.StandContactsInit(testContact.Id);   
        
        RC_PortalController.Login(testContact.Email, testContact.RC_Password__c);
        RC_PortalController.saveFair(testFair.Id);        
        
        RC_PortalController.InitWrapper successResult = RC_PortalController.StandContactsInit(testContact.Id);       
        
        Test.stopTest();
    }
    
    @isTest static void unitTestForInitAgreement(){
        Contact testContact = [SELECT Id, Email, RC_Password__c FROM Contact LIMIT 1];
        
        Test.startTest();
        
        RC_PortalController.InitWrapper emptySessionResult = RC_PortalController.InitAgreement();
        
        RC_PortalController.Login(testContact.Email, testContact.RC_Password__c);
        
        RC_PortalController.InitWrapper successResult = RC_PortalController.InitAgreement();
        
        Test.stopTest();
    }
    
    @isTest static void unitTestForApproveAgreementFail(){
        Contact testContact = [SELECT Id, Email, RC_Password__c FROM Contact LIMIT 1];
        
        Test.startTest();
        
        RC_PortalController.InitWrapper emptySessionResult = RC_PortalController.ApproveAgreement();
        
        RC_PortalController.Login(testContact.Email, testContact.RC_Password__c);
        
        RC_PortalController.InitWrapper successResult = RC_PortalController.ApproveAgreement();
        
        Test.stopTest();
    }
    
    @isTest static void unitTestForApproveAgreementSuccess(){
        Test.setMock(HttpCalloutMock.class, new RC_CommunityWorksMock());
        
        Contact testContact = [SELECT Id, Email, RC_Password__c FROM Contact LIMIT 1];
        
        Test.startTest();
        
        RC_PortalController.InitWrapper emptySessionResult = RC_PortalController.ApproveAgreement();
        
        RC_PortalController.Login(testContact.Email, testContact.RC_Password__c);
        
        RC_PortalController.InitWrapper successResult = RC_PortalController.ApproveAgreement();
        
        Test.stopTest();
    }
    
    @isTest static void unitTestForCompanyEmployeeInit(){        
        Contact testContact = [SELECT Id, Email, RC_Password__c FROM Contact LIMIT 1];
        
        Test.startTest();
        
        RC_PortalController.InitWrapper emptySessionResult = RC_PortalController.CompanyEmployeeInit(testContact.Id);
        
        RC_PortalController.Login(testContact.Email, testContact.RC_Password__c);
        
        RC_PortalController.InitWrapper successResult = RC_PortalController.CompanyEmployeeInit(testContact.Id);
        
        Test.stopTest();
    }
    
    @isTest static void unitTestForDeleteEmployee(){
        Contact testContact = [SELECT Id, Email, RC_Password__c FROM Contact LIMIT 1];
        
        Test.startTest();
        
        RC_PortalController.deleteEmployee(testContact.Id);
        
        Test.setMock(HttpCalloutMock.class, new RC_CommunityWorksMock());
        
        RC_PortalController.deleteEmployee(JSON.serialize(testContact));
        
        Test.stopTest();
    }
    
    @isTest static void unitTestForAddContact(){        
        Contact testContact = [SELECT Id, Email, RC_Password__c FROM Contact LIMIT 1];
        
        Test.startTest();
        
        RC_PortalController.CustomContact customTestContact = new RC_PortalController.CustomContact();
        customTestContact.FirstName = 'New Contact FirstName';
        customTestContact.ContactType = 'STAND';
        customTestContact.Email = 'newTestEmail@outlook.com';
        customTestContact.LastName = 'New Cotact LastName';
        customTestContact.MobilePhone = '5384544772';
        customTestContact.Title = 'Developer';
        
        RC_PortalController.addContact(JSON.serialize(customTestContact));
        
        Test.stopTest();
    }
    
     @isTest static void unitTestForAddContactSuccess(){ 
        Test.setMock(HttpCalloutMock.class, new RC_CommunityWorksMock());

        Contact testContact = [SELECT Id, Email, RC_Password__c FROM Contact LIMIT 1];
        
        Test.startTest();
        
        RC_PortalController.CustomContact customTestContact = new RC_PortalController.CustomContact();
        customTestContact.FirstName = 'New Contact FirstName';
        customTestContact.ContactType = 'STAND';
        customTestContact.Email = 'newTestEmail@outlook.com';
        customTestContact.LastName = 'New Cotact LastName';
        customTestContact.MobilePhone = '5384544772';
        customTestContact.Title = 'Developer';
        
        RC_PortalController.Login(testContact.Email, testContact.RC_Password__c);        
        
        RC_PortalController.addContact(JSON.serialize(customTestContact));
        
        Test.stopTest();
    }
    
    @isTest static void unitTestForCatalogueInit(){        
        Contact testContact = [SELECT Id, Email, RC_Password__c FROM Contact LIMIT 1];
        RC_Fair__c testFair = [SELECT Id FROM RC_Fair__c WHERE RC_Related_Fair__c != null LIMIT 1];        
        
        Test.startTest();        
        
        RC_PortalController.InitWrapper emptyValueResult = RC_PortalController.CatalogueInit();   
        
        RC_PortalController.saveFair(testFair.Id);        
        
        RC_PortalController.InitWrapper exceptionResult = RC_PortalController.CatalogueInit();           
        
        RC_PortalController.Login(testContact.Email, testContact.RC_Password__c);
        
        RC_PortalController.InitWrapper successResult = RC_PortalController.CatalogueInit();   
        
        Test.stopTest();
    }
    
    @isTest static void unitTestForGetSubSectorList(){
        Test.startTest();
        
        RC_Value_Set__c testMainSector = [SELECT Id FROM RC_Value_Set__c WHERE RC_Type__c = 'Sector' LIMIT 1];
        
        RC_PortalController.Sectors result = RC_PortalController.getSubSectorList(testMainSector.Id);
        
        Test.stopTest();
    }
    
    @isTest static void unitTestForGetProductGroupList(){
        Test.startTest();
        
        RC_Value_Set__c testSubSector = [SELECT Id FROM RC_Value_Set__c WHERE RC_Type__c = 'Sub Sector' LIMIT 1];
        
        List<RC_PortalController.SelectOptionWrapper> result = RC_PortalController.getProductGroupList(testSubSector.Id);
        
        Test.stopTest();
    }
    
    @isTest static void unitTestForCatalogueApproveMissingAttachment(){
        Contact testContact = [SELECT Id, Email, RC_Password__c FROM Contact LIMIT 1];
        RC_Fair__c testFair = [SELECT Id FROM RC_Fair__c WHERE RC_Related_Fair__c != null LIMIT 1]; 
        Account testAccount = [SELECT Id FROM Account LIMIT 1];
        
        List<RC_Value_Set__c> valueSetList = [SELECT Id, RC_Type__c FROM RC_Value_Set__c];
        List<RC_PortalController.SectorWrapper> testSWList = getTestSectorList();
        
        RC_PortalController.saveFair(testFair.Id);        
        
        Test.startTest();    
        
        Test.setMock(HttpCalloutMock.class, new RC_CommunityWorksMock());        
        
        Boolean successResult = RC_PortalController.CatalogueApprove(
            '', '', '', JSON.serialize(testSWList), testContact.Id); 
        
        Test.stopTest();
    }
    
    @isTest static void unitTestForCatalogueApprove(){
        Contact testContact = [SELECT Id, Email, RC_Password__c FROM Contact LIMIT 1];
        RC_Fair__c testFair = [SELECT Id FROM RC_Fair__c WHERE RC_Related_Fair__c != null LIMIT 1]; 
        Account testAccount = [SELECT Id FROM Account LIMIT 1];
        
        RC_PortalController.AttachmentWrapper testAW = new RC_PortalController.AttachmentWrapper();
        testAW.Name = 'Test File Name';
        testAW.Body = 'Test Body';
        testAW.BodyLength = testAW.Body.length();
        
        List<RC_Value_Set__c> valueSetList = [SELECT Id, RC_Type__c FROM RC_Value_Set__c];
        List<RC_PortalController.SectorWrapper> testSWList = getTestSectorList();
        
        RC_PortalController.Login(testContact.Email, testContact.RC_Password__c);
        RC_PortalController.saveFair(testFair.Id);        
        
        Test.startTest();    
        
        Test.setMock(HttpCalloutMock.class, new RC_CommunityWorksMock());        
        
        Boolean successResult = RC_PortalController.CatalogueApprove(
            JSON.serialize(new List<RC_PortalController.AttachmentWrapper>{testAW}), '', JSON.serialize(testAccount), JSON.serialize(testSWList), testContact.Id); 
        
        Test.stopTest();
    }
    
    @isTest static void unitTestForBadgeInit(){        
        Contact testContact = [SELECT Id, Email, RC_Password__c FROM Contact LIMIT 1];
        RC_Fair__c testFair = [SELECT Id FROM RC_Fair__c WHERE RC_Related_Fair__c != null LIMIT 1]; 
        
        Test.startTest();
        
        RC_PortalController.InitWrapper emptyValueResult = RC_PortalController.BadgeInit();
        
        RC_PortalController.Login(testContact.Email, testContact.RC_Password__c);
        RC_PortalController.saveFair(testFair.Id);        
        
        RC_PortalController.InitWrapper successResult = RC_PortalController.BadgeInit();
        
        Test.stopTest();
    }
    
    @isTest static void unitTestForInsertBadgeEmptySession(){
        RC_Exhbitor_Badges__c testExhibitorBadges = new RC_Exhbitor_Badges__c(
            RC_FullName__c = 'Test Badge',
            RC_Title__c = 'Test Badge Title'
        );
        
        Test.startTest();
        
        RC_PortalController.InsertBadge(JSON.serialize(testExhibitorBadges));
        
        Test.stopTest();
    }
    
    @isTest static void unitTestForInsertBadgeException(){
        Contact testContact = [SELECT Id, Email, RC_Password__c FROM Contact LIMIT 1];
        RC_Fair__c testFair = [SELECT Id FROM RC_Fair__c WHERE RC_Related_Fair__c != null LIMIT 1]; 
        
        RC_Exhbitor_Badges__c testExhibitorBadges = new RC_Exhbitor_Badges__c(
            RC_FullName__c = 'Test Badge',
            RC_Title__c = 'Test Badge Title'
        );
        
        Test.startTest();
        
        RC_PortalController.Login(testContact.Email, testContact.RC_Password__c);
        RC_PortalController.saveFair(testFair.Id);  
        
        RC_PortalController.InsertBadge(JSON.serialize(testExhibitorBadges));
        
        Test.stopTest();
    }
    
    @isTest static void unitTestForInsertBadgeSuccess(){
        Test.setMock(HttpCalloutMock.class, new RC_CommunityWorksMock());   
        
        Contact testContact = [SELECT Id, Email, RC_Password__c FROM Contact LIMIT 1];
        RC_Fair__c testFair = [SELECT Id FROM RC_Fair__c WHERE RC_Related_Fair__c != null LIMIT 1]; 
        
        RC_Exhbitor_Badges__c testExhibitorBadges = new RC_Exhbitor_Badges__c(
            RC_FullName__c = 'Test Badge',
            RC_Title__c = 'Test Badge Title'
        );
        
        Test.startTest();
        
        RC_PortalController.Login(testContact.Email, testContact.RC_Password__c);
        RC_PortalController.saveFair(testFair.Id);  
        
        RC_PortalController.InsertBadge(JSON.serialize(testExhibitorBadges));    
        
        Test.stopTest();
    }
    
    @isTest static void unitTestForDeleteBadge(){
        Test.setMock(HttpCalloutMock.class, new RC_CommunityWorksMock());   
        
        Contact testContact = [SELECT Id, Email, RC_Password__c FROM Contact LIMIT 1];
        RC_Fair__c testFair = [SELECT Id FROM RC_Fair__c WHERE RC_Related_Fair__c != null LIMIT 1]; 
        
        RC_Exhbitor_Badges__c testExhibitorBadges = [SELECT Id FROM RC_Exhbitor_Badges__c LIMIT 1]; 
        
        Test.startTest();
        
        RC_PortalController.Login(testContact.Email, testContact.RC_Password__c);
        RC_PortalController.saveFair(testFair.Id);  
        
        RC_PortalController.deleteBadge(JSON.serialize(testExhibitorBadges));    
        
        Test.stopTest();
    }    
    
    @isTest static void unitTestForDeleteBadgeException(){
        Test.setMock(HttpCalloutMock.class, new RC_CommunityWorksMock());   
        
        Contact testContact = [SELECT Id, Email, RC_Password__c FROM Contact LIMIT 1];
        RC_Fair__c testFair = [SELECT Id FROM RC_Fair__c WHERE RC_Related_Fair__c != null LIMIT 1]; 
        
        Test.startTest();
        
        RC_PortalController.Login(testContact.Email, testContact.RC_Password__c);
        RC_PortalController.saveFair(testFair.Id);  
        
        RC_PortalController.deleteBadge('test');    
        
        Test.stopTest();
    }
    
    @isTest static void unitTestForGetBadges(){
        Test.setMock(HttpCalloutMock.class, new RC_CommunityWorksMock());   
        
        Contact testContact = [SELECT Id, Email, RC_Password__c FROM Contact LIMIT 1];
        RC_Fair__c testFair = [SELECT Id FROM RC_Fair__c WHERE RC_Related_Fair__c != null LIMIT 1]; 
        
        List<RC_Exhbitor_Badges__c> badgeList = [SELECT Id, Account__r.Name, Account__r.RC_Email__c, Account__r.RC_Portal_Country__c, RC_FullName__c FROM RC_Exhbitor_Badges__c];
        
        Test.startTest();
        
        RC_PortalController.Login(testContact.Email, testContact.RC_Password__c);
        RC_PortalController.saveFair(testFair.Id);          
        
        RC_PortalController.InitWrapper successResult = RC_PortalController.getBadges(JSON.serialize(badgeList));
        
        Test.stopTest();
    }
    
    @isTest static void unitTestForBadgePrintInit(){
        Contact testContact = [SELECT Id, Email, RC_Password__c FROM Contact LIMIT 1];
        RC_Fair__c testFair = [SELECT Id FROM RC_Fair__c WHERE RC_Related_Fair__c != null LIMIT 1]; 
        
        Test.startTest();
        
        RC_PortalController.InitWrapper emptySessionResult = RC_PortalController.BadgePrintInit();
        
        RC_PortalController.Login(testContact.Email, testContact.RC_Password__c);
        RC_PortalController.saveFair(testFair.Id);      
        RC_PortalController.InitWrapper successResult = RC_PortalController.BadgePrintInit();
        
        Test.stopTest();
    }
    
    @isTest static void unitTestForInvitationInit(){
        Contact testContact = [SELECT Id, Email, RC_Password__c FROM Contact LIMIT 1];
        RC_Fair__c testFair = [SELECT Id FROM RC_Fair__c WHERE RC_Related_Fair__c != null LIMIT 1]; 
        
        Test.startTest();
        
        RC_PortalController.InitWrapper emptySessionResult = RC_PortalController.invitationInit();
        
        RC_PortalController.Login(testContact.Email, testContact.RC_Password__c);
        RC_PortalController.saveFair(testFair.Id);      
        
        
        RC_PortalController.InitWrapper successResult = RC_PortalController.invitationInit();
        
        Test.stopTest();
    }
    
    @isTest static void unitTestForSendInvitationEmail(){
        RC_InvitationServices.SendEmail('zckanil@aysegul.com', 'aysegul', 'test account', '2', 'test fuar', '01.01.2020', '01.02.2020', 'hellö', 'hellö');
        RC_InvitationServices.SendEmail('', 'aysegul', 'test account', '2', 'test fuar', '01.01.2020', '01.02.2020', 'hellö', 'hellö');
    }
    
    @isTest static void unitTestForInsertInvitation(){
        Contact testContact = [SELECT Id, Email, RC_Password__c FROM Contact LIMIT 1];
        RC_Fair__c testFair = [SELECT Id FROM RC_Fair__c WHERE RC_Related_Fair__c != null LIMIT 1]; 
        Account testAccount = [SELECT Id FROM Account LIMIT 1];
        
        RC_Invitation__c testInvitation = new RC_Invitation__c(
            Account__c = testAccount.Id,
            RC_Reserved__c = '1'
        );
        Test.startTest();        
        
        Test.setMock(WebServiceMock.class, new RC_PortalWorksMock());
        
        RC_PortalController.Login(testContact.Email, testContact.RC_Password__c);
        RC_PortalController.saveFair(testFair.Id);              
        
        RC_PortalController.InsertInvitation(JSON.serialize(testInvitation));
        
        Test.stopTest(); 
    }
    
    @isTest static void unitTestForDeleteInvitation(){
        RC_Invitation__c testInvitation = [SELECT Id FROM RC_Invitation__c LIMIT 1];
        
        Test.startTest();
        
        RC_PortalController.deleteInvitation(JSON.serialize(testInvitation));
        
        Test.setMock(HttpCalloutMock.class, new RC_CommunityWorksMock()); 
        
        RC_PortalController.deleteInvitation(JSON.serialize(testInvitation));
        
        Test.stopTest(); 
    }
    
    private static List<RC_PortalController.SectorWrapper> getTestSectorList(){
        List<RC_PortalController.SectorWrapper> testSWList = new List<RC_PortalController.SectorWrapper>();        
        RC_PortalController.SectorWrapper testSW = new RC_PortalController.SectorWrapper();
        
        for(RC_Value_Set__c vs : [SELECT Id, RC_Type__c FROM RC_Value_Set__c]){
            if(vs.RC_Type__c == 'Sector')                
                testSW.MainSector = vs.Id;
            else if(vs.RC_Type__c == 'Sub Sector')
                testSW.SubSector = vs.Id;
            else if(vs.RC_Type__c == 'Product Group')
                testSW.ProductGroup = vs.Id;
        }        
        testSW.Type = 'Interested';
        
        testSWList.add(testSW);
        
        return testSWList;
    }
    
    @isTest static void testHttpPost() {
        // prepare test-data
        
        //As Per Best Practice it is important to instantiate the Rest Context
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/RC_CommunityWorks'; //Request URL
        req.httpMethod = 'POST';
        
        Map<String,Object>  reqBody = new Map<String,Object>();
        reqBody.put('Parameters',null);
        reqBody.put('ActionName','GetCurrency');
         
        req.requestBody = Blob.valueOf(JSON.serialize(reqBody));
        RestContext.request = req;
        RestContext.response= res;
        
        Test.startTest();
        String actual = RC_CommunityWorks.CallRequest(); //_HttpClass.updateCustomObject();
        Test.stopTest();
        
        //System.assertEquals(null, actual, 'Value is incorrect');
    }
}