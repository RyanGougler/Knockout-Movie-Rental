/**
*	Integration tests for title search controller
*
*	@author	Sahil Grover
*/
@isTest
private class TitleSearchControllerTest {

	@isTest static void queryTitlesByName_withNoMatchingRecords_shouldReturnNoResults() {
		List<TitleModel> results;
		Test.startTest();
			results = TitleSearchController.queryTitlesByName('Wars');
		Test.stopTest();

		System.assertEquals(0, results.size(), 'No titles should have been returned');
	}

	@isTest static void queryTitlesByName_givenValidSearchTerm_shouldReturnResultsFromDAO() {
		RentalTestDataGenerator dataGen = new RentalTestDataGenerator();
		Title__c searchedTitle = dataGen.createTitle();
		searchedTitle.Name = 'Star Wars: The Force Awakens';
		insert searchedTitle;

		TitleDataAccessorMock titleDataMock = new TitleDataAccessorMock();
		titleDataMock.QueriedTitlesToReturn = new List<Title__c>{searchedTitle};
		TitleSearchController.titleAccessor = titleDataMock;
		List<TitleModel> results;
		Test.startTest();
			results = TitleSearchController.queryTitlesByName('Wars');
		Test.stopTest();

		System.assertEquals(1, results.size(), 'One title should have been returned');
		System.assertEquals(searchedTitle.Id, results[0].TitleId, 'The returned result should match the search term');
	}

	@isTest static void queryFeaturedTitles_withNoFeaturedTitles_shouldReturnEmptyResultList() {
		List<TitleModel> results;
		Test.startTest();
			results = TitleSearchController.queryFeaturedTitles();
		Test.stopTest();

		System.assertEquals(0, results.size(), 'No titles should have been returned');
	}

	@isTest static void queryFeaturedTitles_givenNoParameters_shouldReturnFeaturedTitles() {
		RentalTestDataGenerator dataGen = new RentalTestDataGenerator();
		Title__c featuredTitle = dataGen.createTitle();
		featuredTitle.Featured__c = true;

		TitleDataAccessorMock titleDataMock = new TitleDataAccessorMock();
		titleDataMock.FeaturedTitlesToReturn = new List<Title__c>{featuredTitle};
		TitleSearchController.titleAccessor = titleDataMock;
		List<TitleModel> results;
		Test.startTest();
			results = TitleSearchController.queryFeaturedTitles();
		Test.stopTest();

		System.assertEquals(1, results.size(), 'One title should have been returned');
		System.assert(results[0].Featured, 'The returned result should be featured');
	}

	@isTest static void queryTitlesByNameAndGenre_givenNullSearchTerm_shouldReturnEmptyList() {
		TitleDataAccessorMock titleDataMock = new TitleDataAccessorMock();
		titleDataMock.GenreTitlesToReturn = new List<Title__c>();
		TitleSearchController.titleAccessor = titleDataMock;

		List<TitleModel> results;
		Test.startTest();
			results = TitleSearchController.queryTitlesByNameAndGenre(null, null);
		Test.stopTest();

		System.assert(results.isEmpty(), 'Results from search should be empty list');
	}

	@isTest static void queryTitlesByNameAndGenre_givenValidSearchTerms_shouldReturnMatchingResults() {
		RentalTestDataGenerator dataGen = new RentalTestDataGenerator();
		Title__c searchedTitle = dataGen.createTitle();
		searchedTitle.Name = 'Star Wars: The Force Awakens';
		searchedTitle.Genre__c = 'Action';
		insert searchedTitle;

		TitleDataAccessorMock titleDataMock = new TitleDataAccessorMock();
		titleDataMock.GenreTitlesToReturn = new List<Title__c>{searchedTitle};
		TitleSearchController.titleAccessor = titleDataMock;
		List<TitleModel> results;
		Test.startTest();
			results = TitleSearchController.queryTitlesByNameAndGenre('Wars', 'Action');
		Test.stopTest();

		System.assertEquals(1, results.size(), 'One result should have been returned');
		System.assertEquals(searchedTitle.Id, results[0].TitleId, 'The returned result should match the search term and genre');
	}

	@isTest static void init_givenNoArguments_shouldSetGenreOptions() {
		TitleSearchController titleSearchCon = new TitleSearchController();
		Test.startTest();
			titleSearchCon.init();
		Test.stopTest();

		System.assertNotEquals(null, titleSearchCon.GenreOptions, 'GenreOptions should not be null');
		System.assert(!titleSearchCon.GenreOptions.isEmpty(), 'GenreOptions should not be empty');
	}

}