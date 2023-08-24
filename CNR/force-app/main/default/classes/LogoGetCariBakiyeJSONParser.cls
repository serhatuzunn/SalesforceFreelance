public class LogoGetCariBakiyeJSONParser {

	public Integer cariref {get;set;} 
	public String kodu {get;set;} 
	public String unvani {get;set;} 
	public String sehir {get;set;} 
	public String odemeplani {get;set;} 
	public String masrafmerkezi {get;set;} 
	public String projekodu {get;set;} 
	public Double bakiye {get;set;} 
	public Integer risklimit {get;set;} 
	public String cekdurumu {get;set;} 

	public LogoGetCariBakiyeJSONParser(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'cariref') {
						cariref = parser.getIntegerValue();
					} else if (text == 'kodu') {
						kodu = parser.getText();
					} else if (text == 'unvani') {
						unvani = parser.getText();
					} else if (text == 'sehir') {
						sehir = parser.getText();
					} else if (text == 'odemeplani') {
						odemeplani = parser.getText();
					} else if (text == 'masrafmerkezi') {
						masrafmerkezi = parser.getText();
					} else if (text == 'projekodu') {
						projekodu = parser.getText();
					} else if (text == 'bakiye') {
						bakiye = parser.getDoubleValue();
					} else if (text == 'risklimit') {
						risklimit = parser.getIntegerValue();
					} else if (text == 'cekdurumu') {
						cekdurumu = parser.getText();
					} else {
						System.debug(LoggingLevel.WARN, 'LogoGetCariBakiyeJSONParser consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	public static List<LogoGetCariBakiyeJSONParser> parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return arrayOfLogoGetCariBakiyeJSONParser(parser);
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
	

    private static List<LogoGetCariBakiyeJSONParser> arrayOfLogoGetCariBakiyeJSONParser(System.JSONParser p) {
        List<LogoGetCariBakiyeJSONParser> res = new List<LogoGetCariBakiyeJSONParser>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new LogoGetCariBakiyeJSONParser(p));
        }
        return res;
    }
    
}