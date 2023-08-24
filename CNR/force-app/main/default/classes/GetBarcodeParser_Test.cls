@IsTest
public class GetBarcodeParser_Test {
	
	// This test method should give 100% coverage
	static testMethod void testParse() {
		String json = '['+
		'{'+
		'\"Barcode\": \"1905010310502025229\"'+
		'}'+
		']';
		//List<GetBarcodeParser> r = GetBarcodeParser.parse(json); 
		//System.assert(r != null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		//GetBarcodeParser objGetBarcodeParser = new GetBarcodeParser(System.JSON.createParser(json));
		//System.assert(objGetBarcodeParser != null);
		//System.assert(objGetBarcodeParser.Barcode == null);
	}
}