/**
 * Handler class for NewsCategoryTrigger
 */
public with sharing class NewsCategoryTriggerHandler {
    public static void handleBeforeInsert(List<News_Category__c> newRecords) {
        for (News_Category__c newRecord : newRecords) {
            newRecord.Last_Synced__c = System.now();
        }
    }
    /**
     * Handles after insert events for News_Category__c
     * Uses Future method for callouts when Sync__c is true
     * @param newRecords List of newly inserted News_Category__c records
     */
    public static void handleAfterInsert(List<News_Category__c> newRecords) {
        // TODO: Implement insert handler
        // - Filter categories that need to be synced
        // - Call future method for callouts
        Map<String, String> newsCategoriesToSync = new Map<String, String>();
        List<News_Category__c> newsCategoriesToClearAfterCallout = new List<News_Category__c>();
        for (News_Category__c newsCategory : newRecords) {
            if (newsCategory.Sync__c == true) {
                newsCategoriesToSync.put(newsCategory.Id, newsCategory.Name);
                newsCategoriesToClearAfterCallout.add(newsCategory);
            }
        }
        if (!newsCategoriesToSync.isEmpty()) {
            for (String newsCategoryToSync : newsCategoriesToSync.keySet()) {
                NewsAPIService.insertHeadlinesByCategory(newsCategoryToSync, newsCategoriesToSync.get(newsCategoryToSync));
            }
            List<News_Category__c> updateCategories = new List<News_Category__c>();
            for (News_Category__c newsCategoryToClearAfterCallout : newsCategoriesToClearAfterCallout) {
                News_Category__c categoryToUpdate = new News_Category__c();
                categoryToUpdate.Id = newsCategoryToClearAfterCallout.Id;
                categoryToUpdate.Sync__c = false;
                updateCategories.add(categoryToUpdate);
            }
            update updateCategories;
        }
    }
    
    /**
     * Handles after update events for News_Category__c
     * Uses Queueable Apex for callouts when Sync__c is true
     * @param newRecords List of updated News_Category__c records
     * @param oldMap Map of old record states
     */
    public static void handleAfterUpdate(List<News_Category__c> newRecords, Map<Id, News_Category__c> oldMap) {
        // TODO: Implement update handler
        // - Filter categories that need to be synced
        // - Call queueable method for callouts

        // on update, if category sync__c == true
        // run the callout to get articles with the category
        // articles are inserted
        // category.Last_Synced__c is updated to System.now()
        // category.sync__c is reset to false
        List<News_Category__c> recordsToSync = new List<News_Category__c>();
        for (News_Category__c newRecord : newRecords) {
            if (newRecord.Sync__c == true && oldMap.get(newRecord.Id).Sync__c == false) {
                recordsToSync.add(newRecord);
            }
        }
        if (recordsToSync.isEmpty()) {
            return;
        }

        List<News_Category__c> recordsToUpdate = new List<News_Category__c>();
        for (News_Category__c newRecord : recordsToSync) {
            NewsAPIService.insertHeadlinesByCategory(newRecord.Id, newRecord.Name);
            News_Category__c recordToUpdate = new News_Category__c();
            recordToUpdate.Id = newRecord.Id;
            recordToUpdate.Sync__c = false;
            recordToUpdate.Last_Synced__c = System.now();
            recordsToUpdate.add(recordToUpdate);
        } 
        if (!recordsToUpdate.isEmpty()) {
            update recordsToUpdate;
        }

    }
    
    /**
     * Future method to sync categories using the NewsAPI
     * Used for insert operations
     * @param categoryNames List of category names to sync
     */
    @future(callout=true)
    public static void syncCategoriesWithFuture(List<String> categoryNames) {
        // TODO: Implement future method
        // - Get categories by name
        // - Make callouts to NewsAPI for each category
        // - Insert retrieved articles
        // - Update categories with last synced date
    }
    
    /**
     * Queueable method to sync categories using the NewsAPI
     * Used for update operations
     * @param categoriesToSync List of News_Category__c records to sync
     */
    private static void syncCategoriesWithQueueable(List<News_Category__c> categoriesToSync) {
        // TODO: Implement queueable job enqueuing
        // - Determine pages to sync for each category
        // - Create and enqueue NewsCategoryQueueable job for each category
    }
    
} 