
class CLI 
    #displays welcome message
    def welcome
        puts Rainbow("
                ,-\"-. 
              _r-----i \"        _
              \\      |-.      ,***. 
               |     | |    ,-------. 
               |     | |   c|       |                       ,--. 
               |     |'     |       |      _______________ C|  | 
               (=====)      =========      \\_____________/  `=='   dla 
             (HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH) 
        ").magenta
    end

end

API_KEY = "V8luDogdQ0cBLfJHPmm_sE1GEWqh1Zt4VJwBPzY_8oQKYByfmoJnjEemi0uC1x_4ZysZYHj9qMfceed5Avt5-QnIq3h7CE1N1ThEIG4EhKskNhNZj1d9mhxTRXULXnYx"
# Constants, do not change these
    API_HOST = "https://api.yelp.com"
    SEARCH_PATH = "/v3/businesses/search"
    BUSINESS_PATH = "/v3/businesses/"  # trailing / because we append the business id to the path
    DEFAULT_BUSINESS_ID = "yelp-san-francisco"
    DEFAULT_TERM = "restaurant"
    DEFAULT_LOCATION = "San Francisco, CA"
    SEARCH_LIMIT = 20

def search(term, location)
  url = "#{API_HOST}#{SEARCH_PATH}"
  params = {
    term: term,
    location: location,
    limit: SEARCH_LIMIT
  }
  response = HTTP.auth("Bearer #{API_KEY}").get(url, params: params)
  response.parse
end

def search_restaurants
    all_restaurants = search(DEFAULT_TERM, DEFAULT_LOCATION)
end
   
def restaurant_names
    @all_restaurants =[]
    search_restaurants["businesses"].select do |element|
        element.each do |k,v|
            if k == "name"
                
                @all_restaurants << v

            end
        end
    end
    @all_restaurants
end


#displays welcome message
#menu page for user
#obtains user input from menu page
#exits the app
#reroutes user back to menu
#def method that searches for restaurants in a given zipcode 
#search for highest rated restaurants
#random restaurant suggestion in given zipcode 