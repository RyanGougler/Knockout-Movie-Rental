/**
*	Performs database operations for rentals
*
*	@author	Sahil Grover
*/
public with sharing class RentalDataAccessor implements RentalDAO {
	
	public void saveRentals(List<Rental__c> rentals) {
		upsert rentals;
	}

	public List<Rental__c> queryMostRecentRentals(Set<Id> stockIds) {
		List<Stock__c> stockWithRentals = [
			SELECT Id, (
				SELECT Id, ReturnDateTime__c, Stock__c, Customer__c
				FROM Rentals__r
				ORDER BY CreatedDate DESC
				LIMIT 1
				)
			FROM Stock__c
			WHERE Id IN :stockIds
			];

		List<Rental__c> rentals = new List<Rental__c>();
		for (Stock__c stock : stockWithRentals) {
			rentals.addAll(stock.Rentals__r);
		}
		return rentals;
	}
}