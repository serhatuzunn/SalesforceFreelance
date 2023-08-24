public class RC_ExcelImportJsonParser {

	public String firmaadi {get;set;} 
	public string firmamail {get;set;} 
    public string firmatelefon {get;set;}
	public String firmaparabirimi {get;set;} 
	public String firmavergikimliknumarasi {get;set;} 
    
    public String adres {get;set;} 
    public String ilce {get;set;} 
    public String il {get;set;} 
    public String ulke {get;set;} 
    public String web {get;set;} 
    public String sektor {get;set;} 
    
    
	public String kisiad {get;set;} 
    public String kisiunvan {get;set;} 
    public String kisisoyad {get;set;} 
	public String kisitelefon {get;set;} 
    public String kisimail {get;set;} 
    public String errorMess {get;set;} 

    
	public RC_ExcelImportJsonParser(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'firmaadi') {
						firmaadi = parser.getText();
					} else if (text == 'firmamail') {
						firmamail = parser.getText();
					} else if (text == 'firmatelefon') {
						firmatelefon = parser.getText();
					} else if (text == 'firmaparabirimi') {
						firmaparabirimi = parser.getText();
					} else if (text == 'firmavergikimliknumarasi') {
						firmavergikimliknumarasi = parser.getText();
					} else if (text == 'kisiad') {
						kisiad = parser.getText();
					} else if (text == 'kisiunvan') {
						kisiunvan = parser.getText();
					} else if (text == 'kisisoyad') {
						kisisoyad = parser.getText();
					} else if (text == 'kisitelefon') {
						kisitelefon = parser.getText();
					} else if (text == 'kisimail') {
						kisimail = parser.getText();
					} else if (text == 'adres') {
						adres = parser.getText();
					}else if (text == 'ilce') {
						ilce = parser.getText();
					}else if (text == 'il') {
						il = parser.getText();
					}else if (text == 'ulke') {
						ulke = parser.getText();
					}else if (text == 'web') {
						web = parser.getText();
					}else if (text == 'sektor') {
						sektor = parser.getText();
					}
                    else {

						consumeObject(parser);
                        errorMess=text;
					}
				}
			}
		}
	}
	
	
	public static List<RC_ExcelImportJsonParser> parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return arrayOfRC_ExcelImportJsonParser(parser);
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
	



    private static List<RC_ExcelImportJsonParser> arrayOfRC_ExcelImportJsonParser(System.JSONParser p) {
        List<RC_ExcelImportJsonParser> res = new List<RC_ExcelImportJsonParser>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new RC_ExcelImportJsonParser(p));
        }
        return res;
    }


}