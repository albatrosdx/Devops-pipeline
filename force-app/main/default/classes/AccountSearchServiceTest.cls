@IsTest
private class AccountSearchServiceTest {

    @TestSetup
    static void setupTestData() {
        List<Account> accounts = new List<Account>();
        accounts.add(new Account(
            Name         = '検索対象A',
            Birthday__c  = Date.newInstance(1990, 5, 10),
            Residence__c = '東京都',
            Height__c    = 170,
            Weight__c    = 65
        ));
        accounts.add(new Account(
            Name         = '検索対象A',
            Birthday__c  = Date.newInstance(1985, 8, 20),
            Residence__c = '大阪府',
            Height__c    = 160,
            Weight__c    = 50
        ));
        accounts.add(new Account(
            Name         = '別取引先',
            Birthday__c  = Date.newInstance(1995, 1, 1),
            Residence__c = '京都府',
            Height__c    = 175,
            Weight__c    = 70
        ));
        insert accounts;
    }

    @IsTest
    static void testSearchAccount_invocable_matchFound() {
        AccountSearchService.FlowInvokeInput input = new AccountSearchService.FlowInvokeInput();
        input.AccountName = '検索対象A';

        List<AccountSearchService.FlowInvokeInput> inputs =
            new List<AccountSearchService.FlowInvokeInput>{ input };

        Test.startTest();
        List<List<Account>> result = AccountSearchService.searchAccount(inputs);
        Test.stopTest();

        System.assertEquals(1, result.size(), '結果は1レベルのリスト');
        System.assertEquals(2, result[0].size(), '同名の取引先2件がヒット');
    }

    @IsTest
    static void testSearchAccount_invocable_noMatch() {
        AccountSearchService.FlowInvokeInput input = new AccountSearchService.FlowInvokeInput();
        input.AccountName = '存在しない取引先';

        List<AccountSearchService.FlowInvokeInput> inputs =
            new List<AccountSearchService.FlowInvokeInput>{ input };

        Test.startTest();
        List<List<Account>> result = AccountSearchService.searchAccount(inputs);
        Test.stopTest();

        System.assertEquals(1, result.size());
        System.assertEquals(0, result[0].size(), '一致なしで空リスト');
    }

    @IsTest
    static void testSearchAccounts_aura_matchFoundWithBMI() {
        Test.startTest();
        List<AccountSearchService.AccountWrapper> wrappers =
            AccountSearchService.searchAccounts('検索対象A');
        Test.stopTest();

        System.assertEquals(2, wrappers.size(), '2件取得');

        for (AccountSearchService.AccountWrapper w : wrappers) {
            System.assertEquals('検索対象A', w.AccountName);
            System.assertNotEquals(null, w.BMI, 'BMIが計算されている');

            // BMI = Weight / ((Height/100) ^ 2)
            Decimal expectedBmi = (w.Weight / ((w.Height / 100) * (w.Height / 100)))
                                    .setScale(2, RoundingMode.HALF_UP);
            System.assertEquals(expectedBmi, w.BMI, 'BMIの算出が正しい');
        }
    }

    @IsTest
    static void testSearchAccounts_aura_specificBMICalculation() {
        // 身長170cm, 体重65kg → BMI = 65 / 1.7^2 = 22.49 (setScale(2, HALF_UP))
        Test.startTest();
        List<AccountSearchService.AccountWrapper> wrappers =
            AccountSearchService.searchAccounts('検索対象A');
        Test.stopTest();

        AccountSearchService.AccountWrapper target;
        for (AccountSearchService.AccountWrapper w : wrappers) {
            if (w.Height == 170) {
                target = w;
                break;
            }
        }
        System.assertNotEquals(null, target, '170cmの対象が存在');
        System.assertEquals(Decimal.valueOf('22.49'), target.BMI, 'BMI = 22.49');
    }

    @IsTest
    static void testSearchAccounts_aura_noMatch() {
        Test.startTest();
        List<AccountSearchService.AccountWrapper> wrappers =
            AccountSearchService.searchAccounts('存在しない取引先');
        Test.stopTest();

        System.assertEquals(0, wrappers.size(), '一致なしで空リスト');
    }
}