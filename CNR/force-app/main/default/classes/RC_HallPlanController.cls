public without sharing class RC_HallPlanController {
 //deployment
    private String errorMessage ='T'; 
    public void setErrorMessage(String n) {
        errorMessage = n;
    }
    public String getErrorMessage() {
        return errorMessage;
    }

    public String currentDesign {get; set;} 
    public String currentHall {get; set;} 
    public Opportunity currentOpportunity {get; set;} 
    public RC_Fair__c currentFair {get; set;} 
    //DESIGN - SALE
    public String pageMode {get; set;} 
    public Integer opportunityTotal {get; set;}  
    private List<SelectOption> hallListTmp {get;set;}  
    public List<SelectOption> HallList
    {
        get
        {
            return hallListTmp;
            /*
            //zck! test added 2
            List<RC_Hall__c> halls =  getHallwi();
            HallList = new List<SelectOption>();
            for(RC_Hall__c item : halls)
            {
                HallList.add(new SelectOption(item.Id, item.Name));
            }             
            return HallList;
            */
        }
        set
        {
            hallListTmp = value;
        }
    }
    public Boolean IsShowManager {get; set;} 
    /*public RC_HallPlanController(ApexPages.StandardController controller)
    {
        IsShowManager = false;
        system.debug('StandardController');
        string recordId = controller.getId();
        if(String.isBlank(recordId))
        {
            recordId = Apexpages.currentPage().getParameters().get('recordId');
        }
        loadPage(recordId);
    }*/
    public RC_HallPlanController() {
        IsShowManager = false;
        system.debug('CustomController');
        try {
            opportunityTotal = 0;
            String recordId = Apexpages.currentPage().getParameters().get('recordId');
            //errorMessage = Apexpages.currentPage().getParameters().get('errorMessage');
            //system.debug(errorMessage);
            if(string.isNotBlank(recordId))
            {
                String objectName = findObjectAPIName(recordId);
                if(objectName == 'Opportunity')
                {
                    pageMode = 'SALE';
                }
                else if(objectName == 'RC_Fair__c')
                {
                    pageMode = 'DESIGN';
                }
            }
            system.debug(recordId);
            loadPage(recordId);
        }
         catch (Exception ex) {
            system.debug(ex.getMessage());
            system.debug(ex.getStackTraceString());
        }
    }
    public void loadPage(String recordId)
    {
        String fairIdTemp = '';
        String fairLocationTemp = '';
        if(String.isNotBlank(recordId) && pageMode == 'SALE')
        {
            currentOpportunity = (Opportunity) [SELECT Id,CreatedDate,Account.RC_Brand__c,Account.Name,RC_Fair__r.Id,RC_Fair__r.Name,RC_Fair__r.RC_Short_Name__c,RC_Fair__r.RC_Location__c,StageName,(SELECT Quantity FROM OpportunityLineItems) FROM Opportunity WHERE Id =: recordId LIMIT 1];
            fairIdTemp = currentOpportunity.RC_Fair__r.Id;
            fairLocationTemp = currentOpportunity.RC_Fair__r.RC_Location__c;
            opportunityTotal = 0; 
            for(OpportunityLineItem item : currentOpportunity.OpportunityLineItems)
            {
                opportunityTotal += Integer.valueOf(item.Quantity); 
            }
            // for(RC_Parcel__c item : currentOpportunity.Parcels__r)
            // {
            //     opportunityUsed += item.RC_Size__c;
            // }
        }
        else if(String.isNotBlank(recordId) && pageMode == 'DESIGN')
        {
            currentFair = (RC_Fair__c) [SELECT Id,Name,RC_Location__c FROM RC_Fair__c WHERE Id =: recordId LIMIT 1];
            fairIdTemp = currentFair.Id;
            fairLocationTemp = currentFair.RC_Location__c;
        }
        getTeamRole(fairIdTemp);
        String para = Apexpages.currentPage().getParameters().get('hallId');
        system.debug(para);
        List<RC_Hall__c> firstHall = null;
        /*
        if(String.isNotEmpty(para))
        {
            firstHall = getHalls(para);
        }
        else {
            firstHall = getHallWithFair(fairIdTemp,fairLocationTemp);
            //firstHall = getHalls();
        }*/
          firstHall = getHallWithFair(fairIdTemp,fairLocationTemp);
        if(firstHall != null && firstHall.size() > 0)
        {
            HallLayout layoutItem = null;
            string layoutId = '';
            if(String.isNotEmpty(para))
            {
                for(RC_Hall__c hallItem : firstHall)
                {
                    if(hallItem.Id == para)
                    {
                        layoutId = hallItem.Id;
                        break;
                    }
                }
            }
            else {
                layoutId = firstHall[0].Id;
            }
            layoutItem= getPageLayout(layoutId);                
            
            currentDesign = JSON.serialize(layoutItem);
            system.debug('Current Design : '+ currentDesign);
        }
    }
    public void getTeamRole(String FairId)
    {
        List<RC_Fair_Team__c> fairTeam = [SELECT General_Manager__c FROM RC_Fair_Team__c Where RC_Fair__c =: FairId AND RC_User_Name__c =: UserInfo.getUserId()];
        if(fairTeam.size() > 0)
        {
            RC_Fair_Team__c fairTeamItem = (RC_Fair_Team__c)fairTeam.get(0);
            IsShowManager = (String.isNotBlank(fairTeamItem.General_Manager__c) && fairTeamItem.General_Manager__c != 'Sales');            
        }
    }
    public List<SelectOption> UnplacedAgreements
    {
        get
        {
            List<SelectOption> retVal = new List<SelectOption>();
            string fairId = '';
            if(currentFair != null)
            {
                fairId = currentFair.Id;
            }
            if(currentOpportunity != null)
            {
                fairId = currentOpportunity.RC_Fair__c;
            }
            List<Opportunity> oppList = [SELECT Id,Account.Name,Account.RC_Brand__c,(SELECT Quantity FROM OpportunityLineItems) FROM Opportunity WHERE RC_Reserved__c = false AND RC_Fair__c =: fairId];
            system.debug(oppList);

            for(Opportunity oppItem : oppList)
            {
                Integer opportunityTotalQuantity = 0; 
                for(OpportunityLineItem item : oppItem.OpportunityLineItems)
                {
                    opportunityTotalQuantity += Integer.valueOf(item.Quantity); 
                }
                String sizeMessage = ' (' + opportunityTotalQuantity + ' m2)';
                if(String.isNotBlank(oppItem.Account.RC_Brand__c))
                {
                    retVal.Add(new SelectOption(oppItem.Id, oppItem.Account.RC_Brand__c + sizeMessage));
                }
                else
                {
                    retVal.Add(new SelectOption(oppItem.Id, '???' + sizeMessage ));
                }
            }

            return retVal;
        }
    }
    public Pagereference reloadPage()
    {
        Pagereference retVal = Page.RC_HallPlanPage; //new PageReference('/apex/RC_HallPlanPage'); //Apexpages.currentPage();
        
        //Pagereference retVal = Apexpages.currentPage();
        system.debug(currentHall);
        //String hallId = Apexpages.currentPage().getParameters().get('hallId');
        if(String.isNotEmpty(currentHall))
        {
            retVal.setRedirect(true);
            retVal.getParameters().put('hallId',currentHall);
        }
        if(currentOpportunity != null)
        {
            retVal.getParameters().put('recordId',currentOpportunity.Id);
        }
        else if(currentFair != null)
        {
            retVal.getParameters().put('recordId',currentFair.Id);
        }
        system.debug(currentHall);
        return retVal;
    }
//    public String reloadPage()
//    {
//        return 'test data';
//    }
    public List<RC_Hall__c> getHallWithFair(String fairId,String LocationValue)
    {
        //Fuara ait hallleri getirmek için aşağıdaki kodların düzenlenip fonksiyon haline getirilmesi gerekir.
        //agreement üzerinden gelindiğinde kayıt üzerinden fuar id alınabilir
        //
        RC_Fair__c fair = [SELECT Id,Name,Hall__c FROM RC_Fair__c WHERE Id =: fairId LIMIT 1];

        system.debug(fair);
        system.debug(fair.Hall__c.Split(';'));
        List<string> idList = fair.Hall__c.Split(';');
        List<RC_Hall__c> hallListinternal = [SELECT Id,Name FROM RC_Hall__c WHERE  Name =: idList AND Location__c =: LocationValue  ORDER BY NAME];
        system.debug(hallListinternal); 
        HallList = new List<SelectOption>();
        for(RC_Hall__c item : hallListinternal)
        {
            HallList.Add(new SelectOption(item.Id, item.Name));
        }       
        return hallListinternal;   
    }
    public List<RC_Hall__c> getHalls()
    {
        
        return [SELECT Id,Name,Location__c FROM RC_Hall__c ORDER BY NAME];
    }
    public List<RC_Hall__c> getHalls(String HallId)
    {
        return [SELECT Id,Name,Location__c FROM RC_Hall__c WHERE Id =: HallId];
    }
    public HallLayout getPageLayout(Id hallId)
    {
        HallLayout layoutitem = new HallLayout();
        layoutitem.HallId = hallId;
        layoutitem.HallParcels = new List<ParcelModel>();
        /*List<RC_Parcel__c> parcelList = [SELECT 
        Name,
        RC_Hall__c,
        RC_Hall__r.Name,
        RC_Hall__r.RC_Height__c,
        RC_Hall__r.RC_Left__c,
        RC_Hall__r.RC_Length__c,
        RC_Hall__r.Location__c,
        RC_Hall__r.RC_Top__c,
        RC_Hall__r.RC_Width__c,
        RC_Parcel_Id__c,
        RC_Size__c,
        RC_Design__c,
        RC_Fair__c,
        RC_Type__c,
        Id
        FROM RC_Parcel__c
        WHERE RC_Hall__c =: hallId];*/

        // fuar id ile çekim yapılmalı
        String fairId = '';
        if(currentFair != null)
        {
            fairId = currentFair.Id;
        }
        else if(currentOpportunity != null)
        {
            fairId = currentOpportunity.RC_Fair__c;
        }
        String recordTypeId = Schema.SObjectType.RC_Parcel__c.getRecordTypeInfosByDeveloperName().get('RC_Design').getRecordTypeId();
        RC_Hall__c hallItem = [SELECT Id,Name,RC_Height__c,RC_Left__c,RC_Length__c,Location__c,RC_Top__c,RC_Width__c,RC_Hall_Image__c,
        (SELECT Id,Name,RC_Parcel_Id__c,RC_Size__c,RC_Design__c, RC_Fair__c,RC_Type__c,RC_Agreement__r.Account.RC_Brand__c,RC_Agreement__r.Account.Name,RC_Agreement__r.StageName FROM Parcels__r WHERE RC_Fair__c =:fairId )
         FROM RC_Hall__c WHERE Id =: hallId  LIMIT 1];
        
         
        List<ContentVersion> versionId =  [SELECT Id FROM ContentVersion WHERE ContentDocumentId =: hallItem.RC_Hall_Image__c LIMIT 1];

        layoutitem.HallHeight = hallItem.RC_Height__c;
        layoutitem.HallLeft = hallItem.RC_Left__c;
        layoutitem.HallLength = hallItem.RC_Length__c;
        layoutitem.HallLocation = hallItem.Location__c;
        layoutitem.ImageURL = '';
        if(versionId != null && versionId.size() > 0)
        {
            layoutitem.ImageURL =  '/sfc/servlet.shepherd/version/download/' +versionId[0].Id + '?operationContext=S1';
        }
        layoutitem.HallTop = hallItem.RC_Top__c;
        layoutitem.HallWidth = hallItem.RC_Width__c;
        layoutitem.HallName = hallItem.Name;

        //Boolean hallFilled = false;
        if(hallItem.Parcels__r.size() > 0)
        {
            for(RC_Parcel__c parcelItem : hallItem.Parcels__r)
            { 
                ParcelModel modelItem = new ParcelModel();
                modelItem.SfId = parcelItem.Id;
                modelItem.ParcelId = parcelItem.RC_Parcel_Id__c;
                modelItem.ParcelName = parcelItem.Name;
                modelItem.RoomType = parcelItem.RC_Type__c;
                modelItem.RoomSize = parcelItem.RC_Size__c;
                modelItem.ParcelDesign = parcelItem.RC_Design__c;
                modelItem.AccountName = parcelItem.RC_Agreement__r.Account.RC_Brand__c;    
                if(parcelItem.RC_Agreement__r.Account.RC_Brand__c == null)
                { 
                    modelItem.AccountName = '???';
                }
                layoutitem.HallParcels.add(modelItem);
            }
        }
        return layoutitem;
    }
    public PageReference saveLayout()
    {
        String para = Apexpages.currentPage().getParameters().get('node');
        system.debug(para);
        if(para != null)
        {
            HallLayout hallItem = (HallLayout)JSON.deserialize(para, HallLayout.class);
            List<RC_Parcel__c> upsertList = new List<RC_Parcel__c>();

            if(hallItem != null && hallItem.HallParcels != null && hallItem.HallParcels.size() > 0)
            {
                String recordTypeId = Schema.SObjectType.RC_Parcel__c.getRecordTypeInfosByDeveloperName().get('RC_Design').getRecordTypeId();
                for(ParcelModel modelItem : hallItem.HallParcels)
                {
                    RC_Parcel__c parcelItem = new RC_Parcel__c();
                    parcelItem.Name = modelItem.ParcelName;
                    parcelItem.RC_Hall__c = hallItem.HallId;
                    parcelItem.RC_Design__c = modelItem.ParcelDesign;
                    parcelItem.RC_Parcel_Id__c = modelItem.ParcelId;
                    parcelItem.RC_Size__c = modelItem.RoomSize;
                    parcelItem.RC_Type__c = modelItem.RoomType;
                    parcelItem.RecordTypeId = recordTypeId;
                    parcelItem.RC_Fair__c = currentFair.Id;
                    upsertList.add(parcelItem);
                }
                //RC_Parcel__c.RC_Parcel_Id__c
                List<Database.UpsertResult> srList = Database.upsert(upsertList, RC_Parcel__c.RC_Parcel_Id__c);
                if(srList != null)
                {
                    for(Database.UpsertResult srItem : srList)
                    {
                        if(!srItem.isSuccess())
                        {
                            for(Database.Error err : srItem.getErrors())
                            {
                                system.debug(err.getMessage());
                            }
                        }
                    }
                }
            }
        }
        //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM,'Layout Saved');
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM, System.Label.RC_Hall_LayoutSaved);
        ApexPages.addMessage(myMsg);
        PageReference tempPage = ApexPages.currentPage();            
        //tempPage.setRedirect(true);
        return tempPage;
    }

    public Pagereference makeSell()
    {
                                // <apex:param id="anode2" name="hallId" value="" />
                                // <apex:param id="anode3" name="recordId" value="" />
                                // <apex:param id="anode4" name="designData" value="" />
        String hallID = Apexpages.currentPage().getParameters().get('hallId');
        String recordId = Apexpages.currentPage().getParameters().get('recordId');
        String designData = Apexpages.currentPage().getParameters().get('designData');

        system.debug(hallID);
        system.debug(recordId);
        system.debug(designData);
        
        Integer retVal = saveSell(designData);        
        system.debug(retVal);
        PageReference tempPage = ApexPages.currentPage();            
        if(retVal == 3)
        {
            errorMessage = System.Label.RC_Hall_AlreadySoldAgreement;
        }
        else if(retVal == 2)
        {
            errorMessage = System.Label.RC_Hall_AlreadySold;
            // tempPage = ApexPages.currentPage();
            
            // tempPage.getParameters().put('hallId',hallID);         
            // tempPage.getParameters().put('recordId',recordId);         
            // tempPage.setRedirect(true);
        }
        else if(retVal == 1) {
            errorMessage = System.Label.RC_Hall_Success;
        }
        else {
            errorMessage = System.Label.RC_Hall_UndefinedError;
        }
        //Apexpages.currentPage().getParameters().put('errorMessage',errorMessage);         
        //tempPage.getParameters().put('errorMessage',errorMessage);         
        /*Pagereference pr = Page.RC_HallPlanPage;
        pr.getParameters().put('errorMessage',errorMessage);      */   
        return null;
    }
    //0 : Undefined Error
    //1 : Success
    //2 : Already Sold Parcel
    //3 : Already Sold Agreement
    public Integer  saveSell(String sellData)
    {
        //String data = '{"ParentParcelId" : "a058E00000AE5EhQAL","AgreementId" : "0068E00000NkMhoQAF","RoomSize" : 10,"ParcelDesign" : "[\\"7-13\\",\\"8-13\\",\\"9-13\\",\\"10-13\\"]","RoomType" : "Sold"}';
        Integer retVal = 0;
        String recordTypeId = Schema.SObjectType.RC_Parcel__c.getRecordTypeInfosByDeveloperName().get('RC_Sell').getRecordTypeId();
        ParcelModel sellItem = (ParcelModel)JSON.deserialize(sellData, ParcelModel.class);
        Boolean sold = CheckAgreementSold(sellItem.AgreementId);
        if(!sold)
        {
            Boolean exists = CheckParcelSold(sellItem.ParcelDesign, sellItem.ParentParcelId);
            if(!exists)
            {
                RC_Parcel__c saleparcelItem = new RC_Parcel__c();
                saleparcelItem.RC_Hall__c = currentHall;
                saleparcelItem.RC_Parcel_Id__c = RC_GuidUtil.NewGuid();
                saleparcelItem.RC_ParentParcel__c = sellItem.ParentParcelId;
                saleparcelItem.RC_Agreement__c = sellItem.AgreementId;
                saleparcelItem.RC_Size__c = sellItem.RoomSize;
                saleparcelItem.RC_Design__c = sellItem.ParcelDesign;
                saleparcelItem.RC_Type__c = sellItem.RoomType;
                saleparcelItem.RecordTypeId = recordTypeId;
                saleparcelItem.RC_Fair__c = currentOpportunity.RC_Fair__r.Id;
        
                Database.SaveResult srItem = Database.insert(saleparcelItem);
                if(srItem != null)
                {
                    if(srItem.isSuccess())
                    {
                        retVal = 1;
                        system.debug(srItem.getId());
                        Opportunity opp = new Opportunity(Id = sellItem.AgreementId);
                        opp.RC_Reserved__c = true;
                        Database.SaveResult srOpt = Database.update(opp);
                        if(!srOpt.isSuccess())
                        {
                            for(Database.Error errItem : srOpt.getErrors())
                            {
                                system.debug(errItem.getMessage());
                            }    
                        }
                        else {
                            if(!CheckSoldParcelExist(srItem.getId()))
                            {
                                retVal = 2;
                            }
                        }
                    }
                    else {
                        for(Database.Error errItem : srItem.getErrors())
                        {
                            system.debug(errItem.getMessage());
                        }
                    }
                }
            }
            else {
                retVal = 2;
            }
        }
        else {
            retVal = 3;
        }
        return retVal;
    }
    public Boolean CheckAgreementSold(string AgreementId)
    {
        Boolean retVal = false;
        List<Opportunity> opt = [SELECT RC_Reserved__c FROM Opportunity WHERE Id =: AgreementId LIMIT 1];
        if(opt.size() > 0)
        {
            if(opt.get(0).RC_Reserved__c)
            {
                retVal = true;
            }
        }
        return retVal;
    }
    public Boolean CheckParcelSold(String ParcelDesign, String ParentParcelId)
    {
        Boolean retVal = false;

        List<RC_Parcel__c> parcelList = [SELECT RC_Design__c FROM RC_Parcel__c WHERE RC_ParentParcel__c =:ParentParcelId];
        List<string> currentParcelItemList = (List<String>)JSON.deserialize(ParcelDesign, List<String>.class);
        for(RC_Parcel__c parcelItem : parcelList)
        {
            List<string> savedParcelItem = (List<String>)JSON.deserialize(parcelItem.RC_Design__c, List<String>.class);
            for(string savedItem : savedParcelItem)
            {
                if(currentParcelItemList.contains(savedItem))
                {
                    retVal = true;
                    break;
                }
            }
        }
        return retVal;
    }
    public Boolean CheckSoldParcelExist(String SelfId)
    {
        Boolean retVal = false;
        List<RC_Parcel__c> parcelList = [SELECT RC_Design__c FROM RC_Parcel__c WHERE  Id =: SelfId];
        retVal  = parcelList.size() == 1;
        system.debug(parcelList.size());
        return retVal;
    }
    public Boolean CheckParcelSold(String ParcelDesign, String ParentParcelId, String SelfId)
    {
        Boolean retVal = false;

        List<RC_Parcel__c> parcelList = [SELECT RC_Design__c FROM RC_Parcel__c WHERE RC_ParentParcel__c =:ParentParcelId And Id !=: SelfId];
        List<string> currentParcelItemList = (List<String>)JSON.deserialize(ParcelDesign, List<String>.class);
        for(RC_Parcel__c parcelItem : parcelList)
        {
            List<string> savedParcelItem = (List<String>)JSON.deserialize(parcelItem.RC_Design__c, List<String>.class);
            for(string savedItem : savedParcelItem)
            {
                if(currentParcelItemList.contains(savedItem))
                {
                    retVal = true;
                    break;
                }
            }
        }
        return retVal;
    }
    public PageReference removeSale()
    {
      
        Boolean deletedResult = false; 
        String hallID = Apexpages.currentPage().getParameters().get('hallId');
        String soldSfId = Apexpages.currentPage().getParameters().get('soldId');
        String recordId = Apexpages.currentPage().getParameters().get('recordId');
        
        if(string.isNotBlank(soldSfId))
        {
            deletedResult = dataremoveSale(soldSfId,recordId); 
        }
        if(!deletedResult)
        {
            errorMessage = System.Label.RC_Hall_CanNotDelete;
           //tempPage.setRedirect(true);
            //tempPage = ApexPages.currentPage();          
        }
        else {
            errorMessage = System.Label.RC_Hall_Success;
        }
        //PageReference tempPage = ApexPages.currentPage();
        return null;
        
    }
    public boolean dataremoveSale(String SoldSfId, String OppId)
    {
        Boolean retVal = false;
        Boolean canRemove = false;
        RC_Parcel__c currentParcel = [SELECT Id, RC_Agreement__c FROM RC_Parcel__c WHERE Id =: SoldSfId LIMIT 1];
        if(IsShowManager || (currentParcel.RC_Agreement__c == OppId))
        {
            canRemove = true;
        }
        if(canRemove)
        {
            Database.DeleteResult dr = database.delete(SoldSfId);
            if(dr.isSuccess())
            {
                retVal = true;
                
                Opportunity opp = new Opportunity(Id = currentParcel.RC_Agreement__c);
                opp.RC_Reserved__c = false;
                if(currentParcel != null && currentParcel.RC_Agreement__c != null)
                {
                    Database.update(opp);
                }
            }
            else {
                for(Database.Error err : dr.getErrors())
                {
                    System.debug(err.getMessage());
                }
            }
        }
        return retVal;
    }
    public PageReference removeParcelDesign()
    {
        String ParcelId = Apexpages.currentPage().getParameters().get('ParcelId');
        RC_Parcel__c parcel = new RC_Parcel__c(Id = ParcelId);
        

        Database.DeleteResult sr = Database.delete(parcel);

        PageReference tempPage = ApexPages.currentPage();
        return tempPage;
    }
    public PageReference updateParcelName()
    {
        String ParcelId = Apexpages.currentPage().getParameters().get('ParcelId');
        String newName = Apexpages.currentPage().getParameters().get('newName');
        
        RC_Parcel__c parcel = new RC_Parcel__c(Id = ParcelId);
        parcel.Name = newName;

        Database.SaveResult sr = Database.update(parcel);

        PageReference tempPage = ApexPages.currentPage();
        return tempPage;
    }
    public string findObjectAPIName( String recordId ){
    if(recordId == null)
        return null;
    String objectAPIName = '';
    String keyPrefix = recordId.substring(0,3);
        for( Schema.SObjectType obj : Schema.getGlobalDescribe().Values() ){
            String prefix = obj.getDescribe().getKeyPrefix();
            if(prefix == keyPrefix){
                        objectAPIName = obj.getDescribe().getName();
                        break;
            }
        }

        return objectAPIName;
}

 

    public class HallLayout
    {
        public string HallId {get; set;}
        public string HallName {get; set;}
        public Decimal HallHeight {get; set;}
        public Decimal HallLeft{get; set;}
        public Decimal HallLength {get; set;}
        public string HallLocation {get; set;}
        public string ImageURL {get; set;}
        public Decimal HallTop {get; set;}
        public Decimal HallWidth {get; set;}
        public List<ParcelModel> HallParcels {get; set;}
    }
    public class ParcelModel
    {
        public string SfId {get; set;}
        public string ParcelId {get;set;}
        public string ParcelName {get; set;}
        public string ParcelDesign {get; set;}
        public string RoomType {get; set;}
        public Decimal RoomSize {get; set;}
        public string ParentParcelId {get; set;}
        public string AgreementId {get; set;}
        public string AccountName {get; set;}
    }
}