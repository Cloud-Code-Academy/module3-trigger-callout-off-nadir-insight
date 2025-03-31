/**
 * Wrapper class for parsing the NewsAPI response
 */
public class NewsAPIResponse {
    public String status { get; set; }
    public Integer totalResults { get; set; }
    public List<Article> articles { get; set; }
    
    /**
     * Inner class representing a news article
     */
    public class Article {
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
        public Article__c toSObject(Article articleToConvert) {
            // TODO: Implement conversion from API article to Salesforce record
            // Consider:
            // - Generating a unique record name
            // - Handling field length limits
            Article__c sArticle = new Article__c();
            sArticle.Author__c = articleToConvert.author;
            sArticle.Content__c = articleToConvert.content;
            sArticle.Description__c = articleToConvert.description;
            sArticle.Published_At__c = (DateTime)JSON.deserialize('\"' + articleToConvert
            .publishedAt + '\"', Datetime.class);
            sArticle.Source__c = articleToConvert.source.name;
            sArticle.Title__c = articleToConvert.title;
            sArticle.url__c = articleToConvert.url;
            sArticle.urlToImage__c = articleToConvert.urlToImage;
            return sArticle;
        }
        public Article parse(String jsonText) {
            return (Article) JSON.deserialize(jsonText, Article.class);
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
        // TODO: Implement conversion of all articles to Salesforce records
        return null;
    }
} 