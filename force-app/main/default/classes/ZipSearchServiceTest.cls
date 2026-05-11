@IsTest
private class ZipSearchServiceTest {

    /**
     * 成功レスポンスを返すモック
     */
    private class ZipApiSuccessMock implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(200);
            res.setBody(
                '{' +
                '"message":null,' +
                '"results":[{' +
                    '"address1":"東京都",' +
                    '"address2":"千代田区",' +
                    '"address3":"千代田",' +
                    '"kana1":"トウキョウト",' +
                    '"kana2":"チヨダク",' +
                    '"kana3":"チヨダ",' +
                    '"prefcode":"13",' +
                    '"zipcode":"1000001"' +
                '}],' +
                '"status":"200"' +
                '}'
            );
            return res;
        }
    }

    /**
     * 該当なしのレスポンスを返すモック (results が null)
     */
    private class ZipApiEmptyMock implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(200);
            res.setBody('{"message":null,"results":null,"status":"200"}');
            return res;
        }
    }

    @IsTest
    static void testSearchAdressInfo_success() {
        Test.setMock(HttpCalloutMock.class, new ZipApiSuccessMock());

        Test.startTest();
        ZipSearchService.ZipResponse response =
            ZipSearchService.searchAdressInfo('1000001');
        Test.stopTest();

        System.assertNotEquals(null, response, 'レスポンスが取得できる');
        System.assertEquals('200', response.status);
        System.assertEquals(null, response.message);
        System.assertNotEquals(null, response.results, 'results が存在');
        System.assertEquals(1, response.results.size());

        ZipSearchService.ZipResponseDetail detail = response.results[0];
        System.assertEquals('東京都', detail.address1);
        System.assertEquals('千代田区', detail.address2);
        System.assertEquals('千代田', detail.address3);
        System.assertEquals('トウキョウト', detail.kana1);
        System.assertEquals('チヨダク', detail.kana2);
        System.assertEquals('チヨダ', detail.kana3);
        System.assertEquals('13', detail.prefcode);
        System.assertEquals('1000001', detail.zipcode);
    }

    @IsTest
    static void testSearchAdressInfo_noResult() {
        Test.setMock(HttpCalloutMock.class, new ZipApiEmptyMock());

        Test.startTest();
        ZipSearchService.ZipResponse response =
            ZipSearchService.searchAdressInfo('0000000');
        Test.stopTest();

        System.assertNotEquals(null, response, 'レスポンスは取得できる');
        System.assertEquals('200', response.status);
        System.assertEquals(null, response.results, '該当なしのときは results が null');
    }
}