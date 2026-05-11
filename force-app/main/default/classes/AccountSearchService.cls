public with sharing class AccountSearchService {

    public class FlowInvokeInput {
        @InvocableVariable
        public String AccountName;
    }

    public class AccountWrapper {
        @AuraEnabled
        public String AccountName;
        @AuraEnabled
        public Date Birthday;
        @AuraEnabled
        public String Residence;
        @AuraEnabled
        public Decimal Height;
        @AuraEnabled
        public Decimal Weight;
        @AuraEnabled
        public Decimal BMI;
    }

    @InvocableMethod(label='Search Account' description='Saves the account record')
    public static List<List<Account>> searchAccount(List<FlowInvokeInput> accountData) {
        String accountDataName = accountData.get(0).AccountName;
        List<Account> accountList = [SELECT Id, Name, Birthday__c, Residence__c, Height__c, Weight__c FROM Account WHERE Name = :accountDataName];

        List<List<Account>> result = new List<List<Account>>();
        result.add(accountList);
        return result;
    }

    @AuraEnabled(cacheable=true)
    public static List<AccountWrapper> searchAccounts(String accountName) {
        List<Account> accountList =  [SELECT Id, Name, Birthday__c, Residence__c, Height__c, Weight__c FROM Account WHERE Name = :accountName];
        List<AccountWrapper> accountWrapperList = new List<AccountWrapper>();
        for(Account acc : accountList) {
            AccountWrapper accWrapper = new AccountWrapper();
            accWrapper.AccountName = acc.Name;
            accWrapper.Birthday = acc.Birthday__c;
            accWrapper.Residence = acc.Residence__c;
            accWrapper.Height = acc.Height__c;
            accWrapper.Weight = acc.Weight__c;
            accWrapper.BMI = (accWrapper.Weight / ( (accWrapper.Height / 100 ) * (accWrapper.Height / 100 ) ) ).setScale(2,RoundingMode.HALF_UP);
            accountWrapperList.add(accWrapper);
        }
        return accountWrapperList;
    }   

}