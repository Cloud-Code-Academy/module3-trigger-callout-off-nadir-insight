/**
 * Service class to interact with the NewsAPI for fetching top headlines
 */
public with sharing class NewsAPIService {
    // TODO: Define API endpoint constants
    private static final String API_NAMED_CREDENTIAL = 'callout:NewsAPI'; //https://newsapi.org
    private static final String API_ENDPOINT = '/v2/top-headlines';
    
    // TODO: Define default parameters
    private static final Integer DEFAULT_PAGE_SIZE = 20; 
    
    /**
     * Fetches top headlines for a specified category with pagination support
     * @param category The news category (business, entertainment, general, health, science, sports, technology)
     * @param pageSize Number of results per page (default: 20, max: 100)
     * @param page Page number for pagination
     * @return NewsAPIResponse The wrapper object containing the API response
     */
    public static NewsAPIResponse getTopHeadlinesByCategory(String category, Integer pageSize, Integer page) {
        // TODO: Implement method to fetch headlines by category
        // - Validate and set defaults for parameters
        // - Build the request URL
        // - Make the callout
        // - Parse and return the response
        List<String> newsTopics = new List<String>{'business', 'entertainment', 'general', 'health', 'science', 'sports', 'technology'};

        String searchCategory = newsTopics.contains(category) ? category : 'general';

        String endpoint = 'callout:NewsApi_NC/top-headlines?' + 'category=' + searchCategory;
        HttpResponse response = makeCallout(endpoint);
        
        return null;
    }
    
    /**
     * Helper method to make the HTTP callout
     * @param endpoint The full URL with parameters
     * @return HttpResponse The HTTP response
     */
    private static HttpResponse makeCallout(String endpoint) {
        // TODO: Implement HTTP callout
        // - Create and configure HTTP request
        // - Make the callout
        // - Handle exceptions
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod('GET');
        Http http = new Http();
        HttpResponse response = http.send(request);
        NewsAPIResponse newsResponse = parseResponse(response.getBody());
        return newsResponse;
    }
    
    /**
     * Helper method to parse the JSON response
     * @param jsonResponse The JSON response string
     * @return NewsAPIResponse The parsed response object
     */
    private static NewsAPIResponse parseResponse(String jsonResponse) {
        // TODO: Implement JSON parsing
        // - Deserialize JSON to NewsAPIResponse
        // - Handle exceptions
        
        return null;
    }
    
    /**
     * Custom exception class for NewsAPI errors
     */
    public class NewsAPIException extends Exception {}
} 