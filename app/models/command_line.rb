require 'rest-client'
require 'json'
require 'pry'

class CLI 
    #displays welcome message
    def initialize
        welcome
    end

    def welcome
        puts "Hello!"
    end
    
    # response = RestClient.get("https://developers.zomato.com/api/v2.1/search?", {"user-key" => "2b9423ad30cd3b08e5762a65bc190392"})
    # parsed_response = JSON.parse(response)

    # binding.pry
end

def search_restaurants
    response = RestClient.get("https://developers.zomato.com/api/v2.1/search?q=san+francisco", {"user-key" => "9ea9e2da9ab249f74af457520ac97290"})
    parsed_response = JSON.parse(response)
end
   

    def find_by_zipcode(zipcode)
        
        @restaurants_by_zip = []
        search_restaurants["restaurants"].select do |api_hash|
            restaurant = api_hash["restaurant"]
            restaurant_zipcode = api_hash["restaurant"]["location"]["zipcode"]
                if restaurant_zipcode == zipcode
                    a_restaurant = {
                        name: restaurant["name"],
                        cuisine: restaurant["cuisines"],
                        location: restaurant["location"]
                    }
                    
                    
                    
                    @restaurants_by_zip << a_restaurant
                end
                
                     
    
        end
        @restaurants_by_zip
        binding.pry
    end

#displays welcome message
#menu page for user
#obtains user input from menu page
#exits the app
#reroutes user back to menu
#loads the parsed_response <-- searching through the API
#creates an array of all restaurants
#def method that searches for restaurants in a given zipcode 
#search for highest rated restaurants
#random restaurant suggestion in given zipcode 