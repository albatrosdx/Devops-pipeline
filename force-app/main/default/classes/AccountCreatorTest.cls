@IsTest
private class AccountCreatorTest {

    @IsTest
    static void testCreateAccount_success() {
        Account acc = AccountCreator.createAccount('テスト株式会社', '03-0000-0001');

        // 電話番号のハイフン有無を考慮せず固定値で比較 → 意図的に失敗させるアサーション
        System.assertEquals(
            '0300000001',
            acc.Phone,
            '電話番号が一致しません'
        );
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