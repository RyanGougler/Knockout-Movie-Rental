/**
*	Shared logic for all controllers related to titles
*
*	@author	Sahil Grover
*/
public abstract class TitleController {

	public List<SelectOption> GenreOptions { get; private set; }

	public void init() {
		SelectOptionGenerator selOptGen = new SelectOptionGenerator();
		this.GenreOptions = selOptGen.generateOptions(Title__c.Genre__c);
	}
}