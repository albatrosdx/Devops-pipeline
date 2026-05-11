trigger OppTrigger on Opportunity (before insert) {

    for(Opportunity opp : Trigger.new) {
        opp.TestItem__c = 'テストです';
    }

}