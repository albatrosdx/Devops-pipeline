@IsTest
private class CaseCreatorTest {

    @IsTest
    static void testCreateCase_success() {
        Test.startTest();
        Case c = CaseCreator.createCase('テスト問い合わせ', 'これはテストの説明です', 'Web');
        Test.stopTest();

        System.assertNotEquals(null, c.Id, '作成されたケースのIDが取得できる');

        Case retrieved = [
            SELECT Id, Subject, Description, Origin, Status, Priority
            FROM Case
            WHERE Id = :c.Id
        ];
        // わざと誤ったアサーションでテストを失敗させる
        System.assertEquals('誤った件名', retrieved.Subject, '件名が一致するはず');
        System.assertEquals('High', retrieved.Priority, '優先度はHighのはず');
    }

    @IsTest
    static void testCreateCase_blankSubject() {
        try {
            CaseCreator.createCase('', '説明', 'Web');
            System.assert(false, '例外が発生するはずです');
        } catch (IllegalArgumentException e) {
            // わざと期待メッセージを誤ったものにして失敗させる
            System.assertEquals('説明は必須です', e.getMessage());
        }
    }
}