global class RC_CheckCanceledOpportunity {
    global static void CheckAndUpdate(){    
        List<Opportunity> oppList= [SELECT id FROM Opportunity WHERE StageName = 'Agreement'];
        system.debug('Opportunity List : '+ oppList);
        if(oppList.size() > 0){
            List<RC_Payment_Plan__c> paymentPlains= [SELECT id,RC_Payment_Date__c,RC_Agreement__c FROM RC_Payment_Plan__c WHERE RC_Agreement__c IN :oppList and RC_Installment__c =: 1 and RC_Active__c=:true];
            system.debug('Payment Plan List : '+ paymentPlains);
            if(paymentPlains.size() > 0){
                Map<String,Date> mapData = new Map<String,Date>();
                for(RC_Payment_Plan__c pp : paymentPlains){
                    mapData.put(pp.RC_Agreement__c, pp.RC_Payment_Date__c);           
                }
                system.debug('mapData : '+ mapData);
                
                Agreement_Settings__c mc = [SELECT BufferDateCount__c FROM Agreement_Settings__c LIMIT 1];
                system.debug('BufferDateCount__c : '+ mc.BufferDateCount__c);
                if(mc.BufferDateCount__c != null){
                    for(Opportunity op : oppList){
                        Date bdate = mapData.get(op.Id);
                        system.debug('Buffer Date : '+ bdate);
                        if(bdate != null){                
                            Integer bufferDate = bdate.daysBetween(Date.today());
                            system.debug('Buffer Count : '+ bufferDate); 
                            if(bufferDate > mc.BufferDateCount__c){
                                op.StageName='Canceled';
                            }
                        }
                        else{
                           system.debug('Opportunitynin installment 1 olan ve aktif olan odeme planı yok ya da payment date alanı boş geldi.');
                        }            
                    }
                    List<Database.SaveResult> srOpportunity = Database.update(oppList);
                    system.debug('SaveResult Opportunity : '+ srOpportunity); 
                }
                else{
                    system.debug('Agreement_Settings__c custom settings inden BufferDateCount__c gelmedi.');
                }
            }
            else{
                system.debug('StageName i Agreement olan Opportunitylerden taksit sayısı 1 olan ve aktif olan Ödeme planı gelmedi.');
            }
        }
        else{
            system.debug('StageName i Agreement olan Opportunity gelmedi.');
        }
    }
}