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
        System.assertEquals('テスト問い合わせ', retrieved.Subject, '件名が一致するはず');
        System.assertEquals('これはテストの説明です', retrieved.Description, '説明が一致するはず');
        System.assertEquals('Web', retrieved.Origin, '発生源が一致するはず');
        System.assertEquals('New', retrieved.Status, 'ステータスはNewのはず');
        System.assertEquals('Medium', retrieved.Priority, '優先度はMediumのはず');
    }

    @IsTest
    static void testCreateCase_blankSubject() {
        try {
            CaseCreator.createCase('', '説明', 'Web');
            System.assert(false, '例外が発生するはずです');
        } catch (IllegalArgumentException e) {
            System.assertEquals('件名は必須です', e.getMessage());
        }
    }
}