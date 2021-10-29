public with sharing class VisitService {  

    @AuraEnabled( cacheable = true )  
    public static List<VisitWrapper> getTodayVisit() {                 
    List<VisitWrapper> listVisitWrapper = new List<VisitWrapper>();

    for (Visit__c visit : [ SELECT Id, Patient__r.Name, Doctor__c, StartDate__c 
                        FROM Visit__c
                        WHERE StartDate__c = TODAY
                        ]) {

    DateTime now = System.now();
    DateTime nowMinus15Min = now.addMinutes(-15);
    DateTime nowPlus15Min = now.addMinutes(15);

    VisitWrapper VisitWrap = new VisitWrapper();
    VisitWrap.Id = visit.Id;
    VisitWrap.PatientName = visit.Patient__r.Name;
    VisitWrap.StartDate = visit.StartDate__c.format( 'dd/MM HH:mm' );
    VisitWrap.isActive = !(visit.StartDate__c.addHours(4) >= nowMinus15Min && visit.StartDate__c.addHours(4) <= nowPlus15Min);
    listVisitWrapper.add(VisitWrap);
    }
    return listVisitWrapper;
            }   
            
    @AuraEnabled( cacheable = true )  
    public static VisitWrapper getPatientNameFromVisit(Id visitId) {
        List<Visit__c> visit= [ SELECT Id, Patient__r.Name, Patient__r.Id
                                FROM Visit__c
                                WHERE Id = :visitId
                                ];
        Id MCId;

        for(Patient__c patient: [ SELECT Id, (SELECT Id FROM Medical_cards__r)
                                FROM Patient__c
                                WHERE Id = :visit[0].Patient__r.Id
                                ]){
            for(Medical_card__c MC : patient.Medical_cards__r){
                MCId = MC.Id;
            }
        }     

        VisitWrapper VisitWrap = new VisitWrapper();
        VisitWrap.PatientName = visit[0].Patient__r.Name;
        VisitWrap.medicalCardId = MCId;

        return VisitWrap;
        
    }
    @AuraEnabled
    public static String updateVisit(Id visitId) {                 
        List<Visit__c> visits = new List<Visit__c>();
        for (Visit__c visit : [ SELECT Id, Patient__r.Name, Doctor__c, StartDate__c 
                            FROM Visit__c
                            WHERE Id = :visitId
                            ]) {
        visit.endDate__c = System.now().addHours(-16);
        visits.add(visit);              
                            }
        update visits;
        return 'success';
                        }

    
    @AuraEnabled ( cacheable = true ) 
    public static List< VisitWrapper > getSearchVisit( String searchKey ) { 
    List<VisitWrapper> listVisitWrapper = new List<VisitWrapper>();

    String strKey = '%' + searchKey + '%';  
    for (Visit__c visit :[SELECT Id, Name, Patient__r.Name, StartDate__c, EndDate__c 
                          FROM Visit__c WHERE Patient__r.Name 
                          LIKE: strKey  ]) {


    VisitWrapper VisitWrap = new VisitWrapper();
    VisitWrap.Id = visit.Id;
    VisitWrap.PatientName = visit.Patient__r.Name;
    VisitWrap.StartDate = visit.StartDate__c.format( 'dd/MM HH:mm' );
    VisitWrap.EndDate = visit.EndDate__c.format( 'dd/MM HH:mm' );
    listVisitWrapper.add(VisitWrap);
    }
    return listVisitWrapper;    
    }                    
            

          


    public class VisitWrapper {

        @AuraEnabled
        public String Id;
        @AuraEnabled
        public String PatientName;
        @AuraEnabled
        public Boolean isActive;
        @AuraEnabled
        public String StartDate; 
        @AuraEnabled
        public String EndDate; 
        @AuraEnabled
        public String medicalCardId; 
    }
 
}