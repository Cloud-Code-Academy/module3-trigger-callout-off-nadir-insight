/**
 * Service class to interact with the NewsAPI for fetching top headlines
 */
public with sharing class NewsAPIService {
    // TODO: Define API endpoint constants
    private static final String API_NAMED_CREDENTIAL = 'callout:NewsAPI'; //https://newsapi.org
    private static final String API_ENDPOINT = '/v2/top-headlines';
    
    // TODO: Define default parameters
    private static final Integer DEFAULT_PAGE_SIZE = 20; 
    
    @future(callout=true)
    public static void insertHeadlinesByCategory(String categoryId, String category) {
        HttpRequest request = new HttpRequest();
        request.setMethod('GET');
        request.setEndpoint(API_NAMED_CREDENTIAL + API_ENDPOINT + '/?category=' + category + '&pageSize=' + DEFAULT_PAGE_SIZE + '&page=1');
        Http http = new Http();
        HttpResponse response = http.send(request);

        NewsAPIResponse newsApiResponse = (NewsAPIResponse) JSON.deserialize(response.getBody(), NewsAPIResponse.class);

        insert newsApiResponse.toSObjects(categoryId, category);
    }

    /**
     * Fetches top headlines for a specified category with pagination support
     * @param category The news category (business, entertainment, general, health, science, sports, technology)
     * @param pageSize Number of results per page (default: 20, max: 100)
     * @param page Page number for pagination
     * @return NewsAPIResponse The wrapper object containing the API response
     */
    public static NewsAPIResponse getTopHeadlinesByCategory(String category, Integer pageSize, Integer page) {
        String urlPageSize = pageSize > 0 && pageSize <= 100 ? String.valueOf(pageSize) : '20';
        String urlPage = page > 0 ? String.valueOf(page) : '1';

        String urlEndpoint = constructEndpoint(category, String.valueOf(pageSize), String.valueOf(page));
        HttpResponse response = makeCallout(urlEndpoint);
        try {
            return parseResponse(response.getBody());
        } catch (Exception e) {
            throw new NewsAPIException('NewsAPIResponse error: ' + e.getMessage());
        }
    }
    
    /**
     * Helper method to make the HTTP callout
     * @param endpoint The full URL with parameters
     * @return HttpResponse The HTTP response
     */
    private static HttpResponse makeCallout(String endpoint) {
        HttpRequest request = new HttpRequest();
        request.setMethod('GET');
        request.setEndpoint(endpoint);
        Http http = new Http();
        
        try {
            HttpResponse response = http.send(request);
            if (response.getStatusCode() < 200 || response.getStatusCode() >= 300) {
                throw new CalloutException('Error status code: ' + response.getStatus());
            }
            return response;
        } catch (Exception e) {
            throw new CalloutException('Callout exception: ' + e.getMessage());
        }
    }

    private static String constructEndpoint(String category, String pageSize, String page) {
        return API_NAMED_CREDENTIAL + API_ENDPOINT + '/?category=' + category + '&pageSize=' + pageSize + '&page=' + page;
    }
    
    /**
     * Helper method to parse the JSON response
     * @param jsonResponse The JSON response string
     * @return NewsAPIResponse The parsed response object
     */
    private static NewsAPIResponse parseResponse(String jsonResponseBody) {
        try {
            return (NewsAPIResponse) JSON.deserialize(jsonResponseBody, NewsAPIResponse.class);    
        } catch (Exception e) {
            throw new JsonParsingException('JSON parsing error: ' + e.getMessage());
        }
        
    }
    
    /**
     * Custom exception class for NewsAPI errors
     */
    public class NewsAPIException extends Exception {}
    public class JsonParsingException extends Exception {}
    public class CalloutException extends Exception {}
} 