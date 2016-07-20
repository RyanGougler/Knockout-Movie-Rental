/**
*	Data access object for Title records
*
*	@author	Sahil Grover
*/
public with sharing class TitleDataAccessor implements TitleDAO {
	
	public List<Title__c> queryTitlesByName(String nameKeyword) {
		String nameSearchTerm = buildNameSearchTerm(nameKeyword);
		return [
			SELECT Id, Name, Genre__c, Description__c, Featured__c
			FROM Title__c
			WHERE Name LIKE :nameSearchTerm
		];
	}

	public List<Title__c> queryTitlesByName(String nameKeyword, String genre) {
		String nameSearchTerm = buildNameSearchTerm(nameKeyword);
		return [
			SELECT Id, Name, Genre__c, Description__c, Featured__c
			FROM Title__c
			WHERE Name LIKE :nameSearchTerm
				AND Genre__c INCLUDES (:genre)
		];
	}

	private String buildNameSearchTerm(String nameKeyword) {
		return '%' + String.escapeSingleQuotes(nameKeyword) + '%';
	}

	public List<Title__c> queryFeaturedTitles() {
		return [
			SELECT Id, Name, Genre__c, Description__c, Featured__c
			FROM Title__c
			WHERE Featured__c = true
		];
	}

	public Title__c queryTitleById(Id titleId) {
		return [
			SELECT Id, Name, Genre__c, Description__c, Featured__c
			FROM Title__c
			WHERE Id = :titleId
		];
	}

	public void saveTitle(Title__c title) {
		upsert title;
	}
}