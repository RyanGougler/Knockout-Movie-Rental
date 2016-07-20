/**
*	Interface for Title data access objects
*
*	@author	Sahil Grover
*/
public interface TitleDAO {

	List<Title__c> queryTitlesByName(String nameKeyword);

	List<Title__c> queryTitlesByName(String nameKeyword, String genre);

	List<Title__c> queryFeaturedTitles();

	Title__c queryTitleById(Id titleId);

	void saveTitle(Title__c title);
}