import { LightningElement, api, track } from 'lwc';
import { createRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import MEDICAL_RECORD_OBJECT from '@salesforce/schema/Medical_record__c';
import NAME_FIELD from '@salesforce/schema/Medical_record__c.Name';
import MEDICAL_CARD_FIELD from '@salesforce/schema/Medical_record__c.Medical_card__c';
import DESCRIPTION_FIELD from '@salesforce/schema/Medical_record__c.Description__c';
export default class addRecordForm extends LightningElement {
    strName;
    strDescription;
    strmcid;

    @api
    get strmcid() {
        return this.strmcid;
    }

    // Change Handlers.
    nameChangedHandler(event){
        this.strName = event.target.value;
    }
    descriptionChangedHandler(event){
        this.strDescription = event.target.value;
    }
    // Insert record.
    create(){
        const fields = {};
        fields[NAME_FIELD.fieldApiName] = this.strName;
        //fields[MEDICAL_CARD_FIELD.fieldApiName] = this.strmcid;
        //fields[DESCRIPTION_FIELD.fieldApiName] = this.strDescription;
        const recordInput = { apiName: MEDICAL_RECORD_OBJECT.objectApiName, fields };
        createRecord(recordInput)
            .then(result => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Success',
                        variant: 'success',
                    }),
                );
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message: error.body.message,
                        variant: 'error',
                    }),
                );
            });
   
    }
}