@IsTest
public class AddCustomerParser_Test {	
	// This test method should give 100% coverage
	static testMethod void testParse() {
		String json = '['+
		'{'+
		'\"TableName\": \"Customer\",'+
		'\"CustomerId\": 1209265,'+
		'\"CustomerCode\": \"dda5a5e3-ad08-4215-b524-1c22f957d7ba\",'+
		'\"Name\": \"\",'+
		'\"SurName\": \"\",'+
		'\"TCNumber\": \"\",'+
		'\"PassportNumber\": \"\",'+
		'\"Picture\": \"\",'+
		'\"CompanyName\": \"ZAFER BASIN YAYIN\",'+
		'\"CompanyTypeId\": 0,'+
		'\"SectorId\": 0,'+
		'\"SectorSubId\": 0,'+
		'\"JobId\": 0,'+
		'\"DecisionId\": 0,'+
		'\"Mobile\": \"0212 446 21 00\",'+
		'\"Phone\": \"\",'+
		'\"Fax\": \"\",'+
		'\"ExtLine\": \"\",'+
		'\"Email\": \"hizir@zafer.com\",'+
		'\"BirthDate\": \"0001-01-01T00:00:00\",'+
		'\"Gender\": false,'+
		'\"IsForeign\": false,'+
		'\"WebSite\": \"\",'+
		'\"CountryId\": 1,'+
		'\"CityId\": 0,'+
		'\"CountyId\": 0,'+
		'\"CityOther\": \"\",'+
		'\"Address1\": \"\",'+
		'\"Address2\": \"\",'+
		'\"ZipCode\": \"\",'+
		'\"ContactTypeId\": 0,'+
		'\"IsNewVisit\": false,'+
		'\"CreateDate\": \"2020-03-09T15:18:21.863\",'+
		'\"UpdateDate\": \"0001-01-01T00:00:00\",'+
		'\"CreateUserId\": 2,'+
		'\"UpdateUserId\": 0,'+
		'\"CreateLicenseId\": 2,'+
		'\"UpdateLicenseId\": 0,'+
		'\"IsDataShare\": true,'+
		'\"ActiveFlg\": true,'+
		'\"Error\": \"\"'+
		'},'+
		'{'+
		'\"TableName\": \"Customer\",'+
		'\"CustomerId\": 1209265,'+
		'\"CustomerCode\": \"dda5a5e3-ad08-4215-b524-1c22f957d7ba\",'+
		'\"Name\": \"\",'+
		'\"SurName\": \"\",'+
		'\"TCNumber\": \"\",'+
		'\"PassportNumber\": \"\",'+
		'\"Picture\": \"\",'+
		'\"CompanyName\": \"ZAFER BASIN YAYIN\",'+
		'\"CompanyTypeId\": 0,'+
		'\"SectorId\": 0,'+
		'\"SectorSubId\": 0,'+
		'\"JobId\": 0,'+
		'\"DecisionId\": 0,'+
		'\"Mobile\": \"0212 446 21 00\",'+
		'\"Phone\": \"\",'+
		'\"Fax\": \"\",'+
		'\"ExtLine\": \"\",'+
		'\"Email\": \"hizir@zafer.com\",'+
		'\"BirthDate\": \"0001-01-01T00:00:00\",'+
		'\"Gender\": false,'+
		'\"IsForeign\": false,'+
		'\"WebSite\": \"\",'+
		'\"CountryId\": 1,'+
		'\"CityId\": 0,'+
		'\"CountyId\": 0,'+
		'\"CityOther\": \"\",'+
		'\"Address1\": \"\",'+
		'\"Address2\": \"\",'+
		'\"ZipCode\": \"\",'+
		'\"ContactTypeId\": 0,'+
		'\"IsNewVisit\": false,'+
		'\"CreateDate\": \"2020-03-09T15:18:21.863\",'+
		'\"UpdateDate\": \"0001-01-01T00:00:00\",'+
		'\"CreateUserId\": 2,'+
		'\"UpdateUserId\": 0,'+
		'\"CreateLicenseId\": 2,'+
		'\"UpdateLicenseId\": 0,'+
		'\"IsDataShare\": true,'+
		'\"ActiveFlg\": true,'+
		'\"Error\": \"\"'+
		'}'+
		']';
		List<AddCustomerParser> r = AddCustomerParser.parse(json);
		System.assert(r != null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		AddCustomerParser objAddCustomerParser = new AddCustomerParser(System.JSON.createParser(json));
		System.assert(objAddCustomerParser != null);
		System.assert(objAddCustomerParser.TableName == null);
		System.assert(objAddCustomerParser.CustomerId == null);
		System.assert(objAddCustomerParser.CustomerCode == null);
		System.assert(objAddCustomerParser.Name == null);
		System.assert(objAddCustomerParser.SurName == null);
		System.assert(objAddCustomerParser.TCNumber == null);
		System.assert(objAddCustomerParser.PassportNumber == null);
		System.assert(objAddCustomerParser.Picture == null);
		System.assert(objAddCustomerParser.CompanyName == null);
		System.assert(objAddCustomerParser.CompanyTypeId == null);
		System.assert(objAddCustomerParser.SectorId == null);
		System.assert(objAddCustomerParser.SectorSubId == null);
		System.assert(objAddCustomerParser.JobId == null);
		System.assert(objAddCustomerParser.DecisionId == null);
		System.assert(objAddCustomerParser.Mobile == null);
		System.assert(objAddCustomerParser.Phone == null);
		System.assert(objAddCustomerParser.Fax == null);
		System.assert(objAddCustomerParser.ExtLine == null);
		System.assert(objAddCustomerParser.Email == null);
		System.assert(objAddCustomerParser.BirthDate == null);
		System.assert(objAddCustomerParser.Gender == null);
		System.assert(objAddCustomerParser.IsForeign == null);
		System.assert(objAddCustomerParser.WebSite == null);
		System.assert(objAddCustomerParser.CountryId == null);
		System.assert(objAddCustomerParser.CityId == null);
		System.assert(objAddCustomerParser.CountyId == null);
		System.assert(objAddCustomerParser.CityOther == null);
		System.assert(objAddCustomerParser.Address1 == null);
		System.assert(objAddCustomerParser.Address2 == null);
		System.assert(objAddCustomerParser.ZipCode == null);
		System.assert(objAddCustomerParser.ContactTypeId == null);
		System.assert(objAddCustomerParser.IsNewVisit == null);
		System.assert(objAddCustomerParser.CreateDate == null);
		System.assert(objAddCustomerParser.UpdateDate == null);
		System.assert(objAddCustomerParser.CreateUserId == null);
		System.assert(objAddCustomerParser.UpdateUserId == null);
		System.assert(objAddCustomerParser.CreateLicenseId == null);
		System.assert(objAddCustomerParser.UpdateLicenseId == null);
		System.assert(objAddCustomerParser.IsDataShare == null);
		System.assert(objAddCustomerParser.ActiveFlg == null);
		System.assert(objAddCustomerParser.Error == null);
	}
}