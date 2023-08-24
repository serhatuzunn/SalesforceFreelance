@isTest
public class RC_HallPlanControllerTest {
	@isTest public static void runTestOpportunity()
    {
        Test.StartTest();
        PageReference pageRef = Page.RC_HallPlanPage; 
        Opportunity opp =  [SELECT Id FROM Opportunity LIMIT 1];
        RC_Hall__c hallItem =  [SELECT Id FROM RC_Hall__c LIMIT 1];
        RC_Parcel__c parcelItem =  [SELECT Id FROM RC_Parcel__c LIMIT 1];
       
        pageRef.getParameters().put('recordId', opp.Id);
        pageRef.getParameters().put('hallId', hallItem.Id);
        
        String data = '{"ParentParcelId" : "'+parcelItem.Id+'","AgreementId" : "'+opp.Id+'","RoomSize" : 10,"ParcelDesign" : "[\\"7-13\\",\\"8-13\\",\\"9-13\\",\\"10-13\\"]","RoomType" : "Sold"}';
        

        Test.setCurrentPage(pageRef);
        
        RC_HallPlanController controller = new RC_HallPlanController();        
        Object halllist = controller.HallList;
        controller.getHalls();
        controller.getHalls(hallItem.Id);
        
        
        pageRef.getParameters().put('hallId', hallItem.Id);
        pageRef.getParameters().put('designData', data);
        controller.currentHall = hallItem.Id;
        Test.setCurrentPage(pageRef);
        //controller.loadPage(fairItem.Id);
        controller.saveLayout();
        //controller = new RC_HallPlanController(); 
        
        controller.currentHall = hallItem.Id;
        controller.makeSell();
        pageRef.getParameters().put('soldId', parcelItem.Id);
        controller.removeSale();
        controller.reloadPage();
        List<SelectOption> unplacedList = controller.UnplacedAgreements;
        controller.setErrorMessage('TEST');
        controller.getErrorMessage();
        Test.StopTest();         
    }
    @isTest public static void runTestFair()
    {
        Test.StartTest();
        PageReference pageRef = Page.RC_HallPlanPage; 
        //RC_Fair__c fair =  [SELECT Id FROM RC_Fair__c LIMIT 1];
        RC_Hall__c hallItem =  [SELECT Id FROM RC_Hall__c LIMIT 1];
        RC_Fair__c fairItem =  [SELECT Id FROM RC_Fair__c WHERE RC_Related_Fair__c != null LIMIT 1];
        pageRef.getParameters().put('recordId', fairItem.Id);
        pageRef.getParameters().put('hallId', hallItem.Id);
        pageRef.getParameters().put('node', '{"HallId" : "'+hallItem.Id+'", "HallParcels" : [{"ParcelDesign" : "[\\"7-13\\",\\"8-13\\",\\"9-13\\",\\"10-13\\"]", "ParcelId" : "asd", "RoomSize" : 10, "RoomType" : "Sellable"}]}');
       
        Test.setCurrentPage(pageRef);
        
        RC_HallPlanController controller = new RC_HallPlanController();        
        controller.loadPage(fairItem.Id);
        controller.saveLayout();
        controller.reloadPage();
        //controller.updateParcelName();
        //controller.removeParcelDesign();
        Test.StopTest();         
    }
    @testSetup public static void SetupMethod()
    {
        system.debug('SetupMethod started');
        RC_TestClassUtils.createTestDatas();        
        
        RC_Fair__c fairobj = [SELECT ID FROM RC_Fair__c WHERE RC_Location__c = 'IST' LIMIT 1];
        RC_TestClassUtils.createHall(fairobj.Id);
    }
}