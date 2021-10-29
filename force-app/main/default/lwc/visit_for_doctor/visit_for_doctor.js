import { LightningElement, wire, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getPatientNameFromVisit from '@salesforce/apex/VisitService.getPatientNameFromVisit';  
import updateVisit from '@salesforce/apex/VisitService.updateVisit';  
import { NavigationMixin } from 'lightning/navigation';



export default class Visit_for_doctor extends NavigationMixin(LightningElement) {
    @api recordId;
    PatientName;
    error;
   @api mcId;


    
       @wire(getPatientNameFromVisit, {visitId: '$recordId'})
       wiredBoats({data, error}) {
           if (data) {
               this.PatientName = data.PatientName;
               this.MCId = data.medicalCardId;
           } else if (error) {
               console.log('data.error')
               console.log(error)
           }
       }
   
finishVisit() {  
    updateVisit({ visitId: this.recordId })
            .then(() => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Success',
                        variant: 'success'
                    })
                );
                //return refreshApex(this.contact);
            })
            .catch((error) => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message: error.body.message,
                        variant: 'error'
                    })
                );
            });
    }
 openMedicalCard() {
    console.log('here1')
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.mcId,
                objectApiName: 'Medical_card__c',
                actionName: 'view'
            },
        });
    }

}