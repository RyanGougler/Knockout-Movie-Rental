/**
*	Generate and update rental records
*
*	@author	Sahil Grover
*/
public with sharing class RentalHistoryGenerator implements RentalGenerator {
	
	public List<Rental__c> createRentals(List<Stock__c> stockedItems) {
		List<Rental__c> rentals = new List<Rental__c>();
		for (Stock__c stock : stockedItems) {
			Rental__c rental = new Rental__c(
				Stock__c = stock.Id,
				Customer__c = stock.Customer__c
			);

			rentals.add(rental);
		}
		return rentals;
	}

	public void setReturnDateTime(List<Rental__c> rentals, DateTime returnDateTime) {
		for (Rental__c rental : rentals) {
			rental.ReturnDateTime__c = returnDateTime;
		}
	}
}