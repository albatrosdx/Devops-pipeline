public without sharing class ZipSearchService {

    public class ZipResponse{
        @AuraEnabled public String message;
        @AuraEnabled public List<ZipResponseDetail> results;
        @AuraEnabled public String status;
    }

    public class ZipResponseDetail{
        @AuraEnabled public String address1;
        @AuraEnabled public String address2;
        @AuraEnabled public String address3;
        @AuraEnabled public String kana1;
        @AuraEnabled public String kana2;
        @AuraEnabled public String kana3;
        @AuraEnabled public String prefcode;
        @AuraEnabled public String zipcode;
    }

    @AuraEnabled(cacheable=true)
    public static ZipResponse searchAdressInfo(String zipCode) {

        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://zipcloud.ibsnet.co.jp/api/search?zipcode=' + zipCode);
        req.setMethod('GET');
        req.setHeader('Content-Type','application/json');

        Http http = new Http();
        HttpResponse res = http.send(req);
        System.debug(res.getBody());
        ZipResponse response = (ZipResponse)JSON.deserialize(res.getBody(), ZipResponse.class);
        return response;
    }   

}