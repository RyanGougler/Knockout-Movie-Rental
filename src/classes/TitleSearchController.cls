/**
*	Controller for title search page
*
*	@author	Sahil Grover
*/
public with sharing class TitleSearchController extends TitleController {

	@TestVisible
	private static TitleDAO titleAccessor = new TitleDataAccessor();

	@RemoteAction
	public static List<TitleModel> queryTitlesByName(String searchTerm) {
		return createTitleModels( titleAccessor.queryTitlesByName(searchTerm) );
	}

	@RemoteAction
	public static List<TitleModel> queryTitlesByNameAndGenre(String searchTerm, String genre) {
		return createTitleModels( titleAccessor.queryTitlesByName(searchTerm, genre) );
	}

	@RemoteAction
	public static List<TitleModel> queryFeaturedTitles() {
		return createTitleModels( titleAccessor.queryFeaturedTitles() );
	}

	private static List<TitleModel> createTitleModels(List<Title__c> titleRecords) {
		List<TitleModel> models = new List<TitleModel>();
		for (Title__c title : titleRecords) {
			models.add( new TitleModel(title) );
		}
		return models;
	}
}