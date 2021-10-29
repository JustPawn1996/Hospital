trigger VisitTrigger on Visit__c (after insert) {  
    if(trigger.isInsert){
        if(trigger.isAfter){
            VisitTriggerHandler.createNewShareObjects(Trigger.new);
        }
    }
}