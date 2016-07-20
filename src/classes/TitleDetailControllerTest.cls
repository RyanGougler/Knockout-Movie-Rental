/**
*	Unit tests for TitleDetailController
*
*	@author	Sahil Grover
*/
@isTest
private class TitleDetailControllerTest {
	
	@isTest static void constructor_givenStandardControllerWithUnsavedRecord_shouldSetIdPropertyToNull() {
		TitleDetailController titleController;
		Test.startTest();
			titleController = createTitleController(new Title__c());
		Test.stopTest();

		System.assertEquals(null, titleController.TitleId, 'Title Id should be null for new Title');
	}

	@isTest static void constructor_givenStandardControllerWithSavedRecord_shouldSetIdPropertyToRecordId() {
		RentalTestDataGenerator dataGen = new RentalTestDataGenerator();
		Title__c title = dataGen.createTitle();
		insert title;
		
		TitleDetailController titleController;
		Test.startTest();
			titleController = createTitleController(title);
		Test.stopTest();

		System.assertEquals(title.Id, titleController.TitleId, 'Title Id should be set to saved Title\'s Id');
	}

	@isTest static void getTitle_givenNullId_shouldReturnNewTitle() {
		TitleModel title;
		Test.startTest();
			title = TitleDetailController.getTitle(null);
		Test.stopTest();

		System.assertEquals(null, title.TitleId, 'New title should have been returned if no ID was specified');
		System.assertEquals('', title.Name, 'The name should be blank');
		System.assertEquals('', title.Description, 'The description should be blank');
		System.assertEquals('', title.Genre, 'The genre should be blank');
		System.assertEquals(false, title.Featured, 'The featured field should be false');
	}

	@isTest static void getTitle_givenValidId_shouldReturnCorrectRecord() {
		RentalTestDataGenerator dataGen = new RentalTestDataGenerator();
		Title__c expectedTitle = dataGen.createTitle();
		insert expectedTitle;

		TitleDataAccessorMock titleAccessor = new TitleDataAccessorMock();
		titleAccessor.TitleToReturn = expectedTitle;

		TitleDetailController.titleAccessor = titleAccessor;
		TitleModel returnedTitle;
		Test.startTest();
			returnedTitle = TitleDetailController.getTitle(expectedTitle.Id);
		Test.stopTest();

		System.assertEquals(expectedTitle.Id, returnedTitle.TitleId, 'The wrong title was returned');
	}

	@isTest static void saveTitle_givenAnyTitle_shouldCallSaveTitleMethodOfDataAccessor() {
		RentalTestDataGenerator dataGen = new RentalTestDataGenerator();
		Title__c expectedTitle = dataGen.createTitle();
		insert expectedTitle;

		TitleDataAccessorMock titleAccessor = new TitleDataAccessorMock();
		TitleDetailController.titleAccessor = titleAccessor;
		Test.startTest();
			TitleDetailController.saveTitle(new TitleModel(expectedTitle));
		Test.stopTest();

		System.assertEquals(expectedTitle.Id, titleAccessor.SavedTitle.Id, 'The correct title was not passed to the data accessor');
	}

	@isTest static void init_givenNoArguments_shouldSetGenreOptions() {
		TitleDetailController titleController = createTitleController(new Title__c());
		Test.startTest();
			titleController.init();
		Test.stopTest();

		System.assertNotEquals(null, titleController.GenreOptions, 'GenreOptions should not be null');
		System.assert(!titleController.GenreOptions.isEmpty(), 'GenreOptions should not be empty');
	}

	private static TitleDetailController createTitleController(Title__c title) {
		ApexPages.StandardController stdCon = new ApexPages.StandardController(title);
		return new TitleDetailController(stdCon);
	}
}