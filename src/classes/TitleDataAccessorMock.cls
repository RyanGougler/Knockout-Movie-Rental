/**
* Mock data accessor for Titles
*
* @author	Sahil Grover
*/
@isTest
public class TitleDataAccessorMock implements TitleDAO {

	public List<Title__c> FeaturedTitlesToReturn { get; set; }
	public List<Title__c> QueriedTitlesToReturn { get; set; }
	public List<Title__c> GenreTitlesToReturn { get; set; }
	public Title__c TitleToReturn { get; set; }
	public Title__c SavedTitle { get; private set; }
		
	public List<Title__c> queryTitlesByName(String nameKeyword) {
		return this.QueriedTitlesToReturn;
	}

	public List<Title__c> queryTitlesByName(String nameKeyword, String genre) {
		return this.GenreTitlesToReturn;
	}

	public List<Title__c> queryFeaturedTitles() {
		return this.FeaturedTitlesToReturn;
	}

	public Title__c queryTitleById(Id titleId) {
		return this.TitleToReturn;
	}

	public void saveTitle(Title__c title) {
		this.SavedTitle = title;
	}
}