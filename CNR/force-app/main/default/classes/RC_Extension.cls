public class RC_Extension implements Callable {
    public class AttachmentWrapper {    
        @AuraEnabled
        public String Name{get;set;}
        @AuraEnabled
        public String Body{get;set;}
        @AuraEnabled
        public String ContentType{get;set;}
        @AuraEnabled
        public Decimal BodyLength{get;set;}
        @AuraEnabled
        public Id ParentId{get;set;}
        @AuraEnabled
        public String Description {get;set;}
    }  
    public Object call(String action, Map<String, Object> args) {        
        switch on action { 
            when 'GetCorporateCurrency' {
                return RC_PaymentPlanController.getCorporateCurrency();
            }
            when 'GetCurrency' {
                return RC_PaymentPlanController.getCurrencyRate('USD', Date.today());
            }
            when 'insertContact' {
                String contact = JSON.serialize(args.get('contact'));
                Contact wrapper = (Contact)JSON.deserialize(contact, Contact.class);
                return RC_CommunityHelper.insertContact(wrapper);
            }
            when 'updateContact' {
                String contact = JSON.serialize(args.get('contact'));
                List<Contact> wrapper = (List<Contact>)JSON.deserialize(contact, List<Contact>.class);
                return RC_CommunityHelper.updateContact(wrapper);
            }
            when 'deleteContact' {
                String contact = JSON.serialize(args.get('contact'));
                Contact wrapper = (Contact)JSON.deserialize(contact, Contact.class);
                return RC_CommunityHelper.deleteContact(wrapper);
            }
            when 'insertAttachment' {
                String attachment = JSON.serialize(args.get('attachment'));
                system.debug('attachment:'+attachment);
                List<AttachmentWrapper> attachmentMap = (List<AttachmentWrapper>) JSON.deserialize(attachment, List<AttachmentWrapper>.class);
                system.debug('attachmentMap:'+attachmentMap);
                List<Attachment> lAttachment = new List<Attachment>();
                for(AttachmentWrapper attch: attachmentMap){
                    Attachment newattch = new Attachment();                       
                    newattch.Body = EncodingUtil.base64Decode(attch.Body);
                    newattch.ParentId =attch.ParentId;
                    newattch.ContentType = attch.ContentType;
                    newattch.Name = attch.Name;
                    newattch.Description = attch.Description;
                    lAttachment.add(newattch);
                }                   
                return RC_CommunityHelper.insertAttachment(lAttachment);
            }
            when 'updateOpportunity' {
                String opportunity = JSON.serialize(args.get('opportunity'));
                Opportunity wrapper = (Opportunity)JSON.deserialize(opportunity, Opportunity.class);
                return RC_CommunityHelper.updateOpportunity(wrapper);
            }
            when 'updateAccount' {
                String account = JSON.serialize(args.get('account'));
                Account wrapper = (Account)JSON.deserialize(account, Account.class);
                return RC_CommunityHelper.updateAccount(wrapper);
            }
            when 'insertSector' {
                String sector = JSON.serialize(args.get('sector'));
                List<RC_Related_Sector__c> wrapper = (List<RC_Related_Sector__c>)JSON.deserialize(sector, List<RC_Related_Sector__c>.class);
                return RC_CommunityHelper.insertSector(wrapper);
            }
            when 'deleteBadge' {
                String badge = JSON.serialize(args.get('badge'));
                RC_Exhbitor_Badges__c wrapper = (RC_Exhbitor_Badges__c)JSON.deserialize(badge, RC_Exhbitor_Badges__c.class);
                return RC_CommunityHelper.deleteBadge(wrapper);
            }
            when 'insertBadge' {
                String badge = JSON.serialize(args.get('badge'));
                RC_Exhbitor_Badges__c wrapper = (RC_Exhbitor_Badges__c)JSON.deserialize(badge, RC_Exhbitor_Badges__c.class);
                return RC_CommunityHelper.insertBadge(wrapper);
            }
            when 'updateBadge' {
                String badges = JSON.serialize(args.get('badge'));
                List<RC_Exhbitor_Badges__c> wrapper = (List<RC_Exhbitor_Badges__c>)JSON.deserialize(badges, List<RC_Exhbitor_Badges__c>.class);
                return RC_CommunityHelper.updateBadge(wrapper);
            }            
            when 'deleteInvitation' {
                String invitations = JSON.serialize(args.get('invitation'));
                RC_Invitation__c wrapper = (RC_Invitation__c)JSON.deserialize(invitations, RC_Invitation__c.class);
                return RC_CommunityHelper.deleteInvitation(wrapper);
            }
            when 'insertInvitation' {
                String invitations = JSON.serialize(args.get('invitation'));
                RC_Invitation__c wrapper = (RC_Invitation__c)JSON.deserialize(invitations, RC_Invitation__c.class);
                return RC_CommunityHelper.insertInvitation(wrapper);
            }
            when 'updateInvitation' {
                String invitations = JSON.serialize(args.get('invitation'));
                List<RC_Invitation__c> wrapper = (List<RC_Invitation__c>)JSON.deserialize(invitations, List<RC_Invitation__c>.class);
                return RC_CommunityHelper.updateInvitation(wrapper);
            }            
            when else {
                throw new ExtensionMalformedCallException('Method not implemented');
            }
        }
    }
    public class ExtensionMalformedCallException extends Exception {}    
}