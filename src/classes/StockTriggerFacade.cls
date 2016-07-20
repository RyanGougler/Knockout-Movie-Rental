/**
*	Facade to handle stock trigger events
*
*	@author	Sahil Grover
*/
public with sharing class StockTriggerFacade {
	
	private RentalGenerator rentalGen;
	private RentalDAO rentalAccessor;

	public StockTriggerFacade(RentalGenerator rentalGen, RentalDAO rentalAccessor) {
		this.rentalGen = rentalGen;
		this.rentalAccessor = rentalAccessor;
	}

	public void saveRentalHistory(Map<Id, Stock__c> oldStockMap, List<Stock__c> updatedStock) {
		List<Stock__c> newlyRentedStock = getNewlyRentedStock(oldStockMap, updatedStock);
		List<Rental__c> rentals = this.rentalGen.createRentals(newlyRentedStock);
		this.rentalAccessor.saveRentals(rentals);
	}

	public void updateReturns(Map<Id, Stock__c> oldStockMap, List<Stock__c> updatedStock) {
		Set<Id> returnedStockIds = new Set<Id>();

		for (Stock__c stock : updatedStock) {
			Stock__c oldStock = oldStockMap.get(stock.Id);
			if ( hasBeenReturned(oldStock.Status__c, stock.Status__c) ) {
				returnedStockIds.add(stock.Id);
			}
		}

		List<Rental__c> mostRecentRentals = this.rentalAccessor.queryMostRecentRentals(returnedStockIds);

		this.rentalGen.setReturnDateTime(mostRecentRentals, DateTime.now());
		this.rentalAccessor.saveRentals(mostRecentRentals);
	}

	private List<Stock__c> getNewlyRentedStock(Map<Id, Stock__c> oldStockMap, List<Stock__c> updatedStock) {
		List<Stock__c> newlyRentedStock = new List<Stock__c>();
		for (Stock__c stock : updatedStock) {
			Stock__c oldStock = oldStockMap.get(stock.Id);
			if ( hasBeenRented(oldStock.Status__c, stock.Status__c) ) {
				newlyRentedStock.add(stock);
			}
		}
		return newlyRentedStock;
	}

	private Boolean hasBeenRented(String oldStatus, String newStatus) {
		return oldStatus != StockDataAccessor.STOCK_STATUS_RENTED 
			&& newStatus == StockDataAccessor.STOCK_STATUS_RENTED;
	}

	private Boolean hasBeenReturned(String oldStatus, String newStatus) {
		return oldStatus == StockDataAccessor.STOCK_STATUS_RENTED 
			&& newStatus == StockDataAccessor.STOCK_STATUS_AVAILABLE;
	}

	public static StockTriggerFacade createStockTriggerFacade() {
		return new StockTriggerFacade(
			new RentalHistoryGenerator(),
			new RentalDataAccessor()
			);
	}
}