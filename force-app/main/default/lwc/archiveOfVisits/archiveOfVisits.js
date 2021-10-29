import { LightningElement } from 'lwc';  
import getSearchVisit from '@salesforce/apex/VisitService.getSearchVisit';  
  
const columns = [ 
    { label: 'Id', fieldName: 'Id' },
    { label: 'Patient', fieldName: 'PatientName' },    
    { label: 'StartDate', fieldName: 'StartDate'},
    { label: 'EndDate', fieldName: 'EndDate'}
];  
  
export default class archiveOfVisits extends LightningElement {  
  
    data;  
    error;  
    columns = columns;  
  
    handleKeyChange( event ) {  
          
        const searchKey = event.target.value;  
  
        if ( searchKey ) {  
  
            getSearchVisit( { searchKey } )    
            .then(result => {  
  
                this.data = result;  
  
            })  
            .catch(error => {  
  
                this.error = error;  
  
            });  
  
        }   else  
        this.data = undefined;    
      
    }
  
}