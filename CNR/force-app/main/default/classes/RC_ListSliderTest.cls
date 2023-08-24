@isTest
public class RC_ListSliderTest {

    static testMethod void unitTest(){
        List<String> testDataList = new List<String>();
        testDataList.add('Test 1');
        testDataList.add('Test 2');
        testDataList.add('Test 3');
        testDataList.add('Test 4');
        testDataList.add('Test 5');
        
        Test.startTest();
        
        RC_ListSlider slider = new RC_ListSlider(testDataList);
        
        List<Object> slidedList = slider.slice();
        
        slider.slice(0);
        slider.slice(0, 3);
        
        Test.stopTest();
    }
}