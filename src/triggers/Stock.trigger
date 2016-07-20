/**
*	Trigger for Stock__c object
*
*	@author	Sahil Grover
*/
trigger Stock on Stock__c (after update)  {

	if (Trigger.isAfter && Trigger.isUpdate) {
		StockTriggerFacade stockFacade = StockTriggerFacade.createStockTriggerFacade();
		stockFacade.saveRentalHistory(Trigger.OldMap, Trigger.New);
		stockFacade.updateReturns(Trigger.oldMap, Trigger.New);
	}

}