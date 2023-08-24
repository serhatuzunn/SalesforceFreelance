public class RC_Extension2 implements Callable {
    public Object call(String action, Map<String, Object> args) {
        system.debug(args);
        String requestJSON = JSON.serialize(args);
        system.debug(requestJSON);
        switch on action {
            when 'updateContact' {
                requestJSON = JSON.serialize(args.get('Contact'));
                Contact wrapper = (Contact)JSON.deserialize(requestJSON, Contact.class);
                return RC_CommunityHelper.InsertCase(wrapper);
            }
            /*when 'InsertAttachmentBaggage'
            {
                String attachString = JSON.serialize(args.get('attach'));
                String caseIdString = (String)args.get('caseID');
                system.debug(caseIdString);
                Map<String,Object> attachmentMap = (MAP<string,object>) JSON.deserializeUntyped(attachString);
                Attachment atch = new Attachment();
                atch.Body = EncodingUtil.base64Decode(String.valueOf(attachmentMap.get('Body'))); 
                atch.Name = (String)attachmentMap.get('Name');
                atch.ContentType = (String)attachmentMap.get('ContentType');                 
                return RC_CommunityHelper.addAttachmentToCase(atch, caseIdString);
            }*/
            when else {
                throw new ExtensionMalformedCallException('Method not implemented');
            }
        }
    }
    
    public class ExtensionMalformedCallException extends Exception {}    
}