/**
*	Unit tests for the TitleModel class
*
*	@author Sahil Grover
*/
@isTest
private class TitleModelTest {
	
	@isTest static void constructor_givenNoParameters_shouldGenerateEmptyProperties() {
		TitleModel title;
		Test.startTest();
			title = new TitleModel();
		Test.stopTest();

		System.assertEquals(null, title.TitleId, 'Title ID should be blank');
		System.assertEquals('', title.Name, 'Title Name should be blank');
		System.assertEquals('', title.Genre, 'Title Genre should be blank');
		System.assertEquals('', title.Description, 'Title Description should be blank');
		System.assertEquals(false, title.Featured, 'Title Featured field should be false');
	}

	@isTest static void constructor_givenTitleRecord_shouldCopyTitleFieldsToProperties() {
		Title__c titleRecord = createTitle();
		insert titleRecord;

		TitleModel title;
		Test.startTest();
			title = new TitleModel(titleRecord);
		Test.stopTest();
		
		System.assertEquals(titleRecord.Id, title.TitleId, 'Title Id is incorrect');
		System.assertEquals(titleRecord.Name, title.Name, 'Title Name is incorrect');
		System.assertEquals(titleRecord.Genre__c, title.Genre, 'Title Genre is incorrect');
		System.assertEquals(titleRecord.Description__c, title.Description, 'Title Description is incorrect');
		System.assertEquals(titleRecord.Featured__c, title.Featured, 'Title Featured is incorrect');
	}

	@isTest static void constructor_givenFieldsWithNullValue_shouldConvertToEmptyStringOrFalse() {
		Title__c titleRecord = new Title__c();

		TitleModel title;
		Test.startTest();
			title = new TitleModel(titleRecord);
		Test.stopTest();
		
		System.assertEquals('', title.Name, 'Title Name is incorrect');
		System.assertEquals('', title.Genre, 'Title Genre is incorrect');
		System.assertEquals('', title.Description, 'Title Description is incorrect');
		System.assertEquals(false, title.Featured, 'Title Featured is incorrect');
	}

	@isTest static void createRecord_givenNoParameters_shouldCreateRecordRepresentedByModel() {
		Title__c titleRecord = createTitle();
		insert titleRecord;

		Title__c createdRecord;
		TitleModel title = new TitleModel(titleRecord);
		Test.startTest();
			createdRecord = title.createRecord();
		Test.stopTest();
		
		System.assertEquals(title.TitleId, createdRecord.Id, 'Title Id is incorrect');
		System.assertEquals(title.Name, createdRecord.Name, 'Title Name is incorrect');
		System.assertEquals(title.Genre, createdRecord.Genre__c, 'Title Genre is incorrect');
		System.assertEquals(title.Description, createdRecord.Description__c, 'Title Description is incorrect');
		System.assertEquals(title.Featured, createdRecord.Featured__c, 'Title Featured is incorrect');
	}

	private static Title__c createTitle() {
		RentalTestDataGenerator dataGen = new RentalTestDataGenerator();
		Title__c titleRecord = dataGen.createTitle();
		titleRecord.Name = 'Test Name';
		titleRecord.Genre__c = 'Test Genre';
		titleRecord.Description__c = 'Test Desc';
		titleRecord.Featured__c = true;
		return titleRecord;
	}
}