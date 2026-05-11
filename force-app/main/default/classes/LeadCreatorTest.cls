@IsTest
private class LeadCreatorTest {

    @IsTest
    static void testCreateLead_success() {
        LeadCreator.LeadInfo info = new LeadCreator.LeadInfo();
        info.lastName  = '山田';
        info.firstName = '太郎';
        info.company   = 'テスト株式会社';
        info.email     = 'taro.yamada@example.com';
        info.phone     = '03-1234-5678';

        Test.startTest();
        Lead result = LeadCreator.createLead(info);
        Test.stopTest();

        System.assertNotEquals(null, result.Id, '作成されたリードのIDが取得できる');

        Lead retrieved = [
            SELECT Id, LastName, FirstName, Company, Email, Phone, Status
            FROM Lead
            WHERE Id = :result.Id
        ];
        System.assertEquals('山田', retrieved.LastName);
        System.assertEquals('太郎', retrieved.FirstName);
        System.assertEquals('テスト株式会社', retrieved.Company);
        System.assertEquals('taro.yamada@example.com', retrieved.Email);
        System.assertEquals('03-1234-5678', retrieved.Phone);
        System.assertEquals('Open - Not Contacted', retrieved.Status, 'デフォルトステータスが設定されている');
    }

    @IsTest
    static void testCreateLead_withCustomStatus() {
        LeadCreator.LeadInfo info = new LeadCreator.LeadInfo();
        info.lastName = '鈴木';
        info.company  = 'カスタム商事';
        info.status   = 'Working - Contacted';

        Test.startTest();
        Lead result = LeadCreator.createLead(info);
        Test.stopTest();

        Lead retrieved = [SELECT Status FROM Lead WHERE Id = :result.Id];
        System.assertEquals('Working - Contacted', retrieved.Status, '指定したステータスが反映される');
    }

    @IsTest
    static void testCreateLeadsBulk_success() {
        List<LeadCreator.LeadInfo> infos = new List<LeadCreator.LeadInfo>();
        for (Integer i = 0; i < 10; i++) {
            LeadCreator.LeadInfo info = new LeadCreator.LeadInfo();
            info.lastName = 'バルク姓' + i;
            info.company  = 'バルク会社' + i;
            infos.add(info);
        }

        Test.startTest();
        List<Lead> results = LeadCreator.createLeadsBulk(infos);
        Test.stopTest();

        System.assertEquals(10, results.size(), '10件作成される');

        Integer count = [SELECT COUNT() FROM Lead WHERE LastName LIKE 'バルク姓%'];
        System.assertEquals(10, count, 'DBに10件登録されている');
    }

    @IsTest
    static void testCreateLead_blankLastName() {
        LeadCreator.LeadInfo info = new LeadCreator.LeadInfo();
        info.lastName = '';
        info.company  = 'テスト会社';

        try {
            LeadCreator.createLead(info);
            System.assert(false, '例外が発生するはずです');
        } catch (IllegalArgumentException e) {
            System.assertEquals('姓は必須です', e.getMessage());
        }
    }

    @IsTest
    static void testCreateLead_blankCompany() {
        LeadCreator.LeadInfo info = new LeadCreator.LeadInfo();
        info.lastName = '田中';
        info.company  = '';

        try {
            LeadCreator.createLead(info);
            System.assert(false, '例外が発生するはずです');
        } catch (IllegalArgumentException e) {
            System.assertEquals('会社名は必須です', e.getMessage());
        }
    }

    @IsTest
    static void testCreateLead_nullInfo() {
        try {
            LeadCreator.createLead(null);
            System.assert(false, '例外が発生するはずです');
        } catch (IllegalArgumentException e) {
            System.assertEquals('リード情報がnullです', e.getMessage());
        }
    }

    @IsTest
    static void testCreateLeadsBulk_emptyList() {
        try {
            LeadCreator.createLeadsBulk(new List<LeadCreator.LeadInfo>());
            System.assert(false, '例外が発生するはずです');
        } catch (IllegalArgumentException e) {
            System.assertEquals('リード情報が指定されていません', e.getMessage());
        }
    }
}