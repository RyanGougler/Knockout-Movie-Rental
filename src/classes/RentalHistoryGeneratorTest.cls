/**
*	Unit tests for RentalHistoryGenerator
*
*	@author	Sahil Grover
*/
@isTest
private class RentalHistoryGeneratorTest {

	@isTest static void createRentals_givenEmptyStockList_shouldReturnEmptyList() {
		RentalHistoryGenerator rentalGen = new RentalHistoryGenerator();
		List<Rental__c> rentals;

		Test.startTest();
			rentals = rentalGen.createRentals(new List<Stock__c>());
		Test.stopTest();

		System.assertEquals(0, rentals.size(), 'No rentals should have been generated');
	}

	@isTest static void createRentals_givenStockRecord_shouldGenerateRental() {
		RentalTestDataGenerator dataGen = new RentalTestDataGenerator();

		Title__c movie = dataGen.createTitle();
		insert movie;

		Stock__c stock = dataGen.createStock(movie.Id, StockDataAccessor.STOCK_STATUS_AVAILABLE);
		insert stock;

		RentalHistoryGenerator rentalGen = new RentalHistoryGenerator();
		List<Rental__c> rentals;
		Test.startTest();
			rentals = rentalGen.createRentals(new List<Stock__c>{stock});
		Test.stopTest();

		System.assertEquals(1, rentals.size(), 'One rental record should have been generated');
		System.assertEquals(stock.Id, rentals[0].Stock__c, 'The rental record should point to the stock record');
		System.assertEquals(stock.Customer__c, rentals[0].Customer__c, 'The rental record should point to the correct customer');
	}

	@isTest static void setReturnDateTime_givenRentalList_shouldSetReturnDateTime() {
		Rental__c rental = new Rental__c();

		DateTime returnDateTime = DateTime.newInstance(2015, 12, 20);
		RentalHistoryGenerator rentalGen = new RentalHistoryGenerator();
		Test.startTest();
			rentalGen.setReturnDateTime(new List<Rental__c>{rental}, returnDateTime);
		Test.stopTest();

		System.assertEquals(returnDateTime, rental.ReturnDateTime__c, 'The return date for the rental is incorrect');
	}
}