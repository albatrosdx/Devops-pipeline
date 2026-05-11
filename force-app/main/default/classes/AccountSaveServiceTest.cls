@IsTest
private class AccountSaveServiceTest {

    @IsTest
    static void testSaveAccount_singleRecord() {
        AccountSaveService.FlowInvokeInput input = new AccountSaveService.FlowInvokeInput();
        input.AccountName = '山田太郎';
        input.Birthday    = Date.newInstance(1990, 1, 15);
        input.Residence   = '東京都';
        input.Height      = 170.5;
        input.Weight      = 65.2;

        List<AccountSaveService.FlowInvokeInput> inputs =
            new List<AccountSaveService.FlowInvokeInput>{ input };

        Test.startTest();
        AccountSaveService.saveAccount(inputs);
        Test.stopTest();

        List<Account> accounts = [
            SELECT Id, Name, Birthday__c, Residence__c, Height__c, Weight__c
            FROM Account
            WHERE Name = '山田太郎'
        ];
        System.assertEquals(1, accounts.size(), '1件作成されている');
        System.assertEquals('山田太郎', accounts[0].Name);
        System.assertEquals(Date.newInstance(1990, 1, 15), accounts[0].Birthday__c);
        System.assertEquals('東京都', accounts[0].Residence__c);
        System.assertEquals(170.5, accounts[0].Height__c);
        System.assertEquals(65.2, accounts[0].Weight__c);
    }

    @IsTest
    static void testSaveAccount_multipleRecords() {
        List<AccountSaveService.FlowInvokeInput> inputs =
            new List<AccountSaveService.FlowInvokeInput>();

        for (Integer i = 0; i < 5; i++) {
            AccountSaveService.FlowInvokeInput input = new AccountSaveService.FlowInvokeInput();
            input.AccountName = 'バルク取引先' + i;
            input.Birthday    = Date.newInstance(1990, 1, 1).addDays(i);
            input.Residence   = '東京都';
            input.Height      = 170 + i;
            input.Weight      = 60 + i;
            inputs.add(input);
        }

        Test.startTest();
        AccountSaveService.saveAccount(inputs);
        Test.stopTest();

        Integer count = [SELECT COUNT() FROM Account WHERE Name LIKE 'バルク取引先%'];
        System.assertEquals(5, count, '5件作成されている');
    }

    @IsTest
    static void testSaveAccount_emptyList() {
        List<AccountSaveService.FlowInvokeInput> inputs =
            new List<AccountSaveService.FlowInvokeInput>();

        Test.startTest();
        AccountSaveService.saveAccount(inputs);
        Test.stopTest();

        Integer count = [SELECT COUNT() FROM Account];
        System.assertEquals(0, count, '空リストの場合は何も作成されない');
    }
}