public without sharing class RC_PortalController {
    
    public class InitWrapper {    
        @AuraEnabled
        public List<CustomFairs> fairList{get;set;}
        @AuraEnabled
        public RC_Fair__c fair{get;set;}
        @AuraEnabled
        public Account account {get;set;}
        @AuraEnabled
        public List<RC_Exhbitor_Badges__c> badges {get;set;}
        @AuraEnabled
        public List<RC_Invitation__c> invitations {get;set;}
        @AuraEnabled
        public List<RC_Related_Sector__c> relatedSectors {get;set;}
        @AuraEnabled
        public Opportunity opportunity {get;set;}
        @AuraEnabled
        public String document {get;set;}
        @AuraEnabled
        public Attachment attachment {get;set;}
        @AuraEnabled
        public List<SelectOption> accountProfile {get;set;}
        @AuraEnabled
        public List<Contact> contacts {get;set;}
        @AuraEnabled
        public List<SelectOptionWrapper> contactList {get;set;}
        @AuraEnabled
        public List<SelectOptionWrapper> AccountTypes {get;set;}
        @AuraEnabled
        public List<SelectOptionWrapper> country {get;set;}    
        @AuraEnabled
        public List<SelectOptionWrapper> city {get;set;}  
        @AuraEnabled
        public Sectors Sector{get;set;}
        @AuraEnabled
        public List<SelectOptionWrapper> ProductGroupList{get;set;}
        @AuraEnabled
        public List<SelectOptionWrapper> TypeList{get;set;}
        @AuraEnabled
        public boolean isLogon {get;set;}
        @AuraEnabled
        public List<SelectOptionWrapper> StandDesignCompanyList {get;set;}
        @AuraEnabled
        public String contactPhone {get;set;}
    }
    public class LoginResult {    
        @AuraEnabled
        public String ResultCode{get;set;}
        @AuraEnabled
        public String ResultMessage{get;set;}
        @AuraEnabled
        public String UserId{get;set;}
        @AuraEnabled
        public boolean IsAgree{get;set;}
    }
    public class SelectOptionWrapper{
        @AuraEnabled
        public String label {get;set;}
        @AuraEnabled
        public String value {get;set;}
        @AuraEnabled
        public String selected {get;set;}
    }
    public class AttachmentWrapper {    
        @AuraEnabled
        public String Name{get;set;}
        @AuraEnabled
        public String Body{get;set;}
        @AuraEnabled
        public String ContentType{get;set;}
        @AuraEnabled
        public Decimal BodyLength{get;set;}
        @AuraEnabled
        public Id ParentId{get;set;}
        @AuraEnabled
        public String Description {get;set;}
    }    
    public class Sectors{
        @AuraEnabled
        public List<SelectOptionWrapper> sectorList{get;set;}
        @AuraEnabled
        public List<SelectOptionWrapper> subSectorList{get;set;}
    }
    public class CustomContact {    
        @AuraEnabled
        public String FirstName{get;set;}
        @AuraEnabled
        public String LastName{get;set;}
        @AuraEnabled
        public String Title{get;set;}
        @AuraEnabled
        public String Email{get;set;}
        @AuraEnabled
        public String MobilePhone{get;set;}
        @AuraEnabled
        public String ContactType{get;set;}
    }   
    public class selectedSectors{
        @AuraEnabled
        public String Id{get;set;}
        @AuraEnabled
        public String Name{get;set;}
        @AuraEnabled
        public String Type{get;set;}
    }
    public class SectorWrapper{
        @AuraEnabled
        public String MainSector{get;set;}
        @AuraEnabled
        public String SubSector{get;set;}
        @AuraEnabled
        public String ProductGroup{get;set;}
        @AuraEnabled
        public String Type{get;set;}
    }
    public class BrandWrapper{
        @AuraEnabled
        public String Id {get;set;}
        @AuraEnabled
        public String Tyoe {get;set;}
        @AuraEnabled
        public String Label {get;set;}
        @AuraEnabled
        public String IconName {get;set;}
    }
    
    //LOGIN OPERATIONS
    @AuraEnabled
    public static LoginResult Login(string email,string password){
        system.debug('Login fired. params : '+email+' '+password);
        try{
            LoginResult result = new LoginResult();
            List<Contact> findContact = [SELECT Id, RC_Password__c, AccountId, RC_IsAgree__c FROM Contact WHERE Email=:email AND IsDeleted=:false];
            system.debug('Contact : ' + findContact);
            if(findContact.size() > 0){
                if(findContact[0].RC_Password__c == password){
                    result.ResultCode = '1';
                    result.ResultMessage = 'Başarılı.';
                    result.IsAgree = findContact[0].RC_IsAgree__c;
                    //Session
                    RC_CacheDefaultPartion.putSession('contactId',findContact[0].Id);
                    RC_CacheDefaultPartion.putSession('accountId',findContact[0].AccountId);
                    return result;
                }
                else{
                    result.ResultCode = '0';
                    result.ResultMessage = 'Girilen şifre yanlış.';
                    return result;
                }
            }
            else{
                result.ResultCode = '0';
                result.ResultMessage = 'Girilen email ile kullanıcı bulunamadı.';
                return result;
            } 
        }
        catch(Exception ex){
            system.debug('Login exception : '+ ex.getMessage());
            return null;
        }
    }
    
    @AuraEnabled
    public static LoginResult resetPasswordMail(String email, String lang){
        system.debug('resetPasswordMail fired. params : '+email);
        try{
            LoginResult result = new LoginResult();
            List<Contact> findContact=[SELECT Id, FirstName, LastName, Phone, Email,RC_Password__c,RC_TOKEN__c FROM Contact WHERE Email=:email AND IsDeleted=:false];
            system.debug('findContact'+findContact);
            if(findContact.size() > 0){
                String token = createToken();
                System.debug('token : '+token);
                findContact[0].RC_TOKEN__c=token;                
                List<Contact> Lcontact = new List<Contact>();
                Lcontact.add(findContact[0]);
                Map<String, Object> mapData = new Map<String, Object>();
                mapData.put('contact', Lcontact);
                string sr = RC_ExtensionHelper.CallRequest('updateContact', mapData);
                system.debug('sr:'+sr);
                //Database.SaveResult sr = (Database.SaveResult)JSON.deserialize(jsonResponse, Database.SaveResult.class);
                if(String.isNotBlank(sr)) {
                    boolean isSend= SendEmail(findContact[0].Email,findContact[0].RC_TOKEN__c,lang);
                    System.debug('isSend : '+isSend);
                    if(isSend==true){
                        result.ResultCode='1';
                        result.ResultMessage='Şifre yenileme linki mail adresinize gönderildi.';
                    }
                    else{
                        System.debug('Mail Gönderilemedi : '+isSend);
                        result.ResultCode='0';
                        result.ResultMessage='Hata oluştu.';
                    }
                }
                else{
                    System.debug('Database update edilemedi : '+sr);
                    result.ResultCode='0';
                    result.ResultMessage='Hata oluştu.';
                }
            }
            else{
                result.ResultCode='0';
                result.ResultMessage='Girilen email ile kullanıcı bulunamadı.';
            }
            return result;
        }
        catch(Exception ex){
            system.debug('resetPasswordMail exception : '+ ex.getMessage());
            return null;
        }
    }
    
    @AuraEnabled
    public static LoginResult resetPassword(String password, String repassword, String token){
        system.debug('resetPassword fired. params : '+password+' '+ token);
        try{
            LoginResult result = new LoginResult();
            if(String.isNotEmpty(token)){
                if(password==repassword){
                    List<Contact> findContactList=[SELECT Id,RC_Password__c,RC_TOKEN__c FROM Contact WHERE RC_TOKEN__c=:token AND IsDeleted=:false LIMIT 1];
                    if(findContactList.size() == 1){
                        Contact findContact = findContactList.get(0);
                        findContact.RC_Password__c=password;
                        findContact.RC_TOKEN__c=null;
                        Map<String, Object> mapData = new Map<String, Object>();
                        List<Contact> Lcontact = new List<Contact>();
                        Lcontact.add(findContact);
                        mapData.put('contact', Lcontact);
                        String sr = RC_ExtensionHelper.CallRequest('updateContact', mapData); 
                        if(String.isNotBlank(sr)) {
                            result.ResultCode='1';
                            result.ResultMessage='Şifre yenilendi.';
                        }
                    }
                    else{
                        result.ResultCode='0';
                        result.ResultMessage='Yeni bir şifre yenileme talebi bulunmuyor. Login sayfasından yeni talepte bulunabilirsiniz. ';
                    }
                }
                else{
                    result.ResultCode='0';
                    result.ResultMessage='Girilen şifreler eşleşmiyor. Lütfen kontrol edin. ';
                }
            }
            else{
                result.ResultCode='-1';
            }
            
            return result;
        }
        catch(Exception ex){
            system.debug('resetPassword exception : '+ ex.getMessage());
            return null;
        }
    }
    
    public static String createToken(){
        Blob b = Crypto.GenerateAESKey(128);
        String h = EncodingUtil.ConvertTohex(b);
        String guid = h.SubString(0,8)+ '-' + h.SubString(8,12) + '-' + h.SubString(12,16) + '-' + h.SubString(16,20) + '-' + h.substring(20);
        return guid;
    }
    
    public static boolean SendEmail(String email, String token, String lang) {
        try{
            String link=Label.CnrPortalLink + '/s/resetpassword?token=' + token +'&' + lang;
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.toAddresses = new String[] { email };
                message.optOutPolicy = 'FILTER';
            message.setCharset('UTF-8');
            message.subject = 'Şifre Sıfırlama';
            message.plainTextBody = 'Linke tıklayarak yeni şifre oluşturabilirsiniz. '+link;
            Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
                Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
            if (results[0].success) {
                System.debug('The email was sent successfully.');
                return true;
            } 
            else {
                System.debug('The email failed to send: '+ results[0].errors[0].message);
                return false;
            }
        }
        catch(Exception ex){
            system.debug('SendEmail exception : '+ ex.getMessage());
            return false;
        }
    }
    //END LOGIN OPERATIONS
    
    //LEFT MENU    
    @AuraEnabled
    public static void saveFair(String fairId){
        RC_CacheDefaultPartion.putSession('fairId',fairId);
    }
    
    @AuraEnabled
    public static InitWrapper GetLeftMenu(){
        system.debug('GetLeftMenu fired.');
        try{
            InitWrapper initConfig=new InitWrapper();
            String fairId = RC_CacheDefaultPartion.getSession('fairId');
            String accountId = RC_CacheDefaultPartion.getSession('accountId');
            if (!String.isBlank(fairId) || !String.isBlank(accountId)) {
                Opportunity opportunity = [SELECT Name, RC_Stand__c, RC_Hall__c FROM Opportunity Where AccountId=:accountId and RC_Fair__c=:fairId LIMIT 1];
                system.debug('opportunity : ' + opportunity);
                initConfig.opportunity = opportunity;
                RC_Fair__c fair = [SELECT Id, Name, RC_Start_Date__c, RC_End_Date__c,RC_TR_Logo_ID__c FROM RC_Fair__c Where Id=:fairId LIMIT 1];
                system.debug('fair : ' + fair);
                initConfig.fair = fair;
                if (fair.RC_TR_Logo_ID__c != null){
                    ContentVersion document = [SELECT Id, VersionData, ContentDocumentId FROM ContentVersion WHERE ContentDocumentId =: fair.RC_TR_Logo_ID__c];   
                    system.debug('document : '+document);
                    //initConfig.document='/sfc/servlet.shepherd/version/download/' +document.Id+ '?operationContext=S1';
                    initConfig.document = 'data:image/png;base64, ' + EncodingUtil.base64Encode(document.VersionData);
                    
                }
                initConfig.isLogon=true;
            }
            else{
                initConfig.isLogon=false;
            }
            return initConfig;
        }
        catch(Exception ex){
            system.debug('GetLeftMenu exception : '+ ex.getMessage());
            return null;
        }
    }
    //END LEFT MENU 
    
    //FAIR   
    public class CustomFairs{
        @AuraEnabled
        public Id Id {get;set;}
        @AuraEnabled
        public string Name {get;set;}
        @AuraEnabled
        public date StartDate {get;set;}
        @AuraEnabled
        public date EndDate {get;set;}
        @AuraEnabled
        public string LogoId {get;set;}
        @AuraEnabled
        public string LogoSrc {get;set;}
    } 
    @AuraEnabled
    public static InitWrapper FairInit(){
        system.debug('FairInit fired.');
        try{
            InitWrapper initConfig=new InitWrapper();
            String session = RC_CacheDefaultPartion.getSession('accountId');
            system.debug('session:'+session);
            if (!String.isBlank(session)) {
                List<Opportunity> opportinities = [SELECT Id, RC_Fair__r.Id,RC_Fair__r.Name, RC_Fair__r.RC_Start_Date__c, RC_Fair__r.RC_End_Date__c,RC_Fair__r.RC_TR_Logo_ID__c FROM Opportunity Where AccountId=:session and RC_Fair__r.RC_End_Date__c >: Date.today()];
                
                Map<String,CustomFairs> contentMap = new Map<String,CustomFairs>();
                List<string> LogoIds = new List<string>();
                for(Opportunity op : opportinities){
                    system.debug('op:'+op);
                    CustomFairs fair = new CustomFairs();
                    fair.Id = op.RC_Fair__r.Id;
                    fair.Name = op.RC_Fair__r.Name;
                    fair.StartDate=op.RC_Fair__r.RC_Start_Date__c;
                    fair.EndDate = op.RC_Fair__r.RC_End_Date__c;
                    fair.LogoId= op.RC_Fair__r.RC_TR_Logo_ID__c;       
                    fair.LogoSrc = 'empty';
                    LogoIds.add(fair.LogoId);
                    contentMap.put(fair.LogoId, fair);
                }                
                List<ContentVersion> contents =  [SELECT Id, VersionData, ContentDocumentId FROM ContentVersion WHERE ContentDocumentId IN: LogoIds];
                for(ContentVersion content : contents){ 
                    CustomFairs fair = contentMap.get(content.ContentDocumentId);
                    //fair.LogoSrc = '/sfc/servlet.shepherd/version/download/' +content.Id+ '?operationContext=S1';  
                    fair.LogoSrc = 'data:image/png;base64, ' +EncodingUtil.base64Encode(content.VersionData);
                     
                }
                system.debug('contentMap.values();'+contentMap.values());
                initConfig.fairList=contentMap.values();
                system.debug('initConfig.fairList:'+initConfig.fairList);
                initConfig.isLogon=true;
            }
            else{
                initConfig.isLogon=false;
            }
            return initConfig;
        }
        catch(Exception ex){
            system.debug('FairInit exception : '+ ex.getMessage());
            return null;
        }
    }
    //END FAIR
    
    //FIRM INFORMATION  
    @AuraEnabled
    public static InitWrapper FirmInit(){
        system.debug('FirmInit fired.'); 
        try{
            InitWrapper initConfig = new InitWrapper();
            String session = RC_CacheDefaultPartion.getSession('accountId');
            String fairId = RC_CacheDefaultPartion.getSession('fairId');
            system.debug('Firm Info session : ' + session);
            system.debug('Firm Info fairId : ' + fairId);
            if (!String.isBlank(session)){
                List<Opportunity> oppList = [SELECT Id, AccountId, RC_Primary_Contact__c, RC_Primary_Contact__r.Phone FROM Opportunity WHERE AccountId=:session AND RC_Fair__c=:fairId LIMIT 1];
                if(oppList.size() > 0){
                    initConfig.contactPhone = oppList[0].RC_Primary_Contact__r.Phone;
                }
                Account acct = [SELECT Id, BillingPostalCode, BillingAddress, BillingStreet, RC_Country__c, RC_Portal_Country__c, RC_City_Info__c, BillingCity, Phone, Fax, Website, RC_Email__c, RC_Tax_Number__c, RC_Tax_Office__c, RC_Mersis_Number__c, Type, Name FROM Account Where Id=:session];
                system.debug('Account : ' + acct);        
                initConfig.account = acct;
                initConfig.country = getCountryList(acct.RC_Portal_Country__c);
                initConfig.city = getCityList(acct.RC_City_Info__c);
                initConfig.attachment = new Attachment();
                initConfig.AccountTypes = getAccountTypeList(acct.Type);
                initConfig.isLogon = true;
            }
            else{
                initConfig.isLogon=false;
            }  
            
            return initConfig;
        }
        catch(Exception ex){
            system.debug('FirmInit exception : '+ ex.getMessage());
            return null;
        }
    }
    
    @AuraEnabled
    public static boolean FirmApprove(String account, String attachmentFile){
        system.debug('FirmApprove fired params : '+account+' logo : '+ attachmentFile);
        try{
            if(!String.isBlank(account)){
                Account acct = (Account) JSON.deserialize(account, Account.class);
                system.debug('Account : '+acct);                
                Map<String, Object> mapDataA = new Map<String, Object>();
                mapDataA.put('account', acct);
                RC_ExtensionHelper.CallRequest('updateAccount', mapDataA);
                
                if(!String.isBlank(attachmentFile)){
                    List<AttachmentWrapper> firmAttachmentList = (List<AttachmentWrapper>)JSON.deserialize(attachmentFile, List<AttachmentWrapper>.class); 
                    for(AttachmentWrapper attch : firmAttachmentList){
                        attch.ParentId =acct.Id;
                        attch.Description ='Catalogue';
                    }
                    Map<String, Object> mapData = new Map<String, Object>();
                    mapData.put('attachment', firmAttachmentList);
                    RC_ExtensionHelper.CallRequest('insertAttachment', mapData);                 
                }
                return true;
            }
            return false;
        }
        catch (Exception ex) {
            system.debug('FirmApprove exception : '+ ex.getMessage());
            return false;
        }
    }
    
    public static List<SelectOptionWrapper> getAccountTypeList(String selected){
        List<SelectOptionWrapper> TypeList = new List<SelectOptionWrapper>();
        SelectOptionWrapper opt = new SelectOptionWrapper();
        Schema.DescribeFieldResult fieldResult = Account.Type.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            opt = new SelectOptionWrapper();
            opt.label = pickListVal.getLabel();
            opt.value = pickListVal.getValue();
            if(opt.value == selected) opt.selected = opt.value;
            TypeList.add(opt);
        }
        return TypeList;
    }
    
    public static List<SelectOptionWrapper> getCountryList(String selected){
        List<SelectOptionWrapper> countryList = new List<SelectOptionWrapper>();
        SelectOptionWrapper opt = new SelectOptionWrapper();
        Schema.DescribeFieldResult fieldResult = Account.RC_Portal_Country__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            opt = new SelectOptionWrapper();
            opt.label = pickListVal.getLabel();
            opt.value = pickListVal.getValue();
            if(opt.value == selected) opt.selected = opt.value;
            countryList.add(opt);
        }
        return countryList;
    }
    
    public static List<SelectOptionWrapper> getCityList(String selected){
        List<SelectOptionWrapper> cityList = new List<SelectOptionWrapper>();
        SelectOptionWrapper opt = new SelectOptionWrapper();
        Schema.DescribeFieldResult fieldResult = Account.RC_City_Info__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            opt = new SelectOptionWrapper();
            opt.label = pickListVal.getLabel();
            opt.value = pickListVal.getValue();
            if(opt.label == selected) opt.selected = opt.label;
            cityList.add(opt);
        }
        return cityList;
    }
    //END FIRM INFORMATION
    
    //STAND INFORMATION
    @AuraEnabled
    public static InitWrapper StandInit(){
        system.debug('StandInit fired.'); 
        try{
            InitWrapper initConfig=new InitWrapper();
            String session = RC_CacheDefaultPartion.getSession('accountId');
            system.debug('session : '+session);
            String fairId = RC_CacheDefaultPartion.getSession('fairId');
            system.debug('fairId : '+fairId);        
            
            if (!String.isBlank(session) && !String.isBlank(fairId)) {
                Opportunity opp = [SELECT Id, IsDeleted, AccountId, Name, Description, StageName, Amount, Probability, CloseDate, Type, NextStep, LeadSource, IsClosed, IsWon, ForecastCategory, 
                                   ForecastCategoryName, CurrencyIsoCode, CampaignId, HasOpportunityLineItem, Pricebook2Id, OwnerId, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, 
                                   SystemModstamp, LastActivityDate, FiscalQuarter, FiscalYear, Fiscal, ContactId, LastViewedDate, LastReferencedDate, SyncedQuoteId, ContractId, HasOpenActivity, 
                                   HasOverdueTask, Budget_Confirmed__c, Discovery_Completed__c, ROI_Analysis_Completed__c, Loss_Reason__c, RC_Fair__c, RC_Country__c, RC_Fair_Team__c, 
                                   RC_User_Check__c, RC_Assossiation__c, RC_Subtotal__c, RC_Discount__c, RC_User__c, RC_Tag__c, RC_Average_Maturity_Days__c, RC_Average_Maturity_Date__c, 
                                   RC_Number_of_Installments__c, RC_Sales_Organisation__c, RC_Bonus__c, RC_Submitted_for_Approval__c, RC_Hall__c, RC_Stand__c, RC_KVKK_Approval__c, RC_Owner_Check__c, 
                                   RC_Calculated_Maturity_Days__c, RC_Agreement_Advance_Payment__c, RC_Main_Agreement__c, RC_Stand_Design__c
                                   FROM Opportunity WHERE AccountId=:session AND RC_Fair__c=:fairId LIMIT 1];
                
                initConfig.opportunity = opp;
                initConfig.contacts = getContacts(session);
                initConfig.isLogon = true;
                //initConfig.StandDesignCompanyList = getStandDesignCompanyPickList(opp.RC_Stand_Design__c);
            }
            else{
                initConfig.isLogon = false;
            }
            return initConfig;
        }
        catch(Exception ex){
            system.debug('StandInit exception : '+ ex.getMessage());
            return null;
        }
    }

    /*
    public static List<SelectOptionWrapper> getStandDesignCompanyPickList(){        
        List<SelectOptionWrapper> result = new List<SelectOptionWrapper>();        
        SelectOptionWrapper opt = new SelectOptionWrapper();
        Schema.DescribeFieldResult fieldResult = RC_Value_Set__c.Stand_Design_Company__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){            
            opt = new SelectOptionWrapper();
            opt.label = pickListVal.getLabel();
            opt.value = pickListVal.getValue();
            result.add(opt);
        }             
        return result;
    }
    */
    @AuraEnabled
    public static boolean StandApprove(String selectedDesingCompany, string attachmentFiles){
        system.debug('StandApprove fired params : '+ 'selectedDesingCompany : '+ selectedDesingCompany + 'attachmentFiles : '+ attachmentFiles);
        try{
            if(!String.isBlank(selectedDesingCompany) || !String.isBlank(attachmentFiles)){
                String accountId = RC_CacheDefaultPartion.getSession('accountId');
                String fairId = RC_CacheDefaultPartion.getSession('fairId'); 
                Opportunity opp=[SELECT Id, IsDeleted, AccountId, Name, Description, StageName, Amount, Probability, CloseDate, Type, NextStep, LeadSource, IsClosed, IsWon, ForecastCategory, ForecastCategoryName, CurrencyIsoCode, CampaignId, HasOpportunityLineItem, Pricebook2Id, OwnerId, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastActivityDate, FiscalQuarter, FiscalYear, Fiscal, ContactId, LastViewedDate, LastReferencedDate, SyncedQuoteId, ContractId, HasOpenActivity, HasOverdueTask, Budget_Confirmed__c, Discovery_Completed__c, ROI_Analysis_Completed__c, Loss_Reason__c, RC_Fair__c, RC_Country__c, RC_Fair_Team__c, RC_User_Check__c, RC_Assossiation__c, RC_Subtotal__c, RC_Discount__c, RC_User__c, RC_Tag__c, RC_Average_Maturity_Days__c, RC_Average_Maturity_Date__c, RC_Number_of_Installments__c, RC_Sales_Organisation__c, RC_Bonus__c, RC_Submitted_for_Approval__c, RC_Hall__c, RC_Stand__c, RC_KVKK_Approval__c, RC_Owner_Check__c, RC_Calculated_Maturity_Days__c, RC_Agreement_Advance_Payment__c, RC_Main_Agreement__c
                                 FROM Opportunity
                                 WHERE AccountId=:accountId 
                                 AND   RC_Fair__c=:fairId LIMIT 1];
                if(!String.isBlank(selectedDesingCompany))
                {
                    opp.RC_Stand_Design__c = selectedDesingCompany;
                    Map<String, Object> mapData = new Map<String, Object>();
                    mapData.put('opportunity', opp);
                    RC_ExtensionHelper.CallRequest('updateOpportunity', mapData);
                    //update opp;
                }
                if(!String.isBlank(attachmentFiles)){
                    List<AttachmentWrapper> firmAttachmentList = (List<AttachmentWrapper>)JSON.deserialize(attachmentFiles, List<AttachmentWrapper>.class); 
                    for(AttachmentWrapper attch : firmAttachmentList){
                        attch.ParentId =opp.Id;
                        attch.Description ='Stand';
                    }
                    Map<String, Object> mapData = new Map<String, Object>();
                    mapData.put('attachment', firmAttachmentList);
                    RC_ExtensionHelper.CallRequest('insertAttachment', mapData);                 
                }
            }
            return true;
        }
        catch (Exception e) {
            system.debug('StandApprove exception : '+ e.getMessage());
            return false;
        }
    }
    
    @AuraEnabled
    public static InitWrapper StandContactsInit(String contactId){
        system.debug('CompanyEmployeeInit fired param: '+contactId);  
        try{
            InitWrapper initConfig=new InitWrapper();
            String accountId = RC_CacheDefaultPartion.getSession('accountId');
            String fairId = RC_CacheDefaultPartion.getSession('fairId');
            if(string.isNotBlank(accountId)){
                initConfig.contacts = [SELECT Id, AccountId, Title, Phone, Email, Name, RC_Primary__c FROM Contact Where AccountId=:accountId and RC_Contact_Type__c=:'STAND'];
                initConfig.isLogon = true;  
                if(string.isNotBlank(fairId))
                {
                    Opportunity opportunity = [SELECT Id, Name, RC_Stand__c, RC_Hall__c, RC_Stand_Design__c FROM Opportunity Where AccountId=:accountId and RC_Fair__c=:fairId LIMIT 1];
                    system.debug('opportunity : '+ opportunity);
                    initConfig.opportunity = opportunity;
                    initConfig.StandDesignCompanyList = getStandDesignCompanyPickList(opportunity.RC_Stand_Design__c);
                    
                    List<Attachment> atchList = [SELECT Name,Body, Id FROM Attachment WHERE Description = 'Stand' and ParentId =: opportunity.Id ORDER BY CreatedDate DESC LIMIT 1];
                    if(atchList.size() > 0)
                    {
                        initConfig.attachment = atchList.get(0);
                        initConfig.attachment.Description = EncodingUtil.base64Encode(atchList.get(0).Body);
                    }
                }
            }
            else{
                initConfig.isLogon=false;
            }
            return initConfig;
        }
        catch(Exception ex){
            system.debug('CompanyEmployeeInit exception : '+ ex.getMessage());
            return null;
        }
    }
    
    public static List<SelectOptionWrapper> getStandDesignCompanyPickList(String selected){
        List<SelectOptionWrapper> standList = new List<SelectOptionWrapper>();
        SelectOptionWrapper opt = new SelectOptionWrapper();
        Schema.DescribeFieldResult fieldResult = Opportunity.RC_Stand_Design__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry pickListVal : ple){
            opt = new SelectOptionWrapper();
            opt.label = pickListVal.getLabel();
            opt.value = pickListVal.getValue();
            system.debug('opt.label: ' + opt.label);
            system.debug('opt.value: ' + opt.value);
            if(opt.value == selected) opt.selected = opt.value;
            standList.add(opt);
        }
        return standList;
    } 
    //END STAND INFORMATION    
    
    //AGREEMENT
    @AuraEnabled
    public static InitWrapper initAgreement(){
        system.debug('initAggrement fired.');   
        try{
            InitWrapper initConfig=new InitWrapper();
            String session = RC_CacheDefaultPartion.getSession('accountId');
            system.debug('session:'+session);   
            if (!String.isBlank(session)) {
                initConfig.isLogon=true;
            }
            else{
                initConfig.isLogon=false;
            }
            return initConfig;
        }
        catch(Exception ex){
            system.debug('initAgreement exception : '+ ex.getMessage());
            return null;
        }
    }
    
    @AuraEnabled
    public static InitWrapper approveAgreement(){
        system.debug('approveAgreement fired.');   
        try{
            InitWrapper initConfig=new InitWrapper();
            String contactId = RC_CacheDefaultPartion.getSession('contactId');
            if (!String.isBlank(contactId)) {
                Contact contact = [Select Id,RC_IsAgree__c FROM Contact Where Id=:contactId LIMIT 1];
                contact.RC_IsAgree__c = true;
                List<Contact> contactList = new List<Contact>();
                contactList.add(contact);
                Map<String, Object> mapData = new Map<String, Object>();
                mapData.put('contact', contactList);
                RC_ExtensionHelper.CallRequest('updateContact', mapData);
                initConfig.isLogon=true;
            }
            else{
                initConfig.isLogon=false;
            }
            return initConfig;
        }
        catch(Exception ex){
            system.debug('initAgreement exception : '+ ex.getMessage());
            return null;
        }
    }
    
    //END AGREEMENT
    
    //COMPANY EMPLOYEE
    @AuraEnabled
    public static InitWrapper CompanyEmployeeInit(String contactId){
        system.debug('CompanyEmployeeInit fired param: '+contactId);  
        try{
            InitWrapper initConfig=new InitWrapper();
            String session = RC_CacheDefaultPartion.getSession('accountId');
            if(string.isNotBlank(session)){
                initConfig.contacts = getContacts(session);
                initConfig.isLogon=true;  
            }
            else{
                initConfig.isLogon=false;
            }
            return initConfig;
        }
        catch(Exception ex){
            system.debug('CompanyEmployeeInit exception : '+ ex.getMessage());
            return null;
        }
    }
    
    public static List<Contact> getContacts(String accountId){
        List<Contact> contacts = [SELECT Id, AccountId, Title, Phone, Email, Name, RC_Primary__c, MobilePhone FROM Contact Where AccountId=:accountId ORDER BY Id DESC];
        system.debug('Contact : '+contacts);
        return contacts;
    }
    
    @AuraEnabled
    public static void deleteEmployee(String row){
        system.debug('deleteEmployee fired param : '+row);
        try{
            if(!String.isBlank(row)){
                Contact contactId = (Contact) JSON.deserialize(row, Contact.class);
                Contact contact = [SELECT Id FROM Contact Where Id=:contactId.Id LIMIT 1];
                Map<String, Object> mapData = new Map<String, Object>();
                mapData.put('contact', contact);
                RC_ExtensionHelper.CallRequest('deleteContact', mapData);
                //delete contacts;
            }
        }
        catch(Exception ex){
            system.debug('deleteEmployee exception : '+ ex.getMessage());
        }
    }
    
    @AuraEnabled
    public static void addContact(String contact){
        system.debug('addContact fired param : '+contact);
        try{
            if(!String.isBlank(contact)){
                CustomContact newcontact = (CustomContact) JSON.deserialize(contact, CustomContact.class);
                String accountId = RC_CacheDefaultPartion.getSession('accountId');
                Contact ct = new Contact();
                ct.AccountId = accountId;
                ct.FirstName = newcontact.FirstName;
                ct.LastName = newcontact.LastName;
                ct.Title = newcontact.Title;
                ct.Email = newcontact.Email;
                ct.MobilePhone = newcontact.MobilePhone;
                ct.RC_Contact_Type__c = newcontact.ContactType;
                ct.Phone = newcontact.MobilePhone;
                Map<String, Object> mapData = new Map<String, Object>();
                mapData.put('contact', ct);
                RC_ExtensionHelper.CallRequest('insertContact', mapData);
            }
        }
        catch(Exception ex){
            system.debug('addContact exception : '+ ex.getMessage());
        }
    }
    //END COMPANY EMPLOYEE
    
    //CATALOGUE
    @AuraEnabled
    public static InitWrapper CatalogueInit(){
        system.debug('CatalogueInit fired.');  
        try{
            InitWrapper initConfig = new InitWrapper();
            String accountId = RC_CacheDefaultPartion.getSession('accountId');
            String fairId = RC_CacheDefaultPartion.getSession('fairId');
            
            if(string.isNotBlank(accountId) || string.isNotBlank(fairId)){
                List<Opportunity> oppList = [SELECT Id, AccountId, RC_Primary_Contact__c, RC_Primary_Contact__r.Phone FROM Opportunity WHERE AccountId=:accountId AND RC_Fair__c=:fairId LIMIT 1];
                if(oppList.size() > 0){
                    initConfig.contactPhone = oppList[0].RC_Primary_Contact__r.Phone;
                }
                Account acct = [SELECT Id, Name, RC_Firm_Info_TR__c, RC_Firm_Info_EN__c, Type, BillingAddress, RC_Email__c, Phone, Fax, RC_Brand__c FROM Account Where Id=:accountId];
                system.debug('Account : '+ acct);  
                List<RC_Related_Sector__c> sectors = [SELECT RC_Sector__c, RC_Sub_Sector__c, RC_Product_Group__c, RC_Product_Group__r.Name, RC_Type__c FROM RC_Related_Sector__c 
                                                      Where RC_Fair__c=:fairId and RC_Account__c=:accountId];
                List<Attachment> atchList = [SELECT Name,Body, Id FROM Attachment WHERE Description = 'Catalogue' and ParentId =: accountId ORDER BY CreatedDate DESC LIMIT 1];
                if(atchList.size() > 0)
                {
                    initConfig.attachment = atchList.get(0);
                    initConfig.attachment.Description = EncodingUtil.base64Encode(atchList.get(0).Body);
                }
                /*List<selectedSectors> sSectors = new List<selectedSectors>();
				foreach(RC_Related_Sector__c sec : sectors){
				RC_Value_Set__c de = [SELECT Id, Name FROM RC_Value_Set__c WHERE RC_Type__c =: sec.RC_Type__c];
				sSectors.add(new selectedSectors{sec.RC_Sector__c, sec.RC_Type__c});}*/
                
                system.debug('acct.RC_Brand__c: ' + acct.RC_Brand__c);
                initConfig.account = acct;
                initConfig.relatedSectors = sectors;
                initConfig.contactList = getContactPickList(accountId);
                initConfig.Sector = getSectorPickList();
                initConfig.isLogon = true;  
            }
            else{
                initConfig.isLogon=false;
            }
            return initConfig;
        }
        catch(Exception ex){
            system.debug('CatalogueInit exception : '+ ex.getMessage());
            return null;
        }
    }
    
    public static List<SelectOptionWrapper> getContactPickList(String session){
        List<SelectOptionWrapper> optList = new List<SelectOptionWrapper>();
        List<Contact> contacts = getContacts(session);
        for(Contact cnt : contacts){
            string selected = '';
            if(cnt.RC_Primary__c == true) selected = cnt.Name;
            SelectOptionWrapper opt = new SelectOptionWrapper();
            opt.label = cnt.Name;
            opt.value = cnt.Id;
            opt.selected=selected;
            optList.add(opt);
        }
        return optList;
    }
    
    public static Sectors getSectorPickList(){
        Sectors result = new Sectors();
        result.sectorList = new List<SelectOptionWrapper>();
        SelectOptionWrapper opt = new SelectOptionWrapper();
        //opt.label = '';
        //opt.value = '';
        //result.sectorList.add(opt);
        
        for(RC_Value_Set__c sector : [SELECT Id, Name FROM RC_Value_Set__c WHERE RC_Type__c = 'Sector' ORDER BY Name ASC] ){
            opt = new SelectOptionWrapper();
            opt.label = sector.Name;
            opt.value = sector.Id;
            result.sectorList.add(opt);
        }
        return result;
    }
    
    @AuraEnabled
    public static Sectors getSubSectorList(string selectedMainSector){
        system.debug('CatalogueInit fired param : '+ selectedMainSector);  
        try{
            Sectors result = new Sectors();
            result.subSectorList = new List<SelectOptionWrapper>();
            SelectOptionWrapper opt = new SelectOptionWrapper();
            //opt.label = '';
            //opt.value = '';
            //result.subSectorList.add(opt);
            for(RC_Value_Set__c subSector : [SELECT Id, Name FROM RC_Value_Set__c WHERE RC_Type__c = 'Sub Sector' AND RC_Sector__c =: selectedMainSector ORDER BY Name ASC] ){
                opt = new SelectOptionWrapper();
                opt.label = subSector.Name;
                opt.value = subSector.Id;
                result.subSectorList.add(opt);
            }
            return result;
        }
        catch(Exception ex){
            system.debug('getSubSectorList exception : '+ ex.getMessage());
            return null;
        }
    }
    
    @AuraEnabled
    public static List<SelectOptionWrapper> getProductGroupList(string selectedSubSector){      
        system.debug('getProductGroupList fired param : '+selectedSubSector);  
        try{
            List<SelectOptionWrapper> productGroupList = new List<SelectOptionWrapper>();
            SelectOptionWrapper opt = new SelectOptionWrapper();
            //opt.label = '';
            //opt.value = '';
            //productGroupList.add(opt);
            for(RC_Value_Set__c pGroup : [SELECT Id, Name FROM RC_Value_Set__c WHERE RC_Type__c = 'Product Group' AND RC_Sub_Sector__c =: selectedSubSector ORDER BY Name ASC] ){
                opt = new SelectOptionWrapper();
                opt.label = pGroup.Name;
                opt.value = pGroup.Id;
                productGroupList.add(opt);
            }
            return productGroupList;
        }        catch(Exception ex){
            system.debug('getProductGroupList exception : '+ ex.getMessage());
            return null;
        }
    }
    
    @AuraEnabled
    public static boolean CatalogueApprove(string attachmentFile, string brands, string account, string sectors, string contact){
        system.debug('CatalogueApprove fired.');
        try{
            String session = RC_CacheDefaultPartion.getSession('accountId');
            String fairId = RC_CacheDefaultPartion.getSession('fairId');
            //update account
            Account acct = null;
            if(String.isNotBlank(account)){                
                acct = (Account) JSON.deserialize(account, Account.class);
                Map<String, Object> mapData = new Map<String, Object>();
                mapData.put('account', acct);
                RC_ExtensionHelper.CallRequest('updateAccount', mapData);
            }
            //update acct;
            system.debug('update account : ' + acct);
            //Insert attachment
            if(!String.isBlank(attachmentFile)){
                List<AttachmentWrapper> firmAttachmentList = (List<AttachmentWrapper>)JSON.deserialize(attachmentFile, List<AttachmentWrapper>.class); 
                for(AttachmentWrapper attch : firmAttachmentList){
                    attch.ParentId =acct.Id;
                    attch.Description ='Catalogue';
                }
                Map<String, Object> mapDataAttch = new Map<String, Object>();
                mapDataAttch.put('attachment', firmAttachmentList);
                RC_ExtensionHelper.CallRequest('insertAttachment', mapDataAttch);                 
            }
            //to do : upsert brand
            //update contact
            system.debug('contact: ' + contact);
            List<Contact> getContacts = getContacts(session);
            for(Contact cnt : getContacts){
                system.debug('cnt: ' + cnt);
                system.debug('cnt.Id: ' + cnt.Id);
                cnt.MobilePhone = cnt.MobilePhone;
                if(contact == cnt.Id){
                    cnt.RC_Primary__c = true;
                }
                else{
                    cnt.RC_Primary__c = false;
                }
            }
            Map<String, Object> mapDataC = new Map<String, Object>();
            if(getContacts.size() > 0)
                mapDataC.put('contact', getContacts);
            
            if(mapDataC.keySet().size() > 0)
                RC_ExtensionHelper.CallRequest('updateContact', mapDataC);
            //update getContacts;
            //upsert sector
            system.debug('sectors : ' + sectors);
            SectorWrapper[] SectorList = (SectorWrapper[])JSON.deserialize(sectors,SectorWrapper[].class); 
            system.debug('SectorList : '+SectorList);
            if(SectorList.Size() > 0){
                List<RC_Related_Sector__c> Lsector = new List<RC_Related_Sector__c>();
                for(SectorWrapper sw : SectorList){
                    RC_Related_Sector__c sector = new RC_Related_Sector__c();
                    sector.RC_Fair__c = fairId;
                    sector.RC_Account__c = acct != null ? acct.Id : null;
                    sector.RC_Sector__c = sw.MainSector;
                    sector.RC_Sub_Sector__c = sw.SubSector;
                    sector.RC_Product_Group__c = sw.ProductGroup;
                    sector.RC_Type__c = sw.Type;
                    Lsector.add(sector);
                }
                Map<String, Object> mapDataS = new Map<String, Object>();
                mapDataS.put('sector', Lsector);
                RC_ExtensionHelper.CallRequest('insertSector', mapDataS);
                //insert Lsector;
                system.debug('upsert sector : ' + Lsector);
            }
            
            system.debug('CatalogueApprove brands: ' + brands);
            BrandWrapper[] BrandList = (BrandWrapper[])JSON.deserialize(brands, BrandWrapper[].class); 
            Account accBrand = [SELECT Id, RC_Brand__c FROM Account WHERE Id=:session LIMIT 1];
            system.debug('BrandList : ' + BrandList);
            
            if(accBrand.RC_Brand__c == null){
                accBrand.RC_Brand__c = '';
            }
            else{
                accBrand.RC_Brand__c = '';
                Map<String, Object> mapDataBrand = new Map<String, Object>();
                mapDataBrand.put('account', accBrand);
                RC_ExtensionHelper.CallRequest('updateAccount', mapDataBrand);
                system.debug('delete account brand : ' + accBrand);
            }
            
            if(BrandList.Size() > 0){
                for(BrandWrapper bw : BrandList){
                    accBrand.RC_Brand__c += bw.Label + ',';
                }
                accBrand.RC_Brand__c = accBrand.RC_Brand__c.substring(0, accBrand.RC_Brand__c.length()-1);
                Map<String, Object> mapDataBrand = new Map<String, Object>();
                mapDataBrand.put('account', accBrand);
                RC_ExtensionHelper.CallRequest('updateAccount', mapDataBrand);
                system.debug('insert account brand : ' + accBrand);
            }
            return true;
        }
        catch(Exception ex){
            system.debug('Login CatalogueApprove : ' + ex.getMessage());
            system.debug('Login CatalogueApprove Stacktrace' + ex.getStackTraceString());
            return null;
        }
    }
    //END CATALOGUE
    
    //BADGE
    @AuraEnabled
    public static InitWrapper BadgeInit(){
        system.debug('BadgeInit fired.');  
        try{
            InitWrapper initConfig=new InitWrapper();
            String accountId = RC_CacheDefaultPartion.getSession('accountId');
            String fairId = RC_CacheDefaultPartion.getSession('fairId');
            if(string.isNotBlank(accountId) && string.isNotBlank(fairId)){
                initConfig.badges = [SELECT RC_FullName__c, 
                                     RC_Title__c, 
                                     Account__r.Name, 
                                     Account__r.RC_Mobile__c, 
                                     Account__r.RC_Email__c, 
                                     Account__r.RC_Portal_Country__c              
                                     FROM RC_Exhbitor_Badges__c WHERE Account__c =: accountId and Fair__c =: fairId ORDER BY Name ASC];
                
                initConfig.isLogon = true;  
            }
            else{
                initConfig.isLogon=false;
            }
            return initConfig;
        }
        catch(Exception ex){
            system.debug('BadgeInit exception : '+ ex.getMessage());
            return null;
        }
    }
    
    @AuraEnabled
    public static void InsertBadge(String Badge){
        system.debug('InsertBadge fired.');  
        try{
            String accountId = RC_CacheDefaultPartion.getSession('accountId');
            String fairId = RC_CacheDefaultPartion.getSession('fairId');
            if(!String.isBlank(Badge) && !String.isBlank(accountId)){
                RC_Exhbitor_Badges__c newbadge = (RC_Exhbitor_Badges__c) JSON.deserialize(Badge, RC_Exhbitor_Badges__c.class);                
                RC_Exhbitor_Badges__c bdg = new RC_Exhbitor_Badges__c();
                bdg.Account__c=accountId;
                bdg.Fair__c=fairId;
                bdg.RC_FullName__c=newbadge.RC_FullName__c;
                bdg.RC_Title__c=newbadge.RC_Title__c;
                Map<String, Object> mapData = new Map<String, Object>();
                mapData.put('badge', bdg);
                RC_ExtensionHelper.CallRequest('insertBadge', mapData);
            }
        }
        catch(Exception ex){
            system.debug('InsertBadge exception : '+ ex.getMessage());
        }
    }
    
    @AuraEnabled
    public static void deleteBadge(String row){
        system.debug('deleteBadge fired param : '+row);
        try{
            if(!String.isBlank(row)){
                RC_Exhbitor_Badges__c badgeId = (RC_Exhbitor_Badges__c) JSON.deserialize(row, RC_Exhbitor_Badges__c.class);
                RC_Exhbitor_Badges__c badge = [SELECT Id FROM RC_Exhbitor_Badges__c Where Id=:badgeId.Id LIMIT 1];
                Map<String, Object> mapData = new Map<String, Object>();
                mapData.put('badge', badge);
                RC_ExtensionHelper.CallRequest('deleteBadge', mapData);
            }
        }
        catch(Exception ex){
            system.debug('deleteBadge exception : '+ ex.getMessage());
        }
    }
    
    public class ApiCustomer
    {
        @AuraEnabled
        public integer CustomerId { get; set; }
        @AuraEnabled
        public string CustomerCode { get; set; }
        @AuraEnabled
        public string Name { get; set; }
        @AuraEnabled
        public string SurName { get; set; }
        @AuraEnabled
        public string TCNumber { get; set; }
        @AuraEnabled
        public string CompanyName { get; set; }
        @AuraEnabled
        public string Mobile { get; set; }
        @AuraEnabled
        public string Phone { get; set; }
        @AuraEnabled
        public string Email { get; set; }
        @AuraEnabled
        public integer CountryId { get; set; }
        @AuraEnabled
        public integer CityId { get; set; }
        @AuraEnabled
        public integer CountyId { get; set; }
        @AuraEnabled
        public boolean IsForeign { get; set; }
        @AuraEnabled
        public string Address { get; set; }
        @AuraEnabled
        public DateTime CreateDate { get; set; }
        @AuraEnabled
        public integer CreateUserId { get; set; }
        @AuraEnabled
        public integer CreateLicenseId { get; set; }
        @AuraEnabled
        public boolean ActiveFlg { get; set; }
    }
    
    public class ApiBarcode
    {
        @AuraEnabled
        public integer BarcodeId { get; set; }
        @AuraEnabled
        public integer FairId { get; set; }
        @AuraEnabled
        public integer CustomerId { get; set; }
        @AuraEnabled
        public integer CustomerTypeId { get; set; }
        @AuraEnabled
        public integer CardId { get; set; }
        @AuraEnabled
        public integer TermId { get; set; }
        @AuraEnabled
        public integer WebId { get; set; }
        @AuraEnabled
        public integer ChannelId { get; set; }
        @AuraEnabled
        public integer FairCardId { get; set; }
        @AuraEnabled
        public integer FairDoorId { get; set; }
        @AuraEnabled
        public integer SeriId { get; set; }
        @AuraEnabled
        public string SeriNo { get; set; }
        @AuraEnabled
        public string Barcode { get; set; }
        @AuraEnabled
        public string PnrCode { get; set; }
        @AuraEnabled
        public string Receipt { get; set; }
        @AuraEnabled
        public DateTime CreateDate { get; set; }
        @AuraEnabled
        public integer CreateUserId { get; set; }
        @AuraEnabled
        public integer CreatLicenseId { get; set; }
        @AuraEnabled
        public boolean ActiveFlg { get; set; }
        @AuraEnabled
        public string PromotionCode { get; set; }
    }
    
    @AuraEnabled
    public static InitWrapper getBadges(String badges){
        system.debug('getBadges fired. badges:'+badges);  
        try{
            InitWrapper initConfig = new InitWrapper();
            String session = RC_CacheDefaultPartion.getSession('accountId');  
            String fairId = RC_CacheDefaultPartion.getSession('fairId');
            List<RC_Fair__c> fairList = new List<RC_Fair__c>();
            if(String.isNotBlank(fairId))
            {
                fairList = [SELECT ID,RC_Portal_Term_Id__c,RC_Related_Fair__r.RC_Portal_Web_Id__c FROM RC_Fair__c WHERE Id =:fairId LIMIT 1]; 
                
            }
            if(string.isNotBlank(session)){
                if(string.isNotBlank(badges)){
                    List<RC_Exhbitor_Badges__c> badgeList = (List<RC_Exhbitor_Badges__c>) JSON.deserialize(badges, List<RC_Exhbitor_Badges__c>.class);
                    for(RC_Exhbitor_Badges__c item : badgeList){
                        ApiCustomer apiCustomer = new ApiCustomer();
                        apiCustomer.CustomerId = 0;
                        apiCustomer.CustomerCode = createToken();
                        apiCustomer.Name = item.RC_FullName__c;
                        apiCustomer.SurName = '';
                        apiCustomer.TCNumber = '';
                        apiCustomer.CompanyName = item.Account__r.Name;
                        apiCustomer.Mobile = '';// item.Account__r.RC_Mobile__c;
                        apiCustomer.Email = item.Account__r.RC_Email__c; 
                        //apiCustomer.CountryId = 1;
                        apiCustomer.CountryId = Integer.valueOf(item.Account__r.RC_Portal_Country__c);
                        apiCustomer.CityId = 0;
                        apiCustomer.CountyId = 0;
                        apiCustomer.IsForeign = false;
                        apiCustomer.Address = '';
                        apiCustomer.CreateDate = Date.today();
                        apiCustomer.CreateUserId = 2;
                        apiCustomer.CreateLicenseId = 2;
                        apiCustomer.ActiveFlg = true;
                        
                        String mainWeb_id = '';
                        String web_id = '';
                        String term_id = '';
                        
                        //Ana fuar
                       /* if(item.Fair__r.RC_Related_Fair__c == null){
                            mainWeb_id = item.Fair__r.RC_Portal_Web_Id__c;
                            term_id = item.Fair__r.RC_Portal_Term_Id__c;
                        }*/
                        AddCustomerParser customer = CNRExpoIntegrator.AddCustomerRequest(JSON.serialize(apiCustomer)).get(0);
                        //web_id ='366'; //Nereden gelecek ?
//                        web_id = item.Fair__r.RC_Related_Fair__r.RC_Portal_Web_Id__c; fuar ayrıca alınmalı
                        if(fairList.size() > 0)
                        {
                            web_id = fairList.get(0).RC_Related_Fair__r.RC_Portal_Web_Id__c;
                            //term_id = fairList.get(0).RC_Portal_Term_Id__c;
                            system.debug('item: ' + item);
                            system.debug('item Fair : ' + item.Fair__c);
                            system.debug('item Related : ' + item.Fair__r.RC_Related_Fair__c);
                            system.debug('item RelatedWeb : ' + item.Fair__r.RC_Related_Fair__r.RC_Portal_Web_Id__c);
                        }
                        system.debug(web_id);
                        String licenseId = '2';
                        List<GetFairCardLicenseParser> cardLicenseList = CNRExpoIntegrator.GetFairCardLicenseRequest('/'+web_id+'/'+licenseId);///366/2
                        GetFairCardLicenseParser cardLicense = cardLicenseList.get(0); //IsPaid = false,IsForeign = false,CardName = 'Katılımcı',TermId=20
                        GetBarcodeParser getbarcode = CNRExpoIntegrator.GetBarcodeRequest('/'+cardLicense.FairId+'/'+cardLicense.TypeId+'/'+customer.CustomerId+'/'+cardLicense.TermId+'/'+cardLicense.LicenseId+'/'+2).get(0); //'/85/10/1208729/20/2/2'
                                                
                        String barcode = getbarcode.Barcode;
                        
                        //String year = String.valueOf(date.year());
                        //string year = String.valueOf(Date.year()).Substring(2, String.valueOf(Date.year()).Length - 2); //yıl
                        //string code = cardLicense.FairCode; //kodu
                        //string numeric = serviceForBadge.GetBarcodeByWebId(intWeb_id.ToString());
                        
                        //String SeriNo = year + code + "-" + numeric;
                        
                        ApiBarcode apiBarcode = new ApiBarcode();  
                        apiBarcode.BarcodeId = 0;
                        apiBarcode.FairId = cardLicense.FairId;
                        apiBarcode.CustomerId = customer.CustomerId;
                        apiBarcode.CustomerTypeId = cardLicense.TypeId;
                        apiBarcode.CardId = cardLicense.CardId;
                        apiBarcode.TermId = cardLicense.TermId;
                        apiBarcode.WebId = Integer.valueOf(web_id);
                        apiBarcode.ChannelId = 2;
                        apiBarcode.FairCardId = cardLicense.FairCardId;
                        apiBarcode.FairDoorId = cardLicense.FairDoorId;
                        apiBarcode.SeriId = 4;
                        apiBarcode.SeriNo = '';
                        apiBarcode.Barcode = barcode;
                        apiBarcode.Receipt = item.Id;
                        apiBarcode.PnrCode = item.Account__c;
                        apiBarcode.PromotionCode = '';
                        apiBarcode.CreateDate = Date.today();
                        apiBarcode.CreateUserId = 2;
                        apiBarcode.CreatLicenseId = cardLicense.LicenseId;
                        apiBarcode.ActiveFlg = true; 
                        system.debug('Barcode/Add Request: ' + JSON.serialize(apiBarcode));
                        //PARSE EDERKEN HATA ALIYOR NEDENİNİ ÇÖZEMEDİM
                        AddBarcodeParser addbarcode = CNRExpoIntegrator.AddBarcodeRequest(JSON.serialize(apiBarcode)).get(0);
                        if(addbarcode.BarcodeId > 0){
                            item.RC_Barcode__c= barcode;
                            item.RC_ISCreated__c = true;
                        }
                    }
                    
                    Map<String, Object> mapData = new Map<String, Object>();
                    mapData.put('badge', badgeList);
                    RC_ExtensionHelper.CallRequest('updateBadge', mapData);
                }
                initConfig.isLogon=true; 
            }
            else{
                initConfig.isLogon=false;
            }
            return initConfig;
        }
        catch(Exception ex){
            system.debug('getBadges exception : '+ ex.getMessage());
            system.debug('getBadges stacktrace : '+ ex.getStackTraceString());
            return null;
        }
    }    
    
    @AuraEnabled
    public static InitWrapper BadgePrintInit(){
        system.debug('BadgePrintInit fired.');  
        try{
            InitWrapper initConfig=new InitWrapper();
            String accountId = RC_CacheDefaultPartion.getSession('accountId');
            String fairId = RC_CacheDefaultPartion.getSession('fairId');
            if(string.isNotBlank(accountId) && string.isNotBlank(fairId)){
                initConfig.badges = [SELECT Fair__r.Name,RC_FullName__c,Account__r.Name,Account__r.RC_Country__c,RC_Barcode__c FROM RC_Exhbitor_Badges__c WHERE 
                                     Account__c =: accountId and Fair__c =: fairId ORDER BY Name ASC];
                initConfig.isLogon=true;  
            }
            else{
                initConfig.isLogon=false;
            }
            return initConfig;
        }
        catch(Exception ex){
            system.debug('BadgePrintInit exception : '+ ex.getMessage());
            return null;
        }
    }
    //END BADGE    
    
    //ONLINE INVITATION
    @AuraEnabled
    public static InitWrapper invitationInit(){
        system.debug('invitationInit fired.'); 
        InitWrapper initConfig=new InitWrapper();
        String accountId = RC_CacheDefaultPartion.getSession('accountId');
        if(string.isNotBlank(accountId)){
            initConfig.invitations = [SELECT RC_FullName__c,RC_Email__c,RC_Reserved__c FROM RC_Invitation__c WHERE Account__c =: accountId ORDER BY RC_FullName__c ASC];
            initConfig.isLogon=true;  
        }
        else{
            initConfig.isLogon=false;
        }
        return initConfig;
    }  
    
    @AuraEnabled
    public static void InsertInvitation(String Invitation){
        system.debug('InsertInvitation fired.');  
        try{
            String accountId = RC_CacheDefaultPartion.getSession('accountId');
            String fairId = RC_CacheDefaultPartion.getSession('fairId');
            List<RC_Fair__c> fairInfo = [SELECT Id,RC_Related_Fair__r.RC_Portal_User_Id__c, RC_Portal_User_Id__c, Name, RC_Start_Date__c, RC_End_Date__c FROM RC_Fair__c WHERE Id=:fairId];
            
            if(!String.isBlank(Invitation) && !String.isBlank(accountId)){
                RC_Invitation__c newInvitation = (RC_Invitation__c)JSON.deserialize(Invitation, RC_Invitation__c.class);
                system.debug('newInvitation: ' + newInvitation); 
                Account account = [SELECT Id, Name FROM Account where Id =:accountId LIMIT 1];  
                system.debug('account: ' + account); 
                if(fairInfo.size()> 0)
                {
                    String fairStartDate = String.valueOf(fairInfo[0].RC_Start_Date__c.day()) + '.' + String.valueOf(fairInfo[0].RC_Start_Date__c.month()) + '.' + String.valueOf(fairInfo[0].RC_Start_Date__c.Year());
                    String fairEndDate = String.valueOf(fairInfo[0].RC_End_Date__c.day()) + '.' + String.valueOf(fairInfo[0].RC_End_Date__c.month()) + '.' + String.valueOf(fairInfo[0].RC_End_Date__c.Year());
                    RC_InvitationServices.InsertInvitation(newInvitation, account, fairInfo[0].RC_Related_Fair__r.RC_Portal_User_Id__c, fairInfo[0].Name, fairStartDate, fairEndDate);
                }
            }
        }
        catch(Exception ex){
            system.debug('InsertInvitation exception : '+ ex.getMessage());
        }
    }
    
    @AuraEnabled
    public static void deleteInvitation(String row){
        system.debug('deleteInvitation fired param : '+row);
        try{
            if(!String.isBlank(row)){
                RC_Invitation__c invitationId = (RC_Invitation__c) JSON.deserialize(row, RC_Invitation__c.class);
                RC_Invitation__c invitation = [SELECT Id FROM RC_Invitation__c Where Id=:invitationId.Id LIMIT 1];
                Map<String, Object> mapData = new Map<String, Object>();
                mapData.put('invitation', invitation);
                RC_ExtensionHelper.CallRequest('deleteInvitation', mapData);
            }
        }
        catch(Exception ex){
            system.debug('deleteInvitation exception : '+ ex.getMessage());
        }
    }
    //END ONLINE INVITATION
}