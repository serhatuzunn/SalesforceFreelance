@IsTest
public class LogoGetSozlesmeKalanJSONParser_Test {
	
	// This test method should give 100% coverage
	static testMethod void testParse() {
		String json = '[{'+
		'\"sozlesmeNo\": \"000077\",'+
		'\"kalanTutar\": 0.0,'+
		'\"kayitsayisi\": 0'+
		'}]';
		List<LogoGetSozlesmeKalanJSONParser> r = LogoGetSozlesmeKalanJSONParser.parse(json);
		System.assert(r != null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		LogoGetSozlesmeKalanJSONParser objLogoGetSozlesmeKalanJSONParser = new LogoGetSozlesmeKalanJSONParser(System.JSON.createParser(json));
		System.assert(objLogoGetSozlesmeKalanJSONParser != null);
		System.assert(objLogoGetSozlesmeKalanJSONParser.sozlesmeNo == null);
		System.assert(objLogoGetSozlesmeKalanJSONParser.kalanTutar == null);
		System.assert(objLogoGetSozlesmeKalanJSONParser.kayitsayisi == null);
	}
}