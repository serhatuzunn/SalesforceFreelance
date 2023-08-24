public class GetFairCardLicenseParser {

	public Integer FairLicenseId {get;set;} 
	public Integer FairId {get;set;} 
	public String FairCode {get;set;} 
	public Integer LicenseId {get;set;} 
	public String DeviceName {get;set;} 
	public Integer FairCardId {get;set;} 
	public Boolean IsPaid {get;set;} 
	public Double Paid {get;set;} 
	public String PaidStatus {get;set;} 
	public Integer CardId {get;set;} 
	public String CardName {get;set;} 
	public String CardTitle {get;set;} 
	public String CardTitleEng {get;set;} 
	public Integer TypeId {get;set;} 
	public String TypeName {get;set;} 
	public Boolean IsForeign {get;set;} 
	public String ForeignStatus {get;set;} 
	public Integer TermId {get;set;} 
	public String TermName {get;set;} 
	public Integer FairDoorId {get;set;} 
	public Integer DoorId {get;set;} 
	public String DoorCode {get;set;} 
	public String DoorName {get;set;} 
	public String FullName {get;set;} 
    
    public GetFairCardLicenseParser()
    {
        
    }

	public GetFairCardLicenseParser(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'FairLicenseId') {
						FairLicenseId = parser.getIntegerValue();
					} else if (text == 'FairId') {
						FairId = parser.getIntegerValue();
					} else if (text == 'FairCode') {
						FairCode = parser.getText();
					} else if (text == 'LicenseId') {
						LicenseId = parser.getIntegerValue();
					} else if (text == 'DeviceName') {
						DeviceName = parser.getText();
					} else if (text == 'FairCardId') {
						FairCardId = parser.getIntegerValue();
					} else if (text == 'IsPaid') {
						IsPaid = parser.getBooleanValue();
					} else if (text == 'Paid') {
						Paid = parser.getDoubleValue();
					} else if (text == 'PaidStatus') {
						PaidStatus = parser.getText();
					} else if (text == 'CardId') {
						CardId = parser.getIntegerValue();
					} else if (text == 'CardName') {
						CardName = parser.getText();
					} else if (text == 'CardTitle') {
						CardTitle = parser.getText();
					} else if (text == 'CardTitleEng') {
						CardTitleEng = parser.getText();
					} else if (text == 'TypeId') {
						TypeId = parser.getIntegerValue();
					} else if (text == 'TypeName') {
						TypeName = parser.getText();
					} else if (text == 'IsForeign') {
						IsForeign = parser.getBooleanValue();
					} else if (text == 'ForeignStatus') {
						ForeignStatus = parser.getText();
					} else if (text == 'TermId') {
						TermId = parser.getIntegerValue();
					} else if (text == 'TermName') {
						TermName = parser.getText();
					} else if (text == 'FairDoorId') {
						FairDoorId = parser.getIntegerValue();
					} else if (text == 'DoorId') {
						DoorId = parser.getIntegerValue();
					} else if (text == 'DoorCode') {
						DoorCode = parser.getText();
					} else if (text == 'DoorName') {
						DoorName = parser.getText();
					} else if (text == 'FullName') {
						FullName = parser.getText();
					} else {
						System.debug(LoggingLevel.WARN, 'GetFairCardLicenseParser consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}	
	
	public static List<GetFairCardLicenseParser> parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return arrayOfGetFairCardLicenseParser(parser);
	}
	
	public static void consumeObject(System.JSONParser parser) {
		Integer depth = 0;
		do {
			System.JSONToken curr = parser.getCurrentToken();
			if (curr == System.JSONToken.START_OBJECT || 
				curr == System.JSONToken.START_ARRAY) {
				depth++;
			} else if (curr == System.JSONToken.END_OBJECT ||
				curr == System.JSONToken.END_ARRAY) {
				depth--;
			}
		} while (depth > 0 && parser.nextToken() != null);
	}

    private static List<GetFairCardLicenseParser> arrayOfGetFairCardLicenseParser(System.JSONParser p) {
        List<GetFairCardLicenseParser> res = new List<GetFairCardLicenseParser>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new GetFairCardLicenseParser(p));
        }
        return res;
    }
}