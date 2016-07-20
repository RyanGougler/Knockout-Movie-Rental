/**
*	Integration tests for TitleStockController
*
*	@author	Sahil Grover
*/
@isTest
private class TitleStockControllerTest {
	
	@isTest static void init_givenNoParameters_shouldQueryForExistingStock() {
		RentalTestDataGenerator dataGen = new RentalTestDataGenerator();
		Title__c title = dataGen.createTitle();
		insert title;
		
		List<Stock__c> mixedStock = dataGen.createMixedStock();
		StockDataAccessorMock stockData = new StockDataAccessorMock();
		stockData.StockToReturnInQuery = mixedStock;
		TitleStockController stockController = createTitleStockController(stockData, title);

		Test.startTest();
			stockController.init();
		Test.stopTest();

		System.assertEquals(
			title.Id,
			stockData.TitleIdPassedToQuery,
			'An incorrect title ID was passed to the data accessor'
			);
	}

	@isTest static void init_givenNoParameters_shouldSetStockInTitleStocker() {
		RentalTestDataGenerator dataGen = new RentalTestDataGenerator();
		Title__c title = dataGen.createTitle();
		insert title;
		
		List<Stock__c> mixedStock = dataGen.createMixedStock();
		StockDataAccessorMock stockData = new StockDataAccessorMock();
		stockData.StockToReturnInQuery = mixedStock;
		TitleStockController stockController = createTitleStockController(stockData, title);

		Test.startTest();
			stockController.init();
		Test.stopTest();

		System.assertEquals(
			1,
			stockController.Stocker.AvailableStock.size(),
			'There should be 1 available stock record'
			);
		System.assertEquals(
			1,
			stockController.Stocker.RentedStock.size(),
			'There should be 1 rented stock record'
			);
		System.assertEquals(
			1,
			stockController.Stocker.MissingStock.size(),
			'There should be 1 missing stock record'
			);
	}

	@isTest static void saveStock_givenNoParameters_shouldAddVfPageMessageOnError() {
		RentalTestDataGenerator dataGen = new RentalTestDataGenerator();
		Title__c title = dataGen.createTitle();
		insert title;
		
		StockDataErrorMock stockData = new StockDataErrorMock();
		TitleStockController stockController = createTitleStockController(stockData, title);
		stockController.init();

		Test.startTest();
			stockController.saveStock();
		Test.stopTest();

		System.assertEquals(
			1,
			ApexPages.getMessages().size(),
			'A VF page message should have been added'
			);
	}
	
	@isTest static void saveStock_givenNoParameters_shouldCallSaveAndRequeryOnSuccess() {
		RentalTestDataGenerator dataGen = new RentalTestDataGenerator();
		Title__c title = dataGen.createTitle();
		insert title;
		
		StockDataAccessorMock stockData = new StockDataAccessorMock();
		stockData.StockToReturnInQuery = new List<Stock__c>();
		TitleStockController stockController = createTitleStockController(stockData, title);
		stockController.init();
		stockController.Stocker.addStock();
		Integer numberOfTimesQueryCalledBefore = stockData.QueryCallCount;
		Integer numberOfTimesSaveCalledBefore = stockData.SaveCallCount;

		Test.startTest();
			stockController.saveStock();
		Test.stopTest();

		System.assertEquals(
			numberOfTimesSaveCalledBefore + 1,
			stockData.SaveCallCount,
			'Save should have been called'
			);

		System.assertEquals(
			numberOfTimesQueryCalledBefore + 1,
			stockData.QueryCallCount,
			'Query should have been called'
			);
	}

	@isTest static void removeStock_withRemoveIndexSet_shouldRemoveStockFromAvailableListAtIndex() {
		RentalTestDataGenerator dataGen = new RentalTestDataGenerator();
		Title__c title = dataGen.createTitle();
		insert title;
		
		StockDataAccessorMock stockData = new StockDataAccessorMock();
		stockData.StockToReturnInQuery = new List<Stock__c>();
		TitleStockController stockController = createTitleStockController(stockData, title);
		stockController.init();
		stockController.Stocker.addStock();

		Test.startTest();
			stockController.StockIndexToRemove = 0;
			stockController.removeStock();
		Test.stopTest();

		System.assertEquals(
			0,
			stockController.Stocker.AvailableStock.size(),
			'There should not be any stock in the list after removal'
			);
	}

	private static TitleStockController createTitleStockController(StockDAO stockData, Title__c title) {
		ApexPages.StandardController stdCon = new ApexPages.StandardController(title);
		TitleStockController stockController = new TitleStockController(stdCon);
		stockController.stockAccessor = stockData;

		return stockController;
	}

	private class StockDataErrorMock implements StockDAO {

		public List<Stock__c> queryStock(Id titleId) {
			return new List<Stock__c>();
		}

		public void saveStock(List<Stock__c> stock) {
			throw new DmlException('');
		}

		public void deleteStock(List<Stock__c> stock) {
			throw new DmlException('');
		}
	}

}