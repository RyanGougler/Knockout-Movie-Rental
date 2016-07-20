/**
*	Represents a Title record
*
*	@author Sahil Grover
*/
public class TitleModel {

	public Id TitleId { get; set; }
	public String Name { get; set; }
	public String Genre { get; set; }
	public String Description { get; set; }
	public Boolean Featured { get; set; }

	public TitleModel() {
		this.Name = '';
		this.Genre = '';
		this.Description = '';
		this.Featured = false;
	}

	public TitleModel(Title__c titleRecord) {
		this.TitleId = titleRecord.Id;
		this.Name = getModelValue( titleRecord.Name );
		this.Genre = getModelValue( titleRecord.Genre__c );
		this.Description = getModelValue( titleRecord.Description__c );
		this.Featured = getModelValue( titleRecord.Featured__c );
	}

	public Title__c createRecord() {
		return new Title__c(
			Id = this.TitleId,
			Name = this.Name,
			Genre__c = this.Genre,
			Description__c = this.Description,
			Featured__c = this.Featured
			);
	}

	private String getModelValue(String recordValue) {
		if (recordValue == null) {
			return '';
		}

		return recordValue;
	}

	private Boolean getModelValue(Boolean recordValue) {
		if (recordValue == null) {
			return false;
		}

		return recordValue;
	}
}