import { LightningElement,wire } from 'lwc';  
import getTodayVisit from '@salesforce/apex/VisitService.getTodayVisit';  
import { NavigationMixin } from 'lightning/navigation';  
  
const columns = [  
    { label: 'Patient', fieldName: 'PatientName' },   
    { label: 'Appointment Time', fieldName: 'StartDate'},  
    {type: "button", typeAttributes: {  
        label: 'Start',  
        name: 'Start',  
        title: 'Start',  
        value: 'Start',  
        iconPosition: 'left',
        //disabled: {fieldName: 'isActive'}  
    }} 
];  
  
export default class my_visit_today extends NavigationMixin(LightningElement) {  
    data;
    error;
    columns = columns; 

    @wire(getTodayVisit)  
    wiredVisits({ error, data }) {
        if (data) {
            this.data = data;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.data = undefined;
        }
    }


    callRowAction( event ) {  

        const recId =  event.detail.row.Id;  
        const actionName = event.detail.action.name;  
        if ( actionName === 'Start' ) {  
  
            this[NavigationMixin.Navigate]({  
                type: 'standard__recordPage',  
                attributes: {  
                    recordId: recId,  
                    objectApiName: 'Visit__c',  
                    actionName: 'view'  
                }  
            })        
        }
    }  
  
}