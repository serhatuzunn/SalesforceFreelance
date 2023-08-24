public class RC_CreateOpportunityQueueable implements Queueable {
    
    public class CustomException extends Exception{}
    
    public List<Object> accounts {get; set;}
    public String selectedFairPop {get; set;}
    public String popUpTag {get; set;}
    public String selectedPopupDataType {get; set;}
    
    public RC_CreateOpportunityQueueable(List<Object> accounts, string selectedFairPop, string popUpTag, string selectedPopupDataType){
        this.accounts = accounts ;  
        this.selectedFairPop = selectedFairPop;
        this.popUpTag = popUpTag;
        this.selectedPopupDataType = selectedPopupDataType;
    }
    
    public void execute(QueueableContext context) {    
        List<String> accIdList			= new List<String>();
        List<String> oppIdList 	 	 	= new List<String>();
        List<Account> insertAccountList = new List<Account>();
        List<Contact> insertContactList = new List<Contact>();    
        List<Opportunity> oppList       = new List<Opportunity>();
        List<Opportunity> newOppList    = new List<Opportunity>();
        List<RC_Logger__c> logList      = new List<RC_Logger__c>();
        Map<String, Account> accountMap = new Map<String, Account>();        
        Map<string,Opportunity> oppMap  = new Map<string,Opportunity>();
        
        try{
            RC_Fair__c fair = [SELECT Name FROM RC_Fair__c WHERE id =:selectedFairPop limit 1];
            
            for(Object data : accounts){
                RC_CreateOpportunityController.tableWrapper convertedData = (RC_CreateOpportunityController.tableWrapper)data;
                
                if(String.isBlank(convertedData.accountId)){
                    insertAccountList.add(convertedData.accountData);
                }
                else{
                    accIdList.add(convertedData.accountId);
                }
            }
            
            List<Database.SaveResult> srListForAccount = Database.insert(insertAccountList, false);
            
            for(Database.SaveResult sr : srListForAccount){
                if(sr.isSuccess()){
                    accIdList.add(sr.getId());
                }
                else{
                    for(Database.Error err : sr.getErrors()){
                        System.debug('Account Error Log : ' + err.getMessage());
                        logList.add(RC_Logger.CREATELOG(err.getMessage(), 'Field : ' + err.getFields(), '', 'Create Opportunity Queueable', 'Execute', '', context.getJobId(), 'Account'));
                    }
                }
            }        
            
            if(accIdList.size() > 0){
                for(Account acc : [SELECT Id, Phone, Name, RC_Portal_Country__c FROM Account WHERE Id =: accIdList]){
                    accountMap.put(acc.Phone, acc);
                }
                
                for(Object data : accounts){
                    RC_CreateOpportunityController.tableWrapper convertedData = (RC_CreateOpportunityController.tableWrapper)data;
                    
                    if(convertedData.contactData != null){
                        String accountId = accountMap.containsKey(convertedData.accountData.Phone) ? accountMap.get(convertedData.accountData.Phone).Id : null;
                        
                        if(accountId == null){
                            continue;
                        }
                        else{
                            convertedData.contactData.AccountId = accountId;
                        }
                        
                        if(convertedData.contactData != null){
                            if(String.isBlank(convertedData.contactData.Id)){
                                insertContactList.add(convertedData.contactData);    
                                System.debug('Phone : ' + convertedData.contactData.Phone);
                            }  
                            else{
                                logList.add(RC_Logger.CREATELOG(convertedData.contactData.FirstName + ' ' + convertedData.contactData.LastName + ' Contact bilgisi içeride mevcut.', '', '', 'Create Opportunity Queueable', 'Execute', '', context.getJobId(), 'Contact'));
                            }
                        }                        
                    }
                }
                
                List<Database.SaveResult> srListForContact = Database.insert(insertContactList, false);
                
                for(Database.SaveResult sr : srListForContact){
                    if(!sr.isSuccess()){
                        for(Database.Error err : sr.getErrors()){      
                            System.debug('Contact Error Log : ' + err.getMessage());              
                            logList.add(RC_Logger.CREATELOG(err.getMessage(), 'Field : ' + err.getFields(), '', 'Create Opportunity Queueable', 'Execute', '', context.getJobId(), 'Contact'));
                        }
                    }
                }
                
                
                
                
                for(Account acc : accountMap.values()){
                    Opportunity opp = new Opportunity();
                    opp.AccountId 	    = acc.Id;
                    opp.RC_Fair__c	    = selectedFairPop;
                    opp.StageName		='Unassigned';
                    opp.CloseDate		= system.Date.today().addMonths(1);
                    string oppName      = fair.Name + ' ' + acc.Name;
                    opp.Name			= oppName.left(115) + '...';
                    opp.RC_Tag__c		= popUpTag;
                    opp.RC_Data_Type__c = selectedPopupDataType;
                    opp.RC_Portal_Country__c = acc.RC_Portal_Country__c;
                    
                    oppList.add(opp); 
                    oppMap.put(acc.Id + selectedFairPop, opp);   
                }        
                
                List<Opportunity> currentOppList = [SELECT Id, AccountId, Account.Name, RC_Fair__c, StageName FROM Opportunity WHERE AccountId =: accIdList AND RC_Fair__c =: selectedFairPop AND StageName != 'Canceled'];
                
                for(Opportunity y : currentOppList){
                    string key = string.valueOf(y.AccountId) + y.RC_Fair__c;
                    
                    if(oppMap.ContainsKey(key)){
                        System.debug('Remove Opp : ' + y.Account.Name + ' kullanıcısı için opportunity mevcut.');
                        logList.add(RC_Logger.CREATELOG(y.Account.Name + ' kullanıcısı için opportunity mevcut.', '', '', 'Create Opportunity Queueable', 'Execute', '', context.getJobId(), 'Opportunity'));
                        oppMap.remove(key);
                    }
                }
                
                if(oppMap.values().size() > 0){
                    List<Database.SaveResult> srListForOpportunity = Database.insert(oppMap.values(), false);
                    
                    for(Database.SaveResult sr : srListForOpportunity){
                        if(!sr.isSuccess()){
                            for(Database.Error err : sr.getErrors()){
                                System.debug('Opportunity Error Log : ' + err.getMessage());   
                                logList.add(RC_Logger.CREATELOG(err.getMessage(), 'Field : ' + err.getFields(), '', 'Create Opportunity Queueable', 'Execute', '', context.getJobId(), 'Opportunity'));
                            }
                        }
                        else{
                            oppIdList.add(sr.getId());
                        }
                    }   
                }   
                else{            
                    logList.add(RC_Logger.CREATELOG('İlgili accountların opportunity kaydı bulunduğundan opportunity oluşturulamamıştır', '', '', 'Create Opportunity Queueable', 'Execute', '', context.getJobId(), 'Opportunity'));
                	throw new CustomException('İlgili accountların opportunity kaydı bulunduğundan opportunity oluşturulamamıştır.');
                }
                
                if(oppIdList.size() < accIdList.size()){
                    logList.add(RC_Logger.CREATELOG('İçeride ilgili accountlarla ilgili kayıt bulunduğundan her account için opportunity oluşturulamamıştır', '', '', 'Create Opportunity Queueable', 'Execute', '', context.getJobId(), 'Opportunity'));        
                	throw new CustomException('İçeride ilgili accountlarla ilgili kayıt bulunduğundan her account için opportunity oluşturulamamıştır.');
                }
            }  
            else{
                logList.add(RC_Logger.CREATELOG('İlgili accountların hepsi içeride mevcut', '', '', 'Create Opportunity Queueable', 'Execute', '', context.getJobId(), 'Account'));                
                throw new CustomException('İlgili accountların hepsi içeride mevcut.');
            }
        }
        catch(Exception ex){
            if(logList.size() > 0){List<Database.SaveResult> srListForLog = Database.insert(logList, false);}
        }
    }
}