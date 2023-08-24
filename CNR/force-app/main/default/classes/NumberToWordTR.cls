public class NumberToWordTR { 
    public static String[] to_19 = new string[]{ 'Sıfır', 'Bir',  'İki', 'Üç', 'Dört',  'Beş',  'Altı',  
        'Yedi', 'Sekiz', 'Dokuz'};//, 'On', 'On Bir', 'On İki', 'On Üç', 'On Dört', 'On Beş', 'On Altı', 'On Yedi', 'On Sekiz', 'On Dokuz' };  
           public     static String[] tens = new string[]{ 'On','Yirmi', 'Otuz', 'Kırk', 'Elli', 'Altmış', 'Yetmiş', 'Seksen', 'Doksan'};  
             public   static String[] denom = new string[]{ '', 'Yüz',
                    'Bin',   'Milyon',     'Milyar',    'Trilyon',    'Katrilyon',  
                    'Kentilyon', 'Sekstilyon',   'Septilyon',  'Oktilyon' };  
                        // convert a value < 100 to English.    
                        public static String convert_nn(integer val) {  
                            if (val < 10)  
                                return to_19[val];  
                            if(val == 100)  
                                return 'Yüz';  
                            for (integer v = 0; v < tens.size(); v++) {  
                                String dcap = tens[v]; //90 
                                integer dval = 10 + 10 * v;  //
                                if (dval + 10 > val) {  
                                    if (Math.Mod(val,10) != 0)  
                                        return dcap + '' + to_19[Math.Mod(val,10)];  
                                    return dcap;  
                                }      
                            }  
                            return 'Yanlış girildi';  
                        }  
    // convert a value < 1000 to english, special cased because it is the level that kicks   
    // off the < 100 special case. The rest are more general. This also allows you to  
    // get strings in the form of "forty-five hundred" if called directly.  
    
    public static String convert_nnn(integer val) {  
        String word = '';  
        integer rem = val / 100;  
        integer mod = Math.mod(val,100);  
        if (rem > 0) {  
            word = to_19[rem] + 'Yüz';
            
            if(rem == 1){
                word = 'Yüz';
            }  
            
            if (mod > 0) {  
                word += '';  
            }  
        }  
        if (mod > 0) {  
            word += convert_nn(mod);  
        }  
        return word;  
    }  
    public static String english_number(long val) {  
        system.debug('val: ' +val);
        if (val < 100) {  
            return convert_nn(val.intValue());  
        }  
        if (val < 1000) {  
            return convert_nnn(val.intValue());  
        }  
        //101001
        for (integer v = 0; v < denom.size(); v++) {  //2
            integer didx = v - 1;  //1
            integer dval = (integer)Math.pow(1000, v); //1000 000
            
            if (dval > val) {  
                integer mod = (integer)Math.pow(1000, didx); //1000 
                integer l = (integer) val / mod;  //101
                integer r = (integer) val - (l * mod); //1 
                String ret = convert_nnn(l) + '' + denom[v];  
                
                if(convert_nnn(l) == 'Bir' && v == 2){
                    ret = 'Bin';
                }
                
                if (r > 0) {  
                    ret += '' + english_number(r);  
                }  
                return ret;  
            }
        }
        return 'Should never get here, bottomed out in english_number';  
    }  
}