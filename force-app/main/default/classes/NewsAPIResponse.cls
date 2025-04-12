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
        public Source source { get; set; }
        public String author { get; set; }
        public String title { get; set; }
        public String description { get; set; }
        public String url { get; set; }
        public String urlToImage { get; set; }
        public String publishedAt { get; set; }
        public String content { get; set; }
    }
    
    /**
     * Inner class representing a news source
     */
    public class Source {
        public String id { get; set; }
        public String name { get; set; }
    }
    
    /**
     * Static method to convert an API article to a Salesforce Article__c record
     * @param apiArticle The API article to convert
     * @return Article__c The Salesforce record
     */
    public static Article__c convertToSObject(Article apiArticle) {
        Article__c sfArticle = new Article__c();
        sfArticle.Author__c = apiArticle.author;
        sfArticle.Content__c = apiArticle.content == null ? null : apiArticle.content.left(131072);
        sfArticle.Country__c = null;
        sfArticle.Description__c = apiArticle.description.left(32768);
        sfArticle.Published_At__c = (DateTime) JSON.deserialize('\"' + apiArticle.publishedAt + '\"', Datetime.class);
        sfArticle.Source__c = apiArticle.source.name;
        sfArticle.Title__c = apiArticle.title.left(255);
        sfArticle.url__c = apiArticle.url.left(255);
        sfArticle.urlToImage__c = apiArticle.urlToImage.left(255);
        sfArticle.Name = String.valueOf(sfArticle.Published_At__c) + sfArticle.Title__c.left(232); // 255 string length - date time char length

        // assigning category variables to article
        // sfArticle.News_Category__c = categoryId;
        // sfArticle.Category__c = category;
        
        return sfArticle;
    }
} 