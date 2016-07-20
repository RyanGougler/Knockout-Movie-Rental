/**
*	Controller for Title Detail page
*
*	@author	Sahil Grover
*/
public with sharing class TitleDetailController extends TitleController {

	@TestVisible
	private static TitleDAO titleAccessor = new TitleDataAccessor();

	public Id TitleId { get; private set; }

	public TitleDetailController(ApexPages.StandardController stdCon) {
		this.TitleId = stdCon.getId();
	}

	@RemoteAction
	public static TitleModel getTitle(Id titleId) {
		if (titleId == null) {
			return new TitleModel();
		}

		return new TitleModel(titleAccessor.queryTitleById(titleId));
	}

	@RemoteAction
	public static void saveTitle(TitleModel title) {
		titleAccessor.saveTitle(title.createRecord());
	}
}