/**
 * Service class to interact with the NewsAPI for fetching top headlines
 */
public with sharing class NewsAPIService {
    // TODO: Define API endpoint constants
    private static final String API_NAMED_CREDENTIAL = 'callout:NewsAPI'; //https://newsapi.org
    private static final String API_ENDPOINT = '/v2/top-headlines';
    
    // TODO: Define default parameters
    private static final Integer PAGE_SIZE = 20; 
    private static final List<String> validNewsCategories = new List<String>{'business', 'entertainment', 'general', 'health', 'science', 'sports', 'technology'};
    
    /**
     * Fetches top headlines for a specified category with pagination support
     * @param category The news category (business, entertainment, general, health, science, sports, technology)
     * @param page Page number for pagination
     * @return NewsAPIResponse The wrapper object containing the API response
     */
    public static NewsAPIResponse getTopHeadlinesByCategory(String category, Integer page) {
        String urlCategory = validNewsCategories.contains(category.toLowerCase()) ? category : 'general';
        String urlPage = page > 0 ? String.valueOf(page) : '1';
        String requestUrl = buildRequestUrl(urlCategory, urlPage);
        HttpResponse response = makeCallout(requestUrl);
        
        return parseResponse(response.getBody());
    }

    /**
     * Helper method to generate URL request string
     * @param category The news category (business, entertainment, general, health, science, sports, technology)
     * @param page Page number for pagination
     * @return String url for callout
     */
    private static String buildRequestUrl(String category, String page) {
        return API_NAMED_CREDENTIAL + API_ENDPOINT + '/?category=' + category + '&pageSize=' + String.valueOf(PAGE_SIZE) + '&page=' + page;
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
        request.setMethod('GET');
        request.setEndpoint(endpoint);
        Http http = new Http();
        try {
            HttpResponse response = http.send(request);
            if (response.getStatusCode() != 200) {
                throw new NewsAPIException('Received non-200 response: ' + response.getStatus());
            }
            return response;
        } catch (Exception e) {
            System.debug('Error: ' + e.getMessage());
            return null;
        }
    }
    
    /**
     * Helper method to parse the JSON response
     * @param jsonResponse The JSON response string
     * @return NewsAPIResponse The parsed response object
     */
    private static NewsAPIResponse parseResponse(String jsonResponse) {
        // TODO: Implement JSON parsing
        // - Handle exceptions
        
        return (NewsAPIResponse) JSON.deserialize(jsonResponse, NewsAPIResponse.class);
    }
    
    /**
     * Custom exception class for NewsAPI errors
     */
    public class NewsAPIException extends Exception {}
}