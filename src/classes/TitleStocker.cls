/**
*	Manages stock for titles
*
*	@author	Sahil Grover
*/
public with sharing class TitleStocker {
	
	public List<Stock__c> AvailableStock { get; private set; }
	public List<Stock__c> RentedStock { get; private set; }
	public List<Stock__c> MissingStock { get; private set; }
	public List<Stock__c> StockToDelete { get; private set; }

	private Id titleId;
	private StockDAO stockAccessor;

	public TitleStocker(StockDAO stockAccessor, Id titleId, List<Stock__c> currentStock) {
		this.stockAccessor = stockAccessor;
		this.titleId = titleId;
		this.AvailableStock = filterFromList(currentStock, StockDataAccessor.STOCK_STATUS_AVAILABLE);
		this.RentedStock = filterFromList(currentStock, StockDataAccessor.STOCK_STATUS_RENTED);
		this.MissingStock = filterFromList(currentStock, StockDataAccessor.STOCK_STATUS_MISSING);
		this.StockToDelete = new List<Stock__c>();
	}

	private List<Stock__c> filterFromList(List<Stock__c> source, String status) {
		List<Stock__c> destination = new List<Stock__c>();
		for (Stock__c stock : source) {
			if (stock.Status__c == status) {
				destination.add(stock);
			}
		}
		return destination;
	}

	public void addStock() {
		Stock__c newStock = new Stock__c(
			Status__c = StockDataAccessor.STOCK_STATUS_AVAILABLE,
			Title__c = this.titleId
		);
		this.AvailableStock.add(newStock);
	}

	public void removeAvailableStock(Integer index) {
		Stock__c removedStock = this.AvailableStock.remove(index);
		if (removedStock.Id != null) {
			this.StockToDelete.add(removedStock);
		}
	}

	public void save() {
		stockAccessor.deleteStock(this.StockToDelete);
		stockAccessor.saveStock(this.AvailableStock);
	}
}