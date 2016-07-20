/**
*	Unit tests for Stock__c trigger
*
*	@author	Sahil Grover 
*/
@isTest
private class StockTriggerTest {

	@isTest static void saveRentalHistory_givenEmptyList_shouldPassEmptyListToRentalGenerator() {
		RentalHistoryGeneratorMock rentalGenMock = new RentalHistoryGeneratorMock();
		StockTriggerFacade stockFacade = new StockTriggerFacade(rentalGenMock, new RentalDataAccessorMock());

		Test.startTest();
			stockFacade.saveRentalHistory(new Map<Id, Stock__c>(), new List<Stock__c>());
		Test.stopTest();

		System.assertEquals(
			0, 
			rentalGenMock.StockPassedToCreateRentals.size(), 
			'An empty list should have been passed to the rental generator'
			);
	}

	@isTest static void saveRentalHistory_givenMixedStockStatuses_shouldPassNewlyRentedToRentalGenerator() {
		RentalTestDataGenerator dataGen = new RentalTestDataGenerator();
		Title__c movie = dataGen.createTitle();
		insert movie;

		Stock__c rentedStock = dataGen.createStock(movie.Id, StockDataAccessor.STOCK_STATUS_RENTED);
		Stock__c availableStock = dataGen.createStock(movie.Id, StockDataAccessor.STOCK_STATUS_AVAILABLE);

		List<Stock__c> updatedStock = new List<Stock__c>{
			rentedStock, availableStock
		};

		insert updatedStock;

		Map<Id, Stock__c> oldStockMap = createOldStockMap(updatedStock, dataGen);
		oldStockMap.get(rentedStock.Id).Status__c = StockDataAccessor.STOCK_STATUS_AVAILABLE;
		oldStockMap.get(availableStock.Id).Status__c = StockDataAccessor.STOCK_STATUS_MISSING;
		
		RentalHistoryGeneratorMock rentalGenMock = new RentalHistoryGeneratorMock();
		StockTriggerFacade stockFacade = new StockTriggerFacade(rentalGenMock, new RentalDataAccessorMock());

		Test.startTest();
			stockFacade.saveRentalHistory(oldStockMap, updatedStock);
		Test.stopTest();

		System.assertEquals(
			1,
			rentalGenMock.StockPassedToCreateRentals.size(),
			'Only 1 record should have been passed to the rental generator'
			);

		System.assertEquals(
			rentedStock.Id,
			rentalGenMock.StockPassedToCreateRentals[0].Id,
			'The passed in stock record should have had its status changed to Rented'
			);
	}

	@isTest static void saveRentalHistory_givenRentedStock_shouldPassCreatedRentalRecordsToDataAccessor() {
		RentalTestDataGenerator dataGen = new RentalTestDataGenerator();
		Title__c movie = dataGen.createTitle();
		insert movie;
		
		Stock__c rentedStock = dataGen.createStock(movie.Id, StockDataAccessor.STOCK_STATUS_RENTED);
		insert rentedStock;

		Map<Id, Stock__c> oldStockMap = createOldStockMap(new List<Stock__c>{rentedStock}, dataGen);
		oldStockMap.get(rentedStock.Id).Status__c = StockDataAccessor.STOCK_STATUS_AVAILABLE;

		RentalDataAccessorMock rentalDataMock = new RentalDataAccessorMock();
		StockTriggerFacade stockFacade = new StockTriggerFacade(new RentalHistoryGenerator(), rentalDataMock);
		Test.startTest();
			stockFacade.saveRentalHistory(oldStockMap, new List<Stock__c>{rentedStock});
		Test.stopTest();

		System.assertEquals(
			1,
			rentalDataMock.RentalsPassedToSave.size(),
			'Only one rental should have been passed to the rental data accessor to save'
			);

		Rental__c createdRental = rentalDataMock.RentalsPassedToSave[0];
		confirmRentalMatchesStock(rentedStock, createdRental);
	}

	@isTest static void trigger_givenRentedStock_shouldCreateRentalRecord() {
		RentalTestDataGenerator dataGen = new RentalTestDataGenerator();
		Title__c movie = dataGen.createTitle();
		insert movie;
		
		Stock__c stockedMovie = dataGen.createStock(movie.Id, StockDataAccessor.STOCK_STATUS_AVAILABLE);
		insert stockedMovie;

		Test.startTest();
			stockedMovie.Status__c = StockDataAccessor.STOCK_STATUS_RENTED;
			update stockedMovie;
		Test.stopTest();

		List<Rental__c> rentals = new List<Rental__c>([
			SELECT Id, Stock__c, Customer__c
			FROM Rental__c
			WHERE Stock__c = :stockedMovie.Id
			]);

		System.assertEquals(
			1,
			rentals.size(),
			'Only one rental should have been created for the rented stock'
			);

		confirmRentalMatchesStock(stockedMovie, rentals[0]);
	}

	@isTest static void updateReturns_givenEmptyList_passesEmptyListToRentalGeneratorAndDAO() {
		RentalDataAccessorMock rentalDataMock = new RentalDataAccessorMock();
		rentalDataMock.RentalsToReturnFromQueryMostRecentRentals = new List<Rental__c>();
		RentalHistoryGeneratorMock rentalGenMock = new RentalHistoryGeneratorMock();
		StockTriggerFacade stockFacade = new StockTriggerFacade(rentalGenMock, rentalDataMock);
		Test.startTest();
			stockFacade.updateReturns(new Map<Id, Stock__c>(), new List<Stock__c>());
		Test.stopTest();

		System.assertEquals(
			0,
			rentalGenMock.RentalsPassedToSetReturnDateTime.size(),
			'Any empty list should have been passed to the rental generator'
			);

		System.assertEquals(
			0,
			rentalDataMock.RentalsPassedToSave.size(),
			'An empty list should have been passed to the rental DAO'
			);
	}

	@isTest static void updateReturns_givenReturnedStock_shouldPassRelatedRentalToRentalGeneratorAndDAO() {
		RentalTestDataGenerator dataGen = new RentalTestDataGenerator();
		Title__c movie = dataGen.createTitle();
		insert movie;
		
		Stock__c stockedMovie = dataGen.createStock(movie.Id, StockDataAccessor.STOCK_STATUS_AVAILABLE);
		insert stockedMovie;

		Rental__c rental = dataGen.createRental(stockedMovie.Id);
		insert rental;
		
		RentalDataAccessorMock rentalDataMock = new RentalDataAccessorMock();
		rentalDataMock.RentalsToReturnFromQueryMostRecentRentals = new List<Rental__c>{rental};
		
		Map<Id, Stock__c> oldStockMap = createOldStockMap(new List<Stock__c>{stockedMovie}, dataGen);
		oldStockMap.get(stockedMovie.Id).Status__c = StockDataAccessor.STOCK_STATUS_RENTED;

		RentalHistoryGeneratorMock rentalGenMock = new RentalHistoryGeneratorMock();
		StockTriggerFacade stockFacade = new StockTriggerFacade(rentalGenMock, rentalDataMock);
		Test.startTest();
			stockFacade.updateReturns(oldStockMap, new List<Stock__c>{stockedMovie});
		Test.stopTest();

		System.assertEquals(
			1,
			rentalGenMock.RentalsPassedToSetReturnDateTime.size(),
			'1 record should have been passed to the Rental Generator'
			);

		System.assertEquals(
			rental.Id,
			rentalGenMock.RentalsPassedToSetReturnDateTime[0].Id,
			'The correct rental was not passed to the rental generator'
			);

		System.assertEquals(
			1,
			rentalDataMock.RentalsPassedToSave.size(),
			'1 record should have been passed to the Rental DAO'
			);

		System.assertEquals(
			rental.Id,
			rentalDataMock.RentalsPassedToSave[0].Id,
			'The correct rental was not passed to the rental DAO'
			);
	}

	@isTest static void updateReturns_givenMixedStock_shouldPassOnlyReturnedStockToRentalDAO() {
		RentalTestDataGenerator dataGen = new RentalTestDataGenerator();
		Title__c movie = dataGen.createTitle();
		insert movie;

		Stock__c rentedStock = dataGen.createStock(movie.Id, StockDataAccessor.STOCK_STATUS_RENTED);
		Stock__c returnedStock = dataGen.createStock(movie.Id, StockDataAccessor.STOCK_STATUS_AVAILABLE);

		List<Stock__c> updatedStock = new List<Stock__c>{
			rentedStock, returnedStock
		};

		insert updatedStock;

		Map<Id, Stock__c> oldStockMap = createOldStockMap(updatedStock, dataGen);
		oldStockMap.get(rentedStock.Id).Status__c = StockDataAccessor.STOCK_STATUS_AVAILABLE;
		oldStockMap.get(returnedStock.Id).Status__c = StockDataAccessor.STOCK_STATUS_RENTED;
		
		RentalDataAccessorMock rentalDataMock = new RentalDataAccessorMock();
		RentalHistoryGeneratorMock rentalGenMock = new RentalHistoryGeneratorMock();
		StockTriggerFacade stockFacade = new StockTriggerFacade(rentalGenMock, rentalDataMock);
		Test.startTest();
			stockFacade.updateReturns(oldStockMap, updatedStock);
		Test.stopTest();

		System.assertEquals(
			1,
			rentalDataMock.StockIdsPassedToQueryMostRecentRentals.size(),
			'Only 1 stock record should be passed to the rental DAO'
			);

		System.assert(
			rentalDataMock.StockIdsPassedToQueryMostRecentRentals.contains(returnedStock.Id),
			'The correct ID was not passed to the rentalDAO'
			);
	}

	private static void confirmRentalMatchesStock(Stock__c stock, Rental__c rental) {
		System.assertEquals(
			stock.Id,
			rental.Stock__c,
			'The rental should point to the correct Stock'
			);

		System.assertEquals(
			stock.Customer__c,
			rental.Customer__c,
			'The rental should point to the correct Customer'
			);
	}

	private static Map<Id, Stock__c> createOldStockMap(List<Stock__c> newStock, RentalTestDataGenerator dataGen) {
		Map<Id, Stock__c> oldStockMap = new Map<Id, Stock__c>();
		for (Stock__c stock : newStock) {
			Stock__c oldStock = dataGen.createStock(stock.Title__c, stock.Status__c);
			oldStock.Id = stock.Id;
			oldStockMap.put(oldStock.Id, oldStock);
		}
		return oldStockMap;
	}

	private class RentalHistoryGeneratorMock implements RentalGenerator {
		
		public List<Stock__c> StockPassedToCreateRentals { get; private set; }
		public List<Rental__c> RentalsPassedToSetReturnDateTime { get; private set; }

		public List<Rental__c> createRentals(List<Stock__c> stockedItems) {
			this.StockPassedToCreateRentals = stockedItems;
			return null;
		}

		public void setReturnDatetime(List<Rental__c> rentals, DateTime returnDateTime) {
			this.RentalsPassedToSetReturnDateTime = rentals;
		}
	}

	private class RentalDataAccessorMock implements RentalDAO {

		public List<Rental__c> RentalsPassedToSave { get; private set; }
		public Set<Id> StockIdsPassedToQueryMostRecentRentals { get; private set; }
		public List<Rental__c> RentalsToReturnFromQueryMostRecentRentals { get; set; }

		public void saveRentals(List<Rental__c> rentals) {
			this.RentalsPassedToSave = rentals;
		}

		public List<Rental__c> queryMostRecentRentals(Set<Id> stockIds) {
			this.StockIdsPassedToQueryMostRecentRentals = stockIds;
			return this.RentalsToReturnFromQueryMostRecentRentals;
		}
	}
}