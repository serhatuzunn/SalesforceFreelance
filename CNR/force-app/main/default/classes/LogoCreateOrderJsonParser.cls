public class LogoCreateOrderJsonParser {

	public class Error {
		public String aciklama {get;set;} 

		public Error(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'aciklama') {
							aciklama = parser.getText();
						} else {
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public String status {get;set;} 
	public Error error {get;set;} 
	public String fisNo {get;set;} 

	public LogoCreateOrderJsonParser(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'status') {
						status = parser.getText();
					} else if (text == 'error') {
						error = new Error(parser);
					} else if (text == 'fisNo') {
						fisNo = parser.getText();
					} else {
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	
	public static LogoCreateOrderJsonParser parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new LogoCreateOrderJsonParser(parser);
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
	



}