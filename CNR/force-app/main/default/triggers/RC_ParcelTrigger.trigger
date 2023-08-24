trigger RC_ParcelTrigger on RC_Parcel__c (after insert) {
    RC_HallPlanController cnt = new RC_HallPlanController();
    
    for(RC_Parcel__c parcelItem : Trigger.New)
    {
        if(parcelItem.RC_Type__c == 'Sold')
        {
            Boolean retVal = cnt.CheckParcelSold(parcelItem.RC_Design__c , parcelItem.RC_ParentParcel__c,parcelItem.Id);
            system.debug(retVal);
            if(retVal)
            {
                Database.delete(parcelItem.Id);
            }
        }
    } 
}