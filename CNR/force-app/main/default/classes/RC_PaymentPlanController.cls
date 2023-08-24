public without sharing class RC_PaymentPlanController {
    
    public class initWrapper{
        @AuraEnabled
        public Opportunity opportunity{get;set;}
        @AuraEnabled
        public List<RC_Payment_Plan__c> PaymentPlan{get;set;}
        @AuraEnabled
        public List<SelectOptionWrapper> paymentTypes{get;set;}
        @AuraEnabled
        public FixedPaymentPlanWrapper fixedPayWrapper{get;set;}
        @AuraEnabled
        public RC_Fair__c fairInfo{get;set;}
        @AuraEnabled
        public double advancePayment{get;set;}
        @AuraEnabled
        public date advanceDate{get;set;}
        @AuraEnabled
        public boolean moneyOrder{get;set;}
        @AuraEnabled
        public string userProfile{get;set;}
        @AuraEnabled
        public Decimal calculatedAdvancePaymentAmount {get;set;}
        @AuraEnabled
        public Date advancePaymentDate {get;set;}
    }
    
    public class SelectOptionWrapper{
        @AuraEnabled
        public String label {get;set;}
        @AuraEnabled
        public String value {get;set;}
    }
    
    public class CalculateWrapper{
        @AuraEnabled
        public RC_Payment_Plan__c paymentPlan {get;set;}
        @AuraEnabled
        public boolean hasError{get;set;}
        @AuraEnabled
        public decimal totalPayment{get;set;}
        @AuraEnabled
        public decimal totalInstPayment{get;set;}
        @AuraEnabled
        public decimal diffPayment{get;set;}
    }
    
    public class PaymentPlanWrapper{
        @AuraEnabled
        public List<RC_Payment_Plan__c> paymentPlanLst {get;set;}
        @AuraEnabled
        public boolean calculatedPlan{get;set;} 
        @AuraEnabled
        public Decimal calculatedAdvancePayment {get;set;}
        @AuraEnabled
        public Date advancePaymentDate {get;set;}
    }
    
    public class FixedPaymentPlanWrapper{
        @AuraEnabled
        public boolean fixedPaymentPlan{get;set;}
        @AuraEnabled
        public boolean fixedPaymentSplitTax{get;set;}
        @AuraEnabled
        public string fixedPaymentDay{get;set;}
        @AuraEnabled
        public string fixedPaymentStartMonth{get;set;}
        @AuraEnabled
        public string fixedPaymentType{get;set;}
        @AuraEnabled
        public Date fixedTaxDate{get;set;}
    }
    
    @AuraEnabled
    public static initWrapper getInit(Id recordId){
        
        boolean moneyOrder=false;
        
        Id profileId=userinfo.getProfileId();
        String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
        
        initWrapper initWrp = new initWrapper();
        fixedPaymentPlanWrapper fixedPayWrapper= new fixedPaymentPlanWrapper();
        fixedPayWrapper.fixedPaymentPlan=false;
        Account acc=new Account();
        List<Opportunity> agg= [SELECT Id,AccountId,RC_Final_Total__c,RC_Average_Maturity_Days__c,CreatedDate,RC_Average_Maturity_Date__c,CloseDate,Amount,RC_Number_of_Installments__c,
                                RC_Fair__c,Pricebook2Id,RC_Agreement_Advance_Payment__c,StageName,RC_Agreement_Exchange_Rate__c,CurrencyIsoCode FROM Opportunity WHERE Id=:recordId];
        if(agg.size()>0){
            acc=[SELECT Id,RC_Money_Order__c FROM Account WHERE Id=:agg[0].AccountId];
            initWrp.opportunity=agg[0];
            List<RC_Fair__c> fairInfo=[SELECT Id,RC_Sales_Person_Maturity_Day__c,RC_Money_Order__c,RC_Start_Date__c , RC_End_Date__c
                                       FROM RC_Fair__c WHERE Id=:agg[0].RC_Fair__c];
            List<Pricebook2> priceBookInfo=[SELECT Id,RC_Tax_Include__c,RC_Split_Tax__c,RC_Number_of_Installments__c,RC_Fixed_Payment_Plan__c FROM Pricebook2 where id=:agg[0].Pricebook2Id];
            if(fairInfo!=null && fairInfo.size()>0 && pricebookInfo!=null && pricebookInfo.size()>0){
                
                initWrp.fairInfo=fairInfo[0];
                initWrp.advanceDate=date.valueOf(agg[0].CreatedDate).addDays(15);
                if(pricebookInfo[0].RC_Fixed_Payment_Plan__c)
                {
                    fixedPayWrapper.fixedPaymentPlan=pricebookInfo[0].RC_Fixed_Payment_Plan__c;
                    fixedPayWrapper.fixedPaymentSplitTax=pricebookInfo[0].RC_Split_Tax__c;
                    initWrp.fixedPayWrapper=fixedPayWrapper;
                }
                else
                    initWrp.fixedPayWrapper=null; 
                
                moneyOrder=fairInfo[0].RC_Money_Order__c;
                
                if(agg[0].RC_Agreement_Advance_Payment__c!=null && agg[0].RC_Agreement_Advance_Payment__c > 0 && agg[0].RC_Final_Total__c!=null && agg[0].RC_Final_Total__c>0)
                {
                    if(agg[0].RC_Final_Total__c>0 && agg[0].RC_Agreement_Advance_Payment__c>0)
                        initWrp.advancePayment=Math.floor(agg[0].RC_Final_Total__c / agg[0].RC_Agreement_Advance_Payment__c);
                }
                
            } 
        }
        if(!moneyOrder)
        {
            if(string.isNotBlank(acc.Id))
                moneyOrder=acc.RC_Money_Order__c;
        }
        
        List<SelectOptionWrapper> paymentTypeList=getPaymentType(moneyOrder);
        initWrp.paymentTypes=paymentTypeList;
        initWrp.moneyOrder=moneyOrder;
        initWrp.userProfile=profileName;
        if(fixedPayWrapper!=null && fixedPayWrapper.fixedPaymentPlan){
            PaymentPlanWrapper ppw = GetPaymentPlan(recordId,fixedPayWrapper);
            system.debug('Payment Plan Wrapper Fixed : ' + ppw.calculatedAdvancePayment);
            system.debug('Payment Plan Wrapper Fixed : ' + ppw.advancePaymentDate);
            initWrp.PaymentPlan=ppw.paymentPlanLst;
            initWrp.calculatedAdvancePaymentAmount = ppw.calculatedAdvancePayment;
            initWrp.advancePaymentDate = ppw.advancePaymentDate;
        }
        else{
            PaymentPlanWrapper ppw = GetPaymentPlan(recordId,null);
            system.debug('Payment Plan Wrapper : ' + ppw.calculatedAdvancePayment);
            system.debug('Payment Plan Wrapper : ' + ppw.advancePaymentDate);
            initWrp.PaymentPlan=ppw.paymentPlanLst;
            initWrp.calculatedAdvancePaymentAmount = ppw.calculatedAdvancePayment;
            initWrp.advancePaymentDate = ppw.advancePaymentDate;
        }
        
        return initWrp;
    }
    
    @AuraEnabled
    public static List<SelectOptionWrapper> getPaymentType(boolean moneyOrder){
        List<SelectOptionWrapper> TypeList = new List<SelectOptionWrapper>();
        SelectOptionWrapper opt = new SelectOptionWrapper();
        Schema.DescribeFieldResult fieldResult = RC_Payment_Plan__c.RC_Payment_Type__c.getDescribe();
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
    public static paymentPlanWrapper GetPaymentPlan(string recordId,FixedPaymentPlanWrapper fixedPayWrapper){
        
        Id profileId=userinfo.getProfileId();
        String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
        
        
        paymentPlanWrapper payPlanWrapper= new paymentPlanWrapper();
        List<RC_Payment_Plan__c> paymentPlanList=new List<RC_Payment_Plan__c>();
        
        paymentPlanList=[SELECT Id,RC_Installment__c,RC_Payment_Type__c,RC_Payment_Date__c,RC_Payment_Amount__c,
                         RC_Collector_Check__c,RC_Finance_Check__c,RC_Sales_Person_Check__c,RC_Is_Tax__c,RC_Payment_Plan_Owner_Profile__c,RC_Currency_Rate__c
                         FROM RC_Payment_Plan__c WHERE RC_Agreement__c=:recordId and RC_Active__c=true
                         ORDER BY RC_Installment__c]; 
        
        
        if(paymentPlanList.size()<=0){
            
            List<Opportunity> agg= [SELECT Id,RC_Average_Maturity_Days__c,RC_Average_Maturity_Date__c,RC_Final_Total__c,CloseDate,Pricebook2Id,
                                    Amount,RC_Number_of_Installments__c,RC_Fair__c,RC_Agreement_Advance_Payment__c,RC_Tax_Amount__c,CurrencyIsoCode,RC_Agreement_Exchange_Rate__c
                                    FROM Opportunity WHERE Id=:recordId];
            if(agg.size()>0){
                
                //Para birimi TRY olmayan sözleşmelerde o güne ait kur okunur.
                decimal currRate=1.00;
                if(agg[0].CurrencyIsoCode!='TRY')
                {
                    currRate=  getCurrencyRate(agg[0].CurrencyIsoCode,Date.today());
                    
                }
                system.debug('pricebook' + agg[0]);
                Pricebook2 pricebook=new Pricebook2();
                if(agg[0].Pricebook2Id!=null)
                    pricebook=[SELECT Id,RC_Tax_Include__c,RC_Tax_Date__c,RC_Split_Tax__c from Pricebook2 where Id=:agg[0].Pricebook2Id LIMIT 1];
                
                decimal totalAmount=0.00;
                
                
                //Sabit Ödeme Planı
                if(fixedPayWrapper!=null)
                {
                    List<RC_Payment_Plan_Values__c> fixedPaymentPlan = [SELECT Id,RC_Installment_Date__c,RC_Installment_Percentage__c,RC_Installment_Payment_Type__c,
                                                                        Price_Book__c,RC_Installment_Number__c,RC_Is_Advance_Payment__c,RC_Is_Tax_Payment__c
                                                                        FROM RC_Payment_Plan_Values__c WHERE RC_Fair_Id__c=:agg[0].RC_Fair__c AND RC_Status__c=true AND Price_Book__c=:agg[0].Pricebook2Id];
                    
                    
                    for(RC_Payment_Plan_Values__c fixedPay : fixedPaymentPlan)  
                    {
                        RC_Payment_Plan__c payInst= new RC_Payment_Plan__c();
                        payInst.RC_Payment_Date__c=fixedPay.RC_Installment_Date__c;
                        payInst.RC_Currency_Rate__c=fixedPay.RC_Installment_Number__c==1 ? agg[0].RC_Agreement_Exchange_Rate__c :currRate;
                        payInst.RC_Payment_Type__c=fixedPay.RC_Installment_Payment_Type__c;
                        payInst.RC_Installment__c=fixedPay.RC_Installment_Number__c;
                        payInst.RC_Payment_Amount__c=pricebook.RC_Tax_Include__c ?( agg[0].RC_Final_Total__c * fixedPay.RC_Installment_Percentage__c ) / 100 : ( (agg[0].RC_Final_Total__c - agg[0].RC_Tax_Amount__c) * fixedPay.RC_Installment_Percentage__c ) / 100 ;
                        
                        if(payInst.RC_Installment__c == 1){
                            payPlanWrapper.calculatedAdvancePayment = payInst.RC_Payment_Amount__c;
                            payPlanWrapper.advancePaymentDate = payInst.RC_Payment_Date__c;
                        }
                        paymentPlanList.add(payInst);
                    }
                    system.debug('fixed:' + paymentPlanList);
                }
                //Özel Ödeme Planı
                else
                {
                    //Peşinat Hesaplama            
                    RC_Payment_Plan__c advancePaymentPlan= new RC_Payment_Plan__c();
                    system.debug('agg:' + agg[0]);
                    if(agg[0].RC_Agreement_Advance_Payment__c!=null && agg[0].RC_Agreement_Advance_Payment__c > 0 && agg[0].RC_Final_Total__c!=null && agg[0].RC_Final_Total__c >0)
                    {
                        if(agg[0].RC_Number_of_Installments__c>0)
                            advancePaymentPlan.RC_Payment_Amount__c=pricebook.RC_Tax_Include__c ? Math.floor(agg[0].RC_Final_Total__c * agg[0].RC_Agreement_Advance_Payment__c / 100) : Math.floor((agg[0].RC_Final_Total__c - agg[0].RC_Tax_Amount__c) * agg[0].RC_Agreement_Advance_Payment__c / 100);
                        else
                            advancePaymentPlan.RC_Payment_Amount__c=pricebook.RC_Tax_Include__c ? (agg[0].RC_Final_Total__c * agg[0].RC_Agreement_Advance_Payment__c / 100) : (agg[0].RC_Final_Total__c - agg[0].RC_Tax_Amount__c) * (agg[0].RC_Agreement_Advance_Payment__c / 100);   
                    }
                    
                    
                    advancePaymentPlan.RC_Payment_Date__c=Date.today().addDays(15);
                    advancePaymentPlan.RC_Payment_Type__c='Cash';
                    advancePaymentPlan.RC_Installment__c=1;
                    advancePaymentPlan.RC_Currency_Rate__c=agg[0].RC_Agreement_Exchange_Rate__c > 0 ? agg[0].RC_Agreement_Exchange_Rate__c : currRate;
                    paymentPlanList.add(advancePaymentPlan);
                    system.debug('paymPlanList:' + paymentPlanList);
                    
                    
                    payPlanWrapper.calculatedAdvancePayment = advancePaymentPlan.RC_Payment_Amount__c;
                    payPlanWrapper.advancePaymentDate = advancePaymentPlan.RC_Payment_Date__c;
                    
                    //Sözleşme üzerindeki taksit adeti kadar ödeme planı hesaplama
                    
                    if(agg[0].RC_Number_of_Installments__c>0){
                        
                        
                        if(advancePaymentPlan.RC_Payment_Amount__c>0)
                            totalAmount=agg[0].RC_Final_Total__c - Math.floor(advancePaymentPlan.RC_Payment_Amount__c);  
                        
                        
                        decimal instTotalAmount=0.00;
                        decimal instAmount=!priceBook.RC_Split_Tax__c ? totalAmount/(agg[0].RC_Number_of_Installments__c) : (totalAmount-agg[0].RC_Tax_Amount__c)/agg[0].RC_Number_of_Installments__c;
                        
                        
                        for (integer i=2; i<=agg[0].RC_Number_of_Installments__c+1; i++) {
                            
                            RC_Payment_Plan__c paymentInst= new RC_Payment_Plan__c();
                            
                            Date avgDay=Date.today();
                            if(agg[0].RC_Average_Maturity_Date__c!=null)
                                avgDay=agg[0].RC_Average_Maturity_Date__c;
                            else
                                avgDay= avgDay.addDays(integer.valueOf(agg[0].RC_Average_Maturity_Days__c>0 ? agg[0].RC_Average_Maturity_Days__c : 0 ));
                            
                            paymentInst.RC_Payment_Date__c=avgDay.addDays(integer.valueOf(-30 *(agg[0].RC_Number_of_Installments__c + 1 - i - ((agg[0].RC_Number_of_Installments__c -1) /2))));
                            paymentInst.RC_Installment__c=i;
                            paymentInst.RC_Payment_Type__c='Check'; 
                            paymentInst.RC_Currency_Rate__c=currRate;
                            if(agg[0].RC_Number_of_Installments__c + 1==i){
                                paymentInst.RC_Payment_Amount__c= !priceBook.RC_Split_Tax__c ? (totalAmount-instTotalAmount).setScale(2) : (totalAmount - instTotalAmount - agg[0].RC_Tax_Amount__c).setScale(2);
                            }
                            
                            else{
                                paymentInst.RC_Payment_Amount__c=instAmount.setScale(2);
                                instTotalAmount += instAmount.setScale(2);
                            } 
                            
                            
                            
                            paymentPlanList.add(paymentInst);
                            
                        }
                    }
                    if(priceBook.RC_Split_Tax__c)
                    {
                        RC_Payment_Plan__c taxInst= new RC_Payment_Plan__c();
                        taxInst.RC_Payment_Date__c=pricebook.RC_Tax_Date__c;
                        taxInst.RC_Payment_Type__c='Check';
                        taxInst.RC_Payment_Amount__c=agg[0].RC_Tax_Amount__c;
                        taxInst.RC_Is_Tax__c=true;
                        taxInst.RC_Currency_Rate__c=currRate;
                        paymentPlanList.add(taxInst);
                    }
                }
                
                
                payPlanWrapper.paymentPlanLst=paymentPlanList;
                payPlanWrapper.calculatedPlan=false;
            }
        }
        
        else
        {
            
            List<RC_Payment_Plan__c> collectorPlan=new List<RC_Payment_Plan__c>();
            List<RC_Payment_Plan__c> salesPlan=new List<RC_Payment_Plan__c>();
            for(RC_Payment_Plan__c paymVal : paymentPlanList)
            {
                if(paymVal.RC_Payment_Plan_Owner_Profile__c=='CNR Collector')
                    collectorPlan.add(paymVal);
                if(paymVal.RC_Payment_Plan_Owner_Profile__c=='CNR Sales')
                    salesPlan.add(paymVal);
                
                if(paymVal.RC_Installment__c == 1){
                    payPlanWrapper.calculatedAdvancePayment = paymVal.RC_Payment_Amount__c;
                    payPlanWrapper.advancePaymentDate = paymVal.RC_Payment_Date__c;
                }
            }
            if(collectorPlan.size()>0)
                paymentPlanList=collectorPlan;
            else
                paymentPlanList=salesPlan;
            
            payPlanWrapper.paymentPlanLst=paymentPlanList;
            payPlanWrapper.calculatedPlan=true;
        }
        return payPlanWrapper;
        
    }
    
    //Ortalama vade hesabı yapan fonksiyon - Test edildi :) 
    @AuraEnabled
    public static CalculateWrapper  CalculateAvgMaturity(string paymentPlanStringify,Id recordId){
        List<RC_Payment_Plan__c> selectedParams= new  List<RC_Payment_Plan__c>();
        selectedParams = (List<RC_Payment_Plan__c>)JSON.deserialize(paymentPlanStringify, List<RC_Payment_Plan__c>.class);
        
        List<Opportunity> agg= [SELECT Id,Amount,RC_Final_Total__c,Rc_Average_Maturity_Date__c,Rc_Average_Maturity_Days__c FROM Opportunity WHERE Id=:recordId];
        CalculateWrapper calcResponse= new CalculateWrapper();
        string errorMsg='';
        RC_Payment_Plan__c retval= new RC_Payment_Plan__c();
        
        Date keydate = Date.today().addDays(-30);
        decimal totalMaturity=0.00; 
        decimal totalprice=0.00;
        decimal advancePrice=0.00;
        for(RC_Payment_Plan__c currentplan : selectedParams)
        {
            integer payDate=date.ValueOf(currentplan.RC_Payment_Date__c).day();
            
            if(payDate>=25 && currentPlan.RC_Payment_Type__c=='Note')
                errorMsg+='error'; 
            
            if(currentPlan.RC_Installment__c!=1){
                system.debug('currentPlan:' + currentplan);
                Integer currentPlanDay = keydate.daysBetween(currentplan.RC_Payment_Date__c);
                system.debug('currentPlanDay:' + currentPlanDay);
                Decimal maturity=currentPlanDay*currentplan.RC_Payment_Amount__c;
                totalprice = totalprice + currentplan.RC_Payment_Amount__c;
                totalMaturity =totalMaturity + maturity;
                
            }
            else{
                advancePrice=currentplan.RC_Payment_Amount__c;
                totalprice = totalprice + currentplan.RC_Payment_Amount__c;
            }
            
            
        }
        system.debug('totalMat:' + totalMaturity);
        system.debug('totalPrice:' + totalPrice);
        Integer maturityDay=0;
        if(totalMaturity>0){
            maturityDay= Integer.valueOf(totalMaturity/(totalprice-advancePrice)); 
            Date maturityDate= keydate.addDays(maturityDay); 
            system.debug('maturityDate: ' + maturityDate);
            retval.RC_Payment_Date__c=maturityDate; //Hesaplanan ortalama vade tarihi, fırsat üzerindeki ile karşılaştırılacak
        }
        else
        {
            retval.RC_Payment_Date__c=agg[0].Rc_Average_Maturity_Date__c!=null ? agg[0].Rc_Average_Maturity_Date__c :Date.today().addDays(integer.valueOf(agg[0].RC_Average_Maturity_Days__c));
        }
        
        
        retval.RC_Payment_Amount__c=totalprice; // Sözleşme tutarı
        calcResponse.paymentPlan=retval;
        calcResponse.totalPayment=agg[0].RC_Final_Total__c>0 ? agg[0].RC_Final_Total__c.setScale(2) : 0.00;
        calcResponse.totalInstPayment=totalPrice.setScale(2);
        calcResponse.diffPayment=agg[0].RC_Final_Total__c>0 ? (agg[0].RC_Final_Total__c - totalPrice).setScale(2) : 0.00;
        calcResponse.hasError=errorMsg!='' ? true : false;
        return calcResponse;
    }
    
    @AuraEnabled
    public static boolean SavePaymentPlan(string paymentPlanStringify,string recordId,string avgPaymentDate,FixedPaymentPlanWrapper fixedPayment,string avgD){
        
        Map<Integer,RC_Payment_Plan__c> oldPayCheckMap= new  Map<Integer,RC_Payment_Plan__c>();
        
        Id profileId=userinfo.getProfileId();
        String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
        if(profileName=='System Administrator' || profileName=='CNR Sales Manager' || profileName=='CNR Group Manager' )
            profileName='CNR Sales';
        
        List<RC_Payment_Plan__c> selectedParams= new  List<RC_Payment_Plan__c>();
        selectedParams = (List<RC_Payment_Plan__c>)JSON.deserialize(paymentPlanStringify, List<RC_Payment_Plan__c>.class);
        paymentPlanWrapper payPlan= new paymentPlanWrapper();
        if(fixedPayment!=null)
            payPlan=GetPaymentPlan(recordId,fixedPayment);
        else
            payPlan=GetPaymentPlan(recordId,null);   
        if(payPlan.calculatedPlan){
            
            List<RC_Payment_Plan__c> oldPaymentPlanList=payPlan.paymentPlanLst;
            for(RC_Payment_Plan__c oldPayment : oldPaymentPlanList){
                
                RC_Payment_Plan__c shallowCopyPayment=oldPayment.clone();
                oldPayCheckMap.put(integer.valueOf(shallowCopyPayment.RC_Installment__c),shallowCopyPayment);
                
                if(profileName==oldPayment.RC_Payment_Plan_Owner_Profile__c)
                {
                    oldPayment.RC_Active__c=false;
                }
                
                oldPayment.RC_Sales_Person_Check__c=false;
                oldPayment.RC_Collector_Check__c=false;
                oldPayment.RC_Finance_Check__c=false;
                
                
            }
            Database.Update(oldPaymentPlanList);
        }
        
        
        boolean errMsg=false;
        
        Opportunity agg=  [SELECT Id,RC_Average_Maturity_Days__c,CurrencyIsoCode,RC_Average_Maturity_Date__c,Amount,RC_Number_of_Installments__c,RC_Fair__c,RC_Agreement_Advance_Payment__c FROM Opportunity WHERE Id=:recordId];
        
        
        List<RC_Payment_Plan__c> paymentPlanList= new List<RC_Payment_Plan__c>();
        
        List<RC_Payment_Plan__c> paymsList= [SELECT Id,RC_Payment_Plan_Group__c FROM RC_Payment_Plan__c WHERE RC_Agreement__c=:recordId];
        integer groupNumber=0;
        if(paymsList.size()>0)
        {
            for(RC_Payment_Plan__c pym : paymsList)
            {
                if(pym.RC_Payment_Plan_Group__c!=null && pym.RC_Payment_Plan_Group__c>=0)
                {
                    if(pym.RC_Payment_Plan_Group__c>groupNumber)
                        groupNumber=integer.valueOf(pym.RC_Payment_Plan_Group__c);
                }
            }
        }
        
        integer counter=1;
        for(RC_Payment_Plan__c payment : selectedParams){
            
            RC_Payment_Plan__c newPayment		= new RC_Payment_Plan__c();
            newPayment.RC_Agreement__c			=recordId;
            newPayment.CurrencyIsoCode			=agg.CurrencyIsoCode;
            newPayment.RC_Main_Plan__c			=true;
            newPayment.RC_Installment__c		=counter;
            newPayment.RC_Payment_Amount__c		=payment.RC_Payment_Amount__c;
            newPayment.RC_Payment_Date__c		=payment.RC_Payment_Date__c;
            newPayment.RC_Payment_Type__c		=payment.RC_Payment_Type__c;
            newPayment.RC_Active__c				=true;
            newPayment.RC_Payment_Plan_Owner_Profile__c=profileName;
            newPayment.RC_Average_Maturity_Date__c=date.ValueOf(avgD);
            newPayment.RC_Payment_Plan_Group__c=groupNumber+1;
            newPayment.RC_Currency_Rate__c=payment.RC_Currency_Rate__c;
            newPayment.RC_Sales_Person_Check__c=oldPayCheckMap.containsKey(counter) ? oldPayCheckMap.get(counter).RC_Sales_Person_Check__c : false;
            newPayment.RC_Collector_Check__c=oldPayCheckMap.containsKey(counter) ? oldPayCheckMap.get(counter).RC_Collector_Check__c : false;
            newPayment.RC_Finance_Check__c=oldPayCheckMap.containsKey(counter) ? oldPayCheckMap.get(counter).RC_Finance_Check__c : false;
            paymentPlanList.add(newPayment);
            counter++;
        }
        
        List<Database.SaveResult> paymList =Database.insert(paymentPlanList);
        for(DataBase.SaveResult theResult : paymList) {
            if(theResult.isSuccess() == true){
                continue; 
            }
            List<Database.Error> errors = theResult.getErrors();
            for(Database.Error theError : Errors) {
                return false;
            }
        }
        System.debug('Calcualted Maturity Date Ori : ' + avgPaymentDate);
        System.debug('Calcualted Maturity Date : ' + integer.valueOf(avgPaymentDate));
        agg.RC_Calculated_Maturity_Days__c=integer.valueOf(avgPaymentDate);   
        Database.SaveResult Sresult=Database.Update(agg);
        if(Sresult.isSuccess() == true){
            return true;
        }
        return true;
    }
    
    @AuraEnabled
    public static boolean SaveChecks(string paymentPlanStringify,string recordId){
        
        List<Opportunity> agg= [SELECT Id,RC_Number_of_Installments__c,CurrencyIsoCode,RC_Agreement_Exchange_Rate__c,RC_LogoKey__c,RC_Fair__c FROM Opportunity WHERE Id=:recordId];
        List<RC_Fair__c> fair= [SELECT Id,RC_CNR_Firm__c FROM RC_Fair__c WHERE Id=:agg[0].RC_Fair__c];
        List<Account> acc=[SELECT Id,RC_Logo_Firm__c FROM Account WHERE Id=:fair[0].RC_CNR_Firm__c];
        system.debug('cnrFirm:' + fair[0].RC_CNR_Firm__c + '-Acc:' + acc);
        List<RC_Payment_Plan__c> selectedParams= new  List<RC_Payment_Plan__c>();
        selectedParams = (List<RC_Payment_Plan__c>)JSON.deserialize(paymentPlanStringify, List<RC_Payment_Plan__c>.class);
        List<RC_Payment_Plan__c> paymentPlanList=new List<RC_Payment_Plan__c>();
        if(selectedParams.size()>0){
            paymentPlanList=[SELECT Id,RC_Installment__c,RC_Payment_Type__c,RC_Payment_Date__c,RC_Payment_Amount__c,
                             RC_Collector_Check__c,RC_Finance_Check__c,RC_Sales_Person_Check__c,RC_Is_Tax__c
                             FROM RC_Payment_Plan__c WHERE RC_Agreement__c=:recordId and RC_Active__c=true
                             ORDER BY RC_Installment__c];
            system.debug('paymentPlanList:' + paymentPlanList);
            if(paymentPlanList.size()>0)
            {
                Map<string,RC_Payment_Plan__c> planMap= new Map<string,RC_Payment_Plan__c>();
                for(RC_Payment_Plan__c installment : selectedParams)
                {
                    planMap.put(installment.Id,installment);
                }
                for(RC_Payment_Plan__c paymentVal : paymentPlanList)
                {
                    system.debug('LOGOTEST2');
                    if(planMap.containsKey(paymentVal.Id)){
                        if(planMap.get(paymentVal.Id).RC_Collector_Check__c && paymentVal.RC_Installment__c==1 && string.isBlank(agg[0].RC_LogoKey__c) && acc[0].RC_Logo_Firm__c)
                        {
                            system.debug('LOGOTEST3');
                            List<Id> aggIds=new List<Id>();
                            aggIds.add(agg[0].Id);
                            if(!test.isRunningTest())
                            {
                                LogoCreateOrder.Create(aggIds);
                            }                            
                        } 
                    }
                    
                    paymentVal.RC_Collector_Check__c=planMap.containsKey(paymentVal.Id) ? planMap.get(paymentVal.Id).RC_Collector_Check__c : false;
                    paymentVal.RC_Sales_Person_Check__c=planMap.containsKey(paymentVal.Id) ? planMap.get(paymentVal.Id).RC_Sales_Person_Check__c : false;
                    paymentVal.RC_Finance_Check__c=planMap.containsKey(paymentVal.Id) ? planMap.get(paymentVal.Id).RC_Finance_Check__c : false;
                    if(paymentVal.RC_Collector_Check__c)
                        paymentVal.RC_Currency_Rate__c=planMap.get(paymentVal.Id).RC_Currency_Rate__c;
                }
                List<Database.SaveResult> paymList =Database.update(paymentPlanList);
                for(DataBase.SaveResult theResult : paymList) {
                    if(theResult.isSuccess() == true){
                        system.debug('return:' + theResult.isSuccess());
                        continue; 
                    }
                    else
                    {
                        system.debug('return:' + theResult.isSuccess());
                        return false; 
                    }
                    
                }
                
            }
            else
                return false;
            
            return true;
        }
        else
            return false;
        
    }
    
    public static String getCorporateCurrency()
    {
        String retVal = '';
        CurrencyType currencyTypeItem = [SELECT Id, IsCorporate, IsoCode, ConversionRate FROM CurrencyType WHERE IsCorporate = TRUE LIMIT 1];
        if(currencyTypeItem != null)
        {
            retVal = currencyTypeItem.IsoCode;
        }
        return retVal;
    }
    
    @AuraEnabled
    public static Decimal getCurrencyRate(String CurrencyName, Date CurrencyDate)
    {
        Decimal retVal = 1;
        DatedConversionRate conversationRateItem = null;
        try
        {
            List<DatedConversionRate> dataList = [SELECT Id, StartDate, IsoCode, ConversionRate FROM DatedConversionRate WHERE IsoCode =: CurrencyName AND StartDate =: CurrencyDate  LIMIT 1];
            
            if(dataList.size() > 0)
            	conversationRateItem = dataList.get(0);
            
            system.debug(conversationRateItem);
        }       
        catch(Exception ex)
        {
            system.debug(ex);
        }
        if(conversationRateItem != null)
        {
            retVal = 1/conversationRateItem.ConversionRate;
            system.debug(retVal);
        }
        return retVal;
    }
    
}