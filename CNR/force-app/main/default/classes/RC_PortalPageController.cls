public with sharing class RC_PortalPageController {
    @AuraEnabled
    public String lang {get;set;}
    @AuraEnabled
    public boolean isEng {get;set;}
    
    public RC_PortalPageController(){
        lang='en_US';
        isEng=true;
    }
    
    public void changeEnglish(){        
        lang = 'en_US';      
        isEng=true;
    }
    
    public void changeTurkish(){        
        lang = 'tr';  
        isEng=false;
    }    
}