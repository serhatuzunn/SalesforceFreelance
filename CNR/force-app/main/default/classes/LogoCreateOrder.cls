public class LogoCreateOrder {
    
    public static void Create(List<Id> oppIdList){
        List<Opportunity> oppList= new List<Opportunity>();
        if(oppIdList.size() > 0 ){
            for(Id oppId : oppIdList){
                Opportunity opportunity = [SELECT Id, AccountId, RC_Agreement_Number__c, OwnerId, RC_Agreement_Date__c, Name, RC_Fair__c, RC_Sales_Organisation__c, CurrencyIsoCode,RC_Stamp_Duty__c FROM Opportunity WHERE Id  =: oppId];
                OpportunityLineItem[] opLineItem = [SELECT Id, Product2Id, Quantity, RC_Net_Price__c FROM OpportunityLineItem WHERE OpportunityId  =: oppId];
                RC_Fair__c fair = [SELECT Id, Name, RC_CNR_Firm__c, RC_LogoKey__c FROM RC_Fair__c WHERE Id =: opportunity.RC_Fair__c];
                Account account = [SELECT Id, Name,Phone,RC_Tax_Number__c,RC_Tax_Office__c,RC_Email__c,BillingStreet,BillingState,BillingCity,RC_LogoKey__c  FROM Account WHERE Id =: opportunity.AccountId];
                User user = [SELECT Id, RC_Logo_Key__c FROM User WHERE Id =: opportunity.OwnerId];
                
                
                string accLogoKey=FindLogoKey(account,opportunity.RC_Sales_Organisation__c);
                system.debug('RC_Stamp_Duty__c:'+opportunity.RC_Stamp_Duty__c);
                LogoCreateOrderJsonParser response = LogoCreateOrderIntegrator.LogoCreateOrder(accLogoKey, account.Name, opportunity.RC_Agreement_Number__c, opportunity.Name,
                                                                                               opportunity.RC_Agreement_Date__c, opportunity.RC_Sales_Organisation__c, 
                                                                                               user.RC_Logo_Key__c, opportunity.CurrencyIsoCode, fair.RC_LogoKey__c, opLineItem,opportunity.Id,opportunity.RC_Stamp_Duty__c);
                if(response!=null && string.isNotBlank(response.fisNo))
                {
                    opportunity.RC_LogoKey__c=response.fisNo;
                    oppList.add(opportunity); 
                    
                    account.RC_LogoKey__c=accLogoKey;
                    update account;
                }
                
            }
            if(oppList!=null && oppList.size()>0)
            {
                List<Database.SaveResult> dbUpdate=Database.Update(oppList);
                for(DataBase.SaveResult theResult : dbUpdate) {
                    if(theResult.isSuccess() == true){
                        system.debug('test:' + theResult);
                        continue; 
                    }
                }
            }
        }
    }
    
    public static string FindLogoKey(Account acc,string salesOrg){
        string LogoKey='';
        
        if(string.isNotBlank(acc.RC_LogoKey__c)){
            if(!test.isRunningTest()){
                return acc.RC_LogoKey__c;
            }
        }
        
        if(salesOrg=='Domestic')
        {
            RC_LogoCheckCariByVknIntegrator.ReturnWrapper vknCheck=RC_LogoCheckCariByVknIntegrator.CariKontrolByVKN(acc.RC_Tax_Number__c,'002','01');
            system.debug('vknCheck:' + vknCheck);
            if(string.isNotBlank(vknCheck.cariKodu))
                return vknCheck.cariKodu;
            else
            {
                system.debug('cari kodu boş:' + vknCheck.cariKodu);
                boolean result= CreateCariToLogo(acc,salesOrg);      
                if(result)
                    return acc.RC_Tax_Number__c;
            }
        }
        else
        {
            RC_LogoCheckCariByPhoneIntegrator.ReturnWrapper phoneCheck=RC_LogoCheckCariByPhoneIntegrator.CariKontrolByPhone(acc.Phone,'002','01');
            if(string.isNotBlank(phoneCheck.cariKodu))
                return phoneCheck.cariKodu;
            else
            {
                boolean result= CreateCariToLogo(acc,salesOrg);      
                if(result)
                    return acc.Phone;
            }
        }
        
        return acc.RC_LogoKey__c;
    }
    
    public static boolean CreateCariToLogo(Account acc,string salesOrg)
    {
        
        RC_LogoCariKaydetIntegrator.CariKaydetWrapper cariWrapper= new RC_LogoCariKaydetIntegrator.CariKaydetWrapper();
        cariWrapper.FirmaNo='002';
        cariWrapper.Kodu=salesOrg=='Domestic' ? acc.RC_Tax_Number__c : acc.Phone;
        cariWrapper.Tanimi=acc.Name;
        cariWrapper.Ili=acc.BillingCity;
        cariWrapper.Ilcesi=acc.BillingState;
        cariWrapper.Telefonu=acc.Phone;
        cariWrapper.VergiNo=acc.RC_Tax_Number__c;
        cariWrapper.VergiDairesi=acc.RC_Tax_Office__c;
        cariWrapper.Adresi=acc.BillingStreet;
        cariWrapper.MailAdresi=acc.RC_Email__c;
        
        return RC_LogoCariKaydetIntegrator.CariKaydet(cariWrapper);
        
    }
}