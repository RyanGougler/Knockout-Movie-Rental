/**
*	Unit tests for TitleStocker
*
*	@author	Sahil Grover
*/
@isTest
private class TitleStockerTest {

	@isTest static void constructor_givenEmptyList_shouldCreateEmptyListsForAllStock() {
		RentalTestDataGenerator dataGen = new RentalTestDataGenerator();

		Title__c title = dataGen.createTitle();
		insert title;

		TitleStocker stocker;
		Test.startTest();
			stocker = createTitleStockerWithNoStock(title.Id);
		Test.stopTest();

		System.assertEquals(0, stocker.AvailableStock.size(), 'Available stock should be an empty list');
		System.assertEquals(0, stocker.RentedStock.size(), 'Rented stock should be an empty list');
		System.assertEquals(0, stocker.MissingStock.size(), 'Missing stock should be an empty list');
	}

	@isTest static void constructor_givenMixedStock_shouldFilterStockIntoCorrectLists() {
		RentalTestDataGenerator dataGen = new RentalTestDataGenerator();
		List<Stock__c> stockList = dataGen.createMixedStock();

		TitleStocker stocker;
		Test.startTest();
			stocker = createTitleStocker(null, stockList);
		Test.stopTest();

		assertStockStatusInList(stocker.RentedStock, StockDataAccessor.STOCK_STATUS_RENTED);
		assertStockStatusInList(stocker.MissingStock, StockDataAccessor.STOCK_STATUS_MISSING);
		assertStockStatusInList(stocker.AvailableStock, StockDataAccessor.STOCK_STATUS_AVAILABLE);
	}

	@isTest static void addStock_givenNoParameters_shouldAddStockRecordToAvailableList() {
		RentalTestDataGenerator dataGen = new RentalTestDataGenerator();

		Title__c title = dataGen.createTitle();
		insert title;

		TitleStocker stocker = createTitleStockerWithNoStock(title.Id);
		Test.startTest();
			stocker.addStock();
		Test.stopTest();

		System.assertEquals(
			1,
			stocker.AvailableStock.size(),
			'1 record should have been added to the available stock'
			);
		System.assertEquals(
			StockDataAccessor.STOCK_STATUS_AVAILABLE,
			stocker.AvailableStock[0].Status__c,
			'The added stock should be available'
			);
		System.assertEquals(
			title.Id,
			stocker.AvailableStock[0].Title__c,
			'The new stock should belong to the correct title'
			);
	}

	@isTest static void removeAvailableStock_givenListIndexForSavedStockWithId_shouldMoveStockToForDeleteList() {
		RentalTestDataGenerator dataGen = new RentalTestDataGenerator();

		Title__c title = dataGen.createTitle();
		insert title;

		Stock__c stockedTitle = dataGen.createStock(title.Id, StockDataAccessor.STOCK_STATUS_AVAILABLE);
		insert stockedTitle;

		TitleStocker stocker = createTitleStocker(title.Id, new List<Stock__c>{stockedTitle});
		Test.startTest();
			stocker.removeAvailableStock(0);
		Test.stopTest();

		System.assertEquals(0, stocker.AvailableStock.size(), 'There should not be any available stock');
		System.assertEquals(1, stocker.StockToDelete.size(), 'There should be 1 item in the delete list');
		System.assertEquals(stockedTitle.Id, stocker.StockToDelete[0].Id, 'The correct stock was not added to the delete list');
	}

	@isTest static void removeAvailableStock_givenListIndexForUnsavedStockWithoutId_shouldRemoveStockFromList() {
		RentalTestDataGenerator dataGen = new RentalTestDataGenerator();

		Stock__c stockedTitle = dataGen.createStock(null, StockDataAccessor.STOCK_STATUS_AVAILABLE);
		TitleStocker stocker = createTitleStocker(null, new List<Stock__c>{stockedTitle});
		Test.startTest();
			stocker.removeAvailableStock(0);
		Test.stopTest();
		
		System.assertEquals(0, stocker.AvailableStock.size(), 'There should not be any available stock');
		System.assertEquals(0, stocker.StockToDelete.size(), 'The delete list should be empty');
	}

	@isTest static void save_withItemsInToDeleteList_shouldPassListToDataAccessor() {
		RentalTestDataGenerator dataGen = new RentalTestDataGenerator();

		Title__c title = dataGen.createTitle();
		insert title;

		Stock__c stockedTitle = dataGen.createStock(title.Id, StockDataAccessor.STOCK_STATUS_AVAILABLE);
		insert stockedTitle;

		StockDataAccessorMock stockData = new StockDataAccessorMock();
		TitleStocker stocker = new TitleStocker(stockData, title.Id, new List<Stock__c>{stockedTitle});
		stocker.removeAvailableStock(0);
		Test.startTest();
			stocker.save();
		Test.stopTest();

		System.assertEquals(
			1,
			stockData.StockPassedToDelete.size(),
			'1 record should have been passed to the data accessor'
			);
		System.assertEquals(
			stockedTitle.Id,
			stockData.StockPassedToDelete[0].Id,
			'The correct stock record was not passed to the data accessor'
			);
	}

	@isTest static void save_withItemsInAvailableList_shouldPassListToDataAccessor() {
		RentalTestDataGenerator dataGen = new RentalTestDataGenerator();

		Title__c title = dataGen.createTitle();
		insert title;
		
		StockDataAccessorMock stockData = new StockDataAccessorMock();
		TitleStocker stocker = new TitleStocker(stockData, title.Id, new List<Stock__c>());
		stocker.addStock();
		Test.startTest();
			stocker.save();
		Test.stopTest();

		System.assertEquals(
			1,
			stockData.StockPassedToSave.size(),
			'1 stock record should have been passed to the data accessor'
			);

		System.assertEquals(
			StockDataAccessor.STOCK_STATUS_AVAILABLE,
			stockData.StockPassedToSave[0].Status__c,
			'Available stock should have been passed to the data accessor'
			);
	}

	private static TitleStocker createTitleStockerWithNoStock(Id titleId) {
		return createTitleStocker(titleId, new List<Stock__c>());
	}

	private static TitleStocker createTitleStocker(Id titleId, List<Stock__c> currentStock) {
		return new TitleStocker(new StockDataAccessorMock(), titleId, currentStock);
	}

	private static void assertStockStatusInList(List<Stock__c> stockList, String status) {
		System.assert(stockList.size() > 0, 'There should be records in the stock list');
		for (Stock__c stock : stockList) {
			System.assertEquals(
				status, 
				stock.Status__c, 
				'An stock record with an incorrect status was added to the list');
		}
	}

}