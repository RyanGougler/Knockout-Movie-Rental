/**
*	Generate select options
*
*	@author	Sahil Grover
*/
public with sharing class SelectOptionGenerator {
	
	public List<SelectOption> generateOptions(SObjectField field) {
		List<SelectOption> options = new List<SelectOption>();
		List<Schema.PicklistEntry> picklistEntries = field.getDescribe().getPicklistValues();
		for (Schema.PicklistEntry entry : picklistEntries) {
			options.add(
				new SelectOption(entry.getLabel(), entry.getValue())
				);
		}
		return options;
	}
}