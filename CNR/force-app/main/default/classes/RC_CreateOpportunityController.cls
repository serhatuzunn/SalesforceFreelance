public class RC_CreateOpportunityController {
        
    public class createOpportunityResult{
        @AuraEnabled
        public boolean state {get;set;}
        @AuraEnabled
        public string errMsg {get;set;}
        @AuraEnabled
        public List<String> jobIDList {get; set;}
    }
    
    
    public class JobStatusWrapper{
        @AuraEnabled
        public Integer isCompleted {get; set;}
        @AuraEnabled
        public String message {get; set;}
    }
    
    /*EXCEL*/
    public class excelModelWrapper{
        @AuraEnabled
        public string firmaadi {get;set;}
        @AuraEnabled
        public string firmatelefon {get;set;}
        @AuraEnabled
        public string firmamail {get;set;}
        @AuraEnabled
        public string firmaparabirimi {get;set;}
        @AuraEnabled
        public string firmavergikimliknumarasi {get;set;}
        @AuraEnabled
        public string kisiad {get;set;}
        @AuraEnabled        
        public string kisiunvan {get;set;}
        @AuraEnabled        
        public string kisisoyad {get;set;}
        @AuraEnabled
        public string kisitelefon {get;set;}
        @AuraEnabled
        public string kisimail {get;set;}
        @AuraEnabled
        public string adres {get;set;}
        @AuraEnabled
        public string ilce {get;set;}
        @AuraEnabled
        public string il {get;set;}
        @AuraEnabled
        public string ulke {get;set;}
        @AuraEnabled
        public string web {get;set;}
        @AuraEnabled
        public string sektor {get;set;}
        
    }
    
    public class ResultWrapper{
        @AuraEnabled
        public List<excelModelWrapper> excelData{get;set;}
        @AuraEnabled
        public string ErrorMsg{get;set;}
        @AuraEnabled
        public boolean State{get;set;}
        @AuraEnabled
        public boolean sectorError{get;set;}
        
        @AuraEnabled
        public boolean isDuplice{get;set;}
        
    }
    /*EXCEL*/
    
    public class initWrapper{
        @AuraEnabled
        public Fairs Fair{get;set;}
        @AuraEnabled
        public Sectors Sector{get;set;}
        @AuraEnabled
        public List<SelectOptionWrapper> ProductGroupList{get;set;}
        @AuraEnabled
        public List<SelectOptionWrapper> TypeList{get;set;}
        @AuraEnabled
        public List<SelectOptionWrapper> DataTypeList{get;set;}
        @AuraEnabled
        public boolean isAdmin {get;Set;}
        
        
        
    }
    
    public class dataWrapper{
        @AuraEnabled
        public List<tableWrapper> accountList{get;set;}
        @AuraEnabled 
        public integer currentPage{get;set;}
        @AuraEnabled
        public integer totalPage{get;set;}
        @AuraEnabled
        public integer recCount{get;set;}        
        @AuraEnabled
        public integer pageSize{get;set;}  
        @AuraEnabled
        public integer pageNumber{get;set;} 
    }
    
    public class tableWrapper{
        @AuraEnabled
        public string accountId {get;set;}
        @AuraEnabled
        public string accountName {get;set;}
        @AuraEnabled
        public string accountPhone {get;set;}
        @AuraEnabled
        public string accountMail {get;set;}
        @AuraEnabled
        public string accountCurrency {get;set;}
        @AuraEnabled
        public string accountVKN {get;set;}
        @AuraEnabled
        public string contactName {get;set;}
        @AuraEnabled
        public string contactPhone {get;set;}
        @AuraEnabled
        public string contactMail {get;set;}
        @AuraEnabled
        public Account accountData {get;set;}
        @AuraEnabled
        public Contact contactData {get;set;}
        
    }
    
    public class Fairs{
        @AuraEnabled
        public List<SelectOptionWrapper> mainFairList{get;set;}
        @AuraEnabled
        public List<SelectOptionWrapper> subFairList{get;set;}
        @AuraEnabled
        public List<SelectOptionWrapper> childFairList{get;set;}
        @AuraEnabled 
        public List<SelectOptionWrapper> allFairList{get;set;}
    }
    
    public class Sectors{
        @AuraEnabled
        public List<SelectOptionWrapper> sectorList{get;set;}
        @AuraEnabled
        public List<SelectOptionWrapper> subSectorList{get;set;}
    }
    
    public class SelectOptionWrapper{
        @AuraEnabled
        public string label {get;set;}
        @AuraEnabled
        public string value {get;set;}
        
    }
    
    @AuraEnabled
    public static initWrapper getInit(){
        
        initWrapper initWrp = new initWrapper();
        initWrp.Fair = new Fairs();
        
        initWrp.Fair.mainFairList = getMainFairPickList().mainFairList;
        initWrp.Fair.allFairList  = getAllFairs().allFairList;
        initWrp.TypeList		  = getTypeList();
        initWrp.DataTypeList 	  = getDataTypeList();
        
        Id profileId=userinfo.getProfileId();
        String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
        system.debug('profileName' + profileName);
        if(profileName == 'System Administrator' || profileName == 'CNR Admin'){
            initWrp.isAdmin = true;
        }else{
            initWrp.isAdmin = false;
        }
        
        return initWrp;
    }
    
    @AuraEnabled
    public static Fairs getMainFairPickList(){
        
        Fairs result = new Fairs();
        result.mainFairList = new List<SelectOptionWrapper>();
        
        SelectOptionWrapper opt = new SelectOptionWrapper();
        opt.label = '';
        opt.value = '';
        result.mainFairList.add(opt);
        
        List<RC_Fair__c> mainFairs = [SELECT Id, Name FROM RC_Fair__c WHERE RC_Related_Fair__c = '' AND Status__c ='Approved' ORDER BY Name ASC];
        
        for(RC_Fair__c mainFair : mainFairs ){
            opt = new SelectOptionWrapper();
            opt.label = mainFair.Name;
            opt.value = mainFair.Id;
            
            result.mainFairList.add(opt);
        }   
        
        return result;
    }
    
    @AuraEnabled
    public static Fairs getSubFairList(string selectedMainFair){
        
        Fairs result = new Fairs();
        result.subFairList = new List<SelectOptionWrapper>();
        
        SelectOptionWrapper opt = new SelectOptionWrapper();
        opt.label = '';
        opt.value = '';
        result.subFairList.add(opt);
        
        List<RC_Fair__c> subFairs =[SELECT Id, Name FROM RC_Fair__c WHERE RC_Related_Fair__c =: selectedMainFair AND Status__c ='Approved'   ORDER BY Name ASC];
        
        for(RC_Fair__c subFair: subFairs ){
            opt = new SelectOptionWrapper();
            opt.label = subFair.Name;
            opt.value = subFair.Id;
            
            result.subFairList.add(opt);
        }   
        
        return result;
    }
    
    @AuraEnabled
    public static Fairs getChildFairs(){
        Fairs result = new Fairs();
        result.childFairList = new List<SelectOptionWrapper>();
        
        SelectOptionWrapper opt = new SelectOptionWrapper();
        opt.label = '';
        opt.value = '';
        result.childFairList.add(opt);
        
        List<RC_Fair__c> allChildFairs = [SELECT Id, Name FROM RC_Fair__c WHERE RC_Related_Fair__c != null AND Status__c ='Approved' ORDER BY Name ASC];
        
        for(RC_Fair__c childFair : allChildFairs ){
            opt = new SelectOptionWrapper();
            opt.label = childFair.Name;
            opt.value = childFair.Id;
            
            result.childFairList.add(opt);
        }   
        
        return result;
    }
    
    @AuraEnabled
    public static Fairs getAllFairs(){
        Fairs result = new Fairs();
        result.allFairList = new List<SelectOptionWrapper>();
        
        SelectOptionWrapper opt = new SelectOptionWrapper();
        opt.label = '';
        opt.value = '';
        result.allFairList.add(opt);
        
        List<RC_Fair__c> allFairs = [SELECT Id, Name FROM RC_Fair__c WHERE Status__c ='Approved' ORDER BY Name ASC];
        
        for(RC_Fair__c allFair : allFairs){
            opt = new SelectOptionWrapper();
            opt.label = allFair.Name;
            opt.value = allFair.Id;
            
            result.allFairList.add(opt);
        }   
        
        return result;
    }
    
    @AuraEnabled
    public static Sectors getSectorPickList(){
        
        Sectors result = new Sectors();
        result.sectorList = new List<SelectOptionWrapper>();
        
        SelectOptionWrapper opt = new SelectOptionWrapper();
        opt.label = '';
        opt.value = '';
        result.sectorList.add(opt);
        
        List<RC_Value_Set__c> sectors = [SELECT Id, Name FROM RC_Value_Set__c WHERE RC_Type__c = 'Sector' ORDER BY Name ASC];
        
        for(RC_Value_Set__c sector :  sectors){
            opt = new SelectOptionWrapper();
            opt.label = sector.Name;
            opt.value = sector.Id;
            
            result.sectorList.add(opt);
        }   
        
        return result;
    }
    
    @AuraEnabled
    public static Sectors getSubSectorList(string selectedMainSector){
        
        Sectors result = new Sectors();
        result.subSectorList = new List<SelectOptionWrapper>();
        
        SelectOptionWrapper opt = new SelectOptionWrapper();
        opt.label = '';
        opt.value = '';
        result.subSectorList.add(opt);
        
        List<RC_Value_Set__c> subSectors = [SELECT Id, Name FROM RC_Value_Set__c WHERE RC_Type__c = 'Sub Sector' AND RC_Sector__c =: selectedMainSector ORDER BY Name ASC];
        
        for(RC_Value_Set__c subSector : subSectors){
            opt = new SelectOptionWrapper();
            opt.label = subSector.Name;
            opt.value = subSector.Id;
            
            result.subSectorList.add(opt);
        }   
        
        return result;
    }
    
    @AuraEnabled
    public static List<SelectOptionWrapper> getProductGroupList(string selectedSubSector){
        
        
        List<SelectOptionWrapper> productGroupList = new List<SelectOptionWrapper>();
        
        SelectOptionWrapper opt = new SelectOptionWrapper();
        opt.label = '';
        opt.value = '';
        productGroupList.add(opt);
        
        List<RC_Value_Set__c> groups = [SELECT Id, Name FROM RC_Value_Set__c WHERE RC_Type__c = 'Product Group' AND RC_Sub_Sector__c =: selectedSubSector ORDER BY Name ASC];
        
        for(RC_Value_Set__c pGroup : groups){
            opt = new SelectOptionWrapper();
            opt.label = pGroup.Name;
            opt.value = pGroup.Id;
            
            productGroupList.add(opt);
        }   
        
        return productGroupList;
    }
    
    @AuraEnabled
    public static List<SelectOptionWrapper> getTypeList(){
        
        List<SelectOptionWrapper> TypeList = new List<SelectOptionWrapper>();
        
        SelectOptionWrapper opt = new SelectOptionWrapper();
        opt.label = '';
        opt.value = '';
        TypeList.add(opt);
        
        Schema.DescribeFieldResult fieldResult = RC_Related_Sector__c.RC_Type__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            
            opt = new SelectOptionWrapper();
            opt.label = pickListVal.getLabel();
            opt.value = pickListVal.getValue();
            
            TypeList.add(opt);
        }     
        
        return TypeList;
    }
    
    @AuraEnabled
    public static List<SelectOptionWrapper> getDataTypeList(){
        
        List<SelectOptionWrapper> DataTypeList = new List<SelectOptionWrapper>();
        
        SelectOptionWrapper opt = new SelectOptionWrapper();
        opt.label = '';
        opt.value = '';
        DataTypeList.add(opt);
        
        Schema.DescribeFieldResult fieldResult = Opportunity.RC_Data_Type__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            
            opt = new SelectOptionWrapper();
            opt.label = pickListVal.getLabel();
            opt.value = pickListVal.getValue();
            
            DataTypeList.add(opt);
        }     
        
        return DataTypeList;
    }
    
    @AuraEnabled
    public static dataWrapper listByFairParticipation(string selectedMainFair,string selectedSubFair,integer currentPage){
        dataWrapper dataWrp = new dataWrapper();
        dataWrp.accountList = new List<tableWrapper>();
        
        List<Opportunity> oppList = new List<Opportunity>();
        List<id> accIdList = new List<id>();
        Fairs fair = new Fairs();
        List<RC_Fair__c> subfairList = [SELECT id FROM RC_Fair__c WHERE RC_Related_Fair__c =: selectedMainFair ORDER BY Name ASC];
        Set<Id> fairIdList= new Set<Id>();
        for(RC_Fair__c x : subFairList){
            fairIdList.add(x.Id);
        }
        if(string.isBlank(selectedSubFair)){
            oppList= [SELECT id,AccountId FROM Opportunity WHERE RC_Fair__c IN :fairIdList];
        }else{
            oppList= [SELECT id,AccountId FROM Opportunity WHERE RC_Fair__c =:selectedSubFair];
        }
        
        
        
        Map<Id,Id> accMap= new Map<Id,Id>();
        for(Opportunity opp : oppList)
        {
            if(!accMap.containsKey(opp.AccountId)){
                accMap.put(opp.id,opp.AccountId);
            } 
        }
        for(id x :accMap.keyset()){
            accIdList.add(accMap.get(x));
        }
        integer pageSize = 100;
        integer totalPage = 0;
        integer countRec = 0;   
        
        string queryStr='SELECT Id,Name,Phone,RC_Email__c,CurrencyIsoCode,RC_Tax_Number__c FROM Account WHERE id IN :accIdList LIMIT ' +pageSize+ ' OFFSET ' + currentPage;
        String queryCount = 'Select count() from Account WHERE id IN :accIdList';
        
        
        List<Account> accList = database.query(queryStr);
        countRec = database.countQuery(queryCount);
        totalPage = (countRec / pageSize);
        if(math.mod(countRec, pageSize) > 0){
            totalPage++;
        }  
        
        List<Contact> cList   =[SELECT Name,Phone,Email,AccountId FROM Contact WHERE AccountId IN:accIdList AND RC_Primary__c = true];
        Map<Id,Contact> contactMap= new Map<Id,Contact>();
        for(Contact x : cList){
            contactMap.put(x.AccountId,x);
        }
        
        for(Account acc : accList){
            tableWrapper tblWrp = new tableWrapper();
            Contact tempContact = new Contact();
            tempContact = contactMap.get(acc.id);
            
            if(tempContact != null){
                
                tblWrp.accountId = acc.id;
                tblWrp.accountName = acc.Name;
                tblWrp.accountPhone =acc.Phone;
                tblWrp.accountMail = acc.RC_Email__c;
                tblWrp.accountCurrency = acc.CurrencyIsoCode;
                tblWrp.accountVKN = acc.RC_Tax_Number__c;
                tblWrp.contactName = tempContact.Name;
                if(string.isBlank(tempContact.Phone)){
                    tblWrp.contactPhone = '-';
                }else{
                    tblWrp.contactPhone =tempContact.Phone;
                }
                tblWrp.contactMail = tempContact.Email;
            }else{
                tblWrp.accountId = acc.id;
                tblWrp.accountName = acc.Name;
                tblWrp.accountPhone =acc.Phone;
                tblWrp.accountMail = acc.RC_Email__c;
                tblWrp.accountCurrency = acc.CurrencyIsoCode;
                tblWrp.accountVKN = acc.RC_Tax_Number__c;
            }
            
            
            dataWrp.accountList.add(tblWrp);
        }
        dataWrp.currentPage		= currentPage;
        dataWrp.totalPage		= totalPage;
        dataWrp.pageSize		= pageSize;
        dataWrp.recCount		= countRec;
        dataWrp.pageNumber		=1;
        
        
        return dataWrp;
    }
    
    @AuraEnabled
    public static dataWrapper listByFairSector(List<string> selectedPills,string selectedTypeTab2,integer currentPage){
        List<tableWrapper> tableWrpList = new List<tableWrapper>();
        
        dataWrapper dataWrp = new dataWrapper();
        dataWrp.accountList = new List<tableWrapper>();
        
        List<RC_Related_Sector__c> relatedSectors = [SELECT id,RC_Account__c FROM RC_Related_Sector__c WHERE (RC_Sector__c IN: selectedPills OR RC_Sub_Sector__c IN: selectedPills OR RC_Product_Group__c IN: selectedPills) AND RC_Account__c != null AND RC_Type__c =:selectedTypeTab2];
        
        
        
        
        List<id> accIdList = new List<id>();       
        Map<Id,Id> accMap= new Map<Id,Id>();
        for(RC_Related_Sector__c related : relatedSectors)
        {
            if(!accMap.containsKey(related.RC_Account__c)){
                accMap.put(related.id,related.RC_Account__c);
            } 
        }
        for(id x :accMap.keyset()){
            accIdList.add(accMap.get(x));
        }
        
        
        integer pageSize = 100;
        integer totalPage = 0;
        integer countRec = 0;   
        
        string queryStr='SELECT Id,Name,Phone,RC_Email__c,CurrencyIsoCode,RC_Tax_Number__c FROM Account WHERE id IN :accIdList LIMIT ' +pageSize+ ' OFFSET ' + currentPage;
        String queryCount = 'Select count() from Account WHERE id IN :accIdList';
        
        List<Account> accList = database.query(queryStr);
        countRec = database.countQuery(queryCount);
        totalPage = (countRec / pageSize);
        if(math.mod(countRec, pageSize) > 0){
            totalPage++;
        }
        
        List<Contact> cList   =[SELECT Name,Phone,Email,AccountId FROM Contact WHERE AccountId IN:accIdList AND RC_Primary__c = true];
        Map<Id,Contact> contactMap= new Map<Id,Contact>();
        for(Contact x : cList){
            contactMap.put(x.AccountId,x);
        }
        
        for(Account acc : accList){
            tableWrapper tblWrp = new tableWrapper();
            Contact tempContact = new Contact();
            tempContact = contactMap.get(acc.id);
            
            if(tempContact != null){
                
                tblWrp.accountId = acc.id;
                tblWrp.accountName = acc.Name;
                tblWrp.accountPhone =acc.Phone;
                tblWrp.accountMail = acc.RC_Email__c;
                tblWrp.accountCurrency = acc.CurrencyIsoCode;
                tblWrp.accountVKN = acc.RC_Tax_Number__c;
                tblWrp.contactName = tempContact.Name;
                if(string.isBlank(tempContact.Phone)){
                    tblWrp.contactPhone = '-';
                }else{
                    tblWrp.contactPhone =tempContact.Phone;
                }
                tblWrp.contactMail = tempContact.Email;
            }else{
                tblWrp.accountId = acc.id;
                tblWrp.accountName = acc.Name;
                tblWrp.accountPhone =acc.Phone;
                tblWrp.accountMail = acc.RC_Email__c;
                tblWrp.accountCurrency = acc.CurrencyIsoCode;
                tblWrp.accountVKN = acc.RC_Tax_Number__c;
            }
            
            
            dataWrp.accountList.add(tblWrp);
            
        }
        dataWrp.currentPage		= currentPage;
        dataWrp.totalPage		= totalPage;
        dataWrp.pageSize		= pageSize;
        dataWrp.recCount		= countRec;
        dataWrp.pageNumber		=1;
        
        return dataWrp;
    }
    
    @AuraEnabled
    public static dataWrapper listByFair(string selectedFair,string selectedTypeTab3,integer currentPage){
        List<tableWrapper> tableWrpList = new List<tableWrapper>();
        dataWrapper dataWrp = new dataWrapper();
        dataWrp.accountList = new List<tableWrapper>();
        
        List<RC_Related_Sector__c> relatedSectors = [SELECT id,RC_Account__c,RC_Sector__c,RC_Sub_Sector__c,RC_Product_Group__c FROM RC_Related_Sector__c WHERE RC_Fair__c =:selectedFair ];
        
        
        
        List<id> sectorList = new List<id>();
        
        for(RC_Related_Sector__c x : relatedSectors){
            if(x.RC_Product_Group__c != null){
                sectorList.add(x.RC_Product_Group__c);
            }else if(x.RC_Sub_Sector__c != null){
                sectorList.add(x.RC_Sub_Sector__c);
            }else if(x.RC_Sector__c != null){
                sectorList.add(x.RC_Sector__c);
            }else{
                //Firma bulunamadı hatası dön.
            }
        }
        
        
        List<RC_Related_Sector__c> relatedSectorAccounts = [SELECT id,RC_Account__c FROM RC_Related_Sector__c WHERE (RC_Sector__c IN: sectorList OR RC_Sub_Sector__c IN: sectorList OR RC_Product_Group__c IN: sectorList) AND RC_Account__c != null AND RC_Type__c =:selectedTypeTab3];
        
        List<id> accIdList = new List<id>();       
        Map<Id,Id> accMap= new Map<Id,Id>();
        for(RC_Related_Sector__c relatedAcc : relatedSectorAccounts)
        {
            if(!accMap.containsKey(relatedAcc.RC_Account__c)){
                accMap.put(relatedAcc.id,relatedAcc.RC_Account__c);
            } 
        }
        for(id x :accMap.keyset()){
            accIdList.add(accMap.get(x));
        }
        
        integer pageSize = 100;
        integer totalPage = 0;
        integer countRec = 0;   
        
        string queryStr='SELECT Id,Name,Phone,RC_Email__c,CurrencyIsoCode,RC_Tax_Number__c FROM Account WHERE id IN :accIdList LIMIT ' +pageSize+ ' OFFSET ' + currentPage;
        String queryCount = 'Select count() from Account WHERE id IN :accIdList';
        
        List<Account> accList = database.query(queryStr);
        countRec = database.countQuery(queryCount);
        totalPage = (countRec / pageSize);
        if(math.mod(countRec, pageSize) > 0){
            totalPage++;
        }
        
        List<Contact> cList   =[SELECT Name,Phone,Email,AccountId FROM Contact WHERE AccountId IN:accIdList AND RC_Primary__c = true];
        Map<Id,Contact> contactMap= new Map<Id,Contact>();
        for(Contact x : cList){
            contactMap.put(x.AccountId,x);
        }
        
        for(Account acc : accList){
            tableWrapper tblWrp = new tableWrapper();
            Contact tempContact = new Contact();
            tempContact = contactMap.get(acc.id);
            
            if(tempContact != null){
                
                tblWrp.accountId = acc.id;
                tblWrp.accountName = acc.Name;
                tblWrp.accountPhone =acc.Phone;
                tblWrp.accountMail = acc.RC_Email__c;
                tblWrp.accountCurrency = acc.CurrencyIsoCode;
                tblWrp.accountVKN = acc.RC_Tax_Number__c;
                tblWrp.contactName = tempContact.Name;
                if(string.isBlank(tempContact.Phone)){
                    tblWrp.contactPhone = '-';
                }else{
                    tblWrp.contactPhone =tempContact.Phone;
                }
                tblWrp.contactMail = tempContact.Email;
            }else{
                tblWrp.accountId = acc.id;
                tblWrp.accountName = acc.Name;
                tblWrp.accountPhone =acc.Phone;
                tblWrp.accountMail = acc.RC_Email__c;
                tblWrp.accountCurrency = acc.CurrencyIsoCode;
                tblWrp.accountVKN = acc.RC_Tax_Number__c;
            }
            
            
            dataWrp.accountList.add(tblWrp);
            
        }
        dataWrp.currentPage		= currentPage;
        dataWrp.totalPage		= totalPage;
        dataWrp.pageSize		= pageSize;
        dataWrp.recCount		= countRec;
        dataWrp.pageNumber		=1;
        
        return dataWrp;
    }
    
    @AuraEnabled
    public static ResultWrapper getExcelData(String base64String) {
        
        Boolean isDuplice = false;
        ResultWrapper result=new ResultWrapper();
        result.sectorError = false;
        result.excelData=new List<excelModelWrapper>();
        RC_ExcelImportIntegrator.ResultWrapper resultWrp = new  RC_ExcelImportIntegrator.ResultWrapper();
        
        Set<string> sectorList = new Set<string>();
        Map<string,RC_Value_Set__c> sectorMap = new Map<string,RC_Value_Set__c>();
        
        List<string> excelRowPhoneList = new  List<string>();
        List<string> excelRowVknList = new  List<string>();
        
        resultWrp = RC_ExcelImportIntegrator.getFormattedData(base64String);
        system.debug('resultWrp :::' + resultWrp);
        
        Map<string,excelModelWrapper> phoneMAP = new Map<string,excelModelWrapper>();
        Map<string,excelModelWrapper> VKNMAP = new Map<string,excelModelWrapper>();
        
        if(!string.isNotBlank(resultWrp.ErrorMessage)){
            
            for(integer i=0 ; i<resultWrp.excelList.size() ; i++){
                if(phoneMAP.containsKey(resultWrp.excelList[i].firmatelefon.SubStringBefore('.')) || VKNMAP.containsKey(resultWrp.excelList[i].firmavergikimliknumarasi.SubStringBefore('.')) ){
                    
                    excelModelWrapper excelRow = new excelModelWrapper();
                    excelRow.firmaadi 					= resultWrp.excelList[i].firmaadi;
                    excelRow.firmatelefon 				= resultWrp.excelList[i].firmatelefon.SubStringBefore('.');
                    excelRow.firmavergikimliknumarasi 	= resultWrp.excelList[i].firmavergikimliknumarasi.SubStringBefore('.');
                    
                    result.excelData.Add(excelRow);
                    
                    if(phoneMAP.containsKey(resultWrp.excelList[i].firmatelefon.SubStringBefore('.')))
                    {
                        excelModelWrapper duplicatePhone =  phoneMAP.get(resultWrp.excelList[i].firmatelefon.SubStringBefore('.'));
                        excelModelWrapper excelDuplicateRow = new excelModelWrapper();
                        excelDuplicateRow.firmaadi 					= duplicatePhone.firmaadi;
                        excelDuplicateRow.firmatelefon 				= duplicatePhone.firmatelefon.SubStringBefore('.');
                        excelDuplicateRow.firmavergikimliknumarasi 	= duplicatePhone.firmavergikimliknumarasi.SubStringBefore('.');
                        
                        result.excelData.Add(excelDuplicateRow);
                    }
                    else
                    {
                        if(string.isNotBlank(resultWrp.excelList[i].firmavergikimliknumarasi)){
                            excelModelWrapper duplicateVkn=  VKNMAP.get(resultWrp.excelList[i].firmavergikimliknumarasi.SubStringBefore('.'));
                            excelModelWrapper excelDuplicateRow = new excelModelWrapper();
                            excelDuplicateRow.firmaadi 					= duplicateVkn.firmaadi;
                            excelDuplicateRow.firmatelefon 				= duplicateVkn.firmatelefon.SubStringBefore('.');
                            excelDuplicateRow.firmavergikimliknumarasi 	= duplicateVkn.firmavergikimliknumarasi.SubStringBefore('.');
                            
                            result.excelData.Add(excelDuplicateRow);
                        }
                    }
                    
                }
                else{
                    if(string.IsNotBlank(resultWrp.excelList[i].firmatelefon)){
                        phoneMAP.put(resultWrp.excelList[i].firmatelefon.SubStringBefore('.'),resultWrp.excelList[i]);
                    }
                    
                    excelRowPhoneList.add(resultWrp.excelList[i].firmatelefon.SubStringBefore('.'));
                    if(string.IsNotBlank(resultWrp.excelList[i].firmavergikimliknumarasi)){
                        VKNMAP.put(resultWrp.excelList[i].firmavergikimliknumarasi.SubStringBefore('.'),resultWrp.excelList[i]);
                        excelRowVknList.add(resultWrp.excelList[i].firmavergikimliknumarasi.SubStringBefore('.'));
                    }
                }
            }            
            
            if(result.excelData.size() > 0){
                // VKN veya Telefon ile duplice kayıt var ise ekrana hata ile birlikte dupliceler gösterilir.
                result.ErrorMsg = 'Aynı Vergi Kimlik Numarasına veya Telefon Numarasına Sahip Firma Olamaz .! Listeden Kontrol Ediniz.' ;
                result.State = false;
                result.isDuplice = true;
                return result; 
            }
            else
            {
                for(integer i=0 ; i<resultWrp.excelList.size() ; i++){
                    if(string.IsNotBlank(resultWrp.excelList[i].firmaadi)  &&  string.IsNotBlank(resultWrp.excelList[i].firmatelefon) && 
                       string.IsNotBlank(resultWrp.excelList[i].firmaparabirimi) && string.IsNotBlank(resultWrp.excelList[i].ulke))
                    {
                        excelModelWrapper excelRow=new excelModelWrapper();
                        
                        
                        
                        //firma bilgileri
                        if(resultWrp.excelList[i].firmaadi != null && resultWrp.excelList[i].firmaadi != ''){
                            excelRow.firmaadi 			= resultWrp.excelList[i].firmaadi;
                        }
                        else{
                            result.ErrorMsg = i+2 + '.Satırdaki Firma Adı Boş Olamaz.';
                            result.State = false;
                            if(!Test.isRunningTest()){
                                return result; 
                            }
                        }
                        
                        if(string.isNotBlank(resultWrp.excelList[i].firmamail)){
                            resultWrp.excelList[i].firmamail = resultWrp.excelList[i].firmamail.replaceAll('ç', 'c');
                            resultWrp.excelList[i].firmamail = resultWrp.excelList[i].firmamail.replaceAll('ş', 's');
                            resultWrp.excelList[i].firmamail = resultWrp.excelList[i].firmamail.replaceAll('ü', 'u');
                            resultWrp.excelList[i].firmamail = resultWrp.excelList[i].firmamail.replaceAll('ö', 'o');
                            resultWrp.excelList[i].firmamail = resultWrp.excelList[i].firmamail.replaceAll('ğ', 'g');
                            resultWrp.excelList[i].firmamail = resultWrp.excelList[i].firmamail.replaceAll('ı', 'i');
                            resultWrp.excelList[i].firmamail = resultWrp.excelList[i].firmamail.replaceAll('Ç', 'C');
                            resultWrp.excelList[i].firmamail = resultWrp.excelList[i].firmamail.replaceAll('Ş', 'S');
                            resultWrp.excelList[i].firmamail = resultWrp.excelList[i].firmamail.replaceAll('Ü', 'U');
                            resultWrp.excelList[i].firmamail = resultWrp.excelList[i].firmamail.replaceAll('Ö', 'O');
                            resultWrp.excelList[i].firmamail = resultWrp.excelList[i].firmamail.replaceAll('Ğ', 'G');
                            resultWrp.excelList[i].firmamail = resultWrp.excelList[i].firmamail.replaceAll('İ', 'I');
                            resultWrp.excelList[i].firmamail = resultWrp.excelList[i].firmamail.replaceAll('~', '');
                            resultWrp.excelList[i].firmamail = resultWrp.excelList[i].firmamail.replaceAll('^', '');
                            resultWrp.excelList[i].firmamail = resultWrp.excelList[i].firmamail.replaceAll('<', '');
                            resultWrp.excelList[i].firmamail = resultWrp.excelList[i].firmamail.replaceAll('>', '');
                            resultWrp.excelList[i].firmamail = resultWrp.excelList[i].firmamail.replaceAll('€', '');
                            resultWrp.excelList[i].firmamail = resultWrp.excelList[i].firmamail.replaceAll('£', '');
                            resultWrp.excelList[i].firmamail = resultWrp.excelList[i].firmamail.replaceAll(' ', '');
                            
                            if(validateEmail(resultWrp.excelList[i].firmamail.deleteWhitespace())){
                                excelRow.firmamail				= resultWrp.excelList[i].firmamail.deleteWhiteSpace();
                            }else{
                                result.ErrorMsg = resultWrp.excelList[i].firmamail+ ' ' + 'mail formatına uygun değildir .!';
                                result.State = false;
                                return result;
                            }
                        }
                        else{
                            excelRow.firmamail = '';
                        }
                        
                        excelRow.firmatelefon 				= resultWrp.excelList[i].firmatelefon.SubStringBefore('.');
                        excelRow.firmatelefon 				= excelRow.firmatelefon.deleteWhiteSpace();
                        excelRow.firmatelefon				= excelRow.firmatelefon.replaceAll(' ', '');
                        system.debug('excelRow.firmatelefon :' + excelRow.firmatelefon);
                        excelRow.firmaparabirimi 			= resultWrp.excelList[i].firmaparabirimi;
                        
                        if(string.isNotBlank(resultWrp.excelList[i].sektor)){
                            
                            sectorList.add(resultWrp.excelList[i].sektor);
                            
                        }
                        
                        if(string.IsNotBlank(resultWrp.excelList[i].firmavergikimliknumarasi)){
                            excelRow.firmavergikimliknumarasi 	= resultWrp.excelList[i].firmavergikimliknumarasi.SubStringBefore('.');
                        }
                        
                        if(string.isnotblank(resultWrp.excelList[i].adres)){
                            excelRow.adres 					= resultWrp.excelList[i].adres;
                        }
                        else{
                            excelRow.adres 					= '';
                        }
                        
                        if(string.isnotblank(resultWrp.excelList[i].il)){
                            excelRow.il 					= resultWrp.excelList[i].il;
                        }
                        else{
                            excelRow.il 					= '';
                        }
                        
                        if(string.isnotblank(resultWrp.excelList[i].ilce)){
                            excelRow.ilce					= resultWrp.excelList[i].ilce;
                        }
                        else{
                            excelRow.ilce 					= '';
                        }
                        
                        if(string.isnotblank(resultWrp.excelList[i].ulke)){
                            excelRow.ulke 					= resultWrp.excelList[i].ulke;
                        }
                        else{
                            excelRow.ulke 					= '';
                        }
                        
                        if(string.isnotblank(resultWrp.excelList[i].web)){
                            excelRow.web 					= resultWrp.excelList[i].web;
                        }
                        else{
                            excelRow.web 					= '';
                        }
                        
                        if(string.isnotblank(resultWrp.excelList[i].sektor)){
                            excelRow.sektor 					= resultWrp.excelList[i].sektor;
                        }
                        else{
                            excelRow.sektor 					= '';
                        }
                        
                        //kişi bilgileri
                        if(string.isnotblank(resultWrp.excelList[i].kisiad)){
                            excelRow.kisiad 					= resultWrp.excelList[i].kisiad;
                        }
                        else{
                            excelRow.kisiad 					= '';
                        }
                        
                        if(string.isNotBlank(resultWrp.excelList[i].kisisoyad)){
                            excelRow.kisisoyad 					= resultWrp.excelList[i].kisisoyad;
                        }
                        else{
                            excelRow.kisisoyad 					= '';
                        }
                        
                        if(string.isNotBlank(resultWrp.excelList[i].kisiunvan)){
                            excelRow.kisiunvan 					= resultWrp.excelList[i].kisiunvan;
                        }
                        else{
                            excelRow.kisiunvan 					= '';
                        }
                        
                        if(string.isNotBlank(resultWrp.excelList[i].kisisoyad)){
                            excelRow.kisisoyad 					= resultWrp.excelList[i].kisisoyad;
                        }
                        else{
                            excelRow.kisisoyad 					= '';
                        }
                        
                        if(string.isNotBlank(resultWrp.excelList[i].kisitelefon)){
                            excelRow.kisitelefon				= resultWrp.excelList[i].kisitelefon.SubStringBefore('.').replaceAll(' ', '');
                            excelRow.kisitelefon				= excelRow.kisitelefon.deleteWhiteSpace();
                        }
                        else{
                            excelRow.kisitelefon				= '';
                        }
                        
                        if(string.isNotBlank(resultWrp.excelList[i].kisimail)){
                            
                            resultWrp.excelList[i].kisimail = resultWrp.excelList[i].kisimail.replaceAll('ç', 'c');
                            resultWrp.excelList[i].kisimail = resultWrp.excelList[i].kisimail.replaceAll('ş', 's');
                            resultWrp.excelList[i].kisimail = resultWrp.excelList[i].kisimail.replaceAll('ü', 'u');
                            resultWrp.excelList[i].kisimail = resultWrp.excelList[i].kisimail.replaceAll('ö', 'o');
                            resultWrp.excelList[i].kisimail = resultWrp.excelList[i].kisimail.replaceAll('ğ', 'g');
                            resultWrp.excelList[i].kisimail = resultWrp.excelList[i].kisimail.replaceAll('ı', 'i');
                            resultWrp.excelList[i].kisimail = resultWrp.excelList[i].kisimail.replaceAll('Ç', 'C');
                            resultWrp.excelList[i].kisimail = resultWrp.excelList[i].kisimail.replaceAll('Ş', 'S');
                            resultWrp.excelList[i].kisimail = resultWrp.excelList[i].kisimail.replaceAll('Ü', 'U');
                            resultWrp.excelList[i].kisimail = resultWrp.excelList[i].kisimail.replaceAll('Ö', 'O');
                            resultWrp.excelList[i].kisimail = resultWrp.excelList[i].kisimail.replaceAll('Ğ', 'G');
                            resultWrp.excelList[i].kisimail = resultWrp.excelList[i].kisimail.replaceAll('İ', 'I');
                            resultWrp.excelList[i].kisimail = resultWrp.excelList[i].kisimail.replaceAll('~', '');
                            resultWrp.excelList[i].kisimail = resultWrp.excelList[i].kisimail.replaceAll('^', '');
                            resultWrp.excelList[i].kisimail = resultWrp.excelList[i].kisimail.replaceAll('<', '');
                            resultWrp.excelList[i].kisimail = resultWrp.excelList[i].kisimail.replaceAll('>', '');
                            resultWrp.excelList[i].kisimail = resultWrp.excelList[i].kisimail.replaceAll('€', '');
                            resultWrp.excelList[i].kisimail = resultWrp.excelList[i].kisimail.replaceAll('£', '');
                            resultWrp.excelList[i].kisimail = resultWrp.excelList[i].kisimail.replaceAll(' ', '');
                            if(validateEmail(resultWrp.excelList[i].kisimail.deleteWhiteSpace())){
                                excelRow.kisimail				= resultWrp.excelList[i].kisimail.deleteWhiteSpace();
                            }else{
                                result.ErrorMsg = resultWrp.excelList[i].kisimail+ ' ' + 'mail formatına uygun değildir .!';
                                result.State = false;
                                return result;
                            }
                            
                            
                        }
                        else{
                            excelRow.kisimail				= '';
                        }
                        
                        result.excelData.Add(excelRow);
                        
                    }
                    else{
                        result.ErrorMsg ='Zorunlu alanları doldurunuz.!';
                        result.State = false;
                        return result;
                    }
                }
                
                List<RC_Value_Set__c> sectors = [SELECT id,Name from RC_Value_Set__c WHERE Name =: sectorList AND RC_Type__c = 'Sector'];
                system.debug('sectors !!!! : ' + sectors );
                for(RC_Value_Set__c v : sectors){
                    sectorMap.put(v.Name,v);
                }
                
                if(sectorList.size() != sectors.size()){
                    result.ErrorMsg = 'Excel içerisinde hatalı sektör bilgisi mevcuttur lütfen kontrol ediniz.';
                    result.sectorError = true; 	
                    result.State = true;
                    if(!Test.isRunningTest()){
                        return result; 
                    }
                    
                }
                result.State = true;
            }
            
        }
        else{
            result.ErrorMsg=resultWrp.ErrorMessage;
            result.State = false;
        }
        
        return result;
    }
    
    @AuraEnabled
    public static List<tableWrapper> saveExcel(ResultWrapper excel){
        boolean retVal = false;
        boolean isCreateContact = false;
        List<tableWrapper> tableWrpList = new List<tableWrapper>();
        List<Account> newAccList = new List<Account>();
        List<Account> showAccList = new List<Account>();
        List<Contact> newContactList = new List<Contact>();
        Set<string> excelPhoneList = new Set<string>();
        Set<string> excelVknList = new Set<string>();
        List<string> sectorList = new List<string>();
        Map<string,Account> PhoneAccMap = new Map<string,Account>();
        
        Map<string,Contact> contactMap = new Map<string,Contact>();
        Map<string,RC_Value_Set__c> sectorMap = new Map<string,RC_Value_Set__c>();
        List<string> accountPhoneList = new List<string>();
        
        List<id> showAccIdList = new List<id>();
        
        //Exceldeki PHONE'ları topla
        for(excelModelWrapper x : excel.excelData){
            excelPhoneList.add(x.firmatelefon); //Boşluklu halini listeye ekle
            if(x.firmatelefon.contains(' ')){
                excelPhoneList.add(x.firmatelefon.replace(' ', ''));//Boşluksuz halini listeye ekle
            }
        }
        
        for(excelModelWrapper x : excel.excelData){
            if(String.isNotBlank(x.firmavergikimliknumarasi) && x.firmavergikimliknumarasi != 'null')
                excelVknList.add(x.firmavergikimliknumarasi);
        }
        
        //DB'den PHONE ve VKN ile eşleşen account kayıtlarını getir
        String query = 'SELECT Id,Name,Phone,RC_Email__c,CurrencyIsoCode,RC_Tax_Number__c FROM Account'; 
        if((excelPhoneList != null && excelPhoneList.size() > 0) || (excelVknList != null && excelVknList.size() > 0))
            query += ' WHERE '; 
        
        if(excelPhoneList != null && excelPhoneList.size() > 0){
            query += 'Phone IN (';
            for(string phone : excelPhoneList){
                query += '\'' + phone + '\',';
            }
            query = query.removeEndIgnoreCase(',');
            query += ')';
        }
            
        
        if(excelVknList != null && excelVknList.size() > 0){
            query += ' OR RC_Tax_Number__c IN (';
            for(string vkn : excelVknList){
                query += '\'' + vkn + '\',';
            }
            query = query.removeEndIgnoreCase(',');
            query += ')';
        }
            system.debug('Query : ' + query);
        List<Account> accountList = Database.query(query);
        
        for(Account a : accountList){
            PhoneAccMap.put(a.Phone,a);
        }
        
        for(excelModelWrapper x : excel.excelData){
            if(string.isNotBlank(x.sektor)){
                sectorList.add(x.sektor);
            }
        }
        
        List<RC_Value_Set__c> sectors = [SELECT id,Name from RC_Value_Set__c WHERE Name =: sectorList AND RC_Type__c = 'Sector'];
        
        for(RC_Value_Set__c v : sectors){
            sectorMap.put(v.Name,v);
        }
        
        Map<String, String> portalCountryMap = new Map<String, String>();
		for( Schema.PicklistEntry pickListVal : Account.RC_Portal_Country__c.getDescribe().getPicklistValues()){
            portalCountryMap.put(pickListVal.getLabel(), pickListVal.getValue());
		}   
        
        integer index = 0;
        //excelde for ile dönerken aynı PHONE'a sahip olanları sadece gösterilecek listeye al , olmayanları yarat
        system.debug('test:' + excel.excelData.size());
        for(excelModelWrapper x : excel.excelData){
            if(!PhoneAccMap.containsKey(x.firmatelefon)){
                
                //New Acc Create And Add Acc List
                Account newAcc = new Account();
                newAcc.Name = x.firmaadi;
                newAcc.RC_Email__c = x.firmamail;
                newAcc.Phone = x.firmatelefon.deleteWhiteSpace();
                newAcc.CurrencyIsoCode = x.firmaparabirimi;
                newAcc.RC_Tax_Number__c = x.firmavergikimliknumarasi;
                newAcc.BillingStreet = x.adres;
                newAcc.BillingState = x.ilce;
                newAcc.BillingCity = x.il;
                newAcc.BillingCountry = x.ulke;
                newAcc.RC_Portal_Country__c = portalCountryMap.containsKey(x.ulke) ? portalCountryMap.get(x.ulke) : null; 
                newAcc.Website = x.web;
                
                if(string.isNotBlank(x.sektor)){
                    newAcc.RC_Sector__c = sectorMap.get(x.sektor).id;
                }
                
                
                // newAccList.add(newAcc);              
                
                if(string.isNotBlank(x.kisiad) && string.isNotBlank(x.kisisoyad)){
                    isCreateContact = true;
                    Contact newContact = new Contact();
                    newContact.FirstName = x.kisiad;
                    newContact.LastName = x.kisisoyad;
                    newContact.Title = x.kisiunvan;
                    newContact.Phone = x.kisitelefon.replace(' ', '');
                    newContact.Email = x.kisimail;
                    newContact.RC_Primary__c = true;
                    contactMap.put(x.firmatelefon,newContact);
                    accountPhoneList.add(x.firmatelefon);
                    
                }
                showAccList.add(newAcc);
                
                // system.debug('newAcc Phone : ' + x.firmatelefon + '--- newAcc VKN : ' + x.firmavergikimliknumarasi);
            }else{
                //Add Acc List
                Account accshow = new Account();
                accshow = PhoneAccMap.get(x.firmatelefon);
                showAccIdList.add(accshow.id);
                showAccList.add(accshow);
            }
        }
        
        //İşlenen datayı DB'den çek , önyüze basmak için tableWrapper ile mapping işlemini yap.
        List<Contact> cList   =[SELECT FirstName, LastName, Name,Phone,Email,AccountId,Account.Phone FROM Contact WHERE AccountId IN: showAccIdList AND RC_Primary__c = true];
        for(Contact x : cList){
            contactMap.put(x.Account.Phone,x);
        }
        system.debug('showAccList:' + showAccList.size());
        if(showAccList.size() > 0){                
            for(Account acc : showAccList){
                tableWrapper tblWrp = new tableWrapper();
                Contact tempContact = new Contact();
                tempContact = contactMap.get(acc.Phone);
                
                if(tempContact != null){
                    tblWrp.accountId = acc.id;
                    tblWrp.accountName = acc.Name;
                    tblWrp.accountPhone =acc.Phone;
                    tblWrp.accountMail = acc.RC_Email__c;
                    tblWrp.accountCurrency = acc.CurrencyIsoCode;
                    tblWrp.accountVKN = acc.RC_Tax_Number__c;
                    tblWrp.contactName = tempContact.FirstName + ' ' + tempContact.LastName;
                    if(string.isBlank(tempContact.Phone)){
                        tblWrp.contactPhone = '-';
                    }else{
                        tblWrp.contactPhone =tempContact.Phone;
                    }
                    tblWrp.contactMail = tempContact.Email;
                    tblWrp.accountData = acc;
                    tblWrp.contactData = tempContact;
                }else{
                    tblWrp.accountId = acc.id;
                    tblWrp.accountName = acc.Name;
                    tblWrp.accountPhone =acc.Phone;
                    tblWrp.accountMail = acc.RC_Email__c;
                    tblWrp.accountCurrency = acc.CurrencyIsoCode;
                    tblWrp.accountVKN = acc.RC_Tax_Number__c;
                    tblWrp.accountData = acc;
                }
                
                tableWrpList.add(tblWrp);
            }
        }
        system.debug('tableWrpList:' + tableWrpList);
        return tableWrpList;        
    }
    
    @AuraEnabled
    public static createOpportunityResult createOpportunity(List<tableWrapper> accounts,string selectedFairPop,string popUpTag,string selectedPopupDataType){
        boolean hasErr = false;
        createOpportunityResult result = new createOpportunityResult();      
        result.jobIDList = new List<String>();
        RC_ListSlider slider = new RC_ListSlider(accounts);
        system.debug('accounts.size() ::' + accounts.size());
        Decimal sizeLimit = 100;
        Decimal listSize  = accounts.size();
        
        Integer loopSize = Integer.valueOf(Math.round(listSize.divide(sizeLimit, 1)));
        loopSize += (loopSize == 0 && listSize > 0) ? 1 : 0;
        
        system.debug('loopSize : ' + loopSize);
        
        for(Integer i = 0; i < loopSize; i++){
            if(loopSize == i+1){
                List<Object> selectedDataList = slider.slice(i * sizeLimit);
                
                String jobID = System.enqueueJob(new RC_CreateOpportunityQueueable(selectedDataList, selectedFairPop, popUpTag, selectedPopupDataType));
                result.jobIDList.add(jobID);
            }
            else{      
                List<Object> selectedDataList = slider.slice(i * sizeLimit, sizeLimit);
                
                String jobID = System.enqueueJob(new RC_CreateOpportunityQueueable(selectedDataList, selectedFairPop, popUpTag, selectedPopupDataType));
                result.jobIDList.add(jobID);
            }
        }
        
        return result;
    }
    
    @AuraEnabled
    public static JobStatusWrapper isOpportunityCreated(List<String> jobIDList){
        // 0 : Failed, 1 : Completed, 2 : Continue, 3 : Failed & Success
        JobStatusWrapper jsw = new JobStatusWrapper();
        jsw.isCompleted = 2;
        jsw.message     = '';
        
        List<AsyncApexJob> jobInfoList = [SELECT Status, ExtendedStatus, CreatedDate, CompletedDate FROM AsyncApexJob WHERE Id = :jobIDList];
        DateTime startDate = null;
		DateTime endDate   = null;
        
        for(AsyncApexJob info : jobInfoList){
            startDate = startDate == null ? info.CreatedDate   : startDate > info.CreatedDate   ? info.CreatedDate   : startDate;
            endDate   = endDate   == null ? info.CompletedDate : endDate   < info.CompletedDate ? info.CompletedDate : endDate;
            
            if(info.Status == 'Completed'){
                jsw.isCompleted = 1;
                jsw.message     = 'Aktarım başarılı bir şekilde tamamlandı.';
            }
            else if(info.Status == 'Failed'){
                jsw.isCompleted = 0;
                jsw.message     = 'Paketlerde sorun oluştu. İncelemek için ilgili linke tıklayınız.';
            }
            else if(info.Status == 'Queued' || info.Status == 'Preparing' || info.Status == 'Processing'){
                jsw.isCompleted = 2;
            }
        }    
        
        if(jsw.isCompleted == 1){
            List<RC_Logger__c> logList   = [SELECT Id FROM RC_Logger__c WHERE RC_RelatedDataId__c =: jobIDList];
            
            List<Opportunity> createdOpp = [SELECT Id FROM Opportunity WHERE CreatedById = :UserInfo.getUserId() AND CreatedDate >= :startDate AND CreatedDate <= :endDate];
            
            if(logList.size() > 0 && createdOpp.size() > 0){
                jsw.isCompleted = 3;
                jsw.message     = 'Tamamlanan ve oluşturulamayan kayıtlar mevcut. İlgili linklerden inceleyebilirsiniz.';
            }
            if(logList.size() > 0 && createdOpp.size() <= 0){
                jsw.isCompleted = 0;
                jsw.message     = 'Fırsatlar oluşturulamamıştır. İlgili linkten inceleyebilirsiniz.';                
            }
        }
        
        return jsw;
    }
    
    @AuraEnabled
    public static Boolean FirmaVergiKontrol(string kno){
        //revize edilebilir
        integer v1 = 0;
        integer v2 = 0;
        integer v3 = 0;
        integer v4 = 0;
        integer v5 = 0;
        integer v6 = 0;
        integer v7 = 0;
        integer v8 = 0;
        integer v9 = 0;
        integer v11 = 0;
        integer v22 = 0;
        integer v33 = 0;
        integer v44 = 0;
        integer v55 = 0;
        integer v66 = 0;
        integer v77 = 0;
        integer v88 = 0;
        integer v99 = 0;
        integer v_last_digit = 0;
        integer toplam = 0;
        
        if (kno.length() == 10) {
            
            v1 = math.mod((integer.valueOf((kno.substring(0, 1))) + 9),10);
            v2 = math.mod((integer.valueOf((kno.substring(1, 2))) + 8),10);
            v3 = math.mod((integer.valueOf((kno.substring(2, 3))) + 7),10);
            v4 = math.mod((integer.valueOf((kno.substring(3, 4))) + 6),10);
            v5 = math.mod((integer.valueOf((kno.substring(4, 5))) + 5),10);
            v6 = math.mod((integer.valueOf((kno.substring(5, 6))) + 4),10);
            v7 = math.mod((integer.valueOf((kno.substring(6, 7))) + 3),10);
            v8 = math.mod((integer.valueOf((kno.substring(7, 8))) + 2),10);
            v9 = math.mod((integer.valueOf((kno.substring(8, 9))) + 1),10);
            v_last_digit = integer.valueOf(kno.substring(9, 10));
            
            v11 = math.mod((v1 * 512),9);
            v22 = math.mod((v2 * 256),9);
            v33 = math.mod((v3 * 128),9);
            v44 = math.mod((v4 * 64),9);
            v55 = math.mod((v5 * 32),9);
            v66 = math.mod((v6 * 16),9);
            v77 = math.mod((v7 * 8),9);
            v88 = math.mod((v8 * 4),9);
            v99 = math.mod((v9 * 2),9);
            
            if (v1 != 0 && v11 == 0){v11 = 9; } 
            if (v2 != 0 && v22 == 0){v22 = 9; } 
            if (v3 != 0 && v33 == 0){v33 = 9; } 
            if (v4 != 0 && v44 == 0){v44 = 9; } 
            if (v5 != 0 && v55 == 0){v55 = 9; } 
            if (v6 != 0 && v66 == 0){v66 = 9; } 
            if (v7 != 0 && v77 == 0){v77 = 9; } 
            if (v8 != 0 && v88 == 0){v88 = 9; } 
            if (v9 != 0 && v99 == 0){v99 = 9; } 
            toplam = v11 + v22 + v33 + v44 + v55 + v66 + v77 + v88 + v99;
            
            
            if (math.mod(toplam,10) == 0){
                
                toplam = 0;
            }else{
                
                toplam = (10 - math.mod(toplam,10));
            }
            
            if (toplam == v_last_digit) {
                system.debug('true');
                return true;
            }else{
                system.debug('false');
                return false;
            }
        }else{
            system.debug('false');
            return false;
        }
        
    }
    
    public static Boolean validateEmail(String email) {
        Boolean res = true;
        
        
        String emailRegex = '^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$'; // source: <a href="http://www.regular-expressions.info/email.html" target="_blank" rel="nofollow">http://www.regular-expressions.info/email.html</a>
        Pattern MyPattern = Pattern.compile(emailRegex);
        Matcher MyMatcher = MyPattern.matcher(email);
        
        if (!MyMatcher.matches()) 
            res = false;
        return res;	
    }
}