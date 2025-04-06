/**
 * Trigger for News_Category__c object to sync news from API when Sync__c field is true
 */
trigger NewsCategoryTrigger on News_Category__c (before insert, after insert, after update) {
    // TODO: Implement trigger logic
    // - Call appropriate handler methods for insert and update contexts
    switch on Trigger.operationType {
        when BEFORE_INSERT {
            NewsCategoryTriggerHandler.handleBeforeInsert(Trigger.new);
        }
        when AFTER_INSERT {
            NewsCategoryTriggerHandler.handleAfterInsert(Trigger.new);
        }
        when AFTER_UPDATE {
            NewsCategoryTriggerHandler.handleAfterUpdate(Trigger.new, Trigger.oldMap);
        }
    }
} 