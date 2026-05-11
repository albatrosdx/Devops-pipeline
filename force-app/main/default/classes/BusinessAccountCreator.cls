public with sharing class BusinessAccountCreator {

    public class BusinessAccountInfo {
        public String name;
        public String industry;
        public String billingCity;
        public String billingState;
        public String rating;
    }

    public static Account createBusinessAccount(BusinessAccountInfo info) {
        validateInfo(info);

        Account acc = new Account(
            Name         = info.name,
            Industry     = info.industry,
            BillingCity  = info.billingCity,
            BillingState = info.billingState,
            Rating       = info.rating
        );
        insert acc;
        return acc;
    }

    public static List<Account> createBusinessAccountsBulk(List<BusinessAccountInfo> infos) {
        if (infos == null || infos.isEmpty()) {
            throw new IllegalArgumentException('取引先情報が指定されていません');
        }

        List<Account> accounts = new List<Account>();
        for (BusinessAccountInfo info : infos) {
            validateInfo(info);
            accounts.add(new Account(
                Name         = info.name,
                Industry     = info.industry,
                BillingCity  = info.billingCity,
                BillingState = info.billingState,
                Rating       = info.rating
            ));
        }
        insert accounts;
        return accounts;
    }

    private static void validateInfo(BusinessAccountInfo info) {
        if (info == null || String.isBlank(info.name)) {
            throw new IllegalArgumentException('取引先名は必須です');
        }
    }
}