/**
 * Queueable Apex class for processing News Category records with pagination support
 */
public class NewsCategoryQueueable implements Queueable, Database.AllowsCallouts {
    // Static variable for maximum pages to fetch
    private static final Integer MAX_PAGES = 3;
    
    private News_Category__c category;
    private Integer currentPage;
    
    /**
     * Constructor
     * @param category The News_Category__c record
     * @param currentPage Current page to process
     */
    public NewsCategoryQueueable(News_Category__c category, Integer currentPage) {
        this.category = category;
        this.currentPage = currentPage;
    }
    
    /**
     * Execute method for the queueable job
     * @param context The QueueableContext
     */
    public void execute(QueueableContext context) {
        // IMPORTANT: Create a separate instance of the category for updates

        News_Category__c updatedCategory = new News_Category__c(Id = category.Id);

        try {
            // TODO: Implement execute method
            // - Call NewsAPI for the current page
            NewsAPIResponse apiResponse = NewsAPIService.getTopHeadlinesByCategory(this.category.Name, this.currentPage);
            // - Convert API articles to Salesforce articles using NewsAPIResponse.convertToSObject

            List<Article__c> sfArticles = new List<Article__c>();
            for (NewsAPIResponse.Article jsonArticle : apiResponse.articles) {
                Article__c sfArticle = NewsAPIResponse.convertToSObject(jsonArticle);
                sfArticles.add(sfArticle);
            }
            // - Add category reference to each article
            if (!sfArticles.isEmpty()) {
                for (Article__c sfArticle : sfArticles) {
                    sfArticle.News_Category__c = this.category.Id;
                    sfArticle.Category__c = this.category.Name;
                }
                // upsert sfArticles Name;
                insert sfArticles;
            }

            if (this.currentPage < MAX_PAGES && !Test.isRunningTest()) {
                // - Enqueue the job again for the next page
                System.enqueueJob(new NewsCategoryQueueable(this.category, this.currentPage + 1));
            } else {
                // News_Category__c categoryToUpdate = new News_Category__c();
                // categoryToUpdate.Id = this.category.Id;
                // categoryToUpdate.Sync__c = false;
                // categoryToUpdate.Last_Synced__c = System.now();
                // update categoryToUpdate;
            }

            updatedCategory.Sync__c = false;
            updatedCategory.Last_Synced__c = System.now();
            update updatedCategory;


            // update categoryToUpdate;
            // - Insert the articles
            // - Check if reached MAX_PAGES or no more articles
            // HINT: When requeuing the job check if tests are running
            // - Update category with last synced date and sync flag = false
        } catch (Exception e) {
            // TODO: Handle errors
            // - Update category with error information
            // - Log error to debug logs
            System.debug('Error: ' + e.getMessage());
        }
    }
} 