import { LightningElement,track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import searchZipInfo from '@salesforce/apex/ZipSearchService.searchAdressInfo';

export default class ZipSearch extends LightningElement {

    @track zip;
    zipInfo;
    address;
    addresskana;

    handleZipChange(event){
        this.zip = event.target.value;
    }

    handleSearch(){
        searchZipInfo({zipCode : this.zip})
            .then(result => {
                this.zipInfo = result;
                this.address = this.zipInfo.results[0].address1 + this.zipInfo.results[0].address2 + this.zipInfo.results[0].address3;
                this.addresskana = this.zipInfo.results[0].kana1 + this.zipInfo.results[0].kana2 + this.zipInfo.results[0].kana3;
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error search record',
                        message: '住所情報取得に失敗しました' + error.message,
                        variant: 'error',
                    }),
                );
            });
    }


}