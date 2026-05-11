import { LightningElement, track } from 'lwc';
import searchAccounts from '@salesforce/apex/AccountSearchService.searchAccounts';

const columns = [
    { label: '取引先名', fieldName: 'AccountName', type: 'text' },
    { label: '生年月日', fieldName: 'Birthday', type: 'date' },
    { label: '居住地', fieldName: 'Residence', type: 'text' },
    { label: '身長', fieldName: 'Height', type: 'number' },
    { label: '体重', fieldName: 'Weight', type: 'number' },
    { label: 'BMI', fieldName: 'BMI', type: 'number' }
];

export default class AccountSave extends LightningElement {

    @track accountName;
    columns = columns;
    accounts;

    handleNameChange(event){
        this.accountName = event.target.value;
    }

    handleSearch(){
        searchAccounts({accountName : this.accountName})
            .then(result => {
                this.accounts = result;
                console.log(result);
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error search record',
                        message: '取引先取得に失敗しました' + error.body.message,
                        variant: 'error',
                    }),
                );
            });
    }



}