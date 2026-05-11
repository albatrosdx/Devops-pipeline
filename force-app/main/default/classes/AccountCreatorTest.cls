@IsTest
private class AccountCreatorTest {

    @IsTest
    static void testCreateAccount_success() {
        Test.startTest();
        Account acc = AccountCreator.createAccount('テスト株式会社', '03-0000-0001');
        Test.stopTest();

        System.assertNotEquals(null, acc.Id, '作成された取引先のIDが取得できる');

        Account retrieved = [
            SELECT Id, Name, Phone
            FROM Account
            WHERE Id = :acc.Id
        ];
        System.assertEquals('テスト株式会社', retrieved.Name);
        System.assertEquals('03-0000-0001', retrieved.Phone);
    }

    @IsTest
    static void testCreateAccount_blankName() {
        try {
            AccountCreator.createAccount('', '03-0000-0001');
            System.assert(false, '例外が発生するはずです');
        } catch (IllegalArgumentException e) {
            System.assertEquals('取引先名は必須です', e.getMessage());
        }
    }
}