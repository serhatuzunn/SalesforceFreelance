public class RC_InvitationServices {
    public static void InsertInvitation(RC_Invitation__c newInvitation, Account account, string fairInfoUserId, String fairName, String fairStartDate, String fairEndDate){  
        system.debug('InsertInvitation fired!');
        try{
            CnrServicesWSDL.CnrServiceSoap api = new CnrServicesWSDL.CnrServiceSoap();
            api.timeout_x = 120000;
            
            //CnrServicesWSDL.fuar_user fuarUser = api.Get_fuar_userByID(integer.valueof(account.Id));
            CnrServicesWSDL.fuar_user fuarUser = api.Get_fuar_userByID(integer.valueOf(fairInfoUserId));
            system.debug('fuarUser: ' + fuarUser);
            String code = fuarUser.KULLANICI.Substring(0, 4) + api.GenerateCode().Substring(0, 6);
            system.debug('code:'+code);
            CnrServicesWSDL.bilet_pro biletPro = new CnrServicesWSDL.bilet_pro();            
            biletPro.DURUM = integer.valueof(newInvitation.RC_Reserved__c);
            biletPro.ID = integer.valueof(fairInfoUserId);
            biletPro.Firma = account.Name;
            biletPro.KOD = code;
            biletPro.mail = newInvitation.RC_Email__c;
            biletPro.ORAN = 100;
            biletPro.web_id = fuarUser.web_id;
            
            integer ID = api.Insertbilet_pro(biletPro);
            system.debug('Insertbilet_pro:'+ID);
            
            CnrServicesWSDL.bilet_pro biletPro2 = api.Getbilet_proByID(ID);
            
            RC_Invitation__c Inv = new RC_Invitation__c();
            Inv.Account__c = account.Id;
            Inv.RC_FullName__c = newInvitation.RC_FullName__c;
            Inv.RC_Email__c = newInvitation.RC_Email__c;
            Inv.RC_Reserved__c = newInvitation.RC_Reserved__c;
            Inv.RC_Code__c = biletPro2.KOD;
            Map<String, Object> mapData = new Map<String, Object>();
            mapData.put('invitation', Inv);
            RC_ExtensionHelper.CallRequest('insertInvitation', mapData);
            
            //Mail Atılıyor - PromotionCodeForInvitationMail
            string linkTurkish = 'https://bilet.cnrexpo.com/form.aspx?web_id=' + biletPro2.web_id + '&TicketType=Invitation&PromotionCode=' + biletPro2.KOD;
            string linkEnglish = 'https://bilet.cnrexpo.com/en/form.aspx?web_id=' + biletPro2.web_id + '&TicketType=Invitation&PromotionCode=' + biletPro2.KOD;            
            
            api.GetMailSettingsUtilByMailTopic('E-Davetiye Ziyaretçi Promosyon Kodu');
            system.debug('biletPro2: ' + biletPro2);
            
            SendEmail(biletPro2.mail, newInvitation.RC_FullName__c, account.Name, newInvitation.RC_Reserved__c, fairName, fairStartDate, fairEndDate, linkTurkish, linkEnglish);
        }
        catch(Exception ex)
        {
            system.debug(ex.getMessage());
            system.debug(ex.getStackTraceString());
            RC_Logger.LOG_EXCEPTION(ex.getMessage(), 'Entegrasyonu hata!', ex.getStackTraceString(), 'RC_InvitationServices', 'InsertInvitation', 'RC_Portal_Invitation');
        }
    }
    
    public static boolean SendEmail(String email, String invName, String accountName, String invCount, String fairName, String fairStartDate, String fairEndDate, String linkTurkish, String linkEnglish) {
        try{
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            List<String> toAdresses = new List<String>();
            toAdresses.add(email);
            message.toAddresses = toAdresses;
            message.optOutPolicy = 'FILTER';
            message.setCharset('UTF-8');
            message.subject = 'CNREXPO';
            message.setReplyTo('info@cnr.net');
            message.setSenderDisplayName('CNR Holding');
            //message.plainTextBody = linkTurkish;
            
            /*List<OrgWideEmailAddress> fromAddressList = [SELECT Id, Address FROM OrgWideEmailAddress WHERE Address = 'ziyacan.kalkavan@ritmusconsulting.com'];
            //List<OrgWideEmailAddress> fromAddressList = [SELECT Id, Address FROM OrgWideEmailAddress WHERE Address = 'info@cnrexpo.com'];
            if(fromAddressList.size() > 0){
                message.setOrgWideEmailAddressId(fromAddressList[0].Id);
            }*/
            
            String htmlBody = '';
            htmlBody += '<html><body style="margin:0 auto; bgcolor="#eaeced">';
            
            if(String.isNotBlank(linkTurkish)){
                htmlBody += 'Sayın ' + invName + ',';
                htmlBody += '<br/><br/>';
                htmlBody += accountName + ' Firması katılımcısı olduğu ';
                htmlBody += fairName + ' Fuarı için size özel ' + '<b>' + invCount + '</b>' + ' adet ücretsiz online davetiye oluşturmuştur.';
                htmlBody += '<br/><br/>';
                htmlBody += 'Fuara sıra beklemeden giriş yapabilmeniz için ';
                htmlBody += linkTurkish;
                htmlBody += ' adresinden 5 saniyede yaka kartınızı oluşturabilirsiniz.';
                htmlBody += '<br/><br/>';
                htmlBody += fairStartDate + ' - ' + fairEndDate + ' arasında ' + fairName + ' Fuarı’nda görüşmek dileğiyle,';
                htmlBody += '<br/><br/>';
                htmlBody += 'CNR Holding';
                htmlBody += '<br/><br/>';
            }
            if(String.isNotBlank(linkEnglish)){
                htmlBody += 'Dear ' + invName + ',';
                htmlBody += '<br/><br/>';
                htmlBody += accountName + ' invites you to ';
                htmlBody += fairName + ' Exhibition at CNR Expo, Istanbul. Your online invitation with ' + '<b>' + invCount + '</b>' + ' quota has been generated.';
                htmlBody += '<br/><br/>';
                htmlBody += 'In order to avoid long queues during entrance, please kindly create your badge in 5 seconds on this address: ';
                htmlBody += linkEnglish;
                htmlBody += '<br/><br/>';
                htmlBody += 'Hope to see you at ' + fairName + ' Exhibition between ' + fairStartDate + ' - ' + fairEndDate + ' at CNR Expo, Istanbul.';
                htmlBody += '<br/><br/>';
                htmlBody += 'Our Best,';
                htmlBody += '<br/><br/>';
                htmlBody += 'CNR Holding';
            }
            htmlBody += '</body></html>';
            message.setHtmlBody(htmlBody);
            
            Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
            if (results[0].success) {
                System.debug('The email was sent successfully.');
                return true;
            } 
            else {
                System.debug('The email failed to send: '+ results[0].errors[0].message);
                return false;
            }
        }
        catch(Exception ex){
            system.debug('SendEmail exception : '+ ex.getMessage());
            system.debug(ex.getStackTraceString());
            return false;
        }
    }
}