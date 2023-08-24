trigger RC_DeleteOpportunityLineItemTrigger on OpportunityLineItem (after delete) {
    
    system.debug('test:test:');
    for(OpportunityLineItem oppLi : Trigger.Old)
    {
        boolean success=true;
        try
        {
           // oppLi.Product2Id.addError('Hata Hata');
            Id agreementId=oppLi.OpportunityId;
            List<RC_Payment_Plan__c> payPlanList= [SELECT Id FROM RC_payment_Plan__c WHERE RC_Agreement__c=:agreementId];
            if(payPlanList.size()>0 && payPlanList!=null)
            {
                Database.DeleteResult[] drList = Database.delete(payPlanList, false);
                for(Database.DeleteResult dr : drList) {
                    if (dr.isSuccess()) {
                        continue;
                    }
                    else
                    {
                        success=false;
                    }
                }
                if(success)
                {
                    Opportunity opp= [SELECT Id,RC_Calculated_Maturity_Days__c,RC_Final_Total__c,RC_Subtotal__c,RC_Stamp_Duty__c,RC_Tax_Amount__c,Amount
                                      FROM Opportunity WHERE Id=:oppLi.OpportunityId];
                    if(opp!=null)
                    {
                        opp.RC_Calculated_Maturity_Days__c=null;
                        opp.RC_Subtotal__c=null;
                        opp.RC_Stamp_Duty__c=null;
                        opp.RC_Tax_Amount__c=null;
                        opp.Amount=null;
                        opp.RC_Entrance_Fee__c=0.00;
                        opp.RC_Final_Total__c=null;
                        update opp;
                    }
                }
            }   
        }
        catch(exception ex)
        {
            system.debug('catch:' + ex);
        }
        
    }
}