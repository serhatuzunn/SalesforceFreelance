@isTest
public class RC_PaymentPlanControllerTest {
    
    @testsetup static void prepareData(){  
        
        RC_TestClassPaymentPlan.createTestDatas();
        
        Opportunity agg = [SELECT Id FROM Opportunity LIMIT 1];
        
        agg.Amount = 50;
        agg.RC_Sales_Organisation__c = 'Domestic';
        update agg;
        
        RC_Payment_Plan__c testPaymentPlan1 = new RC_Payment_Plan__c(
            RC_Installment__c = 1,
            RC_Active__c = true,
            RC_Agreement__c = agg.Id,
            RC_Payment_Amount__c = 1000.00,
            RC_Payment_Type__c = 'Cash',
            RC_Sales_Person_Check__c = true,
            RC_Finance_Check__c = true,
            RC_Collector_Check__c = true,
            RC_Payment_Date__c = Date.today().addDays(60)
        );
        insert testPaymentPlan1;
        
        RC_Payment_Plan__c testPaymentPlan2 = new RC_Payment_Plan__c(
            RC_Installment__c = 2,
            RC_Active__c = true,
            RC_Agreement__c = agg.Id,
            RC_Payment_Amount__c = 2000.00,
            RC_Payment_Type__c = 'Cash',
            RC_Sales_Person_Check__c = true,
            RC_Finance_Check__c = false,
            RC_Collector_Check__c = false,
            RC_Payment_Date__c = Date.today().addDays(90)
        );
        insert testPaymentPlan2;
    }
    
    static testMethod void aggWithPlan(){  
        Test.startTest();
        
        Opportunity agg = [SELECT Id FROM Opportunity WHERE StageName = 'Unassigned' LIMIT 1];
        List<RC_Payment_Plan__c> ppList = [SELECT Id, RC_Installment__c, RC_Active__c, RC_Agreement__c, RC_Payment_Amount__c, RC_Payment_Type__c, RC_Sales_Person_Check__c,
                                           RC_Finance_Check__c, RC_Collector_Check__c, RC_Payment_Date__c FROM RC_Payment_Plan__c WHERE RC_Agreement__c = :agg.Id];
        
        RC_PaymentPlanController.getInit(agg.Id);
        RC_PaymentPlanController.CalculateAvgMaturity(JSON.serialize(ppList), agg.Id);
        RC_PaymentPlanController.SavePaymentPlan(JSON.serialize(ppList), agg.Id, '5',null,'2020-02-02');
        RC_PaymentPlanController.SavePaymentPlan(JSON.serialize(ppList), agg.Id, '5',null,'2020-02-02');
        
        Test.stopTest();
    }
    static testMethod void aggWithPlan2(){
        Test.startTest();
        
        Opportunity agg = [SELECT Id FROM Opportunity WHERE StageName = 'Unassigned' LIMIT 1];
        List<RC_Payment_Plan__c> ppList = [SELECT Id, RC_Installment__c, RC_Active__c, RC_Agreement__c, RC_Payment_Amount__c, RC_Payment_Type__c, RC_Sales_Person_Check__c,
                                           RC_Finance_Check__c, RC_Collector_Check__c, RC_Payment_Date__c FROM RC_Payment_Plan__c WHERE RC_Agreement__c = :agg.Id];
        
        RC_PaymentPlanController.SaveChecks(JSON.serialize(ppList), agg.Id);
        RC_PaymentPlanController.getCorporateCurrency();
        RC_PaymentPlanController.getCurrencyRate('EUR', Date.today());
        
        Test.stopTest();
    }
    
    static testMethod void aggWithoutPlan(){
        Test.startTest();
        
        Opportunity agg = [SELECT Id FROM Opportunity WHERE StageName = 'Potential' LIMIT 1];
        
        RC_PaymentPlanController.getInit(agg.Id);
        RC_PaymentPlanController.getCurrencyRate('TRY', Date.today());
        
        Test.stopTest();
    }
    
    static testMethod void aggWithoutFixedPay(){
        Test.startTest();
        
        Opportunity agg = [SELECT Id, StageName FROM Opportunity WHERE StageName = 'Potential' LIMIT 1];

        agg.Amount = 50;
        agg.RC_Sales_Organisation__c = 'Domestic';
        update agg;
        
        RC_Payment_Plan__c testPaymentPlan1 = new RC_Payment_Plan__c(
            RC_Installment__c = 1,
            RC_Active__c = true,
            RC_Agreement__c = agg.Id,
            RC_Payment_Amount__c = 1000.00,
            RC_Payment_Type__c = 'Cash',
            RC_Sales_Person_Check__c = true,
            RC_Finance_Check__c = true,
            RC_Collector_Check__c = true,
            RC_Payment_Date__c = Date.today().addDays(60)
        );
        insert testPaymentPlan1;
        
        RC_Payment_Plan__c testPaymentPlan2 = new RC_Payment_Plan__c(
            RC_Installment__c = 2,
            RC_Active__c = true,
            RC_Agreement__c = agg.Id,
            RC_Payment_Amount__c = 2000.00,
            RC_Payment_Type__c = 'Cash',
            RC_Sales_Person_Check__c = true,
            RC_Finance_Check__c = false,
            RC_Collector_Check__c = false,
            RC_Payment_Date__c = Date.today().addDays(90)
        );
        insert testPaymentPlan2;
        
        List<RC_Payment_Plan__c> ppList = [SELECT Id, RC_Installment__c, RC_Active__c, RC_Agreement__c, RC_Payment_Amount__c, RC_Payment_Type__c, RC_Sales_Person_Check__c,
                                           RC_Finance_Check__c, RC_Collector_Check__c, RC_Payment_Date__c FROM RC_Payment_Plan__c WHERE RC_Agreement__c = :agg.Id];
        
        RC_PaymentPlanController.FixedPaymentPlanWrapper fixed = new RC_PaymentPlanController.FixedPaymentPlanWrapper();
        fixed.fixedPaymentPlan = true;
        fixed.fixedPaymentSplitTax = true;
        fixed.fixedPaymentType = 'Cash';
        fixed.fixedPaymentStartMonth = '10';
        fixed.fixedPaymentDay = '1';
        fixed.fixedTaxDate = Date.newInstance(2021,01,01);
        
        RC_PaymentPlanController.getInit(agg.Id);
        RC_PaymentPlanController.getCorporateCurrency();
        RC_PaymentPlanController.CalculateAvgMaturity(JSON.serialize(ppList), agg.Id);
        RC_PaymentPlanController.SavePaymentPlan(JSON.serialize(ppList), agg.Id, '5',fixed,'2020-02-02');
        RC_PaymentPlanController.SaveChecks(JSON.serialize(ppList), agg.Id);
        
        Test.stopTest();
    }
}