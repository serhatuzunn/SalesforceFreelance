public class LogoGetSozlesmeKalanJSONParser {

	public String sozlesmeNo {get;set;} 
	public Double kalanTutar {get;set;} 
	public Integer kayitsayisi {get;set;} 

	public LogoGetSozlesmeKalanJSONParser(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'sozlesmeNo') {
						sozlesmeNo = parser.getText();
					} else if (text == 'kalanTutar') {
						kalanTutar = parser.getDoubleValue();
					} else if (text == 'kayitsayisi') {
						kayitsayisi = parser.getIntegerValue();
					} else {
						System.debug(LoggingLevel.WARN, 'LogoGetSozlesmeKalanJSONParser consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	
	public static List<LogoGetSozlesmeKalanJSONParser> parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return arrayOfLogoGetSozlesmeKalanJSONParser(parser);
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
	




    private static List<LogoGetSozlesmeKalanJSONParser> arrayOfLogoGetSozlesmeKalanJSONParser(System.JSONParser p) {
        List<LogoGetSozlesmeKalanJSONParser> res = new List<LogoGetSozlesmeKalanJSONParser>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new LogoGetSozlesmeKalanJSONParser(p));
        }
        return res;
    }


}