/**
*	Interface for Rental Data Access Objects
*
*	@author	Sahil Grover
*/
public interface RentalDAO {

	void saveRentals(List<Rental__c> rentals);

	List<Rental__c> queryMostRecentRentals(Set<Id> stocksIds);
}