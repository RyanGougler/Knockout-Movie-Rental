/**
*	Controller for TitleStock page
*
*	@author	Sahil Grover
*/
public with sharing class TitleStockController {

	public TitleStocker Stocker { get; private set; }
	public Integer StockIndexToRemove { get; set; }

	@TestVisible
	private StockDAO stockAccessor;
	private Id titleId;

	public TitleStockController(ApexPages.StandardController stdCon) {
		this.titleId = stdCon.getId();
		this.stockAccessor = new StockDataAccessor();
	}

	public void init() {
		List<Stock__c> currentStock = this.stockAccessor.queryStock(this.titleId);
		this.Stocker = new TitleStocker(this.stockAccessor, this.titleId, currentStock);
	}

	public void saveStock() {
		try {
			this.Stocker.save();
		} catch (DmlException ex) {
			ApexPages.addMessages(ex);
		}
		init();
	}

	public void removeStock() {
		this.Stocker.removeAvailableStock(this.StockIndexToRemove);
	}
}