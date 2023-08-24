@isTest
public class NumberToWordTRTest {
    @isTest
    public static void unitTest(){
         NumberToWordTR.to_19 = new string[]{ 'Sıfır', 'Bir',  'İki', 'Üç', 'Dört',  'Beş',  'Altı',  
        'Yedi', 'Sekiz', 'Dokuz'};//, 'On', 'On Bir', 'On İki', 'On Üç', 'On Dört', 'On Beş', 'On Altı', 'On Yedi', 'On Sekiz', 'On Dokuz' };  
            NumberToWordTR.tens = new string[]{ 'On','Yirmi', 'Otuz', 'Kırk', 'Elli', 'Altmış', 'Yetmiş', 'Seksen', 'Doksan'};  
               NumberToWordTR.denom = new string[]{ '', 'Yüz',
                    'Bin',   'Milyon',     'Milyar',    'Trilyon',    'Katrilyon',  
                    'Kentilyon', 'Sekstilyon',   'Septilyon',  'Oktilyon' };  
        
        NumberToWordTR.english_number(101001);
        NumberToWordTR.english_number(100);
    }
}