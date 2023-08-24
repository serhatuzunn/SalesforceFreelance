trigger RC_OpportunityDupCheck on Opportunity (before insert) {
    
    //[SELECT Id, Type FROM Opportunity WHERE Id =:]
    Map<Id,Opportunity> oppMap = new Map<Id,Opportunity>();
    Set<Id> fairIdList = new Set<Id>();
    for(Opportunity oppItem : Trigger.New)
    {
        if(oppItem.Type == 'RC_New' || String.isBlank(oppItem.Type))
        {
            oppMap.put(oppItem.Id,oppItem);
            fairIdList.add(oppItem.RC_Fair__c);
        }
    }
    List<Opportunity> currentOpps =  [SELECT Id,AccountId,RC_Fair__c FROM Opportunity WHERE RC_Fair__c =: fairIdList];
    for(Opportunity oppItem : currentOpps)
    {
        for(Id newOps : oppMap.keySet() )
        {
            Opportunity opp = oppMap.get(newOps);
            if(opp != null)
            {
                if(opp.AccountId == oppItem.AccountId && opp.RC_Fair__c == oppItem.RC_Fair__c)
                {
                    oppMap.get(opp.Id).addError(Label.RC_OppDupe);
                }
            }
        }
    }
}