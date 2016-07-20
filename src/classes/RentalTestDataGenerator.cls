/**
*	Generates mock data for unit tests
*
*	@author	Sahil Grover
*/
@isTest
public class RentalTestDataGenerator {

	public Title__c createTitle() {
		return new Title__c();
	}
	
	public Stock__c createStock(Id titleId, String status) {
		Stock__c stock = new Stock__c(
			Title__c = titleId,
			Status__c = status
		);

		if (stock.Status__c == StockDataAccessor.STOCK_STATUS_RENTED) {
			stock.Customer__c = UserInfo.getUserId();
		}

		return stock;
	}

	public Rental__c createRental(Id stockId) {
		return new Rental__c(
			Stock__c = stockId
		);
	}

	public List<Stock__c> createMixedStock() {
		Stock__c available = this.createStock(null, StockDataAccessor.STOCK_STATUS_AVAILABLE);
		Stock__c rented = this.createStock(null, StockDataAccessor.STOCK_STATUS_RENTED);
		Stock__c missing = this.createStock(null, StockDataAccessor.STOCK_STATUS_MISSING);

		return new List<Stock__c>{
			available, rented, missing
		};
	}
}