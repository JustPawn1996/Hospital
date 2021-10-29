public class VisitShareService {
	public static void ShareVisit(List<Visit__c> newList){
        Set<Id> visitIds = new Set<Id>();
        
        for(Visit__c visit: newList){
            visitIds.add(visit.Id);
            }
        Map<Id,Set<Id>> doctorIdByVisitId = new Map<Id,Set<Id>>();
        Map<Id,Set<Id>> patientIdByVisitId = new Map<Id,Set<Id>>();
        Map<Id,Set<Id>> patientIdByDoctorId = new Map<Id,Set<Id>>();
        for(Visit__c visit : [SELECT Id, Patient__r.User__c, Patient__c,  Doctor__r.User__c 
                              FROM Visit__c 
                              WHERE Id = :visitIds
                          ]){ 
                                 
        doctorIdByVisitId.put(visit.Id, visit.Doctor__r.User__c); 

        

        if (!patientIdByVisitId.containsKey(visit.Id) {
            patientIdByVisitId.put(visit.Id, new Set<Id>());
        }
        patientIdByVisitId.get(visit.Id).add(visit.Patient__c);
  
               
        if (!patientIdByDoctorId.containsKey(visit.Doctor__r.User__c)) {
            patientIdByDoctorId.put(visit.Doctor__r.User__c, new Set<Id>());
        }
        patientIdByDoctorId.get(visit.Doctor__r.User__c).add(visit.Patient__c);
  
                    	             
    }
        
        // делаешь мапку доккторОВ по пациенту 
        // потом просто в форе делаешь гет  по пациенту 
        // 
        
        List<Medical_card__c> medicalCardsForAllPatients = [SELECT Id, Patient__c FROM Medical_card__c WHERE Patient__c = :patientIdByDoctorId.values()];
        
        for()
        
        Map<Id,Id> medCardIdByDoctorId = new Map<Id,Id>();
        for(Id docId : patientIdByDoctorId.keySet()){
            for(Medical_card__c MedCard : medicalCardsForAllPatients){
                if(patientIdByDoctorId.get(docId)==MedCard.Patient__c){
                    medCardIdByDoctorId.put(docId, MedCard.Id);
                }
            }
        }
        
        List<Group> publicGroup = [SELECT Id, Group.name FROM Group WHERE Group.name = 'administrators' LIMIT 1];
        
        List<Sobject> shareObjs = new List<Sobject>();
        
        for(Id visitId : visitIds){
            Visit__Share visitShare = new Visit__Share();
            visitShare.ParentId  = visitId;
            visitShare.UserOrGroupId = publicGroup[0].Id;
            visitShare.AccessLevel = 'Edit';
            visitShare.RowCause = 'Manual';
            shareObjs.add(visitShare); 
        }


        ///
        /*
        for(Id visitId : doctorIdByVisitId.keySet()){
            if(doctorIdByVisitId.get(visitId) != null){
                Visit__Share visitShare = new Visit__Share();
                visitShare.ParentId  = visitId;
                visitShare.UserOrGroupId = doctorIdByVisitId.get(visitId);
                visitShare.AccessLevel = 'Read';
                visitShare.RowCause = 'Manual';
                shareObjs.add(visitShare);
            }
        }
        
        for(Id visitId : patientIdByVisitId.keySet()){
            if(patientIdByVisitId.get(visitId) != null){
                Visit__Share visitShare = new Visit__Share();
                visitShare.ParentId  = visitId;
                visitShare.UserOrGroupId = patientIdByVisitId.get(visitId);
                visitShare.AccessLevel = 'Edit';
                visitShare.RowCause = 'Manual';
                shareObjs.add(visitShare); 
            }  
        }
        
        for(Id docId : patientIdByDoctorId.keySet()){
            Patient__Share patientShare = new Patient__Share();
            patientShare.ParentId  = patientIdByDoctorId.get(docId);
            patientShare.UserOrGroupId = docId;
            patientShare.AccessLevel = 'Edit';
            patientShare.RowCause = 'Manual';
            shareObjs.add(patientShare); 
        }
        
        for(Id docId : medCardIdByDoctorId.keySet()){
            Medical_card__Share medCardShare = new Medical_card__Share();
            medCardShare.ParentId  = medCardIdByDoctorId.get(docId);
            medCardShare.UserOrGroupId = docId;
            medCardShare.AccessLevel = 'Edit';
            medCardShare.RowCause = 'Manual';
            shareObjs.add(medCardShare); 
        }

        insert shareObjs;
        
    }

}