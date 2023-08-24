@isTest
public class RC_FixedPaymentControllerTest {
    
    @testsetup static void prepareData()
    { 
        RC_TestClassPaymentPlan.createTestDatas();
        RC_Fair__c fair=[SELECT Id From RC_Fair__c LIMIT 1];
        
        Pricebook2 priceBook= new Pricebook2();
        pricebook.Average_Maturity_Date__c=Date.today();
        pricebook.IsActive=true;
        pricebook.Name='Test Fiyat Listesi';
        pricebook.RC_Advance_Payment__c=30;
        pricebook.RC_Fair__c=fair.Id;
        pricebook.RC_Average_Maturity_Days__c=30;
        pricebook.RC_Country__c='Turkey';
        pricebook.RC_Start_Date__c=Date.today().addDays(7);
        pricebook.RC_End_Date__c=Date.today().addDays(30);
        pricebook.RC_Fixed_Payment_Plan__c=true;
        pricebook.RC_Number_of_Installments__c=5;
        pricebook.RC_Split_Tax__c=true;
        insert pricebook;
    }
    
    static testMethod void withoutFixedPlan(){
        Test.startTest();
        Pricebook2 pb=[SELECT ID FROM Pricebook2 LIMIT 1];
        RC_FixedPaymentController.Init(pb.Id);
        Test.stopTest();
    }
    static testMethod void fixedPlan(){
        Test.startTest();
        
        RC_Fair__c fair=[SELECT Id From RC_Fair__c LIMIT 1];
        Pricebook2 pb=[SELECT ID FROM Pricebook2 LIMIT 1];
        
        RC_Payment_Plan_Values__c fixedPay=new RC_Payment_Plan_Values__c();
        fixedPay.RC_Installment_Date__c=Date.today();
        fixedPay.RC_Installment_Number__c=1;
        fixedPay.RC_Installment_Payment_Type__c='Check';
        fixedPay.RC_Installment_Percentage__c=30;
        fixedPay.RC_Status__c=true;
        fixedPay.Price_Book__c=pb.Id;
        fixedPay.RC_Fair_Id__c=fair.Id;
        insert fixedPay;
        
        RC_Payment_Plan_Values__c fixedPay2=new RC_Payment_Plan_Values__c();
        fixedPay2.RC_Installment_Date__c=Date.today();
        fixedPay2.RC_Installment_Number__c=2;
        fixedPay2.RC_Installment_Payment_Type__c='Check';
        fixedPay2.RC_Installment_Percentage__c=20;
        fixedPay2.RC_Status__c=true;
        fixedPay2.Price_Book__c=pb.Id;
        fixedPay2.RC_Fair_Id__c=fair.Id;
        insert fixedPay2;    
        
        RC_Payment_Plan_Values__c fixedPay3=new RC_Payment_Plan_Values__c();
        fixedPay3.RC_Installment_Date__c=Date.today();
        fixedPay3.RC_Installment_Number__c=3;
        fixedPay3.RC_Installment_Payment_Type__c='Check';
        fixedPay3.RC_Installment_Percentage__c=20;
        fixedPay3.RC_Status__c=true;
        fixedPay3.Price_Book__c=pb.Id;
        fixedPay3.RC_Fair_Id__c=fair.Id;
        insert fixedPay3;    
        
        RC_Payment_Plan_Values__c fixedPay4=new RC_Payment_Plan_Values__c();
        fixedPay4.RC_Installment_Date__c=Date.today();
        fixedPay4.RC_Installment_Number__c=4;
        fixedPay4.RC_Installment_Payment_Type__c='Check';
        fixedPay4.RC_Installment_Percentage__c=30;
        fixedPay4.RC_Status__c=true;
        fixedPay4.Price_Book__c=pb.Id;
        fixedPay4.RC_Fair_Id__c=fair.Id;
        insert fixedPay4;   
        
        RC_FixedPaymentController.Init(pb.Id);

        List<RC_Payment_Plan_Values__c> payList=[SELECT Id,RC_Is_Tax_Payment__c,RC_Is_Advance_Payment__c,RC_Installment_Payment_Type__c,
                                                 RC_Installment_Percentage__c,RC_Installment_Number__c,RC_Installment_Date__c
                                                 FROM RC_Payment_Plan_Values__c];
        
        RC_FixedPaymentController.Save(pb.Id,payList);
        
        Test.stopTest();
    }

}