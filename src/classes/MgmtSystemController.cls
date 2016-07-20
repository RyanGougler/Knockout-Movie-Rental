public with sharing class MgmtSystemController {
	private static List<Title__c> titles {get; private set;}
    public static String titlesJSON {get;private set;}
	
    public MgmtSystemController(){
        titles = [
            SELECT Id
                ,Name
                ,AvailableStock__c
                ,TotalStock__c
                ,Featured__c
                ,Genre__c
            FROM Title__c
            ORDER BY Name ASC];
            titlesJSON = JSON.serialize(titles);
    }
}