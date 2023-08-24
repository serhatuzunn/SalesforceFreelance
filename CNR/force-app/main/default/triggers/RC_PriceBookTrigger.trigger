trigger RC_PriceBookTrigger on Pricebook2 (after insert, after delete, after update) {
    Set<String> fairSet = new Set<String>();
    //Map<String,String> salesOrg = new Map<String,String>();
    for(Pricebook2 pricebook : Trigger.New){
        if(pricebook.IsActive){
            fairSet.add(pricebook.RC_Fair__c);
            //salesOrg.put(pricebook.RC_Fair__c,pricebook.RC_Sales_Organisation__c);
        }
    }
    RC_Fair__c[] fairs = [SELECT Id,RC_Pricelist_Count_Domestic__c,RC_Pricelist_Count_Foreign__c FROM RC_Fair__c WHERE Id =: fairSet];
    
    //Pricebook2[] ForeignPriceList = [SELECT Id FROM Pricebook2 WHERE RC_Fair__c =: fairSet and RC_Sales_Organisation__c =: 'Foreign' and IsActive=true];    
    //Pricebook2[] DomesticPriceList = [SELECT Id FROM Pricebook2 WHERE RC_Fair__c =: fairSet and RC_Sales_Organisation__c =: 'Domestic' and IsActive=true];
    
    for(RC_Fair__c fair : fairs){
        fair.RC_Pricelist_Count_Foreign__c = [SELECT Id FROM Pricebook2 WHERE RC_Fair__c =: fair.Id and RC_Sales_Organisation__c =: 'Foreign' and IsActive=true].size();
        fair.RC_Pricelist_Count_Domestic__c = [SELECT Id FROM Pricebook2 WHERE RC_Fair__c =: fair.Id and RC_Sales_Organisation__c =: 'Domestic' and IsActive=true].size();        
    }
    Database.SaveResult[] srList = Database.update(fairs);
    System.debug('RC_PriceBookTrigger : SaveResult -> ' + srList);    
}