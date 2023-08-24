trigger RC_ContactTrigger on Contact (after insert, after delete, after update) {
    system.debug('RC_ContactTrigger fired');
    
    List<Contact> contacts = new List<Contact>();
    if(Trigger.isDelete){
        contacts.addAll(Trigger.Old);
    }
    else{
        contacts.addAll(Trigger.New);
    }
    Set<String> accountSet = new Set<String>();
    for(Contact contact : contacts){
        accountSet.add(contact.AccountId);
    }
    system.debug('accountSet:'+accountSet);
    Account[] accounts = [SELECT Id, Name, (Select Id From Contacts), RC_Contact_Count__c FROM Account WHERE Id =: accountSet];
    
    system.debug('accounts size trigger :' + accounts.size());
    for(Account account : accounts){
        account.RC_Contact_Count__c = account.Contacts.size();
    }
    Database.SaveResult[] srList = Database.update(accounts);

}