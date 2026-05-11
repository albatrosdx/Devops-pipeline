@IsTest
private class BusinessAccountCreatorTest {

    @IsTest
    static void testCreateBusinessAccount_success() {
        BusinessAccountCreator.BusinessAccountInfo info = new BusinessAccountCreator.BusinessAccountInfo();
        info.name         = 'テスト商事';
        info.industry     = 'Technology';
        info.billingCity  = '東京';
        info.billingState = '東京都';
        info.rating       = 'Hot';

        Test.startTest();
        Account result = BusinessAccountCreator.createBusinessAccount(info);
        Test.stopTest();

        System.assertNotEquals(null, result.Id, '作成された取引先のIDが取得できる');

        Account retrieved = [
            SELECT Id, Name, Industry, BillingCity, BillingState, Rating
            FROM Account
            WHERE Id = :result.Id
        ];
        System.assertEquals('テスト商事', retrieved.Name);
        System.assertEquals('Technology', retrieved.Industry);
        System.assertEquals('東京', retrieved.BillingCity);
        System.assertEquals('東京都', retrieved.BillingState);
        System.assertEquals('Hot', retrieved.Rating);
    }

    @IsTest
    static void testCreateBusinessAccountsBulk_success() {
        List<BusinessAccountCreator.BusinessAccountInfo> infos =
            new List<BusinessAccountCreator.BusinessAccountInfo>();

        for (Integer i = 0; i < 5; i++) {
            BusinessAccountCreator.BusinessAccountInfo info =
                new BusinessAccountCreator.BusinessAccountInfo();
            info.name     = 'バルク取引先' + i;
            info.industry = 'Manufacturing';
            infos.add(info);
        }

        Test.startTest();
        List<Account> results = BusinessAccountCreator.createBusinessAccountsBulk(infos);
        Test.stopTest();

        System.assertEquals(5, results.size(), '5件作成される');

        Integer count = [SELECT COUNT() FROM Account WHERE Name LIKE 'バルク取引先%'];
        System.assertEquals(5, count, 'DBに5件登録されている');
    }

    @IsTest
    static void testCreateBusinessAccount_blankName() {
        BusinessAccountCreator.BusinessAccountInfo info =
            new BusinessAccountCreator.BusinessAccountInfo();
        info.name = '';

        try {
            BusinessAccountCreator.createBusinessAccount(info);
            System.assert(false, '例外が発生するはずです');
        } catch (IllegalArgumentException e) {
            System.assertEquals('取引先名は必須です', e.getMessage());
        }
    }

    @IsTest
    static void testCreateBusinessAccountsBulk_emptyList() {
        try {
            BusinessAccountCreator.createBusinessAccountsBulk(new List<BusinessAccountCreator.BusinessAccountInfo>());
            System.assert(false, '例外が発生するはずです');
        } catch (IllegalArgumentException e) {
            System.assertEquals('取引先情報が指定されていません', e.getMessage());
        }
    }
}