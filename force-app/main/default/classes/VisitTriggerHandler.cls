public class VisitTriggerHandler{
    public static void createNewShareObjects(List<Visit__c> newList){
        VisitShareService.ShareVisit(newList);
    }
    
}