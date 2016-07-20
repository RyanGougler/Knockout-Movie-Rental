/**
*	Interface for classes that create Rental__c records
*
*	@author	Sahil Grover
*/
public interface RentalGenerator {

	List<Rental__c> createRentals(List<Stock__c> stockedItems);

	void setReturnDateTime(List<Rental__c> rentals, DateTime returnDateTime);
}