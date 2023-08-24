public class RC_FixedPaymentController {
    
    public class SelectOptionWrapper
    {
        @AuraEnabled
        public String label {get;set;}
        @AuraEnabled
        public String value {get;set;}
    }
    
    public class initWrapper
    {
        @AuraEnabled
        public List<SelectOptionWrapper> paymentTypes{get;set;}
        @AuraEnabled
        public List<RC_Payment_Plan_Values__c> payList {get;set;}
        @AuraEnabled
        public boolean agreementStatus{get;set;}
    }
    
    public class returnWrapper
    {
        @AuraEnabled
        public boolean returnStatus{get;set;}
        @AuraEnabled
        public string returnMessage{get;set;}
    }
    
    
    @AuraEnabled
    public static List<SelectOptionWrapper> getPaymentType(boolean moneyOrder)
    {
        List<SelectOptionWrapper> TypeList = new List<SelectOptionWrapper>();
        SelectOptionWrapper opt = new SelectOptionWrapper();
        Schema.DescribeFieldResult fieldResult = RC_Payment_Plan__c.RC_Payment_Type__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            if(!moneyOrder && pickListVal.getValue()=='Cash'){
                continue;
            }
            opt = new SelectOptionWrapper();
            opt.label = pickListVal.getLabel();
            opt.value = pickListVal.getValue();
            TypeList.add(opt);
        }
        return TypeList;
    }
    
    @AuraEnabled
    public static initWrapper Init(Id recordId)
    {
        
        boolean moneyOrder=false;
        initWrapper initWrp=new initWrapper();
        initWrp.agreementStatus=false;
        
        List<RC_Payment_Plan_Values__c> fixedPaymentPlanList= new List<RC_Payment_Plan_Values__c>();
        List<Pricebook2> priceBookInfo=[SELECT Id,RC_Tax_Include__c,RC_Split_Tax__c,RC_Number_of_Installments__c,RC_Fixed_Payment_Plan__c,RC_Fair__c FROM Pricebook2 WHERE Id=:recordId];
        if(priceBookInfo.size()>0)
        {
            
            //Bu plan ile oluşturulmuş bir sözleşme var ise sabit ödeme planı değiştirilemez.
            List<Opportunity> agreementList=[SELECT Id From Opportunity WHERE Pricebook2.Id=:priceBookInfo[0].Id ];
            if(agreementList!=null && agreementList.size()>0)
            {
                initWrp.agreementStatus=true;
                
            }
            
            //Havale Yapılabilir mi kontrolü burada yapılır.
            List<RC_Fair__c> fair=[SELECT Id,RC_Money_Order__c FROM RC_Fair__c WHERE Id=:priceBookInfo[0].RC_Fair__c];
            if(fair!=null && fair.size()>0)
                moneyOrder=fair[0].RC_Money_Order__c;
            if(priceBookInfo[0].RC_Fixed_Payment_Plan__c)
            {
                
                system.debug('pricebook:' + priceBookInfo[0].Id);
                fixedPaymentPlanList=[SELECT Id,RC_Installment_Date__c,RC_Installment_Percentage__c,RC_Installment_Payment_Type__c,Price_Book__c,RC_Installment_Number__c,RC_Is_Advance_Payment__c,RC_Is_Tax_Payment__c
                                      FROM RC_Payment_Plan_Values__c WHERE Price_Book__c=:priceBookInfo[0].Id and RC_Status__c=true];
                
                //Daha önce plan oluşturulmadıysa fiyat listesi üzerindeki taksit adetine göre oluşturulur.
                if(!(fixedPaymentPlanList.size()>0))
                {
                    RC_Payment_Plan_Values__c advancePayment= new RC_Payment_Plan_Values__c();
                    advancePayment.RC_Installment_Number__c=1;
                    advancePayment.RC_Is_Advance_Payment__c=true;
                    advancePayment.RC_Is_Tax_Payment__c=false;
                    advancePayment.RC_Fair_Id__c=priceBookInfo[0].RC_Fair__c;
                    fixedPaymentPlanList.add(advancePayment);
                    
                    for(integer i=2; i<= priceBookInfo[0].RC_Number_of_Installments__c + 1; i++)
                    {
                        RC_Payment_Plan_Values__c installment= new RC_Payment_Plan_Values__c();
                        installment.RC_Installment_Number__c=i;
                        installment.RC_Is_Advance_Payment__c=false;
                        installment.RC_Is_Tax_Payment__c=false;
                        installment.RC_Fair_Id__c=priceBookInfo[0].RC_Fair__c;
                        fixedPaymentPlanList.add(installment);
                    }
                    if(priceBookInfo[0].RC_Split_Tax__c)
                    {
                        RC_Payment_Plan_Values__c taxPayment= new RC_Payment_Plan_Values__c();
                        taxPayment.RC_Installment_Number__c=priceBookInfo[0].RC_Number_of_Installments__c + 2;
                        taxPayment.RC_Is_Advance_Payment__c=false;
                        taxPayment.RC_Is_Tax_Payment__c=true;
                        taxPayment.RC_Fair_Id__c=priceBookInfo[0].RC_Fair__c;
                        fixedPaymentPlanList.add(taxPayment);   
                    }
                    
                }
                
            }
        }
        initWrp.payList=fixedPaymentPlanList;
        initWrp.paymentTypes=getPaymentType(moneyOrder);
        system.debug('fixedPaymentPlanList:' + fixedPaymentPlanList);
        return initWrp;
    }
    
    @AuraEnabled
    public static returnWrapper Save(Id recordId,List<RC_Payment_Plan_Values__c> paymValues)
    {
        string errorMsg='';
        returnWrapper returnWrp=new returnWrapper();
        decimal totalInstPercentage=0.00;
        Pricebook2 priceBook=[SELECT Id,RC_Fair__c FROM Pricebook2 WHERE Id=:recordId LIMIT 1];
        List<RC_Payment_Plan_Values__c> paymentPlanList= new List<RC_Payment_Plan_Values__c>();
        try
        {
            if(paymValues.size()>0)
            {
                for(RC_Payment_Plan_Values__c paym : paymValues)
                {
                    RC_Payment_Plan_Values__c payment= new RC_Payment_Plan_Values__c();
                    payment.RC_Installment_Date__c=paym.RC_Installment_Date__c;
                    payment.RC_Installment_Number__c=paym.RC_Installment_Number__c;
                    payment.RC_Installment_Percentage__c=paym.RC_Installment_Percentage__c;
                    payment.RC_Installment_Payment_Type__c=paym.RC_Installment_Payment_Type__c;
                    payment.Price_Book__c=priceBook.Id;
                    payment.RC_Fair_Id__c=pricebook.RC_Fair__c;
                    payment.RC_Is_Advance_Payment__c=paym.RC_Is_Advance_Payment__c;
                    payment.RC_Is_Tax_Payment__c=paym.RC_Is_Tax_Payment__c;
                    payment.RC_Status__c=true;
                    paymentPlanList.add(payment);
                    totalInstPercentage +=!paym.RC_Is_Tax_Payment__c ? paym.RC_Installment_Percentage__c : 0;
                    integer payDate=date.ValueOf(paym.RC_Installment_Date__c).day();
                    system.debug('payDate:' + payDate);
                     if(payDate>=25)
                    errorMsg+='error'; 
                }
                system.debug('errorMsg:' + errorMsg);
                if(string.isNotBlank(errorMsg)){returnWrp.returnStatus=false; returnWrp.returnMessage='İlgili ayın 25 inden sonra ödeme yapılamaz.';} 
                else if(totalInstPercentage!=100){returnWrp.returnStatus=false; returnWrp.returnMessage='Peşinat ve taksit yüzdeleri toplamını kontrol ediniz.';} 
                
                else
                {
                    
                    List<RC_Payment_Plan_Values__c> oldPaymentPlanList=[SELECT Id,RC_Installment_Date__c,RC_Installment_Percentage__c,RC_Installment_Payment_Type__c,Price_Book__c,RC_Installment_Number__c,RC_Is_Advance_Payment__c,RC_Is_Tax_Payment__c
                                                                        FROM RC_Payment_Plan_Values__c WHERE Price_Book__c=:recordId and RC_Status__c=true];
                    for(RC_Payment_Plan_Values__c oldPaym : oldPaymentPlanList)
                    {
                        oldPaym.RC_Status__c=false;
                    }
                    List<Database.SaveResult> paymList =Database.update(oldPaymentPlanList);
                    for(DataBase.SaveResult res : paymList) {
                        if(res.isSuccess() == true)
                            continue; 
                        else
                        {
                            returnWrp.returnStatus=false;
                            break;   
                        }
                        
                    }
                    List<Database.SaveResult> pList =Database.insert(paymentPlanList, false);
                    for(DataBase.SaveResult theResult : pList) {
                        if(theResult.isSuccess() == true){
                            continue;
                            system.debug('test');
                        }
                        else
                            returnWrp.returnStatus=false;
                    }
                    returnWrp.returnStatus=true;
                }
                
                
            }
        }
        catch(exception ex)
        {
            system.debug('error:' +  ex);
            returnWrp.returnStatus=false;
        }
        return returnWrp;
    }

    
}