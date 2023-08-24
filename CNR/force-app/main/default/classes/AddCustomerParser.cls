public class AddCustomerParser {

	public String TableName {get;set;} 
	public Integer CustomerId {get;set;} 
	public String CustomerCode {get;set;} 
	public String Name {get;set;} 
	public String SurName {get;set;} 
	public String TCNumber {get;set;} 
	public String PassportNumber {get;set;} 
	public String Picture {get;set;} 
	public String CompanyName {get;set;} 
	public Integer CompanyTypeId {get;set;} 
	public Integer SectorId {get;set;} 
	public Integer SectorSubId {get;set;} 
	public Integer JobId {get;set;} 
	public Integer DecisionId {get;set;} 
	public String Mobile {get;set;} 
	public String Phone {get;set;} 
	public String Fax {get;set;} 
	public String ExtLine {get;set;} 
	public String Email {get;set;} 
	public String BirthDate {get;set;} 
	public Boolean Gender {get;set;} 
	public Boolean IsForeign {get;set;} 
	public String WebSite {get;set;} 
	public Integer CountryId {get;set;} 
	public Integer CityId {get;set;} 
	public Integer CountyId {get;set;} 
	public String CityOther {get;set;} 
	public String Address1 {get;set;} 
	public String Address2 {get;set;} 
	public String ZipCode {get;set;} 
	public Integer ContactTypeId {get;set;} 
	public Boolean IsNewVisit {get;set;} 
	public String CreateDate {get;set;} 
	public String UpdateDate {get;set;} 
	public Integer CreateUserId {get;set;} 
	public Integer UpdateUserId {get;set;} 
	public Integer CreateLicenseId {get;set;} 
	public Integer UpdateLicenseId {get;set;} 
	public Boolean IsDataShare {get;set;} 
	public Boolean ActiveFlg {get;set;} 
	public String Error {get;set;} 

    public AddCustomerParser()
    {
        
    }
	public AddCustomerParser(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'TableName') {
						TableName = parser.getText();
					} else if (text == 'CustomerId') {
						CustomerId = parser.getIntegerValue();
					} else if (text == 'CustomerCode') {
						CustomerCode = parser.getText();
					} else if (text == 'Name') {
						Name = parser.getText();
					} else if (text == 'SurName') {
						SurName = parser.getText();
					} else if (text == 'TCNumber') {
						TCNumber = parser.getText();
					} else if (text == 'PassportNumber') {
						PassportNumber = parser.getText();
					} else if (text == 'Picture') {
						Picture = parser.getText();
					} else if (text == 'CompanyName') {
						CompanyName = parser.getText();
					} else if (text == 'CompanyTypeId') {
						CompanyTypeId = parser.getIntegerValue();
					} else if (text == 'SectorId') {
						SectorId = parser.getIntegerValue();
					} else if (text == 'SectorSubId') {
						SectorSubId = parser.getIntegerValue();
					} else if (text == 'JobId') {
						JobId = parser.getIntegerValue();
					} else if (text == 'DecisionId') {
						DecisionId = parser.getIntegerValue();
					} else if (text == 'Mobile') {
						Mobile = parser.getText();
					} else if (text == 'Phone') {
						Phone = parser.getText();
					} else if (text == 'Fax') {
						Fax = parser.getText();
					} else if (text == 'ExtLine') {
						ExtLine = parser.getText();
					} else if (text == 'Email') {
						Email = parser.getText();
					} else if (text == 'BirthDate') {
						BirthDate = parser.getText();
					} else if (text == 'Gender') {
						Gender = parser.getBooleanValue();
					} else if (text == 'IsForeign') {
						IsForeign = parser.getBooleanValue();
					} else if (text == 'WebSite') {
						WebSite = parser.getText();
					} else if (text == 'CountryId') {
						CountryId = parser.getIntegerValue();
					} else if (text == 'CityId') {
						CityId = parser.getIntegerValue();
					} else if (text == 'CountyId') {
						CountyId = parser.getIntegerValue();
					} else if (text == 'CityOther') {
						CityOther = parser.getText();
					} else if (text == 'Address1') {
						Address1 = parser.getText();
					} else if (text == 'Address2') {
						Address2 = parser.getText();
					} else if (text == 'ZipCode') {
						ZipCode = parser.getText();
					} else if (text == 'ContactTypeId') {
						ContactTypeId = parser.getIntegerValue();
					} else if (text == 'IsNewVisit') {
						IsNewVisit = parser.getBooleanValue();
					} else if (text == 'CreateDate') {
						CreateDate = parser.getText();
					} else if (text == 'UpdateDate') {
						UpdateDate = parser.getText();
					} else if (text == 'CreateUserId') {
						CreateUserId = parser.getIntegerValue();
					} else if (text == 'UpdateUserId') {
						UpdateUserId = parser.getIntegerValue();
					} else if (text == 'CreateLicenseId') {
						CreateLicenseId = parser.getIntegerValue();
					} else if (text == 'UpdateLicenseId') {
						UpdateLicenseId = parser.getIntegerValue();
					} else if (text == 'IsDataShare') {
						IsDataShare = parser.getBooleanValue();
					} else if (text == 'ActiveFlg') {
						ActiveFlg = parser.getBooleanValue();
					} else if (text == 'Error') {
						Error = parser.getText();
					} else {
						System.debug(LoggingLevel.WARN, 'AddCustomerParser consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	public static List<AddCustomerParser> parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return arrayOfAddCustomerParser(parser);
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

    private static List<AddCustomerParser> arrayOfAddCustomerParser(System.JSONParser p) {
        List<AddCustomerParser> res = new List<AddCustomerParser>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new AddCustomerParser(p));
        }
        return res;
    }
}