/**
*	Mock for stock data accessor
*
*	@author	Sahil Grover
*/
@isTest
public with sharing class StockDataAccessorMock implements StockDAO {
	
	public Id TitleIdPassedToQuery { get; private set; }
	public List<Stock__c> StockToReturnInQuery { get; set; }
	public List<Stock__c> StockPassedToSave { get; private set; }
	public List<Stock__c> StockPassedToDelete { get; private set; }

	public Integer QueryCallCount { get; private set; }
	public Integer SaveCallCount { get; private set; }
	public Integer DeleteCallCount { get; private set; }

	public StockDataAccessorMock() {
		this.QueryCallCount = 0;
		this.SaveCallCount = 0;
		this.DeleteCallCount = 0;
	}

	public List<Stock__c> queryStock(Id titleId) {
		this.QueryCallCount++;
		this.TitleIdPassedToQuery = titleId;
		return this.StockToReturnInQuery;
	}

	public void saveStock(List<Stock__c> stock) {
		this.SaveCallCount++;
		this.StockPassedToSave = stock;
	}

	public void deleteStock(List<Stock__c> stock) {
		this.DeleteCallCount++;
		this.StockPassedToDelete = stock;
	}
}