public with sharing class TestObjectController {
    public TestObject__c newTestObject { get; set; }

    public TestObjectController() {
        newTestObject = new TestObject__c();
    }

    public PageReference save() {
        try {
            insert newTestObject;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Record saved successfully.'));
            return null;
        } catch (Exception e) {
            ApexPages.addMessages(e);
            return null;
        }
    }
}