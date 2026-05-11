public with sharing class AccountSaveService {

    public class FlowInvokeInput {
        @InvocableVariable
        public String AccountName;
        @InvocableVariable
        public Date Birthday;
        @InvocableVariable
        public String Residence;
        @InvocableVariable
        public Decimal Height;
        @InvocableVariable
        public Decimal Weight;
    }

    @InvocableMethod(label='Save Account' description='Saves the account record')
    public static void saveAccount(List<FlowInvokeInput> accountData) {
        List<Account> accountsToSave = new List<Account>();

        for (FlowInvokeInput data : accountData) {
            Account acc = new Account();
            acc.Name = data.AccountName;
            acc.Birthday__c = data.Birthday;
            acc.Residence__c = data.Residence;
            acc.Height__c = data.Height;
            acc.Weight__c = data.Weight;
            accountsToSave.add(acc);
        }

        if (!accountsToSave.isEmpty()) {
            insert accountsToSave;
        }
    }
}