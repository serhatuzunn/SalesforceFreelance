trigger RC_UpdateOpportunityCurrencyISOCode on Opportunity (before insert,before update) {
    system.debug('test:test:');
    for(Opportunity opp : Trigger.New)
    {
        if(opp.RC_Sales_Organisation__c=='Foreign')
        {
            opp.CurrencyIsoCode='EUR';

        }
    }
}