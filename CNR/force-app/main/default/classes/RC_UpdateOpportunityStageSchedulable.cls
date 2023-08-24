global class RC_UpdateOpportunityStageSchedulable implements Schedulable, Database.AllowsCallouts{
    global void execute(SchedulableContext sc){       
        RC_CheckCanceledOpportunity.CheckAndUpdate();
    }
}