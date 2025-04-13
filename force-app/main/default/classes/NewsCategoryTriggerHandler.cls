/**
 * Handler class for NewsCategoryTrigger
 */
public with sharing class NewsCategoryTriggerHandler {
    /**
     * Handles after insert events for News_Category__c
     * Uses Queueable for callouts when Sync__c is true
     * @param newRecords List of newly inserted News_Category__c records
     */
    public static void handleInsert(List<News_Category__c> newRecords) {
        // TODO: Implement insert handler

        List<News_Category__c> categoriesToSync = new List<News_Category__c>();

        for (News_Category__c category : newRecords) {
            if (category.Sync__c) {
                categoriesToSync.add(category);
            }
        }

        if (!categoriesToSync.isEmpty()) {
            syncCategoriesWithQueueable(categoriesToSync);
        }
    }
    
    /**
     * Handles after update events for News_Category__c
     * Uses Queueable Apex for callouts when Sync__c is true
     * @param newRecords List of updated News_Category__c records
     * @param oldMap Map of old record states
     */
    public static void handleUpdate(List<News_Category__c> newRecords, Map<Id, News_Category__c> oldMap) {
        // TODO: Implement update handler
        List<News_Category__c> categoriesToSync = new List<News_Category__c>();

        for (News_Category__c category : newRecords) {
            if (category.Sync__c == true) {
                categoriesToSync.add(category);
            }
        }
        if (!categoriesToSync.isEmpty()) {
            syncCategoriesWithQueueable(categoriesToSync);
        }
    }
    
    /**
     * Queueable method to sync categories using the NewsAPI
     * @param categoriesToSync List of News_Category__c records to sync
     */
    private static void syncCategoriesWithQueueable(List<News_Category__c> categoriesToSync) {
        // TODO: Implement queueable job enqueuing
        // - Create and enqueue NewsCategoryQueueable job for each category
        for (News_Category__c category : categoriesToSync) {
            // if(!Test.isRunningTest()) {
                System.enqueueJob(new NewsCategoryQueueable(category, 1));
            // }
        }
    }
} 