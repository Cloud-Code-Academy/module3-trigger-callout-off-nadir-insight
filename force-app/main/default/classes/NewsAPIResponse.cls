/**
 * Wrapper class for parsing the NewsAPI response
 */
public class NewsAPIResponse {
    // TODO: Define fields to match the NewsAPI response structure
    public String status { get; set; }
    public Integer totalResults { get; set; }
    public List<Article> articles { get; set; }
    
    /**
     * Inner class representing a news article
     */
    public class Article {
        // TODO: Define article fields
        public Source source;
        public String author;
        public String title;
        public String description;
        public String url;
        public String urlToImage;
        public String publishedAt;
        public String content;
        
        /**
         * Converts the API article to a Salesforce Article__c record
         * @return Article__c The Salesforce record
         */
        public Article__c toSObject() {
            // TODO: Implement conversion from API article to Salesforce record
            Article__c sfArticle = new Article__c();
            sfArticle.Author__c = this.author;
            sfArticle.Category__c = null;
            sfArticle.Content__c = this.content.left(131072);
            sfArticle.Country__c = null;
            sfArticle.Description__c = this.description.left(32768);
            sfArticle.News_Category__c = null;
            sfArticle.Published_At__c = (DateTime) JSON.deserialize('\"' + this.publishedAt + '\"', Datetime.class);
            sfArticle.Source__c = this.source.name;
            sfArticle.Title__c = this.title.left(255);
            sfArticle.url__c = this.url.left(255);
            sfArticle.urlToImage__c = this.urlToImage.left(255);
            sfArticle.Name = String.valueOf(sfArticle.Published_At__c) + sfArticle.Title__c.left(232); // 255 string length - date time char length
            
            return sfArticle;
        }
    }
    
    /**
     * Inner class representing a news source
     */
    public class Source {
        public String id;
        public String name;
    }
    
    /**
     * Helper method to convert all articles in this response to Salesforce records
     * @return List<Article__c> List of Salesforce records
     */
    public List<Article__c> toSObjects() {
        List<Article__c> sfArticles = new List<Article__c>();
        for (Article article : this.articles) {
            sfArticles.add(article.toSObject());
        }
        return sfArticles;
    }
} 