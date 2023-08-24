@IsTest
public class LogoGetCariBakiyeJSONParser_Test {
	
	// This test method should give 100% coverage
	static testMethod void testParse() {
		String json = '['+
		'{'+
		'\"cariref\": 299491,'+
		'\"kodu\": \"144\",'+
		'\"unvani\": \"4E YAYIN YAPIM ILETISIM PAZ.SAN.TIC.LTD.STI. (KARATAY)\",'+
		'\"sehir\": \"\",'+
		'\"odemeplani\": \"\",'+
		'\"masrafmerkezi\": \"\",'+
		'\"projekodu\": \"\",'+
		'\"bakiye\": 17073.42,'+
		'\"risklimit\": 0,'+
		'\"cekdurumu\": \"\"'+
		'}'+
		']';
		List<LogoGetCariBakiyeJSONParser> r = LogoGetCariBakiyeJSONParser.parse(json);
		System.assert(r != null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		LogoGetCariBakiyeJSONParser objLogoGetCariBakiyeJSONParser = new LogoGetCariBakiyeJSONParser(System.JSON.createParser(json));
		System.assert(objLogoGetCariBakiyeJSONParser != null);
		System.assert(objLogoGetCariBakiyeJSONParser.cariref == null);
		System.assert(objLogoGetCariBakiyeJSONParser.kodu == null);
		System.assert(objLogoGetCariBakiyeJSONParser.unvani == null);
		System.assert(objLogoGetCariBakiyeJSONParser.sehir == null);
		System.assert(objLogoGetCariBakiyeJSONParser.odemeplani == null);
		System.assert(objLogoGetCariBakiyeJSONParser.masrafmerkezi == null);
		System.assert(objLogoGetCariBakiyeJSONParser.projekodu == null);
		System.assert(objLogoGetCariBakiyeJSONParser.bakiye == null);
		System.assert(objLogoGetCariBakiyeJSONParser.risklimit == null);
		System.assert(objLogoGetCariBakiyeJSONParser.cekdurumu == null);
	}
}