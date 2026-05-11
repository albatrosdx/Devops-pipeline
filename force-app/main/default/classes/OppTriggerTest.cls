@isTest
public class OppTriggerTest {
    @isTest
    static void test1() {
        Account a = new Account(Name = 'Test Account');
        insert a;
        Opportunity o = new Opportunity(Name = 'Test Opportunity', AccountId = a.Id, StageName = 'Prospecting', CloseDate = Date.today());
        Test.startTest();
        insert o;
        Test.stopTest();
        o = [SELECT Id, TestItem__c FROM Opportunity WHERE Id = :o.Id];
        System.assertEquals('テストです', o.TestItem__c);

    }
}