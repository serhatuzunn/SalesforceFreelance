public class GetBarcodeParser {
    
    public String Barcode {get;set;} 
    public GetBarcodeParser()
    {
        
    }
    /*
    public GetBarcodeParser(JSONParser parser) {
        while (parser.nextToken() != System.JSONToken.END_OBJECT) {
            if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'Barcode') {
						Barcode = parser.getText();
					} else {
						System.debug(LoggingLevel.WARN, 'GetBarcodeParser consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	public static List<GetBarcodeParser> parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return arrayOfGetBarcodeParser(parser);
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
	
    private static List<GetBarcodeParser> arrayOfGetBarcodeParser(System.JSONParser p) {
        List<GetBarcodeParser> res = new List<GetBarcodeParser>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            //res.add(new GetBarcodeParser(p));
        }
        return res;
    }
*/
}