public class RC_CommunityHelper {
    public static Object insertContact(Contact cnt)
    {
        system.debug('cnt.MobilePhone:'+cnt.MobilePhone);
        Database.SaveResult sr = Database.insert(cnt);
        system.debug('SaveResult:'+sr);
        return sr;      
    }
    
    public static Object updateContact(List<Contact> cnts)
    {
        List<Database.SaveResult> sr = Database.update(cnts);
        system.debug('SaveResult:'+sr);
        return sr;      
    }
    
    public static Object deleteContact(Contact cnt)
    {
        Database.DeleteResult dr = Database.delete(cnt);
        system.debug('DeleteResult:'+dr);
        return dr;      
    }
    
    public static Object insertAttachment(List<Attachment> atchList)
    {
        List<Database.SaveResult> srAtch= Database.insert(atchList);
        
        system.debug('sr attachment ' + srAtch);
        /*
        for(Database.SaveResult srItem : srAtch)
        {
            if(srItem != null && srItem.isSuccess())
            {
                system.debug('attchId' +srItem.getId());
            }
            else
            {
                for(Database.Error errItem: srItem.getErrors())
                {
                    system.debug('attachment err : ' + errItem.getMessage());
                }
            }            
        }   */
        return atchList;
    }
    
    public static Object updateOpportunity(Opportunity opp)
    {
        Database.SaveResult sr = Database.update(opp);
        system.debug('SaveResult:'+sr);
        return sr;      
    }
    
    public static Object updateAccount(Account acct)
    {
        Database.SaveResult sr = Database.update(acct);
        system.debug('SaveResult:'+sr);
        return sr;      
    }
    
    public static Object insertSector(List<RC_Related_Sector__c> sector)
    {
        List<Database.SaveResult> sr = Database.insert(sector);
        system.debug('SaveResult:'+sr);
        return sr;      
    }
    
    public static Object deleteBadge(RC_Exhbitor_Badges__c badge)
    {
        Database.DeleteResult dr = Database.delete(badge);
        system.debug('DeleteResult:'+dr);
        return dr;      
    }
    
    public static Object insertBadge(RC_Exhbitor_Badges__c badge)
    {
        Database.SaveResult sr = Database.insert(badge);
        system.debug('SaveResult:'+sr);
        return sr;      
    }
    
    public static Object updateBadge(List<RC_Exhbitor_Badges__c> badges)
    {
        List<Database.SaveResult> sr = Database.update(badges);
        system.debug('SaveResult:'+sr);
        return sr;      
    }
    
    public static Object deleteInvitation(RC_Invitation__c invitation)
    {
        Database.DeleteResult dr = Database.delete(invitation);
        system.debug('DeleteResult:'+dr);
        return dr;      
    }
    
    public static Object insertInvitation(RC_Invitation__c invitation)
    {
        Database.SaveResult sr = Database.insert(invitation);
        system.debug('SaveResult:'+sr);
        return sr;      
    }
    
    public static Object updateInvitation(List<RC_Invitation__c> invitations)
    {
        List<Database.SaveResult> sr = Database.update(invitations);
        system.debug('SaveResult:'+sr);
        return sr;      
    }    
}