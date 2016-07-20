/**
*	Interface representing a stock data access object
*
*	@author	Sahil Grover
*/
public interface StockDAO {

	List<Stock__c> queryStock(Id titleId);

	void saveStock(List<Stock__c> stock);

	void deleteStock(List<Stock__c> stock);
}