/**
*	Performs database operations for stock records
*
*	@author	Sahil Grover
*/
public with sharing class StockDataAccessor implements StockDAO {

	public static String STOCK_STATUS_RENTED = 'Rented';
	public static String STOCK_STATUS_AVAILABLE = 'Available';
	public static String STOCK_STATUS_MISSING = 'Missing';

	public List<Stock__c> queryStock(Id titleId) {
		return [
			SELECT Id, Name, Title__c, Status__c
			FROM Stock__c
			WHERE Title__c = :titleId
			];
	}

	public void saveStock(List<Stock__c> stock) {
		upsert stock;
	}

	public void deleteStock(List<Stock__c> stock) {
		delete stock;
	}
}