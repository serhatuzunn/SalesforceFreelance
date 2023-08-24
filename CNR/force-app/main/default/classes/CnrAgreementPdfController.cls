public class CnrAgreementPdfController {
    
    ApexPages.StandardController controller;
    public Opportunity o {get;set;}
    public Opportunity opp {get;set;}
    public Account acc  {get;set;}
    public Contact contact  {get;set;}
    public List<OpportunityLineItem> lineItems {get;set;}
    public List<RC_Payment_Plan__c> payments {get;set;}
    public List<OpportunityContactRole> role {get;set;}
    public decimal KDV {get;set;}
    public decimal DAMGA {get;set;}
    public decimal ENTERENCE {get;set;}
    public string ENTERENCEDisplay {get;set;}
    public decimal GENELTOPLAM {get;Set;}
    public decimal PAYMENTGENELTOPLAM {get;Set;}
    public string numberToWord {get;Set;}
    public string temsilci {get;Set;}
    public string imgSrc {get;set;}
    public Blob imgBlob {get;set;}
    public string rulesTR {get;set;}
    public decimal exchangeRateAmount {get;set;}
    public string accountName {get;Set;}
    public id oppFairId {get;set;}
    public string customISOCode {get;Set;}
    public string customISOCodeForPayment {get;Set;}
    public boolean isDomestic {get;set;}
    public string isShowNumberToWord {get;set;}
    
    public CnrAgreementPdfController(ApexPages.StandardController c) {
        
        controller = c;
        o          = (Opportunity) c.getRecord(); 
        if(o.Id == null){
            return;
        }
        
        system.debug('o ::' + o.id);
        opp = [SELECT Id, RC_Agreement_Date__c, IsDeleted, AccountId, Name, Description, StageName, Amount, Probability, CloseDate, Type, NextStep, LeadSource, IsClosed, IsWon, ForecastCategory, ForecastCategoryName, CurrencyIsoCode,
               CampaignId, HasOpportunityLineItem, Pricebook2Id, OwnerId, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastActivityDate, FiscalQuarter, FiscalYear, Fiscal, ContactId,
               LastViewedDate, LastReferencedDate, SyncedQuoteId, ContractId, HasOpenActivity, HasOverdueTask, Budget_Confirmed__c, Discovery_Completed__c, ROI_Analysis_Completed__c, Loss_Reason__c, RC_Fair__c, RC_Country__c,
               RC_Fair_Team__c, RC_User_Check__c, RC_Assossiation__c, RC_Subtotal__c, RC_Discount__c, RC_User__c, RC_Tag__c, RC_Average_Maturity_Days__c, RC_Average_Maturity_Date__c, RC_Number_of_Installments__c, RC_Agency__c,
               RC_Sales_Organisation__c, RC_Bonus__c, RC_Submitted_for_Approval__c, RC_Hall__c, RC_Stand__c, RC_KVKK_Approval__c, RC_Owner_Check__c, RC_Calculated_Maturity_Days__c, RC_Agreement_Advance_Payment__c, RC_Main_Agreement__c,
               RC_Stand_Design_Company__c, RC_Entrance_Fee__c, RC_CRM_Id__c, RC_LogoKey__c, RC_Final_Total__c, RC_Tax_Amount__c, RC_Stamp_Duty__c,RC_Agreement_Number__c ,
               RC_Fair__r.RC_Agreement_Rules_TR__c, RC_Fair__r.RC_Agreement_Rules_EN__c, RC_Fair__r.RC_Agreement_Text_TR__c, RC_Fair__r.RC_Agreement_Text_EN__c,
               RC_Fair__r.RC_TR_Logo_ID__c, RC_Agreement_Exchange_Rate__c, RC_USD_Currency_Rate_of_Agreement_Date__c, Agreement_Date_Exchange_Rate__c
               FROM Opportunity 
               WHERE id = :o.id];
        
        if(opp.RC_Sales_Organisation__c != Null){
            if(opp.RC_Sales_Organisation__c == 'Domestic'){
                isDomestic = true;
                isShowNumberToWord = 'display:grid';
            }else{
                isShowNumberToWord = 'display:none';
                isDomestic = false;
            }
        }
        
        oppFairId = opp.RC_Fair__c;
        List<RC_Fair__c> cnrFirm = [SELECT RC_CNR_Firm__r.Name FROM RC_Fair__c WHERE id =:oppFairId];
        if(cnrFirm.size() > 0 && cnrFirm.get(0).RC_CNR_Firm__r!=null){
            accountName = cnrFirm.get(0).RC_CNR_Firm__r.Name.toLowerCase();
        }
        
        system.debug('accountName : ' + accountName);
        
        List<ContentVersion> asdas =  [SELECT Id, VersionData, ContentDocumentId FROM ContentVersion WHERE ContentDocumentId =: opp.RC_Fair__r.RC_TR_Logo_ID__c];
        
        if(asdas.size() > 0){
            imgBlob = asdas[0].VersionData;
            imgSrc = '/sfc/servlet.shepherd/version/download/' +asdas[0].id+ '?operationContext=S1';
            
        }else{
            imgSrc = 'empty';
        }
        
        if(Apexpages.currentPage() != null){
            String myGeneratedFileName =string.valueOf(opp.RC_Agreement_Number__c);
            Apexpages.currentPage().getHeaders().put('content-disposition', 'inline; filename='+myGeneratedFilename+'.pdf'); 
        }
        
        User usr = [SELECT Name FROM User WHERE id =: opp.OwnerId limit 1];
        temsilci = usr.Name.toUpperCase('tr');
        
        acc = [SELECT Id, IsDeleted, MasterRecordId, Name, Type, ParentId, BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry, BillingLatitude, BillingLongitude, BillingGeocodeAccuracy,
               BillingAddress, ShippingStreet, ShippingCity, ShippingState, ShippingPostalCode, ShippingCountry, ShippingLatitude, ShippingLongitude, ShippingGeocodeAccuracy, ShippingAddress, Phone, Fax,
               Website, PhotoUrl, Industry, NumberOfEmployees, Description, CurrencyIsoCode, OwnerId, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastActivityDate, LastViewedDate,
               LastReferencedDate, Jigsaw, JigsawCompanyId, AccountSource, SicDesc, RC_Account_Commercial_Type__c, RC_Email__c, RC_Tax_Number__c, RC_Tax_Office__c, RC_Commercial_Register_Number__c, RC_Mersis_Number__c,
               RC_Member_of_an_Association__c, RC_Old_Address__c, RC_Source_Date__c, RC_Score__c, RC_Transfer_Date__c, RC_LogoKey__c, RC_Transfer_Source__c, RC_Sector__c, RC_Sub_Sector__c, RC_Product_Group__c, RC_Domestic__c,
               RC_Mobile__c, RC_Country__c, Account_Profile__c, RC_Linkedin__c, RC_E_mail_Domain__c, RC_NACE_Code__c
               FROM Account
               WHERE Id =: opp.AccountId limit 1];
        
        role = [SELECT Id, OpportunityId, ContactId, Role, IsPrimary, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, IsDeleted, CurrencyIsoCode 
                FROM OpportunityContactRole
                WHERE OpportunityId =: opp.id 
                AND IsPrimary=true];
        if(role.size()>0)
            contact = [SELECT Id, IsDeleted, MasterRecordId, AccountId, LastName, FirstName, Salutation, MiddleName, Suffix, Name, MailingStreet, MailingCity, MailingState, MailingPostalCode, MailingCountry, MailingLatitude, MailingLongitude, MailingGeocodeAccuracy, MailingAddress, Phone, Fax, MobilePhone, ReportsToId, Email, Title, Department, CurrencyIsoCode, OwnerId, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastActivityDate, LastCURequestDate, LastCUUpdateDate, LastViewedDate, LastReferencedDate, EmailBouncedReason, EmailBouncedDate, IsEmailBounced, PhotoUrl, Jigsaw, JigsawContactId, IndividualId, RC_Password__c, RC_TOKEN__c, RC_Primary__c 
                       FROM Contact
                       WHERE id =:role[0].ContactId];
        
        lineItems = new List<OpportunityLineItem>();
        lineItems = [SELECT Id, OpportunityId, opportunity.RC_Discounted_M2_Unit_Price__c, SortOrder, PricebookEntryId, Product2Id, ProductCode,Product2.Name, Name, CurrencyIsoCode, Quantity, Discount, Subtotal, TotalPrice, UnitPrice, ListPrice, ServiceDate, Description, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, IsDeleted, RC_Net_Price__c 
                     FROM OpportunityLineItem WHERE OpportunityId=:o.id];
        
        payments = [SELECT Id, IsDeleted, Name, CurrencyIsoCode, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastActivityDate, RC_Payment_Date__c, RC_Payment_Amount__c, RC_Installment__c, RC_Payment_Type__c, RC_Active__c, RC_Agreement__c, RC_Main_Plan__c 
                    ,RC_Currency_Rate__c FROM RC_Payment_Plan__c WHERE RC_Agreement__c =: o.id AND RC_Active__c = true ORDER BY RC_Installment__c ASC];
        
        DateTime dT = opp.CreatedDate;
        Date myDate = date.newinstance(dT.year(), dT.month(), dT.day());
        system.debug('myDate :' + myDate);
        
        //Decimal curRate = payments[0].RC_Currency_Rate__c; // direk payment plan üzerinden de çekebiliriz.
        //Decimal curRate = RC_PaymentPlanController.getCurrencyRate(opp.CurrencyIsoCode,myDate);
        //system.debug('curRate :' + curRate);
        exchangeRateAmount = 0.0;
        PAYMENTGENELTOPLAM = 0.0;
        
        for(RC_Payment_Plan__c x : payments){
            PAYMENTGENELTOPLAM += x.RC_Payment_Amount__c;
            /*if(opp.CurrencyIsoCode != 'TRY'){
if(x.RC_Installment__c == 1 && curRate != null){
exchangeRateAmount = curRate * x.RC_Payment_Amount__c;
customISOCodeForPayment = x.CurrencyIsoCode;
}
}*/
        }
        /*
for(RC_Payment_Plan__c x : payments){
if(isDomestic){
customISOCodeForPayment = 'TL';
if(curRate != null){
PAYMENTGENELTOPLAM += (curRate * x.RC_Payment_Amount__c);
x.RC_Payment_Amount__c = (curRate * x.RC_Payment_Amount__c);
}
}else{
customISOCodeForPayment = opp.CurrencyIsoCode;
PAYMENTGENELTOPLAM += x.RC_Payment_Amount__c;
}
}*/
        
        system.debug('opp.CurrencyIsoCode ::' + opp.CurrencyIsoCode);
        system.debug('opp.RC_Agreement_Exchange_Rate__c ::' + opp.RC_Agreement_Exchange_Rate__c);
        
        /*if(isDomestic){
customISOCode = 'TL';
if(curRate != null){
if(lineItems.size() > 0){
for(OpportunityLineItem i : lineItems){
i.UnitPrice  = (i.UnitPrice  * curRate).setScale(2);
i.TotalPrice = i.TotalPrice * curRate;
}
opp.Amount = opp.Amount * curRate;

ENTERENCE = opp.RC_Entrance_Fee__c * curRate;

if(ENTERENCE > 0){
ENTERENCEDisplay = 'display:grid';
}else{
ENTERENCEDisplay = 'display:none';
}
KDV = opp.RC_Tax_Amount__c * curRate;
DAMGA = opp.RC_Stamp_Duty__c * curRate;

GENELTOPLAM = 0.0;

if(opp.Amount != null){
GENELTOPLAM += opp.Amount ;
}
if(opp.RC_Tax_Amount__c != null){
GENELTOPLAM += KDV;
}
if(opp.RC_Stamp_Duty__c != null){
GENELTOPLAM += DAMGA;
}
if(opp.RC_Entrance_Fee__c != null){
GENELTOPLAM += ENTERENCE;
}

numberToWord = NumberToWordTR.english_number(integer.valueOf(GENELTOPLAM));
}
}
}else{*/
        system.debug('ELSE');
        customISOCode= opp.CurrencyIsoCode;
        ENTERENCE = opp.RC_Entrance_Fee__c;
        
        if(ENTERENCE > 0){
            ENTERENCEDisplay = 'display:grid';
        }else{
            ENTERENCEDisplay = 'display:none';
        }
        KDV = opp.RC_Tax_Amount__c;
        DAMGA = opp.RC_Stamp_Duty__c;
        
        GENELTOPLAM = 0.0;
        
        system.debug('1 :' + opp.Amount + '2 :'  + opp.RC_Tax_Amount__c + '3 :'  + opp.RC_Stamp_Duty__c + '4 :'  + opp.RC_Entrance_Fee__c);
        if(opp.Amount != null){
            GENELTOPLAM += opp.Amount;
        }
        if(opp.RC_Tax_Amount__c != null){
            GENELTOPLAM += opp.RC_Tax_Amount__c;
        }
        if(opp.RC_Stamp_Duty__c != null){
            GENELTOPLAM += opp.RC_Stamp_Duty__c;
        }
        if(opp.RC_Entrance_Fee__c != null){
            GENELTOPLAM += opp.RC_Entrance_Fee__c;
        }
        
        String value = String.valueOf(geneltoplam);
        system.debug('String Val : ' + value);
        List<String> splittedValue = value.contains('.') ? value.split('\\.') : value.split('\\,');
        
        system.debug('splittedValue : ' + splittedValue);
        
        numberToWOrd    = '';
        for(Integer i = 0; i < splittedValue.size(); i++){
            String val = splittedValue.get(i);
            String convertedVal = '';
            if(i == 1){
                val = val.length() >= 2 ? val.left(2) : val;
                convertedVal = NumberToWordTR.english_number(integer.valueOf(val));
            }
            else
                convertedVal = NumberToWordTR.english_number(integer.valueOf(val));
            
            if(convertedVal != 'Sıfır'){
                numberToWord += convertedVal;
                
                if(i == 1){
                    if(customISOCode == 'TRY')				
                        numberToWord += 'Krş'; 
                    else if(customISOCode == 'USD')				
                        numberToWord += 'Cent';     
                    if(customISOCode == 'EUR')				
                        numberToWord += 'Cent';                        
                }
                else{
                    if(customISOCode == 'TRY')	
                        numberToWord += 'TL';
                    else if(customISOCode == 'USD')				
                        numberToWord += 'Dolar';     
                    if(customISOCode == 'EUR')				
                        numberToWord += 'Euro'; 
                }                
            }           
        }
        
        //numberToWord = NumberToWordTR.english_number(integer.valueOf(GENELTOPLAM));
        
        //}
        
    }
    
    public PageReference savePdf(){   
        
        Attachment attach = new Attachment();
        PageReference thePDF = Page.CnrAgreementPdfView;
        string oppId = o.id;
        
        
        if(Test.isRunningTest()){
            oppId = opp.Id;
        }
        
        thePDF.getParameters().put('id',oppId);
        thePDF.setRedirect(true);
        
        if(!Test.isRunningTest())
        {
            SaveContentDoc(thePDF.getContentAsPDF(),'TR');
        }
        else
        {
            SaveContentDoc(Blob.valueOf('UNIT.TEST'),'TR');
            
        }
        return controller.view();
    }
    
    public PageReference savePdfInternational(){   
        
        Attachment attach = new Attachment();
        PageReference thePDF = Page.CnrAgreementPdfInternationalView;
        string oppId = o.id;
        
        if(Test.isRunningTest()){
            oppId=opp.Id;
        }
        
        thePDF.getParameters().put('id',oppId);
        thePDF.setRedirect(true);
        
        if(!Test.isRunningTest())
        {
            SaveContentDoc(thePDF.getContentAsPDF(),'ENG');
        }
        else
        {
            SaveContentDoc(Blob.valueOf('UNIT.TEST'),'ENG');
            
        }
        
        return controller.view();
    }
    
    public void SaveContentDoc(Blob contentDoc,string type){
        try{
            string oppId = o.id;
            system.debug('oppId:::' + oppId);
            ContentVersion contentVersion_1 = new ContentVersion(
                Title = type + '-' + opp.Name + '.pdf',
                VersionData = contentDoc, 
                origin = 'H',
                PathOnClient = opp.Name+ '-' + type +'.pdf'
            );
            
            Database.SaveResult sr = Database.insert(contentVersion_1);  
            if (sr.isSuccess() == true) {
                if(!Test.isRunningTest())
                {
                    system.debug('hello');
                    ContentVersion contentVersion_2 = [SELECT Id, Title, ContentDocumentId FROM ContentVersion
                                                       WHERE Id = :sr.getId() LIMIT 1];
                    system.debug('contentVersion_1.Id:' + contentVersion_1.Id);
                    system.debug('contentVersion_2: ' + contentVersion_2);
                    ContentDocumentLink contentlink = new ContentDocumentLink();
                    contentlink.LinkedEntityId = oppId;
                    contentlink.contentdocumentid = contentVersion_2.contentdocumentid;
                    contentlink.ShareType = 'V';
                    contentlink.Visibility = 'AllUsers';
                    insert contentlink; 
                }
            }
            else{
                system.debug('excep');
            }
        }
        catch(DMLException e){
            system.debug('exception :' + e.getMessage());
        }
    }
}