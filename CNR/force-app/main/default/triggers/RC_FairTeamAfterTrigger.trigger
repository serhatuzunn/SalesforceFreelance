trigger RC_FairTeamAfterTrigger on RC_Fair_Team__c (after insert, after delete) {
    
    if(Trigger.isInsert){
    	for(RC_Fair_Team__c ft : Trigger.New){
        
   			User usr = [SELECT Id, User_Code__c FROM User WHERE Id =: ft.RC_User_Name__c];
        
        	RC_Fair__c fair = [SELECT Id, RC_Fair_Team__c FROM RC_Fair__c WHERE Id =: ft.RC_Fair__c];
        
        	fair.RC_Fair_Team__c = fair.RC_Fair_Team__c == null ? usr.User_Code__c : fair.RC_Fair_Team__c + usr.User_Code__c;
        
  			update(fair);
    	}
    }
    
    if(Trigger.isDelete)
        
        for(RC_Fair_Team__c ft: Trigger.Old){
            
            User usr = [SELECT Id, User_Code__c FROM User WHERE Id =: ft.RC_User_Name__c];
        
        	RC_Fair__c fair = [SELECT Id, RC_Fair_Team__c FROM RC_Fair__c WHERE Id =: ft.RC_Fair__c];
            
            if(fair.RC_Fair_Team__c != null){
            
            String s = fair.RC_Fair_Team__c;

			String removedText = usr.User_Code__c;

			s = s.replace(removedText,'');
            
            fair.RC_Fair_Team__c = s;
            
            update(fair);
            
            }
            
        }

}