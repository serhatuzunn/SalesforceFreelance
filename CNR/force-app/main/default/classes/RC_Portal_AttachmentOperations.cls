public without sharing class RC_Portal_AttachmentOperations {
    public static void InsertCaseAttachment(List<Attachment> atchList)
    {
        List<Database.SaveResult> srAtch= Database.insert(atchList);
        if(Test.isRunningTest())
        {
            system.debug('sr attachment ' + srAtch);
        }
        for(Database.SaveResult srItem : srAtch)
        {
            if(srItem != null && srItem.isSuccess())
            {
                system.debug('attchId' +srItem.getId() );
            }
            else
            {
                for(Database.Error errItem: srItem.getErrors())
                {
                    system.debug('attachment err : ' + errItem.getMessage());
                }
            }            
        }
    }
}