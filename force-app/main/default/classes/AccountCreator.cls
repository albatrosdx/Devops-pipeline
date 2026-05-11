public with sharing class AccountCreator {

    public static Account createAccount(String name, String phone) {
        if (String.isBlank(name)) {
            throw new IllegalArgumentException('取引先名は必須です');
        }

        Account acc = new Account(
            Name  = name,
            Phone = phone
        );
        insert acc;
        return acc;
    }
}