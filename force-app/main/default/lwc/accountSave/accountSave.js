import { LightningElement,track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { createRecord } from 'lightning/uiRecordApi';
import ACCOUNT_OBJECT from '@salesforce/schema/Account';
import NAME_FIELD from '@salesforce/schema/Account.Name';
import BIRTHDAY_FIELD from '@salesforce/schema/Account.Birthday__c';
import RESIDENCE_FIELD from '@salesforce/schema/Account.Residence__c';
import HEIGHT_FIELD from '@salesforce/schema/Account.Height__c';
import WEIGHT_FIELD from '@salesforce/schema/Account.Weight__c';

export default class AccountSave extends LightningElement {

    @track accountName;
    @track birthday;
    @track residence;
    @track height;
    @track weight;

    handleNameChange(event){
        this.accountName = event.target.value;
    }

    handleBirthDayChange(event){
        this.birthday = event.target.value;
    }

    handleResidenceChange(event){
        this.residence = event.target.value;
    }   

    handleHeightChange(event){
        this.height = event.target.value;
    }

    handleWeightChange(event){
        this.weight = event.target.value;
    }

    handleSave(){
        const fields = {};
        fields[NAME_FIELD.fieldApiName] = this.accountName;
        fields[BIRTHDAY_FIELD.fieldApiName] = this.birthday;
        fields[RESIDENCE_FIELD.fieldApiName] = this.residence;
        fields[HEIGHT_FIELD.fieldApiName] = this.height;
        fields[WEIGHT_FIELD.fieldApiName] = this.weight;

        const recordInput = { apiName: ACCOUNT_OBJECT.objectApiName, fields };
        createRecord(recordInput)
            .then(result => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: '取引先が作成されました。' + result.Name,
                        variant: 'success',
                    }),
                );
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error creating record',
                        message: '取引先作成に失敗しました' + error.body.message,
                        variant: 'error',
                    }),
                );
            });
    }
}