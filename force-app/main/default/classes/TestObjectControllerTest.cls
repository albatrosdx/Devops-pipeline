@isTest
private class TestObjectControllerTest {
    
    @isTest
    static void testSaveSuccess() {
        // Create an instance of the controller
        TestObjectController controller = new TestObjectController();
        
        // Set the necessary fields on the TestObject__c
        controller.newTestObject.Name = 'Test Name'; // Adjust fields as needed
        controller.newTestObject.TestItem__c = '1';
        
        // Call the save method
        Test.startTest();
        PageReference result = controller.save();
        Test.stopTest();
        
        // Verify: Check if the record was inserted
        TestObject__c[] insertedRecords = [SELECT Id, Name FROM TestObject__c WHERE Name = 'Test Name'];
        System.assertEquals(1, insertedRecords.size(), 'Record should be inserted');
        
        // Verify: Check if a confirmation message was added
        List<ApexPages.Message> messages = ApexPages.getMessages();        
        System.assertEquals(1, messages.size(), 'There should be one message.');
        System.assertEquals(ApexPages.Severity.CONFIRM, messages[0].getSeverity(), 'Message should be a confirmation.');
        System.assertEquals('Record saved successfully.', messages[0].getSummary(), 'The message content should match.');
    }

@isTest
static void testSaveException() {
    // Create an instance of the controller
    TestObjectController controller = new TestObjectController();
    
    // Leave a required field unset or set it to an invalid value
    // For example, let's assume 'Name' is required and we are not setting it
    
    // Call the save method
    Test.startTest();
    PageReference result = controller.save();
    Test.stopTest();
    
    // Verify: Check if no record was inserted
    TestObject__c[] insertedRecords = [SELECT Id FROM TestObject__c WHERE Id = :controller.newTestObject.Id];
    System.assertEquals(0, insertedRecords.size(), 'Record should not be inserted due to validation error');
    
    // Verify: Check if error messages were added
    List<ApexPages.Message> messages = ApexPages.getMessages();
    System.assert(messages.size() > 0, 'There should be error messages.');
    System.assertEquals(ApexPages.Severity.ERROR, messages[0].getSeverity(), 'Message should be an error.');
}
}