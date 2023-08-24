public class RC_AgreementPDF_Invocable {

    @InvocableMethod(label='Create PDF' description='Returns the list of account names corresponding to the specified account IDs.')

    public static void InvokeCreatePDF(List<Id> idList)
    {
        if(idlist.size()==1)
        {  
        ApexPages.StandardController controller = new ApexPages.StandardController(new Opportunity(id = idList[0]));
        controller.view();
        CnrAgreementPdfController con= new CnrAgreementPdfController(controller);
        con.savePdf();
        con.savePdfInternational();
        }
    }
}