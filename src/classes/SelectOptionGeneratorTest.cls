/**
*	Unit tests for select option generator
*
*	@author	Sahil Grover
*/
@isTest
private class SelectOptionGeneratorTest {

	// we can't really test specific values, as they are stored as config data -- would be cumbersome to maintain this test
	@isTest static void generateOptions_givenFieldDescribe_shouldReturnNonEmptySelectOptionList() {
		SelectOptionGenerator selOptGen = new SelectOptionGenerator();
		List<SelectOption> genreOptions;
		Test.startTest();
			genreOptions = selOptGen.generateOptions(Title__c.Genre__c);
		Test.stopTest();

		System.assert(!genreOptions.isEmpty(), 'The returned select options should not be empty');
	}
}